
## Producore Canonical Guide - RMF Operating Doctrine

### Status

Draft for adoption as the canonical operating doctrine for Requirements Maturation Flow (RMF) within the Producore Canonical Engineering Ontology and Operating Doctrine.

This guide governs RMF operating doctrine only.

It does not define:

- Capability
- Behavior
- correctness
- PKBDD specification authority
- PKB artifact craftsmanship
- BDD craftsmanship
- engineering realization rules
- host-platform template mechanics

Those remain governed by:

1. Producore Canonical Definition Guide - Capability System
2. Producore Canonical Definition Guide - Behavior System
3. Producore Canonical Guide - PKBDD Operating Doctrine
4. Producore Canonical Guide - BDD Craftsmanship Standard
5. Producore Canonical Guide - PKBDD Craftsmanship Standard
6. Producore Canonical Guide - Producore Engineering Doctrine

---

### 1. Purpose and Scope

This guide defines Requirements Maturation Flow (RMF) as the operating doctrine for the maturation of work items before implementation begins, the explicit gating of implementation work into execution, and the explicit gating of implementation work out of execution by objective completion criteria.

RMF exists because persisted authoritative specifications alone are not sufficient to ensure stable delivery flow. A team may have a valid place to store requirements, valid behavioral specifications, and valid engineering practices, while still beginning implementation before an item is mature enough to begin and still closing implementation without a clear, objective basis for completion. RMF governs that missing operational layer.

RMF governs:

- readiness as a pre-implementation operating concern
- maturation work as real work that must be made visible
- implementation gating
- completion gating
- the operational relationship between Shared Understanding, Definition of Ready, and Definition of Done
- the relationship between readiness flow and the authoritative specification surfaces governed elsewhere

RMF does not govern:

- what a Capability is
- what Behavior is
- what makes a PKB specification binding
- PKB page types or PKB section semantics
- scenario-form craftsmanship
- engineering implementation technique
- board-tool template mechanics or field-format constraints

RMF is therefore not a replacement for PKBDD, BDD, or engineering doctrine.

It is the operating doctrine that governs:

- when implementation work is mature enough to begin
- how the preparatory work required to reach that condition is made visible, governed, and capacity-bearing
- how implementation work is judged complete against item-specific completion criteria

A critical operating distinction follows from this scope.

RMF does not prohibit all work on an item before that item is ready for implementation.

RMF requires and governs preparatory work that matures an item toward readiness.

What RMF prohibits is beginning implementation work before the governing readiness conditions have been satisfied.

That distinction must remain explicit throughout this doctrine.

A second critical distinction also follows.

Preparatory work is not merely "work that happens earlier."

Preparatory work is the real maturity work required to make responsible implementation possible.

Because this work often exists before the implementation item has become sufficiently knowable and bounded, it must not be hidden inside implementation effort or treated as though it were already normal implementation work.

RMF therefore governs not only readiness as a gate, but also the visibility and governability of the preparatory work required to reach that gate.

---

### 2. Core Assertion

Requirements Maturation Flow establishes that:

Implementation work must not start until it is ready.

Implementation work is only finished when it is verifiably done.

These are not merely good habits. They are the governing operational constraints of RMF.

RMF therefore treats the following as first-class operating concerns:

- whether the meaning of the implementation work is sufficiently shared before implementation begins
- whether the implementation work has satisfied its bespoke readiness criteria before commitment to implementation
- whether the implementation work has satisfied its bespoke completion criteria before acceptance as done
- whether the preparatory work required to make the item ready has been made visible, scheduled, and completed

RMF is the doctrine that governs this operational flow.

PKBDD governs where authoritative persisted specifications live and when they are binding.

RMF governs when work around those specifications is mature enough that implementation may responsibly begin and when implementation may be accepted as complete.

RMF therefore governs the operational flow around implementation work.

It does not erase or deny the existence of preparatory work.

It requires that preparatory work be treated honestly as real work rather than hidden as assumption, interruption, unmanaged overhead, or disguised implementation effort.

That requirement is not optional decoration.

Without visibility into preparatory work, inspection is distorted, adaptation is weakened, and implementation commitments are made against a false picture of what remains to be done.

RMF exists in part to correct that condition.

---

### 3. Principles of RMF

The following principles define RMF operating law.

#### 3.1 Implementation Work Must Not Start Until It Is Ready

No implementation work may begin merely because an item exists, has been discussed, or appears urgent.

Implementation may begin only when the item satisfies the readiness conditions appropriate to that item.

Readiness is not approximated by optimism, informal confidence, or schedule pressure.

Readiness is a governed condition.

This principle does not prohibit preparatory work.

It prohibits beginning implementation work before readiness has been achieved.

Preparatory work exists precisely because readiness is not assumed.

