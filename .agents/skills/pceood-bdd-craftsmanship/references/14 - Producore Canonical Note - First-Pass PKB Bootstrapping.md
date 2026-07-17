
## Producore Canonical Note — First-Pass PKB Bootstrapping

### Status

Canonical applied note.

This note defines an applied method for bootstrapping a first-pass Product Knowledge Base (PKB) for an existing solution or solution area.

It derives from:

- Producore Canonical Model Definition
- Producore Canonical Guide - PKBDD Operating Doctrine
- Producore Canonical Note - Defect Analysis Through Current-State Specification

It does not define new ontology, new authority rules, new lifecycle mechanics, new craftsmanship rules, or new engineering doctrine.

---

### 1. Purpose

This note defines how to establish a valid first-pass PKB when a solution does not yet have a mature PKB, but meaningful product knowledge already exists in history, implementation, conversations, work artifacts, design material, or other non-authoritative sources.

Its purpose is to prevent a recurring structural error:

- treating the absence of a mature PKB as permission either to fabricate maturity or to preserve too little real product knowledge for the PKB to function as the system's memory and continuity layer

This method applies in:

- first-pass PKB creation for an existing solution
- retrospective PKB reconstruction
- onboarding of historically grown systems
- recovery from fragmented or partially lost product knowledge
- transitional PKB establishment before fuller maturation work proceeds

---

### 2. Scope Boundary

This note does not define:

- what a Capability is
- what Behavior is
- what makes a specification binding
- new lifecycle states or transitions
- PKB page-type doctrine
- PKB section semantics as doctrine
- RMF operating law
- engineering realization practice

Those concerns remain governed by higher canonical sources.

This note defines only how the existing canonical distinctions are applied when a PKB must be established before mature product knowledge has been fully formalized into authoritative PKB form.

---

### 3. Core Distinction

A first-pass PKB is not the same thing as a mature PKB.

A first-pass PKB may be valid while still incomplete, provisional, or immature.

Its job is not to pretend maturity.

Its job is to establish a governed memory and continuity surface that preserves the minimum real product knowledge required for the doctrine to function honestly.

Therefore:

- first-pass validity must not be confused with maturity
- provisional capture must not be confused with authoritative target-state completion
- bootstrapping must preserve real knowledge without inventing false certainty
- the PKB must begin preserving the missing middle even before all behavior is fully matured into target-state authoritative specification

---

### 4. First-Pass Bootstrapping Objective

The objective of first-pass PKB bootstrapping is to establish a PKB that is valid under PKBDD while still openly acknowledging where knowledge remains immature.

That requires the PKB to do three things at once:

1. preserve product knowledge that would otherwise remain fragmented, tribal, or lost
2. represent authority honestly rather than silently promoting approximations into binding target-state specification
3. create a stable continuity surface from which later maturation can proceed

Bootstrapping therefore aims first at truthful preservation and governable continuity, not at the illusion of immediate completeness.

---

### 5. First-Pass Sources and Their Role

When a mature PKB does not already exist, the first-pass PKB must often be constructed from sources that are not themselves authoritative.

These may include:

- code and implementation evidence
- tests and automation artifacts
- work items and execution history
- conversations and review history
- design material
- architecture notes
- historical requirements artifacts
- user-facing or operational documentation

Such sources may provide evidence, memory, context, or provisional clarity.

They do not become authoritative simply by being imported, referenced, or summarized.

Their role in first-pass bootstrapping is:

- to surface what is already known
- to expose what appears stable
- to reveal where current-state capture is needed
- to expose where target-state clarification is still missing
- to preserve rationale and decision traces where available

---

### 6. Minimum First-Pass Preservation Requirement

A first-pass PKB must preserve, in governed form, enough product knowledge that the PKB can function as the system's continuity layer rather than as a hollow authority shell.

At minimum, first-pass bootstrapping must work to preserve or explicitly account for:

- the problem or solution context being addressed
- the use cases, journeys, steps, actions, scenarios, or event boundaries that reveal what must be supported
- support-selection understanding, including what is selected, deferred, excluded, uncertain, approximate, or unresolved
- the bounded capabilities that appear relevant, required, or already in scope
- current-state and target-state specification surfaces where those can be honestly distinguished
- preserved rationale, decision context, and meaningful lineage where available

The first-pass PKB need not capture all of these at full maturity on day one.

It must, however, preserve them honestly enough that later maturation does not require reconstructing the solution primarily from implementation, recollection, or transient coordination artifacts.

