# The Producore Canonical Engineering Ontology and Operating Doctrine

This repository defines a formal, internally consistent system for the meaning, structure, authority, and realization of software engineering work.

It is organized as a layered doctrine.

The files in this repository do not all have the same kind of authority.

Some files define ontology.
Some define binding authority.
Some derive structural rules.
Some define operating doctrine.
Some define delegated downstream practice.
Some are applied notes.

This README exists to make that structure explicit.

It is an entrypoint and assembly guide.

It is not itself an authority source for ontology, behavior, lifecycle, craftsmanship, engineering rules, RMF operating rules, or RMF craftsmanship rules.

---

## 1. Purpose of This Repository

This repository exists to preserve a governed doctrine for:

- how software system meaning is defined
- how behavior is structurally anchored
- how specifications become authoritative
- how readiness and completion flow are governed around implementation work
- how engineering work proceeds downstream of that authority
- how applied methods remain derived rather than foundational

The doctrine is designed so that:

- meaning remains stable
- authority remains explicit
- structural drift is prevented
- downstream practice does not silently redefine upstream concepts
- AI systems can operate inside the doctrine without collapsing its layers

---

## 2. How to Read This Repository

This repository must be read in authority order, not convenience order.

Read the files in the following sequence.

### Layer 0 — Canonical Core

1. `02 - Producore Canonical Model Definition.md`
2. `03 - Producore Canonical Definition Guide - Capability System.md`
3. `04 - Producore Canonical Definition Guide - Behavior System.md`
4. `07 - Producore Canonical Guide - PKBDD Operating Doctrine.md`

These files define the core system.

They establish:

- top-level ontology
- Capability
- Behavior
- Specified Behavior
- authority and lifecycle of binding specification within PKBDD

Nothing downstream may redefine them.

---

### Layer 1 — Canonical Structural Derivation

5. `06 - Producore Canonical Guide - Capability Structuring and Authority Doctrine.md`
6. `05 - Producore Canonical Guide - Capability Structure Design Framework.md`

These files derive structural placement and assignment rules from the core.

They define:

- behavioral ownership by capability
- structural exclusivity
- placement
- promotion
- elevation
- drift detection in structure

They do not define ontology or binding authority.

---

### Layer 2 — Canonical Operating Doctrine Extensions

7. `12 - Producore Canonical Guide - RMF Operating Doctrine.md`

This file defines a distinct operating-doctrine layer for Requirements Maturation Flow.

It defines:

- readiness as a pre-implementation operating concern
- visible preparatory maturity work
- implementation gating
- completion gating
- the disciplined relationship between RMF 1, RMF 2, and RMF 3
- the operational relationship between readiness flow and authoritative specification surfaces governed elsewhere

It does not define Capability, Behavior, PKBDD binding authority, PKB-local craftsmanship, BDD craftsmanship, RMF craftsmanship, or engineering realization.

---

### Layer 3 — Delegated Expression, Craftsmanship, and Practice Standards

8. `08 - Producore Canonical Guide - BDD Craftsmanship Standard.md`
9. `09 - Producore Canonical Guide - Producore Engineering Doctrine.md`
10. `11 - Producore Canonical Guide - PKBDD Craftsmanship Standard.md`
11. `13 - Producore Canonical Guide - RMF Craftsmanship Standard.md`
12. `15 - Producore Canonical Guide - ADO Repo Wiki PKB Production Standard.md`

These files govern delegated expression, local craftsmanship, downstream realization, and host-platform production practice.

They define:

- how Specified Behavior is expressed in BDD form
- how engineering work proceeds downstream of the canonical chain
- how PKB artifacts are authored locally and safely within PKBDD without redefining authority, lifecycle, or structure
- how RMF support artifacts are authored locally and safely without redefining RMF operating law, PKBDD authority, or engineering realization
- how doctrine-safe PKB artifacts are materially produced as Azure DevOps Repo Wiki structures without redefining PKB ontology, authority, lifecycle, or structural ownership

They do not define Capability, Behavior, or authority.

---

### Layer 4 — Applied Canonical Notes

