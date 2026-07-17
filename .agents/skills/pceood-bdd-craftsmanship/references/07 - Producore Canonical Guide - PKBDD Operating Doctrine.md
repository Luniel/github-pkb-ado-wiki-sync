
## Producore Canonical Guide - PKBDD Operating Doctrine

### Status
Canonical. Normative. Binding within the Producore Canonical Engineering Ontology and Operating Doctrine.

This document defines PKBDD (Product Knowledgebase-Driven Development) as an operating doctrine governing authority, lifecycle, and behavioral specification management within the PKB.

---

### 1. Core Assertion

PKBDD establishes that:

The Product Knowledge Base (PKB) is the sole authoritative system of record for specifications that express system behavior.

Behavior itself is defined by the Canonical Definition Guide — Behavior System.

PKBDD governs when a specification of Behavior becomes binding.

No system behavior is considered authoritative, enforceable, or governable unless it exists as a specification in the PKB in the `Current` lifecycle state.

---

### 2. Authority Model

#### 2.1 Single Source of Authority

The PKB is the only authoritative source for:

- specifications that express product behavior  
- behavioral contracts  
- capability-scoped specifications  

The PKB does not define Behavior itself.

Behavior is defined by the Behavior System and expressed through specifications governed in the PKB.

All other systems (code, tests, documentation, pipelines, diagrams, conversations) are non-authoritative projections or consumers of PKB content.

Work items, boards, sprint artifacts, and other execution-planning surfaces are also non-authoritative coordination artifacts.

They may reference authoritative specifications, preserve execution history, and coordinate realization work.

They must not become the hidden place where requirement meaning, authoritative section content, or missing behavioral detail actually lives.

Implementation must therefore be driven from persisted PKB specifications rather than from transient work-item text.

If work-item wording, commentary, or execution-planning shorthand diverges from the PKB specification, the PKB governs.

#### 2.2 Binding Condition

A specification is binding if and only if:

1. It expresses Behavior  
2. It is located under a Capability  
3. It is in the `Current` lifecycle state  

Binding applies to the specification as the governed expression of Behavior.

PKBDD does not define what Behavior is.

PKBDD does not create Behavior, alter the meaning of Behavior, or define different kinds of Behavior by lifecycle state.

It governs only whether a Specification that expresses Behavior is authoritative within the system.

It determines whether a given specification of Behavior is authoritative.

#### 2.3 Authority Dimensions

Authority is determined along two independent dimensions:

1. Lifecycle Authority (Binding)
   - Determined by lifecycle state  
   - Only `Current` specifications are binding  

2. Expression Fidelity (Completeness and Precision)
   - Determined by specification form  
   - BDD specifications represent the highest-fidelity expression  
   - Approximate artifacts are lower-fidelity expressions  

These dimensions are independent:

- A non-Current specification is not binding regardless of fidelity  
- A Current specification is binding regardless of fidelity  

#### 2.4 PKB Validity and PKB Maturity

PKB validity and PKB maturity are not the same thing.

A PKB may be valid while still immature.

A valid but immature PKB:

- represents authority honestly  
- does not fabricate mature specification where mature specification does not yet exist  
- preserves uncertainty in governed form where needed  
- preserves current-state capture, governed approximations, and unresolved meaning without falsely promoting them into target-state binding authority  

A valid PKB must also preserve or explicitly account for the minimum classes of product knowledge required for behavioral authority to remain meaningful rather than merely formal.

At minimum, a valid PKB must preserve in governed form:

- discovery-layer knowledge about the problem being solved, the solution intent, and the use cases, journeys, steps, actions, scenarios, or event boundaries that determine what must be supported  
- support-selection knowledge identifying what is selected, deferred, excluded, uncertain, approximate, or unresolved  
- capability-layer knowledge identifying the bounded capabilities that are relevant, required, or brought into scope  
- specification-layer knowledge expressing the behavior that is governed, currently captured, approximated, or still maturing toward authoritative target-state specification  
- preserved rationale and decision knowledge needed to maintain continuity between discovery, capability, specification, and later realization  

These are minimum content classes, not minimum maturity levels.

