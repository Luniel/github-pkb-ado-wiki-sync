#!/usr/bin/env python3
"""Protected one-way manuscript publishing sync."""
from __future__ import annotations
import argparse, datetime as dt, hashlib, json, os, re, shutil, stat, sys, tempfile
from pathlib import Path

EXIT_OK=0; EXIT_VALIDATION=2; EXIT_BLOCKED=3; EXIT_MUTATION=4
MARKER='.protected-manuscript-publishing-target'; STATE_SCHEMA=1; CONFIG_SCHEMA=1
SAFE_ID=re.compile(r'^[A-Za-z0-9][A-Za-z0-9._-]*$'); SHA_RE=re.compile(r'^[0-9a-f]{64}$')

class SyncError(Exception):
    code=EXIT_VALIDATION
    def __init__(self,msg,code=None): super().__init__(msg); self.code=self.code if code is None else code
class Blocked(SyncError): code=EXIT_BLOCKED
class MutationFailure(SyncError): code=EXIT_MUTATION

def lex_abs(p): return os.path.abspath(os.path.normpath(os.fspath(p)))
def canonical(p): return os.path.abspath(os.path.realpath(os.fspath(p)))
def safe_key(p): return os.path.normcase(canonical(p))
def inside(child,parent):
    c=safe_key(child); p=safe_key(parent).rstrip(os.sep)
    return c==p or c.startswith(p+os.sep)
def validate_rel(r):
    if not isinstance(r,str) or r in ('','.','..') or r.startswith('../') or r.startswith('/') or '\\' in r:
        raise SyncError(f'Unsafe relative path: {r}')
    if any(part in ('','.','..') for part in r.split('/')): raise SyncError(f'Unsafe relative path: {r}')
def rel_slash(path, root):
    r=os.path.relpath(path, root).replace(os.sep,'/'); validate_rel(r); return r

def is_reparse(st): return bool(getattr(st,'st_file_attributes',0) & getattr(stat,'FILE_ATTRIBUTE_REPARSE_POINT',0x400))
def reject_link_reparse(p, what):
    st=os.lstat(p)
    if stat.S_ISLNK(st.st_mode): raise SyncError(f'{what} is a symlink: {p}')
    if is_reparse(st): raise SyncError(f'{what} is a reparse point: {p}')
    return st
def inspect_existing_components(path, what='Path'):
    p=Path(lex_abs(path)); chain=[]
    while True:
        chain.append(p)
        if p.parent==p: break
        p=p.parent
    for part in reversed(chain):
        if part.exists() or os.path.lexists(part): reject_link_reparse(str(part), what)
def inspect_existing_path(path, what):
    inspect_existing_components(path, what)
    return reject_link_reparse(lex_abs(path), what)

def sha_file(p):
    h=hashlib.sha256(); n=0
    with open(p,'rb') as f:
        for b in iter(lambda:f.read(1024*1024),b''):
            h.update(b); n+=len(b)
    return h.hexdigest(), n

def snapshot(root):
    root=lex_abs(root); files={}; dirs=[]
    if not os.path.exists(root): return {'files':{}, 'empty_dirs':[]}
    st=inspect_existing_path(root,'Manuscript root')
    if not stat.S_ISDIR(st.st_mode): raise SyncError(f'Manuscript path is not a directory: {root}')
    def walk(d):
        st=reject_link_reparse(d,'Manuscript entry')
        if not stat.S_ISDIR(st.st_mode): raise SyncError(f'Manuscript entry is not a directory: {d}')
        entries=[]
        with os.scandir(d) as it:
            for e in it: entries.append(e)
        has_file=False; child_dirs=[]
        for e in sorted(entries, key=lambda x:x.name.lower()):
            p=e.path; st=e.stat(follow_symlinks=False)
            if stat.S_ISLNK(st.st_mode) or is_reparse(st): raise SyncError(f'Unsupported link or reparse point in manuscript: {p}')
            if e.name=='.git': raise SyncError(f'Nested .git entry is not allowed in manuscript: {p}')
            if stat.S_ISDIR(st.st_mode): child_dirs.append(p); walk(p)
            elif stat.S_ISREG(st.st_mode):
                has_file=True; rp=rel_slash(p,root); digest,size=sha_file(p); files[rp]={'sha256':digest,'bytes':size}
            else: raise SyncError(f'Unsupported non-regular manuscript entry: {p}')
        if d!=root and not has_file and not child_dirs: dirs.append(rel_slash(d,root))
    walk(root)
    return {'files':dict(sorted(files.items())), 'empty_dirs':sorted(dirs)}

