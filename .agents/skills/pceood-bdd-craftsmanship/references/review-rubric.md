# Producore BDD Review Rubric Reference

## Purpose

This reference is for reviewing behavioral-specification drafts against Producore-style BDD craftsmanship.

It is not a generic BDD checklist.

It is specifically for detecting where a draft has drifted into narrative, inference, implementation leakage, tooling convenience, generic Cucumber-style habits, or any other form that weakens the behavioral contract surface.

## Severity Levels

Use three severity levels.

### Hard fail
The draft is not acceptable as a Producore behavioral specification.

### Major defect
The draft is structurally weak and not ready for downstream use.

### Drift / non-preferred
The draft may still be recoverable, but it has drifted away from Producore-first craftsmanship and should be tightened.

## Hard Fail Criteria

A draft is a hard fail if any of the following are true.

### 1. Interpretation is required
- Different readers could reasonably derive different behavioral meaning.
- Engineering, QA, product, or automation would need to infer what was intended.
- The draft requires explanation to implement correctly.

### 2. It is not a valid state-event-state contract
- `Given` does not define the full required start-state.
- `When` is not one bounded primary event.
- `Then` does not define resulting state and constraints.
- The draft reads as narrative instead of deterministic transformation.

### 3. Implementation appears in the specification surface
- Internal services, loops, API calls, database updates, orchestration, code-facing mechanics, step-binding mechanics, or test-framework behavior appear in the acceptance surface.

### 4. Multiple events are collapsed into one scenario
- `When` hides a sequence.
- Predecessor events are buried in `Given`.
- Successor events are buried in `Then`.
- The scenario is really a journey or use case, not one behavioral unit.

### 5. `Then` is temporal or narrative
- Sequence appears in `Then`.
- Intermediate transitions appear in `Then`.
- Temporal phrasing such as `eventually`, `after that`, `starts doing`, `finishes doing`, or equivalent progression language appears.

### 6. Material state is missing
- Required entities, values, relationships, constraints, or environmental conditions are omitted.
- The outcome only makes sense if hidden assumptions are supplied.

### 7. Examples are doing rule-definition work
- The governing rule must be inferred from examples.
- The examples are being treated as the specification.

### 8. Automation would have to invent behavior
- Automation would need to guess missing state.
- Automation would need to infer unstated relationships.
- Automation would need to encode business rules that the specification failed to make explicit.

### 9. Observation, implementation, or tests have been treated as the contract
- Current implementation is implicitly defining the requirement.
- Test artifacts are functioning as the requirement surface.
- Observed current behavior is being treated as authoritative without explicit specification.

## Major Defect Criteria

A draft has a major defect if any of the following are true.

### 10. Dangling elements exist
- Entities or values are introduced but not used.
- Entities or values are used but not introduced.
- `When` contains values with no origin.
- `Then` contains outputs with no grounded precursor.
- Transformations are implied but not explicitly modeled.

### 11. Hidden assumptions remain
- Domain knowledge is required.
- Previous-scenario knowledge is required.
- Defaults are assumed but unstated.
- Variable naming is being used in place of explicit state establishment.

### 12. Granularity is wrong
- The scenario is too large and contains multiple business decisions or an entire use case.
- The scenario is too small and is merely a mechanical fragment without meaningful behavioral value.

### 13. Mixed behavior concerns are present
- One scenario is trying to prove several concerns at once.
- The outcome surface is unstable.
- The scenario is overloaded.

### 14. Meaningful permutations were not processed
- Meaningful variants are visible but were not surfaced.
- Edge conditions were discovered but not classified.
- Variants were neither specified, deferred explicitly, rejected explicitly, nor flagged for research.

### 15. Relevant questions were not externalized
- Unresolved meaning is left inside the scenario as residue.
- Missing behavior is left for implementation or testing to improvise.
- Follow-up concerns were neither incorporated nor captured explicitly.

### 16. Scenario Template misuse is present
- Rows hide branch changes.
- Rows have different outcomes.
- Rows contain row-specific `Then` mutations.
- Rows would not stand as acceptable full scenarios independently.

### 17. `Background` hides meaningful variability
- Meaningful preconditions were moved into `Background`.
- Behavioral variability became invisible.
- `Background` conceals hidden events or capability-specific conditions.

### 18. Hidden rules are buried in tables
- A table is doing behavioral-rule work without explicit scenario wording.
- A clause data table is being used like a substitution table.
- Rule meaning is encoded in tabular shorthand instead of explicit contract language.

### 19. Scenario naming is defective
- The name does not identify the primary event.
- The name includes the outcome.
- The name summarizes the whole scenario instead of identifying the behavioral instance.
- The name uses `when` to express conditional context rather than event identity.
- The name is overloaded with detail such that ordinary refinement causes rename churn.

