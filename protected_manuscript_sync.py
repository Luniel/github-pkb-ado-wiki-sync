#!/usr/bin/env python3
"""Protected one-way manuscript publishing sync."""
from __future__ import annotations
import argparse, datetime as dt, hashlib, json, os, re, shutil, stat, sys, tempfile
from pathlib import Path

EXIT_OK=0; EXIT_VALIDATION=2; EXIT_BLOCKED=3; EXIT_MUTATION=4
MARKER='.protected-manuscript-publishing-target'; STATE_SCHEMA=1; CONFIG_SCHEMA=1
SAFE_ID=re.compile(r'^[A-Za-z0-9][A-Za-z0-9._-]*$')

class SyncError(Exception):
    code=EXIT_VALIDATION
    def __init__(self,msg,code=None): super().__init__(msg); self.code=self.code if code is None else code
class Blocked(SyncError):
    code=EXIT_BLOCKED
class MutationFailure(SyncError):
    code=EXIT_MUTATION

def norm(p): return os.path.abspath(os.path.realpath(os.fspath(p)))
def safe_key(p): return os.path.normcase(norm(p))
def inside(child,parent):
    c=safe_key(child); p=safe_key(parent)
    return c==p or c.startswith(p.rstrip(os.sep)+os.sep)
def rel_slash(path, root):
    r=os.path.relpath(path, root).replace(os.sep,'/')
    validate_rel(r); return r

def validate_rel(r):
    if r in ('','.','..') or r.startswith('../') or r.startswith('/') or '\\' in r: raise SyncError(f'Unsafe relative path: {r}')
    if any(part in ('','.','..') for part in r.split('/')): raise SyncError(f'Unsafe relative path: {r}')

def lstat_path(p):
    try: return os.lstat(p)
    except FileNotFoundError: raise

def is_reparse(st): return bool(getattr(st,'st_file_attributes',0) & getattr(stat,'FILE_ATTRIBUTE_REPARSE_POINT',0x400))
def reject_link_reparse(p, what):
    st=lstat_path(p)
    if stat.S_ISLNK(st.st_mode): raise SyncError(f'{what} is a symlink: {p}')
    if is_reparse(st): raise SyncError(f'{what} is a reparse point: {p}')
    return st

def check_components(p, stop=None):
    p=norm(p); stop=safe_key(stop) if stop else None
    cur=Path(p)
    parts=[]
    while True:
        parts.append(cur)
        if cur.parent==cur: break
        if stop and safe_key(cur)==stop: break
        cur=cur.parent
    for x in reversed(parts):
        if x.exists(): reject_link_reparse(str(x),'Path component')

def sha_file(p):
    h=hashlib.sha256(); n=0
    with open(p,'rb') as f:
        for b in iter(lambda:f.read(1024*1024),b''):
            h.update(b); n+=len(b)
    return h.hexdigest(), n

def snapshot(root):
    root=norm(root); files={}; dirs=[]
    if not os.path.exists(root): return {'files':{}, 'empty_dirs':[]}
    reject_link_reparse(root,'Manuscript root')
    def walk(d):
        reject_link_reparse(d,'Directory')
        entries=[]
        with os.scandir(d) as it:
            for e in it: entries.append(e)
        has_regular=False; child_dirs=[]
        for e in sorted(entries, key=lambda x:x.name.lower()):
            p=e.path; st=e.stat(follow_symlinks=False)
            if stat.S_ISLNK(st.st_mode) or is_reparse(st): raise SyncError(f'Unsupported link or reparse point in manuscript: {p}')
            if e.name=='.git': raise SyncError(f'Nested .git entry is not allowed in manuscript: {p}')
            if stat.S_ISDIR(st.st_mode): child_dirs.append(p); walk(p)
            elif stat.S_ISREG(st.st_mode):
                has_regular=True; rp=rel_slash(p,root); digest,size=sha_file(p); files[rp]={'sha256':digest,'bytes':size}
            else: raise SyncError(f'Unsupported non-regular manuscript entry: {p}')
        if d!=root and not has_regular and not child_dirs:
            dirs.append(rel_slash(d,root))
    walk(root)
    return {'files':dict(sorted(files.items())), 'empty_dirs':sorted(dirs)}

def same(a,b): return a==b
def counts(a,b):
    ak=set(a['files'])|set(a.get('empty_dirs',[])); bk=set(b['files'])|set(b.get('empty_dirs',[]))
    add=len(ak-bk); dele=len(bk-ak); mod=sum(1 for k in set(a['files'])&set(b['files']) if a['files'][k]!=b['files'][k]); un=len(ak&bk)-mod
    return add,mod,dele,un

