
## Producore Canonical Guide - ADO Repo Wiki PKB Production Standard

### Status

Draft for adoption as the delegated craftsmanship standard for producing doctrine-safe PKBs as Azure DevOps Repo Wiki artifacts.

This guide governs ADO Repo Wiki PKB production only.

It is authoritative only within that delegated boundary.

It does not define ontology, authority, lifecycle, capability ownership, behavioral ownership, RMF operating law, RMF craftsmanship, or engineering realization.

---

### 1. Purpose and Scope

This guide defines Producore's local standard for materially producing a PKB as an Azure DevOps Repo Wiki repository without collapsing doctrine-visible distinctions in the host-platform tree.

This guide exists because:

- PKBDD Operating Doctrine governs authority and lifecycle
- Capability and Behavior guides govern meaning
- structural derivation guides govern behavioral ownership and placement
- PKBDD Craftsmanship governs PKB artifact authoring, page-type boundaries, section semantics, template usage, and PKB-local review
- none of those, by themselves, fully govern Azure DevOps Repo Wiki production form

The result is a real delegated gap:

teams still need doctrine-safe rules for how valid PKB artifacts are materialized as an ADO Repo Wiki tree so that:

- artifact classes remain legible in navigation
- local ordering is stable
- topology does not silently distort meaning
- support artifacts do not masquerade as contract artifacts
- AI and human readers can navigate the live repo-native wiki without tribal knowledge

This guide governs:

- Azure DevOps Repo Wiki topology rules for PKBs
- repo-native page/folder adjacency rules
- `.order` usage for PKB navigation
- ADO Repo Wiki naming rules for PKB pages and folders
- host-platform materialization patterns for PKB artifact families
- local linking and navigation conventions for ADO Repo Wiki PKBs
- ADO-specific anti-patterns
- review criteria for whether a repo-native ADO Wiki PKB is materially well produced

This guide does not govern:

- what a Capability is
- what Behavior is
- what makes a specification binding
- lifecycle states or legal lifecycle transitions
- behavioral ownership or structural exclusivity
- RMF operating law
- RMF craftsmanship
- engineering realization practice
- non-ADO host-platform profiles

---

### 2. Authority, Precedence, and Canonical Boundary

#### 2.1 Delegated Authority

Authority is delegated to this guide only for ADO Repo Wiki PKB production form.

That delegated authority covers:

- platform-local topology rules
- platform-local naming rules
- platform-local adjacency rules
- platform-local ordering mechanics
- platform-local artifact materialization patterns
- platform-local anti-patterns
- platform-local review criteria

This guide has no authority to define ontology, confer binding status, alter lifecycle semantics, reinterpret upstream artifact classes, or reassign structural ownership of Behavior.

#### 2.2 Precedence

If any statement in this guide conflicts with a higher authority, the higher authority governs.

Precedence order:

1. Producore Canonical Definition Guide - Capability System
2. Producore Canonical Definition Guide - Behavior System
3. Producore Canonical Guide - PKBDD Operating Doctrine
4. Producore Canonical Guide - Capability Structuring and Authority Doctrine
5. Producore Canonical Guide - Capability Structure Design Framework
6. Producore Canonical Guide - RMF Operating Doctrine
7. Producore Canonical Guide - BDD Craftsmanship Standard
8. Producore Canonical Guide - PKBDD Craftsmanship Standard
9. Producore Canonical Guide - RMF Craftsmanship Standard
10. Producore Engineering Doctrine
11. This guide

This guide may refine only delegated local platform-production practice.

It may not reinterpret upstream definitions or redistribute doctrinal ownership.

#### 2.3 Scope Boundary

This guide must not redefine:

- Capability
- Behavior
- correctness
- binding authority
- lifecycle authority
- behavioral ownership
- structural promotion logic
- PKB ontology
- RMF operating law
- engineering realization rules

It only defines how valid PKB artifacts are materially produced as an Azure DevOps Repo Wiki.

#### 2.4 Canonical Alignment

All production rules under this guide operate within the canonical chain already defined elsewhere.

For local host-platform production purposes:

- Capability pages remain orienting artifacts, not behavior contracts
- behavior specification pages remain contract artifacts, not generic notes
- support artifacts remain support artifacts
- visual design artifacts remain visual design artifacts
- templates remain authoring aids
- current-state capture remains descriptive unless separately governed
- host-platform cleanliness does not confer authority

