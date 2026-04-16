# GitHub PKB ↔ ADO Wiki Sync

A small PowerShell tool for synchronizing a **Product Knowledge Base (PKB)** between:

- a **GitHub source repository folder** that acts as the authoritative PKB location, and
- an **Azure DevOps Wiki Git repository** that acts as the published wiki surface.

This tool supports a stewardship model where the PKB lives inside a solution repo, while the ADO Wiki repo mirrors that PKB for wiki publishing and optional direct wiki editing.

---

# Purpose

This tool exists to support a clean stewardship model:

- the PKB remains authoritative in the solution repo
- the ADO Wiki repo remains a publishable and optionally editable wiki surface
- synchronization is explicit and reviewable
- conflicting edits are detected instead of silently overwritten
- sync state is kept with the sync tooling rather than inside the PKB source or wiki content surface

---

# What it does

The tool supports three actions:

- `status` — compare both sides against the last recorded sync state
- `publish` — sync **GitHub PKB -> ADO Wiki repo root**
- `pullback` — sync **ADO Wiki repo root -> GitHub PKB**

It also:

- preserves folder structure and `.order` files
- ignores `.git`
- stores sync state in a configurable JSON file
- supports one config/state pair per solution
- detects same-path divergence on both sides since the last sync
- stops on conflicts unless `-Force` is used
- supports bootstrap initialization when no state file exists yet

---

# Recommended folder model

Example solution layout:

```text
D:\GitHub\markdown-knowledgebase-exporter\pkb
D:\GitHub\MKBE_PKB\Markdown-Knowledgebase-Exporter.wiki
D:\GitHub\GitHub-PKB-ADO-Wiki-Sync
```

Expected mapping:

- source PKB folder contents -> wiki repo root
- `pkb\Home.md` -> `Home.md`
- `pkb\Home\...` -> `Home\...`
- `pkb\.order` -> `.order`

The `pkb` folder itself is **not** copied as a top-level folder into the wiki repo. Only its contents are mirrored into the wiki repo root.

---

# Repo contents

```text
GitHub-PKB-ADO-Wiki-Sync/
├── README.md
├── sync_github_pkb_ado_wiki.ps1
├── sync.config.example.json
├── .gitignore
├── configs/
│   ├── mkbe.sync.json
│   ├── mkbe.sync.state.json
│   └── other-solution.sync.json
└── launchers/
    ├── status.cmd
    ├── publish.cmd
    ├── pullback.cmd
    ├── mkbe-status.cmd
    ├── mkbe-publish.cmd
    └── mkbe-pullback.cmd
```

---

# Configuration

Copy `sync.config.example.json` to a solution-specific config file and update the paths.

Example:

```json
{
  "source_pkb_path": "D:\\GitHub\\markdown-knowledgebase-exporter\\pkb",
  "wiki_repo_path": "D:\\GitHub\\MKBE_PKB\\Markdown-Knowledgebase-Exporter.wiki",
  "state_file": ".\\mkbe.sync.state.json"
}
```

## Configuration rules

- `source_pkb_path` is the authoritative PKB folder inside the source repo
- `wiki_repo_path` is the root of the ADO Wiki Git repo
- `state_file` is optional
- if `state_file` is relative, it is resolved **relative to the config file's directory**
- if `state_file` is omitted, the tool creates a default state file beside the config file using the config filename

Example:

- config: `configs\mkbe.sync.json`
- default state file if omitted: `configs\mkbe.sync.state.json`

You can also override paths on the command line.

---

# Usage

## 1. Status

```powershell
.\sync_github_pkb_ado_wiki.ps1 status -ConfigPath .\configs\mkbe.sync.json
```

## 2. Publish GitHub PKB -> ADO Wiki

```powershell
.\sync_github_pkb_ado_wiki.ps1 publish -ConfigPath .\configs\mkbe.sync.json
```

## 3. Pull back ADO Wiki -> GitHub PKB

```powershell
.\sync_github_pkb_ado_wiki.ps1 pullback -ConfigPath .\configs\mkbe.sync.json
```

## 4. Force through a detected conflict

```powershell
.\sync_github_pkb_ado_wiki.ps1 publish -ConfigPath .\configs\mkbe.sync.json -Force
```

