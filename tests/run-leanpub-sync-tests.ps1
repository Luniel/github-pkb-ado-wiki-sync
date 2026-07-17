Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$ScriptPath = Join-Path $RepoRoot 'sync_github_book_leanpub.ps1'
$ConfigRoot = Join-Path $RepoRoot 'configs'
$script:Passed = 0
$script:Failed = 0
$script:Skipped = 0

function New-TextFile {
    param([Parameter(Mandatory = $true)][string]$Path, [AllowEmptyString()][string]$Content)
    $directory = Split-Path -Parent $Path
    if ($directory -and -not (Test-Path -LiteralPath $directory -PathType Container)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

function Get-TreeFingerprint {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return '<missing>' }
    $entries = Get-ChildItem -LiteralPath $Path -Recurse -Force | Sort-Object FullName | ForEach-Object {
        $relative = $_.FullName.Substring((Get-FullPath -Path $Path).Length).TrimStart('\', '/') -replace '\\', '/'
        if ($_.PSIsContainer) { "D|$relative" } else { "F|$relative|$($_.Length)|$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash)" }
    }
    return ($entries -join "`n")
}

function Get-FullPath { param([string]$Path) return [System.IO.Path]::GetFullPath($Path) }

function New-Fixture {
    param([switch]$GitFile)
    $id = [guid]::NewGuid().ToString('n')
    $root = Join-Path ([System.IO.Path]::GetTempPath()) "leanpub-sync-test-$id"
    $sourceRepo = Join-Path $root 'book-the-gap'
    $source = Join-Path $sourceRepo 'manuscript'
    $repo = Join-Path $root 'book-the-gap-publishing'
    $pub = Join-Path $repo 'manuscript'
    $safeState = Join-Path $ConfigRoot "$id.sync.state.json"
    $config = Join-Path $ConfigRoot "$id.sync.json"

    New-Item -ItemType Directory -Path $source, $repo, $ConfigRoot -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $sourceRepo '.git') -Force | Out-Null
    if ($GitFile) {
        New-TextFile (Join-Path $repo '.git') 'gitdir: C:\fake\worktree\.git'
    }
    else {
        New-Item -ItemType Directory -Path (Join-Path $repo '.git') -Force | Out-Null
    }

    New-TextFile (Join-Path $repo 'README.md') 'publishing readme'
    New-TextFile (Join-Path $repo 'outside.md') 'outside root file'
    New-TextFile (Join-Path $source 'book.txt') "chapter1.md`nchapter2.md`n"
    New-TextFile (Join-Path $source 'chapter1.md') "# One`n![img](resources/a.png)`n"
    New-TextFile (Join-Path $source 'chapter2.md') "# Two`n"
    New-TextFile (Join-Path $source 'resources/a.png') 'A'
    New-TextFile (Join-Path $source 'resources/unused.zip') 'UNUSED'
    New-TextFile (Join-Path $source 'old/archive.md') 'OLD'

    New-TextFile $config (@{
        source_manuscript_path = $source
        publishing_repo_path = $repo
        publishing_manuscript_path = 'manuscript'
        spine_file = 'book.txt'
        state_file = ('.\' + (Split-Path -Leaf $safeState))
    } | ConvertTo-Json)

    return [PSCustomObject]@{
        Id = $id
        Root = $root
        SourceRepo = $sourceRepo
        Source = $source
        Repo = $repo
        Pub = $pub
        Config = $config
        State = $safeState
    }
}

function Get-ConfigObject {
    param($Fixture)
    return Get-Content -LiteralPath $Fixture.Config -Raw | ConvertFrom-Json
}

function Save-ConfigObject {
    param($Fixture, $ConfigObject)
    New-TextFile $Fixture.Config ($ConfigObject | ConvertTo-Json -Depth 8)
}

function Invoke-Tool {
    param($Fixture, [ValidateSet('status', 'publish')][string]$Action = 'status')
    $output = & $ScriptPath $Action -ConfigPath $Fixture.Config 2>&1 | Out-String
    return $output
}

function Invoke-ToolExpectFailure {
    param($Fixture, [ValidateSet('status', 'publish')][string]$Action = 'status', [string]$Contains)
    $failed = $false
    try {
        $output = & $ScriptPath $Action -ConfigPath $Fixture.Config 2>&1 | Out-String
    }
    catch {
        $failed = $true
        if ($Contains -and ($_.Exception.Message -notlike "*$Contains*")) {
            throw "Expected error containing '$Contains' but got: $($_.Exception.Message)"
        }
    }
    if (-not $failed) { throw "Expected $Action to fail with '$Contains'." }
}

function Assert-True { param([bool]$Condition, [string]$Message) if (-not $Condition) { throw $Message } }
function Assert-False { param([bool]$Condition, [string]$Message) if ($Condition) { throw $Message } }

function Test-Case {
    param([string]$Name, [scriptblock]$Body)
    try {
        & $Body
        Write-Host "PASS $Name"
        $script:Passed++
    }
    catch {
        Write-Host "FAIL $Name"
        Write-Host $_.Exception.Message
        $script:Failed++
    }
}

function Skip-Test {
    param([string]$Reason)
    throw [System.NotSupportedException]::new($Reason)
}

function Test-CaseWithSkip {
    param([string]$Name, [scriptblock]$Body)
    try {
        & $Body
        Write-Host "PASS $Name"
        $script:Passed++
    }
    catch [System.NotSupportedException] {
        Write-Host "SKIP $Name - $($_.Exception.Message)"
        $script:Skipped++
    }
    catch {
        Write-Host "FAIL $Name"
        Write-Host $_.Exception.Message
        $script:Failed++
    }
}

function New-TestSymlink {
    param([string]$Path, [string]$Target, [switch]$Directory)
    try {
        if ($Directory) {
            New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force -ErrorAction Stop | Out-Null
        }
        else {
            New-Item -ItemType SymbolicLink -Path $Path -Target $Target -Force -ErrorAction Stop | Out-Null
        }
    }
    catch {
        Skip-Test "symlink creation unavailable: $($_.Exception.Message)"
    }
}

function Assert-NoMutationOnFailure {
    param($Fixture, [scriptblock]$Arrange, [string]$Contains)
    New-TextFile (Join-Path $Fixture.Pub 'preexisting.md') 'preexisting'
    $before = Get-TreeFingerprint -Path $Fixture.Repo
    & $Arrange
    Invoke-ToolExpectFailure $Fixture publish $Contains
    $after = Get-TreeFingerprint -Path $Fixture.Repo
    Assert-True ($before -eq $after) "Target repository mutated on failure. Before: $before After: $after"
}

Test-Case 'reads active spine entries ignoring blank and comments' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'book.txt') "`n # c`nchapter1.md`n`nchapter2.md`n"
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Active manuscript files:\s+2') $output
}

