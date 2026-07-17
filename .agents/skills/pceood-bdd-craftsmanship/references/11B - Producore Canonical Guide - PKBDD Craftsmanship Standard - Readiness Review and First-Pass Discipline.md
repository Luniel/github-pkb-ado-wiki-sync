
### Producore Canonical Guide - PKBDD Craftsmanship Standard - Part 2 of 2

> **11B - Readiness Review and First-Pass Discipline**  
> Covers readiness, review, anti-patterns, governed templates, first-pass discipline.

#### 11. Draft and Promotion Authoring Discipline

##### 11.1 Before Page Generation

Template or page generation should not proceed until there is sufficiently explicit local authoring discipline for:

- what belongs on that page type
- what must not appear there
- how the template is to be interpreted
- what readiness gates apply to the artifact

Page generation before page-type discipline creates structurally weak PKBs.

##### 11.2 Readiness to Create a Behavior Specification Page

Before creating a behavior specification page, the author should be able to state:

- the owning capability or sub-capability
- the bounded behavior being expressed
- the primary event or trigger under analysis
- the intended scope boundary
- the key unresolved questions, if any

If those cannot be stated clearly, the artifact is not ready to be instantiated as a behavioral contract page.

##### 11.2A Readiness to Create an Open Questions and Maturation Page

Before creating an `Open Questions and Maturation` page, the author should be able to state:

- the owning capability or sub-capability
- the unresolved meaning, follow-on concerns, or maturation pressure that materially affect later refinement or interpretation
- why that content does not belong in the corrected current scenario
- why that content does not yet belong in an appropriate non-`Current` specification surface

If those cannot be stated clearly, the page is not yet justified as a distinct capability-local support surface and should not be created merely as a generic notes page.

##### 11.3 Readiness to Promote Toward `Approved New`

Before promoting a draft behavior specification toward `Approved New`, the author should be able to defend:

- explicit capability ownership
- adequate behavior clarity
- absence of hidden implementation logic
- meaningful processing of open questions and permutations relevant to the artifact
- correct section semantics
- appropriate cleanup of no-longer-useful draft scaffolding

##### 11.4 Why This Matters

PKBDD lifecycle authority must not be burdened with artifacts that are still structurally confused at the local craftsmanship level.

Lifecycle does not rescue weak artifact craft.

It governs artifacts that are already structurally suitable for governance.

---

#### 12. Rule Weight: Binding Craftsmanship Rules vs First-Choice Conventions

Not all PKBDD craftsmanship guidance has the same weight.

This guide distinguishes between:

- binding PKBDD craftsmanship rules
- first-choice PKB authoring conventions

##### 12.1 Binding Craftsmanship Rules

A binding craftsmanship rule is a real correctness-of-craft requirement within this guide's delegated boundary.

Violation of a binding craftsmanship rule is a real craftsmanship defect.

Examples include:

- a behavior specification page must live under exactly one capability or sub-capability
- support artifacts must not act as behavioral contract artifacts
- `Dependencies` may list only true capability dependencies that must be used in implementation
- `Implementation Notes` must remain optional and non-authoritative
- visual design pages must not override or silently redefine behavior specifications
- capability pages must not be used as hidden specification dumps

##### 12.2 First-Choice Conventions

A first-choice convention is a preferred local practice that improves consistency, readability, usability, or structural stability without automatically turning every deviation into structural invalidity.

Examples include:

- separating template instructions from reusable content
- wrapping reusable template content in fenced Markdown code blocks
- retaining visible scaffolding in `Draft`
- cleaning empty sections during maturation toward `Approved New`
- using host-compatible page and folder patterns where a governed host model is in use

##### 12.3 Why the Distinction Matters

Without this distinction, guides become either too weak or too noisy.

If every preference is treated as invalidity, the guide becomes brittle and oppressive.

If every rule is phrased as a suggestion, the guide loses force and drift becomes normalized.

This distinction preserves rigor without collapsing craft into stylistic policing.

---

#### 13. Preferred PKB Structural Conventions