## 5. Override config-defined paths directly

```powershell
.\sync_github_pkb_ado_wiki.ps1 status `
  -ConfigPath .\configs\mkbe.sync.json `
  -SourcePkbPath "D:\GitHub\markdown-knowledgebase-exporter\pkb" `
  -WikiRepoPath "D:\GitHub\MKBE_PKB\Markdown-Knowledgebase-Exporter.wiki"
```

## 6. Override the state file directly

```powershell
.\sync_github_pkb_ado_wiki.ps1 status `
  -ConfigPath .\configs\mkbe.sync.json `
  -StateFile ".\configs\mkbe.alt.state.json"
```

---

# Launcher examples

Example MKBE launchers:

## `launchers\mkbe-status.cmd`

```batch
@echo off
title MKBE PKB Wiki Sync - Status
cd /d D:\GitHub\GitHub-PKB-ADO-Wiki-Sync
powershell -ExecutionPolicy Bypass -File ".\sync_github_pkb_ado_wiki.ps1" status -ConfigPath ".\configs\mkbe.sync.json"
echo.
pause
```

## `launchers\mkbe-publish.cmd`

```batch
@echo off
title MKBE PKB Wiki Sync - Publish
cd /d D:\GitHub\GitHub-PKB-ADO-Wiki-Sync
powershell -ExecutionPolicy Bypass -File ".\sync_github_pkb_ado_wiki.ps1" publish -ConfigPath ".\configs\mkbe.sync.json"
echo.
pause
```

## `launchers\mkbe-pullback.cmd`

```batch
@echo off
title MKBE PKB Wiki Sync - Pullback
cd /d D:\GitHub\GitHub-PKB-ADO-Wiki-Sync
powershell -ExecutionPolicy Bypass -File ".\sync_github_pkb_ado_wiki.ps1" pullback -ConfigPath ".\configs\mkbe.sync.json"
echo.
pause
```

---

# Conflict model

The tool tracks file snapshots from the last successful sync.

If the **same relative path** changed on both sides since that sync, the tool treats that as a conflict and stops.

This prevents silent loss of meaning when both the GitHub PKB and the ADO Wiki repo have changed the same file independently.

If you intentionally want one side to win, use `-Force`.

The tool does **not** attempt line-level merges.

---

# Bootstrap behavior

If no state file exists yet:

- `status` reports the sync as **uninitialized**
- `publish` or `pullback` establishes the first baseline state
- first-run status may show both sides as changed relative to an empty baseline, but conflicts are not raised until a real baseline exists

---

# Sync state

The tool writes its sync state to the configured `state_file`.

That file records:

- source PKB path
- wiki repo path
- last sync UTC timestamp
- last sync direction
- source snapshot
- wiki snapshot

Recommended practice:

- store one state file per config
- keep config and state files together in the sync tool repo
- do not store state inside the PKB source repo
- do not store state inside the ADO Wiki repo unless you deliberately want that behavior

---

# Expected workflow

## Normal publish workflow

1. Edit PKB in the source repo.
2. Run `status`.
3. Run `publish`.
4. Review diffs in both repos.
5. Commit/push source repo changes.
6. Commit/push wiki repo changes.

## Occasional direct ADO Wiki edit workflow

1. Edit in the ADO Wiki repo.
2. Run `status`.
3. Run `pullback`.
4. Review diffs in both repos.
5. Commit/push wiki repo changes.
6. Commit/push source repo PKB changes.

---

# PowerShell execution policy

If PowerShell blocks script execution, run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Then rerun the command.

---

# Notes

- This tool is intentionally small and conservative.
- It is designed for PKB folder synchronization, not generic Git mirroring.
- It preserves structure and special wiki files such as `.order`.
- It excludes `.git`.
- It excludes the configured sync state file from mirrored content.
- It treats same-path divergence as a conflict instead of guessing.

---

# Future improvements

Possible later additions:

- dry-run mode
- richer conflict reports
- file hash comparison instead of timestamp/size only
- deletion policy options
- support for multiple named sync targets from a single config
- CI-friendly non-interactive reporting
- structured log output
- optional promotion of launchers from config metadata