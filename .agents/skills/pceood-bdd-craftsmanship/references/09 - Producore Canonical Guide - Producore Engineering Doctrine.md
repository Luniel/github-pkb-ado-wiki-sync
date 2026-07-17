
## Producore Canonical Guide - Producore Engineering Doctrine

### Status

Canonical. Normative. Binding within the Producore Canonical Engineering Ontology and Operating Doctrine.

This document defines the discipline of engineering work as it operates downstream of the canonical ontology and authority model.

---

### 1. Purpose

This doctrine defines how software is:

- designed
- implemented
- validated
- evolved

Its objective is to ensure:

- structural coherence
- behavioral correctness
- delivery stability

Engineering operates as the realization layer of the system. It does not define system meaning or authority.

---

### 2. Canonical Alignment

Engineering operates within the canonical chain defined by:

- Canonical Definition Guide - Capability System
- Canonical Definition Guide - Behavior System
- Canonical Guide - PKBDD Operating Doctrine

This doctrine does not redefine those systems.

It applies them.

The governing relationship is:

Capability -> Behavior -> Specification -> Implementation

This relationship is:

- directional
- non-reversible
- invariant

Engineering work must preserve this chain at all times.

No engineering activity may:

- redefine Capability
- redefine Behavior
- infer Behavior from Implementation
- treat Implementation or tests as authoritative

If a conflict arises, the canonical sources govern.

---

### 3. Specification (Contract)

#### Role

Specification is the artifact through which Behavior is expressed for implementation and validation.

Specifications:

- express Behavior
- serve as the contract surface for Implementation and validation

Specifications do not create Behavior.

They are the implementation-facing expression surface through which Behavior is made explicit for realization and validation.

#### Rules

Specifications:

- must be anchored to a Capability
- must provide sufficient clarity to be implemented and validated
- must not encode implementation logic
- must be analyzable, testable, and unambiguous

#### Authority

Binding authority is determined exclusively by lifecycle state under the PKBDD Operating Doctrine.

Specification form determines fidelity of expression, not authority.

BDD specifications represent the highest-fidelity expression of Specified Behavior, but do not determine whether the behavior is binding.

#### Constraint

Implementation must conform to Specification.

Specification must conform to Behavior.

This relationship must not be inverted.

---

### 4. Implementation

#### Role

Implementation realizes Behavior as defined by Specification.

Implementation is strictly downstream of Specification and has no authority over Behavior.

#### Rules

Implementation:

- must satisfy Specified Behavior under all defined scenarios
- must be evaluated against the Authoritative Contract Artifact
- must not redefine Behavior
- must not encode implicit assumptions
- must remain replaceable without changing Capability

#### Prohibitions

Implementation must not be used to:

- define Behavior
- infer missing Behavior
- justify deviation from Specification

If Implementation and Specification diverge, Specification governs unless formally superseded through PKBDD lifecycle.

---

### 5. Testing

#### Role

Tests validate alignment between Implemented Behavior and Specified Behavior.

Tests are a validation mechanism, not a source of definition.

Tests do not define Behavior, and they do not determine what a Specification means.

They provide evidence about whether Implemented Behavior conforms to the Specification.

#### Rules

Tests:

- must validate conformance to Specification
- must not define Behavior
- must not act as a source of truth
- must validate constraints and state transitions

Tests must fail when Implementation diverges from Specification, not when expectations differ from incidental system representation.

Preferred validation approaches:

- structural assertions
- invariant validation
- scenario-based verification

Avoid:

- brittle output equality unless output is explicitly part of Behavior

---

### 6. Structural Invariants

Implementation must enforce invariants as defined in Specification.

Invariants define constraints that must always hold true.

Examples:

- ordering must be preserved
- structural relationships must remain valid
- boundaries must not be violated

Invariants are part of Specified Behavior and must be enforced by Implementation and validated by Tests.

---

### 7. Refactoring

#### Definition

Refactoring is changing design without changing Behavior.

#### Rules

- Specified Behavior must remain constant
- changes must be small and reversible
- correctness must be preserved at all times
- if correctness is uncertain, abort and re-evaluate

Refactoring must not alter Specified Behavior.