13. `10 - Producore Canonical Note - Defect Analysis Through Current-State Specification.md`
14. `14 - Producore Canonical Note - First-Pass PKB Bootstrapping.md`
15. `16 - Producore Canonical Note - First-Pass PKB Rebaselining for Implementation Handoff.md`

These files apply the canonical system to specific applied problems.

They define method, not ontology.

---

### Layer 5 — Entry / Packaging

16. `01 - README.md`

This file explains the whole structure.

It defines no doctrine of its own.

---

## 3. Repository Authority Stack

The repository is organized as a strict authority stack.

### 3.1 Model

`02 - Producore Canonical Model Definition.md`

Owns:

- the top-level ontology of the whole system
- the distinction and relationship between Solution Discovery and Solution Realization
- the role of the PKB as memory and continuity layer
- the system-level relationship between selection, realization, and preserved rationale

Must not define:

- detailed Capability rules
- detailed Behavior rules
- lifecycle mechanics
- craftsmanship rules
- engineering delivery rules
- RMF operating doctrine
- RMF craftsmanship rules

---

### 3.2 Capability

`03 - Producore Canonical Definition Guide - Capability System.md`

Owns:

- what a Capability is
- what a Capability is not
- capability identity
- capability continuity
- capability independence from implementation
- the rule that Capability anchors Behavior

Must not define:

- lifecycle authority
- placement heuristics
- BDD craftsmanship
- PKBDD craftsmanship
- RMF operating doctrine
- RMF craftsmanship
- engineering workflow

---

### 3.3 Behavior

`04 - Producore Canonical Definition Guide - Behavior System.md`

Owns:

- what Behavior is
- the forms of Behavior
- Specified Behavior
- alignment and correctness
- the role of Contract Artifacts as expression surfaces
- separation of definition, expression, and authority

Must not define:

- lifecycle mechanics
- placement rules
- craftsmanship details
- RMF operating doctrine
- RMF craftsmanship
- engineering workflow

---

### 3.4 PKBDD

`07 - Producore Canonical Guide - PKBDD Operating Doctrine.md`

Owns:

- binding authority
- lifecycle states
- legal lifecycle transitions
- evidence requirements
- specification authority within the PKB
- non-authoritative artifact rules

Must not define:

- Capability ontology
- Behavior ontology
- craftsmanship rules
- RMF operating doctrine
- RMF craftsmanship
- structural placement rules except where needed as preconditions of authority

---

### 3.5 Structural Derivations

`06 - Producore Canonical Guide - Capability Structuring and Authority Doctrine.md`  
`05 - Producore Canonical Guide - Capability Structure Design Framework.md`

Own:

- structural assignment of behavior to capability
- exclusivity of ownership
- interaction constraints
- specialization constraints
- placement and promotion logic
- reuse-driven structural evolution

Must not define:

- Capability ontology
- Behavior ontology
- lifecycle authority
- RMF operating doctrine
- RMF craftsmanship
- craftsmanship
- engineering process

---

### 3.6 RMF Operating Doctrine

`12 - Producore Canonical Guide - RMF Operating Doctrine.md`

Owns:

- readiness as a pre-implementation operating concern
- preparatory maturity work as visible, schedulable, governable work
- implementation gating
- completion gating
- the operating relationship between Shared Understanding, Definition of Ready, and Definition of Done
- the disciplined relationship between RMF 1, RMF 2, and RMF 3
- the operational interlock between RMF and authoritative specification surfaces governed elsewhere

Must not define:

- Capability ontology
- Behavior ontology
- PKBDD specification authority
- PKB artifact craftsmanship
- BDD craftsmanship
- RMF craftsmanship
- engineering realization rules
- host-platform template mechanics

---

### 3.7 RMF Craftsmanship

`13 - Producore Canonical Guide - RMF Craftsmanship Standard.md`

Owns:

- RMF support-artifact authoring discipline
- local craftsmanship for bespoke Definition of Ready criteria
- local craftsmanship for bespoke Definition of Done criteria
- local craftsmanship for readiness-oriented work-item surfaces
- local review discipline for RMF support artifacts
- RMF-local anti-patterns
- doctrine-safe use of RMF starter templates