#### 3.2 Implementation Work Is Only Finished When It Is Verifiably Done

An implementation work item is not complete merely because coding activity has ceased, a demonstration occurred, or participants feel satisfied.

Implementation work is complete only when it satisfies the bespoke Definition of Done established for that item and that satisfaction has been verified.

This principle governs completion of implementation work.

It does not imply that all work related to the item vanishes at that moment. It defines the completion condition for the governed implementation effort on that item.

#### 3.3 Shared Understanding Precedes Execution

The team must not treat implementation as the means by which the meaning of the work is discovered.

Shared understanding is a pre-implementation concern.

Verification of shared understanding may be verbal or otherwise lightweight.

No specific shared-understanding artifact is required by RMF.

What is required is that the readiness condition be genuinely satisfied and that completion of the preparatory work required to achieve that understanding be made visible through the governing readiness surfaces for the item.

#### 3.4 Readiness and Done-Ness Are Bespoke

Readiness and done-ness are specific to the implementation item under consideration.

Generic checklists may serve as starting points.

They are not substitutes for item-specific readiness and completion criteria.

RMF therefore rejects the idea that one generic Definition of Ready or one generic Definition of Done is sufficient for all implementation work.

#### 3.5 Visibility of Maturity Work Is Essential

The preparatory work required to become ready is real work.

If it is not made visible, it will still occur, but it will occur informally, reactively, and outside governed planning.

RMF therefore requires that readiness and maturation work be made visible as work rather than hidden as assumption, interruption, or unmanaged overhead.

The point is not merely to acknowledge that such work exists.

The point is to govern it honestly so that implementation commitment is made against verified readiness rather than against hope.

This is also why RMF treats concealment of preparatory work inside implementation effort as a failure of operational transparency.

When preparatory work is hidden, people outside the immediate team tend to underestimate how much real work remains before responsible implementation can begin.

That produces unrealistic expectations, distorted commitments, bureaucratic pressure, and false narratives about team underperformance.

RMF corrects that condition by requiring the work of becoming ready to become visible, governable, and schedulable in its own right.

#### 3.6 Timeboxing Is a Core Response to the Nature of Preparatory Work

Preparatory work is often not honestly estimable in the same way mature implementation work becomes estimable once the item has become sufficiently known, bounded, and ready.

That does not make preparatory work optional.

It means the operating response must differ.

RMF therefore treats timeboxing as a core governance mechanism for preparatory work when the work is not yet sufficiently knowable to estimate as implementation work.

Timeboxing allocates capacity to readiness work without pretending that the team already knows more than it actually knows.

It creates a governed way to inspect progress toward readiness, adapt the remaining readiness work, and reserve real capacity for the work required to make implementation possible.

Timeboxing is therefore not incidental convenience.

It is one of the practical ways RMF prevents opaque preparatory work from being hidden inside implementation commitments.

#### 3.7 RMF Is Additive, Not Substitutive

RMF does not replace iterative delivery frameworks.

It adds the missing operational discipline needed to prevent unready implementation work from entering execution and to prevent ambiguous implementation work from being accepted as done.

#### 3.8 RMF 3 Expands RMF 1

RMF 1 is not discarded when RMF 3 is adopted.

RMF 3 formalizes and expands RMF 1 by turning its readiness concern into a bespoke Definition of Ready and a formal readiness gate.

The readiness concern remains the same.

The governing surface becomes more explicit.

---

### 4. The Three Components of RMF

RMF consists of three mutually reinforcing components.

#### 4.1 RMF 1 - Shared Understanding Before Implementation

RMF 1 governs the pre-implementation requirement that the relevant participants share sufficient understanding of the intended implementation work before implementation begins.

Its purpose is not to create a mandatory document.

Its purpose is to ensure that implementation does not become the place where the meaning of the work is first discovered.

RMF 1 therefore guarantees a readiness criterion:

Before implementation begins, the item must have verified shared understanding.

The method of verification may be verbal, written, or otherwise appropriate to the context.

RMF does not require a specific shared-understanding artifact.

What RMF requires is that this readiness condition be genuinely satisfied and that the preparatory work required to achieve it be visible.

#### 4.2 RMF 2 - Bespoke Definition of Done and Acceptance Gate

RMF 2 governs the completion side of implementation work.

Each implementation item must have a bespoke Definition of Done that defines what must be true for the implementation work on that item to be accepted as complete.

RMF 2 establishes that completion is not a matter of mood, convention, or vague team sentiment.

It is a governed acceptance gate.

An implementation work item may be accepted as done only when its bespoke Definition of Done has been satisfied and verified.

#### 4.3 RMF 3 - Bespoke Definition of Ready and Formal Readiness Gate

RMF 3 governs the formal readiness side of implementation work.