### 20. Domain language has been replaced by tool language
- Automation or framework terminology has displaced domain-facing contract language.
- The draft reads like a tool artifact rather than a behavioral specification.

### 21. The draft is written as a test script
- It reads like execution instructions.
- It reads like a manual test procedure.
- It reads like automation-driving prose rather than a behavioral contract.

### 22. Behavior has been reduced to output only
- Start-state is weak or absent.
- Event boundary is weak or absent.
- `Then` is detached from explicit transformation.

### 23. Actor use is unnecessary and weakens the contract
- Actor-centered narrative was introduced where object-state formulation would be stronger.
- The actor is not behaviorally required but has been made structurally central.

### 24. Repetition was removed even though it preserved contract strength
- Identity continuity was weakened.
- Non-creation or non-duplication constraints were weakened.
- Cardinality visibility was weakened.
- Explicit end-state constraints were compressed into looser summary language.

## Drift / Non-Preferred Criteria

These are not always structural invalidity, but they are still signs of generic-BDD drift.

### 25. Generic normalization weakened the formulation
- Wording is cleaner but less explicit.
- State was compressed into prose.
- Relationship assertions were softened into summary language.
- The draft became more mainstream-BDD-friendly and less contract-strong.

### 26. Gherkin-native containers are being over-trusted
- `Feature` is being treated as more than a grouping container.
- `Rule` is being treated as the contract rather than an explanatory container.
- Container prose is doing behavioral work scenarios should do.

### 27. Domain variables and template parameters are blurred
- Square-bracket variables and angle-bracket row parameters are being treated interchangeably.

### 28. Special tokens are vague
- Tokens such as `empty` or `anything` hide specificity that should be explicit.

### 29. The expression surface has become too code-like
- Mathematical clarity has crossed into programming-surface behavior.
- Business reviewability has been reduced.

### 30. Presentation conventions are ignored in ways that harm reviewability
- Visual structure is poor enough to make the contract harder to inspect.
- Labels are used in ways that blur container distinctions.
- Formatting increases review friction.


## Producore Violation Review

A scenario or behavior specification fails review if it contains unresolved blocking Producore violations.

Reviewers must check:
- whether concrete literals are domain-required or merely example/test data
- whether examples are being used as the specification
- whether role variables should replace arbitrary values
- whether implementation or automation details have leaked into the behavioral contract
- whether the scenario defines starting state, focal event, and resulting state without invention
- whether every Given, Then, variable, data table element, and Scenario Template column is critical
- whether support surfaces are carrying missing behavior

## One-Pass Gate

Reject or return for refinement if the answer to any of the following is `No`.

- Is the draft an exact start-state plus one event plus resulting state contract?
- Can all readers reach the same interpretation without explanation?
- Is every important entity, value, and relationship grounded explicitly?
- Is there exactly one primary event?
- Does `Then` describe resulting state and constraints rather than sequence or choreography?
- Is implementation absent?
- Could engineering implement it without invention?
- Could automation consume it without invention?
- Are hidden assumptions absent?
- Are hidden events absent?
- Are meaningful variants either specified or explicitly externalized?
- Does the scenario name identify the event without including the outcome?
- Is the wording domain-facing rather than tool-facing?
- Is the draft a behavioral contract rather than a test script?

## Review Verdicts

### Red
Use when any hard fail is present.

**Verdict:** Reject. Rewrite required.

### Amber
Use when no hard fail is present, but one or more major defects remain.

**Verdict:** Not ready. Refine before downstream use.

### Yellow
Use when no hard fail or major defect remains, but non-preferred drift is still visible.

**Verdict:** Recoverable draft. Tighten before treating as strong Producore artifact.

### Green
Use when no hard fail, no major defect, and no meaningful drift remain.

**Verdict:** Strong Producore-style behavioral specification candidate.

## Reviewer Notes Template

### Verdict
- Red / Amber / Yellow / Green

### Hard fails
- None / list them explicitly

### Major defects
- None / list them explicitly

### Drift / non-preferred findings
- None / list them explicitly

### Required corrections
- State exactly what must be rewritten

### Externalized follow-ups
- List permutations, open questions, or related scenarios that do not belong inside the current scenario

## Core Review Principle

Reject the draft if it:
- makes the reader infer
- makes the author explain
- makes engineering invent
- makes automation invent
- hides state
- hides events
- hides rules
- tells a story instead of specifying a contract
- describes implementation instead of constraints
- uses examples as the rule
- writes a test script instead of a behavioral specification
