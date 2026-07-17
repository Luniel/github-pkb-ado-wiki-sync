
### Producore Canonical Guide - BDD Craftsmanship Standard - Part 2 of 3

> **08B - Scenario Construction and Executability**  
> Covers scenario/template construction, Gherkin container handling, executability, implementation/testing relationship, and completeness.

#### 16. Scenario Construction and Scenario Template Discipline

A scenario is the canonical local unit for expressing one behavior under a specific set of conditions.

A Scenario Template is a parameterized scenario shape whose parameters are supplied by a Scenarios substitution table.

In this section, not all guidance has the same weight.

- The scenario naming subsection defines binding craftsmanship rules.
- The visual formatting subsection defines first-choice presentation conventions.

Both matter. They should not be collapsed into one category. A violation of a binding craftsmanship rule is a real craftsmanship defect. A deviation from a first-choice presentation convention is not automatically a structural-invalidity trigger, but it should not be done casually when it reduces readability, reviewability, or structural visibility.

##### Construction Rules

A valid scenario or template must satisfy the following:

- it is anchored to one capability
- it expresses one behavior
- it has one primary event
- its outcome surface remains stable as a behavioral contract
- it does not change meaning from row to row in hidden ways

##### Scenario Template Discipline

A Scenario Template is valid only when the scenarios share the same behavioral shape and differ only by parameter substitution or deterministic helpers.

A substitution table is not a place to mix:

- different kinds of outcomes
- different behavioral concerns
- different hidden branches
- row-specific Then mutations

Each row must materialize into a complete scenario that would be acceptable if written independently.

##### Scenario Naming Discipline

Scenario names are not decorative.

They are local identifiers for behavioral contract instances.

They must help reviewers, authors, implementers, and later readers identify the behavioral unit under discussion without forcing the name itself to become a paraphrase of the whole scenario.

A scenario name must identify the primary event under analysis.

A scenario name may include only the minimum distinguishing conditions needed to differentiate the scenario from sibling scenarios that share the same primary event.

A scenario name must not include the outcome.

A scenario name should not become a mini-specification, a summary sentence, or a restatement of the Given and Then surfaces.

The scenario body is where the contract is expressed.

The name is where the contract instance is identified.

###### Event and Condition Language in Scenario Names

The guide already treats `When` as the event surface in the scenario body.

That distinction should remain clear in scenario names as well.

When a scenario name includes distinguishing conditions, those conditions should be expressed as conditions, not as disguised events.

Prefer `if` for distinguishing conditions in scenario names.

Do not use `when` in a scenario name to mean "under the condition that" or "in the case where" when the word is really introducing conditional context rather than the event under analysis.

This keeps the semantic grammar of the guide internally consistent:

- the event belongs to the event concept
- distinguishing conditions belong to conditional differentiation

###### Identifier Stability

A scenario name should remain stable under ordinary specification refinement.

This is one of the reasons the name must not include the outcome.

The outcome surface is often the part of the contract most likely to be refined during maturation, decomposition, or clarification.

If the name includes the outcome, then ordinary improvement of the scenario body creates unnecessary rename pressure on the identifier itself.

That widens the blast radius of routine refinement across:

- review discussions
- work-item discussions
- traceability references
- comments
- implementation conversations
- historical comparisons

A stable identifier helps the scenario remain discussable even while the body becomes more precise.

##### Distinction: Scenarios Tables vs Data Tables in Steps

This distinction must remain explicit.

A Scenarios table:

- materializes multiple scenarios from one template

A data table attached to a Gherkin clause:

- supplies structured state or expectations for that single clause only

These are not interchangeable.  
They serve different purposes and must not be collapsed.

##### Rationale

Templates and tables are powerful compression devices, but they become destructive when used before the behavior is properly understood.

They are for representing already-understood common shape, not for skipping analysis.

---
##### Additional Surface Rules for Gherkin Containers