def load_config(path):
    cp=norm(path); base=os.path.dirname(cp)
    try:
        with open(cp,encoding='utf-8') as f: data=json.load(f)
    except Exception as e: raise SyncError(f'Cannot read config: {e}')
    if data.get('schema_version')!=CONFIG_SCHEMA: raise SyncError('schema_version must equal 1')
    for k in ('source_repo_path','publishing_repo_path','expected_target_id'):
        if not data.get(k): raise SyncError(f'Missing required config value: {k}')
    tid=str(data['expected_target_id'])
    if not SAFE_ID.match(tid): raise SyncError('expected_target_id must be a non-empty safe identifier')
    def res(v): return norm(v if os.path.isabs(v) else os.path.join(base,v))
    sf=data.get('state_file') or (os.path.basename(cp)+'.state.json')
    return {'config_path':cp,'source_repo_path':res(data['source_repo_path']),'publishing_repo_path':res(data['publishing_repo_path']),'expected_target_id':tid,'state_file':res(sf)}

def validate_env(c):
    src,tgt=c['source_repo_path'],c['publishing_repo_path']
    for p,n in ((src,'source repository'),(tgt,'publishing repository')):
        if not os.path.isdir(p): raise SyncError(f'Missing {n}: {p}')
        check_components(p); reject_link_reparse(p,n)
        if not os.path.exists(os.path.join(p,'.git')): raise SyncError(f'{n} does not contain .git: {p}')
    if safe_key(src)==safe_key(tgt) or inside(src,tgt) or inside(tgt,src): raise SyncError('Source and publishing repository roots must be distinct and non-overlapping')
    sm=os.path.join(src,'manuscript'); tm=os.path.join(tgt,'manuscript')
    if not os.path.isdir(sm): raise SyncError(f'Missing source manuscript directory: {sm}')
    check_components(sm,src); reject_link_reparse(sm,'source manuscript')
    book=os.path.join(sm,'book.txt')
    if not os.path.isfile(book): raise SyncError(f'Missing regular source manuscript/book.txt: {book}')
    reject_link_reparse(book,'source book.txt')
    if os.path.exists(tm): check_components(tm,tgt); reject_link_reparse(tm,'target manuscript')
    sf=c['state_file']; check_components(os.path.dirname(sf))
    if inside(sf,src) or inside(sf,tgt): raise SyncError('State file must not be inside either repository')
    marker=os.path.join(tgt,MARKER)
    if not os.path.isfile(marker): raise SyncError(f'Missing publishing target marker: {marker}')
    reject_link_reparse(marker,'target marker')
    try:
        with open(marker,'r',encoding='utf-8') as f: raw=f.read()
    except Exception as e: raise SyncError(f'Cannot read target marker: {e}')
    text=raw.strip()
    if not text or '\x00' in raw: raise SyncError('Malformed target marker')
    if text!=c['expected_target_id']: raise SyncError(f'Target marker mismatch: expected {c["expected_target_id"]}, found {text}')
    return sm,tm

def load_state(c):
    sf=c['state_file']
    if not os.path.exists(sf): return None
    try:
        with open(sf,encoding='utf-8') as f: s=json.load(f)
    except Exception as e: raise SyncError(f'Malformed state: {e}')
    if s.get('schema_version')!=STATE_SCHEMA: raise SyncError('Unsupported state schema version')
    if s.get('source_repo_path')!=c['source_repo_path'] or s.get('publishing_repo_path')!=c['publishing_repo_path'] or s.get('expected_target_id')!=c['expected_target_id']:
        raise SyncError('State identity does not match active config')
    snap=s.get('accepted_snapshot')
    if not isinstance(snap,dict) or 'files' not in snap or 'empty_dirs' not in snap: raise SyncError('Malformed state snapshot')
    for k in list(snap['files'])+list(snap['empty_dirs']): validate_rel(k)
    return s

def classify(S,T,B):
    if B is None:
        if not T['files'] and not T['empty_dirs']: return 'initial-empty-target', True, 'safe initial publish'
        if same(S,T): return 'initial-identical-target', True, 'safe baseline initialization'
        raise Blocked('Initial target is non-empty and differs from source; manual reconciliation required')
    B=B['accepted_snapshot']
    if same(S,B) and same(T,B): return 'in-sync', True, 'publish unnecessary'
    if not same(S,B) and same(T,B): return 'source-only-changes', True, 'safe to mirror source to target'
    if same(S,B) and not same(T,B): raise Blocked('Target-only divergence blocked')
    if not same(S,B) and not same(T,B) and same(S,T): return 'already-reconciled-identically', True, 'safe baseline refresh'
    if not same(S,B) and not same(T,B) and not same(S,T): raise Blocked('Conflicting source and target divergence blocked')
    raise Blocked('Unclassifiable divergence blocked')