Test-Case 'fails on empty active spine' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'book.txt') "`n# none`n"
    Invoke-ToolExpectFailure $fx status 'no active manuscript'
}

Test-Case 'fails on duplicate spine entries' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'book.txt') "chapter1.md`nchapter1.md`n"
    Invoke-ToolExpectFailure $fx status 'Duplicate spine entry'
}

Test-Case 'fails on duplicate spine entry using dot segment' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'chapter.md') '# c'
    New-TextFile (Join-Path $fx.Source 'book.txt') "chapter.md`n.\chapter.md`n"
    Invoke-ToolExpectFailure $fx status 'Duplicate spine entry'
}

Test-Case 'fails on duplicate spine entry using slash and backslash' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'chapters/chapter.md') '# c'
    New-TextFile (Join-Path $fx.Source 'book.txt') "chapters/chapter.md`nchapters\chapter.md`n"
    Invoke-ToolExpectFailure $fx status 'Duplicate spine entry'
}

Test-Case 'fails on case-only duplicate spine entries on case-insensitive policy' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'Case.md') '# c'
    New-TextFile (Join-Path $fx.Source 'case.md') '# c2'
    New-TextFile (Join-Path $fx.Source 'book.txt') "Case.md`ncase.md`n"
    Invoke-ToolExpectFailure $fx status 'Duplicate spine entry'
}

