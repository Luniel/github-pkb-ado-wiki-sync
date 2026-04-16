param(
    [Parameter(Position=0)]
    [ValidateSet("status","publish","pullback")]
    [string]$Action = "status",

    [string]$ConfigPath = (Join-Path $PSScriptRoot "sync.config.json"),
    [string]$SourcePkbPath,
    [string]$WikiRepoPath,
    [string]$StateFile,
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-NormalizedPath {
    param([Parameter(Mandatory=$true)][string]$PathValue)
    return [System.IO.Path]::GetFullPath($PathValue)
}

function Resolve-PathRelativeToBase {
    param(
        [Parameter(Mandatory=$true)][string]$PathValue,
        [Parameter(Mandatory=$true)][string]$BaseDirectory
    )

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return Get-NormalizedPath -PathValue $PathValue
    }

    return Get-NormalizedPath -PathValue (Join-Path $BaseDirectory $PathValue)
}

function Confirm-DirectoryExists {
    param([Parameter(Mandatory=$true)][string]$PathValue)
    if (-not (Test-Path -LiteralPath $PathValue -PathType Container)) {
        throw "Directory not found: $PathValue"
    }
}

function Get-DefaultStateFilePath {
    param([Parameter(Mandatory=$true)][string]$ConfigPathValue)

    $configDirectory = Split-Path -Parent $ConfigPathValue
    $configLeaf = Split-Path -Leaf $ConfigPathValue
    $configBaseName = [System.IO.Path]::GetFileNameWithoutExtension($configLeaf)

    return Join-Path $configDirectory "$configBaseName.state.json"
}

function Get-ConfigOrDefault {
    param(
        [Parameter(Mandatory=$true)][string]$ConfigPathValue,
        [string]$CliSourcePkbPath,
        [string]$CliWikiRepoPath,
        [string]$CliStateFile
    )

    $resolvedConfigPath = Get-NormalizedPath -PathValue $ConfigPathValue
    $configDirectory = Split-Path -Parent $resolvedConfigPath

    $configSource = $null
    $configWiki = $null
    $configStateFile = $null

    if (Test-Path -LiteralPath $resolvedConfigPath -PathType Leaf) {
        $raw = Get-Content -LiteralPath $resolvedConfigPath -Raw | ConvertFrom-Json

        if ($null -ne $raw.PSObject.Properties['source_pkb_path']) {
            $configSource = [string]$raw.source_pkb_path
        }
        if ($null -ne $raw.PSObject.Properties['wiki_repo_path']) {
            $configWiki = [string]$raw.wiki_repo_path
        }
        if ($null -ne $raw.PSObject.Properties['state_file']) {
            $configStateFile = [string]$raw.state_file
        }
    }

    $resolvedSource = if ($CliSourcePkbPath) { $CliSourcePkbPath } elseif ($configSource) { $configSource } else { $null }
    $resolvedWiki = if ($CliWikiRepoPath) { $CliWikiRepoPath } elseif ($configWiki) { $configWiki } else { $null }
    $resolvedStateFile = if ($CliStateFile) { $CliStateFile } elseif ($configStateFile) { $configStateFile } else { $null }

    if (-not $resolvedSource) {
        throw "No source PKB path provided. Set it in the config file or pass -SourcePkbPath."
    }
    if (-not $resolvedWiki) {
        throw "No wiki repo path provided. Set it in the config file or pass -WikiRepoPath."
    }

    $normalizedSource = Get-NormalizedPath -PathValue $resolvedSource
    $normalizedWiki = Get-NormalizedPath -PathValue $resolvedWiki

    if ($resolvedStateFile) {
        $normalizedStateFile = Resolve-PathRelativeToBase -PathValue $resolvedStateFile -BaseDirectory $configDirectory
    } else {
        $normalizedStateFile = Get-DefaultStateFilePath -ConfigPathValue $resolvedConfigPath
    }

    return [PSCustomObject]@{
        config_path = $resolvedConfigPath
        source_pkb_path = $normalizedSource
        wiki_repo_path = $normalizedWiki
        state_file = $normalizedStateFile
    }
}