If Behavior changes, it is not refactoring.

---

### 8. Design

All implementation work is design work.

Design defines how Behavior is realized while preserving structural integrity.

#### Principles

- design to contracts (Specification), not implementations
- encapsulate variation
- minimize coupling
- preserve clarity of intent

Design must not introduce Behavior not defined in Specification.

Poor design manifests as:

- inability to validate behavior
- coupling-induced ripple effects
- unclear or unstable system behavior

---

### 9. Engineering Boundary

Engineering operates strictly downstream of:

- Capability definition
- Behavior definition
- Specification authority

Engineering is responsible for:

- realizing behavior
- validating conformance
- maintaining implementation quality

Engineering is not responsible for:

- defining Capability
- defining Behavior
- determining binding authority

If any of these are unclear, engineering must stop and escalate to the appropriate canonical layer.

---

### 10. Delivery Discipline

Stable delivery requires:

- Behavior defined before implementation
- Specification established before implementation
- Capability boundaries maintained
- commitment aligned with verified understanding
- structural visibility of system behavior

Instability occurs when:

Commitment exceeds verified understanding.

---

### 11. Product Knowledgebase (PKB)

The PKB is the authoritative knowledge system as defined by the PKBDD Operating Doctrine.

It contains:

- Capability definitions
- Specifications expressing Behavior
- structural relationships
- decision history and rationale

#### Rules

- PKB is the source of truth
- all Specifications originate from and are governed within the PKB
- Implementation must trace back to PKB-defined Specifications

---

### 12. Anti-Patterns

The following indicate structural failure:

- inferring Behavior from code or output
- treating tests as authoritative definitions
- collapsing Behavior states
- allowing Implementation to define Capability or Behavior
- encoding behavior implicitly in code
- changing Behavior and design simultaneously
- treating lower-fidelity approximations as equivalent to governed Specifications
- treating a valid but immature first-pass PKB as though every page within it is equally implementation-driving

The last anti-pattern causes:

- local invention of missing behavior
- accidental promotion of unresolved meaning into code
- architecture-driven coding where contract narrowing was still required
- loss of continuity between preserved first-pass knowledge and the subset that was actually safe to build

---

### 13. Consumption Boundary for First-Pass and Mixed-Maturity PKBs

Engineering must distinguish between:

- preserved continuity surfaces
- transitional first-pass surfaces
- implementation-driving contract surfaces

A valid but immature first-pass PKB may contain all three.

Engineering must not treat the existence of a page in the PKB as proof that the page is implementation-driving in the same way.

#### 13.1 Downstream Consumption Rule

Engineering and AI-assisted coding systems must not treat the following as automatically implementation-driving merely because they are present in a valid PKB:

- open questions and maturation surfaces
- governed approximations
- current-state behavior capture
- decision and rationale pages
- traceability notes
- architecture-direction pages
- support-selection surfaces
- capability inventory or capability-candidate pages

Those surfaces may be essential to continuity.

They are not automatically build-ready contract surfaces.

#### 13.2 Required Response When the PKB Is First-Pass and Mixed-Maturity

When the PKB is valid but still immature, Engineering must ensure that realization work is driven from the correctly narrowed implementation-driving subset rather than from the full undifferentiated first-pass corpus.

If that narrowed subset does not yet exist and is materially needed, Engineering must not silently invent it in code, tests, or work-item wording.

The correct response is to require the missing narrowing or clarification through the governing upstream process.

#### 13.3 AI Coding Boundary

The same rule applies to coding AI.

A coding AI must not be given unresolved evaluative behavior, architecture ambition, current-state reconstruction, or support-selection residue as though those were settled implementation-driving contract surfaces.

If such material is necessary for context, it must remain context.

It must not be treated as hidden authority.

---

### 14. Invariant

If Capability is unclear or unstable, Behavior cannot be defined.

If Behavior is unclear or misaligned, Specification cannot be trusted.

If Specification is unclear or absent, Implementation will drift.

Engineering discipline cannot compensate for failure in upstream definition.

It also cannot safely compensate for failure to distinguish preserved first-pass continuity from implementation-driving contract surfaces.

---
