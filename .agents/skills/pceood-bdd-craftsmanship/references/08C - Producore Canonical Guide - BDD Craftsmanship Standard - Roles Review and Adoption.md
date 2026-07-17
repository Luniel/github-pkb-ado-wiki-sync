
### Producore Canonical Guide - BDD Craftsmanship Standard - Part 3 of 3

> **08C - Roles Review and Adoption**
> Covers shared contract responsibility, To Do capture, anti-patterns, boundary rules, checklisting, onboarding, and craftsmanship health signals.

#### 21. Shared Contract Across Roles

A behavioral specification is a shared contract surface across roles.

It is not a private artifact owned only by:

- product
- QA
- developers
- automation engineers

It must be usable by all of them without the meaning changing.

This means no role is allowed to silently reinterpret the scenario into a different requirement surface.

##### Behavioral Specification Authorship Responsibility

This guide does not redefine canonical roles.

Canonical doctrine determines which roles hold primary upstream responsibility for capability-scoped Specified Behavior.

This guide defines the craftsmanship obligation that applies to whoever is acting as the **requirements author** or **behavioral specification author** for a specification that will be presented downstream for implementation and validation.

Whomever is authoring such a behavioral specification must:

- master the craftsmanship rules in this guide
- master the analysis techniques in this guide
- lead efforts to apply those analysis techniques before downstream handoff
- justify and defend the use of those analysis techniques when structural problems, ambiguity, missing scope, or coarse granularity are present
- endeavor to present already-well-formed, already-well-structured, already-analyzed specifications to Engineering
- preserve capability anchoring and avoid shifting behavior-definition burden downstream into implementation or testing

Where canonical doctrine places primary responsibility for capability-scoped Specified Behavior upstream of Engineering, the person acting under that responsibility must embody this authorship discipline.

This is not optional stewardship. It is part of the craft.

##### Product and Upstream Authoring Responsibility

Product or domain authors are responsible for:

- drafting behavior in business language
- surfacing stakeholder intent
- resolving ambiguity with the relevant stakeholders
- keeping the behavioral requirement aligned with the product's actual needs

When those authors are also the acting behavioral specification authors for capability-scoped behavior, they are additionally responsible for:

- applying the analysis techniques directly, not merely expecting Engineering or QA to do so later
- structuring scenarios so that they are already as adequate, explicit, and implementation-ready as the current understanding allows
- making the specification strong enough that Engineering does not need to manufacture missing behavior through assumption

##### Engineering and QA Responsibility

Engineering and QA reviewers are responsible for:

- enforcing structural craftsmanship rules
- applying analysis techniques in review, refinement, validation, and lower-level specification work
- challenging ambiguity, missing scope, and coarse granularity
- ensuring automation does not corrupt the specification surface
- refusing to silently compensate for upstream authorship weakness by inventing missing behavioral meaning in code, tests, or automation bindings

Engineering and QA are therefore required practitioners of this craft.

However, their responsibility here is not a substitute for upstream authorship discipline.

They must be able to detect, challenge, and help refine weak specifications, but they must not become the silent primary definers of behavior merely because an upstream specification was under-analyzed.

##### Product Ownership as Stewardship

Product ownership is the steward of the requirements as living product knowledge.

##### Rationale

If each role keeps a different mental model of the same scenario, then the scenario is not functioning as a contract.

It is just a loose prompt.

That is not acceptable in Producore BDD craftsmanship.

Producore's upstream/downstream chain matters here.

Behavior must be clarified before implementation, not manufactured during implementation.

If the author of a behavioral specification does not master and apply the analysis discipline needed to make that behavior explicit, downstream Engineering and QA will be pressured to fill the gaps.

When that happens, implementation, tests, or automation bindings begin functioning as hidden requirement authors.

That is structurally wrong.

So this guide must make two things explicit at the same time:

- upstream authorship of behavioral specification carries a primary craftsmanship burden
- downstream Engineering and QA must still understand and apply the same craft rigorously

This preserves separation of concerns without weakening shared responsibility for specification quality.

---

#### 22. To Do Capture as Craftsmanship Discipline

Questions and related scenarios discovered during analysis must be captured explicitly rather than silently forgotten or improvised in implementation.

This is not a minor note-taking preference. It is part of scenario craftsmanship.

A second rule follows from this.

The current scenario under analysis must be corrected as needed to make that scenario itself structurally valid, adequate, and ready at its intended scope.

Findings that do not belong inside the corrected current scenario must be externalized explicitly as follow-up concerns.

They must not remain as:

- unresolved residue inside the specification
- hidden assumptions the reader is expected to supply
- missing behavioral meaning to be improvised during implementation or testing
- informal side knowledge carried only in conversation or memory

This guide does not prescribe the host-system mechanics by which such follow-up concerns are stored or governed.

It does govern the craftsmanship rule that analysis outputs must either:

- be incorporated into the corrected current scenario where they belong
- or be externalized explicitly outside that scenario for later deliberate processing

##### What Gets Captured

Capture:

- unanswered questions
- follow-on scenarios
- alternate scenarios
- future concerns
- stakeholder questions to resolve
- scope candidates
- concerns that are out of scope for the current scenario but still matter

##### Preferred Capability-Local Capture Surface

When a follow-on concern is capability-local and does not belong in the corrected current scenario or in a more appropriate non-`Current` specification surface, the preferred local home is the capability-local `Open Questions and Maturation` surface.

This identifies the preferred capability-local capture surface for such follow-on concerns.

This does not redefine PKBDD artifact semantics, lifecycle authority, or host-platform production mechanics.

It also does not mean that every follow-on concern must always be captured there regardless of a better-fit destination.

##### Boundary on Later Maturation

Externalized follow-on capture is not a substitute for specification maturation.

If a concern later becomes clarified, selected, and governable behavioral meaning, that meaning belongs in the appropriate non-`Current` specification surface rather than remaining indefinitely in support capture.

##### Why This Matters

During scenario crafting, many legitimate concerns arise that do not belong inside the scenario currently being written.

If they are argued inside the current scenario prematurely, the scenario loses focus and the analysis effort is derailed.

If they are ignored, they are often forgotten.

If they are neither incorporated into the current scenario nor captured explicitly for follow-up, they remain unresolved meaning that later readers, implementers, or testers may feel forced to infer, supply, or improvise.

Capturing the follow-up concern preserves the current scenario's integrity without allowing the unresolved concern to disappear, derail the current task, or be silently carried elsewhere.

##### Rationale

A To Do list or equivalent follow-up capture surface is not casual note-taking. It is part of the analysis discipline.

Its purpose is to let the team acknowledge a valid concern, preserve it explicitly, and continue the current analysis without collapsing into rabbit holes, premature argument, or loss of participation.

Capturing is not the same as committing to implement everything now.

It is a commitment that the concern will remain explicitly preserved for later deliberate review rather than being lost, improvised, or allowed to distort the current specification effort.

---

#### 23. Local Anti-Patterns

The following are craftsmanship failures:

- specification written as a test script
- behavior reduced to output only
- examples used as a substitute for explicit behavior
- Scenario Template rows with row-specific Then mutations
- Background used to hide variability
- UI choreography in When where the choreography is not the behavior
- hidden rules buried in tables
- domain language replaced by tool language
- unstable variable naming
- implementation logic leaked into the acceptance surface
- Then clauses used as temporal narratives
- variable names used as a substitute for explicitly established state
- assuming automation or engineering can "figure out the rest"
- treating scenarios as disposable artifacts rather than governed product knowledge
- outcome-coupled scenario names
- scenario names that use `when` to express conditional context rather than event identity
- scenario names that summarize the whole scenario instead of identifying the event and only the minimum distinguishing conditions needed
- scenario names overloaded with detail such that ordinary refinement creates unnecessary rename churn

---

#### 24. The Goal of Producore BDD Craftsmanship

The goal is not to write scenarios.

The goal is to produce:

> complete, precise, executable behavioral specifications  
> that require zero interpretation

This goal is not machine-only.

It must also remain accessible to technical but business-oriented stakeholders such as Capability Managers who must learn how to craft behavioral specifications correctly and decompose capabilities correctly.

That means the guide must support both:

- teaching
- reference use

##### Observable Outcomes of Mastery

- scenarios are unambiguous
- scope is known before implementation
- teams align naturally
- rework is minimized
- defects decrease
- stakeholders trust the specification
- automation consumes the contract rather than inventing it
- capability-level behavior is expressed with structural discipline

##### Final Principle

> If a scenario requires explanation, it is not finished.

---

#### 25. Explicit Out-of-Scope and Downstream Tool Boundary

This guide is intentionally broad within the delegated BDD craftsmanship boundary, but it still has an edge.

That edge must remain explicit.

This guide governs:

- how behavioral specifications are written in scenario form
- how they are analyzed for adequacy, scope, granularity, and internal connectedness
- how Scenario Templates, Scenarios tables, and data tables attached to Gherkin clauses are used safely
- how automation may consume the specification surface without corrupting it

