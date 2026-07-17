param(
    [Parameter(Position=0, Mandatory=$true)]
    [ValidateSet("status","publish")]
    [string]$Action,

    [string]$ConfigPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Fail-Wrapper {
    param([string]$Message)
    [Console]::Error.WriteLine($Message)
    exit 2
}

$BookName = "The Gap"
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $scriptDirectory ".."))
$enginePath = Join-Path $repositoryRoot "protected_manuscript_sync.py"
if (-not (Test-Path -LiteralPath $enginePath -PathType Leaf)) {
    Fail-Wrapper "$BookName manuscript sync engine not found: $enginePath"
}
if (-not $ConfigPath) {
    $ConfigPath = Join-Path $repositoryRoot "local-only\the-gap-manuscript-sync.json"
}
$configFullPath = [System.IO.Path]::GetFullPath($ConfigPath)
if (-not (Test-Path -LiteralPath $configFullPath -PathType Leaf)) {
    Fail-Wrapper "$BookName manuscript sync config not found: $configFullPath"
}

$candidates = @(
    @{ Command = "py"; Prefix = @("-3") },
    @{ Command = "python"; Prefix = @() },
    @{ Command = "python3"; Prefix = @() }
)

$selected = $null
foreach ($candidate in $candidates) {
    $cmd = Get-Command $candidate.Command -ErrorAction SilentlyContinue
    if ($null -eq $cmd) { continue }
    $versionArgs = @()
    $versionArgs += $candidate.Prefix
    $versionArgs += @("-c", "import sys; raise SystemExit(0 if sys.version_info[0] == 3 else 1)")
    & $candidate.Command @versionArgs > $null 2> $null
    if ($LASTEXITCODE -eq 0) { $selected = $candidate; break }
}
if ($null -eq $selected) {
    Fail-Wrapper "$BookName manuscript sync requires a usable Python 3 interpreter. Tried: py -3, python, python3."
}

$args = @()
$args += $selected.Prefix
$args += @($enginePath, $Action, "--config", $configFullPath)
& $selected.Command @args
exit $LASTEXITCODE
