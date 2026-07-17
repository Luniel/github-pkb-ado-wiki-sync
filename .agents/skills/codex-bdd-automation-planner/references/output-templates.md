# Output Templates

## Implementation plan for user approval

```markdown
## Source patterns used
[Brief list of existing files/symbols inspected and adopted]

## Proposed file changes
[Exact file paths]

## Binding / fixture / seam plan
[Concrete symbols, methods, transformations, and proof paths]

## Material decisions needing approval
[Only decisions requiring user/Product/Engineering judgment]

## Recommendation
[Approve / revise / stop]
```

## Codex implementation prompt body

```markdown
# Codex Prompt: [task]

## Task
[Concrete implementation task]

## Required preflight
[Files to read and classification to report]

## Allowed files
[Exact allowed paths]

## Forbidden files
[Forbidden paths]

## Required changes
[Exact file-by-file implementation plan]

## Stop conditions
[When to stop instead of continuing]

## Validation
[Commands to run; require stop if unavailable]

## Final report
[Required headings]
```

Remember: put repo/branch/mode/PR target in the pre-prompt block for the user, not in this prompt body.

## Codex result review

```markdown
## Verdict
[Provisionally acceptable pending diff inspection / request changes / abandon / ask for validation]

## What is correct
[Short]

## Blocking issues
[Concrete, cited when possible]

## Required correction
[Actionable next prompt or user action]
```

## Minimal Codex follow-on prompt

```text
[Direct instruction]

Do not edit files unless explicitly authorized.
[Exact required output or correction]
[Stop condition]
```
