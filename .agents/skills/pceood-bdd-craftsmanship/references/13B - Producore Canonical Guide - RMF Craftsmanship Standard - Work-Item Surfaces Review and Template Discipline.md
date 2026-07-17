### Producore Canonical Guide - RMF Craftsmanship Standard - Part 2 of 2

> **13B - Work-Item Surfaces, Review, Template Discipline, and Boundary Alignment**  
> Covers readiness work-item surfaces, review discipline, RMF anti-patterns, doctrine-safe starter-template use, neighboring-doctrine relationships, and the final assertion.

#### 6. Readiness Work-Item Surfaces and First-Choice Conventions

##### 6.1 Readiness Work-Item Surfaces Exist to Make Preparatory Work Visible

Readiness-oriented work items exist so that preparatory work can be:

- visible
- schedulable
- inspectable
- capacity-bearing
- reviewable

Their purpose is not to create paperwork.

Their purpose is to prevent preparatory work from being hidden inside implementation work.

##### 6.2 First-Choice Convention: Make Readiness Work Explicit Rather Than Implicit

Where meaningful preparatory work must be done, the first-choice convention is to represent it explicitly rather than leaving it implied inside an implementation item.

This may include:

- readiness PBIs
- analysis PBIs
- shared readiness work items
- explicit readiness check surfaces in implementation items where appropriate

This is a first-choice craftsmanship convention, not a claim that one board model is universally mandatory.

##### 6.3 First-Choice Convention: Separate Readiness Conditions from Execution History

Readiness criteria should be readable as gate conditions.

Execution history, commentary, evolving discussion, and incidental coordination should not be mixed into the same surface in a way that makes readiness harder to inspect.

A support artifact that mixes the gate with a noisy activity log becomes harder to review honestly.

##### 6.4 First-Choice Convention: Make Responsibility Boundaries Readable

Where local work-item surfaces distinguish Product exit, Engineering entrance, Engineering exit, Product entrance, or similar responsibility boundaries, those boundaries should remain readable and explicit rather than collapsed into one undifferentiated checklist.

The point is not ceremony.

The point is to preserve inspectable transitions of responsibility where the local operating model uses them.

##### 6.5 First-Choice Convention: Preserve the Difference Between “Ready for Sprint” and “Ready for Implementation”

Local work-item surfaces should preserve the difference between:

- scheduling preparatory work
- committing implementation work

That distinction should not be blurred by using one readiness label to cover both.

##### Rationale

Local conventions exist because support artifacts are not read only by their authors.

They are inspected by people making real planning and commitment decisions.

Readable surfaces reduce hidden work, confusion, and false confidence.

---

#### 7. Review Discipline for RMF Support Artifacts

##### 7.1 Review Exists to Detect Craftsmanship Drift Before Gate Decisions Are Made

Local review of RMF support artifacts exists to detect craftsmanship defects before those defects distort readiness or completion decisions.

This review is not a substitute for RMF operating doctrine.

It is a support mechanism for applying that doctrine honestly.

##### 7.2 Review Questions for Definitions of Ready

A Definition of Ready should be reviewed for questions such as:

- Are the criteria bespoke to the item rather than copied mechanically?
- Does each criterion represent a real readiness condition?
- Are the criteria concrete enough to inspect honestly?
- Does the artifact rely on vague confidence language?
- Has missing requirement meaning been smuggled into the DoR?
- Is the relationship to the bespoke Definition of Done explicit where needed?
- Are dependencies and prerequisite conditions represented honestly?
- Does the artifact preserve the distinction between preparatory work and implementation commitment?

##### 7.3 Review Questions for Definitions of Done

A Definition of Done should be reviewed for questions such as:

- Are the criteria bespoke to the item rather than copied mechanically?
- Does each criterion represent a real completion condition?
- Are the criteria concrete enough to verify honestly?
- Has verification been collapsed into sentiment or ceremony?
- Has missing requirement meaning been smuggled into the DoD?
- Is the relationship to the governing specification surfaces clear?
- Does the artifact preserve completion gating rather than functioning as a generic team slogan?

##### 7.4 Review Questions for Readiness Work-Item Surfaces

Readiness-oriented work items should be reviewed for questions such as:

- Is the preparatory work actually visible?
- Is the work represented honestly as readiness work rather than disguised implementation?
- Is blocked readiness discoverable from the artifact?
- Are the local responsibility boundaries readable where relevant?
- Does the artifact preserve inspectability of readiness rather than collapsing it into noise?
- Has the work-item surface started absorbing requirement meaning that belongs in the PKB?

##### Rationale

RMF support artifacts fail most often not because they are absent, but because they look structured while quietly failing to carry the right kind of meaning.

Review discipline is the craftsmanship defense against that false confidence.

---

#### 8. RMF Local Anti-Patterns

The following are craftsmanship failures.

##### 8.1 Template Copy Treated as Readiness Thinking

A generic starter template is copied with minimal adaptation and treated as though the work is now governed.

This is not craftsmanship.

It is ceremonial reuse.

##### 8.2 Generic Criteria Used as a Substitute for Bespoke Criteria

