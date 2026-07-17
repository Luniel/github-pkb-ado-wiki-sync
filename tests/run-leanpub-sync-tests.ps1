Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$Script = Join-Path $RepoRoot 'sync_github_book_leanpub.ps1'
$script:Passed = 0
$script:Failed = 0

function New-TextFile { param([string]$Path,[string]$Content) $dir=Split-Path -Parent $Path; if(-not(Test-Path -LiteralPath $dir)){New-Item -ItemType Directory -Path $dir -Force|Out-Null}; [IO.File]::WriteAllText($Path,$Content,(New-Object Text.UTF8Encoding($false))) }
function New-Fixture {
  $root = Join-Path ([IO.Path]::GetTempPath()) ("leanpub-sync-test-" + [guid]::NewGuid().ToString('n'))
  $src = Join-Path $root 'book-the-gap/manuscript'; $repo = Join-Path $root 'book-the-gap-publishing'; $pub = Join-Path $repo 'manuscript'
  New-Item -ItemType Directory -Path $src,$repo,(Join-Path $repo '.git') -Force|Out-Null
  New-TextFile (Join-Path $repo 'README.md') 'publishing readme'
  New-TextFile (Join-Path $src 'book.txt') "chapter1.md`nchapter2.md`n"
  New-TextFile (Join-Path $src 'chapter1.md') "# One`n![img](resources/a.png)`n"
  New-TextFile (Join-Path $src 'chapter2.md') "# Two`n"
  New-TextFile (Join-Path $src 'resources/a.png') 'A'
  New-TextFile (Join-Path $src 'resources/unused.zip') 'UNUSED'
  New-TextFile (Join-Path $src 'old/archive.md') 'OLD'
  $cfg = Join-Path $root 'leanpub.sync.json'
  New-TextFile $cfg (@{source_manuscript_path=$src;publishing_repo_path=$repo;publishing_manuscript_path='manuscript';spine_file='book.txt';state_file='.\leanpub.sync.state.json'} | ConvertTo-Json)
  [PSCustomObject]@{Root=$root;Source=$src;Repo=$repo;Pub=$pub;Config=$cfg;State=(Join-Path $root 'leanpub.sync.state.json')}
}
function Invoke-Tool { param($Fx,[string]$Action='status') & $Script $Action -ConfigPath $Fx.Config 2>&1 | Out-String }
function Assert { param([bool]$Condition,[string]$Message) if(-not $Condition){throw $Message} }
function Expect-Failure { param([scriptblock]$Block,[string]$Contains) $failed=$false; try { & $Block | Out-Null } catch { $failed=$true; Assert ($_.Exception.Message -like "*$Contains*") "Expected error containing '$Contains' but got '$($_.Exception.Message)'" }; Assert $failed "Expected failure containing '$Contains'" }
function Test-Case { param([string]$Name,[scriptblock]$Body) try { & $Body; Write-Host "PASS $Name"; $script:Passed++ } catch { Write-Host "FAIL $Name`n$($_.Exception.Message)"; $script:Failed++ } }

