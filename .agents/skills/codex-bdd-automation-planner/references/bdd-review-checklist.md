# BDD Automation Review Checklist

Use this checklist when reviewing Codex output, PRs, or implementation plans for BDD automation.

## Feature fidelity

- Feature file contains only approved scenarios.
- Scenario names match exactly.
- Clause wording matches exactly.
- No comments or explanatory lines were added to the feature file unless explicitly approved.
- Excluded scenarios remain excluded.

## PCEOOD / PKBDD posture

- Implementation remains downstream of specification.
- Tests validate conformance; they do not define behavior.
- Automation bindings do not infer missing behavior.
- Engineering friction is captured as a collaboration/maturation question when needed.
- Production behavior changes are absent unless explicitly authorized.

## Binding mechanics

- Every parameterized binding attribute has exactly one placeholder/capture per method parameter.
- Literal-only attributes have zero parameters.
- Reqnroll/SpecFlow/Cucumber expressions match existing repo patterns.
- StepArgumentTransformation names and patterns are real or proposed with exact file/path/declaration.
- Bracket variables are consumed as variable keys, not hard-coded aliases.
- Equivalent aliases remain possible where the spec semantics allow.

## Fixture and state handling

- Scenario state lives in fixtures, drivers, or approved test seams.
- No incidental binding instance fields unless the repo already uses that pattern and it is safe.
- No parallel state system is added when existing fixture tables/drivers are sufficient.
- New fixture types follow the repo’s existing factory/interface pattern.

## Proof path

- Bindings arrange inputs and trigger app behavior; they do not manufacture evidence.
- Page-access/request evidence is recorded only when the app/session path calls the seam.
- Redirects come from app/session/server behavior or an approved test-side response seam.
- Final route/current URI assertions prove route outcomes when approved.
- UI/rendered-component assertions are not added unless approved by the spec or user.

## Diff inspection before merge recommendation

- Do not recommend merge from a final report alone.
- Treat final reports as claims requiring diff and validation inspection.
- Inspect the actual diff before declaring the result mergeable.
- Verify allowed file scope, feature text, binding mechanics, proof path, and validation evidence.
- If the report looks correct but the diff has not been inspected, use: `Provisionally acceptable pending diff inspection`.

## Validation

- Required build/test commands ran successfully.
- Filtered BDD run actually executed the intended scenarios.
- Full relevant test suite ran when required.
- `git diff --check` or equivalent formatting/whitespace validation passed.
- Final status was inspected.
- If validation could not run, the task stopped without PR unless explicitly allowed.

## Reject/request changes if

- Codex opened a PR without required validation.
- Codex claims no unresolved concerns while validation failed or did not run.
- Production files changed without explicit authorization.
- Helper names/classes/constants are invented but not declared.
- The result asks questions already answered by the user.
- The implementation drifts into behavior/specification authority.
