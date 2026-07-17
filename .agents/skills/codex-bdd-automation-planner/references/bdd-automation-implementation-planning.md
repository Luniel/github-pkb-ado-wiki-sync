# BDD Automation Implementation Planning

Use this guide before producing a Codex implementation prompt for non-trivial BDD automation.

## Source inspection sequence

Inspect, as applicable:

1. Existing feature files with similar wording.
2. Existing binding classes for naming, constants, and transformation style.
3. Existing step argument transformations.
4. Existing fixture and variable-table patterns.
5. Existing drivers and mocks used for actions and assertions.
6. The real domain/application/system execution path needed to produce the approved evidence.
7. Validation commands and project/test filters.

Do not ask Codex to rediscover this if ChatGPT can inspect it.

## Implementation-plan checklist

The plan must state:

- feature file path and exact desired feature text;
- allowed files and forbidden files;
- existing source patterns being followed;
- new files/classes/methods to add;
- exact binding attributes;
- exact method signatures;
- parameter-count proof for every binding;
- exact transformations and their return types;
- exact fixture resolution for every square-bracket variable;
- exact action that triggers the event under test;
- exact approved evidence surface for each Then clause;
- exact test-side seams and why they observe rather than define behavior;
- exact validation commands.

## Binding mechanics checklist

Reject plans where:

- literal bracketed step text is paired with method parameters;
- Cucumber-expression placeholders do not correspond to parameters;
- transformation names are invented without declarations;
- helper constants are referenced but not existing or explicitly proposed;
- square-bracket variables are treated as hard-coded aliases;
- state is stored in incidental binding fields when the repo has fixture/driver patterns.

## Test-side seam checklist

A test seam is acceptable when it observes or configures test state without defining product behavior.

Prefer seams that:

- log calls made by the real system path under test;
- configure test data consumed by existing behavior;
- assert final state already produced by the system under test.

Reject seams that:

- perform the product decision inside the binding;
- manually force the expected outcome after computing expected behavior;
- create a parallel domain state machine;
- add arbitrary behavior that production does not have.

## Codex implementation prompt checklist

Once the plan is approved, the prompt should be mechanical:

- implement these exact changes;
- stay in this file scope;
- stop if exact mechanics cannot work;
- run required validation;
- open PR only after validation passes.