A Definition of Ready or Definition of Done is filled with generic criteria that do not meaningfully reflect the item.

This creates the appearance of governance without item-specific rigor.

##### 8.3 Hidden Requirement Meaning in DoR or DoD

Business rules, behavioral decisions, or requirement meaning are inserted into readiness or done artifacts because the authoritative specification surface is incomplete.

This is an upstream defect disguised as local thoroughness.

##### 8.4 Sentiment Used as Gate Evidence

Criteria are written or reviewed in a way that reduces readiness or completion to confidence, comfort, or perceived sufficiency.

That undermines inspectability.

##### 8.5 Preparatory Work Hidden Inside Implementation

Work needed to become ready is concealed inside implementation work instead of being made visible through readiness-oriented surfaces.

This undermines transparency and distorts commitments.

##### 8.6 Responsibility Boundaries Collapsed into Noise

Product/Engineering boundary transitions or similar handoff distinctions are collapsed into unreadable mixed lists, reducing inspectability of who is attesting to what.

##### 8.7 Support Artifacts Treated as Doctrine

Templates, board-item conventions, or locally convenient checklists are treated as though they define RMF itself.

They do not.

They are governed support surfaces only.

##### 8.8 Platform Mechanics Elevated into Craftsmanship Doctrine

Tool-specific formatting tricks, field hacks, or host-platform workarounds are treated as though they were doctrinal craftsmanship rules.

They are not.

##### Rationale

Anti-patterns matter because RMF support artifacts often fail while still looking superficially disciplined.

A weak support artifact can appear highly structured and still quietly destroy honest readiness or completion review.

---

#### 9. Doctrine-Safe Use of RMF Starter Templates

##### 9.1 Starter Templates Are Support Assets

RMF starter templates may be useful because they:

- accelerate local setup
- expose common readiness and completion categories
- provide a reviewable starting structure
- help teams avoid forgetting recurring concerns

They are support assets.

They are not doctrine by themselves.

##### 9.2 What Starter Templates Are Good For

Starter templates are useful for:

- reminding teams of recurring categories of concern
- making blank support surfaces less likely
- accelerating local adaptation
- helping teams learn the shape of readiness and completion surfaces

##### 9.3 What Starter Templates Must Not Be Used For

Starter templates must not be used as though they:

- automatically make a work item ready
- automatically make a completion contract valid
- substitute for bespoke local thinking
- settle doctrinal ownership questions
- override the need for review

##### 9.4 Local Adaptation Is Required

A template-derived artifact must be adapted to the actual item, actual readiness conditions, actual completion conditions, and actual supporting specification surfaces.

If that adaptation does not happen, the artifact is locally weak even if it looks complete.

##### 9.5 Tool-Specific Mechanics Are Out of Scope

If a host platform requires formatting workarounds, field constraints, or local mechanics, those may be handled in tool guidance or template notes.

They are not part of this doctrine.

##### Rationale

Templates are powerful because they reduce startup friction.

They are dangerous for the same reason.

Without explicit governance, teams start confusing "template used" with "thinking completed."

---

#### 10. Relationship to Neighboring Doctrine Layers

##### 10.1 Relationship to RMF Operating Doctrine

RMF Operating Doctrine defines:

- what readiness means
- what completion means
- what RMF 1, RMF 2, and RMF 3 are
- why preparatory work must be visible
- why timeboxing may be required
- when implementation may begin
- when implementation may be accepted as complete

This guide does not redefine any of that.

This guide governs only the local craftsmanship of the artifacts through which teams support and apply those operating decisions.

##### 10.2 Relationship to PKBDD Operating Doctrine

PKBDD Operating Doctrine governs authoritative specification surfaces, lifecycle, and binding status.

This guide does not alter that.

It only governs the local craftsmanship of RMF support artifacts that may reference those authoritative surfaces.

##### 10.3 Relationship to PKBDD Craftsmanship Standard

PKBDD Craftsmanship Standard governs PKB-local artifact authoring.

This guide does not govern PKB page craft.

Where RMF support artifacts reference or point to PKB artifacts, PKB artifact craft remains governed by the PKBDD Craftsmanship Standard.

##### 10.4 Relationship to BDD Craftsmanship Standard

BDD Craftsmanship Standard governs scenario-form specification.

This guide does not govern scenario construction or scenario expression.

Where readiness or completion criteria refer to scenarios or specifications, those scenario-form concerns remain governed elsewhere.

##### 10.5 Relationship to Engineering Doctrine

Engineering Doctrine governs realization downstream of the authoritative and matured requirement surfaces.

This guide does not govern implementation technique, testing design, architecture, refactoring, or release practice.

---

### 11. Final Assertion

A local RMF support artifact is craftsmanship-valid only if it:

- supports RMF operating doctrine without attempting to redefine it
- remains a support surface rather than a hidden authority surface
- expresses bespoke readiness or completion criteria honestly
- makes preparatory work visible where needed
- preserves inspectability and reviewability
- does not smuggle requirement meaning into the wrong layer
- does not reduce readiness or completion to ceremony, sentiment, or template reuse

If these conditions are violated, RMF support artifacts may still appear structured, but they no longer support honest RMF operation.