function Get-CurrentSnapshot {
    param(
        [Parameter(Mandatory=$true)][string]$RootPath,
        [string]$SkipFileName = $null
    )

    $rootItem = Get-Item -LiteralPath $RootPath
    $files = Get-ChildItem -LiteralPath $RootPath -Recurse -File -Force |
        Where-Object {
            $_.FullName -notmatch '\\.git(\\|$)' -and
            ($null -eq $SkipFileName -or $_.Name -ne $SkipFileName)
        } |
        Sort-Object FullName

    $entries = foreach ($file in $files) {
        $relative = $file.FullName.Substring($rootItem.FullName.Length).TrimStart('\').Replace('\','/')
        [PSCustomObject]@{
            path = $relative
            length = [int64]$file.Length
            last_write_utc = $file.LastWriteTimeUtc.ToString("o")
        }
    }

    return @($entries)
}

function Get-StateOrDefault {
    param(
        [Parameter(Mandatory=$true)][string]$StateFilePath,
        [Parameter(Mandatory=$true)][string]$SourcePkbPathValue,
        [Parameter(Mandatory=$true)][string]$WikiRepoPathValue
    )

    if (-not (Test-Path -LiteralPath $StateFilePath -PathType Leaf)) {
        return [PSCustomObject]@{
            source_pkb_path = $SourcePkbPathValue
            wiki_repo_path = $WikiRepoPathValue
            last_sync_utc = $null
            last_direction = $null
            source_snapshot = @()
            wiki_snapshot = @()
        }
    }

    $raw = Get-Content -LiteralPath $StateFilePath -Raw | ConvertFrom-Json

    $sourceSnapshot = if ($null -ne $raw.PSObject.Properties['source_snapshot']) { @($raw.source_snapshot) } else { @() }
    $wikiSnapshot = if ($null -ne $raw.PSObject.Properties['wiki_snapshot']) { @($raw.wiki_snapshot) } else { @() }

    return [PSCustomObject]@{
        source_pkb_path = if ($null -ne $raw.PSObject.Properties['source_pkb_path']) { [string]$raw.source_pkb_path } else { $SourcePkbPathValue }
        wiki_repo_path = if ($null -ne $raw.PSObject.Properties['wiki_repo_path']) { [string]$raw.wiki_repo_path } else { $WikiRepoPathValue }
        last_sync_utc = if ($null -ne $raw.PSObject.Properties['last_sync_utc']) { $raw.last_sync_utc } else { $null }
        last_direction = if ($null -ne $raw.PSObject.Properties['last_direction']) { $raw.last_direction } else { $null }
        source_snapshot = $sourceSnapshot
        wiki_snapshot = $wikiSnapshot
    }
}

function Save-State {
    param(
        [Parameter(Mandatory=$true)][string]$StateFilePath,
        [Parameter(Mandatory=$true)][string]$SourcePkbPathValue,
        [Parameter(Mandatory=$true)][string]$WikiRepoPathValue,
        [Parameter(Mandatory=$true)][string]$Direction,
        [Parameter(Mandatory=$true)][array]$SourceSnapshot,
        [Parameter(Mandatory=$true)][array]$WikiSnapshot
    )

    $stateDirectory = Split-Path -Parent $StateFilePath
    if (-not (Test-Path -LiteralPath $stateDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $stateDirectory -Force | Out-Null
    }

    $state = [PSCustomObject]@{
        source_pkb_path = $SourcePkbPathValue
        wiki_repo_path = $WikiRepoPathValue
        last_sync_utc = (Get-Date).ToUniversalTime().ToString("o")
        last_direction = $Direction
        source_snapshot = $SourceSnapshot
        wiki_snapshot = $WikiSnapshot
    }

    $state | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $StateFilePath -Encoding UTF8
}

function Get-ChangedPathSet {
    param(
        [Parameter(Mandatory=$true)]
        [AllowEmptyCollection()]
        [array]$BaselineSnapshot,

        [Parameter(Mandatory=$true)]
        [AllowEmptyCollection()]
        [array]$CurrentSnapshot
    )

    if ($null -eq $BaselineSnapshot) { $BaselineSnapshot = @() }
    if ($null -eq $CurrentSnapshot) { $CurrentSnapshot = @() }

    $baselineMap = @{}
    foreach ($entry in $BaselineSnapshot) {
        $baselineMap[[string]$entry.path] = $entry
    }

    $currentMap = @{}
    foreach ($entry in $CurrentSnapshot) {
        $currentMap[[string]$entry.path] = $entry
    }

    $allPaths = @($baselineMap.Keys + $currentMap.Keys | Sort-Object -Unique)
    $changed = New-Object System.Collections.Generic.List[string]

    foreach ($path in $allPaths) {
        $hasBaseline = $baselineMap.ContainsKey($path)
        $hasCurrent = $currentMap.ContainsKey($path)

        if ($hasBaseline -ne $hasCurrent) {
            [void]$changed.Add($path)
            continue
        }

        $b = $baselineMap[$path]
        $c = $currentMap[$path]

        if (($b.length -ne $c.length) -or ([string]$b.last_write_utc -ne [string]$c.last_write_utc)) {
            [void]$changed.Add($path)
        }
    }

    return @($changed | Sort-Object -Unique)
}

function Sync-DirectoryContents {
    param(
        [Parameter(Mandatory=$true)][string]$FromPath,
        [Parameter(Mandatory=$true)][string]$ToPath,
        [string]$ProtectedFileName = $null
    )

    $fromRoot = (Get-Item -LiteralPath $FromPath).FullName
    $toRoot = (Get-Item -LiteralPath $ToPath).FullName

    $sourceFiles = Get-ChildItem -LiteralPath $FromPath -Recurse -File -Force |
        Where-Object {
            $_.FullName -notmatch '\\.git(\\|$)' -and
            ($null -eq $ProtectedFileName -or $_.Name -ne $ProtectedFileName)
        }

    foreach ($file in $sourceFiles) {
        $relative = $file.FullName.Substring($fromRoot.Length).TrimStart('\')
        $dest = Join-Path $ToPath $relative
        $destDir = Split-Path -Parent $dest
        if (-not (Test-Path -LiteralPath $destDir -PathType Container)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        Copy-Item -LiteralPath $file.FullName -Destination $dest -Force
    }

    $destFiles = Get-ChildItem -LiteralPath $ToPath -Recurse -File -Force |
        Where-Object {
            $_.FullName -notmatch '\\.git(\\|$)' -and
            ($null -eq $ProtectedFileName -or $_.Name -ne $ProtectedFileName)
        }

    foreach ($destFile in $destFiles) {
        $relative = $destFile.FullName.Substring($toRoot.Length).TrimStart('\').Replace('\','/')
        $sourceEquivalent = Join-Path $FromPath ($relative.Replace('/','\'))
        if (-not (Test-Path -LiteralPath $sourceEquivalent -PathType Leaf)) {
            Remove-Item -LiteralPath $destFile.FullName -Force
        }
    }

    $destDirs = Get-ChildItem -LiteralPath $ToPath -Recurse -Directory -Force |
        Where-Object { $_.FullName -notmatch '\\.git(\\|$)' } |
        Sort-Object FullName -Descending

    foreach ($destDir in $destDirs) {
        $remaining = Get-ChildItem -LiteralPath $destDir.FullName -Force
        if ($remaining.Count -eq 0) {
            Remove-Item -LiteralPath $destDir.FullName -Force
        }
    }
}

$config = Get-ConfigOrDefault -ConfigPathValue $ConfigPath -CliSourcePkbPath $SourcePkbPath -CliWikiRepoPath $WikiRepoPath -CliStateFile $StateFile
$ConfigPath = $config.config_path
$SourcePkbPath = $config.source_pkb_path
$WikiRepoPath = $config.wiki_repo_path
$stateFilePath = $config.state_file
$stateFileName = [System.IO.Path]::GetFileName($stateFilePath)

Confirm-DirectoryExists -PathValue $SourcePkbPath
Confirm-DirectoryExists -PathValue $WikiRepoPath

$hasExistingState = Test-Path -LiteralPath $stateFilePath -PathType Leaf
$state = Get-StateOrDefault -StateFilePath $stateFilePath -SourcePkbPathValue $SourcePkbPath -WikiRepoPathValue $WikiRepoPath

$currentSourceSnapshot = Get-CurrentSnapshot -RootPath $SourcePkbPath -SkipFileName $stateFileName
$currentWikiSnapshot = Get-CurrentSnapshot -RootPath $WikiRepoPath -SkipFileName $stateFileName

$changedSource = @(Get-ChangedPathSet -BaselineSnapshot $state.source_snapshot -CurrentSnapshot $currentSourceSnapshot)
$changedWiki = @(Get-ChangedPathSet -BaselineSnapshot $state.wiki_snapshot -CurrentSnapshot $currentWikiSnapshot)

$conflicts = @()
if ($hasExistingState) {
    foreach ($path in $changedSource) {
        if ($path -in $changedWiki) {
            $conflicts += $path
        }
    }
}
$conflicts = @($conflicts | Sort-Object -Unique)

switch ($Action) {
    "status" {
        Write-Host "Config file: $ConfigPath"
        Write-Host "Source PKB:  $SourcePkbPath"
        Write-Host "Wiki repo:   $WikiRepoPath"
        Write-Host "State file:  $stateFilePath"
        if ($state.last_sync_utc) {
            Write-Host "Last sync:   $($state.last_sync_utc) ($($state.last_direction))"
        } else {
            Write-Host "Last sync:   <none>"
        }
        Write-Host ""
        if (-not $hasExistingState) {
            Write-Host "Sync state:  uninitialized"
            Write-Host "Note: first publish/pullback will establish the baseline state."
            Write-Host ""
        }
        Write-Host "Changed since last sync:"
        Write-Host "- Source PKB side: $($changedSource.Count)"
        Write-Host "- Wiki repo side:  $($changedWiki.Count)"
        Write-Host "- Conflicts:       $($conflicts.Count)"

        if ($conflicts.Count -gt 0) {
            Write-Host ""
            Write-Host "Conflicting paths:" -ForegroundColor Yellow
            $conflicts | ForEach-Object { Write-Host "- $_" }
        }
        break
    }

    "publish" {
        if ($conflicts.Count -gt 0 -and -not $Force) {
            throw "Conflicts detected. Use 'status' to inspect or rerun with -Force if you intentionally want source PKB to win."
        }

        Sync-DirectoryContents -FromPath $SourcePkbPath -ToPath $WikiRepoPath -ProtectedFileName $stateFileName

        $newSourceSnapshot = Get-CurrentSnapshot -RootPath $SourcePkbPath -SkipFileName $stateFileName
        $newWikiSnapshot = Get-CurrentSnapshot -RootPath $WikiRepoPath -SkipFileName $stateFileName
        Save-State -StateFilePath $stateFilePath -SourcePkbPathValue $SourcePkbPath -WikiRepoPathValue $WikiRepoPath -Direction "publish" -SourceSnapshot $newSourceSnapshot -WikiSnapshot $newWikiSnapshot
        Write-Host "Published PKB to ADO Wiki repo."
        break
    }

    "pullback" {
        if ($conflicts.Count -gt 0 -and -not $Force) {
            throw "Conflicts detected. Use 'status' to inspect or rerun with -Force if you intentionally want wiki repo to win."
        }

        Sync-DirectoryContents -FromPath $WikiRepoPath -ToPath $SourcePkbPath -ProtectedFileName $stateFileName

        $newSourceSnapshot = Get-CurrentSnapshot -RootPath $SourcePkbPath -SkipFileName $stateFileName
        $newWikiSnapshot = Get-CurrentSnapshot -RootPath $WikiRepoPath -SkipFileName $stateFileName
        Save-State -StateFilePath $stateFilePath -SourcePkbPathValue $SourcePkbPath -WikiRepoPathValue $WikiRepoPath -Direction "pullback" -SourceSnapshot $newSourceSnapshot -WikiSnapshot $newWikiSnapshot
        Write-Host "Pulled wiki repo changes back into PKB source folder."
        break
    }
}