Must not define:

- Capability ontology
- Behavior ontology
- PKBDD specification authority
- PKBDD lifecycle authority
- RMF operating law
- PKB artifact craftsmanship
- BDD craftsmanship
- engineering realization rules
- host-platform template mechanics

---

### 3.8 Other Delegated Standards

`08 - Producore Canonical Guide - BDD Craftsmanship Standard.md`  
`09 - Producore Canonical Guide - Producore Engineering Doctrine.md`  
`11 - Producore Canonical Guide - PKBDD Craftsmanship Standard.md`  
`15 - Producore Canonical Guide - ADO Repo Wiki PKB Production Standard.md`

Own:

- local scenario-form craftsmanship
- downstream engineering realization discipline
- PKBDD-local artifact authoring discipline and PKB-local specification craftsmanship
- Azure DevOps Repo Wiki PKB materialization, topology, ordering, naming, navigation, and host-platform production review criteria

Must not define:

- Capability
- Behavior
- correctness
- binding authority
- lifecycle
- RMF operating doctrine
- RMF craftsmanship
- PKB ontology

---

### 3.9 Applied Notes

`10 - Producore Canonical Note - Defect Analysis Through Current-State Specification.md`  
`14 - Producore Canonical Note - First-Pass PKB Bootstrapping.md`  
`16 - Producore Canonical Note - First-Pass PKB Rebaselining for Implementation Handoff.md`

Own:

- derived applied methods that use the canonical system without redefining it
- defect-analysis method for distinguishing current-state and target-state specification
- first-pass PKB bootstrapping method for establishing a valid PKB without fabricating maturity
- rebaselining method for narrowing a valid but immature first-pass PKB into a safe implementation-driving subset without collapsing continuity into hidden authority

Must not define:

- new ontology
- new authority
- new lifecycle
- new craftsmanship rules
- new RMF doctrine
- new ADO host-platform doctrine
- new engineering doctrine

---

## 4. What Each File Owns

This section is for quick navigation.

### `02 - Producore Canonical Model Definition.md`

Owns:

- the whole-system model
- discovery vs realization
- PKB as continuity layer
- top-level relationship between decisions, rationale, and realization

---

### `03 - Producore Canonical Definition Guide - Capability System.md`

Owns:

- Capability definition
- Capability validity
- Capability continuity
- Capability-to-Behavior directional relationship

---

### `04 - Producore Canonical Definition Guide - Behavior System.md`

Owns:

- Behavior definition
- Expected / Specified / Implemented / Observed distinctions
- correctness as alignment
- Contract Artifact as expression surface
- separation of expression from authority

---

### `07 - Producore Canonical Guide - PKBDD Operating Doctrine.md`

Owns:

- when a specification becomes binding
- lifecycle states and transitions
- evidence requirements
- authority of PKB over non-authoritative artifacts

---

### `06 - Producore Canonical Guide - Capability Structuring and Authority Doctrine.md`

Owns:

- behavioral ownership by capability
- exclusivity rules
- interaction rules
- specialization constraints
- structural drift detection and correction

---

### `05 - Producore Canonical Guide - Capability Structure Design Framework.md`

Owns:

- local/shared/business placement
- promotion/elevation logic
- placement heuristics
- reuse-driven structural evolution

---

### `12 - Producore Canonical Guide - RMF Operating Doctrine.md`

Owns:

- readiness before implementation
- visible preparatory maturity work
- timeboxed and schedulable readiness work where needed
- formal readiness gates where needed
- formal completion gates where needed
- the disciplined relationship between RMF 1, RMF 2, and RMF 3
- RMF's operating boundary relative to PKBDD, craftsmanship, and engineering realization

---

### `13 - Producore Canonical Guide - RMF Craftsmanship Standard.md`

Owns:

- RMF support-artifact authoring discipline
- local craftsmanship for bespoke Definition of Ready criteria
- local craftsmanship for bespoke Definition of Done criteria
- local craftsmanship for readiness-oriented work-item surfaces
- local review discipline for RMF support artifacts
- RMF-local anti-patterns
- doctrine-safe use of RMF starter templates