This section defines first-choice conventions, not universal PKBDD ontology.

##### 13.1 Template-Family Convention

A top-level template family is a preferred way to keep reusable PKB authoring aids explicit, discoverable, and governable.

##### 13.2 Host-Platform Compatibility Convention

Where a governed host model is in use, first-choice local craftsmanship should remain compatible with that host model rather than forcing authors to reverse-engineer local exceptions.

This guide does not define host-platform materialization mechanics.

Where Azure DevOps Repo Wiki is the host model, apply the separate ADO Repo Wiki PKB Production Standard for topology, ordering, repo-native naming, and navigation form.

##### 13.3 Draft Cleanup Convention

Prefer visible incompleteness over hidden ambiguity while drafting.

Prefer cleaner, more intentional surfaces as artifacts mature.

##### 13.4 Naming Convention for Page Types

Prefer page names that make artifact type clear.

Capability pages should read like capabilities.

Behavior specification pages should read like specification artifacts, not vague notes.

Visual design pages should be clearly identifiable as visual-design surfaces.

Template pages should be clearly named as templates.

##### 13.5 Host-Visible Naming Convention

Where the host platform exposes page or file names prominently in navigation, search, or linking, first-choice local craftsmanship should keep artifact class sufficiently legible from the visible name.

This guide does not define host-platform naming mechanics.

Where Azure DevOps Repo Wiki is the host model, apply the separate ADO Repo Wiki PKB Production Standard for repo-native naming expectations.

At the PKBDD craftsmanship level, the local consequence is simple:

- do not rely on in-body prose alone to make artifact class legible where host-visible naming materially affects interpretation
- do not choose vague note-like names that blur whether the page is a capability, specification, support artifact, visual design surface, or template
- do not hide lifecycle-bearing posture in the visible name where local host-compatible convention expects that posture to be legible

This is a first-choice local craftsmanship convention, not universal PKBDD ontology and not a redefinition of lifecycle law.

---

#### 14. PKBDD Anti-Patterns

The following are craftsmanship failures.

- capability page used as a requirement dump
- behavior specification page used as an analysis notebook
- support page treated as an authoritative behavior surface
- `Dependencies` used as a generic related-links list
- `Implementation Notes` used to smuggle in behavior or scope
- visual design page used to define logic or state transitions
- template page that mixes instructions and reusable content unsafely
- copied template page treated as mature merely because it looks structured
- exhaustive exclusion lists on capability pages
- empty-section cleanup performed too early, hiding incompleteness
- empty-section scaffolding left forever after maturity, creating noise and drift
- work item treated as the real source of requirement meaning while the PKB artifact remains thin or incomplete
- linked work items used to hold authoritative section content that should live on the PKB page
- host-visible page or file names that hide artifact class or expected lifecycle posture so thoroughly that readers must inspect body prose to determine what kind of PKB artifact they are reading

Anti-pattern sections are not included for scolding effect. They exist because drift often arrives not as obvious doctrinal rebellion, but as locally convenient misuse of otherwise reasonable artifact surfaces.

---

#### 15. Reviewer Checklist and Author Self-Check

##### 15.1 Capability-Page Review Checks

- [ ] Does this page summarize what must be possible and why the Capability exists, rather than behavioral detail?
- [ ] Does it remain independent of implementation?
- [ ] Does it avoid becoming a hidden specification surface?

##### 15.2 Behavior-Specification-Page Review Checks

- [ ] Is the page under exactly one capability or sub-capability?
- [ ] Does `Dependencies` contain only true capability dependencies that must be used in implementation?
- [ ] Are `Implementation Notes`, if present, clearly aids rather than instructions?
- [ ] Are support links and supplementary aspects placed in the correct sections?
- [ ] Is visible draft scaffolding appropriate for the current lifecycle state?
- [ ] Has the page avoided becoming a notebook, decision dump, or mixed-purpose surface?
- [ ] Would this page still stand as the requirement surface if the linked work items disappeared?
- [ ] Are linked work items serving traceability and coordination only, rather than carrying missing requirement meaning?

