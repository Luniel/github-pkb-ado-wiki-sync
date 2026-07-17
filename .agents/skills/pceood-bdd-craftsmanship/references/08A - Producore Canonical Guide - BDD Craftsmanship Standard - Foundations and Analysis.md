
### Producore Canonical Guide - BDD Craftsmanship Standard - Part 1 of 3

> **08A - Foundations and Analysis**  
> Covers formal foundations, structural integrity, adequacy, Given/When/Then discipline, and the canonical analysis techniques.

#### 1. Foundation: Behavior as a Formal System

Behavior-Driven Development is not a writing style. It is a method for defining software behavior as a deterministic transformation of system state.

A valid BDD specification describes:

- a starting state (Given)
- an event (When)
- a resulting state (Then)

This is not narrative. It is a mathematical mapping:

> (State0 + Event) -> State1

The requirement is not that the scenario "makes sense."  
The requirement is that it can be executed, verified, and reasoned about without interpretation.

Gherkin is therefore not a communication aid. It is a formal behavioral language that must produce identical understanding across:

- product stakeholders
- engineers
- testers
- automation frameworks

If a scenario produces different interpretations across those audiences, it is invalid.

##### Expanded Interpretation of "State"

The term state must be interpreted rigorously:

- It is not a vague description of "context"
- It is the complete set of conditions required to evaluate the outcome

This includes:

- entities
- attributes
- relationships
- constraints
- system conditions
- relevant environmental factors

Any omission from state that affects outcome is a specification defect.

##### Formal Definition of Event

The term event must also be interpreted rigorously.

An event is the discrete trigger under evaluation in the scenario. It is the thing that occurs at the moment the stipulated start-state is in force and that requires the capability to behave.

An event in a valid scenario must be:

- discrete
- atomic
- singular in primary business meaning
- bounded clearly enough that the team can identify when it occurs
- recognizable by the system or by the external actor whose interaction is being specified

An event in a valid scenario must not:

- collapse multiple business events into one clause
- encode a sequence of actions as though it were one trigger
- hide intermediate events that materially affect the outcome
- smuggle in internal implementation choreography

If the "When" clause actually compresses a chain of events, the scenario is too large and Hidden Events Analysis must be applied.

##### Rationale

Most teams treat Gherkin as structured prose. That creates:

- ambiguity
- hidden assumptions
- inconsistent implementation

Producore treats Gherkin as a formal specification language, because:

- automation requires exactness
- engineering requires determinism
- product requires unambiguous intent

If a scenario cannot be executed without interpretation, it is not a valid specification.

---

#### 2. Authority, Scope, and Canonical Boundary

This guide defines craftsmanship only.

It defines:

- how Specified Behavior is expressed in scenario form
- how scenarios are constructed and decomposed
- how scenario families are represented without changing behavior
- how scenario-form specifications are assessed for craftsmanship quality
- how craftsmanship supports implementation and automation consumption without allowing automation to redefine the specification surface

It does not define:

- ontology
- Capability
- Behavior
- behavior forms
- correctness
- alignment
- binding authority
- lifecycle semantics
- PKB structure or PKB ontology

This guide must remain within the delegated authority boundary established by the canonical doctrine.

Use of Gherkin-native terms and containers does not elevate those terms into Producore doctrine. When this guide discusses native Gherkin constructs, it does so only to govern safe local use of Gherkin form.

##### Canonical Alignment

All craftsmanship under this guide operates within the canonical chain already defined elsewhere.

For local craftsmanship purposes:

- specifications must remain capability-anchored
- specifications must express Behavior without redefining it
- implementation and automation must remain downstream consumers of specification

If that chain is violated, the problem is structural, not craftsmanship-related, and must be corrected in the appropriate higher document.

##### Binding Boundary

Whether a specification is binding is governed exclusively by the PKBDD Operating Doctrine.

Craftsmanship and artifact form do not confer authority.

Therefore:

- a high-quality BDD specification may still be non-binding
- a binding specification may still be lower fidelity than ideal BDD form

This guide governs quality of expression, not authority.

##### Rationale

The Producore doctrine separates:

- definition
- expression
- authority
- realization

This guide exists only in the expression layer.

If the BDD Craftsmanship Standard starts defining ontology, conferring authority, or absorbing lifecycle concerns, it becomes structurally invalid relative to the canonical stack.

---

#### 3. The Role of Gherkin: Constraints, Not Implementation