This guide does not govern the following downstream or adjacent concerns:

- feature-file organization
- step-definition code structure
- hooks
- binding-class design
- dependency injection strategy inside automation code
- runner mechanics
- CI/CD routing
- manifest design
- pipeline selection policy
- PKB storage mechanics
- PKB hierarchy mechanics
- lifecycle state mechanics
- evidence approval flow

Those may depend on this guide.

They are not defined by this guide.

##### Why This Boundary Must Remain Explicit

A craftsmanship guide can become misleading if it quietly expands into every adjacent practice simply because those practices touch the same `.feature` files or the same scenarios.

Producore does not treat all such concerns as one undifferentiated topic.

A specification is not the same thing as:

- its file layout
- its automation bindings
- its execution route
- its PKB storage location
- its lifecycle state

Those concerns are connected.

They are not interchangeable.

##### Regex and Developer-Only Language Boundary

Regex is not part of normal acceptance language.

If regex is ever shown in relation to a behavioral specification, it must be clearly marked as developer-only and must not become domain-facing contract language.

The same principle applies to:

- step-binding signatures
- test-framework attributes
- runner tags used for execution selection
- code-level helpers used in automation

These may support downstream realization.

They must not leak upward and become the behavioral contract surface.

##### Rationale

This boundary matters because Producore deliberately separates:

- behavior definition
- behavior expression
- authority
- realization

If local craftsmanship guidance starts absorbing automation-framework design, PKB operating mechanics, or execution-pipeline concerns, the guide stops being a delegated craftsmanship standard and starts drifting into adjacent doctrinal territory.

That would weaken the system rather than strengthen it.

---

#### 26. Reviewer Checklist and Author Self-Check

A full craftsmanship standard should not only explain principles.

It should also provide a compact review surface that experienced authors, reviewers, and AI systems can use to sanity-check whether a scenario or Scenario Template is structurally ready.

The following checklist is not a replacement for analysis.

It is a compact gate that helps ensure the analysis already performed is visible in the artifact.

##### Compact Checklist for Scenario Review

- [ ] The specification is anchored to a capability.
- [ ] The scenario or Scenario Template proves one behavior.
- [ ] The scenario name identifies the primary event under analysis.
- [ ] The scenario name includes only the minimum distinguishing conditions needed to differentiate it from sibling scenarios.
- [ ] The scenario name does not include the outcome.
- [ ] If the scenario name includes distinguishing conditions, those conditions are expressed as conditions, and `if` is preferred rather than `when` for that differentiation.
- [ ] There is one primary When event.
- [ ] The Given clauses define the state that is true at the exact moment the event occurs.
- [ ] The Then clauses define observable outcomes and constraints, not implementation choreography.
- [ ] No Then assertion depends on hidden assumptions, tribal knowledge, or unexplained prior context.
- [ ] Every entity, value, and transformation is properly connected across Given, When, and Then.
- [ ] If a Scenario Template is used, each row in the Scenarios table would be acceptable as a full scenario if written independently.
- [ ] If a Scenario Template is used, the Then set is stable across rows except for substitution or deterministic formatting.
- [ ] If a data table is attached to a Gherkin clause, it is scoped to that clause only and is not being used as a substitution table.
- [ ] Square-bracket variables and angle-bracket row parameters are used intentionally and are not being confused with one another.
- [ ] The scenario has survived adequacy analysis, scope analysis, granularity analysis, and the relevant deeper techniques.
- [ ] The scenario can be disputed or accepted in business language.
- [ ] The scenario could be consumed by automation without the automation layer manufacturing missing meaning.

##### Additional Checklist for Automation Binding Fidelity Review

Use this checklist when reviewing step definitions and fixture bindings that consume scenario-form specification text.

- [ ] Does every square-bracket variable bind through the repository variable-key pattern rather than a hard-coded alias?
- [ ] Would the binding still work if `[S]` became `[Surface]`, `[S1]`, or another valid variable key?
- [ ] If the same entity appears in multiple clauses, is there a fixture for that entity?
- [ ] Is scenario state stored on the relevant fixture or scenario entity rather than on the binding instance?
- [ ] Does the binding reuse existing binding constants such as `Param`, `Var`, and named transformations?
- [ ] Does the binding reuse `VariableFixture<T>` and `VariablesTableFixture<T>` conventions where those conventions exist in the repository?
- [ ] Does the binding use `StringFixture` (or repository equivalent) instead of raw `{string}` when variable-aware string support is required by the clause semantics?
- [ ] Does the binding avoid introducing a second parsing convention for a concept that is already modeled?
- [ ] Does the binding preserve equivalent meaning under reasonable equivalent Gherkin wording?
- [ ] Is any deliberate narrowing documented as behavior-specific rather than incidental automation convenience?

