Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Wrapper = Join-Path $RepoRoot "launchers\the-gap-manuscript-sync.ps1"
$TempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("wrapper spaces " + [guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $TempRoot | Out-Null
$Passed = 0; $Failed = 0
function Assert-True($Condition, $Name) { if ($Condition) { $script:Passed++; Write-Host "PASS $Name" } else { $script:Failed++; Write-Host "FAIL $Name" } }
function New-Repo($Path) { New-Item -ItemType Directory -Path $Path | Out-Null; New-Item -ItemType Directory -Path (Join-Path $Path ".git") | Out-Null }
function Write-Utf8Bom($Path,$Text) { $enc = New-Object System.Text.UTF8Encoding($true); [System.IO.File]::WriteAllText($Path,$Text,$enc) }
function Write-AsciiCmd($Path,$Text) { $enc = [System.Text.Encoding]::ASCII; [System.IO.File]::WriteAllText($Path,$Text,$enc) }
function Write-Config($Source,$Target,$Config,$State) { $json = @{ schema_version=1; source_repo_path=$Source; publishing_repo_path=$Target; expected_target_id='the-gap-publishing'; state_file=$State } | ConvertTo-Json; Write-Utf8Bom $Config $json }
function Invoke-Script($Script,$Action,$Config,$ExtraEnv) {
    $out = Join-Path $TempRoot ([guid]::NewGuid().ToString()+'.out')
    $err = Join-Path $TempRoot ([guid]::NewGuid().ToString()+'.err')
    $oldPath = $env:PATH
    if ($ExtraEnv -and $ExtraEnv.ContainsKey('PATH')) { $env:PATH = $ExtraEnv['PATH'] }
    try {
        if ($Config) { & $Script $Action -ConfigPath $Config > $out 2> $err } else { & $Script $Action > $out 2> $err }
        $code = $LASTEXITCODE
    } finally { $env:PATH = $oldPath }
    [pscustomobject]@{ Code=$code; Out=(Get-Content -LiteralPath $out -Raw -ErrorAction SilentlyContinue); Err=(Get-Content -LiteralPath $err -Raw -ErrorAction SilentlyContinue) }
}
function New-CopiedWrapperRepo($ExitCode) {
    $fakeRoot = Join-Path $TempRoot ("fake " + [guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path (Join-Path $fakeRoot 'launchers') | Out-Null
    Copy-Item -LiteralPath $Wrapper -Destination (Join-Path $fakeRoot 'launchers\the-gap-manuscript-sync.ps1')
    $engine = @"
import sys
print('stub stdout')
print('stub stderr', file=sys.stderr)
sys.exit($ExitCode)
"@
    Set-Content -LiteralPath (Join-Path $fakeRoot 'protected_manuscript_sync.py') -Value $engine -Encoding UTF8
    [pscustomobject]@{ Root=$fakeRoot; Wrapper=(Join-Path $fakeRoot 'launchers\the-gap-manuscript-sync.ps1') }
}
try {
    $src=Join-Path $TempRoot 'source repo'; $pub=Join-Path $TempRoot 'publishing repo'; New-Repo $src; New-Repo $pub
    New-Item -ItemType Directory -Path (Join-Path $src 'manuscript') | Out-Null
    Set-Content -LiteralPath (Join-Path $src 'manuscript\book.txt') -Value 'book' -Encoding UTF8
    Write-Utf8Bom (Join-Path $pub '.protected-manuscript-publishing-target') "the-gap-publishing`r`n"
    $cfg=Join-Path $TempRoot 'config file.json'; $state=Join-Path $TempRoot 'state file.json'; Write-Config $src $pub $cfg $state
    $r=Invoke-Script $Wrapper 'status' $cfg $null; Assert-True ($r.Code -eq 0 -and $r.Out -match 'Action: status') 'BOM config and marker work; status stdout and exit 0 preserved; paths with spaces work'
    $r=Invoke-Script $Wrapper 'publish' $cfg $null; Assert-True ($r.Code -eq 0 -and (Test-Path (Join-Path $pub 'manuscript\book.txt'))) 'wrapper accepts publish and invokes engine'
    Set-Content -LiteralPath (Join-Path $pub 'manuscript\target.md') -Value 'target' -Encoding UTF8
    $r=Invoke-Script $Wrapper 'status' $cfg $null; Assert-True ($r.Code -eq 3 -and $r.Err -match 'Classification: blocked-target-only-divergence' -and $r.Err -match 'No mutation performed') 'engine exit code 3 and blocked report stderr preserved'
    Remove-Item -LiteralPath (Join-Path $pub '.protected-manuscript-publishing-target')
    $r=Invoke-Script $Wrapper 'status' $cfg $null; Assert-True ($r.Code -eq 2 -and $r.Err -match 'marker') 'engine exit code 2 preserved'
    $r=Invoke-Script $Wrapper 'status' $null $null; Assert-True ($r.Code -eq 2 -and $r.Err -match 'config not found') 'missing default config returns exact 2 with clear stderr'
    $badOut = Join-Path $TempRoot 'unsupported.out'; $badErr = Join-Path $TempRoot 'unsupported.err'; & $Wrapper unsupported -ConfigPath $cfg > $badOut 2> $badErr; $unsupportedCode = $LASTEXITCODE; Assert-True ($unsupportedCode -ne 0) 'unsupported action remains nonzero'
    $fake=New-CopiedWrapperRepo 4; $fakeCfg=Join-Path $fake.Root 'c.json'; Set-Content -LiteralPath $fakeCfg -Value '{}' -Encoding UTF8
    $r=Invoke-Script $fake.Wrapper 'status' $fakeCfg $null; Assert-True ($r.Code -eq 4 -and $r.Out -match 'stub stdout' -and $r.Err -match 'stub stderr') 'engine exit code 4 stdout stderr preserved'
    Remove-Item -LiteralPath (Join-Path $fake.Root 'protected_manuscript_sync.py')
    $r=Invoke-Script $fake.Wrapper 'status' $fakeCfg $null; Assert-True ($r.Code -eq 2 -and $r.Err -match 'engine not found') 'missing engine returns exact 2'
    $fake=New-CopiedWrapperRepo 0; $fakeCfg=Join-Path $fake.Root 'c.json'; Set-Content -LiteralPath $fakeCfg -Value '{}' -Encoding UTF8
    $bin=Join-Path $TempRoot 'fakebin'; New-Item -ItemType Directory -Path $bin | Out-Null
    foreach ($cmd in @('py.cmd','python.cmd','python3.cmd')) { Write-AsciiCmd (Join-Path $bin $cmd) "@echo off`r`nexit /b 1`r`n"; & (Join-Path $bin $cmd) > $null 2> $null; Assert-True ($LASTEXITCODE -ne 0) "fake failing $cmd returns nonzero directly" }
    $r=Invoke-Script $fake.Wrapper 'status' $fakeCfg @{ PATH=$bin }; Assert-True ($r.Code -eq 2 -and $r.Err -match 'usable Python 3') 'no usable Python 3 returns exact 2'
    $realPython = (Get-Command python -ErrorAction SilentlyContinue).Source
    if ($realPython) {
        Write-AsciiCmd (Join-Path $bin 'py.cmd') "@echo off`r`nexit /b 1`r`n"
        Write-AsciiCmd (Join-Path $bin 'python.cmd') "@echo off`r`nexit /b 1`r`n"
        & (Join-Path $bin 'py.cmd') > $null 2> $null; $pyFailed = ($LASTEXITCODE -ne 0)
        & (Join-Path $bin 'python.cmd') > $null 2> $null; $pythonFailed = ($LASTEXITCODE -ne 0)
        Write-AsciiCmd (Join-Path $bin 'python3.cmd') "@echo off`r`nset WRAPPER_FALLBACK_REACHED=1`r`n`"$realPython`" %*`r`n"
        $r=Invoke-Script $fake.Wrapper 'status' $fakeCfg @{ PATH=$bin }; Assert-True ($pyFailed -and $pythonFailed -and $r.Code -eq 0 -and $r.Out -match 'stub stdout') 'unusable earlier candidates fall back to next usable Python 3'
    } else { Write-Host 'SKIP fallback test: no python command path available' }
    Assert-True (-not (Test-Path (Join-Path $RepoRoot 'manuscript'))) 'no real repository is touched'
}
finally { Remove-Item -LiteralPath $TempRoot -Recurse -Force -ErrorAction SilentlyContinue }
Write-Host "Passed: $Passed Failed: $Failed"
if ($Failed -gt 0) { exit 1 }
