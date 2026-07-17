import json, os, shutil, subprocess, sys, tempfile, unittest
from pathlib import Path
from unittest import mock
import protected_manuscript_sync as pms

ROOT=Path(__file__).resolve().parents[1]
ENGINE=ROOT/'protected_manuscript_sync.py'

class T(unittest.TestCase):
    def setUp(self):
        self.t=tempfile.TemporaryDirectory(); self.d=Path(self.t.name); self.src=self.d/'source repo'; self.pub=self.d/'publishing repo'; self.cfg=self.d/'cfg.json'; self.statep=self.d/'state.json'
        for r in (self.src,self.pub): (r/'.git').mkdir(parents=True); (r/'README.md').write_text('root',encoding='utf-8')
        (self.src/'manuscript').mkdir(); (self.src/'manuscript'/'book.txt').write_text('book',encoding='utf-8')
        (self.pub/'.protected-manuscript-publishing-target').write_text('the-gap-publishing\n',encoding='utf-8')
        self.write_cfg()
    def tearDown(self): self.t.cleanup()
    def write_cfg(self, **kw):
        data={'schema_version':1,'source_repo_path':str(self.src),'publishing_repo_path':str(self.pub),'expected_target_id':'the-gap-publishing','state_file':str(self.statep)}; data.update(kw); self.cfg.write_text(json.dumps(data),encoding='utf-8')
    def cli(self,*args): return subprocess.run([sys.executable,str(ENGINE),*args],cwd=ROOT,text=True,capture_output=True)
    def publish(self): return self.cli('publish','--config',str(self.cfg))
    def status(self): return self.cli('status','--config',str(self.cfg))
    def state(self): return json.loads(self.statep.read_text(encoding='utf-8'))
    def init(self): r=self.publish(); self.assertEqual(r.returncode,0,r.stderr)
    def run_direct(self):
        try: return 0,pms.run('publish',str(self.cfg))
        except pms.SyncError as e: return e.code,str(e)
    def target_bytes(self):
        out={}
        root=self.pub/'manuscript'
        if not root.exists(): return None
        for p in root.rglob('*'):
            if p.is_file(): out[p.relative_to(root).as_posix()]=p.read_bytes()
            elif p.is_dir(): out[p.relative_to(root).as_posix()]='<DIR>'
        return out
    def assert_blocked_report(self, r, classification):
        self.assertEqual(r.returncode,3,r.stderr+r.stdout); text=r.stderr+r.stdout
        for phrase in ['Action:', 'Source repository:', 'Publishing repository:', 'Source manuscript path:', 'Target manuscript path:', 'State-file path:', 'Target marker result: valid', 'Baseline:', f'Classification: {classification}', 'Counts vs target:', 'Publish assessment: blocked', 'Blocking reason:', 'No mutation performed.']:
            self.assertIn(phrase,text)

    def test_config_relative_default_and_bom(self):
        rel=self.d/'rel.json'; (self.d/'s').mkdir(); (self.d/'p').mkdir(); data={'schema_version':1,'source_repo_path':'s','publishing_repo_path':'p','expected_target_id':'id'}
        rel.write_text('\ufeff'+json.dumps(data),encoding='utf-8')
        c=pms.load_config(str(rel)); self.assertEqual(c['source_repo_path'],str(self.d/'s')); self.assertTrue(c['state_file'].endswith('rel.json.state.json'))
    def test_missing_roots_manuscript_book_marker_and_bad_utf8(self):
        self.write_cfg(source_repo_path=str(self.d/'no')); self.assertEqual(self.status().returncode,2)
        self.write_cfg(publishing_repo_path=str(self.d/'no')); self.assertEqual(self.status().returncode,2)
        self.write_cfg(); shutil.rmtree(self.src/'manuscript'); self.assertEqual(self.status().returncode,2)
        (self.src/'manuscript').mkdir(); self.assertEqual(self.status().returncode,2)
        (self.src/'manuscript'/'book.txt').write_text('book'); os.remove(self.pub/'.protected-manuscript-publishing-target'); self.assertEqual(self.status().returncode,2)
        (self.pub/'.protected-manuscript-publishing-target').write_bytes(b'\xff\xfe'); self.assertEqual(self.status().returncode,2)
    def test_marker_bom_wrong_and_malformed(self):
        (self.pub/'.protected-manuscript-publishing-target').write_text('\ufeff the-gap-publishing \n',encoding='utf-8'); self.assertEqual(self.status().returncode,0)
        (self.pub/'.protected-manuscript-publishing-target').write_text('wrong',encoding='utf-8'); self.assertEqual(self.status().returncode,2)
        (self.pub/'.protected-manuscript-publishing-target').write_text('\x00',encoding='utf-8'); self.assertEqual(self.status().returncode,2)
    def test_equal_nested_roots_state_inside_and_canonical_alias(self):
        self.write_cfg(publishing_repo_path=str(self.src)); self.assertEqual(self.status().returncode,2)
        nested=self.src/'nested'; nested.mkdir(); (nested/'.git').mkdir(); self.write_cfg(publishing_repo_path=str(nested)); self.assertEqual(self.status().returncode,2)
        self.write_cfg(state_file=str(self.src/'state.json')); self.assertEqual(self.status().returncode,2)
        self.write_cfg(state_file=str(self.pub/'state.json')); self.assertEqual(self.status().returncode,2)
    def test_target_manuscript_file_is_validation_failure(self):
        (self.pub/'manuscript').write_text('not dir'); r=self.status(); self.assertEqual(r.returncode,2); self.assertIn('Target manuscript path is not a directory',r.stderr)
    def test_uninitialized_empty_identical_and_differing(self):
        r=self.status(); self.assertEqual(r.returncode,0); self.assertIn('initial-empty-target',r.stdout); self.assertFalse(self.statep.exists())
        r=self.publish(); self.assertEqual(r.returncode,0,r.stderr); self.assertTrue((self.pub/'manuscript'/'book.txt').exists())
        self.t.cleanup(); self.setUp(); shutil.copytree(self.src/'manuscript',self.pub/'manuscript'); before=(self.pub/'manuscript'/'book.txt').stat().st_mtime_ns
        self.assertIn('initial-identical-target',self.status().stdout); code,text=self.run_direct(); self.assertEqual(code,0,text); self.assertEqual(before,(self.pub/'manuscript'/'book.txt').stat().st_mtime_ns)
        self.t.cleanup(); self.setUp(); (self.pub/'manuscript').mkdir(); (self.pub/'manuscript'/'other.md').write_text('x'); self.assert_blocked_report(self.status(),'blocked-initial-differing-target'); self.assert_blocked_report(self.publish(),'blocked-initial-differing-target')
    def test_source_add_modify_delete_binary_spaces_empty_dirs_confined(self):
        (self.src/'manuscript'/'dir with spaces'/'empty').mkdir(parents=True); (self.src/'manuscript'/'dir with spaces'/'b.bin').write_bytes(b'\0\xffbin'); (self.pub/'outside.txt').write_text('keep'); marker=(self.pub/'.protected-manuscript-publishing-target').read_text(); self.init()
        st=self.state(); self.assertIn('dir with spaces/empty',st['accepted_snapshot']['empty_dirs']); self.assertEqual((self.pub/'manuscript'/'dir with spaces'/'b.bin').read_bytes(),b'\0\xffbin'); self.assertEqual((self.pub/'outside.txt').read_text(),'keep'); self.assertEqual((self.pub/'.protected-manuscript-publishing-target').read_text(),marker)
        (self.src/'manuscript'/'a.md').write_text('a'); (self.src/'manuscript'/'book.txt').write_text('book2'); self.assertEqual(self.publish().returncode,0); os.remove(self.src/'manuscript'/'a.md'); self.assertEqual(self.publish().returncode,0); self.assertFalse((self.pub/'manuscript'/'a.md').exists())
    def test_blocked_target_only_conflict_and_identical_refresh_reports(self):
        self.init(); (self.pub/'manuscript'/'x.md').write_text('x'); self.assert_blocked_report(self.status(),'blocked-target-only-divergence')
        shutil.rmtree(self.pub/'manuscript'); shutil.copytree(self.src/'manuscript',self.pub/'manuscript'); (self.src/'manuscript'/'book.txt').write_text('s'); (self.pub/'manuscript'/'book.txt').write_text('t'); self.assert_blocked_report(self.status(),'blocked-conflicting-divergence'); self.assert_blocked_report(self.publish(),'blocked-conflicting-divergence')
        (self.src/'manuscript'/'book.txt').write_text('same'); (self.pub/'manuscript'/'book.txt').write_text('same'); r=self.publish(); self.assertEqual(r.returncode,0,r.stderr); self.assertIn('already-reconciled-identically',r.stdout)
    def test_state_status_no_mutation_bom_and_malformed_schema(self):
        self.init(); old=self.statep.read_bytes(); self.status(); self.assertEqual(old,self.statep.read_bytes())
        self.statep.write_bytes(b'\xef\xbb\xbf'+old); self.assertEqual(self.status().returncode,0)
        cases=[b'{bad', b'\xff', json.dumps({'schema_version':99}).encode(), json.dumps({'schema_version':1,'source_repo_path':'x','publishing_repo_path':'y','expected_target_id':'z','accepted_utc':'bad','accepted_snapshot':{'files':{},'empty_dirs':[]}}).encode()]
        for data in cases:
            self.statep.write_bytes(data); self.assertEqual(self.status().returncode,2)
    def test_malformed_state_snapshot_cases_exit_2(self):
        self.init(); base=self.state()
        cases=[]
        for snap in [[], {'files':[],'empty_dirs':[]}, {'files':{},'empty_dirs':{}}, {'files':{'a':[]},'empty_dirs':[]}, {'files':{'a':{'sha256':'BAD','bytes':1}},'empty_dirs':[]}, {'files':{'a':{'sha256':'0'*64,'bytes':-1}},'empty_dirs':[]}, {'files':{'a':{'sha256':'0'*64,'bytes':True}},'empty_dirs':[]}, {'files':{'a':{'sha256':'0'*64,'bytes':1}},'empty_dirs':['a']}, {'files':{'../a':{'sha256':'0'*64,'bytes':1}},'empty_dirs':[]}]:
            x=dict(base); x['accepted_snapshot']=snap; cases.append(x)
        for c in cases:
            self.statep.write_text(json.dumps(c),encoding='utf-8'); self.assertEqual(self.status().returncode,2)
    def test_symlink_path_safety_where_supported(self):
        if not hasattr(os,'symlink'): self.skipTest('symlink unavailable')
        # source root through symlink
        link=self.d/'src-link'
        try: os.symlink(self.src,link,target_is_directory=True)
        except OSError as e: self.skipTest(f'symlink unavailable: {e}')
        self.write_cfg(source_repo_path=str(link)); self.assertEqual(self.status().returncode,2)
        self.write_cfg(); plink=self.d/'pub-link'; os.symlink(self.pub,plink,target_is_directory=True); self.write_cfg(publishing_repo_path=str(plink)); self.assertEqual(self.status().returncode,2)
        self.write_cfg(); os.remove(self.pub/'.git') if (self.pub/'.git').is_file() else shutil.rmtree(self.pub/'.git'); os.symlink(self.d,self.pub/'.git',target_is_directory=True); self.assertEqual(self.status().returncode,2)
        os.unlink(self.pub/'.git'); (self.pub/'.git').mkdir(); os.remove(self.pub/'.protected-manuscript-publishing-target'); os.symlink(self.src/'manuscript'/'book.txt',self.pub/'.protected-manuscript-publishing-target'); self.assertEqual(self.status().returncode,2)
        os.unlink(self.pub/'.protected-manuscript-publishing-target'); (self.pub/'.protected-manuscript-publishing-target').write_text('the-gap-publishing'); parent=self.d/'state-link'; real=self.d/'real-state'; real.mkdir(); os.symlink(real,parent,target_is_directory=True); self.write_cfg(state_file=str(parent/'s.json')); self.assertEqual(self.status().returncode,2)
    def test_state_file_symlink_rejected_where_supported(self):
        if not hasattr(os,'symlink'): self.skipTest('symlink unavailable')
        self.init(); target=self.d/'real.json'; target.write_text(self.statep.read_text()); self.statep.unlink();
        try: os.symlink(target,self.statep)
        except OSError as e: self.skipTest(f'symlink unavailable: {e}')
        self.assertEqual(self.status().returncode,2)
    def test_transaction_failures_preserve_existing_target_and_state(self):
        self.init(); (self.src/'manuscript'/'new.md').write_text('new'); old_state=self.statep.read_bytes(); old_target=self.target_bytes()
        originals=(pms.copy_tree,pms.snapshot,pms.write_state,shutil.copytree)
        scenarios=[]
        def fail_stage(src,dst):
            if str(dst).endswith('stage'): raise OSError('stage create fail')
            return originals[0](src,dst)
        scenarios.append((mock.patch('protected_manuscript_sync.copy_tree',side_effect=fail_stage),'stage create fail'))
        def bad_snapshot(path):
            s=originals[1](path)
            if str(path).endswith('stage'): return {'files':{},'empty_dirs':[]}
            return s
        scenarios.append((mock.patch('protected_manuscript_sync.snapshot',side_effect=bad_snapshot),'Staged source copy verification failed'))
        def fail_rollback(src,dst):
            if str(dst).endswith('rollback'): raise OSError('rollback create fail')
            return originals[0](src,dst)
        scenarios.append((mock.patch('protected_manuscript_sync.copy_tree',side_effect=fail_rollback),'rollback create fail'))
        def bad_rb(path):
            s=originals[1](path)
            if str(path).endswith('rollback'): return {'files':{},'empty_dirs':[]}
            return s
        scenarios.append((mock.patch('protected_manuscript_sync.snapshot',side_effect=bad_rb),'Rollback copy verification failed'))
        def fail_write(c,S): raise OSError('state write fail')
        scenarios.append((mock.patch('protected_manuscript_sync.write_state',side_effect=fail_write),'state write fail'))
        for patcher,msg in scenarios:
            with patcher:
                code,text=self.run_direct(); self.assertEqual(code,4); self.assertIn(msg,text)
            self.assertEqual(self.statep.read_bytes(),old_state); self.assertEqual(self.target_bytes(),old_target)
    def test_mutation_postverify_absent_initial_and_rollback_failure(self):
        self.init(); (self.src/'manuscript'/'new.md').write_text('new'); old_state=self.statep.read_bytes(); old_target=self.target_bytes()
        orig_copytree=shutil.copytree; orig_snapshot=pms.snapshot; orig_restore=pms.restore_target
        with mock.patch('protected_manuscript_sync.remove_tree',side_effect=OSError('target remove fail')):
            code,text=self.run_direct(); self.assertEqual(code,4); self.assertIn('target remove fail',text)
        self.assertEqual(self.statep.read_bytes(),old_state); self.assertEqual(self.target_bytes(),old_target)
        def fail_target(src,dst,*a,**kw):
            if Path(dst)==self.pub/'manuscript': raise OSError('target copy fail')
            return orig_copytree(src,dst,*a,**kw)
        def bad_target_snapshot(path):
            s=orig_snapshot(path)
            if Path(path)==self.pub/'manuscript' and (self.pub/'manuscript'/'new.md').exists(): return {'files':{},'empty_dirs':[]}
            return s
        with mock.patch('protected_manuscript_sync.snapshot',side_effect=bad_target_snapshot):
            code,text=self.run_direct(); self.assertEqual(code,4); self.assertIn('Post-operation',text)
        self.assertEqual(self.target_bytes(),old_target)
        def fail_restore(*args,**kw): raise OSError('restore boom')
        with mock.patch('protected_manuscript_sync.restore_target',side_effect=fail_restore), mock.patch('protected_manuscript_sync.remove_tree',side_effect=OSError('target remove fail')):
            code,text=self.run_direct(); self.assertEqual(code,4); self.assertIn('target remove fail',text); self.assertIn('restore boom',text)
        # Absent initial target restores absence and no state.
        self.t.cleanup(); self.setUp(); shutil.rmtree(self.pub/'manuscript',ignore_errors=True)
        with mock.patch('shutil.copytree',side_effect=fail_target):
            code,text=self.run_direct(); self.assertEqual(code,4)
        self.assertFalse((self.pub/'manuscript').exists()); self.assertFalse(self.statep.exists())

    def test_counts_file_directory_type_change_is_modified(self):
        a={'files':{'same':{'sha256':'0'*64,'bytes':1}},'empty_dirs':[]}
        b={'files':{},'empty_dirs':['same']}
        self.assertEqual(pms.counts(a,b),(0,1,0,0))
        (self.pub/'manuscript').mkdir(); (self.pub/'manuscript'/'book.txt').write_text('book'); (self.pub/'manuscript'/'same').mkdir()
        (self.src/'manuscript'/'same').write_text('file')
        r=self.status(); self.assertEqual(r.returncode,3); self.assertIn('modified=1',r.stderr)
    def test_state_ancestor_paths_rejected(self):
        self.init(); base=self.state(); bad=[({'a':{'sha256':'0'*64,'bytes':1},'a/b.md':{'sha256':'0'*64,'bytes':1}},[]), ({'a':{'sha256':'0'*64,'bytes':1}},['a/empty']), ({},['a','a/b'])]
        for files,dirs in bad:
            x=dict(base); x['accepted_snapshot']={'files':files,'empty_dirs':dirs}; self.statep.write_text(json.dumps(x),encoding='utf-8'); self.assertEqual(self.status().returncode,2)

    def test_windows_style_normalized_keys_keep_slashes_and_reject_ancestors(self):
        def win_normcase(value):
            return value.lower().replace('/','\\')
        with mock.patch('protected_manuscript_sync.os.path.normcase',side_effect=win_normcase):
            self.assertEqual(pms.normalized_path_key('A/B.md'),'a/b.md')
            cases=[({'a':{'sha256':'0'*64,'bytes':1},'a/b.md':{'sha256':'0'*64,'bytes':1}},[]), ({'A':{'sha256':'0'*64,'bytes':1},'a/b.md':{'sha256':'0'*64,'bytes':1}},[]), ({'a':{'sha256':'0'*64,'bytes':1}},['A/empty']), ({},['a','a/b']), ({},['A','a/b'])]
            for files,dirs in cases:
                with self.assertRaises(pms.SyncError):
                    pms.validate_snapshot_schema({'files':files,'empty_dirs':dirs})

    def test_transaction_parent_external_ignores_default_temp_and_cleans_success(self):
        self.init(); (self.src/'manuscript'/'new.md').write_text('new')
        state_parent=self.statep.parent; work_parent=state_parent/'.protected-manuscript-sync-work'; seen=[]; orig=pms.tempfile.mkdtemp
        def record_mkdtemp(*args,**kwargs):
            seen.append(kwargs.get('dir')); return orig(*args,**kwargs)
        old_tempdir=tempfile.tempdir; old_tmp=os.environ.get('TMP'); old_temp=os.environ.get('TEMP')
        try:
            tempfile.tempdir=str(self.src); os.environ['TMP']=str(self.pub); os.environ['TEMP']=str(self.src/'manuscript')
            with mock.patch('protected_manuscript_sync.tempfile.mkdtemp',side_effect=record_mkdtemp):
                code,text=self.run_direct(); self.assertEqual(code,0,text)
        finally:
            tempfile.tempdir=old_tempdir
            if old_tmp is None: os.environ.pop('TMP',None)
            else: os.environ['TMP']=old_tmp
            if old_temp is None: os.environ.pop('TEMP',None)
            else: os.environ['TEMP']=old_temp
        self.assertTrue(seen); self.assertEqual(Path(seen[0]),work_parent); self.assertFalse(work_parent.exists()); self.assertFalse(any(p.name.startswith('protected-manuscript-sync-') for p in self.src.rglob('*')))
    def test_transaction_parent_external_ignores_publishing_and_target_temp_failure_cleans(self):
        self.init(); (self.src/'manuscript'/'new.md').write_text('new'); state_parent=self.statep.parent; work_parent=state_parent/'.protected-manuscript-sync-work'
        old_tempdir=tempfile.tempdir; old_tmp=os.environ.get('TMP'); old_temp=os.environ.get('TEMP')
        try:
            tempfile.tempdir=str(self.pub); os.environ['TMP']=str(self.pub/'manuscript'); os.environ['TEMP']=str(self.pub)
            with mock.patch('protected_manuscript_sync.write_state',side_effect=OSError('state write fail')):
                code,text=self.run_direct(); self.assertEqual(code,4); self.assertIn('state write fail',text)
        finally:
            tempfile.tempdir=old_tempdir
            if old_tmp is None: os.environ.pop('TMP',None)
            else: os.environ['TMP']=old_tmp
            if old_temp is None: os.environ.pop('TEMP',None)
            else: os.environ['TEMP']=old_temp
        self.assertFalse(work_parent.exists()); self.assertFalse(any(p.name.startswith('protected-manuscript-sync-') for p in self.pub.rglob('*')))
    def test_state_parent_file_and_transaction_parent_reparse_rejected(self):
        file_parent=self.d/'not-dir'; file_parent.write_text('x'); self.write_cfg(state_file=str(file_parent/'s.json')); self.assertEqual(self.status().returncode,2)
        if hasattr(os,'symlink'):
            real=self.d/'real-work'; real.mkdir(); link=self.d/'.protected-manuscript-sync-work'
            try: os.symlink(real,link,target_is_directory=True)
            except OSError as e: self.skipTest(f'symlink unavailable: {e}')
            self.write_cfg(state_file=str(self.d/'state.json'))
            r=self.publish(); self.assertEqual(r.returncode,2); self.assertIn('transaction work parent',r.stderr)

    def test_exit_codes_no_force_no_pullback(self):
        self.assertEqual(self.status().returncode,0); self.assertEqual(self.cli('--help').returncode,0); self.assertNotEqual(self.cli('pullback','--config',str(self.cfg)).returncode,0); self.assertNotEqual(self.cli('status','--config',str(self.cfg),'--force').returncode,0)
    def make_junction(self, link, target):
        r=subprocess.run(['cmd','/c','mklink','/J',str(link),str(target)],capture_output=True,text=True)
        if r.returncode!=0: self.skipTest(f'junction creation failed: {r.stderr or r.stdout}')
    def test_windows_junction_rejections(self):
        if os.name!='nt': self.skipTest('Windows reparse points require Windows')
        j=self.src/'manuscript'/'j'; real=self.d/'realj'; real.mkdir(); self.make_junction(j,real); self.assertEqual(self.status().returncode,2)
        shutil.rmtree(j); self.init(); j=self.pub/'manuscript'/'j'; self.make_junction(j,real); self.assertEqual(self.status().returncode,2)
        shutil.rmtree(j); srcj=self.d/'srcj'; self.make_junction(srcj,self.src); self.write_cfg(source_repo_path=str(srcj)); self.assertEqual(self.status().returncode,2)
        self.write_cfg(); pubj=self.d/'pubj'; self.make_junction(pubj,self.pub); self.write_cfg(publishing_repo_path=str(pubj)); self.assertEqual(self.status().returncode,2)
        self.write_cfg(); parent=self.d/'statej'; self.make_junction(parent,self.d); self.write_cfg(state_file=str(parent/'s.json')); self.assertEqual(self.status().returncode,2)

if __name__=='__main__': unittest.main()
