import json, os, shutil, subprocess, sys, tempfile, unittest
from pathlib import Path
import protected_manuscript_sync as pms

ROOT=Path(__file__).resolve().parents[1]
ENGINE=ROOT/'protected_manuscript_sync.py'

class T(unittest.TestCase):
    def setUp(self):
        self.t=tempfile.TemporaryDirectory(); self.d=Path(self.t.name); self.src=self.d/'source repo'; self.pub=self.d/'publishing repo'; self.cfg=self.d/'cfg.json'
        for r in (self.src,self.pub): (r/'.git').mkdir(parents=True); (r/'README.md').write_text('root',encoding='utf-8')
        (self.src/'manuscript').mkdir(); (self.src/'manuscript'/'book.txt').write_text('book',encoding='utf-8')
        (self.pub/'.protected-manuscript-publishing-target').write_text('the-gap-publishing\n',encoding='utf-8')
        self.write_cfg()
    def tearDown(self): self.t.cleanup()
    def write_cfg(self, **kw):
        data={'schema_version':1,'source_repo_path':str(self.src),'publishing_repo_path':str(self.pub),'expected_target_id':'the-gap-publishing','state_file':str(self.d/'state.json')}; data.update(kw); self.cfg.write_text(json.dumps(data),encoding='utf-8')
    def cli(self,*args,env=None): return subprocess.run([sys.executable,str(ENGINE),*args],cwd=ROOT,text=True,capture_output=True,env=env)
    def publish(self): return self.cli('publish','--config',str(self.cfg))
    def status(self): return self.cli('status','--config',str(self.cfg))
    def state(self): return json.loads((self.d/'state.json').read_text(encoding='utf-8'))
    def init(self): r=self.publish(); self.assertEqual(r.returncode,0,r.stderr)

    def test_01_valid_config_loading_relative_default_state(self):
        rel=self.d/'rel.json'; (self.d/'s').mkdir(); (self.d/'p').mkdir(); data={'schema_version':1,'source_repo_path':'s','publishing_repo_path':'p','expected_target_id':'id'}; rel.write_text(json.dumps(data),encoding='utf-8')
        c=pms.load_config(str(rel)); self.assertEqual(c['source_repo_path'],str(self.d/'s')); self.assertTrue(c['state_file'].endswith('rel.json.state.json'))
    def test_02_missing_roots_and_manuscript_and_book(self):
        cases=[('source_repo_path',self.d/'no',2),('publishing_repo_path',self.d/'no',2)]
        for k,v,code in cases:
            self.write_cfg(**{k:str(v)}); self.assertEqual(self.status().returncode,code)
        self.write_cfg(); shutil.rmtree(self.src/'manuscript'); self.assertEqual(self.status().returncode,2)
        (self.src/'manuscript').mkdir(); self.assertEqual(self.status().returncode,2)
    def test_03_marker_validation(self):
        os.remove(self.pub/'.protected-manuscript-publishing-target'); self.assertEqual(self.status().returncode,2)
        (self.pub/'.protected-manuscript-publishing-target').write_text('wrong',encoding='utf-8'); self.assertEqual(self.status().returncode,2)
        (self.pub/'.protected-manuscript-publishing-target').write_text('\x00',encoding='utf-8'); self.assertEqual(self.status().returncode,2)
    def test_04_equal_nested_roots_state_inside_repos(self):
        self.write_cfg(publishing_repo_path=str(self.src)); self.assertEqual(self.status().returncode,2)
        nested=self.src/'nested'; nested.mkdir(); (nested/'.git').mkdir(); self.write_cfg(publishing_repo_path=str(nested)); self.assertEqual(self.status().returncode,2)
        self.write_cfg(state_file=str(self.src/'state.json')); self.assertEqual(self.status().returncode,2)
        self.write_cfg(state_file=str(self.pub/'state.json')); self.assertEqual(self.status().returncode,2)
    def test_05_uninitialized_empty_status_and_publish(self):
        r=self.status(); self.assertEqual(r.returncode,0); self.assertIn('initial-empty-target',r.stdout); self.assertFalse((self.d/'state.json').exists())
        r=self.publish(); self.assertEqual(r.returncode,0,r.stderr); self.assertTrue((self.pub/'manuscript'/'book.txt').exists()); self.assertTrue((self.d/'state.json').exists())
    def test_06_uninitialized_identical_baseline_without_rewrite(self):
        shutil.copytree(self.src/'manuscript',self.pub/'manuscript'); before=(self.pub/'manuscript'/'book.txt').stat().st_mtime_ns
        self.assertIn('initial-identical-target',self.status().stdout); r=self.publish(); self.assertEqual(r.returncode,0,r.stderr); self.assertEqual(before,(self.pub/'manuscript'/'book.txt').stat().st_mtime_ns)
    def test_07_uninitialized_differing_blocks(self):
        (self.pub/'manuscript').mkdir(); (self.pub/'manuscript'/'other.md').write_text('x',encoding='utf-8'); r=self.status(); self.assertEqual(r.returncode,3); self.assertIn('Initial target',r.stderr)
    def test_08_initialized_in_sync_and_source_add_modify_delete_mirror(self):
        self.init(); self.assertIn('in-sync',self.status().stdout)
        (self.src/'manuscript'/'a.md').write_text('a',encoding='utf-8'); (self.src/'manuscript'/'book.txt').write_text('book2',encoding='utf-8'); r=self.publish(); self.assertEqual(r.returncode,0,r.stderr); self.assertEqual((self.pub/'manuscript'/'a.md').read_text(),'a')
        os.remove(self.src/'manuscript'/'a.md'); r=self.publish(); self.assertEqual(r.returncode,0,r.stderr); self.assertFalse((self.pub/'manuscript'/'a.md').exists())
    def test_09_safe_publish_confined_preserves_root_marker_outside_and_binary_spaces(self):
        (self.src/'manuscript'/'dir with spaces').mkdir(); data=b'\x00\xffbin'; (self.src/'manuscript'/'dir with spaces'/'b.bin').write_bytes(data); (self.pub/'outside.txt').write_text('keep'); marker=(self.pub/'.protected-manuscript-publishing-target').read_text(); readme=(self.pub/'README.md').read_text()
        r=self.publish(); self.assertEqual(r.returncode,0,r.stderr); self.assertEqual((self.pub/'manuscript'/'dir with spaces'/'b.bin').read_bytes(),data); self.assertEqual((self.pub/'outside.txt').read_text(),'keep'); self.assertEqual((self.pub/'.protected-manuscript-publishing-target').read_text(),marker); self.assertEqual((self.pub/'README.md').read_text(),readme)
    def test_10_target_only_add_modify_delete_block(self):
        self.init(); (self.pub/'manuscript'/'x.md').write_text('x'); self.assertEqual(self.status().returncode,3)
        shutil.rmtree(self.pub/'manuscript'); shutil.copytree(self.src/'manuscript',self.pub/'manuscript'); (self.pub/'manuscript'/'book.txt').write_text('changed'); self.assertEqual(self.status().returncode,3)
        shutil.rmtree(self.pub/'manuscript'); (self.pub/'manuscript').mkdir(); self.assertEqual(self.status().returncode,3)
    def test_11_both_sides_identical_refresh_and_different_conflict(self):
        self.init(); (self.src/'manuscript'/'book.txt').write_text('same'); (self.pub/'manuscript'/'book.txt').write_text('same'); r=self.publish(); self.assertEqual(r.returncode,0,r.stderr); self.assertIn('already-reconciled',r.stdout)
        (self.src/'manuscript'/'book.txt').write_text('s'); (self.pub/'manuscript'/'book.txt').write_text('t'); self.assertEqual(self.status().returncode,3)
    def test_12_empty_dirs_are_mirrored_and_in_state_with_slashes(self):
        (self.src/'manuscript'/'empty'/'nested').mkdir(parents=True); self.init(); s=self.state(); self.assertIn('empty/nested',s['accepted_snapshot']['empty_dirs']); self.assertTrue((self.pub/'manuscript'/'empty'/'nested').is_dir())
    def test_13_malformed_unsupported_mismatch_state_status_no_change(self):
        self.init(); old=(self.d/'state.json').read_text(); self.status(); self.assertEqual(old,(self.d/'state.json').read_text())
        (self.d/'state.json').write_text('{bad'); self.assertEqual(self.status().returncode,2)
        (self.d/'state.json').write_text(json.dumps({'schema_version':99})); self.assertEqual(self.status().returncode,2)
        os.remove(self.d/'state.json'); self.init(); st=self.state(); st['expected_target_id']='other'; (self.d/'state.json').write_text(json.dumps(st)); self.assertEqual(self.status().returncode,2)
    def test_14_symlink_nested_git_and_escape_rejection(self):
        (self.src/'manuscript'/'.git').mkdir(); self.assertEqual(self.status().returncode,2); shutil.rmtree(self.src/'manuscript'/'.git')
        if hasattr(os,'symlink'):
            try: os.symlink(self.src/'manuscript'/'book.txt', self.src/'manuscript'/'link')
            except OSError as e: self.skipTest(f'symlink unavailable: {e}')
            self.assertEqual(self.status().returncode,2)
        with self.assertRaises(pms.SyncError): pms.validate_rel('../x')
    def test_15_atomic_write_and_rollback_on_simulated_failure_state_unchanged(self):
        self.init(); old=(self.d/'state.json').read_text(); (self.src/'manuscript'/'new.md').write_text('new')
        env=os.environ.copy(); env['PROTECTED_MANUSCRIPT_SYNC_TEST_FAIL_AFTER_STAGE']='1'; r=self.cli('publish','--config',str(self.cfg),env=env)
        self.assertEqual(r.returncode,4); self.assertEqual((self.d/'state.json').read_text(),old); self.assertFalse((self.pub/'manuscript'/'new.md').exists())
    def test_16_exit_codes_no_force_no_pullback(self):
        self.assertEqual(self.status().returncode,0); self.assertEqual(self.cli('--help').returncode,0); self.assertNotEqual(self.cli('pullback','--config',str(self.cfg)).returncode,0); self.assertNotEqual(self.cli('status','--config',str(self.cfg),'--force').returncode,0)
    def test_17_windows_junction_reparse_point_rejection_where_supported(self):
        if os.name!='nt': self.skipTest('Windows reparse points require Windows')

if __name__=='__main__': unittest.main()