If that chain is violated, the problem is doctrinal or structural, not merely production-related, and must be corrected in the appropriate higher document.

#### 2.5 Binding Boundary

Whether a PKB specification is authoritative is governed exclusively by the PKBDD Operating Doctrine.

Whether readiness or completion gating is valid is governed exclusively by RMF Operating Doctrine.

Whether readiness-oriented support artifacts are locally well authored is governed separately by RMF Craftsmanship.

Whether a page is visually well produced in ADO Repo Wiki does not make it authoritative.

Therefore:

- a beautifully produced Draft page is still Draft
- a badly named page may still contain important continuity, but it is locally defective
- a clean page tree may still be invalid if artifact classes are collapsed
- host-platform production quality supports doctrine-safe use; it does not replace authority

---

### 3. Core Principle

A doctrine-safe PKB must be materially produced in Azure DevOps Repo Wiki form such that artifact distinctions, ownership boundaries, navigation meaning, and maturity signals remain visible, stable, and non-misleading in the actual repo-native tree used by humans and AI.

---

### 4. Host-Platform Production Model

The ADO Repo Wiki production model must preserve the distinction among:

- PKB meaning
- PKB artifact semantics
- host-platform materialization form

Those are related, but not identical.

PKB meaning is governed upstream.

PKB artifact semantics are governed by PKBDD Craftsmanship and other owning standards.

This guide governs how those valid artifacts are materialized as:

- pages
- folders
- sibling page/folder pairs
- local ordering files
- local names
- local links
- visible navigation surfaces

The same doctrine-safe PKB could theoretically be materialized in another host platform later.

That possibility does not weaken the need for a governed ADO-specific production profile now.

---

### 5. Required Production Outcomes

A well-produced ADO Repo Wiki PKB must be:

- navigable without tribal knowledge
- structurally legible from page names and placement
- explicit about artifact class
- stable under ordinary maintenance
- safe for both human and AI reading
- resistant to authority leakage through naming, placement, or mixed-content pages

The material production of the wiki must ensure that:

- capability ownership remains visible
- support surfaces do not visually masquerade as behavioral contracts
- current-state capture, governed approximations, traceability notes, and open questions remain visibly distinguishable
- page identity is not overloaded with accidental document residue
- ordering is separated from naming
- the tree reads like a maintained PKB rather than an export dump

---

### 6. Repo-Native ADO Wiki Topology Rules

#### 6.1 Root Shape

An ADO Repo Wiki PKB must have a coherent root shape.

At minimum, root production should provide:

- `Home.md` as the entry page
- a root `.order` file when root child order matters
- real root-level pages for governance and orienting surfaces
- real root-level folders only where corresponding parent pages or grouped support zones justify them

#### 6.2 Parent-Page and Child-Folder Rule

When a page has child pages in Azure DevOps Repo Wiki form:

- the parent page is a real `.md` file
- the child container is a same-named sibling folder
- that sibling folder contains the child pages
- this file-plus-folder adjacency is treated as normal platform structure, not duplicate content

This pattern must be used intentionally and consistently.

#### 6.3 Child Containers Are Structural, Not Generic Buckets

Same-named child folders exist to hold the children of their parent page.

They must not become generic dumping grounds.

A child folder should contain:

- real child artifacts of the parent surface
- a local `.order` file where ordering matters
- only the surfaces that genuinely belong under that parent

#### 6.4 Local `.order` Files

`.order` files are the authoritative local ordering mechanism for ADO Repo Wiki production.

They exist to control child ordering without embedding ordering into names.

`.order` usage is local, structural, and navigational.

It must not be repurposed as:

- a hidden whitelist of valid pages
- a metadata system
- a lifecycle signal
- a substitute for meaningful names

#### 6.5 Depth Discipline

Hierarchy depth must remain shallow enough that the tree is locally understandable.

If a subtree becomes difficult to navigate because of depth alone, the problem should be treated as a structural production problem and reconsidered.

Depth is justified by real ownership or real artifact family boundaries, not by aesthetic symmetry.

---

### 7. Navigation and Ordering Rules

#### 7.1 Ordering Belongs in `.order`, Not in Names

Do not use numeric prefixes merely to force local order when `.order` is available.

Page names should carry meaning.

Ordering should be handled through `.order`.

#### 7.2 Names Must Remain Stable Under Reordering