A complete craftsmanship standard must also make the local container distinctions explicit.

The following terms are **native Gherkin language constructs**:

- `Feature`
- `Rule`
- `Background`

They are part of the Gherkin language itself and they have specific local functions in `.feature` files used by BDD automation frameworks such as Cucumber, SpecFlow, and Reqnroll.

They are included in this guide only so that Producore practitioners can use Gherkin safely and consistently.

They are **not official Producore terminology**.

They do **not** define Producore ontology, Capability structure, Behavior forms, lifecycle, authority, or PKB ontology.

If there is any apparent overlap between a Gherkin-native term and a Producore doctrinal concept, the Producore doctrinal concept governs and the Gherkin-native term must be treated as a local language/container construct only.

A **Gherkin Feature** is an optional narrative container for related scenarios.

A **Gherkin Rule** is an optional statement of the governing business constraint that explains why scenarios differ.

A **Gherkin Background** is an optional shared precondition mechanism.

A **Scenario** is the canonical local unit for proving one behavior under one scenario-bound set of conditions.

A **Scenario Template** is a parameterized scenario shape whose rows in the **Scenarios** table materialize into complete scenarios.

These units are not interchangeable.

A Gherkin Feature does not define behavior merely because it contains scenarios.  
A Gherkin Rule does not replace the scenarios beneath it.  
A Gherkin Background does not license hiding meaningful variability.  
A Scenario Template does not weaken the requirement that each row materialize into a full scenario.  
A data table attached to a Gherkin clause does not become a substitution table merely because it is tabular.

###### Gherkin Feature

A Gherkin Feature may be used when it helps readers understand the coherent family of behaviors being expressed.

Gherkin Feature is a narrative grouping surface only.

It must not become:

- a second behavioral authority layer
- a place where hidden rules replace explicit scenarios
- a container that silently changes the meaning of the enclosed scenarios
- an apparent Producore doctrinal unit merely because the Gherkin language recognizes it

###### Gherkin Rule

A Gherkin Rule may be used when the scenarios differ because of a common governing business constraint.

A Gherkin Rule is especially useful when a reader would otherwise have to infer why several scenarios exist side by side.

A Gherkin Rule does not define behavior in place of scenarios.

It explains the business reason that the scenarios differ.

A Gherkin Rule is still a Gherkin-native container, not a Producore canonical concept.

###### Gherkin Background

Gherkin Background may be used when it removes duplication without hiding variability that matters to the behavior being specified.

Gherkin Background must not be used to:

- smuggle in meaningful preconditions that should be visible in the scenario
- hide differences between rows or scenarios
- disguise hidden events
- conceal capability-specific conditions that materially affect meaning

If moving content into Background makes the scenario harder to dispute in business language, that move is invalid.

###### Scenario Template and Scenarios Table

A Scenario Template is valid only when the scenario wording remains stable and the table supplies substitutions rather than new hidden branches.

Each row in the Scenarios table must materialize into a full scenario that would be acceptable if written independently.

A row is not a casual example.

It is a shorthand for a full behavioral specification instance.

##### Variables, Parameters, and Lightweight Expressions

Producore distinguishes between canonical domain variables and row-level template parameters.

**Canonical domain variables** use square brackets, for example:

- `user [U]`
- `cart [C]`
- `password [P]`

These identify domain entities, values, or named variables that are part of the scenario language itself.

**Row-level template parameters** use angle brackets, for example:

- `<Path>`
- `<Landing Page>`

These are used only in a Scenario Template and are substituted from the Scenarios table.

This distinction must remain explicit.

Square-bracket variables are part of the domain language of the specification.

Angle-bracket parameters are part of the template materialization mechanism.

They are not the same thing.

###### Lightweight Expression Boundary

The acceptance specification surface should remain mathematically precise without becoming a programming language.

Only lightweight expressions should appear, and only when they make the behavior more explicit rather than less reviewable.

Examples of acceptable lightweight expression patterns include:

- equality or direct value relation expressions
- simple additive expressions where the original and resulting values matter
- minimal functions such as `LEN(...)` where the function is domain-comprehensible and materially clarifies the rule

The purpose of such expressions is not to smuggle implementation into the scenario.

The purpose is to make the behavioral rule explicit enough that the reader does not have to infer it.

If the expression surface starts to look like code rather than business-reviewable behavior, it has crossed the craftsmanship boundary.

###### Special Tokens

Special tokens such as `empty` and `anything` may be useful in local craftsmanship when they clarify a behavioral rule without forcing awkward natural-language repetition.

They must not be used as vague placeholders.

If a token hides necessary specificity, it is invalid.

If it makes the scenario easier to dispute or verify in business language, it may be appropriate.

##### Style and Conventions

The local craftsmanship surface should prefer consistency where consistency improves reviewability.

Not all guidance in this section has the same weight.

Some guidance in this guide is binding craftsmanship rule.

Some guidance in this section is first-choice presentation convention.

Violation of a binding craftsmanship rule is a real craftsmanship defect.

Deviation from a first-choice presentation convention is not automatically a structural-invalidity trigger.

Even so, preferred conventions should not be discarded casually when they materially improve readability, reviewability, structural visibility, or calmer, lower-friction review conditions.

###### ASCII Hygiene

Use ASCII punctuation in the canonical specification surface unless a compelling domain reason requires otherwise.

This avoids drift between authoring, storage, automation tooling, and review surfaces.

###### Headings and Labels

Use:

- `Scenario:` for a single instance
- `Scenario Template:` when followed by `Scenarios:`

Use the label `Scenarios:` for substitution tables that materialize scenario instances.

Do not casually switch labels in ways that blur the distinction between substitution tables and data tables attached to Gherkin clauses.

###### Indentation and Visual Shape

Keep clause indentation and table indentation consistent and visually aligned.

Good visual structure is not cosmetic only.

It reduces reading errors and helps reviewers notice missing or inconsistent structure.

###### Preferred Clause-Body Alignment

As a first-choice presentation convention, prefer using a consistent visual clause ladder within each Gherkin clause block.

In this preferred convention:

- `Given` begins slightly to the right of the scenario label
- `When` and `Then` begin one space further right than `Given`
- `And` and `But` begin one space further right than `When` and `Then`

Preserve this relative visual shape consistently where the clause block benefits from it.

This is a presentation convention, not a structural-validity rule.

A scenario does not become semantically invalid merely because this exact alignment preference was not followed.

However, it is still a meaningful craftsmanship preference.

It improves:

- structural scanability
- visual regularity
- rapid defect visibility
- reduced cognitive friction during review
- calmer, less frantic re-scanning of the specification surface

These are legitimate craftsmanship concerns for a guide intended to support human review as well as machine-consumable precision.

Example preferred visual shape:

```Gherkin
Scenario: candidate enters Forge through one pipeline entry path
    Given candidate [C] has a valid Forge invitation path
     When candidate [C] enters Forge from that path
     Then Forge starts candidate [C] in one bounded pipeline entry flow
      And Forge does not require separate invitation links per later stage

Scenario Template: candidate enters Forge through one pipeline entry path
   Given candidate [C] has a valid Forge invitation path
    When candidate [C] enters Forge from that path
    Then Forge starts candidate [C] in one bounded pipeline entry flow
     And Forge does not require separate invitation links per later stage
```

In this preferred visual convention, the Gherkin clauses form a consistent staggered ladder that improves readability and review calmness.

This is a first-choice presentation convention for readability and review calmness.
It is not a structural-validity rule.

###### Tags and Selection Concerns

Selection and routing are external concerns.

Do not encode execution-selection policy, routing policy, or pipeline-targeting concerns into the acceptance-specification text by default.

If a downstream system needs such metadata, that concern belongs downstream of the behavioral contract unless a higher authority explicitly requires otherwise.