##### 15.3 Template-Page Review Checks

- [ ] Are instructions separated from the reusable template?
- [ ] Is the reusable template safely copyable?
- [ ] Does the template page avoid implying authority?
- [ ] Are section-interpretation warnings explicit where needed?

##### 15.4 Author Self-Check

Before presenting a PKB artifact downstream or for lifecycle progression, the acting author should be able to answer yes to the following:

- [ ] Do I know exactly what kind of PKB artifact this is?
- [ ] Do I know what this artifact is allowed to do and not allowed to do?
- [ ] Have I used each named section according to its governed meaning?
- [ ] Have I avoided using convenience surfaces as hidden authority surfaces?
- [ ] Is visible incompleteness still appropriate for the artifact's maturity, or is cleanup now required?
- [ ] Would a reviewer understand this page's role without me having to explain what kind of page it is supposed to be?
- [ ] If someone ignored the linked work items entirely, would this artifact still communicate what it claims to communicate?
- [ ] If the host platform exposes names prominently in navigation, is the artifact class sufficiently legible there?
- [ ] If local convention uses visible lifecycle signaling, is that signaling present and unambiguous?

---

#### 16. Governed Template Family

The following initial template family is governed by this guide.

##### 16.1 Capability Template

This template is for drafting capability pages.

It should be used to create lightweight, bounded capability surfaces.

It must not be used to embed behavioral specifications or to create exhaustive anti-scope inventories.

##### 16.2 Draft Specification - Behavior Template

This template is for drafting new or evolving behavior specification pages.

It should be used to preserve consistent section semantics, visible drafting support, and disciplined supplementary surfaces around the behavioral contract.

It must not be used to define capability structure, implementation logic, or hidden rationale in place of the specification.

##### 16.3 Draft Specification - Visual Design Template

This template is for drafting visual design specification pages.

It should be used to preserve strong visual-design separation of concerns and visual-reference continuity.

It must not be used to define behavioral rules, triggers, state transitions, or logic.

##### 16.4 Open Questions and Maturation Template

This template is for drafting capability-local `Open Questions and Maturation` pages.

It should be used to preserve unresolved meaning, follow-on concerns, and maturation pressure honestly when that content does not belong in the corrected current scenario or in an appropriate non-`Current` specification surface.

It must not be used as a behavioral contract artifact, a generic notes page, or a place to leave clarified governable behavioral meaning indefinitely once that meaning is ready for the appropriate specification surface.

##### 16.5 Why the Included Templates Matter

The included templates are not merely conveniences.

They are the first governed artifact family for this guide.

They provide practical authoring surfaces through which this guide's craftsmanship rules become operational.

---

#### 17. First-Pass Artifact Selection and Local Page-Type Discipline

A first-pass PKB often contains mixed-maturity knowledge.

PKB-local craftsmanship must therefore protect artifact-class distinctions more aggressively during first-pass work than during later mature maintenance.

The purpose of this rule is not to redefine first-pass method.

The purpose is to ensure that, once an author has determined which first-pass artifact family is justified, the PKB does not collapse those artifact families back into one another through weak local authoring.

##### 17.1 Local Rule - Do Not Use a Behavioral Specification Page as a Surrogate Container

A behavioral specification page must not be used as a surrogate container for:

- unresolved meaning that materially belongs in an open-questions or maturation surface
- rationale that materially belongs in a decision or rationale surface
- current-state reconstruction that materially belongs in current-state behavior capture
- approximation that materially belongs in a governed approximation surface
- traceability continuity that materially belongs in a traceability note

A specification page may reference those surfaces.

It must not absorb them merely because the local subtree would otherwise feel sparse.

##### 17.2 Local Rule - Unresolved Meaning Must Be Externalized When It Materially Affects Interpretation

If unresolved meaning materially affects:

- the event boundary
- the interpretation of the behavior
- whether a draft contract is even validly knowable
- later refinement continuity

then that unresolved meaning must be preserved explicitly in a governed support surface rather than left as hidden residue in implementation notes, page prose, or reviewer memory.