Test-Case 'fails on missing active manuscript files' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'book.txt') "missing.md`n"
    Invoke-ToolExpectFailure $fx status 'not found'
}

Test-Case 'rejects traversal spine entry' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'book.txt') "../secret.md`n"
    Invoke-ToolExpectFailure $fx status 'Unsafe spine entry'
}

Test-Case 'rejects rooted Windows spine entry' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'book.txt') "C:\secret.md`n"
    Invoke-ToolExpectFailure $fx status 'Unsafe spine entry'
}

Test-Case 'rejects drive-qualified relative spine entry' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'book.txt') "C:secret.md`n"
    Invoke-ToolExpectFailure $fx status 'Unsafe spine entry'
}

Test-Case 'rejects UNC spine entry' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'book.txt') "\\server\share\secret.md`n"
    Invoke-ToolExpectFailure $fx status 'Unsafe spine entry'
}

Test-Case 'rejects rooted active-platform spine entry' {
    $fx = New-Fixture
    $rooted = Join-Path ([System.IO.Path]::GetPathRoot($fx.Source)) 'secret.md'
    New-TextFile (Join-Path $fx.Source 'book.txt') "$rooted`n"
    Invoke-ToolExpectFailure $fx status 'Unsafe spine entry'
}

Test-Case 'discovers referenced resources' {
    $fx = New-Fixture
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Referenced resources:\s+1') $output
    Assert-True ($output -match 'resources/a.png') $output
}

Test-Case 'supports optional titles and angle paths with spaces and parentheses' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'resources/path with spaces/example (final).png') 'S'
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](<resources/path with spaces/example (final).png>) ![b](resources/a.png "Title")'
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Referenced resources:\s+2') $output
}

Test-Case 'supports query strings fragments and percent-encoded spaces' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'resources/encoded space.png') 'S'
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](resources/encoded%20space.png?cache=1#frag)'
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Referenced resources:\s+1') $output
}

Test-Case 'supports escaped spaces in image targets' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'resources/escaped space.png') 'S'
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](resources/escaped\ space.png)'
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Referenced resources:\s+1') $output
}

Test-Case 'ignores external URLs and fragment-only references' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](https://x/y.png) ![b](http://x) ![c](data:image/png,abc) ![d](mailto:x@y) ![e](#anchor)'
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Referenced resources:\s+0') $output
}

Test-Case 'local non-image markdown links are unsupported and ignored' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '[doc](resources/missing.pdf)'
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Referenced resources:\s+0') $output
}

Test-Case 'fails on missing local resources' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](resources/missing.png)'
    Invoke-ToolExpectFailure $fx status 'Referenced resource not found'
}

Test-Case 'fails on resource traversal outside source root' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](resources/../../secret.png)'
    Invoke-ToolExpectFailure $fx status 'Unsafe resource reference'
}


Test-Case 'handles zero referenced resources without scalar/null unrolling' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '# no resources'
    New-TextFile (Join-Path $fx.Source 'chapter2.md') '# no resources either'
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Referenced resources:\s+0') $output
}

Test-Case 'handles one referenced resource without scalar/null unrolling' {
    $fx = New-Fixture
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Referenced resources:\s+1') $output
}

Test-Case 'handles multiple referenced resources without scalar/null unrolling' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'resources/b.png') 'B'
    New-TextFile (Join-Path $fx.Source 'chapter1.md') "![a](resources/a.png)`n![b](resources/b.png)"
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Referenced resources:\s+2') $output
}