A valid but immature PKB may preserve these classes through governed approximations, current-state capture, explicit uncertainty, and unresolved-meaning preservation where appropriate.

A PKB that preserves authority labels while omitting these classes so thoroughly that continuity of meaning cannot be maintained is not valid merely because its lifecycle framing appears clean.

An invalid PKB is not merely incomplete.

A PKB is invalid when authority is misrepresented, when implementation or non-authoritative artifacts are treated as authority, or when unresolved meaning is hidden rather than preserved explicitly.

Completeness and maturity may increase over time.

Authority honesty is required from the beginning.

---

### 3. Structural Ontology Alignment

#### 3.1 Capability System Alignment

- Capabilities define structural domains of responsibility  
- Capabilities do not define behavior directly  
- Capabilities become authoritative only through their child specifications  

Invariant:

A capability without a `Current` specification has no binding behavior.

#### 3.2 Behavior System Alignment

- Behavior is defined exclusively by the Canonical Definition Guide — Behavior System  
- PKBDD does not define Behavior  

Specified Behavior exists only as it is expressed through Specifications.

Specifications:

- express Behavior in accordance with the Behavior System  
- are governed by PKBDD for authority and lifecycle  

PKBDD governs:

- whether a specification is binding  
- how specifications evolve over time  

PKBDD does not govern:

- what Behavior is  
- how Behavior is defined  
- how correctness is determined  

#### 3.3 Authority Hierarchy

PKBDD governs authority through the following structure:

```text
Capability (structure)
  └── Specification (expression of Behavior)
        └── Lifecycle State (authority)
```

Behavior itself is defined outside this hierarchy.

This hierarchy governs how Behavior, once expressed, becomes authoritative.

---

### 4. Specification Doctrine

#### 4.1 Specification Definition

A Specification is:

- the atomic unit of behavioral contract  
- the mechanism by which an expression of Behavior becomes authoritative  
- a lifecycle-governed artifact within the PKB  

Specifications MUST:

- reside under a capability  
- declare exactly one lifecycle state  
- be uniquely identifiable (stable ID or canonical path)  
- be auditable and versioned  

#### 4.2 Specification Forms

PKBDD does not constrain specification form beyond structural validity.

Permitted forms include:

- BDD scenarios (preferred where applicable)  
- Structured declarative behavior definitions  
- Other formally accepted specification formats  

All forms MUST comply with the Behavior System and, where applicable, the BDD Craftsmanship Standard.

Specification form determines fidelity of expression, not authority.

A lower-fidelity specification may be binding if it is in `Current`.

A higher-fidelity specification is not binding unless it is in `Current`.

#### 4.3 Specification Identity and Lineage

A specification must preserve stable identity throughout its lifecycle participation.

Identity must remain stable across:

- lifecycle transitions  
- evidence linkage  
- audit activity  
- supersession handling  

A specification's identity must not be replaced merely because its lifecycle state changes.

Behavioral change requires a new specification rather than mutation of an existing binding contract.

Lineage must therefore be preserved whenever one specification supersedes another.

The system must be able to determine:

- which specification superseded which prior specification  
- which prior specification was binding before supersession  
- which evidence supports the specification that became binding  

This discipline preserves contract continuity and prevents authority from becoming ambiguous during evolution.

#### 4.4 Current-State Capture as a Governed Transitional Surface

Current-state capture is not an additional lifecycle state.

It is an analysis and preservation surface that may be used during recovery, clarification, defect analysis, or first-pass maturation.

A current-state capture may preserve behavior that is presently implemented, but it does not become binding authority unless and until a governed Specification expressing that behavior progresses through PKBDD lifecycle to `Current`.

Current-state capture is a governed transitional surface.

It may be used when stable implementation-visible meaning must be preserved without falsely asserting that the preserved behavior is already mature target-state binding authority.

Current-state capture:

- does not confer target-state authority by itself  
- does not excuse later target-state clarification where such clarification is required  
- exists to prevent loss of stable observed or implemented meaning during PKB maturation  

Current-state capture must therefore remain distinct from authoritative target-state specification even when it preserves behavior that is currently visible in implementation.

---

### 5. Lifecycle Doctrine