Gherkin does not describe how a system works. It defines the constraints on acceptable outcomes.

The Then clause defines:

- what must be true
- not how it becomes true

Implementation exists between When and Then, but is intentionally excluded.

##### Critical Distinction: Constraint vs Implementation

Constraint (Specification):

- "order [O] is marked as paid"
- "user [U] is logged in"
- "cart [C] line item [I] is discounted 10%"

Implementation (Forbidden in Specification):

- calling a payment API
- updating database rows
- iterating through collections
- invoking internal services

If implementation appears in a specification, the specification is invalid.

##### Why "How" Is Explicitly Excluded

The system may have many valid implementations that satisfy the same constraint.

Describing implementation:

- couples requirements to design
- eliminates valid alternatives
- introduces brittleness

Instead, constraints:

- bound the solution space
- preserve flexibility
- maintain testability

##### Rationale

The specification defines the allowed outcome space.  
Implementation is simply one of many possible ways to satisfy that space.

As constraints increase, implementation options decrease.

This preserves:

- engineering freedom
- long-term adaptability
- clear separation of concerns

---

#### 4. BDD as Product Specification, Not Test-Script Writing

BDD is not just a testing framework. It is a business practice for defining behavior in a form that product, engineering, and testing can all use as the same requirement surface.

Used correctly, BDD scenarios are not transient test artifacts. They are part of the living specification of the product.

That means the same scenario must be suitable for:

- business review
- implementation guidance
- test design
- automated validation

When teams use Gherkin only as a way to script automated tests, they usually lose:

- business language
- rationale
- shared understanding
- product ownership of requirements
- usefulness as a durable behavioral record

##### Rationale

If Gherkin is written only for automation, it becomes tool-facing instead of business-facing.

That creates several failure patterns:

- product stops owning the specifications
- scenarios drift from the actual requirement
- engineers and testers fill in gaps from habit
- the artifact loses value as product knowledge

Producore therefore treats Gherkin as part of living product knowledge, not as a throwaway test-script surface.

---

#### 5. Structural Integrity of a Scenario

A valid scenario is a closed system.

Every element must:

- be introduced
- be used
- be connected

No element may:

- appear without origin
- exist without influence
- imply unstated transformations

##### Core Rule

> Nothing appears in Then that is not grounded in Given or When.

##### Structural Model

A scenario must form a complete transformation graph:

- Given defines all required inputs
- When defines the triggering event
- Then defines all resulting outputs

Every element must trace:

- backward -> to its origin
- forward -> to its effect

If either direction fails, the scenario is invalid.

##### Specification Smells (Indicators of Structural Failure)

A scenario is structurally invalid if it exhibits:

- entities introduced in Then that were not defined earlier
- values used in When without origin
- elements in Given that have no effect
- implied transformations not stated
- ambiguous or inferred relationships

These are not stylistic issues.  
They are logical defects.

##### Implied State Defect

An implied state defect exists when a condition required to interpret the behavior is not explicitly stated in Given.

This includes cases where the scenario relies on:

- domain knowledge that was never made explicit
- assumptions from a previous scenario
- supposed defaults that were never stated
- variable names that hint at relationships but do not actually establish them
- unstated prior conditions needed to make the Then outcome meaningful

Examples include:

- assuming cart [C] contains the relevant items without stating that those items exist
- assuming an entered password is the user's password without establishing that relationship
- assuming a count is incremented from some prior value without stating the prior value

If the reader or implementer has to silently reconstruct the starting state, the scenario is defective.

##### Rationale

Violations force humans to fill in the gaps, which introduces:

- inconsistent implementations
- hidden assumptions
- non-reproducible behavior

This is the root cause of most BDD failure.

---

#### 6. Adequacy: What "Good Enough" Actually Means

A scenario is adequate only if it:

1. Fully defines the starting state
2. Clearly defines the triggering event
3. Precisely defines the resulting state
4. Requires no interpretation
5. Can be implemented without invention
6. Can be automated without invention

##### What Inadequacy Looks Like

A scenario may appear "clear" but still be inadequate.

Example pattern:

- assumes entities exist
- assumes relationships
- omits behavior for other elements

Example failure:

```Gherkin
Then cart [C] line item [MostExpensiveItem] is discounted 10%
```

Problems:

- Where did the item come from?
- What defines "most expensive"?
- What happens to other items?
- What if there is only one item?

The scenario relies on reader inference, which is disallowed.