Test-Case 'handles zero target manifest entries without scalar/null unrolling' {
    $fx = New-Fixture
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'ADD count:\s+4') $output
    Assert-True ($output -match 'DELETE count:\s+0') $output
}

Test-Case 'handles one target manifest entry without scalar/null unrolling' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Pub 'stale.md') 'stale'
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'DELETE count:\s+1') $output
}

Test-Case 'handles multiple target manifest entries without scalar/null unrolling' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Pub 'stale-a.md') 'stale a'
    New-TextFile (Join-Path $fx.Pub 'stale-b.md') 'stale b'
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'DELETE count:\s+2') $output
}

Test-Case 'unreferenced resources are not copied' {
    $fx = New-Fixture
    Invoke-Tool $fx publish | Out-Null
    Assert-False (Test-Path -LiteralPath (Join-Path $fx.Pub 'resources/unused.zip')) 'unused copied'
}

Test-Case 'manuscript old is not copied merely because it exists' {
    $fx = New-Fixture
    Invoke-Tool $fx publish | Out-Null
    Assert-False (Test-Path -LiteralPath (Join-Path $fx.Pub 'old/archive.md')) 'old copied'
}

Test-Case 'initial publication adds expected files' {
    $fx = New-Fixture
    $output = Invoke-Tool $fx publish
    foreach ($path in @('book.txt', 'chapter1.md', 'chapter2.md', 'resources/a.png')) {
        Assert-True (Test-Path -LiteralPath (Join-Path $fx.Pub $path)) "$path missing"
    }
    Assert-True ($output -match 'ADD book.txt') $output
}

Test-Case 'changed source content produces update' {
    $fx = New-Fixture
    Invoke-Tool $fx publish | Out-Null
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '# Won'
    $output = Invoke-Tool $fx publish
    Assert-True ($output -match 'UPDATE chapter1.md') $output
}

Test-Case 'removed spine resource references produce target deletions' {
    $fx = New-Fixture
    Invoke-Tool $fx publish | Out-Null
    New-TextFile (Join-Path $fx.Source 'book.txt') "chapter2.md`n"
    $output = Invoke-Tool $fx publish
    Assert-True ($output -match 'DELETE chapter1.md') $output
    Assert-True ($output -match 'DELETE resources/a.png') $output
}

Test-Case 'stale target files are deleted only inside manuscript' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Pub 'stale.md') 'stale'
    New-TextFile (Join-Path $fx.Repo 'unrelated-root.txt') 'root'
    Invoke-Tool $fx publish | Out-Null
    Assert-False (Test-Path -LiteralPath (Join-Path $fx.Pub 'stale.md')) 'stale remains'
    Assert-True (Test-Path -LiteralPath (Join-Path $fx.Repo 'unrelated-root.txt')) 'root file removed'
    Assert-True (Test-Path -LiteralPath (Join-Path $fx.Repo 'outside.md')) 'outside root file removed'
}

Test-Case 'root README remains unchanged' {
    $fx = New-Fixture
    Invoke-Tool $fx publish | Out-Null
    Assert-True ((Get-Content -LiteralPath (Join-Path $fx.Repo 'README.md') -Raw) -eq 'publishing readme') 'readme changed'
}

Test-Case 'status performs no mutations and writes no state' {
    $fx = New-Fixture
    Invoke-Tool $fx status | Out-Null
    Assert-False (Test-Path -LiteralPath $fx.Pub) 'publishing manuscript created'
    Assert-False (Test-Path -LiteralPath $fx.State) 'state written'
}

Test-Case 'publish writes state after success' {
    $fx = New-Fixture
    Invoke-Tool $fx publish | Out-Null
    Assert-True (Test-Path -LiteralPath $fx.State) 'state missing'
    Assert-True ((Get-Content -LiteralPath $fx.State -Raw) -match 'schema_version') 'bad state'
}

