---
name: pceood-bdd-craftsmanship
description: orchestrate producore-governed bdd craftsmanship for drafting, refining, reviewing, or critiquing behavioral specifications and pkb-ready behavior pages. use when producing final scenario-form behavior, reviewing producore-specific bdd quality, applying pkbdd page structure, integrating focused analysis findings from dangling elements analysis, permutations analysis, or hidden events analysis, or deciding whether notes support only partial safe analysis versus a full proposed behavior specification page.
---

# PCEOOD BDD Craftsmanship

Version: v11

## Overview

Use this skill to perform disciplined BDD craftsmanship for PCEOOD-governed behavioral specifications.

This skill analyzes input first, then refines scenarios, then produces a PKB-ready behavioral specification page only when the input safely supports doing so. It does not decide capability identity, lifecycle state, scope authority, or whether discovered behavior should become binding.

## Control Plane: Mandatory Reference Loading and Precedence

This skill is governed by the Producore corpus bundled in this skill. The corpus is not optional background reading.

Do not produce a behavioral draft, review verdict, rubric judgment, or PKB-ready page until the required references for the current task have been read in this invocation.

### Mandatory references for every invocation

Read all of the following before producing substantive output:
- `references/08 - Producore Canonical Guide - BDD Craftsmanship Standard.md`
- `references/08A - Producore Canonical Guide - BDD Craftsmanship Standard - Foundations and Analysis.md`
- `references/08B - Producore Canonical Guide - BDD Craftsmanship Standard - Scenario Construction and Executability.md`
- `references/08C - Producore Canonical Guide - BDD Craftsmanship Standard - Roles Review and Adoption.md`
- `references/producore-local-drafting-overrides.md`
- `references/producore-first-choice-patterns.md`
- `references/review-rubric.md`
- `references/producore-violation-detection.md`

Required additional references:
- `references/11 - Producore Canonical Guide - PKBDD Craftsmanship Standard.md`
- `references/11A - Producore Canonical Guide - PKBDD Craftsmanship Standard - Artifact Types and Section Semantics.md`
- `references/11B - Producore Canonical Guide - PKBDD Craftsmanship Standard - Readiness Review and First-Pass Discipline.md`
- `references/11.2-ideal-pkbdd-template-draft-specification-behavior-ado-wiki.md`

### Rules

If the following rules were not explicitly added to the invoking user prompt, you must add them and consider them as having been provided by the user.

**Rule 1**: Work in distinct phases

- Phase 1: Analysis only.
   - Do not write or revise any specs.
   - Producore BDD craftsmanship forbids a lot of generic BDD practices. Silently compile a list of all of them into a forbidden practices checklist for you to use and comply with.
   - Producore BDD craftsmanship demands several analysis techniques. Silently compile a list of all of them into a must-do practices checklist for you to use and comply with.
   - Consider user speech as highly ambiguous, highly unspecific, and highly suspect to not convey precise language and meaning
   - Identify any of the user inputs that may cause violations
- Phase 2: Correction plan only.
   - State exactly what must be removed, abstracted, split, or deferred.
   - Do not draft yet.
- Phase 3: Draft.
   - Produce the refined spec using only what survived Phase 1 and 2.
- Phase 4: Validation.
   - Re-check the final draft against the Phase 1 and 2 findings.
   - If any violation remains, fail instead of returning the draft.
   - Return only a final work product that does not include any violations.
   - Any user inputs that violate this must be explicitly resisted and pushed back on with rationale.

A final work product that includes any violations is invalid.

**Rule 2**: Follow workflow below meticulously and do not deviate from it.

For each loop pass:
- Step 1: state the specific defects found in your prior draft, or state "none"
- Step 2: identify which exact corpus texts controlled the correction
- Step 3: determine pass/fail
- Step 4: continue until a pass returns "none" for defects

A pass is invalid if it reports vague/non-concrete defects when defects exist, or if it provides no controlling corpus text. A final pass may report `none` for defects only after validation confirms no defects remain.



