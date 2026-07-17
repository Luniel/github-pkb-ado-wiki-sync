### Producore Canonical Guide - RMF Craftsmanship Standard - Part 1 of 2

> **13A - Foundations and Bespoke Criteria**  
> Covers purpose, authority boundaries, the role of RMF support artifacts, and craftsmanship rules for bespoke Definitions of Ready and Definitions of Done.

#### 1. Purpose and Scope

This guide defines Producore's delegated local standard for crafting RMF support artifacts so that readiness work, implementation-gating surfaces, completion-gating surfaces, and related RMF-local coordination artifacts can participate safely in the RMF operating system without drifting into operating doctrine, authority, PKB ontology, or engineering realization.

This guide exists because RMF Operating Doctrine governs the operating law of readiness, preparatory work visibility, implementation gating, completion gating, and the relationship between RMF 1, RMF 2, and RMF 3. That operating doctrine does not, by itself, fully govern the local craft of how teams author bespoke Definitions of Ready, bespoke Definitions of Done, readiness-oriented work-item surfaces, and other RMF support artifacts as artifacts. Teams still need doctrine-safe rules for how those artifact types are used, what constitutes good and poor local expression, how generic starter assets are adapted into item-specific working surfaces, how local review detects craftsmanship defects before gate decisions are made, and how RMF support artifacts remain support artifacts rather than silently becoming doctrine.

This guide governs:

- RMF support-artifact authoring discipline
- local craftsmanship for bespoke Definition of Ready criteria
- local craftsmanship for bespoke Definition of Done criteria
- local craftsmanship for readiness-oriented work-item surfaces
- local review discipline for RMF support artifacts
- RMF-local anti-patterns
- first-choice authoring and presentation conventions that do not redefine higher doctrine
- doctrine-safe use of RMF starter templates

This guide does not govern:

- what a Capability is
- what Behavior is
- what makes a specification binding
- lifecycle state definitions or legal transitions
- RMF operating law
- PKB page craft
- scenario-form craftsmanship
- engineering realization practice
- host-platform topology or board-tool mechanics

This guide governs RMF craftsmanship only.

It does not decide whether a work item is ready, whether implementation may begin, whether work is done, or whether an authoritative PKB specification exists in the right state.

It helps ensure that the support artifacts used in those operating decisions are authored in a way that allows RMF operating doctrine to function safely and honestly.

A critical distinction follows from this.

RMF support artifacts are not the same thing as RMF doctrine.

Definitions of Ready, Definitions of Done, readiness checklists, readiness work items, and similar local artifacts are governed support surfaces. They help teams apply RMF operating law in concrete local contexts. They do not define RMF operating law by themselves.

A second distinction also follows.

RMF support artifacts are not the same thing as authoritative PKB requirement/specification artifacts.

They may reference authoritative specifications, depend on them, and enforce preconditions around them. They must not become the hidden place where authoritative requirement meaning, binding behavioral detail, or missing specification content actually lives.

---

#### 2. Authority, Precedence, and Canonical Boundary

##### 2.1 Delegated Authority

Authority is delegated to this guide only for RMF-local craftsmanship.

That delegated authority covers:

- authoring discipline for bespoke Definitions of Ready
- authoring discipline for bespoke Definitions of Done
- local interpretation and safe use of RMF starter templates
- craftsmanship-level review of RMF support artifacts
- RMF-local anti-patterns
- first-choice conventions for readiness-oriented work-item surfaces
- local distinctions between valid support-artifact content and content that must instead live in doctrine, authoritative PKB artifacts, or engineering surfaces

This guide has no authority to define ontology, confer binding status, alter lifecycle semantics, redefine RMF operating law, or define downstream engineering technique.

##### 2.2 Precedence

If any statement in this guide conflicts with a higher authority, the higher authority governs.

Precedence order:

1. Producore Canonical Definition Guide - Capability System
2. Producore Canonical Definition Guide - Behavior System
3. Producore Canonical Guide - PKBDD Operating Doctrine
4. Producore Canonical Guide - RMF Operating Doctrine
5. Producore Canonical Guide - BDD Craftsmanship Standard
6. Producore Canonical Guide - PKBDD Craftsmanship Standard
7. Producore Engineering Doctrine
8. This guide

This guide may refine only delegated local practice.

It may not reinterpret upstream definitions or redistribute doctrinal ownership.

##### 2.3 Scope Boundary

This guide must not redefine:

- Capability
- Behavior
- correctness
- binding authority
- lifecycle authority
- RMF operating law
- PKB ontology
- engineering realization rules

