param(
    [Parameter(Position=0, Mandatory=$true)]
    [ValidateSet("status","publish")]
    [string]$Action,

    [string]$ConfigPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$BookName = "The Gap"
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $scriptDirectory ".."))
$enginePath = Join-Path $repositoryRoot "protected_manuscript_sync.py"
if (-not (Test-Path -LiteralPath $enginePath -PathType Leaf)) {
    Write-Error "$BookName manuscript sync engine not found: $enginePath"
    exit 2
}
if (-not $ConfigPath) {
    $ConfigPath = Join-Path $repositoryRoot "local-only\the-gap-manuscript-sync.json"
}
$configFullPath = [System.IO.Path]::GetFullPath($ConfigPath)
if (-not (Test-Path -LiteralPath $configFullPath -PathType Leaf)) {
    Write-Error "$BookName manuscript sync config not found: $configFullPath"
    exit 2
}

$candidates = @(
    @{ Command = "py"; Prefix = @("-3") },
    @{ Command = "python"; Prefix = @() },
    @{ Command = "python3"; Prefix = @() }
)

$selected = $null
foreach ($candidate in $candidates) {
    $cmd = Get-Command $candidate.Command -ErrorAction SilentlyContinue
    if ($null -ne $cmd) { $selected = $candidate; break }
}
if ($null -eq $selected) {
    Write-Error "$BookName manuscript sync requires Python 3. Tried: py -3, python, python3."
    exit 2
}

$args = @()
$args += $selected.Prefix
$args += @($enginePath, $Action, "--config", $configFullPath)
& $selected.Command @args
exit $LASTEXITCODE