def same(a,b): return a==b
def path_kind(snapshot_value, path):
    if path in snapshot_value['files']: return 'file'
    if path in snapshot_value.get('empty_dirs',[]): return 'dir'
    return None
def counts(a,b):
    ak=set(a['files'])|set(a.get('empty_dirs',[])); bk=set(b['files'])|set(b.get('empty_dirs',[]))
    added=len(ak-bk); deleted=len(bk-ak); modified=0; unchanged=0
    for p in ak & bk:
        akind=path_kind(a,p); bkind=path_kind(b,p)
        if akind!=bkind: modified+=1
        elif akind=='file' and a['files'][p]!=b['files'][p]: modified+=1
        else: unchanged+=1
    return added, modified, deleted, unchanged

def load_json_file(path, label):
    inspect_existing_components(path, label)
    try:
        with open(lex_abs(path),encoding='utf-8-sig') as f: return json.load(f)
    except UnicodeDecodeError as e: raise SyncError(f'{label} is not valid UTF-8: {e}')
    except json.JSONDecodeError as e: raise SyncError(f'{label} is not valid JSON: {e}')
    except OSError as e: raise SyncError(f'Cannot read {label}: {e}')

def load_config(path):
    cp=lex_abs(path); data=load_json_file(cp,'config') ; base=os.path.dirname(cp)
    if not isinstance(data,dict): raise SyncError('Config must be a JSON object')
    if data.get('schema_version')!=CONFIG_SCHEMA: raise SyncError('schema_version must equal 1')
    for k in ('source_repo_path','publishing_repo_path','expected_target_id'):
        if not isinstance(data.get(k),str) or not data.get(k): raise SyncError(f'Missing required config value: {k}')
    tid=data['expected_target_id']
    if not SAFE_ID.match(tid): raise SyncError('expected_target_id must be a non-empty safe identifier')
    def res(v): return lex_abs(v if os.path.isabs(v) else os.path.join(base,v))
    sf=data.get('state_file') or (os.path.basename(cp)+'.state.json')
    if not isinstance(sf,str) or not sf: raise SyncError('state_file must be a string when provided')
    src=res(data['source_repo_path']); tgt=res(data['publishing_repo_path'])
    # Inspect originals before canonicalizing/storing identity paths.
    inspect_existing_components(src,'source repository path')
    inspect_existing_components(tgt,'publishing repository path')
    return {'config_path':cp,'source_repo_path':canonical(src),'publishing_repo_path':canonical(tgt),'source_repo_lexical':src,'publishing_repo_lexical':tgt,'expected_target_id':tid,'state_file':res(sf)}

