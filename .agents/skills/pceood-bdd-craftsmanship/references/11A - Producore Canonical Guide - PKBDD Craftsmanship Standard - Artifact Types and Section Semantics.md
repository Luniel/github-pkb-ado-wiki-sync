
### Producore Canonical Guide - PKBDD Craftsmanship Standard - Part 1 of 2

> **11A - Artifact Types and Section Semantics**  
> Covers page types, boundaries, template meaning, section semantics.

#### 1. Purpose and Scope

This guide defines Producore's local standard for crafting PKB artifacts so that they can participate safely in PKBDD without collapsing page types, smuggling authority into the wrong surfaces, or allowing local authoring practice to drift into ontology, lifecycle, or realization concerns.

This guide exists because PKBDD governs authority and lifecycle, BDD craftsmanship governs scenario-form behavioral expression, and the structural guides govern capability ownership and placement. None of those, by themselves, fully govern the local craft of authoring PKB pages as pages. The result is a real delegated gap: teams still need doctrine-safe rules for how PKB artifact types are used, how PKB templates are interpreted, what named sections on specification pages mean, how draft scaffolding is handled, and how PKB-local review discipline detects drift before lifecycle problems appear.

This guide governs:

- PKB artifact authoring discipline
- PKB page-type boundaries
- PKB template usage discipline
- section-level semantics for PKB specification pages
- PKB-local review and readiness discipline
- PKBDD anti-patterns
- first-choice PKB authoring and structural conventions

This guide does not govern:

- what a Capability is
- what Behavior is
- what makes a specification binding
- lifecycle state definitions or legal transitions
- structural derivation of behavioral ownership
- engineering realization practice
- host-platform topology choices such as repo-native vs mirrored wiki operating models

This guide governs PKB craftsmanship only. It does not decide whether a specification is authoritative. It helps ensure that PKB artifacts are authored in a way that allows authority, lifecycle, and downstream realization to operate safely.

PKBDD Craftsmanship governs PKB artifact semantics and PKB-local authoring discipline.

Azure DevOps Repo Wiki materialization, topology, ordering, naming, and navigation form are governed separately by `15 - Producore Canonical Guide - ADO Repo Wiki PKB Production Standard.md`.

A critical local distinction follows from this.

PKB artifacts are persistent requirement and knowledge surfaces. Work items, boards, sprint artifacts, and similar execution-planning surfaces are transient coordination artifacts.

The rule that persisted PKB specifications are authoritative, and that transient work-item surfaces are not, is owned by the PKBDD Operating Doctrine. This guide does not restate that rule as an authority doctrine of its own. It states the local craftsmanship consequence of that upstream rule: PKB craftsmanship must protect against requirement meaning leaking into transient work artifacts. Work items may reference PKB artifacts, coordinate implementation, and preserve execution history. They must not become the hidden place where requirement meaning, authoritative section content, or missing behavioral detail actually lives.

---

#### 2. Authority, Precedence, and Canonical Boundary

##### 2.1 Delegated Authority

Authority is delegated to this guide only for PKBDD-local craftsmanship.

That delegated authority covers:

- PKB artifact-type distinctions
- local interpretation of PKB page templates
- section-level semantics for PKB specification pages
- draft-state and promotion-state authoring discipline
- PKB-local review discipline
- PKB-local anti-patterns
- first-choice authoring and structural conventions that do not redefine higher doctrine

This guide has no authority to define ontology, confer binding status, alter lifecycle semantics, or reassign structural ownership of Behavior.

##### 2.2 Precedence

If any statement in this guide conflicts with a higher authority, the higher authority governs.

Precedence order:

1. Producore Canonical Model Definition
2. Producore Canonical Definition Guide - Capability System
3. Producore Canonical Definition Guide - Behavior System
4. Producore Canonical Guide - PKBDD Operating Doctrine
5. Producore Canonical Guide - Capability Structuring and Authority Doctrine
6. Producore Canonical Guide - Capability Structure Design Framework
7. Producore Canonical Guide - BDD Craftsmanship Standard
8. Producore Canonical Guide - Producore Engineering Doctrine
9. This guide

##### 2.3 Canonical Boundary

This guide must not redefine:

- Capability
- Behavior
- behavior forms
- correctness
- alignment
- binding authority
- lifecycle authority
- structural placement doctrine
- engineering realization practice

It only defines how PKB artifacts are authored locally and safely so that they remain usable within the existing canonical chain.

##### 2.4 Canonical Alignment

All craftsmanship under this guide operates within the canonical chain already defined elsewhere.

For local craftsmanship purposes:

- artifacts that express behavior must remain capability-anchored
- support artifacts must not silently become contract artifacts
- templates must remain authoring aids rather than authority surfaces
- local craft must not be used to compensate for upstream doctrinal ambiguity

If a local PKB authoring problem is actually a problem of ontology, authority, lifecycle, or structural ownership, the correction belongs in the file that owns that concept, not in this guide.

---

#### 3. Core Principle of PKBDD Craftsmanship

A PKB artifact must be authored such that:

- its role is clear
- its authority implications are not misleading
- its relationship to adjacent artifacts is explicit enough to prevent realistic confusion
- its internal sections do not collapse into one another
- its lifecycle participation is structurally supportable

In other words, PKB artifacts must not merely look orderly. They must be authored so that the rest of the doctrine can operate correctly through them.

A page that looks polished but collapses page types, hides behavior in the wrong section, or blurs authoritative and non-authoritative surfaces is not well-crafted. It is structurally dangerous.

---

#### 4. PKB Artifact Family and Page-Type Distinctions

Different PKB artifacts serve different purposes. They are not interchangeable.

A PKBDD craftsmanship standard must therefore begin by making artifact-family distinctions explicit.

##### 4.1 Capability Pages

Capability pages summarize required possibility and enablement purpose.

They explain what must be possible, why the Capability exists, and the responsibility boundary needed to preserve capability identity.

They do not serve as behavioral contract artifacts.

They must not become:

- hidden requirement dumps
- pseudo-specification pages
- implementation notes pages
- anti-scope encyclopedias

A capability page is an orienting artifact. It helps preserve capability identity and local interpretive clarity. It does not replace behavioral specifications.

##### 4.2 Sub-Capability Pages

Sub-capability pages exist only when there is real durable internal structure that must be preserved below the parent capability.

They are not created merely to make a tree look tidy, to mirror implementation structure, or to pre-emptively over-model future distinctions.

A sub-capability page must justify its existence through real internal responsibility structure.

##### 4.3 Behavior Specification Pages

Behavior specification pages are the contract artifacts that express behavior.

They are the PKB pages through which behavior is made explicit for lifecycle governance, implementation, and validation.

They may contain scenario-form specifications and closely related supporting sections defined by template and section semantics.

They must not become:

- analysis notebooks
- decision logs
- generic note collections
- architecture pages
- visual design pages

##### 4.4 Visual Design Specification Pages

Visual design specification pages govern visual design only where behavioral specifications are silent.

They are used for:

- layout
- composition
- styling
- spacing
- visual arrangement
- stable visual-reference surfaces

They must not define:

- behavioral logic
- triggers
- state transitions
- event handling rules
- behavioral constraints that belong in behavior specifications

Visual Design Specification pages may define how a behavioral specification is surfaced through a user interface, including where users trigger events, where relevant values are entered or displayed, and where resulting states or outputs are presented. They must not define the behavioral rules themselves, nor override the meaning, constraints, triggers, or state transitions governed by behavioral specifications.

Examples are:

- how a user triggers an event that is already defined in a behavioral specification
- where the UI gathers or displays values that correspond to Given conditions
- where the UI presents results that correspond to Then outcomes
- how the interface visually supports the use of an already-defined behavior

##### 4.5 Support Artifacts

Support artifacts include notes, decisions, glossary pages, working agreements, journeys, use cases, diagrams, open questions and maturation surfaces, and similar supporting materials.

These artifacts may clarify, orient, support, or preserve rationale, unresolved meaning, continuity, or other non-authoritative working knowledge.

They are not behavioral contract artifacts.

They must not be treated as though they define behavior by themselves.

##### 4.6 Template Pages

Template pages are authoring aids.

They exist to make recurring PKB artifact creation safer, more consistent, and more governable.

They do not, by themselves, create authority.

They do not make a copied page valid or mature merely because the resulting page looks structured.

##### 4.7 Why These Distinctions Matter

