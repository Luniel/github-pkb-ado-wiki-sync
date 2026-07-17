# Protected Manuscript Publishing Workflow

This document describes a separate protected manuscript-publishing capability. This PR does not modify `Luniel/book-the-gap`, does not modify `Luniel/book-the-gap-publishing`, and does not perform a real synchronization.

## Rationale and boundary

The confidential source repository remains authoritative for normal authorship. The sanitized publishing repository is the confidentiality boundary for Leanpub/publication operations. Branches are not a confidentiality boundary: every branch in a repository is still part of the same repository access surface.

The tool mirrors the complete English `manuscript/` tree only:

```text
<source_repo_path>/manuscript/ -> <publishing_repo_path>/manuscript/
```

It does not parse `book.txt`, interpret Markdown or Markua, or select files from publication metadata.

Publishing-only files outside the mirrored `manuscript/` tree may remain in the publishing repository. The sync engine never touches the root README, marker, `.git`, or files outside `manuscript/`.

## Engine and wrappers

`protected_manuscript_sync.py` is the generic Python engine. Book-specific PowerShell wrappers, such as `launchers/the-gap-manuscript-sync.ps1`, only locate Python, choose a default local config path, and forward arguments. Add another book by creating another thin wrapper and config; do not copy synchronization logic.

## Configuration schema

Example committed template:

```json
{
  "schema_version": 1,
  "source_repo_path": "D:\\GitHub\\book-the-gap",
  "publishing_repo_path": "D:\\GitHub\\book-the-gap-publishing",
  "expected_target_id": "the-gap-publishing",
  "state_file": ".\\the-gap-manuscript-sync.state.json"
}
```

`schema_version`, `source_repo_path`, `publishing_repo_path`, and `expected_target_id` are required. `state_file` is optional; when omitted, the engine writes a state file beside the config using the config file name plus `.state.json`. Relative paths resolve relative to the config file directory. Actual The Gap config and state should live under ignored `local-only/`.

## Marker contract

The publishing repository root must contain `.protected-manuscript-publishing-target`. It must be a regular UTF-8 text file whose trimmed content exactly equals `expected_target_id`. For The Gap, the content will be `the-gap-publishing`. The tool validates but never creates, edits, or deletes this marker.

## Commands

```powershell
python protected_manuscript_sync.py status --config <config-path>
python protected_manuscript_sync.py publish --config <config-path>
.\launchers\the-gap-manuscript-sync.ps1 status
.\launchers\the-gap-manuscript-sync.ps1 publish
.\launchers\the-gap-manuscript-sync.ps1 status -ConfigPath <path>
```

Humans must confirm clean working trees and review diffs separately. The tool performs no Git operations.

## Protection model

The state file records the last accepted baseline where source and target were intentionally identical. Status classifications are:

- no state and absent/empty target: safe initial publish;
- no state and target equals source: safe baseline initialization;
- no state and non-empty differing target: blocked;
- initialized and `S == B`, `T == B`: in sync;
- initialized and `S != B`, `T == B`: source-only changes, safe to publish;
- initialized and `S == B`, `T != B`: target-only divergence, blocked;
- initialized and both changed but `S == T`: already reconciled identically, safe baseline refresh;
- initialized and both changed differently: conflict, blocked.

There is no automated reverse synchronization, no pullback action, no force option, no environment-variable bypass, and no interactive override.

## First-run bootstrap

Run `status` first. If target `manuscript/` is absent or empty, `publish` may create the mirror and baseline. If target already equals source, `publish` initializes the baseline without rewriting content. If target is non-empty and differs, reconcile manually before publishing.

## Normal and blocked workflows

For normal publishing, edit the confidential source repository, review source changes, run `status`, run `publish` only when safe, then review and commit publishing repository changes manually.

If Leanpub or a human changes the publishing repository, target divergence blocks publish. Return approved improvements through a source-side branch such as `leanpub/return-<initiative>`. Human Git techniques outside this tool include direct cherry-pick, `cherry-pick --no-commit`, controlled merge, and selective file/hunk import. After both manuscript trees are intentionally identical, run `publish` to refresh the accepted baseline.

## Exit codes

- `0`: successful status or publish; no blocked condition
- `2`: configuration, marker, state, or path-safety validation failure
- `3`: publishing-side divergence or source-target conflict blocked
- `4`: mutation, rollback, or post-verification failure

## Rollback design

Before mutation, the engine snapshots source and target, creates a staged source copy in a temporary directory outside both repositories, and preserves a rollback copy of the existing target manuscript. If mutation or verification fails, the state file is left unchanged and the target manuscript is restored from rollback.

## The Gap local acceptance checklist

Use disposable repositories first:

- [ ] Windows PowerShell 5.1 wrapper test
- [ ] PowerShell 7 wrapper test when available
- [ ] paths with spaces
- [ ] missing config
- [ ] missing marker
- [ ] wrong marker
- [ ] initial empty target
- [ ] initial identical target
- [ ] initial differing target block
- [ ] source-only add/change/delete
- [ ] target-only divergence block
- [ ] both-sides conflict block
- [ ] identical manual reconciliation and baseline refresh
- [ ] binary file preservation
- [ ] wrapper output
- [ ] wrapper exact exit-code propagation
- [ ] Windows junction/reparse-point rejection
- [ ] rollback behavior
- [ ] confirmation that root README and all files outside target `manuscript/` remain unchanged

Place the real repositories last:

```text
D:\GitHub\book-the-gap
D:\GitHub\book-the-gap-publishing
D:\GitHub\GitHub-PKB-ADO-Wiki-Sync
```

The first real action must be `status`, not `publish`.

## Real first-publish safety checklist

- [ ] Real source and publishing working trees are clean by human Git inspection.
- [ ] The publishing repository marker exists and contains the expected target ID.
- [ ] The local config lives under `local-only/` and the state file will also live there.
- [ ] `status` reports a safe initial publish, safe baseline initialization, or safe source-only publish.
- [ ] No target-side divergence is reported.
- [ ] No machine-specific config or state is committed.
- [ ] Review publishing repository diff after publish before any human commit.