def validate_env(c):
    src_lex,tgt_lex=c['source_repo_lexical'],c['publishing_repo_lexical']
    for p,n in ((src_lex,'source repository'),(tgt_lex,'publishing repository')):
        if not os.path.isdir(p): raise SyncError(f'Missing {n}: {p}')
        st=inspect_existing_path(p,n)
        if not stat.S_ISDIR(st.st_mode): raise SyncError(f'{n} is not a directory: {p}')
        gp=os.path.join(p,'.git')
        if not os.path.exists(gp) and not os.path.lexists(gp): raise SyncError(f'{n} does not contain .git: {p}')
        gst=inspect_existing_path(gp,f'{n} .git')
        if not (stat.S_ISDIR(gst.st_mode) or stat.S_ISREG(gst.st_mode)): raise SyncError(f'{n} .git must be a file or directory: {gp}')
    if safe_key(src_lex)==safe_key(tgt_lex) or inside(src_lex,tgt_lex) or inside(tgt_lex,src_lex): raise SyncError('Source and publishing repository roots must be distinct and non-overlapping')
    sm=os.path.join(src_lex,'manuscript'); tm=os.path.join(tgt_lex,'manuscript')
    if not os.path.isdir(sm): raise SyncError(f'Missing source manuscript directory: {sm}')
    st=inspect_existing_path(sm,'source manuscript')
    if not stat.S_ISDIR(st.st_mode): raise SyncError(f'source manuscript is not a directory: {sm}')
    book=os.path.join(sm,'book.txt')
    if not os.path.isfile(book): raise SyncError(f'Missing regular source manuscript/book.txt: {book}')
    bst=inspect_existing_path(book,'source book.txt')
    if not stat.S_ISREG(bst.st_mode): raise SyncError(f'source manuscript/book.txt is not regular: {book}')
    if os.path.exists(tm) or os.path.lexists(tm):
        tst=inspect_existing_path(tm,'target manuscript')
        if not stat.S_ISDIR(tst.st_mode): raise SyncError(f'Target manuscript path is not a directory: {tm}')
    sf=c['state_file']; state_parent=os.path.dirname(sf); inspect_existing_components(state_parent,'state-file parent')
    if os.path.exists(state_parent) or os.path.lexists(state_parent):
        pst=inspect_existing_path(state_parent,'state-file parent')
        if not stat.S_ISDIR(pst.st_mode): raise SyncError(f'State-file parent is not a directory: {state_parent}')
    if os.path.exists(sf) or os.path.lexists(sf): inspect_existing_path(sf,'state file')
    if inside(sf,src_lex) or inside(sf,tgt_lex): raise SyncError('State file must not be inside either repository')
    marker=os.path.join(tgt_lex,MARKER)
    if not os.path.isfile(marker): raise SyncError(f'Missing publishing target marker: {marker}')
    mst=inspect_existing_path(marker,'target marker')
    if not stat.S_ISREG(mst.st_mode): raise SyncError(f'Target marker is not a regular file: {marker}')
    try:
        with open(marker,'r',encoding='utf-8-sig') as f: raw=f.read()
    except UnicodeDecodeError as e: raise SyncError(f'Target marker is not valid UTF-8: {e}')
    except OSError as e: raise SyncError(f'Cannot read target marker: {e}')
    text=raw.strip()
    if not text or '\x00' in raw: raise SyncError('Malformed target marker')
    if text!=c['expected_target_id']: raise SyncError(f'Target marker mismatch: expected {c["expected_target_id"]}, found {text}')
    return sm,tm

def normalized_path_key(path):
    return os.path.normcase(path).replace('\\','/')
def has_ancestor(path, possible_ancestor):
    return path.startswith(possible_ancestor.rstrip('/') + '/')
def validate_no_structural_collisions(files, dirs):
    entries=[]; seen={}
    for p in files: entries.append((p,'file'))
    for p in dirs: entries.append((p,'dir'))
    for p,kind in entries:
        key=normalized_path_key(p)
        if key in seen: raise SyncError('Duplicate or conflicting normalized path in state snapshot')
        seen[key]=kind
    keys=sorted(seen)
    for i,a in enumerate(keys):
        for b in keys[i+1:]:
            if has_ancestor(b,a): raise SyncError('State snapshot contains an impossible ancestor path relationship')
def validate_snapshot_schema(snap):
    if not isinstance(snap,dict) or set(snap.keys())!={'files','empty_dirs'}: raise SyncError('Malformed state snapshot')
    files=snap.get('files'); dirs=snap.get('empty_dirs')
    if not isinstance(files,dict): raise SyncError('State snapshot files must be an object')
    if not isinstance(dirs,list): raise SyncError('State snapshot empty_dirs must be an array')
    seen_dirs=set()
    for d in dirs:
        validate_rel(d)
        if normalized_path_key(d) in seen_dirs: raise SyncError('Duplicate empty directory path in state')
        seen_dirs.add(normalized_path_key(d))
    for p,meta in files.items():
        validate_rel(p)
        if normalized_path_key(p) in seen_dirs: raise SyncError('State path cannot be both file and empty directory')
        if not isinstance(meta,dict) or set(meta.keys())!={'sha256','bytes'}: raise SyncError('Malformed state file metadata')
        if not isinstance(meta.get('sha256'),str) or not SHA_RE.match(meta['sha256']): raise SyncError('Malformed state sha256')
        b=meta.get('bytes')
        if not isinstance(b,int) or isinstance(b,bool) or b<0: raise SyncError('Malformed state byte count')
    validate_no_structural_collisions(files.keys(), dirs)
    return {'files':dict(sorted(files.items())), 'empty_dirs':sorted(dirs)}

def parse_timestamp(value):
    if not isinstance(value,str) or not value.endswith('Z'): raise SyncError('Malformed state accepted_utc')
    try: dt.datetime.fromisoformat(value[:-1]+'+00:00')
    except ValueError as e: raise SyncError(f'Malformed state accepted_utc: {e}')

