param(
    [Parameter(Position = 0)]
    [ValidateSet("status", "publish")]
    [string]$Action = "status",

    [string]$ConfigPath = (Join-Path $PSScriptRoot "sync.leanpub.config.json"),
    [string]$SourceManuscriptPath,
    [string]$PublishingRepoPath,
    [string]$PublishingManuscriptPath,
    [string]$SpineFile,
    [string]$StateFile
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SyncToolRoot = [System.IO.Path]::GetFullPath($PSScriptRoot)

function Get-FullPathValue {
    param([Parameter(Mandatory = $true)][string]$PathValue)
    return [System.IO.Path]::GetFullPath($PathValue)
}

function Join-FullPath {
    param(
        [Parameter(Mandatory = $true)][string]$BasePath,
        [Parameter(Mandatory = $true)][string]$ChildPath
    )

    if ([System.IO.Path]::IsPathRooted($ChildPath)) {
        return Get-FullPathValue -PathValue $ChildPath
    }

    return Get-FullPathValue -PathValue (Join-Path -Path $BasePath -ChildPath $ChildPath)
}

function Convert-ToManifestPath {
    param([Parameter(Mandatory = $true)][string]$PathValue)
    return ($PathValue -replace '\\', '/').TrimStart('/')
}

function Get-PathKey {
    param([Parameter(Mandatory = $true)][string]$PathValue)
    return (Convert-ToManifestPath -PathValue $PathValue).ToLowerInvariant()
}

function Test-PathInsideOrEqual {
    param(
        [Parameter(Mandatory = $true)][string]$ChildPath,
        [Parameter(Mandatory = $true)][string]$RootPath
    )

    $child = (Get-FullPathValue -PathValue $ChildPath).TrimEnd('\', '/')
    $root = (Get-FullPathValue -PathValue $RootPath).TrimEnd('\', '/')

    if ($child.Equals($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $true
    }

    return $child.StartsWith($root + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase) -or
        $child.StartsWith($root + [System.IO.Path]::AltDirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)
}

function Test-PathStrictlyInside {
    param(
        [Parameter(Mandatory = $true)][string]$ChildPath,
        [Parameter(Mandatory = $true)][string]$RootPath
    )

    $child = (Get-FullPathValue -PathValue $ChildPath).TrimEnd('\', '/')
    $root = (Get-FullPathValue -PathValue $RootPath).TrimEnd('\', '/')

    return -not $child.Equals($root, [System.StringComparison]::OrdinalIgnoreCase) -and
        (Test-PathInsideOrEqual -ChildPath $child -RootPath $root)
}

function Assert-PathInsideOrEqual {
    param(
        [Parameter(Mandatory = $true)][string]$ChildPath,
        [Parameter(Mandatory = $true)][string]$RootPath,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if (-not (Test-PathInsideOrEqual -ChildPath $ChildPath -RootPath $RootPath)) {
        throw "$Label resolves outside approved root: $ChildPath"
    }
}

function Test-UnsafeRelativePath {
    param([Parameter(Mandatory = $true)][string]$PathValue)

    if ([string]::IsNullOrWhiteSpace($PathValue)) {
        return $true
    }

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return $true
    }

    if ($PathValue -match '^[A-Za-z]:') {
        return $true
    }

    if ($PathValue.StartsWith('\\')) {
        return $true
    }

    $segments = ($PathValue -replace '\\', '/').Split('/')
    return @($segments | Where-Object { $_ -eq '..' }).Count -gt 0
}

function Normalize-SafeRelativePath {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [Parameter(Mandatory = $true)][string]$BasePath,
        [Parameter(Mandatory = $true)][string]$Label
    )

    if (Test-UnsafeRelativePath -PathValue $RelativePath) {
        throw "Unsafe $Label path: $RelativePath"
    }

    $fullPath = Join-FullPath -BasePath $BasePath -ChildPath $RelativePath
    Assert-PathInsideOrEqual -ChildPath $fullPath -RootPath $BasePath -Label $Label

    $root = (Get-FullPathValue -PathValue $BasePath).TrimEnd('\', '/')
    $relative = $fullPath.Substring($root.Length).TrimStart('\', '/')
    return Convert-ToManifestPath -PathValue $relative
}

function Confirm-DirectoryExists {
    param([Parameter(Mandatory = $true)][string]$PathValue)

    if (-not (Test-Path -LiteralPath $PathValue -PathType Container)) {
        throw "Directory not found: $PathValue"
    }
}

function Get-JsonProperty {
    param(
        [Parameter(Mandatory = $true)]$JsonObject,
        [Parameter(Mandatory = $true)][string]$Name
    )

    if ($null -ne $JsonObject.PSObject.Properties[$Name]) {
        return [string]$JsonObject.PSObject.Properties[$Name].Value
    }

    return $null
}

function Get-DefaultStateFilePath {
    param([Parameter(Mandatory = $true)][string]$ResolvedConfigPath)

    $configDirectory = Split-Path -Parent $ResolvedConfigPath
    $configLeaf = Split-Path -Leaf $ResolvedConfigPath
    $configBaseName = [System.IO.Path]::GetFileNameWithoutExtension($configLeaf)
    return Join-Path -Path $configDirectory -ChildPath "$configBaseName.state.json"
}

function Find-ContainingGitRoot {
    param([Parameter(Mandatory = $true)][string]$StartPath)

    $current = Get-FullPathValue -PathValue $StartPath
    if (Test-Path -LiteralPath $current -PathType Leaf) {
        $current = Split-Path -Parent $current
    }

    while ($current) {
        if (Test-Path -LiteralPath (Join-Path -Path $current -ChildPath '.git')) {
            return $current
        }

        $parent = Split-Path -Parent $current
        if ([string]::IsNullOrWhiteSpace($parent) -or $parent -eq $current) {
            return $null
        }

        $current = $parent
    }

    return $null
}

function Get-LeanpubConfig {
    param(
        [Parameter(Mandatory = $true)][string]$ConfigPathValue,
        [string]$CliSourceManuscriptPath,
        [string]$CliPublishingRepoPath,
        [string]$CliPublishingManuscriptPath,
        [string]$CliSpineFile,
        [string]$CliStateFile
    )

    $resolvedConfigPath = Get-FullPathValue -PathValue $ConfigPathValue
    $configDirectory = Split-Path -Parent $resolvedConfigPath

    if (-not (Test-Path -LiteralPath $resolvedConfigPath -PathType Leaf)) {
        throw "Config file not found: $resolvedConfigPath"
    }

    try {
        $rawConfig = Get-Content -LiteralPath $resolvedConfigPath -Raw | ConvertFrom-Json
    }
    catch {
        throw "Malformed JSON config '$resolvedConfigPath': $($_.Exception.Message)"
    }

    $sourceManuscriptPathValue = if ($CliSourceManuscriptPath) { $CliSourceManuscriptPath } else { Get-JsonProperty -JsonObject $rawConfig -Name 'source_manuscript_path' }
    $publishingRepoPathValue = if ($CliPublishingRepoPath) { $CliPublishingRepoPath } else { Get-JsonProperty -JsonObject $rawConfig -Name 'publishing_repo_path' }
    $publishingManuscriptPathValue = if ($CliPublishingManuscriptPath) { $CliPublishingManuscriptPath } else { Get-JsonProperty -JsonObject $rawConfig -Name 'publishing_manuscript_path' }
    $spineFileValue = if ($CliSpineFile) { $CliSpineFile } else { Get-JsonProperty -JsonObject $rawConfig -Name 'spine_file' }
    $stateFileValue = if ($CliStateFile) { $CliStateFile } else { Get-JsonProperty -JsonObject $rawConfig -Name 'state_file' }

    $requiredValues = @{
        source_manuscript_path = $sourceManuscriptPathValue
        publishing_repo_path = $publishingRepoPathValue
        publishing_manuscript_path = $publishingManuscriptPathValue
        spine_file = $spineFileValue
    }

    foreach ($name in @($requiredValues.Keys | Sort-Object)) {
        if ([string]::IsNullOrWhiteSpace($requiredValues[$name])) {
            throw "Missing required config value: $name"
        }
    }

    if (Test-UnsafeRelativePath -PathValue $publishingManuscriptPathValue) {
        throw "publishing_manuscript_path must be a safe relative path: $publishingManuscriptPathValue"
    }

    if (Test-UnsafeRelativePath -PathValue $spineFileValue) {
        throw "spine_file must be a safe relative path: $spineFileValue"
    }

    $sourceManuscriptFullPath = Get-FullPathValue -PathValue $sourceManuscriptPathValue
    $publishingRepoFullPath = Get-FullPathValue -PathValue $publishingRepoPathValue
    $publishingManuscriptFullPath = Join-FullPath -BasePath $publishingRepoFullPath -ChildPath $publishingManuscriptPathValue
    $spineRelativePath = Normalize-SafeRelativePath -RelativePath $spineFileValue -BasePath $sourceManuscriptFullPath -Label 'spine_file'
    $spineFullPath = Join-FullPath -BasePath $sourceManuscriptFullPath -ChildPath $spineRelativePath

    if ($stateFileValue) {
        $stateFileFullPath = Join-FullPath -BasePath $configDirectory -ChildPath $stateFileValue
    }
    else {
        $stateFileFullPath = Get-DefaultStateFilePath -ResolvedConfigPath $resolvedConfigPath
    }

    return [PSCustomObject]@{
        config_path = $resolvedConfigPath
        config_directory = $configDirectory
        source_manuscript_path = $sourceManuscriptFullPath
        source_repo_path = $null
        publishing_repo_path = $publishingRepoFullPath
        publishing_manuscript_path = $publishingManuscriptFullPath
        publishing_manuscript_relative = Convert-ToManifestPath -PathValue $publishingManuscriptPathValue
        spine_file = $spineRelativePath
        spine_path = $spineFullPath
        state_file = $stateFileFullPath
    }
}

function Test-ReparsePoint {
    param([Parameter(Mandatory = $true)][string]$PathValue)

    if (-not (Test-Path -LiteralPath $PathValue)) {
        return $false
    }

    $item = Get-Item -LiteralPath $PathValue -Force
    return (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)
}

function Assert-NoReparsePointInExistingPath {
    param(
        [Parameter(Mandatory = $true)][string]$FullPath,
        [Parameter(Mandatory = $true)][string]$RootPath,
        [Parameter(Mandatory = $true)][string]$Label
    )

    Assert-PathInsideOrEqual -ChildPath $FullPath -RootPath $RootPath -Label $Label

    $root = (Get-FullPathValue -PathValue $RootPath).TrimEnd('\', '/')
    $target = Get-FullPathValue -PathValue $FullPath
    $current = $root

    if (Test-ReparsePoint -PathValue $current) {
        throw "$Label path includes a reparse point or symbolic link: $current"
    }

    $relative = $target.Substring($root.Length).TrimStart('\', '/')
    foreach ($part in (($relative -replace '\\', '/').Split('/') | Where-Object { $_ })) {
        $current = Join-Path -Path $current -ChildPath $part
        if (Test-Path -LiteralPath $current) {
            if (Test-ReparsePoint -PathValue $current) {
                throw "$Label path includes a reparse point or symbolic link: $current"
            }
        }
    }
}

function Confirm-StateFileSafety {
    param([Parameter(Mandatory = $true)]$Config)

    $statePath = Get-FullPathValue -PathValue $Config.state_file

    if (-not (Test-PathStrictlyInside -ChildPath $statePath -RootPath $SyncToolRoot)) {
        throw "Unsafe state_file location '$statePath'. Store local Leanpub sync state under the sync-tool repository, preferably configs/."
    }

    $protectedRoots = New-Object System.Collections.Generic.List[string]
    $protectedRoots.Add($Config.source_manuscript_path)
    $protectedRoots.Add($Config.publishing_manuscript_path)
    $protectedRoots.Add($Config.publishing_repo_path)

    $sourceRepoRoot = Find-ContainingGitRoot -StartPath $Config.source_manuscript_path
    if ($sourceRepoRoot) {
        $Config.source_repo_path = $sourceRepoRoot
        $protectedRoots.Add($sourceRepoRoot)
    }

    foreach ($root in @($protectedRoots | Sort-Object -Unique)) {
        if (Test-PathInsideOrEqual -ChildPath $statePath -RootPath $root) {
            throw "Unsafe state_file location '$statePath'. It is inside protected repository/content root '$root'."
        }
    }
}

function Confirm-RepositoryAndPathSafety {
    param(
        [Parameter(Mandatory = $true)]$Config,
        [switch]$RequirePublishingGit
    )

    Confirm-DirectoryExists -PathValue $Config.source_manuscript_path
    Confirm-DirectoryExists -PathValue $Config.publishing_repo_path

    if ($RequirePublishingGit -and -not (Test-Path -LiteralPath (Join-Path -Path $Config.publishing_repo_path -ChildPath '.git'))) {
        throw "Publishing repository is not a Git working tree (missing .git file or directory): $($Config.publishing_repo_path)"
    }

    if (-not (Test-PathStrictlyInside -ChildPath $Config.publishing_manuscript_path -RootPath $Config.publishing_repo_path)) {
        throw "Publishing manuscript path must be a child of the publishing repository, not the repository root: $($Config.publishing_manuscript_path)"
    }

    Assert-NoReparsePointInExistingPath -FullPath $Config.publishing_manuscript_path -RootPath $Config.publishing_repo_path -Label 'Publishing manuscript'

    $sourceRepoRoot = Find-ContainingGitRoot -StartPath $Config.source_manuscript_path
    if ($sourceRepoRoot) {
        $Config.source_repo_path = $sourceRepoRoot
    }

    $overlapPairs = @(
        @($Config.publishing_manuscript_path, $Config.source_manuscript_path, 'publishing manuscript is inside source manuscript'),
        @($Config.source_manuscript_path, $Config.publishing_manuscript_path, 'source manuscript is inside publishing manuscript'),
        @($Config.publishing_repo_path, $Config.source_manuscript_path, 'publishing repository is inside source manuscript'),
        @($Config.source_manuscript_path, $Config.publishing_repo_path, 'source manuscript is inside publishing repository')
    )

    if ($Config.source_repo_path) {
        $overlapPairs += ,@($Config.publishing_repo_path, $Config.source_repo_path, 'publishing repository is inside source repository')
    }

    foreach ($pair in $overlapPairs) {
        if (Test-PathInsideOrEqual -ChildPath $pair[0] -RootPath $pair[1]) {
            throw "Dangerous source/target overlap rejected: $($pair[2]) ('$($pair[0])' and '$($pair[1])')."
        }
    }
}

function Get-HashEntry {
    param(
        [Parameter(Mandatory = $true)][string]$FullPath,
        [Parameter(Mandatory = $true)][string]$RelativePath
    )

    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    try {
        $stream = [System.IO.File]::OpenRead($FullPath)
        try {
            $hashBytes = $sha256.ComputeHash($stream)
        }
        finally {
            $stream.Dispose()
        }
    }
    finally {
        $sha256.Dispose()
    }

    $file = Get-Item -LiteralPath $FullPath -Force
    if (($file.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "Refusing to hash reparse point or symbolic link: $FullPath"
    }

    return [PSCustomObject]@{
        path = Convert-ToManifestPath -PathValue $RelativePath
        length = [int64]$file.Length
        sha256 = ([System.BitConverter]::ToString($hashBytes).Replace('-', '').ToLowerInvariant())
    }
}

function Get-ActiveSpineEntries {
    param([Parameter(Mandatory = $true)]$Config)

    if (-not (Test-Path -LiteralPath $Config.spine_path -PathType Leaf)) {
        throw "Spine file not found: $($Config.spine_path)"
    }

    Assert-NoReparsePointInExistingPath -FullPath $Config.spine_path -RootPath $Config.source_manuscript_path -Label 'Spine file'

    $seen = @{}
    $entries = New-Object System.Collections.Generic.List[string]

    foreach ($line in Get-Content -LiteralPath $Config.spine_path) {
        $trimmedLine = $line.Trim()
        if (-not $trimmedLine -or $trimmedLine.StartsWith('#')) {
            continue
        }

        $relativePath = Normalize-SafeRelativePath -RelativePath $trimmedLine -BasePath $Config.source_manuscript_path -Label 'spine entry'
        $pathKey = Get-PathKey -PathValue $relativePath
        if ($seen.ContainsKey($pathKey)) {
            throw "Duplicate spine entry after canonicalization: $relativePath"
        }

        $fullPath = Join-FullPath -BasePath $Config.source_manuscript_path -ChildPath $relativePath
        if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
            if (Test-Path -LiteralPath $fullPath -PathType Container) {
                throw "Spine entry is a directory where a file is required: $relativePath"
            }
            throw "Active manuscript file not found: $relativePath"
        }

        Assert-NoReparsePointInExistingPath -FullPath $fullPath -RootPath $Config.source_manuscript_path -Label 'Spine entry'
        $seen[$pathKey] = $true
        $entries.Add($relativePath)
    }

    if ($entries.Count -eq 0) {
        throw "Spine contains no active manuscript files: $($Config.spine_path)"
    }

    return @($entries)
}

function Get-MarkdownImageTargets {
    param([Parameter(Mandatory = $true)][string]$Text)

    $pattern = '!\[[^\]]*\]\((?<target><[^>]+>|(?:\\.|[^)\s])+)(?:\s+"[^"]*")?\)'
    $matches = [System.Text.RegularExpressions.Regex]::Matches($Text, $pattern)

    foreach ($match in $matches) {
        $target = $match.Groups['target'].Value.Trim()
        if ($target.StartsWith('<') -and $target.EndsWith('>')) {
            $target = $target.Substring(1, $target.Length - 2)
        }

        $target = $target.Replace('\(', '(').Replace('\)', ')').Replace('\ ', ' ')
        Write-Output $target
    }
}

function Resolve-ResourceReference {
    param(
        [Parameter(Mandatory = $true)][string]$Reference,
        [Parameter(Mandatory = $true)][string]$ManuscriptRelativePath,
        [Parameter(Mandatory = $true)]$Config
    )

    $resourceReference = $Reference.Trim()
    if (-not $resourceReference) {
        return $null
    }

    if ($resourceReference.StartsWith('#') -or $resourceReference -match '(?i)^(https?://|data:|mailto:)') {
        return $null
    }

    $resourceReference = ($resourceReference -split '[?#]', 2)[0]
    try {
        $resourceReference = [System.Uri]::UnescapeDataString($resourceReference)
    }
    catch {
        throw "Unable to decode resource reference '$Reference' in '$ManuscriptRelativePath'."
    }

    if (Test-UnsafeRelativePath -PathValue $resourceReference) {
        throw "Unsafe resource reference '$Reference' in '$ManuscriptRelativePath'."
    }

    $activeFileDirectory = Split-Path -Parent $ManuscriptRelativePath
    $combinedRelativePath = if ($activeFileDirectory) {
        Join-Path -Path $activeFileDirectory -ChildPath $resourceReference
    }
    else {
        $resourceReference
    }

    $resourceRelativePath = Normalize-SafeRelativePath -RelativePath $combinedRelativePath -BasePath $Config.source_manuscript_path -Label 'resource reference'
    if (-not $resourceRelativePath.StartsWith('resources/', [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Referenced local resource must be under resources/: '$Reference' in '$ManuscriptRelativePath'."
    }

    $resourceFullPath = Join-FullPath -BasePath $Config.source_manuscript_path -ChildPath $resourceRelativePath
    if (-not (Test-Path -LiteralPath $resourceFullPath -PathType Leaf)) {
        if (Test-Path -LiteralPath $resourceFullPath -PathType Container) {
            throw "Referenced resource is a directory: $resourceRelativePath"
        }
        throw "Referenced resource not found: $resourceRelativePath"
    }

    Assert-NoReparsePointInExistingPath -FullPath $resourceFullPath -RootPath $Config.source_manuscript_path -Label 'Resource'
    return $resourceRelativePath
}

function Get-ReferencedResources {
    param(
        [Parameter(Mandatory = $true)][string[]]$ActiveFiles,
        [Parameter(Mandatory = $true)]$Config
    )

    $resourcesByKey = @{}
    foreach ($activeFile in $ActiveFiles) {
        $activeFullPath = Join-FullPath -BasePath $Config.source_manuscript_path -ChildPath $activeFile
        $content = Get-Content -LiteralPath $activeFullPath -Raw
        foreach ($target in Get-MarkdownImageTargets -Text $content) {
            $resourcePath = Resolve-ResourceReference -Reference $target -ManuscriptRelativePath $activeFile -Config $Config
            if ($resourcePath) {
                $resourcesByKey[(Get-PathKey -PathValue $resourcePath)] = $resourcePath
            }
        }
    }

    return @($resourcesByKey.Values | Sort-Object)
}

function Build-SourceManifest {
    param(
        [Parameter(Mandatory = $true)]$Config,
        [Parameter(Mandatory = $true)][ref]$ActiveFileCount,
        [Parameter(Mandatory = $true)][ref]$ResourceCount
    )

    $activeFiles = Get-ActiveSpineEntries -Config $Config
    $resources = Get-ReferencedResources -ActiveFiles $activeFiles -Config $Config

    $ActiveFileCount.Value = $activeFiles.Count
    $ResourceCount.Value = $resources.Count

    $pathsByKey = @{}
    foreach ($path in @($Config.spine_file) + $activeFiles + $resources) {
        $pathsByKey[(Get-PathKey -PathValue $path)] = $path
    }

    $manifest = foreach ($path in @($pathsByKey.Values | Sort-Object)) {
        $fullPath = Join-FullPath -BasePath $Config.source_manuscript_path -ChildPath $path
        Get-HashEntry -FullPath $fullPath -RelativePath $path
    }

    return @($manifest)
}

function Get-TargetFileEntriesSafe {
    param([Parameter(Mandatory = $true)]$Config)

    if (-not (Test-Path -LiteralPath $Config.publishing_manuscript_path)) {
        return @()
    }

    if (-not (Test-Path -LiteralPath $Config.publishing_manuscript_path -PathType Container)) {
        throw "Publishing manuscript path exists but is not a directory: $($Config.publishing_manuscript_path)"
    }

    Assert-NoReparsePointInExistingPath -FullPath $Config.publishing_manuscript_path -RootPath $Config.publishing_repo_path -Label 'Publishing manuscript'

    $root = (Get-FullPathValue -PathValue $Config.publishing_manuscript_path).TrimEnd('\', '/')
    $pendingDirectories = New-Object System.Collections.Generic.Stack[string]
    $pendingDirectories.Push($root)

    $files = New-Object System.Collections.Generic.List[object]

    while ($pendingDirectories.Count -gt 0) {
        $directory = $pendingDirectories.Pop()
        Assert-NoReparsePointInExistingPath -FullPath $directory -RootPath $Config.publishing_repo_path -Label 'Target directory'

        foreach ($item in Get-ChildItem -LiteralPath $directory -Force) {
            $itemFullPath = Get-FullPathValue -PathValue $item.FullName
            Assert-PathInsideOrEqual -ChildPath $itemFullPath -RootPath $root -Label 'Target manifest item'

            if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Target manifest contains a reparse point or symbolic link: $itemFullPath"
            }

            if ($item.PSIsContainer) {
                $pendingDirectories.Push($itemFullPath)
            }
            else {
                $files.Add($item)
            }
        }
    }

    return @($files | Sort-Object FullName)
}

function Build-TargetManifest {
    param([Parameter(Mandatory = $true)]$Config)

    $targetFiles = Get-TargetFileEntriesSafe -Config $Config
    $root = (Get-FullPathValue -PathValue $Config.publishing_manuscript_path).TrimEnd('\', '/')

    $manifest = foreach ($file in $targetFiles) {
        $relativePath = (Get-FullPathValue -PathValue $file.FullName).Substring($root.Length).TrimStart('\', '/')
        Get-HashEntry -FullPath $file.FullName -RelativePath $relativePath
    }

    return @($manifest)
}

function Compare-Manifests {
    param(
        [Parameter(Mandatory = $true)][array]$SourceManifest,
        [Parameter(Mandatory = $true)][array]$TargetManifest
    )

    $sourceByKey = @{}
    foreach ($entry in $SourceManifest) {
        $sourceByKey[(Get-PathKey -PathValue $entry.path)] = $entry
    }

    $targetByKey = @{}
    foreach ($entry in $TargetManifest) {
        $targetByKey[(Get-PathKey -PathValue $entry.path)] = $entry
    }

    $allKeys = @($sourceByKey.Keys + $targetByKey.Keys | Sort-Object -Unique)
    foreach ($key in $allKeys) {
        if (-not $targetByKey.ContainsKey($key)) {
            [PSCustomObject]@{ operation = 'ADD'; path = $sourceByKey[$key].path; source = $sourceByKey[$key]; target = $null }
        }
        elseif (-not $sourceByKey.ContainsKey($key)) {
            [PSCustomObject]@{ operation = 'DELETE'; path = $targetByKey[$key].path; source = $null; target = $targetByKey[$key] }
        }
        elseif ($sourceByKey[$key].sha256 -ne $targetByKey[$key].sha256) {
            [PSCustomObject]@{ operation = 'UPDATE'; path = $sourceByKey[$key].path; source = $sourceByKey[$key]; target = $targetByKey[$key] }
        }
        else {
            [PSCustomObject]@{ operation = 'UNCHANGED'; path = $sourceByKey[$key].path; source = $sourceByKey[$key]; target = $targetByKey[$key] }
        }
    }
}

function New-PublicationPlan {
    param(
        [Parameter(Mandatory = $true)]$Config,
        [Parameter(Mandatory = $true)][array]$SourceManifest,
        [Parameter(Mandatory = $true)][array]$TargetManifest
    )

    $diffs = @(Compare-Manifests -SourceManifest $SourceManifest -TargetManifest $TargetManifest)

    foreach ($diff in @($diffs | Where-Object { $_.operation -in @('ADD', 'UPDATE', 'DELETE') } | Sort-Object path)) {
        $targetPath = Join-FullPath -BasePath $Config.publishing_manuscript_path -ChildPath $diff.path
        Assert-PathInsideOrEqual -ChildPath $targetPath -RootPath $Config.publishing_manuscript_path -Label 'Planned target path'
        Assert-NoReparsePointInExistingPath -FullPath $targetPath -RootPath $Config.publishing_repo_path -Label 'Planned target path'

        if ($diff.operation -eq 'DELETE' -and -not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
            throw "Planned delete target is not a regular file: $targetPath"
        }
    }

    return $diffs
}

function Write-Summary {
    param(
        [Parameter(Mandatory = $true)]$Config,
        [Parameter(Mandatory = $true)][int]$ActiveFileCount,
        [Parameter(Mandatory = $true)][int]$ResourceCount,
        [Parameter(Mandatory = $true)][array]$Diffs
    )

    Write-Host "Source manuscript path: $($Config.source_manuscript_path)"
    Write-Host "Publishing repository path: $($Config.publishing_repo_path)"
    Write-Host "Publishing manuscript path: $($Config.publishing_manuscript_path)"
    Write-Host "Spine path: $($Config.spine_path)"
    Write-Host "Active manuscript files: $ActiveFileCount"
    Write-Host "Referenced resources: $ResourceCount"

    foreach ($operation in @('ADD', 'UPDATE', 'DELETE', 'UNCHANGED')) {
        $count = @($Diffs | Where-Object { $_.operation -eq $operation }).Count
        Write-Host "$operation count: $count"
    }

    foreach ($operation in @('ADD', 'UPDATE', 'DELETE')) {
        $items = @($Diffs | Where-Object { $_.operation -eq $operation } | Sort-Object path)
        if ($items.Count -gt 0) {
            Write-Host "$operation paths:"
            foreach ($item in $items) {
                Write-Host "  $($item.path)"
            }
        }
    }

    if (@($Diffs | Where-Object { $_.operation -ne 'UNCHANGED' }).Count -eq 0) {
        Write-Host "Publication projection is synchronized."
    }
    else {
        Write-Host "Publication projection has pending changes."
    }
}

function Get-ValidatedPlan {
    param(
        [Parameter(Mandatory = $true)]$Config,
        [switch]$RequirePublishingGit
    )

    Confirm-StateFileSafety -Config $Config
    Confirm-RepositoryAndPathSafety -Config $Config -RequirePublishingGit:$RequirePublishingGit

    $activeFileCount = 0
    $resourceCount = 0
    $sourceManifest = Build-SourceManifest -Config $Config -ActiveFileCount ([ref]$activeFileCount) -ResourceCount ([ref]$resourceCount)
    $targetManifest = Build-TargetManifest -Config $Config
    $diffs = @(New-PublicationPlan -Config $Config -SourceManifest $sourceManifest -TargetManifest $targetManifest)

    return [PSCustomObject]@{
        source_manifest = $sourceManifest
        target_manifest = $targetManifest
        diffs = $diffs
        active_file_count = $activeFileCount
        resource_count = $resourceCount
    }
}

function Copy-ManifestFile {
    param(
        [Parameter(Mandatory = $true)]$Config,
        [Parameter(Mandatory = $true)]$ManifestEntry
    )

    $sourcePath = Join-FullPath -BasePath $Config.source_manuscript_path -ChildPath $ManifestEntry.path
    $targetPath = Join-FullPath -BasePath $Config.publishing_manuscript_path -ChildPath $ManifestEntry.path
    $targetDirectory = Split-Path -Parent $targetPath

    Assert-NoReparsePointInExistingPath -FullPath $sourcePath -RootPath $Config.source_manuscript_path -Label 'Copy source'
    Assert-NoReparsePointInExistingPath -FullPath $targetPath -RootPath $Config.publishing_repo_path -Label 'Copy target'

    if (-not (Test-Path -LiteralPath $targetDirectory -PathType Container)) {
        Assert-NoReparsePointInExistingPath -FullPath $targetDirectory -RootPath $Config.publishing_repo_path -Label 'Copy target directory'
        New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
    }

    Assert-NoReparsePointInExistingPath -FullPath $targetDirectory -RootPath $Config.publishing_repo_path -Label 'Copy target directory'
    Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
}

function Remove-TargetFile {
    param(
        [Parameter(Mandatory = $true)]$Config,
        [Parameter(Mandatory = $true)][string]$RelativePath
    )

    $targetPath = Join-FullPath -BasePath $Config.publishing_manuscript_path -ChildPath $RelativePath
    Assert-NoReparsePointInExistingPath -FullPath $targetPath -RootPath $Config.publishing_repo_path -Label 'Delete target'

    if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
        throw "Delete target is not a regular file: $targetPath"
    }

    Remove-Item -LiteralPath $targetPath -Force
}

function Remove-EmptyTargetDirectories {
    param([Parameter(Mandatory = $true)]$Config)

    if (-not (Test-Path -LiteralPath $Config.publishing_manuscript_path -PathType Container)) {
        return
    }

    $directories = New-Object System.Collections.Generic.List[string]
    $pendingDirectories = New-Object System.Collections.Generic.Stack[string]
    $pendingDirectories.Push($Config.publishing_manuscript_path)

    while ($pendingDirectories.Count -gt 0) {
        $directory = $pendingDirectories.Pop()
        Assert-NoReparsePointInExistingPath -FullPath $directory -RootPath $Config.publishing_repo_path -Label 'Cleanup target directory'

        foreach ($childDirectory in Get-ChildItem -LiteralPath $directory -Directory -Force) {
            if (($childDirectory.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Cleanup target contains a reparse point or symbolic link: $($childDirectory.FullName)"
            }

            $pendingDirectories.Push($childDirectory.FullName)
            $directories.Add($childDirectory.FullName)
        }
    }

    foreach ($directory in @($directories | Sort-Object -Descending)) {
        Assert-NoReparsePointInExistingPath -FullPath $directory -RootPath $Config.publishing_repo_path -Label 'Cleanup target directory'
        if (@(Get-ChildItem -LiteralPath $directory -Force).Count -eq 0) {
            Remove-Item -LiteralPath $directory -Force
        }
    }
}

function Assert-ManifestsMatch {
    param(
        [Parameter(Mandatory = $true)][array]$ExpectedManifest,
        [Parameter(Mandatory = $true)][array]$ActualManifest
    )

    $verificationDiffs = @(Compare-Manifests -SourceManifest $ExpectedManifest -TargetManifest $ActualManifest | Where-Object { $_.operation -ne 'UNCHANGED' })
    if ($verificationDiffs.Count -gt 0) {
        $details = ($verificationDiffs | Sort-Object path | ForEach-Object { "$($_.operation) $($_.path)" }) -join '; '
        throw "Post-publish verification failed; target manifest does not match source manifest: $details"
    }
}

function Save-LeanpubState {
    param(
        [Parameter(Mandatory = $true)]$Config,
        [Parameter(Mandatory = $true)][array]$FinalManifest
    )

    $stateDirectory = Split-Path -Parent $Config.state_file
    if (-not (Test-Path -LiteralPath $stateDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $stateDirectory -Force | Out-Null
    }

    $state = [PSCustomObject]@{
        schema_version = 1
        last_publish_utc = (Get-Date).ToUniversalTime().ToString('o')
        source_manuscript_path = $Config.source_manuscript_path
        publishing_repo_path = $Config.publishing_repo_path
        publishing_manuscript_path = $Config.publishing_manuscript_path
        spine_file = $Config.spine_file
        manifest = @($FinalManifest | Sort-Object path)
    }

    $json = $state | ConvertTo-Json -Depth 8
    [System.IO.File]::WriteAllText($Config.state_file, $json, (New-Object System.Text.UTF8Encoding($false)))
}

function Invoke-LeanpubStatus {
    param([Parameter(Mandatory = $true)]$Config)

    $plan = Get-ValidatedPlan -Config $Config
    Write-Summary -Config $Config -ActiveFileCount $plan.active_file_count -ResourceCount $plan.resource_count -Diffs $plan.diffs
}

function Invoke-LeanpubPublish {
    param([Parameter(Mandatory = $true)]$Config)

    $plan = Get-ValidatedPlan -Config $Config -RequirePublishingGit
    Write-Summary -Config $Config -ActiveFileCount $plan.active_file_count -ResourceCount $plan.resource_count -Diffs $plan.diffs

    foreach ($diff in @($plan.diffs | Where-Object { $_.operation -in @('ADD', 'UPDATE') } | Sort-Object path)) {
        Write-Host "$($diff.operation) $($diff.path)"
        Copy-ManifestFile -Config $Config -ManifestEntry $diff.source
    }

    foreach ($diff in @($plan.diffs | Where-Object { $_.operation -eq 'DELETE' } | Sort-Object path)) {
        Write-Host "DELETE $($diff.path)"
        Remove-TargetFile -Config $Config -RelativePath $diff.path
    }

    Remove-EmptyTargetDirectories -Config $Config

    $finalTargetManifest = Build-TargetManifest -Config $Config
    Assert-ManifestsMatch -ExpectedManifest $plan.source_manifest -ActualManifest $finalTargetManifest
    Save-LeanpubState -Config $Config -FinalManifest $finalTargetManifest
}

$config = Get-LeanpubConfig `
    -ConfigPathValue $ConfigPath `
    -CliSourceManuscriptPath $SourceManuscriptPath `
    -CliPublishingRepoPath $PublishingRepoPath `
    -CliPublishingManuscriptPath $PublishingManuscriptPath `
    -CliSpineFile $SpineFile `
    -CliStateFile $StateFile

if ($Action -eq 'status') {
    Invoke-LeanpubStatus -Config $config
}
else {
    Invoke-LeanpubPublish -Config $config
}