#### 5.1 Lifecycle as Authority Model

The lifecycle governs the authority status of specifications.

It does not define Behavior or correctness.

Those are defined by the Behavior System.

A specification MUST exist in exactly one of the following states:

- Draft  
- Approved New  
- Committed  
- Past Attempted  
- Current  
- Deprecated  

#### 5.2 State Semantics

##### Draft
- Non-binding  
- Incomplete or exploratory  
- Not eligible for implementation  

##### Approved New
- Contract is valid and approved  
- Eligible for implementation  
- Only legal path to replace a `Current` contract  

##### Committed
- Implementation effort is in progress  
- Contract is being realized  
- Not yet binding  

##### Past Attempted
- Implementation attempt failed  
- Contract remains valid  
- System is known to be non-conforming  

##### Current
- Contract matches system behavior  
- Verified through evidence  
- Sole binding definition of behavior  

`Current` does not define what Behavior is.

`Current` identifies the Specification that is presently binding as the authoritative expression of that Behavior within the PKB.

##### Deprecated
- Contract retired  
- Preserved for lineage and audit  
- Not binding  

#### 5.3 Transition Law

Only the following transitions are permitted:

- Draft → Approved New  
- Approved New → Committed  
- Committed → Current  
- Committed → Past Attempted  
- Past Attempted → Committed  
- Any → Deprecated (with justification)  
- Current → Deprecated (via supersession)  

Illegal transitions MUST be treated as violations of the doctrine.

#### 5.4 Immutability of Current

A `Current` specification MUST NOT be modified in place.

To change behavior:

1. Create a new Draft specification  
2. Promote through lifecycle  
3. Supersede existing `Current`  
4. Mark previous `Current` as Deprecated  

This preserves auditable contract history.

#### 5.5 Supersession, Correction, and Rollback Handling

Supersession is the governed mechanism for replacing a binding specification.

A new specification becomes binding only by progressing through the lifecycle and then superseding the existing `Current`.

The prior `Current` must then be preserved as Deprecated with lineage intact.

A system must not correct a problematic `Current` by:

- editing the existing `Current` in place  
- silently reviving an older `Current` as though binding authority had never changed  
- treating implementation reversion by itself as contract rollback  

If a non-binding specification path proves infeasible, defective, or otherwise unsuitable before becoming `Current`, correction must still preserve auditability.

Such correction may require:

- deprecating the problematic non-binding specification with justification  
- creating a replacement Draft specification  
- progressing the replacement through the normal lifecycle  

Rollback in implementation does not by itself restore prior contract authority.

If implemented behavior does not conform to the binding `Current` specification, one of the following is true:

- the system is defective relative to the binding contract, or
- the binding specification in the PKB is stale and no longer truthfully represents the implemented current behavior

Such divergence must not be silently tolerated.

It must be resolved either by correcting implementation to conform to the binding `Current` contract, or by governing a replacement specification through lifecycle and superseding the stale `Current`.

If a prior contract is to become binding again, that must be handled through governed specification lifecycle, not through informal reactivation.

This preserves authoritative continuity even during correction.

---

### 6. Evidence Doctrine

#### 6.1 Evidence Requirement

A specification may only transition to `Current` if:

- verifiable evidence demonstrates system conformance  
- acceptance is recorded  

Evidence may include:

- automated test results  
- manual validation protocols  
- combined verification approaches  

Evidence does not define Behavior.

Evidence supports the determination that Implemented Behavior conforms to the binding Specification that expresses Behavior.

#### 6.2 Evidence Ownership

Evidence MUST:

- be linked to the specification  
- be traceable and reproducible  
- map deterministically to the specification’s identity  

---

### 7. Execution Decoupling

#### 7.1 Principle

Execution systems consume specifications but do not define them.

This includes:

- test frameworks  
- feature files  
- automation pipelines  
- runtime systems  

Execution systems operate against specifications.

They do not define Behavior and must not be used to infer it.

#### 7.2 Prohibition

Execution artifacts MUST NOT:

- redefine behavior  
- act as source of truth  
- diverge from PKB-defined specifications  

If divergence occurs, the PKB is authoritative and execution must be corrected.