Test-Case 'second publish is idempotent without operation lines' {
    $fx = New-Fixture
    Invoke-Tool $fx publish | Out-Null
    $output = Invoke-Tool $fx publish
    $operationLines = @($output -split "`r?`n" | Where-Object { $_ -match '^(ADD|UPDATE|DELETE)\s+' })
    Assert-True ($output -match 'Publication projection is synchronized') $output
    Assert-True ($operationLines.Count -eq 0) "Unexpected operation lines: $($operationLines -join ', ')"
}

Test-Case 'SHA-256 detects same-length content change' {
    $fx = New-Fixture
    Invoke-Tool $fx publish | Out-Null
    New-TextFile (Join-Path $fx.Source 'chapter2.md') '# Tw0'
    $output = Invoke-Tool $fx publish
    Assert-True ($output -match 'UPDATE chapter2.md') $output
}

Test-Case 'publishing manuscript equals repository root is rejected' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.publishing_manuscript_path = '.'
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'repository root'
}

Test-Case 'target inside source is rejected' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.publishing_repo_path = Join-Path $fx.Source 'nested-publishing'
    New-Item -ItemType Directory -Path $cfg.publishing_repo_path, (Join-Path $cfg.publishing_repo_path '.git') -Force | Out-Null
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'overlap'
}

Test-Case 'source inside target is rejected' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.source_manuscript_path = Join-Path $fx.Pub 'nested-source'
    New-Item -ItemType Directory -Path $cfg.source_manuscript_path -Force | Out-Null
    New-TextFile (Join-Path $cfg.source_manuscript_path 'book.txt') 'chapter.md'
    New-TextFile (Join-Path $cfg.source_manuscript_path 'chapter.md') '# c'
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'overlap'
}

Test-Case 'source and target paths equal are rejected' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.publishing_repo_path = Split-Path -Parent $fx.Source
    $cfg.publishing_manuscript_path = Split-Path -Leaf $fx.Source
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'overlap'
}

Test-Case 'target repository inside source repository is rejected' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.publishing_repo_path = Join-Path $fx.SourceRepo 'publishing-repo'
    New-Item -ItemType Directory -Path $cfg.publishing_repo_path, (Join-Path $cfg.publishing_repo_path '.git') -Force | Out-Null
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'overlap'
}

Test-Case 'source manuscript inside publishing repository is rejected' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.source_manuscript_path = Join-Path $fx.Repo 'source-manuscript'
    New-Item -ItemType Directory -Path $cfg.source_manuscript_path -Force | Out-Null
    New-TextFile (Join-Path $cfg.source_manuscript_path 'book.txt') 'chapter.md'
    New-TextFile (Join-Path $cfg.source_manuscript_path 'chapter.md') '# c'
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'overlap'
}

Test-Case 'safe sibling repositories under same parent are accepted' {
    $fx = New-Fixture
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Publication projection has pending changes') $output
}

Test-Case 'state file inside source manuscript is rejected' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.state_file = Join-Path $fx.Source 'state.json'
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'Unsafe state_file'
}

Test-Case 'state file inside publishing manuscript is rejected' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.state_file = Join-Path $fx.Pub 'state.json'
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'Unsafe state_file'
}

Test-Case 'state file at publishing repository root is rejected' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.state_file = Join-Path $fx.Repo 'state.json'
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'Unsafe state_file'
}

Test-Case 'state file inside source repository outside manuscript is rejected' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.state_file = Join-Path $fx.SourceRepo 'state.json'
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'Unsafe state_file'
}

Test-Case 'state file in sync-tool config directory is accepted' {
    $fx = New-Fixture
    $output = Invoke-Tool $fx status
    Assert-True ($output -match 'Publication projection has pending changes') $output
}

Test-Case 'state file at safe external location is rejected by policy' {
    $fx = New-Fixture
    $cfg = Get-ConfigObject $fx
    $cfg.state_file = Join-Path $fx.Root 'external-state.json'
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx status 'Unsafe state_file'
}