A page must not need to be renamed merely because its local order changes.

If ordering changes force renaming, the production form is defective.

#### 7.3 Curated Parent Navigation

Parent pages should normally provide curated explicit child listings rather than relying on `[[_TOSP_]]`.

Use curated child listings by default because they:

- make artifact classes visible
- allow selective emphasis
- reduce generic tree noise
- better preserve meaning in first-pass and mixed-maturity PKBs

Use `[[_TOSP_]]` only when there is a specific reason to do so.

#### 7.4 Navigation Must Preserve Artifact-Class Legibility

A reader should be able to infer from navigation whether a child page is:

- a capability page
- a draft behavioral specification
- a current-state behavior capture
- a governed approximation
- a traceability note
- an open-questions surface
- a support artifact

If the navigation obscures that distinction, the production is defective even if the underlying pages are locally well written.

---

### 8. Naming Rules

#### 8.1 General Naming Rule

Page and folder names must be human-readable, artifact-legible, and host-platform-native.

They must not look like:

- exported document residue
- implementation file names
- temporary note titles
- pseudo-database keys
- numeric ordering hacks

#### 8.2 Capability Page Names

Capability page names should name the capability, not the page type.

Example pattern:

- `Repository Qualification and File Selection.md`

Not:

- `Capability - Repository Qualification and File Selection.md`

unless a local ambiguity truly requires it.

#### 8.3 Behavior Specification Page Names

Behavior specification page names should visibly encode both artifact class and lifecycle state where local conventions require it.

They should remain clear in ADO navigation.

Example patterns:

- `Draft-Behavior-Specification---Combined-Content-Fidelity.md`
- `Approved-New-Specification.md`
- `Current-Specification.md`

The standard does not require one global filename pattern for all solutions, but the local pattern must be:

- explicit
- consistent
- lifecycle-legible where lifecycle is encoded in naming
- artifact-class legible

#### 8.4 Current-State Capture Names

Current-state capture pages should be visibly descriptive and non-promotional.

Preferred pattern:

- `Current-State-Behavior-Capture.md`

#### 8.5 Governed Approximation Names

Governed approximation pages should signal approximation plainly.

Preferred pattern:

- `Governed-Approximation.md`
- or a more specific approximation title when the local context requires it

#### 8.6 Traceability Names

Traceability support pages should remain clearly support-oriented.

Preferred pattern:

- `Traceability-Notes.md`

#### 8.7 Support Surface Names

Support pages should be named for their support role, not disguised as specs.

Examples:

- `Solution-Intent.md`
- `Decision-and-Rationale-Ledger.md`
- `Open-Questions-and-Maturation.md`
- `Use-Cases-and-Flows.md`

---

### 9. Artifact Materialization Patterns

#### 9.1 Capability Page Pattern

A capability materialized in ADO Repo Wiki form should normally have:

- a real parent capability page
- a same-named child folder when children exist
- child pages that represent real artifact classes or real sub-capabilities
- no generic “miscellaneous” child bucket unless genuinely required and explicitly named for its support role

#### 9.2 Behavioral Specification Pattern

Behavioral specifications should normally live directly under their owning capability surface, not under generic platform-neutral bucket names like `Specifications` unless the local profile deliberately uses such a bucket and keeps artifact classes visible anyway.

The first choice is direct child placement under the owning capability.

#### 9.3 Visual Design Pattern

Visual design pages should be placed near the behavior they support without displacing the behavioral contract pages.

They remain subordinate support surfaces, not sibling authorities to behavior by default.

#### 9.4 Current-State Immaturity Pattern

When a behavior is being truthfully captured from existing implementation and mature target-state authority is not yet justified, the ADO tree should materialize that honestly through explicit artifact types such as:

- `Current-State-Behavior-Capture`
- `Governed Approximation`
- `Traceability Notes`
- `Open Questions and Maturation`

These should be first-class pages, not buried prose inside other artifact types.

#### 9.5 Support-Artifact Pattern

Support artifacts should be materially produced so that they are easy to find but not visually confused with contract surfaces.

Support artifacts belong in clear support zones or clearly support-class child positions.

They should not be embedded inside behavior-spec pages merely because the platform makes that easy.

Where a capability-local support surface is the real local home for unresolved meaning, follow-on maturation pressure, or related support continuity, it should be materially produced as a visible child page of that capability rather than being buried inside specification prose or generic support buckets.