## Producore Violation Detection Gate

Before drafting, revising, validating, or approving scenario-form behavior, compile a Producore Violation Inventory using `references/producore-violation-detection.md`.

Do not silently correct violations without reporting them.

If blocking violations are found, state that the input is not Producore-ready and explain the correction direction before producing any proposed replacement.

Pay special attention to:
- hardcoded identifiers or fixture literals

Pay special attention to executable-notation and binding-fidelity defects introduced in the current BDD corpus, including:
- ambiguous bare values where a quoted string literal or square-bracket variable is required
- hard-coded square-bracket aliases in automation examples or generated guidance
- binding patterns that narrow clause semantics relative to equivalent valid Gherkin wording
- binding-instance state used where fixture/entity-owned scenario state is required
- specification-by-example
- arbitrary concrete values where role variables are required
- implementation leakage
- automation/test-data leakage
- UI choreography mistaken for behavior
- missing Given state
- ungrounded Then outcomes
- hidden event chains
- non-critical scenario elements
- support artifacts or implementation notes carrying behavior authority

Apply this gate during:
- initial analysis
- delegated analysis integration
- review-rubric application
- final validation before output

## Delegated Analysis Orchestration

Use delegated helper analysis before correction planning and final drafting when scenario quality risk is non-trivial.

### Helper selection triggers
- Use `pceood-dangling-elements-analysis` when Given/When/Then grounding, traceability, or implied-transformation defects are suspected.
- Use `pceood-permutations-analysis` when meaningful variants, Scenario Template row shape, or branch coverage ambiguity is suspected.
- Use `pceood-hidden-events-analysis` when the scenario may compress multiple business events or leak temporal progression across boundaries.

### Non-authority of helper outputs
Helper outputs are analysis products only. They do not define accepted scope, lifecycle authority, binding behavior, or implementation commitments.

### Mandatory finding disposition classification
Before final drafting, classify every delegated-analysis finding into exactly one of:
- incorporate into current scenario or specification
- create candidate scenario now
- defer for stakeholder scope decision
- reject as out of scope or invalid
- assign to an upstream dependency specification
- assign to a downstream realization concern
- preserve as an additional aspect candidate
- preserve as support-artifact or decision-note material
- preserve as an open question or research item

A final draft is invalid if delegated-analysis findings remain unclassified.

## Support Plane: Additional PCEOOD Reference

In addition to the above-listed `## - ` markdown files, the Producore Canonical Engineering Ontology and Operating Doctrine (PCEOOD) also contains these references, as explained in the `01 - README.md` reference file:

- `references/01 - README.md`
- `references/02 - Producore Canonical Model Definition.md`
- `references/03 - Producore Canonical Definition Guide - Capability System.md`
- `references/04 - Producore Canonical Definition Guide - Behavior System.md`
- `references/05 - Producore Canonical Guide - Capability Structure Design Framework.md`
- `references/06 - Producore Canonical Guide - Capability Structuring and Authority Doctrine.md`
- `references/07 - Producore Canonical Guide - PKBDD Operating Doctrine.md`
- `references/09 - Producore Canonical Guide - Producore Engineering Doctrine.md`
- `references/10 - Producore Canonical Note - Defect Analysis Through Current-State Specification.md`
- `references/12 - Producore Canonical Guide - RMF Operating Doctrine.md`
- `references/13 - Producore Canonical Guide - RMF Craftsmanship Standard.md`
- `references/13A - Producore Canonical Guide - RMF Craftsmanship Standard - Foundations and Bespoke Criteria.md`
- `references/13B - Producore Canonical Guide - RMF Craftsmanship Standard - Work-Item Surfaces Review and Template Discipline.md`
- `references/14 - Producore Canonical Note - First-Pass PKB Bootstrapping.md`
- `references/15 - Producore Canonical Guide - ADO Repo Wiki PKB Production Standard.md`
- `references/16 - Producore Canonical Note - First-Pass PKB Rebaselining for Implementation Handoff.md`