##### Rationale

Much of the confusion in real BDD work comes not from the core idea of Given/When/Then, but from collapsing local units that serve different purposes.

Teams blur:

- Scenario Templates and Scenarios tables
- data tables attached to Gherkin clauses and substitution tables
- Features and behavioral authority
- Rule explanations and scenario contracts
- variables and row parameters
- binding craftsmanship rules and first-choice presentation conventions
- event language and condition language in scenario names

Once those distinctions collapse, ambiguity spreads quickly.

The purpose of these conventions is not stylistic purity.

The purpose is to preserve explicit structure so that the specification remains readable, reviewable, and executable without interpretation.

That includes protecting conditions under which a human reviewer can see structure clearly, maintain focus, detect defects quickly, and refine a scenario without unnecessary agitation or re-scanning.

Review calmness is not a trivial concern.

It directly affects specification quality.

---

#### 17. Executability and Automation Consumption

A valid scenario must be craftable in a way that allows automation to consume it without corrupting the specification surface.

##### Core Rule

Automation consumes.  
It does not author.

When automation frameworks such as Cucumber, SpecFlow, or Reqnroll interpret `.feature` files, they do so through automation steps or step definitions bound to Gherkin clauses. The automation meaning of `step` must not be confused with use-case steps, analysis steps, or general execution actions.

##### A Scenario Is Invalid for Executable Consumption If Automation Must:

- guess missing state
- invent values that were never grounded
- infer unstated relationships
- decide what the requirement "probably meant"
- encode business rules not made explicit in the specification

##### Why Executability Matters

A scenario that cannot be automated without invention is already defective as a specification, even if the automation effort never happens.

Automation pressure does not create the defect.  
It reveals the defect.

##### Stable Traceability

Automated execution should be traceable back to:

- the originating scenario
- and, where applicable, the specific substitution-table row

##### Determinism

Automation should prefer deterministic setup and validation, including:

- controlled clocks where needed
- stable fixtures or factories
- isolated scenarios
- order independence
- explicit handling of external dependencies

##### No Incidental Assertions by Default

Automation should assert behavioral constraints and invariants, not incidental formatting or representation, unless that representation is itself the behavior under test.

##### Selection Policy Boundary

Selection and routing are external concerns.

They should not be encoded into acceptance specification text by default.

##### Executable Gherkin Notation Semantics (Binding Craftsmanship Rule)

Executable Gherkin in PCEOOD must preserve explicit value semantics in clause text.

Notation standard:

```text
"Forge"       = string literal
[PID1]        = variable/value reference
product [P1] = typed domain entity variable reference
Forge         = bare domain phrase/token only when an explicit typed binding models it as a domain concept
```

Rules:

- String literals are quoted.
- Variable/value references use square-bracket variable notation.
- Domain entities use typed domain language plus square-bracket variables.
- Bare words are valid only when intentionally modeled as typed domain concepts with explicit typed transformations.
- Scenario Template table values must quote string literals.
- Bare Scenario Template table values are valid only when the column is a typed domain concept with explicit typed transformation support.
- Automation must not rely on framework inference to guess whether a bare value is a string literal, variable reference, or domain concept.

Examples:

Bad (ambiguous bare value):

```gherkin
Then product surface [S] has product identity label Forge
```

Good (string literal):

```gherkin
Then product surface [S1] has product identity label "Forge"
```

Good (variable reference):

```gherkin
Given string [PID1] is "Forge"
And product surface [Surface] has active product identity [PID1]
When define identity labels for product surface [Surface]
Then product surface [Surface] has product identity label [PID1]
```

Good (typed domain phrase):

```gherkin
Given product [SubjectProduct] is Forge
When define identity label for product [SubjectProduct]
Then product [SubjectProduct] has product identity label "Forge"
```

In the typed-domain form above, `Forge` is valid only because the clause and automation binding intentionally model it as a product domain concept.