---

### `08 - Producore Canonical Guide - BDD Craftsmanship Standard.md`

Owns:

- scenario construction rules
- template rules
- substitution-table rules
- readability and quality rules for scenario-form specification
- craftsmanship-level automation consumption rules

---

### `09 - Producore Canonical Guide - Producore Engineering Doctrine.md`

Owns:

- implementation discipline
- testing discipline
- design discipline
- refactoring discipline
- delivery discipline
- engineering’s downstream boundary

---

### `11 - Producore Canonical Guide - PKBDD Craftsmanship Standard.md`

Owns:

- PKB artifact authoring discipline
- PKB page-type boundaries
- PKB template usage discipline
- section-level semantics for PKB specification pages
- PKB-local review and readiness discipline
- PKBDD anti-patterns
- first-choice PKB authoring and structural conventions

---

### `10 - Producore Canonical Note - Defect Analysis Through Current-State Specification.md`

Owns:

- current-state vs target-state analysis method

---

### `14 - Producore Canonical Note - First-Pass PKB Bootstrapping.md`

Owns:

- first-pass PKB bootstrapping method
- applied guidance for establishing a valid but still immature PKB
- applied guidance for preserving continuity honestly during retrospective or first-pass PKB creation

---

### `16 - Producore Canonical Note - First-Pass PKB Rebaselining for Implementation Handoff.md`

Owns:

- rebaselining method for narrowing a valid but still immature first-pass PKB into a safe implementation-driving subset
- applied guidance for distinguishing implementation-driving contract surfaces from preserved continuity, current-state capture, governed approximations, unresolved blockers, deferred support, and contextual support surfaces
- applied guidance for safe implementation handoff to Engineering and AI-assisted coding systems without promoting unresolved meaning into hidden authority

---

### `15 - Producore Canonical Guide - ADO Repo Wiki PKB Production Standard.md`

Owns:

- Azure DevOps Repo Wiki PKB materialization rules
- repo-native PKB topology rules for Azure DevOps Repo Wiki form
- `.order` usage, naming, navigation, and adjacency rules for ADO Repo Wiki PKBs
- host-platform artifact materialization patterns for doctrine-safe PKB surfaces in ADO Repo Wiki form
- Azure DevOps Repo Wiki PKB production anti-patterns and review criteria

---

### `01 - README.md`

Owns:

- reading order
- repository navigation
- packaging explanation
- dependency visibility
- authority stack summary

---

## 5. What Each File Must Not Define

This is the repository’s anti-drift map.

### Only these files may define ontology

- `02 - Producore Canonical Model Definition.md`
- `03 - Producore Canonical Definition Guide - Capability System.md`
- `04 - Producore Canonical Definition Guide - Behavior System.md`

---

### Only this file may define binding authority and lifecycle

- `07 - Producore Canonical Guide - PKBDD Operating Doctrine.md`

---

### Only these files may define structural derivation rules

- `06 - Producore Canonical Guide - Capability Structuring and Authority Doctrine.md`
- `05 - Producore Canonical Guide - Capability Structure Design Framework.md`

---

### Only this file may define RMF operating doctrine

- `12 - Producore Canonical Guide - RMF Operating Doctrine.md`

---

### Only this file may define RMF craftsmanship rules

- `13 - Producore Canonical Guide - RMF Craftsmanship Standard.md`

---

### Only this file may define BDD craftsmanship rules

- `08 - Producore Canonical Guide - BDD Craftsmanship Standard.md`

---

### Only this file may define PKBDD craftsmanship rules

- `11 - Producore Canonical Guide - PKBDD Craftsmanship Standard.md`

---

### Only this file may define ADO Repo Wiki PKB production rules

- `15 - Producore Canonical Guide - ADO Repo Wiki PKB Production Standard.md`

---

### Only this file may define downstream engineering practice

- `09 - Producore Canonical Guide - Producore Engineering Doctrine.md`

---