def copy_tree(src,dst):
    if os.path.exists(dst): shutil.rmtree(dst)
    shutil.copytree(src,dst,symlinks=False)

def write_state(c,S):
    data={'schema_version':STATE_SCHEMA,'source_repo_path':c['source_repo_path'],'publishing_repo_path':c['publishing_repo_path'],'expected_target_id':c['expected_target_id'],'accepted_utc':dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace('+00:00','Z'),'accepted_snapshot':S}
    os.makedirs(os.path.dirname(c['state_file']),exist_ok=True)
    fd,tmp=tempfile.mkstemp(prefix='.tmp-state-',dir=os.path.dirname(c['state_file']),text=True)
    try:
        with os.fdopen(fd,'w',encoding='utf-8',newline='\n') as f: json.dump(data,f,indent=2,sort_keys=True); f.write('\n')
        os.replace(tmp,c['state_file'])
    finally:
        if os.path.exists(tmp): os.unlink(tmp)

def publish(c,sm,tm,S,T,cl):
    before=snapshot(tm); tmpbase=tempfile.mkdtemp(prefix='protected-manuscript-sync-')
    stage=os.path.join(tmpbase,'stage'); rollback=os.path.join(tmpbase,'rollback')
    try:
        copy_tree(sm,stage)
        if snapshot(stage)!=S: raise MutationFailure('Staged source copy verification failed')
        if os.path.exists(tm): copy_tree(tm,rollback)
        else: os.makedirs(rollback)
        if cl in ('initial-identical-target','in-sync','already-reconciled-identically'):
            pass
        else:
            if os.environ.get('PROTECTED_MANUSCRIPT_SYNC_TEST_FAIL_AFTER_STAGE')=='1': raise OSError('simulated mutation failure')
            copy_tree(stage,tm)
        after=snapshot(tm)
        if after!=S: raise MutationFailure('Post-operation source/target equality verification failed')
        write_state(c,S)
        return 'Publish completed; accepted baseline written.'
    except Exception as e:
        try:
            if os.path.exists(tm): shutil.rmtree(tm)
            if os.path.exists(rollback): shutil.copytree(rollback,tm)
            rb_ok=(snapshot(tm)==before)
        except Exception as rb: raise MutationFailure(f'Publish failed: {e}; rollback failed: {rb}')
        raise MutationFailure(f'Publish failed: {e}; rollback verified: {rb_ok}')
    finally: shutil.rmtree(tmpbase,ignore_errors=True)

def report(action,c,sm,tm,S,T,state,cl,msg,block=None,mut=None):
    a,m,d,u=counts(S,T)
    lines=[f'Action: {action}',f'Source repository: {c["source_repo_path"]}',f'Publishing repository: {c["publishing_repo_path"]}',f'Source manuscript path: {sm}',f'Target manuscript path: {tm}',f'State-file path: {c["state_file"]}',f'Target marker result: valid ({c["expected_target_id"]})',f'Baseline: {"initialized" if state else "uninitialized"}',f'Classification: {cl}',f'Counts vs target: added={a}, modified={m}, deleted={d}, unchanged={u}',f'Publish assessment: {msg}']
    if block: lines.append(f'Blocking reason: {block}')
    if mut: lines.append(f'Mutation result: {mut}')
    if action=='status': lines.append('No mutation performed.')
    return '\n'.join(lines)+'\n'

def run(action,config):
    c=load_config(config); sm,tm=validate_env(c); state=load_state(c); S=snapshot(sm); T=snapshot(tm)
    cl,_safe,msg=classify(S,T,state)
    mut=None
    if action=='publish': mut=publish(c,sm,tm,S,T,cl)
    return report(action,c,sm,tm,S,T,state,cl,msg,mut=mut)

def main(argv=None):
    p=argparse.ArgumentParser(description='Protected one-way manuscript publishing sync. Actions: status, publish.')
    p.add_argument('action',choices=['status','publish']); p.add_argument('--config',required=True)
    ns=p.parse_args(argv)
    try:
        sys.stdout.write(run(ns.action,ns.config)); return EXIT_OK
    except SyncError as e:
        sys.stderr.write(f'ERROR: {e}\n'); return e.code
    except Exception as e:
        sys.stderr.write(f'ERROR: unexpected failure: {e}\n'); return EXIT_MUTATION
if __name__=='__main__': sys.exit(main())