Test-Case '1 reads active spine entries ignoring blank and comments' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Source 'book.txt') "`n # c`nchapter1.md`n`nchapter2.md`n"; $o=Invoke-Tool $fx status; Assert ($o -match 'Active manuscript files:\s+2') $o }
Test-Case '2 fails on empty active spine' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Source 'book.txt') "`n# none`n"; Expect-Failure { Invoke-Tool $fx status } 'no active manuscript' }
Test-Case '3 fails on duplicate spine entries' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Source 'book.txt') "chapter1.md`nchapter1.md`n"; Expect-Failure { Invoke-Tool $fx status } 'Duplicate spine entry' }
Test-Case '4 fails on missing active manuscript files' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Source 'book.txt') "missing.md`n"; Expect-Failure { Invoke-Tool $fx status } 'not found' }
Test-Case '5 fails on absolute or traversal spine entries' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Source 'book.txt') "../secret.md`n"; Expect-Failure { Invoke-Tool $fx status } 'Unsafe spine entry' }
Test-Case '6 discovers referenced resources' { $fx=New-Fixture; $o=Invoke-Tool $fx status; Assert ($o -match 'Referenced resources:\s+1') $o; Assert ($o -match 'resources/a.png') $o }
Test-Case '7 supports optional titles and angle paths with spaces' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Source 'resources/path with spaces/example.png') 'S'; New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](<resources/path with spaces/example.png>) ![b](resources/a.png "Title")'; $o=Invoke-Tool $fx status; Assert ($o -match 'Referenced resources:\s+2') $o }
Test-Case '8 ignores external URLs and fragment-only references' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](https://x/y.png) ![b](http://x) ![c](data:image/png,abc) ![d](mailto:x@y) ![e](#anchor)'; $o=Invoke-Tool $fx status; Assert ($o -match 'Referenced resources:\s+0') $o }
Test-Case '9 fails on missing local resources' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](resources/missing.png)'; Expect-Failure { Invoke-Tool $fx status } 'Referenced resource not found' }
Test-Case '10 fails on resource traversal outside source root' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](resources/../../secret.png)'; Expect-Failure { Invoke-Tool $fx status } 'Unsafe resource reference' }
Test-Case '11 unreferenced resources are not copied' { $fx=New-Fixture; Invoke-Tool $fx publish|Out-Null; Assert (-not(Test-Path -LiteralPath (Join-Path $fx.Pub 'resources/unused.zip'))) 'unused copied' }
Test-Case '12 manuscript old is not copied merely because it exists' { $fx=New-Fixture; Invoke-Tool $fx publish|Out-Null; Assert (-not(Test-Path -LiteralPath (Join-Path $fx.Pub 'old/archive.md'))) 'old copied' }
Test-Case '13 initial publication adds expected files' { $fx=New-Fixture; $o=Invoke-Tool $fx publish; foreach($p in 'book.txt','chapter1.md','chapter2.md','resources/a.png'){Assert (Test-Path -LiteralPath (Join-Path $fx.Pub $p)) "$p missing"}; Assert ($o -match 'ADD book.txt') $o }
Test-Case '14 changed source content produces update' { $fx=New-Fixture; Invoke-Tool $fx publish|Out-Null; New-TextFile (Join-Path $fx.Source 'chapter1.md') '# Won'; $o=Invoke-Tool $fx publish; Assert ($o -match 'UPDATE chapter1.md') $o }
Test-Case '15 removed spine/resource references produce deletions' { $fx=New-Fixture; Invoke-Tool $fx publish|Out-Null; New-TextFile (Join-Path $fx.Source 'book.txt') "chapter2.md`n"; $o=Invoke-Tool $fx publish; Assert ($o -match 'DELETE chapter1.md') $o; Assert ($o -match 'DELETE resources/a.png') $o }
Test-Case '16 stale target files deleted only inside manuscript' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Pub 'stale.md') 'stale'; New-TextFile (Join-Path $fx.Repo 'outside.md') 'outside'; Invoke-Tool $fx publish|Out-Null; Assert (-not(Test-Path -LiteralPath (Join-Path $fx.Pub 'stale.md'))) 'stale remains'; Assert (Test-Path -LiteralPath (Join-Path $fx.Repo 'outside.md')) 'outside removed' }
Test-Case '17 root README remains unchanged' { $fx=New-Fixture; Invoke-Tool $fx publish|Out-Null; Assert ((Get-Content -LiteralPath (Join-Path $fx.Repo 'README.md') -Raw) -eq 'publishing readme') 'readme changed' }
Test-Case '18 status performs no mutations and writes no state' { $fx=New-Fixture; Invoke-Tool $fx status|Out-Null; Assert (-not(Test-Path -LiteralPath $fx.Pub)) 'pub created'; Assert (-not(Test-Path -LiteralPath $fx.State)) 'state written' }
Test-Case '19 publish writes state after success' { $fx=New-Fixture; Invoke-Tool $fx publish|Out-Null; Assert (Test-Path -LiteralPath $fx.State) 'state missing'; Assert ((Get-Content -LiteralPath $fx.State -Raw) -match 'schema_version') 'bad state' }
Test-Case '20 validation failure causes no target mutation' { $fx=New-Fixture; New-TextFile (Join-Path $fx.Source 'book.txt') 'missing.md'; Expect-Failure { Invoke-Tool $fx publish } 'not found'; Assert (-not(Test-Path -LiteralPath $fx.Pub)) 'target mutated' }
Test-Case '21 second publish is idempotent' { $fx=New-Fixture; Invoke-Tool $fx publish|Out-Null; $o=Invoke-Tool $fx publish; Assert ($o -match 'Publication projection is synchronized') $o; Assert (-not($o -match '^(ADD|UPDATE|DELETE) ')) $o }
Test-Case '22 SHA-256 detects same-length content change' { $fx=New-Fixture; Invoke-Tool $fx publish|Out-Null; New-TextFile (Join-Path $fx.Source 'chapter2.md') '# Tw0'; $o=Invoke-Tool $fx publish; Assert ($o -match 'UPDATE chapter2.md') $o }
Test-Case '23 dangerous source target overlap is rejected' { $fx=New-Fixture; $cfg=Get-Content -LiteralPath $fx.Config -Raw | ConvertFrom-Json; $cfg.publishing_repo_path=$fx.Source; $cfg.publishing_manuscript_path='.'; New-TextFile $fx.Config ($cfg|ConvertTo-Json); Expect-Failure { Invoke-Tool $fx status } 'must not be the repository root' }

Write-Host "Passed: $script:Passed Failed: $script:Failed"
if($script:Failed -gt 0){ exit 1 }