##### Author Self-Check Before Handoff

Before presenting a behavioral specification downstream, the acting behavioral specification author should be able to answer yes to all of the following:

- Can I explain why this is one behavior rather than several?
- Can I defend why the scenario name identifies the event correctly and does not overstate the contract?
- Can I defend why the When is the primary event?
- Can I show where every important entity or value came from?
- Can I explain why nothing important has been hidden in a table, row, or implied condition?
- Can I explain why the scenario is at the right granularity for implementation?
- Can I explain what relevant variants were considered and whether they were specified, deferred, or ruled out?
- Can I explain why this wording is business-facing and not implementation-facing?

If the answer to any of those questions is no, the scenario is not yet mature enough for confident downstream use.

##### Rationale

A checklist is useful because craftsmanship failures are often obvious in hindsight but easy to miss during drafting.

The checklist does not define correctness by itself.

It helps reveal whether the underlying analysis has actually been done or merely assumed.

It is also useful for AI-assisted work because it provides a compact validation surface against which a generated specification can be evaluated before anyone treats it as serious.

---

#### 27. Adoption, Onboarding, and Temporary Deviations

A guide of this kind should help a new team start using the craft correctly and help an established team avoid gradually normalizing weak exceptions.

##### Onboarding Quick Start

For new practitioners, the recommended entry path is:

1. Read the foundational sections on behavior as state transformation, constraints over implementation, and the nature of Given / When / Then.
2. Write a small number of scenarios in one capability area.
3. Apply the analysis techniques deliberately rather than trusting first drafts.
4. Use the reviewer checklist and self-check before treating the scenarios as ready.
5. Ask whether the resulting specifications could be implemented and automated without invention.
6. Repeat until the team can produce scenarios that are explicit, business-readable, and structurally sound without constant correction.

This guide is not meant to be read once and admired.

It is meant to be practiced.

##### Temporary Deviations and Exceptions

There may be cases where a team temporarily deviates from the ideal local craftsmanship form.

Such deviations must be treated as temporary, explicit, and visible.

They must not silently become the new normal.

When a temporary deviation is accepted, record at least:

- owner
- scope
- reason
- expiration date or review point
- exit criteria

Examples of temporary deviations might include:

- a coarse scenario preserved temporarily because discovery is still underway
- a lower-fidelity artifact being used while a higher-fidelity scenario set is still being matured
- a narrow local compromise required by a downstream tool, clearly marked as downstream and non-authoritative

What must not happen is this:

- a temporary weakness is left unmarked
- the team begins treating it as acceptable craftsmanship
- future authors copy it as precedent

##### Rationale

Teams do not usually destroy standards through one dramatic act.

They erode them by allowing unclear exceptions to persist until nobody remembers they were exceptions.

A mature craft needs a way to acknowledge reality without surrendering the standard.

That is the purpose of explicit, time-bounded deviations.

---

#### 28. Signals of Craftsmanship Health

A local craftsmanship standard is more useful when it helps teams notice whether their practice is getting stronger or weaker over time.

These signals are not doctrinal authority.

They are practical indicators that can help a team understand whether it is maturing or drifting.

##### Useful Signals

Examples of useful local signals include:

- time from first draft to readiness
- amount of structural churn after a scenario was treated as ready
- number of structural violations found during review
- how often automation work reveals missing Given state or ambiguous Then assertions
- how often Scenario Templates must be split because they were introduced too early or mixed different outcome concerns
- how often Engineering or QA had to manufacture missing behavioral meaning during realization or automation work

##### What to Look For

Healthy trajectory usually looks like:

- fewer hidden assumptions
- fewer row-shape violations
- fewer mixed-outcome templates
- less downstream invention
- clearer and faster stakeholder dispute/accept cycles

Unhealthy trajectory usually looks like:

- scenarios that pass review only because reviewers already know the missing context
- recurring argument about what a scenario “really means”
- automation bindings becoming the place where behavior is actually defined
- repeated need to split scenarios late because granularity was ignored early

##### Rationale

The purpose of these signals is not bureaucratic reporting.

The purpose is to help a team notice drift before that drift becomes normalized.

Craftsmanship failure rarely begins with code visibly breaking.

It begins earlier, when the specification surface no longer carries enough precision to protect the contract.

---