It only defines how RMF support artifacts are crafted locally and safely.

##### 2.4 Canonical Alignment

All craftsmanship under this guide operates within the canonical chain already defined elsewhere.

For local craftsmanship purposes:

- RMF support artifacts must remain downstream of RMF operating doctrine
- readiness and completion criteria may depend on authoritative PKB specifications without attempting to redefine them
- implementation and verification must remain downstream consumers of readiness and completion decisions, not their authors
- support artifacts must not become hidden authority surfaces

If that chain is violated, the problem is doctrinal or structural, not craftsmanship-related, and must be corrected in the appropriate higher document.

##### 2.5 Binding Boundary

Whether a PKB specification is authoritative is governed exclusively by the PKBDD Operating Doctrine.

Whether implementation may begin or work may be accepted as done is governed exclusively by RMF Operating Doctrine.

Craftsmanship and support-artifact form do not confer authority and do not create gate legitimacy by themselves.

Therefore:

- a well-crafted Definition of Ready may still be used against an item that is not actually ready
- a poorly crafted Definition of Ready may still be attached to an item whose readiness must still be judged under RMF doctrine
- a support artifact may be locally clean while still being attached to the wrong authoritative specification state
- a support artifact may be heavily populated and still be invalid because it contains the wrong kind of content

This guide governs quality of local support-artifact expression, not operating authority.

##### Rationale

The Producore doctrine separates:

- definition
- expression
- authority
- operating law
- realization

This guide exists only in the delegated local-practice layer.

Without that separation, teams start using templates as doctrine, boards as authority, or checklist completion as a substitute for genuine readiness.

---

#### 3. Role of RMF Support Artifacts

RMF support artifacts exist to make readiness work and completion conditions locally usable, inspectable, and reviewable.

They serve as support surfaces for applying RMF operating doctrine in concrete work contexts.

They do not define readiness doctrine by themselves.

They do not replace authoritative specifications.

They do not replace engineering verification.

Typical RMF support artifacts include:

- bespoke Definitions of Ready
- bespoke Definitions of Done
- readiness-oriented work items
- readiness progress tracking surfaces
- supporting notes that clarify local gate application without becoming hidden requirement authority

These artifacts may:

- make preconditions explicit
- make completion conditions explicit
- make blocked readiness visible
- make preparatory work visible and schedulable
- reference authoritative PKB specification surfaces
- reveal when work is not yet mature enough for implementation

These artifacts must not:

- invent requirement meaning that belongs in PKB specifications
- redefine RMF operating law
- replace engineering verification with checklist confidence
- become dumping grounds for unresolved ambiguity
- conceal the absence of real readiness beneath generic checklist completion

##### Rationale

Support artifacts are necessary because operating law must be applied somewhere concrete.

But once teams begin using local support surfaces, a second risk appears: the support surfaces themselves start absorbing doctrine, authority, and missing specification meaning.

This guide exists to prevent that drift.

---

#### 4. Crafting Bespoke Definitions of Ready

##### 4.1 A Bespoke Definition of Ready Is a Readiness Contract for One Implementation Item

A valid Definition of Ready must be specific to the implementation item under consideration.

It must not be treated as a ritual checklist copied mechanically from a generic template.

A bespoke Definition of Ready must answer this local question:

What must be true before responsibility for implementation may be accepted for this item?

That question must be answered in a way that is:

- item-specific
- explicit
- inspectable
- reviewable by the relevant participants
- grounded in the actual readiness needs of the item

##### 4.2 Criteria Must Be Necessary and Readiness-Relevant

Each Definition of Ready criterion should earn its place.

A valid criterion should represent a condition whose absence would make responsible implementation premature, risky, or meaningfully underprepared.

Criteria should not be included merely because:

- they appear in a generic starter template
- they are usually useful in other cases
- they feel administratively thorough
- someone wants a larger list

A weak Definition of Ready accumulates ceremonial checks.

A strong Definition of Ready identifies the real readiness conditions for the item.

##### 4.3 Criteria Must Be Concrete Enough to Review

A Definition of Ready criterion must be concrete enough that the relevant participants can determine whether it is satisfied.

A criterion is weak when it depends on vague confidence language such as:

- sufficiently understood
- mostly ready
- seems clear
- probably resolved
- looks fine
- team is comfortable

A criterion is stronger when it identifies what must actually be true, such as:

- the required specifications are linked
- the necessary dependencies are identified and resolved
- the shared understanding condition has been verified
- the bespoke Definition of Done has been agreed
- the required readiness work has been completed

The point is not to maximize checklist length.