This is a local craftsmanship consequence of authority honesty.

##### 17.3 Local Rule - Current-State and Target-State Surfaces Must Remain Distinct

If a local area contains both:

- preserved current-state meaning
- intended or approximated target-state meaning

then those surfaces must remain materially distinct.

A single page must not silently mix them merely because the author believes the reader can keep them mentally separated.

##### 17.4 Local Rule - Template Usage Does Not Determine Artifact Choice

Using a valid capability-page template or specification-page template does not by itself justify that the chosen page type is the correct artifact family.

Template correctness is downstream of artifact-family correctness.

A beautifully templated misclassified page remains a local craftsmanship defect.

##### 17.5 Local Rule - Capability-Local Support Pages Are First-Class Surfaces When Needed

Capability-local support pages are not second-class artifacts.

If a capability-local traceability note, governed approximation, decision surface, or maturation page is needed to preserve meaning honestly, it should be authored as a first-class page rather than compressed into adjacent artifacts.

##### 17.6 First-Pass Local Anti-Patterns

Add the following to local PKBDD anti-pattern handling.

###### Anti-Pattern - Draft Spec Inflation

Creating draft behavioral specification pages for most or all capability areas merely to make the tree look mature.

###### Anti-Pattern - Support Surface Burial

Burying important unresolved meaning, rationale, approximation, or traceability continuity inside specification pages, capability pages, or implementation notes.

###### Anti-Pattern - Current/Target Collapse

Mixing current-state reconstruction and target-state direction in one page without clear boundary.

###### Anti-Pattern - Additional-Aspect Collapse into Core Behavior

Forcing every stakeholder concern, constraint lens, or supplementary aspect into one core behavioral specification until the page becomes difficult to review, difficult to scope, or difficult to validate with the relevant stakeholders.

This is structural overload.

When a distinct governed concern applies to the same core behavior but should be reviewed, evolved, or owned through a different lens, it should be preserved through an Additional Aspect artifact rather than collapsed into the core behavioral page.

###### Anti-Pattern - Additional-Aspect Fragmentation

Splitting concern handling into many extremely small Additional Aspect artifacts whose separation does not meaningfully improve reviewability, stakeholder-specific review, or governed preservation.

This is fragmentation rather than useful separation.

Additional Aspect artifacts should exist to preserve materially distinct concern lenses, not to maximize decomposition for its own sake.

When aspect separation makes the specification set harder for humans to review without providing corresponding governance value, the separation has gone too far.

###### Anti-Pattern - Template-Driven Misclassification

Choosing the page type because a template exists, rather than because the artifact class is correct.

##### 17.7 Local Review Questions for First-Pass PKB Craftsmanship

When reviewing a first-pass PKB locally, ask:

- is each page the correct artifact class, or merely a plausible one?
- has unresolved meaning been externalized where needed?
- has current-state meaning been kept distinct from target-state meaning?
- are traceability and rationale preserved explicitly where they materially affect later refinement?
- has any draft specification been created where a weaker but more honest surface was the correct choice?
- has the core behavioral specification remained bounded and reviewable, or have distinct concern lenses been overloaded into it?
- where a distinct stakeholder or concern lens materially applies to the same core behavior, has that concern been preserved through an appropriate Additional Aspect artifact rather than hidden in commentary or implementation?
- have Additional Aspect artifacts been created only where they materially improve governed concern preservation or human review, rather than splitting the specification set into low-value fragments?

If these questions cannot be answered confidently, the local craftsmanship work is not yet adequate.

---

#### 18. Final Invariant

If PKBDD craftsmanship is weak:

- artifact roles collapse
- section meanings drift
- support surfaces gain hidden authority
- templates become misleading rather than stabilizing
- lifecycle readiness becomes noisier and less trustworthy
- downstream implementation and review inherit avoidable ambiguity

When that happens, doctrinal drift begins before lifecycle or engineering failures become obvious.

PKBDD craftsmanship therefore exists to preserve local authoring integrity before larger system failures appear.

---