`Open Questions and Maturation` is one valid example of such a capability-local support surface.

---

### 10. Support Artifact Placement Rules

#### 10.1 Root-Level Support Surfaces

The following commonly belong near the root or another clearly visible support zone when they orient the whole PKB:

- Solution Intent
- Governance
- Glossary
- Capability Inventory
- Open Questions and Maturation
- Decision and Rationale surfaces
- lifecycle framing surfaces
- template/reference/admin surfaces

#### 10.2 Capability-Local Support Surfaces

The following may belong under a capability when they support that capability specifically:

- traceability notes
- governed approximations
- capability-local open questions and maturation
- capability-local decisions
- capability-local use cases or flows
- capability-local visual design pages

#### 10.3 RMF Support Surfaces

RMF support surfaces should be placed where they remain visibly support-oriented and do not masquerade as PKB contract pages.

If materialized in the PKB tree at all, they must remain clearly non-authoritative support artifacts.

#### 10.4 Decision and Rationale Placement

Decision and rationale surfaces should be easy to locate and should align with the scope of the decision:

- global decisions in global support zones
- capability-local decisions under the relevant capability support area

Do not mix decision logs into behavior specification pages.

---

### 11. First-Pass PKB Production Rules

#### 11.1 First-Pass Validity

A first-pass ADO Repo Wiki PKB may be immature and still valid.

It is valid when:

- it is structurally coherent
- artifact classes are visible
- capability ownership is emerging clearly
- uncertainty is preserved honestly
- current-state capture is explicit where needed
- fake maturity is avoided

#### 11.2 Minimum Visible Surfaces

A first-pass ADO Repo Wiki PKB should normally make visible at least:

- root orientation/governance surfaces
- capability inventory
- one or more real capability pages
- explicit current-state capture where implemented behavior is being clarified
- explicit governed approximations where needed
- explicit open questions where unresolved meaning remains
- traceability support where code/history evidence is being used

#### 11.3 No Fabricated Maturity

Do not materialize a tree that visually implies clean mature authority when the real state is:

- current-state reconstruction
- unresolved ownership
- partial capability saturation
- incomplete behavioral contract surfaces

#### 11.4 Honest Continuity Preservation

Do not erase continuity merely to make the ADO tree look cleaner.

If messy continuity must be preserved, preserve it as visibly non-final support or current-state material rather than silently deleting it.

#### 11.5 Current-State and Target-State Must Remain Distinct

If current implemented behavior and future intended behavior both matter, they must be materially distinct in the ADO tree.

Do not collapse them into one page merely because one page would look cleaner.

#### 11.6 Benchmark First-Pass ADO Root Production Profile

When an upstream first-pass method has determined that a benchmark first-pass PKB requires visible continuity and support surfaces, the ADO Repo Wiki production form should materialize those surfaces explicitly rather than compressing them into a smaller but semantically weaker tree.

A benchmark first-pass ADO root should normally make it materially obvious where a reader can find, when justified by the PKB's real content:

- root orientation or home surface
- solution intent
- use cases and flows or equivalent continuity surfaces
- support-selection or scope-selection surfaces
- capability inventory or equivalent capability map
- open questions and maturation
- decision and rationale continuity
- capability subtree surfaces

This guide does not define whether those surfaces are required in principle.

It defines that, when they are required by the valid first-pass artifact set, they should be materially produced in a way that keeps them visible and legible in the repo-native ADO tree.

#### 11.7 Benchmark Capability Subtree Production Profile

When an upstream first-pass method has determined that a capability or capability candidate requires child artifacts, the ADO Repo Wiki subtree should materialize those child artifacts in a way that keeps their artifact classes visually distinct.

A benchmark first-pass capability subtree may include, as justified by the real maturity of the local area:

- draft behavioral specifications
- current-state behavior capture
- governed approximations
- traceability notes
- capability-local open questions and maturation
- capability-local decision and rationale surfaces
- capability-local visual design pages
- capability-local use cases or flows where those genuinely belong locally

These child artifacts should remain materially distinguishable in navigation and page naming.

Do not flatten them into a generic child bucket merely because the subtree would look tidier.

#### 11.8 Curated Navigation Requirement for Mixed-Maturity First-Pass PKBs

When a PKB is first-pass and mixed-maturity, parent pages should normally provide curated child listings rather than relying on generic navigation expansion alone.