Each implementation item must have a bespoke Definition of Ready that defines what must be true before that item may be committed to implementation.

RMF 3 therefore converts the readiness concern of RMF 1 into a formal pre-implementation gate.

An implementation item may not enter implementation until its bespoke Definition of Ready has been satisfied.

RMF 3 expands RMF 1 rather than replacing it.

Shared understanding remains part of readiness.

RMF 3 makes that readiness governable through a formal gate.

---

### 5. Preparatory Work, Implementation Work, and Gate Semantics

#### 5.1 Preparatory Work and Implementation Work Are Distinct

RMF requires a clear distinction between:

- preparatory work that matures an item toward readiness
- implementation work that realizes the item once readiness has been achieved

Preparatory work may include analysis, clarification, dependency resolution, data preparation, environment preparation, design alignment, compliance alignment, skills acquisition, refactoring needed to enable safe implementation, and similar efforts needed to make responsible implementation possible.

Implementation work is the downstream realization effort performed after the item is ready.

This distinction is not optional.

If preparatory work and implementation work are collapsed into one undifferentiated concept of "work," readiness doctrine becomes incoherent.

It also becomes far easier for readiness work to be hidden inside implementation effort, which makes the actual state of the item less visible to the team and to others who rely on that visibility.

#### 5.2 Readiness Is a Governed Condition

Readiness is not synonymous with refinement, discussion, interest, or partial understanding.

Readiness is the condition in which the item satisfies the governing criteria that must be true before implementation can begin.

An item that has been discussed but does not satisfy those criteria is not ready.

An item that is partially understood but does not satisfy those criteria is not ready.

An item that is urgent but does not satisfy those criteria is not ready.

#### 5.3 Definition of Ready

The Definition of Ready is the bespoke readiness contract for a specific implementation item.

It defines the conditions that must be satisfied before responsibility for implementation may be accepted.

Those conditions may include, among other things:

- shared understanding
- required specification presence and linkage
- identified and resolved dependencies
- data, design, compliance, or environment prerequisites
- agreement on the bespoke Definition of Done
- any other item-specific condition necessary for responsible implementation

A Definition of Ready is therefore a gate surface, not a generic checklist ritual.

It governs the boundary between preparatory work and implementation commitment.

#### 5.4 Definition of Done

The Definition of Done is the bespoke completion contract for a specific implementation item.

It defines the conditions that must be satisfied before the implementation work on that item may be accepted as complete.

Those conditions may include specification satisfaction, verification, testing, review, acceptance, and any other item-specific completion concern.

A Definition of Done is therefore a completion gate, not a ceremonial declaration.

#### 5.5 Ready for Implementation versus Ready for Sprint

RMF distinguishes between readiness to schedule preparatory work and readiness to begin implementation.

Ready for Sprint applies to work items whose purpose is preparatory readiness work and which may be scheduled to perform that maturation work.

Ready for Implementation applies to implementation work items whose bespoke Definition of Ready has been satisfied and which may therefore be committed to implementation.

These are not interchangeable states.

Confusing them collapses preparatory work into implementation work and undermines the purpose of RMF.

#### 5.6 Changes to Readiness or Done Criteria Mid-Flight

If bespoke readiness or completion criteria must change after implementation has already begun, that does not retroactively make the work ready.

The implementation effort must be re-evaluated against the governing readiness and completion conditions.

If the changed conditions mean readiness is no longer satisfied, the item must return to preparatory readiness work before implementation continues.

RMF therefore treats mid-flight criteria changes as governing operational events rather than as harmless administrative edits.

---

### 6. Visible Maturity Work

#### 6.1 Maturity Work Is Real Work

Analysis, clarification, dependency resolution, design alignment, data preparation, compliance preparation, skills acquisition, and similar efforts are not imaginary pre-work.

They are real preparatory work required to make an item fit for implementation.

RMF therefore treats readiness work as schedulable and visible.

This visibility is not optional convenience.

It is required so that the actual state of readiness can be inspected honestly and so that adaptation can occur against reality rather than against an optimistic fiction that implementation is all that remains.

#### 6.2 Readiness PBIs and Analysis PBIs

Where preparatory work must be planned, reserved, tracked, or timeboxed, it should exist as explicit work items rather than being hidden inside an implementation item.

These readiness-oriented work items exist to:

- make maturity work visible
- allow capacity to be reserved for it
- make blocked readiness discoverable
- preserve operational honesty about what must happen before implementation can responsibly begin

Their role is to govern visible maturation flow around implementation work.

They are not a loophole for starting implementation early under a different label.

They are the governed mechanism for doing the preparatory work required before implementation may begin.

One of the reasons these work items exist is that much preparatory work is not yet sufficiently knowable to estimate as mature implementation work.