##### Characteristics of Inadequate Scenarios

- Things introduced in Then that should've been established earlier
- Assumptions instead of explicit state
- Ambiguity across stakeholders
- Requires prior knowledge
- Requires explanation (tribal knowledge)
- High cognitive load

##### Impact of Inadequacy

- People interpret it differently -> rework
- People overbuild -> technical debt
- People underbuild -> missing functionality

##### Rationale

BDD is not about expressing intent.  
It is about eliminating interpretation.

A scenario that requires explanation is not complete.

---

#### 7. The Nature of Given, When, Then

##### Given

Defines:

- the state of the system
- at the exact moment the event occurs

Given does not describe how the system got there.

Given is not the setup script.  
Given is not narrative preamble.  
Given is not prior history unless that prior history is relevant as current state.

The essential rule is this:

> Given defines the start-state at the exact moment the When event occurs.

Given and When are therefore co-located on the timeline.

##### When

Defines:

- the event being evaluated

Must:

- be singular
- be explicit when needed
- represent the point at which the capability is exercised

The event may be implicit only when it is genuinely unambiguous from context. If the event must be inferred, debated, or interpreted, it must be made explicit.

##### Then

Defines:

- the resulting state

Must:

- describe outcomes
- not describe execution actions or intermediate transitions
- not imply sequence
- not encode temporal leakage
- not continue the story beyond the scenario boundary

##### Critical Rule

Then describes:

> what is true after the scenario  
not  
> what happens during the scenario

##### Explicit Prohibition of Temporal Leakage in Then

Then clauses must not encode time, sequence, or intermediate transitions unless those are themselves the behavior being specified through explicit states or events.

The following are invalid patterns:

- "then X happens and then Y happens"
- "after that..."
- "eventually..."
- "then the system starts doing..."
- "then the system finishes doing..."

Those formulations shift Then from end-state specification into narrative choreography.

If timing or progression matters, it must be specified explicitly through state, events, or additional scenarios.

##### Rationale

This separation ensures:

- clarity of behavior
- testability
- implementation independence

It also prevents a common failure mode in which teams use Then clauses to smuggle a mini-use-case into what should be a single scenario.

---

#### 8. Constraints vs Implementation (Reinforced)

The system between When and Then is:

- unknown
- irrelevant to the specification

Only constraints matter.

##### Practical Implication

If someone asks:

> "How does it do that?"

The correct response is:

> "That is not part of this specification."

If someone replies:

> "But how matters here,"

the correct analytical response is not to encode the implementation.

The correct response is to ask:

- what outcome are you trying to require?
- what boundary are you trying to enforce?
- what harmful result are you trying to prevent?

That concern should be restated as a constraint or outcome, not as choreography.

##### Rationale

Specifications define:

- what must be true

Engineering defines:

- how it becomes true

Mixing them corrupts both.

---

#### 9. Explicit Requirements vs Specification by Example

Examples are not the specification.

Examples may support:

- discussion
- testing
- stakeholder conversation
- later validation planning

But examples must not be the thing from which the real rule has to be inferred.

##### Why Specification by Example Is Insufficient

Examples are concrete, but they are still incomplete as requirements when they require the reader to infer the governing rule.

That leads to:

- limited scope
- fragile maintenance
- hidden ambiguity
- unclear handling of unspecified cases

##### Producore Position

Examples may illustrate.  
Explicit requirements define.

A valid specification must make the rule, constraint, or transformation explicit enough that additional valid cases can be understood without guesswork.

##### Rationale

Readers should not have to reverse-engineer a formula, decision rule, or behavioral constraint from a handful of examples.

That may be acceptable for exploratory discussion.  
It is not acceptable as the authoritative or implementation-driving requirement surface.

---

#### 10. Analysis as the Core Discipline

The central principle:

> Analysis is not optional. It is the work.

Three systemic failure modes:

- scenarios are not good enough
- scope is not identified
- granularity is incorrect

These are not separate problems.  
They are different expressions of:

> insufficient examination of behavior

##### Why Analysis Is Required

Without analysis:

- missing conditions remain hidden
- implicit assumptions persist
- scope is discovered too late
- implementations diverge

Analysis transforms:

- vague intent -> precise specification
- assumptions -> explicit state
- unknowns -> structured exploration

##### Rationale

The recipes and techniques do not fix problems.

They reveal problems.

Resolution requires expertise.

> Analysis reveals, expertise resolves.

---