The point is to make readiness review honest.

##### 4.4 Criteria Must Not Smuggle in Implementation Technique

A Definition of Ready may identify prerequisites for responsible implementation.

It must not prescribe implementation choreography, design-pattern selection, test architecture, or other engineering-realization choices unless those are genuinely preconditions to beginning work and belong there for that reason.

If a criterion is really downstream implementation technique, it belongs elsewhere.

##### 4.5 Criteria Must Not Become Hidden Requirement Specification

A Definition of Ready may reference required authoritative specifications.

It may identify that specification presence, linkage, scope clarity, or state are prerequisites for implementation.

It must not become the place where the missing requirement meaning is actually written because the authoritative specification is incomplete.

If the Definition of Ready contains business rules, behavior definitions, or decision logic that should have existed in the authoritative specification, the problem is not "more DoR detail needed."

The problem is upstream specification incompleteness.

##### 4.6 Shared Understanding Must Be Handled Honestly

Where shared understanding is part of readiness, the Definition of Ready should capture the condition honestly without forcing a mandatory artifact that RMF doctrine does not require.

Valid local expression may confirm, for example, that:

- the relevant participants believe they share the same understanding of the work
- the Definition of Done has been reviewed together
- the necessary scenarios or specifications have been examined together
- the outstanding readiness concerns have been surfaced and addressed

Invalid local expression treats shared understanding as satisfied merely because a meeting occurred or because a checkbox was copied from a template without substantive review.

##### 4.7 The Definition of Done Relationship Must Remain Explicit

A valid Definition of Ready often includes conditions related to the existence, review, and agreement of the bespoke Definition of Done.

That relationship must remain explicit.

A team that begins implementation without a stable completion contract is not ready simply because other preparatory checks appear complete.

##### Rationale

A bespoke Definition of Ready is one of the main local surfaces through which RMF operating doctrine becomes usable.

If it is weak, ceremonial, vague, or used as a substitute for upstream specification clarity, RMF loses its operational value even while appearing formally present.

---

#### 5. Crafting Bespoke Definitions of Done

##### 5.1 A Bespoke Definition of Done Is a Completion Contract for One Implementation Item

A valid Definition of Done must be specific to the implementation item under consideration.

It must answer this local question:

What must be true before the implementation work on this item may be accepted as complete?

A bespoke Definition of Done is not a recycled team slogan.

It is a concrete local completion contract.

##### 5.2 Criteria Must Be Necessary and Completion-Relevant

Each criterion should represent a condition whose absence would mean the implementation work is not yet responsibly complete.

Criteria should not be included merely because:

- they usually appear on generic templates
- they sound disciplined
- they create the appearance of rigor
- they were copied from another item without examination

A weak Definition of Done accumulates generic obligations.

A strong Definition of Done identifies the actual completion conditions for the item.

##### 5.3 Criteria Must Be Concrete Enough to Verify

A Definition of Done criterion must be concrete enough that participants can determine whether it has been satisfied.

Weak completion criteria rely on vague language such as:

- appears complete
- seems acceptable
- behavior looks correct
- tested enough
- team is satisfied

Stronger criteria identify what must actually be verified, demonstrated, reviewed, promoted, or accepted.

The purpose is not administrative neatness.

The purpose is honest acceptance gating.

##### 5.4 Criteria Must Not Collapse Verification into Sentiment

Completion must not be reduced to mood, confidence, or ritual sign-off.

A valid Definition of Done may include acceptance attestations, but it must not rely on those attestations as substitutes for the actual conditions that must be true.

The artifact should help reveal whether work is done.

It must not help hide that the basis of completion is vague.

##### 5.5 Criteria Must Not Smuggle in Upstream Requirement Meaning

A Definition of Done may reference specifications, tests, demonstrations, or acceptance conditions downstream of those specifications.

It must not become the place where missing behavioral rules, omitted scenarios, or undefined business constraints are quietly inserted because the authoritative requirement surface is incomplete.

If completion criteria are compensating for missing requirement meaning, the problem is upstream, not local craftsmanship.

##### 5.6 Criteria Should Preserve the Relationship to the Governing Specification Surfaces

Where completion depends on authoritative specifications, that dependency should be explicit.

A good Definition of Done makes clear that the work is complete in relation to the governing specification surfaces rather than floating free as a generic engineering checklist.

##### Rationale

A bespoke Definition of Done is the local support surface through which RMF completion doctrine becomes operationally inspectable.

If it becomes ceremonial, vague, or overloaded with content that belongs elsewhere, acceptance loses integrity.
