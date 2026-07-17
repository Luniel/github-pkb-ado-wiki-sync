Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Wrapper = Join-Path $RepoRoot "launchers\the-gap-manuscript-sync.ps1"
$TempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("wrapper spaces " + [guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $TempRoot | Out-Null
$Passed = 0; $Failed = 0
function Assert-True($Condition, $Name) { if ($Condition) { $script:Passed++; Write-Host "PASS $Name" } else { $script:Failed++; Write-Host "FAIL $Name" } }
function New-Repo($Path) { New-Item -ItemType Directory -Path $Path | Out-Null; New-Item -ItemType Directory -Path (Join-Path $Path ".git") | Out-Null }
function Write-Config($Source,$Target,$Config,$State) { @{ schema_version=1; source_repo_path=$Source; publishing_repo_path=$Target; expected_target_id='the-gap-publishing'; state_file=$State } | ConvertTo-Json | Set-Content -LiteralPath $Config -Encoding UTF8 }
function Invoke-Wrapper($Action,$Config) {
    $out = Join-Path $TempRoot ([guid]::NewGuid().ToString()+'.out')
    $err = Join-Path $TempRoot ([guid]::NewGuid().ToString()+'.err')
    if ($Config) { & $Wrapper $Action -ConfigPath $Config > $out 2> $err } else { & $Wrapper $Action > $out 2> $err }
    [pscustomobject]@{ Code=$LASTEXITCODE; Out=(Get-Content -LiteralPath $out -Raw -ErrorAction SilentlyContinue); Err=(Get-Content -LiteralPath $err -Raw -ErrorAction SilentlyContinue) }
}
try {
    $src=Join-Path $TempRoot 'source repo'; $pub=Join-Path $TempRoot 'publishing repo'; New-Repo $src; New-Repo $pub
    New-Item -ItemType Directory -Path (Join-Path $src 'manuscript') | Out-Null
    Set-Content -LiteralPath (Join-Path $src 'manuscript\book.txt') -Value 'book' -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $pub '.protected-manuscript-publishing-target') -Value 'the-gap-publishing' -Encoding UTF8
    $cfg=Join-Path $TempRoot 'config file.json'; $state=Join-Path $TempRoot 'state file.json'; Write-Config $src $pub $cfg $state
    $r=Invoke-Wrapper 'status' $cfg; Assert-True ($r.Code -eq 0 -and $r.Out -match 'Action: status') 'wrapper accepts status, ConfigPath, stdout, exit 0, paths with spaces'
    $r=Invoke-Wrapper 'publish' $cfg; Assert-True ($r.Code -eq 0 -and (Test-Path (Join-Path $pub 'manuscript\book.txt'))) 'wrapper accepts publish and invokes engine'
    Set-Content -LiteralPath (Join-Path $pub 'manuscript\target.md') -Value 'target' -Encoding UTF8
    $r=Invoke-Wrapper 'status' $cfg; Assert-True ($r.Code -eq 3 -and $r.Err -match 'Target-only') 'wrapper returns engine exit code 3 and stderr'
    Remove-Item -LiteralPath (Join-Path $pub '.protected-manuscript-publishing-target')
    $r=Invoke-Wrapper 'status' $cfg; Assert-True ($r.Code -eq 2 -and $r.Err -match 'marker') 'wrapper returns engine exit code 2'
    $r=Invoke-Wrapper 'status' $null; Assert-True ($r.Code -eq 2 -and $r.Err -match 'config not found') 'default config-missing error is clear'
    & $Wrapper unsupported -ConfigPath $cfg >$null 2>$null; Assert-True ($LASTEXITCODE -ne 0) 'wrapper rejects unsupported actions'
    Assert-True (-not (Test-Path (Join-Path $RepoRoot 'manuscript'))) 'no repository outside disposable test trees is touched'
}
finally { Remove-Item -LiteralPath $TempRoot -Recurse -Force -ErrorAction SilentlyContinue }
Write-Host "Passed: $Passed Failed: $Failed"
if ($Failed -gt 0) { exit 1 }