#### 11. Dangling Elements Analysis (Internal Consistency)

This technique ensures the scenario is:

- logically complete
- internally connected
- mathematically coherent

##### Definition

Dangling elements are entities or values that are:

- introduced but not used
- used but not introduced
- implying transformation but not defined
- present in a way that misleads the reader about their role in the behavior

##### Full Canonical Method

The canonical six-analysis-step method is:

1. Find and address any Given clauses that imply a transformation but that transformation is not expressly stipulated.
2. Find and address any entities or values introduced in Given clauses that have no influence on the When or Then clauses.
3. Find and address any entities or values introduced in the When clause that should be introduced earlier.
4. Find and address any entities or values introduced in the When clause that have no influence on a Then clause.
5. Find and address any entities or values introduced in the Then clauses that should be introduced earlier.
6. Find and address any Then clauses that imply a transformation from an original state that is not expressly stipulated in the Given or When clauses.

##### What This Enforces

- traceability of all elements
- elimination of ambiguity
- explicit transformation modeling
- balanced beginning-state and end-state relationships
- removal of copy-and-paste holdovers and misleading conditions

##### Example Failure Pattern

A clause like:

- "current day of week is Sunday"

appears in Given but has no influence on the event or outcome.

That is not harmless clutter. It is a defect signal. It may indicate:

- an accidental holdover from a copied scenario
- a missing condition in Then
- a misunderstood rule
- a stakeholder concern that was not properly resolved

##### Rationale

Natural language encourages imprecision.

Dangling Elements Analysis forces:

- discipline
- precision
- completeness

Without it, scenarios are descriptive rather than executable.

---

#### 12. Permutations Analysis (Scope Discovery)

This technique explores the behavioral space around a scenario.

##### Core Principle

Scope is not discovered by brainstorming alone.  
It is discovered by systematic variation.

##### Full Method

1. Identify all parameters in Given.
2. Identify all parameters in When.
3. Identify implied parameters in Then.
4. Generate values and variations for those parameters.
5. Identify meaningful permutations.
6. Process the discovered permutations.

##### What Counts as a Parameter

Anything that can vary:

- values
- presence or absence
- cardinality
- formatting
- combinations
- whether a line exists at all
- whether an actor or condition is present
- whether a setting, locale, date, or environmental factor changes outcome

##### Example Dimensions

- null vs present
- blank vs non-blank
- valid vs invalid
- boundary values
- alternative representations
- interacting conditions
- cardinality changes
- regional or temporal differences
- configuration and setting differences

##### Important Constraint: This Is Heuristic, Not Exhaustive

Permutations Analysis is not a promise that every theoretical combination will be enumerated.

In real systems, the total permutation space is often too large.

The purpose is not exhaustive brute force coverage.  
The purpose is disciplined discovery of meaningful behavioral variation.

Therefore this technique is heuristic by design.

It is used to achieve good enough coverage of the meaningful behavioral space before implementation and before irreversible commitments are made.

##### Processing Outcomes

Discovered permutations do not all become implemented scenarios immediately.

After analysis, each meaningful permutation must be processed into one of the following outcomes:

- create one or more scenarios now
- explicitly defer it
- reject it as out of scope or invalid
- identify it as unknown and requiring stakeholder research or further analysis

##### Rationale

Failure to perform this analysis leads to:

- missed edge cases
- production defects
- unpredictable timelines
- stakeholder misalignment

This technique converts:

- unknown unknowns -> known considerations

---

#### 13. Hidden Events Analysis (Temporal Decomposition)

This technique identifies implicit events within a scenario.

##### Core Insight

Many scenarios are actually:

> compressed sequences of multiple events

##### Symptoms

- scenarios too large
- unclear boundaries
- vague transitions
- difficult to implement
- multiple event meanings hidden in one "When"
- Then clauses that only make sense if intermediate events are silently assumed

##### Full Method

1. Identify implied events in Given.
2. Identify implied events in When.
3. Identify implied events in Then.
4. Construct the event timeline.
5. Split into predecessor scenarios where earlier events must be modeled explicitly.
6. Split into successor scenarios where later events must be modeled explicitly.

##### Timeline Construction

The timeline is not an optional visualization trick.  
It is the mechanism by which the team determines:

- what belongs before the event under analysis
- what belongs in the event under analysis
- what belongs after the event under analysis
- which intermediate transitions are being hidden

When the timeline is made explicit, event boundaries become visible.