Readiness work items therefore provide a legitimate operational mechanism for handling work that must be planned and capacity-bearing even when the remaining effort cannot yet be represented honestly as bounded implementation effort.

#### 6.3 Timeboxing Readiness Work

When preparatory work is not yet sufficiently knowable to estimate honestly as implementation work, RMF requires an explicit operating response rather than concealment.

A primary response is timeboxing.

Timeboxing readiness work allows a team to:

- allocate real capacity to becoming ready
- inspect what has been learned during the timebox
- adapt the remaining readiness work based on what is now known
- preserve honesty about uncertainty instead of pretending the work is already implementation-ready

Timeboxing does not make the work less real.

It makes the governance of uncertain preparatory work more honest.

This is one of the key ways RMF supports transparency in contexts where the work needed to become ready cannot yet be predicted with the same fidelity expected of mature implementation work.

#### 6.4 Shared Readiness Work

When one readiness concern serves multiple implementation items, it may be managed as shared readiness work.

This does not remove the requirement that each implementation item satisfy its own bespoke Definition of Ready.

RMF governs visibility and coordination of readiness work.

It does not allow readiness obligations to disappear into shared ambiguity.

---

### 7. RMF and PKBDD

#### 7.1 Boundary with PKBDD

PKBDD governs where authoritative specifications live, when those specifications become binding, and how persisted specification authority operates within the PKB.

RMF does not redefine any of that.

RMF governs the operational flow around work items that depend on those authoritative specification surfaces.

In simplified form:

- PKBDD governs authoritative persisted specification
- RMF governs readiness and done flow around implementation work

#### 7.2 Operational Interlock

RMF and PKBDD interlock at the points where readiness and completion criteria refer to authoritative specifications.

This includes, for example:

- whether required specifications exist
- whether they are linked where needed
- whether the necessary specification surfaces are in an appropriate state for the work under consideration
- whether readiness outputs that should persist have been captured in the PKB

RMF therefore depends on PKBDD.

It does not replace it.

#### 7.3 Optional PKB Capture of Shared-Understanding Notes

RMF does not require a mandatory shared-understanding artifact.

However, in higher-risk, longer-lived, or otherwise context-heavy work, teams may choose to capture shared-understanding outputs or notes in the PKB.

When they do so, PKBDD craftsmanship and PKBDD authority rules govern that capture.

RMF governs only the operational significance of whether the readiness condition has been satisfied.

---

### 8. RMF and Other Downstream Practices

#### 8.1 RMF and BDD

RMF does not govern how Specified Behavior is expressed.

BDD craftsmanship governs scenario-form expression.

RMF governs whether implementation work is mature enough that meaningful behavioral expression and implementation commitment may responsibly occur.

#### 8.2 RMF and Engineering Realization

RMF does not govern implementation technique, test architecture, design patterns, refactoring practice, or release engineering.

Engineering doctrine governs realization downstream of the authoritative and matured requirement surfaces.

RMF governs only the maturity and gate conditions under which implementation may responsibly begin and be accepted as complete.

---

### 9. Boundary on Templates, Adoption Material, and Future RMF Layers

#### 9.1 Starter Templates Are Not Doctrine

Definitions of Ready, Definitions of Done, and work-item templates may provide useful starting points.

They are not, by themselves, RMF doctrine.

RMF doctrine governs what such artifacts are for and what role they play.

It does not reduce itself to template copy.

#### 9.2 This Guide Is Not RMF Craftsmanship

This guide defines RMF operating doctrine.

It does not yet define the later local craftsmanship questions such as:

- how to craft good bespoke DoR criteria
- how to craft good bespoke DoD criteria
- local anti-patterns in wording those criteria
- local review discipline for RMF support artifacts

If those concerns later require canonization, they belong in a later RMF craftsmanship artifact rather than in this first operating doctrine.

#### 9.3 This Guide Is Not an Adoption Manual

This guide may include rationale where needed to preserve understanding.

It is not the place for broad rollout playbooks, maturity models, dashboards, or consulting-style transformation guidance unless and until those concerns are explicitly assigned a doctrinal home.

---

### 10. Summary Assertion

Requirements Maturation Flow is the operating doctrine that governs:

- whether implementation work is mature enough to begin
- whether the preparatory work required to make that implementation ready has been made visible and governed honestly
- whether an implementation work item may be accepted as complete against its bespoke completion criteria

RMF closes the operational gap between authoritative persisted requirements and downstream realization by governing:

- readiness before implementation
- visible preparatory maturation work
- timeboxed and schedulable readiness work where needed
- formal readiness gates where needed
- formal completion gates where needed
- the disciplined relationship between RMF 1, RMF 2, and RMF 3

It does so without redefining Capability, Behavior, PKBDD authority, craftsmanship, or engineering realization.
