# Codex Prompt Hygiene

## Principle

Treat Codex like an extremely smart dumb terminal. The user configures repo, branch/ref, mode, and PR target in the Codex UI. The prompt body should not manage those concerns.

## Pre-prompt block for the user only

Always provide this outside the Codex prompt body:

```text
Codex task setup:
- Use: New task / Existing task
- Repo to select in Codex UI: ...
- Branch/ref to select in Codex UI: ...
- Mode: Planning / Code
- PR target, if applicable: ...
```

## Codex prompt body contents

Include only what Codex can act on:

- task;
- required preflight;
- files to inspect or modify;
- exact changes or exact output required;
- constraints;
- stop conditions;
- validation;
- final report format.

## Remove by default

Do not include by default:

- repo setup;
- branch checkout;
- remote fetch;
- `origin/...` verification;
- HEAD/SHA/status reporting;
- PR target routing;
- prior PR history;
- RMF/PBI history;
- long rationale or narrative.

Include Git commands only when the task itself is about Git operations.

## Planning vs implementation

For Planning mode, use one sentence such as:

```text
Produce a report only; do not implement.
```

For Code/Implementation mode, specify exact file scope and validation. Do not tell Codex how to create its task branch unless the task is Git-specific.