##### Automation Binding Fidelity to Gherkin Semantics (Binding Craftsmanship Rule)

Automation consumes the specification.

It does not author, narrow, reinterpret, or replace it.

Therefore, automation bindings must preserve the semantic flexibility of the specification language rather than only passing one concrete scenario wording.

Enforceable rules:

1. Square-bracket variables (for example `[S]`, `[B]`, `[P]`, `[PID1]`, `[Surface]`) are variable-key notation and must not be hard-coded as literal alias text unless the behavior explicitly requires that exact alias.
2. A step definition must not depend on one arbitrary alias. Equivalent valid variable keys must continue to bind.
3. If the same entity appears across multiple clauses, bindings must introduce or reuse a fixture for that entity unless the repository already has an equivalent scenario-entity pattern, rather than storing entity state on the binding class instance.
4. Where a repository already has variable-key patterns such as `VariableFixture<T>` and `VariablesTableFixture<T>`, new bindings must reuse those conventions unless a behavior-specific exception is documented, instead of inventing alternate parsing paths.
5. Where a repository has variable-aware string fixtures (for example `StringFixture`), new bindings must use that parameter type instead of raw `{string}` whenever the clause value may be either a quoted literal or a square-bracket variable reference. Any narrowing must be behavior-specific and explicitly documented.
6. Bindings must reuse established constants and named transformations (for example `Param`, `Var`, and named transformation identifiers) so clause semantics stay consistent and reviewable.
7. Bindings must not make feature authors guess which aliases are "secretly supported" by automation code.
8. A binding is not craftsmanship-compliant merely because the current scenario text executes.
9. Binding review must test reasonable equivalent wording, including equivalent variable aliases.

Bad pattern (illustrative):

```csharp
[Given("product surface [S] has active product identity {string}")]
public void GivenActiveProductIdentity(string identity)
{
  _activeProductIdentity = identity;
}
```

Why this is defective:

- hard-codes one alias (`[S]`)
- rejects equivalent valid aliases
- narrows value binding to raw string literal parsing when variable-aware string fixtures may exist
- stores entity-owned state on the binding instance
- may pass one scenario while corrupting the broader specification language

Good pattern (illustrative class names):

```csharp
[Given($"{ProductSurfaceBindings.Param} has active product identity {StringBindings.Param}")]
public void GivenProductSurfaceHasActiveProductIdentity(
  ProductSurfaceFixture surface,
  StringFixture identity)
{
  surface.ActiveProductIdentity = identity;
}
```

Variable-key transformation and fixture unwrapping pattern (illustrative):

```csharp
public const string Name = "ProductSurface";
public const string VariableName = $"{Name}Var";
public const string Param = $"{{{Name}}}";
public const string Var = $"{{{VariableName}}}";

[StepArgumentTransformation($"product surface {KeyBindings.Pattern}", Name = VariableName)]
[StepArgumentTransformation(KeyBindings.Pattern, Name = VariableName)]
public VariableFixture<ProductSurfaceFixture> GetVariableByKey(VariableKey key)
{
  return Variables[key];
}

[StepArgumentTransformation($"product surface {KeyBindings.Pattern}", Name = Name)]
public ProductSurfaceFixture Unwrap(VariableFixture<ProductSurfaceFixture> variable)
{
  return variable.Value;
}
```

The class names are examples only. The governing pattern is variable-key transformation, fixture unwrapping, fixture-owned state, and variable-aware string handling.

##### Rationale

BDD tools decouple specification from test bindings. That only helps if the specification itself is precise enough to be consumed consistently across different automation scopes.

If the specification is vague, the bindings become the place where behavior is silently invented, and the contract surface is corrupted.

If bindings narrow clause semantics beyond what the specification language allows, the same corruption occurs even when execution appears green.

---

#### 18. Relationship with Implementation, Testing, and Manual Use

The same behavioral specification serves multiple downstream consumers.