### Applied notes must not become foundational

- `10 - Producore Canonical Note - Defect Analysis Through Current-State Specification.md`
- `14 - Producore Canonical Note - First-Pass PKB Bootstrapping.md`
- `16 - Producore Canonical Note - First-Pass PKB Rebaselining for Implementation Handoff.md`

---

### This README must not define doctrine

This file must not define:

- ontology
- Capability
- Behavior
- correctness
- lifecycle
- binding authority
- RMF operating rules
- RMF craftsmanship rules
- craftsmanship rules
- host-platform production rules
- engineering practice rules

It may only summarize and point.

---

Each file must define only what it explicitly owns.

Anything not listed as owned is prohibited, even if not explicitly listed under “must not define.”

---

## 6. Dependency Map

The repository dependency structure is:

### Canonical core

- `02 - Producore Canonical Model Definition.md`
- `03 - Producore Canonical Definition Guide - Capability System.md`
- `04 - Producore Canonical Definition Guide - Behavior System.md`
- `07 - Producore Canonical Guide - PKBDD Operating Doctrine.md`

---

### Structural derivation

- `06 - Producore Canonical Guide - Capability Structuring and Authority Doctrine.md`
  - depends on Model + Capability System + Behavior System + PKBDD

- `05 - Producore Canonical Guide - Capability Structure Design Framework.md`
  - depends on Capability System + Capability Structuring and Authority Doctrine

---

### Operating doctrine extension

- `12 - Producore Canonical Guide - RMF Operating Doctrine.md`
  - depends on Capability System + Behavior System + PKBDD + BDD Craftsmanship Standard + PKBDD Craftsmanship Standard + Producore Engineering Doctrine

---

### Delegated expression and practice

- `08 - Producore Canonical Guide - BDD Craftsmanship Standard.md`
  - depends on Behavior System + Capability System + PKBDD

- `09 - Producore Canonical Guide - Producore Engineering Doctrine.md`
  - depends on Model + Capability System + Behavior System + PKBDD

- `11 - Producore Canonical Guide - PKBDD Craftsmanship Standard.md`
  - depends on Capability System + Behavior System + PKBDD + Capability Structuring and Authority Doctrine + Capability Structure Design Framework + BDD Craftsmanship Standard + Producore Engineering Doctrine

- `13 - Producore Canonical Guide - RMF Craftsmanship Standard.md`
  - depends on Capability System + Behavior System + PKBDD + BDD Craftsmanship Standard + PKBDD Craftsmanship Standard + RMF Operating Doctrine + Producore Engineering Doctrine

- `15 - Producore Canonical Guide - ADO Repo Wiki PKB Production Standard.md`
  - depends on Capability System + Behavior System + PKBDD + Capability Structuring and Authority Doctrine + Capability Structure Design Framework + PKBDD Craftsmanship Standard + RMF Operating Doctrine + RMF Craftsmanship Standard + Producore Engineering Doctrine

---

### Applied notes

- `10 - Producore Canonical Note - Defect Analysis Through Current-State Specification.md`
  - depends on Behavior System + PKBDD + Engineering Doctrine

- `14 - Producore Canonical Note - First-Pass PKB Bootstrapping.md`
  - depends on Model + PKBDD + Defect Analysis Through Current-State Specification

- `16 - Producore Canonical Note - First-Pass PKB Rebaselining for Implementation Handoff.md`
  - depends on Model + PKBDD + First-Pass PKB Bootstrapping + Producore Engineering Doctrine + ADO Repo Wiki PKB Production Standard

---

### Entry layer

- `01 - README.md`
  - depends on all
  - defines none

---

A file may depend on upstream sources only for interpretation, not reinterpretation or extension of their definitions.

---

## 7. Clean Assembly View

When assembled into one continuous text, this repository should still preserve layer distinction.

Assembly does not make all text co-equal.

The intended authority order remains:

1. Model
2. Capability
3. Behavior
4. PKBDD
5. Structural derivations
6. RMF operating doctrine
7. Delegated standards, including RMF craftsmanship
8. Applied notes
9. README / packaging

