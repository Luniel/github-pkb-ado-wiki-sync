---
name: codex-bdd-automation-planner
description: use when the user asks ChatGPT to plan, prompt, or review Codex work for BDD/SpecFlow/Reqnroll/Cucumber automation, especially in PCEOOD/PKBDD-governed repositories. Triggers include creating Codex prompts for executable BDD, converting Gherkin/spec text into source-side test implementation plans, reviewing Codex BDD PRs/results, separating ChatGPT planning from Codex implementation, enforcing Codex prompt hygiene, and preventing repo/branch UI setup, backstory, hidden behavior authority, or unverifiable history from leaking into Codex prompts.
---

# Codex BDD Automation Planner

Version: v6

## Operating model

Use ChatGPT for specification judgment, PCEOOD/PKBDD boundary protection, source-pattern analysis, implementation planning, and review.

Use Codex for applying an already-approved mechanical plan, editing files, running validation, iterating on build/test failures, and producing a PR.

Default split:

```text
ChatGPT designs.
User approves.
Codex implements.
ChatGPT reviews.
```

## Core rules

- Treat Codex like an extremely smart dumb terminal.
- Give Codex actionable task instructions only.
- Do not include repo, branch, checkout, fetch, remote, HEAD, SHA, or PR-target setup in the Codex prompt body unless the task is explicitly about Git operations.
- Put Codex UI setup details in a separate pre-prompt block for the user only.
- Exclude backstory, PR history, RMF/PBI history, and anything Codex cannot directly act on.
- Do not ask Codex to invent repo-specific implementation design when ChatGPT can inspect the repo and produce the design.
- Do not let tests, bindings, or automation become hidden behavior authority.
- Treat PCEOOD compliance as the default operating boundary for BDD automation work. Do not proceed under weaker fallback governance.

## PCEOOD/PKBDD boundary

Use [pceood-bdd-codex-guardrails.md](references/pceood-bdd-codex-guardrails.md) for BDD automation work and whenever the user names PCEOOD, PKBDD, Producore, RMF, capability behavior, or authoritative specification.

Key boundary:

- Specification expresses behavior for implementation and validation.
- Implementation realizes specification.
- Tests validate conformance.
- Tests and automation do not define behavior.
- Engineering friction is feedback into shared understanding, not an instruction to force automation at all costs.

## Workflow decision tree

1. **User asks for a Codex prompt for BDD automation**
   - First decide whether ChatGPT must inspect the repo and produce an implementation plan.
   - Use [codex-prompt-hygiene.md](references/codex-prompt-hygiene.md).

2. **BDD implementation is non-trivial, repo-specific, PCEOOD-governed, or has failed before**
   - Do not send Codex a broad planning task by default.
   - ChatGPT should inspect source patterns, produce the implementation plan, ask the user to approve material test-harness or proof-path decisions, then produce an implementation-only Codex prompt.
   - Use [bdd-automation-implementation-planning.md](references/bdd-automation-implementation-planning.md).

3. **User shares a Codex result, PR, or failed run**
   - Review it against [bdd-review-checklist.md](references/bdd-review-checklist.md).
   - Identify whether to request changes, abandon/restart, ask for validation, convert failures into Engineering/Product questions, or mark it provisionally acceptable pending diff inspection.
   - Do not recommend merge from the Codex final report alone.

4. **User asks whether to change a spec, narrow automation, or push forward**
   - Keep collaboration posture.
   - Do not force specs onto Engineering.
   - Treat automation friction as evidence for shared Product/Engineering understanding.
   - Recommend PKB/RMF/spec maturation only when the approved behavior or automation treatment is genuinely unclear.

## Pre-prompt block for the user only

Before every Codex prompt, provide a setup block for the user outside the Codex prompt body:

```text
Codex task setup:
- Use: New task / Existing task
- Repo to select in Codex UI: ...
- Branch/ref to select in Codex UI: ...
- Mode: Planning / Code
- PR target, if applicable: [target branch selected in Codex UI]
```

Use the actual target/base branch for the PR target. If it is unknown, use the neutral placeholder `[target branch selected in Codex UI]`. Do not use the implementation branch as the PR target unless the user explicitly says the task is to update an existing PR branch.

Do not put this block inside the Codex prompt body.

## Codex prompt body rules

A Codex prompt body should usually contain only:

```text
Task
Required preflight
Files to inspect/change
Exact implementation plan or exact planning output required
Constraints
Stop conditions
Validation
Output format
```

Avoid:

- repo/branch selection instructions;
- `git fetch`, `git checkout`, HEAD, SHA, origin, remote, or status checks unless the task is Git-specific;
- narrative history;
- RMF/PBI/PR backstory unless Codex must edit that exact artifact;
- “same task checkout” language;
- vague phrases like “use existing patterns” without exact file/symbol references when implementation is requested.

## Required preflight for BDD automation work

For BDD automation work, require Codex to read repo-local governance files:

```text
AGENTS.md
CODEX_WORKFLOW_SOP.md
PCEOOD/01 - README.md
PCEOOD/09 - Producore Canonical Guide - Producore Engineering Doctrine.md
.agents/skills/pceood-bdd-craftsmanship/SKILL.md
```

Also require Codex to read all references required by the repo-local BDD craftsmanship skill.

If any required governance file cannot be loaded, the Codex task must stop and report. Do not let Codex decide that prompt-only governance is sufficient. Do not proceed under fallback governance.

## Planning rule

Before writing an implementation prompt, ChatGPT should inspect source examples and produce a concrete plan covering:

- exact feature text to create/replace;
- exact files allowed to change;
- exact existing symbols to reuse;
- exact new symbols/classes/methods to add;
- exact Reqnroll/SpecFlow/Cucumber binding attributes;
- exact method signatures and parameter types;
- exact step argument transformations;
- exact fixture-table or singleton-driver resolution for each bracket token;
- exact event/action execution path under test;
- exact approved evidence surface for each Then clause;
- exact test-side seams and why they observe rather than define behavior;
- exact validation commands.

If a symbol is referenced, it must be either existing with file path or proposed as new with file path and declaration. Do not accept invented helper names in Codex plans.

## Implementation-prompt rule

When the implementation plan is approved, the Codex prompt should tell Codex to implement the exact plan. It should not ask Codex to redesign the plan.

Include a hard stop when validation is essential:

```text
If dotnet/build/test tooling is unavailable, stop without opening a PR.
```

Adjust the tooling name to the repo's stack.

## Review rule

When reviewing Codex BDD output:

- Treat Codex final reports as claims requiring diff and validation inspection.
- Do not declare Codex output mergeable from the final report alone.
- Use “Provisionally acceptable pending diff inspection” when the report looks correct but the diff has not yet been inspected.
- Inspect the diff, allowed file scope, feature text, binding mechanics, proof path, and validation evidence before recommending merge.

Reject or request changes if:

- feature text diverges from approved Gherkin;
- excluded scenarios are added;
- step attributes use literal bracketed variables while methods expect parameters;
- parameter count cannot match;
- bindings manufacture evidence they later assert;
- test seams define behavior instead of observing the real system path under test;
- Codex opened a PR without required build/test validation;
- final report claims no concerns while validation did not run;
- production files changed without explicit authorization.

## Output templates

Use templates from [output-templates.md](references/output-templates.md) when producing:

- implementation plan for user approval;
- Codex implementation prompt;
- Codex planning prompt, only when truly needed;
- Codex result/PR review.