A first-pass PKB is therefore insufficient if it preserves governance framing, glossary surfaces, capability inventory, or isolated specification fragments while leaving the solution's meaningful continuity chain recoverable only from code, memory, or transient coordination history.

The requirement is not immediate completeness.

The requirement is that enough governed knowledge is preserved that later maturation proceeds from continuity rather than from reconstruction-by-guessing.

---

### 7. Transitional Surfaces in First-Pass Bootstrapping

First-pass bootstrapping requires governed transitional surfaces.

These may include:

- current-state capture
- governed approximations
- unresolved meaning
- provisional capability framing
- partial target-state specification
- preserved discovery knowledge awaiting fuller normalization

These surfaces are valid when they are used to preserve continuity honestly.

They are invalid when they are used to simulate maturity that does not yet exist.

A transitional surface must therefore remain explicit about which of the following it represents:

- current system reality
- target-state intent
- approximation
- open question
- deferred clarification

The purpose of these surfaces is continuity under truth, not reduction of visible uncertainty.

---

### 8. First-Pass Sequencing Guidance

First-pass bootstrapping does not always begin from the same entry point.

Work may begin from:

- a known problem and solution area
- a capability inventory
- historical use cases and flows
- current implementation behavior
- major work streams or product areas

Regardless of entry point, the bootstrapping sequence must work toward recovering and preserving the connected chain across discovery, capability, specification, and rationale.

In practice, this means:

- start from the strongest available grounded knowledge
- preserve it in governed form
- reconstruct surrounding context rather than freezing isolated fragments
- distinguish current-state clarity from target-state authority
- expand outward until the relevant continuity chain is visible enough for maturation to proceed responsibly

In practical first-pass work, the continuity chain commonly has to be recovered and preserved across surfaces such as:

- problem or solution context
- use cases, journeys, or other meaningful flow structures
- steps, actions, event boundaries, or scenario-bearing distinctions
- what was considered, selected, deferred, excluded, approximate, or still unresolved
- relevant capabilities
- current-state and target-state specification surfaces where those can be honestly distinguished
- preserved rationale, decision lineage, and implementation-facing continuity where needed

The sequence is therefore directional but not rigidly linear.

What matters is that the resulting PKB preserves connected meaning rather than disconnected artifact residue.

This guidance does not redefine the ontology of Discovery, Realization, Capability, or Behavior.

It defines an applied method for recovering and preserving continuity during first-pass PKB establishment.

---

### 9. Current-State and Target-State Handling

First-pass PKB bootstrapping will often require both current-state and target-state surfaces.

Current-state capture may be necessary when the system already behaves in stable ways that must be made explicit before correction, restructuring, or refinement can proceed.

Target-state specification may be necessary where intended behavior is already sufficiently knowable to govern realization.

These must not be collapsed.

Therefore:

- current-state specification may preserve what the system presently does
- target-state specification defines what the system should do
- approximations must not be silently promoted into target-state authority
- lack of target-state maturity does not excuse loss of current-state meaning where that meaning is material

The first-pass PKB must preserve both clarity and distinction.

---

### 10. First-Pass Capability and Specification Handling

A first-pass PKB must not force premature precision where capability boundaries or specification maturity are not yet fully stabilized.

At the same time, it must not avoid capability and specification work so thoroughly that the PKB never begins to anchor behavior properly.

Therefore:

- capability framing may begin provisionally, but it must move toward clear required possibility, capability identity, and responsibility boundary rather than remaining arbitrary grouping
- specification surfaces may begin in lower-fidelity or transitional form, but they must remain governed and honest about their maturity
- discovery material may reveal Capability need without defining Capability identity
- target-state binding authority still requires the normal PKBDD conditions

Bootstrapping therefore begins the anchoring process without pretending that anchoring is already complete.

---

### 11. Prohibitions

The following are invalid first-pass bootstrapping moves:

- treating code or tests as authoritative because no mature PKB existed previously
- copying transient work-item wording into the PKB as though that alone establishes sufficient preserved meaning
- fabricating target-state certainty where only approximation or current-state evidence exists
- omitting discovery-layer knowledge so completely that only capabilities and implementation-facing fragments remain
- omitting rationale so completely that later decisions must be reconstructed from memory or implementation
- using first-pass status as an excuse for structural dishonesty
- turning local topology, host-platform habits, or template preferences into foundational doctrine

Common first-pass bootstrapping failure modes also include:

- preserving governance structure while preserving too little actual solution or product knowledge
- treating current-state capture as though it were already mature target-state authority
- treating implementation-visible reality as though it were authoritative merely because it is stable
- allowing unresolved meaning, deferred clarification, or open questions to disappear instead of preserving them explicitly
- preserving isolated capability or specification fragments without enough surrounding discovery, rationale, or continuity context for later maturation to proceed responsibly
- allowing non-authoritative support artifacts, delivery artifacts, or execution artifacts to become the hidden place where missing PKB meaning survives informally

First-pass work may be incomplete.

It may not be dishonest about what it knows, what it does not know, and what it is preserving.

---

### 12. Outcome Standard

A successful first-pass PKB is not one that looks finished.

A successful first-pass PKB is one that:

- establishes a governed memory and continuity surface
- preserves the minimum real product knowledge needed for the doctrine to function
- distinguishes validity from maturity
- distinguishes current-state capture from target-state authority
- makes further maturation possible without requiring wholesale reconstruction from implementation or recollection

That is the standard this note is intended to support.

---

### 13. Benchmark First-Pass Assembly Profile

The purpose of first-pass PKB bootstrapping is not merely to create a minimally valid PKB.

The purpose is to create the strongest first-pass PKB that can be justified by the available source material without fabricating maturity, hiding unresolved meaning, or collapsing the continuity chain.

A benchmark first-pass PKB therefore requires more than:

- one or more capability pages
- one or more draft specifications
- a generic context page
- a visually clean page tree

A benchmark first-pass PKB must preserve and materially express the continuity chain strongly enough that later refinement, narrowing, and implementation-driving handoff can proceed without reconstructing missing meaning from memory, work items, or implementation.

#### 13.1 Benchmark First-Pass Construction Goal

A benchmark first-pass PKB should, where supported by the source material, visibly preserve:

- problem framing or solution framing
- solution intent
- use cases, journeys, flows, meaningful steps, actions, or event-boundary-relevant continuity
- support-selection knowledge, including what is selected, deferred, excluded, uncertain, approximate, provisional, or unresolved
- capability candidates, capability certainty or provisionality, and capability-local boundaries
- target-state behavioral contract surfaces only where those are sufficiently knowable
- current-state capture where stable implementation-visible meaning must be preserved honestly
- governed approximations where real directional understanding exists but mature target-state authority is not yet justified
- decision and rationale continuity
- traceability continuity where code, artifacts, or history materially inform the first-pass reconstruction

This does not redefine PKB validity.

It operationalizes stronger first-pass assembly within the existing validity and maturity distinction.

#### 13.2 Benchmark First-Pass Assembly Sequence

When bootstrapping a first-pass PKB from immature, messy, partial, or retrospective source material, proceed in the following sequence.

##### Step 1 - Source Inventory and Knowledge Classification

Identify and classify the available source material before producing PKB structure.

Classify source material by the kind of knowledge it contains, such as:

- problem framing
- solution intent
- use cases or flows
- meaningful steps or actions
- event-boundary-relevant discussion
- support-selection decisions
- open questions and unresolved meaning
- candidate capabilities
- target-state behavioral rules
- current-state behavior
- rationale and tradeoffs
- implementation-informed traceability
- technical decision inputs

Do not begin by generating a page tree before the source knowledge has been classified.

##### Step 2 - Continuity Preservation Before Normalization

Preserve the continuity chain before attempting to normalize the PKB into clean capability-and-specification form.

If the source material contains meaningful continuity that is not yet mature enough for stable capability-scoped specification, preserve that continuity explicitly as support surfaces, current-state capture, governed approximations, or unresolved-meaning surfaces.

Do not erase continuity merely because it is not yet clean.

##### Step 3 - Support-Selection Preservation

Identify and preserve what the source material says, implies, or reveals about:

- selected support
- deferred support
- excluded support
- unknown support
- approximate or provisional support
- unresolved support questions

If this support-selection knowledge materially affects later capability recognition, behavioral interpretation, or implementation-driving narrowing, it must be preserved explicitly.

##### Step 4 - Capability Candidate Extraction

Identify capability candidates from the continuity chain and the source material.

Do not derive capability identity from:

- use-case labels
- stage names
- workflow sequences
- outputs
- implementation modules
- UI surfaces
- teams
- architecture pieces

Use discovery and solution artifacts to reveal capability need.

Do not let those artifacts define capability identity.

Where certainty is uneven, preserve that honestly.