---

### 8. Reuse and Specialization Doctrine

#### 8.1 Shared Capability Behavior

- Shared capability specifications may be reused across products  
- Shared specifications may be `Current` independently of product specializations  

#### 8.2 Specialization Constraints

A product-specific specialization:

- MAY narrow behavior  
- MAY contextualize behavior  
- MUST NOT contradict a shared `Current` specification  

#### 8.3 Variance Handling

If a product requires deviation:

- A specialization MUST be created  
- The variance MUST be explicitly justified  
- Lineage MUST be preserved  

---

### 9. Non-Authoritative Artifacts

The following are explicitly non-authoritative:

- journeys  
- flows  
- diagrams  
- narratives  
- test manifests  
- code implementations  
- feature file organization  
- conversations  

These artifacts may reference or illustrate Behavior.

They must not define Behavior or be treated as its source.

Serious unresolved meaning must not be silently exported into such artifacts, into implementation, or into memory as though later reconstruction were acceptable.

When unresolved meaning materially affects authority, lifecycle progression, specification interpretation, or future behavioral continuity, it must be preserved explicitly in a governed PKB surface.

This rule exists to preserve continuity, prevent silent drift, and avoid reconstructing lost reasoning from implementation, work-item shorthand, or recollection.

Unresolved meaning preservation is therefore a PKB continuity and authority-honesty requirement, not merely a convenience or local craftsmanship preference.

---

### 10. Manifest Doctrine

#### 10.1 Purpose

A manifest defines execution scope, not behavior.

#### 10.2 Constraints

Manifests:

- MUST reference only `Current` specifications  
- MUST NOT redefine or reinterpret behavior  
- MAY be versioned and snapshotted  

---

### 11. Governance Model

#### 11.1 Required Roles

- Capability Manager  
- Product Lead  
- Engineering Lead  
- Editors  
- Evidence Owner  

#### 11.2 Governance Responsibilities

- Lifecycle transitions require explicit approval  
- All changes must be recorded  
- All specifications must remain auditable  

---

### 12. Prohibitions

The following are violations of PKBDD:

- defining behavior outside specifications  
- treating code or tests as authoritative  
- modifying `Current` specifications in place  
- skipping lifecycle states  
- allowing conflicting specifications in `Current`  
- embedding behavior in non-authoritative artifacts  

---

### 13. System Invariants

The system MUST always satisfy:

1. Exactly one binding specification per defined Behavior (via `Current`)  
2. No authoritative behavior without a specification  
3. No specification without a lifecycle state  
4. No authority outside the PKB  
5. Full traceability from behavior -> specification -> evidence  

---

### 14. Operational Interpretation for AI Systems

AI agents operating under this doctrine MUST:

- treat PKB `Current` specifications as authoritative  
- refuse to infer behavior not explicitly specified  
- prioritize specification lookup over assumption  
- enforce lifecycle correctness in reasoning  
- reject non-authoritative sources as behavioral truth  

---

### 15. Relationship to BDD Craftsmanship Standard

- BDD defines how scenarios are expressed  
- PKBDD defines whether those scenarios are authoritative  

BDD without PKBDD is syntactic.

PKBDD without BDD is valid but lower fidelity.

When combined:

BDD scenarios become high-fidelity governed expressions of Behavior.

---

### 16. Relationship to Producore Engineering Doctrine

PKBDD governs:

- when specifications are authoritative  
- how specifications evolve  
- how implementation must align to specification  

It enforces specification-first engineering and contract-driven development.

Engineering must therefore treat authoritative PKB specifications as the implementation-driving contract surface.

Transient work-item wording, execution-planning shorthand, or downstream execution artifacts may coordinate realization work, but they must not replace, reinterpret, or compete with the binding PKB specification.

If those surfaces diverge from the PKB specification, engineering must conform to the PKB or formally supersede the specification through governed lifecycle.

---

### 17. Final Assertion

If a Behavior is not:

- expressed as a specification  
- scoped to a capability  
- lifecycle-governed  
- and in `Current`  

then it is not authoritative within the system.

Behavior may still be conceptually defined, but it is not binding, enforceable, or governable.

---