Test-Case 'ordinary git directory is accepted for publish' {
    $fx = New-Fixture
    Invoke-Tool $fx publish | Out-Null
    Assert-True (Test-Path -LiteralPath $fx.State) 'state missing'
}

Test-Case 'git worktree file is accepted for publish' {
    $fx = New-Fixture -GitFile
    Invoke-Tool $fx publish | Out-Null
    Assert-True (Test-Path -LiteralPath $fx.State) 'state missing'
}

Test-CaseWithSkip 'source resource path through reparse point is rejected' {
    $fx = New-Fixture
    $outside = Join-Path $fx.Root 'outside-source'
    New-Item -ItemType Directory -Path $outside -Force | Out-Null
    New-TextFile (Join-Path $outside 'escape.png') 'escape'
    Remove-Item -LiteralPath (Join-Path $fx.Source 'resources') -Recurse -Force
    New-TestSymlink -Path (Join-Path $fx.Source 'resources') -Target $outside -Directory
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](resources/escape.png)'
    Invoke-ToolExpectFailure $fx status 'reparse point'
}

Test-CaseWithSkip 'publishing manuscript path as reparse point is rejected' {
    $fx = New-Fixture
    $outside = Join-Path $fx.Root 'outside-target'
    New-Item -ItemType Directory -Path $outside -Force | Out-Null
    New-TestSymlink -Path $fx.Pub -Target $outside -Directory
    Invoke-ToolExpectFailure $fx status 'reparse point'
}

Test-CaseWithSkip 'nested publishing resource directory as reparse point is rejected' {
    $fx = New-Fixture
    New-Item -ItemType Directory -Path $fx.Pub -Force | Out-Null
    $outside = Join-Path $fx.Root 'outside-target'
    New-Item -ItemType Directory -Path $outside -Force | Out-Null
    New-TestSymlink -Path (Join-Path $fx.Pub 'resources') -Target $outside -Directory
    Invoke-ToolExpectFailure $fx status 'reparse point'
}

Test-CaseWithSkip 'stale target deletion through reparse point is rejected' {
    $fx = New-Fixture
    New-Item -ItemType Directory -Path $fx.Pub -Force | Out-Null
    $outside = Join-Path $fx.Root 'outside-target'
    New-Item -ItemType Directory -Path $outside -Force | Out-Null
    New-TextFile (Join-Path $outside 'stale.md') 'stale'
    New-TestSymlink -Path (Join-Path $fx.Pub 'oldlink') -Target $outside -Directory
    Invoke-ToolExpectFailure $fx publish 'reparse point'
}

Test-Case 'malformed config failure leaves target unchanged' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Pub 'preexisting.md') 'preexisting'
    $before = Get-TreeFingerprint -Path $fx.Repo
    New-TextFile $fx.Config '{ not json'
    Invoke-ToolExpectFailure $fx publish 'Malformed JSON'
    $after = Get-TreeFingerprint -Path $fx.Repo
    Assert-True ($before -eq $after) 'target mutated'
}

Test-Case 'missing spine failure leaves target unchanged' {
    $fx = New-Fixture
    Assert-NoMutationOnFailure $fx { Remove-Item -LiteralPath (Join-Path $fx.Source 'book.txt') -Force } 'Spine file not found'
}

Test-Case 'empty active spine failure leaves target unchanged' {
    $fx = New-Fixture
    Assert-NoMutationOnFailure $fx { New-TextFile (Join-Path $fx.Source 'book.txt') '# empty' } 'no active manuscript'
}

Test-Case 'missing active manuscript failure leaves target unchanged' {
    $fx = New-Fixture
    Assert-NoMutationOnFailure $fx { New-TextFile (Join-Path $fx.Source 'book.txt') 'missing.md' } 'not found'
}

Test-Case 'missing referenced resource failure leaves target unchanged' {
    $fx = New-Fixture
    Assert-NoMutationOnFailure $fx { New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](resources/missing.png)' } 'Referenced resource not found'
}