When PKB artifact types collapse into one another, several failures appear quickly:

- capability pages start accumulating hidden specifications
- specification pages become containers for unresolved thinking rather than contracts
- support pages quietly gain quasi-authoritative force
- visual design pages redefine behavior by accident
- templates become hidden doctrine instead of governed authoring aids

PKBDD craftsmanship exists to prevent exactly this class of drift.

---

#### 5. Capability-Page Craftsmanship

##### 5.1 Purpose of a Capability Page

A capability page should provide an implementation-independent summary of what must be possible, why that Capability exists, and the responsibility boundary needed to preserve capability identity.

It should help a reader understand the Capability's responsibility boundary without having to infer behavior from code, implementation structure, or unrelated supporting pages.

##### 5.2 What Belongs on a Capability Page

A well-crafted capability page typically includes:

- a concise description of what must be possible and why the Capability exists
- what the capability enables for relevant stakeholders

The page should remain light enough to orient, but strong enough to preserve boundary clarity.

##### 5.3 What Must Not Belong on a Capability Page

A capability page must not be used to:

- encode behavior contracts that belong in behavior specification pages
- smuggle in implementation logic
- accumulate unresolved scenario details
- define lifecycle rules
- define ontology
- define structural ownership rules already governed elsewhere

##### 5.4 Capability-Page Anti-Patterns

The following are craftsmanship failures:

- capability page used as a requirement dump
- capability page used as a behavioral contract surface
- capability page filled with exhaustive exclusion lists
- capability page that derives meaning from implementation or placement rather than capability identity, required possibility
- capability page that contains details better expressed through child specifications or support artifacts

---

#### 6. Behavior-Specification-Page Craftsmanship

##### 6.1 Purpose

A behavior specification page exists to express behavior as a contract artifact under one capability or sub-capability.

It is the page type through which behavior becomes governable in lifecycle terms.

##### 6.2 Ownership

A behavior specification page must live under exactly one capability or sub-capability.

Its ownership must not be ambiguous.

If a specification appears to span multiple capabilities, the structural problem must be corrected before the artifact is treated as ready for lifecycle participation.

##### 6.3 What Belongs on the Page

A behavior specification page may include:

- the specification itself
- true capability dependencies that must be used in implementation
- optional implementation notes within the narrow semantics defined by this guide
- links to additional aspect artifacts where those aspects genuinely supplement the specification
- work-item linkage surface
- visible draft-state to-do capture
- version-delta surface where relevant

##### 6.4 What Must Not Belong on the Page

A behavior specification page must not be used to:

- define capability structure
- store unresolved design residue indefinitely
- act as a general notebook
- smuggle in implementation logic through secondary sections
- use support links as though they were contract substance
- carry ambiguous section meaning

##### 6.5 Draft-State Scaffolding

In `Draft`, template-derived scaffolding may remain visible.

This includes:

- empty or placeholder sections that still mark intended authoring work
- `To Do` items that preserve known incompleteness openly
- structural template remnants that still assist disciplined drafting

Visible scaffolding in `Draft` is not sloppiness. It is controlled incompleteness.

##### 6.6 Promotion-State Cleanup

As a behavior specification approaches `Approved New`, empty and unneeded sections should be removed.

The objective is not to cosmetically hide incompleteness early. The objective is to preserve visible drafting support while drafting, and cleaner, more intentional artifact form as the artifact matures.

##### 6.7 Why This Matters

If scaffolding is removed too early, incompleteness becomes hidden.

If scaffolding remains forever after maturity, noise accumulates and signal weakens.

PKBDD craftsmanship therefore distinguishes between legitimate visible drafting support and mature artifact hygiene.

---

#### 7. Visual-Design-Specification-Page Craftsmanship

##### 7.1 Purpose

A visual design specification page records how something should look, not how it should behave.

This page type exists so that visual design can be preserved, reviewed, versioned, and linked within the PKB without forcing behavior specifications to absorb composition, spacing, layout, or styling material that is not itself behavioral.

##### 7.2 Authoritative Boundary

Visual design is only authoritative for things not specified in the behavioral specifications.

If there is any conflict, the behavioral specification governs.

##### 7.3 What Belongs on the Page

A visual design page may include:

- design references such as Figma links
- visual snapshots
- layout and composition guidance
- styling and spacing guidance
- visual-design-only notes
- version-delta surface

##### 7.4 What Must Not Belong on the Page

A visual design page must not define:

- logic
- triggers
- state transitions
- event rules
- behavioral constraints
- sequence rules masquerading as layout logic

If a statement reads like logic, trigger handling, or stateful behavioral reaction, it belongs in a behavior specification even if a design frame is involved.

##### 7.5 Why This Boundary Matters

Visual-design pages become dangerous when they silently redefine behavior.

That produces split authority between design surfaces and behavioral contract surfaces.

PKBDD craftsmanship must prevent this drift before lifecycle governance is asked to carry it.

---

#### 8. Support-Artifact Boundaries

Support artifacts matter. They often preserve rationale, orientation, planning context, glossary meaning, working agreements, and journey-level understanding.

But support artifacts are not behavioral contract artifacts.

They may:

- support understanding
- support discussion
- preserve rationale
- orient readers to adjacent surfaces
- preserve non-authoritative working knowledge

They must not:

- define behavior
- override specifications
- act as hidden authority surfaces
- become substitutes for missing specification work

Examples of support artifacts include:

- notes
- decision pages
- glossaries
- journeys
- use cases
- working agreements
- diagrams
- narratives

These may be valuable and sometimes indispensable. They remain non-authoritative unless governed elsewhere by explicit doctrine.

Journeys and use cases, in particular, may help identify capabilities, scope broader end-to-end flows, or show how multiple behaviors relate across a user or system journey. They remain orienting and analytical surfaces. They must not silently become the authoritative definition of the behavior itself.

##### 8.1 Open Questions and Maturation Surfaces

An `Open Questions and Maturation` page is a valid capability-local support surface within PKBDD craftsmanship.

Its purpose is to preserve unresolved meaning, blockers, deferred scenario candidates, cross-scenario findings, capability-local TODO items, and related maturation pressure that materially affect later refinement or interpretation.

It is a support artifact.

It is not a behavioral contract artifact.

It must not become:

- a hidden specification page
- a shadow contract surface
- a generic notes dump
- a substitute for proper draft specification work

This surface exists so that unresolved or still-maturing meaning can remain visible without being misrepresented as governed behavioral contract content.

Accordingly:

- unresolved or support-only content preserved on this surface must not be inserted into `Current`
- support-only preservation on this surface does not confer lifecycle authority
- clarified, selected, governable behavioral meaning must move into the appropriate non-`Current` specification surface rather than remaining only on this page
- a behavior specification page may reference this surface, but must not absorb unresolved or support-only content from it merely for local convenience

This surface may preserve continuity honestly.

It must not function as the place where the real contract silently lives.

---

#### 9. Template-Page Craftsmanship

##### 9.1 Role of a Template Page

A template page is an authoring aid that exists to make artifact creation safer, more consistent, and less drift-prone.

It is not a contract artifact.

It is not an authority surface.

It does not make copied content correct merely because the copied artifact inherits structure.

##### 9.2 Instruction Surface and Reusable Template Surface Must Be Separated

A well-crafted template page must clearly separate:

- instructions about how to use the template
- the actual reusable template content

This separation prevents confusion between meta-guidance and instance content.

##### 9.3 Preferred Template Pattern

The first-choice convention is:

- instructions above
- reusable template body wrapped in fenced Markdown code blocks below

This pattern is preferred because it:

- makes copying safer
- reduces accidental template edits
- preserves clarity between instruction and reusable content
- supports practical copying workflows in Azure DevOps Wiki

##### 9.4 Copying a Template Does Not Create Maturity

A newly copied template instance is only a structured draft surface.

It is not automatically:

- valid
- complete
- authority-ready
- promotion-ready

The copied page must still be authored, interpreted correctly, and reviewed against the relevant page-type discipline and section semantics.

##### 9.5 Governing the Included Template Family

The following initial template family is governed by this guide:

1. Capability page template
2. Draft Specification - Behavior template
3. Draft Specification - Visual Design template
4. Open Questions and Maturation template

This guide governs what each template is for, what it must not be used for, and how its sections are to be interpreted.

The templates themselves remain authoring aids.

---