def load_state(c):
    sf=c['state_file']
    if not os.path.exists(sf): return None
    s=load_json_file(sf,'state')
    if not isinstance(s,dict): raise SyncError('State must be a JSON object')
    if set(s.keys())!={'schema_version','source_repo_path','publishing_repo_path','expected_target_id','accepted_utc','accepted_snapshot'}: raise SyncError('Malformed state structure')
    if s.get('schema_version')!=STATE_SCHEMA: raise SyncError('Unsupported state schema version')
    for k in ('source_repo_path','publishing_repo_path','expected_target_id'):
        if not isinstance(s.get(k),str) or not s.get(k): raise SyncError(f'Malformed state identity field: {k}')
    if s['source_repo_path']!=c['source_repo_path'] or s['publishing_repo_path']!=c['publishing_repo_path'] or s['expected_target_id']!=c['expected_target_id']:
        raise SyncError('State identity does not match active config')
    parse_timestamp(s['accepted_utc'])
    s['accepted_snapshot']=validate_snapshot_schema(s['accepted_snapshot'])
    return s

def classify(S,T,state):
    if state is None:
        if not T['files'] and not T['empty_dirs']: return 'initial-empty-target', True, 'safe initial publish', None
        if same(S,T): return 'initial-identical-target', True, 'safe baseline initialization', None
        return 'blocked-initial-differing-target', False, 'blocked', 'Initial target is non-empty and differs from source; manual reconciliation required'
    B=state['accepted_snapshot']
    if same(S,B) and same(T,B): return 'in-sync', True, 'publish unnecessary', None
    if not same(S,B) and same(T,B): return 'source-only-changes', True, 'safe to mirror source to target', None
    if same(S,B) and not same(T,B): return 'blocked-target-only-divergence', False, 'blocked', 'Target-only divergence blocked'
    if not same(S,B) and not same(T,B) and same(S,T): return 'already-reconciled-identically', True, 'safe baseline refresh', None
    if not same(S,B) and not same(T,B) and not same(S,T): return 'blocked-conflicting-divergence', False, 'blocked', 'Conflicting source and target divergence blocked'
    return 'blocked-unclassifiable-divergence', False, 'blocked', 'Unclassifiable divergence blocked'

def copy_tree(src,dst):
    if os.path.exists(dst): shutil.rmtree(dst)
    shutil.copytree(src,dst,symlinks=False)

def remove_tree(path):
    if os.path.exists(path) or os.path.lexists(path): shutil.rmtree(path)

def ensure_real_directory(path, label):
    if os.path.exists(path) or os.path.lexists(path):
        st=inspect_existing_path(path,label)
        if not stat.S_ISDIR(st.st_mode): raise SyncError(f'{label} is not a directory: {path}')
    else:
        inspect_existing_components(os.path.dirname(path), label + ' parent')
        os.makedirs(path, exist_ok=True)
        st=inspect_existing_path(path,label)
        if not stat.S_ISDIR(st.st_mode): raise SyncError(f'{label} is not a directory: {path}')
def prepare_transaction_parent(c):
    state_parent=os.path.dirname(c['state_file'])
    ensure_real_directory(state_parent,'state-file parent')
    work_parent=lex_abs(os.path.join(state_parent,'.protected-manuscript-sync-work'))
    created=not (os.path.exists(work_parent) or os.path.lexists(work_parent))
    ensure_real_directory(work_parent,'transaction work parent')
    if inside(work_parent,c['source_repo_lexical']) or inside(work_parent,c['publishing_repo_lexical']):
        raise SyncError('Transaction work parent must be outside source and publishing repositories')
    return work_parent, created

def write_state(c,S):
    data={'schema_version':STATE_SCHEMA,'source_repo_path':c['source_repo_path'],'publishing_repo_path':c['publishing_repo_path'],'expected_target_id':c['expected_target_id'],'accepted_utc':dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace('+00:00','Z'),'accepted_snapshot':S}
    os.makedirs(os.path.dirname(c['state_file']),exist_ok=True)
    fd,tmp=tempfile.mkstemp(prefix='.tmp-state-',dir=os.path.dirname(c['state_file']),text=True)
    try:
        with os.fdopen(fd,'w',encoding='utf-8',newline='\n') as f: json.dump(data,f,indent=2,sort_keys=True); f.write('\n')
        os.replace(tmp,c['state_file'])
    finally:
        if os.path.exists(tmp): os.unlink(tmp)