Test-Case 'unsafe spine failure leaves target unchanged' {
    $fx = New-Fixture
    Assert-NoMutationOnFailure $fx { New-TextFile (Join-Path $fx.Source 'book.txt') '../secret.md' } 'Unsafe spine entry'
}

Test-Case 'unsafe resource failure leaves target unchanged' {
    $fx = New-Fixture
    Assert-NoMutationOnFailure $fx { New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](resources/../../secret.png)' } 'Unsafe resource reference'
}

Test-Case 'unsafe state-file failure leaves target unchanged' {
    $fx = New-Fixture
    Assert-NoMutationOnFailure $fx {
        $cfg = Get-ConfigObject $fx
        $cfg.state_file = Join-Path $fx.Repo 'state.json'
        Save-ConfigObject $fx $cfg
    } 'Unsafe state_file'
}

Test-Case 'dangerous overlap failure leaves target unchanged and does not create manuscript directory' {
    $fx = New-Fixture
    $before = Get-TreeFingerprint -Path $fx.Repo
    $cfg = Get-ConfigObject $fx
    $cfg.publishing_repo_path = Join-Path $fx.Source 'nested-publishing'
    New-Item -ItemType Directory -Path $cfg.publishing_repo_path, (Join-Path $cfg.publishing_repo_path '.git') -Force | Out-Null
    $beforeConfiguredRepo = Get-TreeFingerprint -Path $cfg.publishing_repo_path
    Save-ConfigObject $fx $cfg
    Invoke-ToolExpectFailure $fx publish 'overlap'
    Assert-True ($before -eq (Get-TreeFingerprint -Path $fx.Repo)) 'original target mutated'
    Assert-True ($beforeConfiguredRepo -eq (Get-TreeFingerprint -Path $cfg.publishing_repo_path)) 'configured target mutated'
    Assert-False (Test-Path -LiteralPath (Join-Path $cfg.publishing_repo_path 'manuscript')) 'manuscript directory created'
}

Test-CaseWithSkip 'target reparse-point detection failure leaves target unchanged' {
    $fx = New-Fixture
    New-Item -ItemType Directory -Path $fx.Pub -Force | Out-Null
    $outside = Join-Path $fx.Root 'outside-target'
    New-Item -ItemType Directory -Path $outside -Force | Out-Null
    New-TestSymlink -Path (Join-Path $fx.Pub 'resources') -Target $outside -Directory
    $before = Get-TreeFingerprint -Path $fx.Repo
    Invoke-ToolExpectFailure $fx publish 'reparse point'
    $after = Get-TreeFingerprint -Path $fx.Repo
    Assert-True ($before -eq $after) 'target mutated'
}

Test-Case 'validation failure before target exists does not create manuscript directory' {
    $fx = New-Fixture
    New-TextFile (Join-Path $fx.Source 'chapter1.md') '![a](resources/missing.png)'
    Invoke-ToolExpectFailure $fx publish 'Referenced resource not found'
    Assert-False (Test-Path -LiteralPath $fx.Pub) 'publishing manuscript directory was created'
}

Test-CaseWithSkip 'post-publish verification failure prevents state write' {
    $fx = New-Fixture
    New-Item -ItemType Directory -Path $fx.Pub -Force | Out-Null
    $outside = Join-Path $fx.Root 'outside-target'
    New-Item -ItemType Directory -Path $outside -Force | Out-Null
    New-TextFile (Join-Path $outside 'a.png') 'wrong'
    New-TestSymlink -Path (Join-Path $fx.Pub 'resources') -Target $outside -Directory
    Invoke-ToolExpectFailure $fx publish 'reparse point'
    Assert-False (Test-Path -LiteralPath $fx.State) 'state written after verification failure path'
}

Write-Host "Passed: $script:Passed Failed: $script:Failed Skipped: $script:Skipped"
if ($script:Failed -gt 0) {
    exit 1
}