#### 10. Section-Level Semantics

One of the most important responsibilities of PKBDD craftsmanship is to make named sections mean something stable.

If named sections drift into catch-all buckets, local artifact order may remain, but interpretive order collapses.

##### 10.1 `# Specification`

This section contains the actual behavior-specification contract surface.

It must not be diluted by unrelated guidance, implementation notes, or authoring residue embedded into the contract itself.

##### 10.2 `# Dependencies`

This section may list only true capability dependencies that must be used in implementation.

It is not:

- a generic related-links section
- a glossary list
- a rationale list
- a decision-page list
- a reminder bucket

If an item is useful background but not a true capability dependency that must be used in implementation, it does not belong here.

##### 10.3 `# Implementation Notes`

This section is optional and non-authoritative.

It exists only to preserve specific implementation-level notes or choices requested by Engineering.

Implementation notes are aids, not authoritative instructions.

This section must not be used to:

- clarify behavior that should be clarified in the specification
- preserve analysis residue
- dump unresolved scope questions
- define lifecycle semantics
- create a shadow contract

##### 10.4 `# Additional Aspects`

`# Additional Aspects` is for genuine supplementary aspect artifacts that apply a distinct governed lens to the same core behavior without redefining the core behavioral specification itself.

Additional Aspects exist because a single bounded core behavioral event may have multiple meaningful concern lenses, while still requiring one reviewable core behavioral specification.

These aspect artifacts may include, for example:

- visual design
- accessibility
- performance
- security
- privacy
- legal
- finance / tax
- compliance
- auditability
- other stakeholder- or concern-specific aspect surfaces

Use `# Additional Aspects` when:

- the concern applies to the same core behavior
- the concern is real enough to govern or preserve explicitly
- embedding that concern directly into the core behavioral specification would overload the core behavioral surface or make stakeholder review impractical

Do not use `# Additional Aspects` as:

- a generic related-links section
- a place for arbitrary supporting references
- a substitute for missing core behavioral specification
- a place to hide behavioral rules that actually belong in the core behavioral specification

Additional Aspect separation is a craftsmanship judgment, not a mechanical decomposition rule.

Do not create separate Additional Aspect artifacts merely because a distinct concern can be named.

Create a separate Additional Aspect artifact only when that concern is materially real, worth preserving or governing explicitly, and separate enough that doing so improves reviewability, stakeholder-specific review, or controlled evolution.

If the concern is small enough that preserving it inside the core behavioral specification keeps the page clearer and more reviewable, it may remain there.

The goal is to avoid both:

- overloading the core behavioral specification with too many distinct concern lenses
- fragmenting concern handling into unnecessarily tiny or low-value aspect artifacts

An Additional Aspect does not replace the core behavioral specification.

It supplements that core behavior through a distinct concern lens.

The core behavioral specification remains the primary behavioral contract for the bounded event under analysis.

##### 10.5 `# Changes Since`

This section belongs only where version-delta visibility matters.

It should summarize meaningful change relative to a previous governed artifact.

It should not become a full historical narrative.

##### 10.6 `# Work Items`

This section is the work-linkage surface.

It supports traceability and work coordination.

It is not a substitute for behavior or rationale.

Linked work items remain transient execution and coordination artifacts. They may track implementation, review, scheduling, acceptance, or change work around the PKB artifact. They must not become the place where requirement meaning actually lives.

This means:

- do not move authoritative requirement detail into a linked work item
- do not rely on a work item comment, field, or description to complete a PKB artifact's meaning
- do not assume that because a work item is linked, the PKB page may remain locally under-specified

If the linked work items disappeared, the PKB artifact should still stand as the requirement surface it claims to be.

##### 10.7 `# To Do`

In `Draft`, `To Do` is a legitimate craftsmanship surface.

It is not clutter merely because it is incomplete.

It records known incompleteness openly and preserves discipline by preventing open questions from disappearing into memory or conversation.

As artifacts mature, the `To Do` surface should shrink or disappear as appropriate.

##### 10.8 Why Section Semantics Matter

Stable section meaning allows readers, reviewers, editors, engineers, and AI systems to know where to look, what each section does, and what each section must not silently become.

Without section semantics, even well-written pages gradually degrade into mixed-purpose surfaces.

---