def restore_target(tm, existed, rollback, before):
    if os.path.exists(tm) or os.path.lexists(tm): shutil.rmtree(tm)
    if existed: shutil.copytree(rollback,tm)
    ok=(os.path.isdir(tm) and snapshot(tm)==before) if existed else not (os.path.exists(tm) or os.path.lexists(tm))
    if not ok: raise MutationFailure('rollback verification failed')

def publish(c,sm,tm,S,T,cl):
    target_existed=os.path.isdir(tm); before=snapshot(tm); work_parent,parent_created=prepare_transaction_parent(c)
    tmpbase=tempfile.mkdtemp(prefix='protected-manuscript-sync-', dir=work_parent)
    if inside(tmpbase,c['source_repo_lexical']) or inside(tmpbase,c['publishing_repo_lexical']):
        shutil.rmtree(tmpbase,ignore_errors=True)
        raise SyncError('Transaction directory must be outside source and publishing repositories')
    stage=os.path.join(tmpbase,'stage'); rollback=os.path.join(tmpbase,'rollback'); mutation_started=False
    try:
        copy_tree(sm,stage)
        if snapshot(stage)!=S: raise MutationFailure('Staged source copy verification failed')
        if target_existed:
            copy_tree(tm,rollback)
            if snapshot(rollback)!=before: raise MutationFailure('Rollback copy verification failed')
        if cl in ('initial-identical-target','in-sync','already-reconciled-identically'):
            write_state(c,S); return 'Publish completed; accepted baseline written.'
        mutation_started=True
        remove_tree(tm); shutil.copytree(stage,tm)
        if snapshot(tm)!=S: raise MutationFailure('Post-operation source/target equality verification failed')
        write_state(c,S)
        return 'Publish completed; accepted baseline written.'
    except Exception as e:
        if not mutation_started:
            if isinstance(e,SyncError): raise
            raise MutationFailure(f'Publish failed before target mutation; target left untouched: {e}')
        try: restore_target(tm,target_existed,rollback,before)
        except Exception as rb: raise MutationFailure(f'Publish failed: {e}; rollback failed: {rb}')
        raise MutationFailure(f'Publish failed: {e}; rollback verified')
    finally:
        shutil.rmtree(tmpbase,ignore_errors=True)
        if parent_created:
            try: os.rmdir(work_parent)
            except OSError: pass

def report(action,c,sm,tm,S,T,state,cl,msg,reason=None,mut=None):
    a,m,d,u=counts(S,T)
    assessment='blocked' if reason else msg
    lines=[f'Action: {action}',f'Source repository: {c["source_repo_path"]}',f'Publishing repository: {c["publishing_repo_path"]}',f'Source manuscript path: {sm}',f'Target manuscript path: {tm}',f'State-file path: {c["state_file"]}',f'Target marker result: valid ({c["expected_target_id"]})',f'Baseline: {"initialized" if state else "uninitialized"}',f'Classification: {cl}',f'Counts vs target: added={a}, modified={m}, deleted={d}, unchanged={u}',f'Publish assessment: {assessment}']
    if reason: lines.append(f'Blocking reason: {reason}')
    if mut: lines.append(f'Mutation result: {mut}')
    if action=='status' or reason: lines.append('No mutation performed.')
    return '\n'.join(lines)+'\n'

def run(action,config):
    c=load_config(config); sm,tm=validate_env(c); state=load_state(c); S=snapshot(sm); T=snapshot(tm)
    cl,safe,msg,reason=classify(S,T,state)
    if not safe:
        text=report(action,c,sm,tm,S,T,state,cl,msg,reason=reason)
        raise Blocked(text)
    mut=None
    if action=='publish': mut=publish(c,sm,tm,S,T,cl)
    return report(action,c,sm,tm,S,T,state,cl,msg,mut=mut)

def main(argv=None):
    p=argparse.ArgumentParser(description='Protected one-way manuscript publishing sync. Actions: status, publish.')
    p.add_argument('action',choices=['status','publish']); p.add_argument('--config',required=True)
    ns=p.parse_args(argv)
    try: sys.stdout.write(run(ns.action,ns.config)); return EXIT_OK
    except Blocked as e: sys.stderr.write(str(e)); return EXIT_BLOCKED
    except SyncError as e: sys.stderr.write(f'ERROR: {e}\n'); return e.code
    except Exception as e: sys.stderr.write(f'ERROR: unexpected failure: {e}\n'); return EXIT_MUTATION
if __name__=='__main__': sys.exit(main())
