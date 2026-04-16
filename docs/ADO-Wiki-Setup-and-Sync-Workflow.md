# ADO Wiki Setup and Sync Workflow

This document explains how to:

- treat an in-repo PKB as the authoritative source
- publish that PKB into an Azure DevOps Wiki Git repository
- keep the two repos in sync using `sync_github_pkb_ado_wiki.ps1`
- allow occasional direct edits in the ADO Wiki repo without silently losing meaning

This is an operational support document for the sync tool.
It does **not** redefine PKB doctrine, PKBDD authority, or Azure DevOps Wiki behavior.

---

# 1. Stewardship model

This tool assumes the following stewardship model:

- the **solution repository** contains the authoritative `pkb/` folder
- the **ADO Wiki Git repo** is a publish target and optionally an editing surface
- the sync tool sits outside both content surfaces and keeps state in its own repo
- synchronization is explicit, reviewable, and conflict-aware

In other words:

- **GitHub PKB is authoritative by default**
- **ADO Wiki is published working surface**
- **pullback exists for governed exceptions, not casual drift**

---

# 2. Recommended local folder layout

Example:

```text
D:\GitHub\MySolution\pkb
D:\GitHub\MySolution_PKB\MySolution.wiki
D:\GitHub\GitHub-PKB-ADO-Wiki-Sync
```

Expected mapping:

- `D:\GitHub\MySolution\pkb\Home.md` -> `D:\GitHub\MySolution_PKB\MySolution.wiki\Home.md`
- `D:\GitHub\MySolution\pkb\Home\...` -> `D:\GitHub\MySolution_PKB\MySolution.wiki\Home\...`
- `D:\GitHub\MySolution\pkb\.order` -> `D:\GitHub\MySolution_PKB\MySolution.wiki\.order`

The top-level `pkb` folder itself is **not** mirrored as a folder into the wiki repo.
Only its **contents** are mirrored into the wiki repo root.

---

# 3. One-time ADO Wiki setup

## 3.1 Create or identify the ADO Wiki

In Azure DevOps:

1. Create the wiki if it does not already exist.
2. Open the wiki in Azure DevOps.
3. Locate the option to clone the wiki Git repo.
4. Copy the clone URL.

## 3.2 Clone the ADO Wiki repo locally

Example:

```powershell
git clone <ADO-WIKI-CLONE-URL> "D:\GitHub\MySolution_PKB\MySolution.wiki"
```

Open the folder locally and confirm it is a normal Git working tree.

## 3.3 Confirm expected wiki structure

Azure DevOps Wiki stores content as Markdown files and folders.
When a parent page has children, ADO Wiki may represent that using both:

- `Parent-Page.md`
- `Parent-Page\`

This is normal and should be preserved.

`.order` files are also normal and should be preserved when present.

---

# 4. Configure the sync tool

Copy the example config:

```text
configs\sync.config.example.json
```

Create a solution-specific config such as:

```text
configs\mysolution.sync.json
```

Example:

```json
{
  "source_pkb_path": "D:\GitHub\MySolution\pkb",
  "wiki_repo_path": "D:\GitHub\MySolution_PKB\MySolution.wiki",
  "state_file": ".\mysolution.sync.state.json"
}
```

### Config meaning

- `source_pkb_path` = authoritative PKB folder inside the solution repo
- `wiki_repo_path` = root of the ADO Wiki Git repo
- `state_file` = sync state file written by the tool

If `state_file` is relative, it is resolved relative to the config file directory.

Recommended practice:

- one config per solution
- one state file per config
- keep both in the sync tool repo
- do not store the state file inside the PKB repo or wiki repo

---

# 5. Optional launcher setup

You can run the PowerShell script directly, but solution-specific launcher files make the workflow faster.

Example launcher files:

## `launchers\mysolution-status.cmd`

```batch
@echo off
title MySolution PKB Wiki Sync - Status
cd /d D:\GitHub\GitHub-PKB-ADO-Wiki-Sync
powershell -ExecutionPolicy Bypass -File ".\sync_github_pkb_ado_wiki.ps1" status -ConfigPath ".\configs\mysolution.sync.json"
echo.
pause
```

## `launchers\mysolution-publish.cmd`

```batch
@echo off
title MySolution PKB Wiki Sync - Publish
cd /d D:\GitHub\GitHub-PKB-ADO-Wiki-Sync
powershell -ExecutionPolicy Bypass -File ".\sync_github_pkb_ado_wiki.ps1" publish -ConfigPath ".\configs\mysolution.sync.json"
echo.
pause
```

## `launchers\mysolution-pullback.cmd`

```batch
@echo off
title MySolution PKB Wiki Sync - Pullback
cd /d D:\GitHub\GitHub-PKB-ADO-Wiki-Sync
powershell -ExecutionPolicy Bypass -File ".\sync_github_pkb_ado_wiki.ps1" pullback -ConfigPath ".\configs\mysolution.sync.json"
echo.
pause
```

These launcher files can be executed directly from Windows Explorer.

---

# 6. Bootstrap the first sync

After the PKB and wiki repo both exist locally:

## 6.1 Check status

```powershell
.\sync_github_pkb_ado_wiki.ps1 status -ConfigPath .\configs\mysolution.sync.json
```

If no state file exists yet, the tool treats sync as uninitialized.
That is expected.

## 6.2 Establish the baseline

If the in-repo PKB is the authority you want to publish into the wiki repo, run:

```powershell
.\sync_github_pkb_ado_wiki.ps1 publish -ConfigPath .\configs\mysolution.sync.json
```

This will:

- mirror PKB contents into the wiki repo root
- preserve structure and `.order` files
- write the initial sync state file

After that, run status again.

A clean result should show no meaningful divergence.

---

# 7. Normal operating workflow

## 7.1 Standard publish workflow

Use this when the PKB was changed in the solution repo.

1. Edit PKB in the solution repo.
2. Run `status`.
3. Run `publish`.
4. Review diffs in both repos.
5. Commit/push solution repo changes.
6. Commit/push wiki repo changes.

This is the default workflow.

## 7.2 Occasional direct wiki edit workflow

Use this only when you intentionally edited the ADO Wiki repo directly.

1. Edit the wiki repo.
2. Run `status`.
3. Run `pullback`.
4. Review diffs in both repos.
5. Commit/push wiki repo changes.
6. Commit/push solution repo PKB changes.

This is an exception workflow, not the default operating mode.

---

# 8. Conflict handling

The tool records the last successful sync state.
If the **same relative path** changed on both sides since that sync, the tool stops and reports a conflict.

This is intentional.
The tool is conservative by design.
It does **not** attempt line-level merges.

If one side should intentionally overwrite the other, use `-Force`.

Example:

```powershell
.\sync_github_pkb_ado_wiki.ps1 publish -ConfigPath .\configs\mysolution.sync.json -Force
```

Use that only when you have already reviewed the divergence.

---

# 9. What is authoritative and what is not

This is the most important operating rule.

## Authoritative by default

- the in-repo PKB in the solution repository

## Non-authoritative publish / working surface

- the ADO Wiki Git repo
- the rendered ADO Wiki UI

## Tool-owned operational state

- sync config files
- sync state files
- launcher files

The sync tool exists to preserve structural fidelity between the authoritative PKB and the wiki surface.
It does not make the wiki the authority merely because the wiki is convenient to browse.

If you choose to edit in the wiki repo directly, that is a governed operational exception and should be pulled back explicitly.

---

# 10. Good practices

- keep one config/state pair per solution
- keep sync state outside content repos
- review diffs in both repos before committing
- prefer publish over pullback for normal operation
- use pullback only when direct wiki edits were intentional
- treat `-Force` as an explicit overwrite decision, not a normal workflow step
- preserve `.order` files
- do not store unrelated notes or operational state inside the wiki content root

---

# 11. Common mistakes to avoid

- copying the whole `pkb` folder into the wiki repo as a nested folder
- storing the sync state file in the wiki repo root
- treating the rendered ADO Wiki as the authority by accident
- editing both sides casually and expecting silent merge behavior
- forgetting to review diffs after publish or pullback
- using the tool as if it were generic Git mirroring rather than PKB-to-wiki synchronization

---

# 12. Minimal quick-start checklist

- [ ] Clone the ADO Wiki repo locally
- [ ] Confirm the in-repo PKB folder path
- [ ] Create a solution-specific sync config
- [ ] Create optional launcher files
- [ ] Run `status`
- [ ] Run initial `publish`
- [ ] Review diffs
- [ ] Commit and push both repos
- [ ] Use `publish` as the default ongoing workflow
- [ ] Use `pullback` only for intentional direct wiki edits