##### Product and Stakeholders

Use it to confirm what behavior is required and to dispute incorrect or missing behavior in business language.

##### Engineering

Uses it to understand what behavior must be realized.

At minimum, the engineer should be able to drive design and implementation from the scenario.

Ideally, the scenario should also be usable directly as the source contract for automated validation.

##### Testing

Uses it to derive:

- manual test activities
- automated acceptance tests
- focused exploratory testing
- lower-scope validations where appropriate

##### Important Boundary

Those downstream consumers may create:

- test scripts
- unit tests
- integration tests
- feature files
- automation bindings

But those artifacts do not redefine the scenario.

##### Rationale

The same behavioral requirement must remain stable while different downstream consumers use different realization and validation techniques.

That stability is part of the reason BDD is so valuable when done correctly.

---
#### 19. Distinction Between Observation, Implementation, and Specification

This distinction must remain explicit.

A behavioral specification is not the same thing as:

- an observation of what a system currently does
- an implementation of that behavior in code
- a test or automation artifact that validates a behavior
- a conversation about what the behavior might be

These artifacts may relate to one another, but they are not interchangeable.

##### Observation Is Not Specification

Observed behavior may reveal:

- what the system currently appears to do
- what users are experiencing
- what a tester can reproduce
- what telemetry or logs suggest

Observed behavior does not define what the requirement is.

Observation may motivate specification work.

Observation may help discover missing behavior.

Observation may help reconstruct a current-state specification when no valid specification exists.

But observation is not the contract.

##### Implementation Is Not Specification

Code, bindings, tests, automation fixtures, and manual regression checklists are downstream realizations or consumers.

They may expose misunderstanding.

They may reveal ambiguity.

They may provide evidence of conformance or divergence.

They must not become hidden sources of behavioral truth.

##### Specification Is the Contract Surface

The specification is the reviewable expression surface through which the intended behavior is made explicit for realization and validation.

That is why craftsmanship matters so much.

If the specification is weak, the surrounding artifacts begin to absorb meaning they were never meant to own.

##### Reverse-Engineering Boundary

Sometimes the team must reconstruct a valid scenario-form specification from current behavior because no valid specification exists.

When that happens, the goal is not to treat whatever the system currently does as automatically correct.

The goal is to produce an explicit, reviewable specification for the relevant current-state or target-state behavior without collapsing:

- observed behavior
- implemented behavior
- specified behavior

into one thing.

This guide does not define the full defect-analysis method for doing that work.

It only preserves the local craftsmanship boundary that the distinction must remain explicit.

##### Rationale

If a team collapses observation, implementation, and specification into one undifferentiated idea of "what the system does," then all downstream governance erodes.

Tests become requirements.
Code becomes behavior definition.
Conversations become contract.

That is structurally invalid in the Producore system.

So the craftsmanship guide must preserve the distinction clearly enough that local scenario work does not silently destroy the upstream/downstream chain.

---

#### 20. Scenario Completeness Standard

A scenario is complete only if:

- all required entities have origin
- all material values are defined
- all relevant transformations are explicit
- the event boundary is clear
- there are no dangling elements
- there are no hidden assumptions required to interpret the outcome
- there are no hidden events collapsing multiple behaviors into one scenario
- relevant meaningful permutations have either been specified, deferred explicitly, rejected explicitly, or flagged for research
- the scenario can be implemented and validated without invention
- stakeholders can read and dispute it in business language

##### Not-Ready Signals

A scenario is not ready if it contains any of the following:

- hidden assumptions
- contradictory interpretations
- coarse outcome declarations that are not implementable
- mixed behavior concerns
- multiple primary events
- implicit branching hidden in rows or tables
- implementation chatter masking missing behavior definition

##### Rationale

Syntactic validity is cheap.  
Readiness is not.

A scenario is ready only when it has survived the required analysis and still stands as a coherent, implementable, stakeholder-reviewable requirement.

---