Curated listings should make artifact classes visible.

They should help the reader distinguish, at a glance, between:

- capability pages
- behavioral contract surfaces
- current-state capture
- governed approximations
- capability-local open questions and maturation or other clearly support-class pages
- rationale and traceability pages

This requirement exists because mixed-maturity first-pass PKBs are especially vulnerable to visual misreading in repo-native navigation.

#### 11.9 Root and Subtree Naming Expectations for Benchmark First-Pass PKBs

A benchmark first-pass ADO PKB should use names that keep artifact role visible without overloading names with lifecycle, ordering, or authoring residue.

When a page is visibly support-oriented, the name should preserve that support role plainly.

When a page is a current-state or approximation surface, the name should preserve that status plainly.

When a page is a behavioral contract surface, the name should preserve that artifact class plainly.

This file does not require one global naming scheme.

It does require that the local naming scheme allow a reader to distinguish artifact classes without opening every page.

#### 11.10 Normative Production Pattern for Visible Support Zones

Where a benchmark first-pass PKB contains root-level support surfaces, those surfaces should normally be grouped in a way that is both visible and semantically honest.

Preferred production approaches include:

- root-level support pages directly under `Home`
- clearly named root-level support folders with corresponding orienting parent pages
- capability-local support zones only where the support content is truly capability-local

Avoid production patterns that force a reader to infer support topology from generic bucket names.

#### 11.11 First-Pass Tree Compression Anti-Pattern

The following is a local production anti-pattern:

Compressing a benchmark first-pass PKB into a smaller ADO Repo Wiki tree by removing or hiding continuity-preserving support surfaces that materially belong in the PKB.

Examples include:

- removing visible use-case or flow surfaces because capability pages already exist
- hiding support-selection knowledge inside a generic context page
- burying traceability continuity inside draft specification prose
- collapsing current-state and target-state surfaces into one page because a smaller subtree looks cleaner
- relying on generic child expansion when curated artifact-legible navigation is required

This anti-pattern is locally defective even if the resulting tree looks visually neat.

#### 11.12 Material Benchmark for ADO Repo Wiki First-Pass Production

A benchmark first-pass ADO Repo Wiki PKB is materially well produced only if:

- the repo-native tree is navigable without tribal knowledge
- visible support surfaces remain visible rather than compressed into hidden prose
- capability subtrees preserve artifact-class legibility
- mixed-maturity areas are materially distinguishable from mature contract areas
- current-state, approximation, traceability, and open questions and maturation surfaces do not masquerade as behavioral specifications
- parent pages help a reader understand the artifact family beneath them
- the ADO form strengthens, rather than erodes, the upstream first-pass continuity that the PKB is required to preserve

This benchmark remains local to host-platform production quality.

It does not alter upstream authority, validity, or maturity doctrine.

---

### 12. ADO Repo Wiki Production Profile

#### 12.1 ADO Repo Wiki Is the Governing Host Form for This Guide

This guide assumes the PKB is materially produced as an Azure DevOps Repo Wiki backed by Git.

Production choices must therefore respect:

- file-plus-folder parent/child mechanics
- `.order`-based navigation
- repo-native markdown page identity
- Azure DevOps Wiki page path behavior

#### 12.2 Parent/Child Semantics Must Be Legible in Git Form

The Git form is not an implementation nuisance to be hidden.

It is the actual production medium.

Readers and AI systems must be able to interpret:

- parent `.md` page
- same-named sibling child folder
- local `.order`
- child-page file identity

without confusion.

#### 12.3 Local Links Must Be Repo-Wiki-Native

Links should be written in a way that is stable and legible for the ADO Repo Wiki context.

Do not use linking habits that assume a different host platform.

#### 12.4 Images and Referenced Assets

Referenced assets should be stored in a locally understandable way that does not obscure their relationship to the page surfaces they support.

The platform profile does not require one global asset convention here, but the convention used by a PKB must be:

- visible
- consistent
- non-misleading
- easy to maintain in Git form

#### 12.5 Repo-Wiki-Specific Anti-Patterns

ADO Repo Wiki production must avoid:

- fake parent/child structures that violate file-plus-folder adjacency
- naming hacks used to work around `.order`
- generic bucket folders that hide artifact classes
- producing benchmark first-pass support surfaces in ways that visually collapse them into mature contract surfaces

---
