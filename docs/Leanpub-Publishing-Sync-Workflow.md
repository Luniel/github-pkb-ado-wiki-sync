# Leanpub Publishing Sync Workflow

This workflow projects a curated Leanpub manuscript from the working manuscript repository into a separate publishing repository.

## Authority model

```text
book-the-gap
    authoritative working manuscript
            |
            | one-way publication projection
            v
book-the-gap-publishing
    authoritative source presented to Leanpub
            |
            v
Leanpub
```

`book-the-gap` remains the authoring source. `book-the-gap-publishing` exists so Leanpub sees only publication-ready files, not planning, governance, archive, continuity, source-control, or alternate manuscript material.

## Why this is not the PKB ↔ ADO Wiki sync

`sync_github_pkb_ado_wiki.ps1` is a bidirectional mirror with `publish` and `pullback` behavior for an in-repository PKB and an Azure DevOps Wiki Git repository. Leanpub publication is different: it is deliberately one-way and allowlist-based. `sync_github_book_leanpub.ps1` does not pull back, force overwrite conflicts, commit, push, or copy an entire manuscript tree.

## Install and local configuration

Copy the example configuration and edit it for your machine:

```powershell
cd D:\GitHub\GitHub-PKB-ADO-Wiki-Sync
New-Item -ItemType Directory -Path .\configs -Force
Copy-Item .\sync.leanpub.config.example.json .\configs\the-gap-leanpub.sync.json
notepad .\configs\the-gap-leanpub.sync.json
```

The config values are:

- `source_manuscript_path`: source manuscript root, for example `D:\GitHub\book-the-gap\manuscript`
- `publishing_repo_path`: Leanpub publishing Git repository root, for example `D:\GitHub\book-the-gap-publishing`
- `publishing_manuscript_path`: target manuscript folder relative to the publishing repository, normally `manuscript`
- `spine_file`: active Leanpub spine relative to the source manuscript root, normally lowercase `book.txt`
- `state_file`: optional audit state path; relative paths resolve beside the config file

Local `configs/*.sync.json` and `configs/*.sync.state.json` files are ignored so machine-specific paths and generated state are not accidentally committed. The committed example config remains tracked.

## Initial status

Run status first. It is read-only, does not create the target manuscript directory, and does not write the state file. A successful status exits with code `0` even when differences exist; nonzero exits are reserved for validation or operational failures.

```powershell
.\sync_github_book_leanpub.ps1 status `
  -ConfigPath .\configs\the-gap-leanpub.sync.json
```

The summary shows resolved paths, active manuscript count, referenced resource count, and counts for `ADD`, `UPDATE`, `DELETE`, and `UNCHANGED` files.

## Initial publish

Publish performs the same validation before mutation, copies only the generated manifest, deletes stale files only under the configured publishing manuscript directory, removes empty directories there, and writes the audit state after success.

```powershell
.\sync_github_book_leanpub.ps1 publish `
  -ConfigPath .\configs\the-gap-leanpub.sync.json
```

The script prints exact `ADD`, `UPDATE`, and `DELETE` operations. It does not run Git commands.

## Inspect and commit publishing changes manually

Expected manual workflow:

```powershell
cd D:\GitHub\GitHub-PKB-ADO-Wiki-Sync

.\sync_github_book_leanpub.ps1 status `
  -ConfigPath .\configs\the-gap-leanpub.sync.json

.\sync_github_book_leanpub.ps1 publish `
  -ConfigPath .\configs\the-gap-leanpub.sync.json

cd D:\GitHub\book-the-gap-publishing

git status --short
git diff --stat
git diff

git add manuscript
git commit -m "Publish current Leanpub manuscript"
git push
```

## Normal recurring workflow

1. Edit the manuscript in `book-the-gap`.
2. Update `manuscript\book.txt` when the active publication spine changes.
3. Run `status` from this sync-tool repository.
4. Run `publish` only after the status output is expected.
5. Review, commit, and push the publishing repository manually.

## State-file behavior

The state file is a human-readable audit record, not a bidirectional conflict mechanism. It records the last successful publish time, resolved paths, spine file, and SHA-256 manifest entries. `status` never writes it. `publish` writes it only after a successful projection.

## Safety guarantees

The Leanpub sync:

- uses `book.txt` as the active-file authority
- scans only active manuscript files for supported image/resource references
- copies only `book.txt`, active files, and referenced local files under `resources/`
- rejects absolute paths, drive-qualified paths, UNC paths, `..` traversal, missing files, directories where files are required, and source/target overlap
- rejects resources outside `resources/` or outside the source manuscript root
- avoids symlink/reparse-point paths that could escape the source root
- never copies `.git`, `manuscript/old`, unreferenced resources, or the whole manuscript directory
- never mutates source manuscript files
- never mutates files outside the publishing manuscript directory
- never commits, pushes, branches, pulls, or merges either repository

Resource parsing intentionally supports ordinary Markdown/Markua image references such as `![Alt](resources/file.png)`, optional quoted titles, and angle-bracket paths with spaces. It is not a complete Markdown parser.

## Troubleshooting

### Missing `book.txt`

Confirm `spine_file` is correct and relative to `source_manuscript_path`. The expected default is lowercase `book.txt`.

### Missing active manuscript files

Every nonblank, non-comment line in `book.txt` is treated as active. Fix typos, remove inactive entries, or create the missing file before rerunning.

### Missing referenced resources

Only local resources referenced by active manuscript files are copied. If a referenced `resources/...` file is missing, restore it or update the image reference. External URLs, `data:`, `mailto:`, and fragment-only references are ignored.

### Malformed config

Validate the JSON syntax and required property names. Use the committed `sync.leanpub.config.example.json` as the template.

### PowerShell execution policy

On Windows, run from an appropriate shell or use:

```powershell
powershell -ExecutionPolicy Bypass -File .\sync_github_book_leanpub.ps1 status -ConfigPath .\configs\the-gap-leanpub.sync.json
```

### Empty or unexpected publishing diff

If status says the projection is synchronized, inspect `book.txt`: only active spine entries and their referenced `resources/` files are considered. Unreferenced files and `manuscript/old` are intentionally excluded.