Any AI or human reader consuming an assembled export must preserve that ordering mentally.

Continuous text must not be mistaken for flattened authority.

Downstream sections must never be used to interpret or override upstream definitions, even when encountered later in continuous text.

---

## 8. Editorial Rule for Ongoing Maintenance

Changes to this repository must preserve the authority stack.

A valid change:

- localizes new rules to the narrowest valid boundary
- does not duplicate authority already owned elsewhere
- does not allow downstream documents to redefine upstream concepts
- does not let applied notes silently become foundational
- does not let practice language become ontology
- does not let packaging-layer wording silently redistribute doctrinal ownership

When a rule is ambiguous, fix it at the file that actually owns it.

Do not patch a downstream document to compensate for an upstream defect.

Any invariant or statement in this README is a restatement of upstream authority.

If conflict or ambiguity exists, upstream canonical sources govern.

Clarifications must be made only at the layer that owns the concept. Downstream clarification of upstream concepts is prohibited.

---

## 9. Repository Invariant

This repository remains structurally valid only if:

- ontology is defined only in the canonical core
- authority is defined only in PKBDD
- structural derivations remain derived
- RMF operating doctrine remains a distinct operating-doctrine layer
- craftsmanship remains delegated
- RMF craftsmanship remains distinct from RMF operating doctrine
- ADO Repo Wiki PKB production remains distinct from PKBDD artifact semantics and lifecycle authority
- engineering remains downstream
- applied notes remain applied
- README remains an entrypoint only

If any boundary is violated, the repository is structurally invalid and must be corrected before further work proceeds.

The most critical boundaries in the repository are these:

- Behavior is defined in the Behavior System
- Behavior is expressed through Specification
- binding authority is conferred only by PKBDD lifecycle
- readiness and completion flow around implementation are governed by RMF operating doctrine
- RMF support-artifact craftsmanship is governed separately from RMF operating law

These concerns must never be collapsed.

---

## 10. Quick Start

If you need to orient quickly:

- read `02 - Producore Canonical Model Definition.md` first
- then read Capability, Behavior, and PKBDD in that order
- then read the structural derivation files
- then read the RMF Operating Doctrine
- then read RMF Craftsmanship
- then read BDD Craftsmanship, Engineering Doctrine, and PKBDD Craftsmanship
- then read the ADO Repo Wiki PKB Production Standard when working on Azure DevOps Repo Wiki PKB materialization or topology
- then read applied notes only after the core and operating doctrine layers are understood
- for bootstrapping a first-pass PKB, read `14 - Producore Canonical Note - First-Pass PKB Bootstrapping.md` after `02` and `07`
- for narrowing a valid but immature first-pass PKB into a safe implementation-driving handoff, read `16 - Producore Canonical Note - First-Pass PKB Rebaselining for Implementation Handoff.md` after `14`, `09`, and `15`

If you need to decide where a new rule belongs:

- ontology question -> Model / Capability / Behavior
- authority or lifecycle question -> PKBDD
- capability ownership or overlap question -> Structuring Doctrine
- placement / promotion question -> Structure Design Framework
- readiness / implementation gating / completion gating question -> RMF Operating Doctrine
- RMF support-artifact craftsmanship question -> RMF Craftsmanship
- scenario-writing question -> BDD Craftsmanship
- PKB page-authoring question -> PKBDD Craftsmanship
- Azure DevOps Repo Wiki PKB materialization / topology / ordering / navigation question -> ADO Repo Wiki PKB Production Standard
- implementation / testing / design question -> Engineering Doctrine
- defect-analysis method question -> Canonical Note
- first-pass PKB bootstrapping method question -> Canonical Note
- first-pass PKB rebaselining / implementation handoff narrowing question -> Canonical Note

---

## 11. Final Statement

This repository is not a loose collection of related guidance.

It is a layered doctrinal system.

Its integrity depends on preserving the difference between:

- definition
- expression
- authority
- structure
- RMF operating flow
- practice
- application

That separation is what allows the doctrine to remain internally consistent, governable, and executable by both humans and AI.

---