A first-pass PKB may include:

- clearly justified capability pages
- provisional capability framing
- capability-local notes clarifying why a capability candidate is still boundary-unstable

##### Step 5 - Artifact-Family Decision

For each major area of preserved meaning, decide which artifact family is justified.

Do not default automatically to a draft target-state behavioral specification.

A benchmark first-pass PKB uses the strongest justified artifact family, not the most flattering one.

##### Step 6 - Materialize the Benchmark First-Pass Package

Only after the prior steps are complete should the first-pass PKB be materially assembled.

The resulting package should preserve benchmark first-pass continuity and should remain visibly honest about maturity.

#### 13.3 Benchmark Root Package Pattern

A benchmark first-pass PKB should normally make visible, in some form appropriate to the solution, at least the following classes of first-pass surfaces:

- root orientation or entry surface
- solution intent or equivalent framing surface
- use cases, flows, or equivalent continuity surface
- support-selection surface
- capability inventory or equivalent capability-map surface
- open questions or unresolved-meaning surface
- decision and rationale continuity surface where such reasoning materially affects later refinement
- capability pages
- capability-local child artifacts as justified by the available maturity

This does not require one universal naming convention.

It does require that these knowledge classes not be silently omitted when they materially exist and matter.

#### 13.4 Capability-Local First-Pass Artifact Decision Rules

For each capability or capability candidate, determine whether the appropriate first-pass child artifact is:

- a draft target-state behavioral specification
- a current-state behavior capture surface
- a governed approximation surface
- a traceability note
- a capability-local open-questions or maturation surface
- a capability-local decision or rationale surface
- no child artifact yet, because the capability page itself is all that is currently justified

##### Use a Draft Target-State Behavioral Specification When

Use a draft target-state behavioral specification only when all of the following are true:

- the behavior belongs clearly to the capability
- the event boundary is sufficiently knowable
- the start-state and resulting-state logic can be expressed without local invention
- the unresolvedness that remains does not destroy the meaningfulness of the draft contract surface
- the draft will help rather than mislead later refinement and implementation-driving narrowing

##### Use Current-State Behavior Capture When

Use current-state behavior capture when:

- stable implementation-visible meaning must be preserved
- the source material is strongly current-state or reverse-engineered
- target-state authority would be premature
- preserving current implemented or observed meaning is necessary to prevent knowledge loss during maturation

##### Use a Governed Approximation When

Use a governed approximation when:

- a real directional rule or intended behavior is visible
- the source material justifies preserving it
- mature target-state behavioral precision is not yet justified
- the approximation is still valuable to preserve explicitly rather than leaving it implicit

##### Use Traceability Notes When

Use traceability notes when:

- code, historical artifacts, prior specs, or implementation evidence materially influence understanding
- the relationship between preserved meaning and its source must remain visible
- later refinement would be materially degraded if the reconstruction lineage were lost

##### Use Open Questions or Maturation Surfaces When

Use capability-local open questions or maturation surfaces when:

- unresolved meaning materially affects local interpretation
- a draft spec would otherwise absorb questions it cannot answer
- the unresolvedness belongs near the capability rather than only in a global ledger

#### 13.5 Explicit "Do Not Spec This Yet" Rule

Do not create a draft target-state behavioral specification merely because a topic exists or because a page tree looks cleaner when every capability has one.

Do not create a draft target-state behavioral specification when the available source material is still mostly:

- architecture direction
- issue inventory
- support-selection tension
- current-state observation
- policy conflict
- scoring ambiguity
- unresolved evaluative logic
- rationale without contract clarity
- provisional category grouping

In those cases, preserve the strongest justified non-contract surface instead.

This is not a weakness in the first-pass PKB.

It is part of authority honesty.

#### 13.6 Benchmark First-Pass Assembly Quality Test

A benchmark first-pass PKB passes this applied quality test only if:

- it preserves the continuity chain strongly enough that later refinement does not depend on memory reconstruction
- it preserves support-selection knowledge explicitly where that knowledge materially affects later interpretation
- it does not overproduce target-state draft specs in areas that are still mostly unresolved
- it uses transitional surfaces deliberately rather than apologetically
- it preserves capability candidates honestly, including boundary instability where present
- it gives later refinement a better starting point than a clean but hollow capability/spec shell would have provided

Failure to meet this benchmark test does not necessarily mean the PKB is invalid.

It does mean the first-pass bootstrapping method was underpowered relative to the available source material.