##### Predecessor and Successor Factoring

Once hidden events are found, the scenario may need to be decomposed into:

- predecessor scenarios that establish the correct prior state through earlier events
- the focal scenario that handles the event actually under analysis
- successor scenarios that handle later events that occur after the focal outcome

This decomposition can be recursive.  
A predecessor scenario may itself hide earlier events and require additional decomposition.

##### Outcome

- clear event boundaries
- correct scenario decomposition
- accurate behavioral timeline
- scenarios that are implementable at the right granularity

##### Rationale

A scenario must represent:

> one event -> one outcome

Hidden Events Analysis restores that structure.

Without it:

- scenarios become bloated
- behavior becomes unclear
- implementation becomes inconsistent

---

#### 14. Unified Analysis Model

These analysis techniques are not isolated tricks.

They form a unified craftsmanship model.

##### Dangling Elements Analysis

Answers:

- Is the scenario internally connected?
- Are all entities, values, and transformations properly grounded?

##### Permutations Analysis

Answers:

- What meaningful variants of this scenario exist?
- What required scope or behavioral space has not yet been surfaced?

##### Hidden Events Analysis

Answers:

- Is this actually one scenario, or is it a compressed sequence of scenarios?
- Are the temporal boundaries correct?

##### Together

Together, these techniques produce a more complete behavioral model by addressing:

- internal connectedness
- behavioral space
- temporal decomposition

No single technique is enough on its own.

##### Rationale

Teams often apply one technique and assume the scenario is therefore mature.

That is a category error.

A scenario can be internally consistent and still be under-scoped.  
A scenario can cover the right permutations and still hide multiple events.  
A scenario can be the right granularity and still contain dangling elements.

The techniques work together.

---

#### 15. Granularity: The Correct Size of a Scenario

A scenario must represent:

> exactly one meaningful event producing one meaningful outcome

##### Too Large

Indicators:

- multiple implicit use-case steps or hidden events
- high-level declarations ("items are paid")
- unclear boundaries
- multiple business decisions hidden behind one When
- a Then that summarizes an entire use case rather than a single event outcome

Impact:

- over-engineering
- estimation failure
- delayed delivery
- product decisions pushed downstream into engineering

##### Too Small

Indicators:

- trivial fragments that are too small to stand as meaningful behavioral requirements
- implementation leakage
- no meaningful behavior
- mere mechanical fragments that do not stand as stakeholder-reviewable requirements

Impact:

- fragmentation
- loss of coherence
- unreadable requirement sets
- excessive coupling to implementation detail

##### Correct Granularity

A scenario:

- captures one event
- produces one observable outcome
- is fully implementable
- is fully testable
- is still readable by business stakeholders as a meaningful behavioral requirement

##### Scenario vs Use Case

This distinction must remain explicit.

A use case is a broader journey or sequence of use-case steps across time.

A scenario is one behavioral unit inside that broader journey.

A use case may require many scenarios.

A single scenario must not be used to encode an entire use case journey as though it were one event.

##### Terminology Clarification: The Word "Step"

The word `step` is overloaded in ordinary English and in BDD practice. This guide must not use it carelessly.

In Producore BDD work, the following distinctions must remain explicit:

- a **use-case step** is a step in a broader use case or journey
- a **Gherkin clause** is a Given / When / Then / And / But line in the specification text
- an **automation step** or **step definition** is the automation-framework interpretation and binding of a Gherkin clause in tools such as Cucumber, SpecFlow, or Reqnroll
- an **analysis step** is a numbered step in an analysis technique such as Dangling Elements Analysis, Hidden Events Analysis, or Permutations Analysis
- an **execution action**, **setup action**, or **validation action** is an action taken by a human or tool to set up state, trigger an event, or verify an outcome while executing or testing behavior

These are not interchangeable.

This guide should prefer:

- `use-case step` when discussing broader journeys
- `Gherkin clause` when discussing the specification text itself
- `automation step` or `step definition` when discussing automation tooling
- `analysis step` when discussing numbered method steps
- `execution action`, `setup action`, or `validation action` when discussing how a person or tool drives or checks the system

The guide may still use the unqualified English word `step` where the meaning is obvious and no ambiguity is possible, but it must not do so where multiple readings are plausible.

##### Rationale

Granularity determines:

- clarity
- implementability
- predictability

It is not solved by intuition.  
It is solved through:

- Hidden Events Analysis
- disciplined decomposition

---
