
## Producore Canonical Model Definition

This is the single source of truth. Everything else must derive from this.

### State

Canonical Model locked

Do not modify this file again unless:

- a contradiction is discovered during term alignment, or
- a required wording adjustment is forced by the Working Term Discipline Guide

### Editing Rules

1. Do not use text embellishments like bold or italics because it complicates text-based searching and causes false negatives (not found but it does exist, just in an embellished format).
2. Use properly nested ATX headers and `- ` style unordered list items, not `* `. Fix any deviations from this.
3. This file must at all times accurately reflect the correctly synthesized current Canonical Model Definition based on the exact current text pasted for review.
4. Edits may not be made based on remembered or inferred content instead of the exact current state.
5. For every step that involves reviewing, correcting, refining, or aligning this file, the AI assistant must first ask to have the exact current text from this file paste before it suggests any changes.

---

### 1. Two Distinct but Connected Systems

The system operates through two distinct but connected structures:

#### A. Solution Discovery (Selection and Understanding)

This determines what problems are addressed and what must be supported.

#### B. Solution Realization (Composition and Execution)

This determines how those problems are solved through capabilities and implementation.

These are not interchangeable and must not be conflated.

---

### 2. Solution Discovery Model

Solution discovery is the process of selecting and understanding the problem space and determining what will be supported.

It operates across the following structure:

```
Problem Space
   ↓
Use Cases (ways the problem is solved)
   ↓
Steps (actions within use cases)
   ↓
Scenarios (conditions under which steps occur)
   ↓
Scenario Selection (now / later / never, stakeholder-informed and stakeholder-consented)
   ↓
Supported Scenarios
```

Key properties:

- This structure is exploratory and selective
- It determines scope, not structure
- It identifies where capabilities are required and which capabilities must be brought into scope, but does not define their identity

---

### 3. Solution Realization Model

Solution realization is the structural realization of the selected scope through capabilities and their specified behavior.

```
Capabilities
   ↓
Specified Behavior (expressed through capability-level scenarios and persisted in PKB)
   ↓
Implementation
```

Key properties:

- This structure is structural and stable
- Capabilities are independent abilities required for intended outcomes
- Specified Behavior is the authoritative definition of how a capability must operate under conditions
- Implementation realizes, but does not define, capability and remains free to innovate within specified behavioral conditions and constraints

---

### 4. Relationship Between Discovery and Realization

The two systems are connected through scenario selection and specified behavior:

- Discovery identifies scenarios that must be supported
- These scenarios:
  - map to capabilities
  - refine or extend their specified behavior
  - are constrained by existing capability definitions and boundaries
  - are governed by stakeholder-informed and stakeholder-consented selection

Crucially:

Discovery reveals where capability is required.
It does not define what the capability is.

#### Construction and Continuity Chain

The relationship between Discovery, Realization, and the PKB must also be understood as a continuity chain through which product knowledge is surfaced, clarified, selected, refined, and preserved.

At the system level, that chain is not merely a sequence of disconnected artifact types. It is a connected progression in which broader solution understanding is made increasingly explicit without collapsing the distinction between Discovery and Realization.

A simplified view of that chain is:

```text
Problem Framing
   ↓
Solution Intent
   ↓
Use Cases / Journeys
   ↓
Meaningful Steps / Actions within those journeys
   ↓
Capability need becomes visible through those steps / actions
   ↓
Hidden or explicit event boundaries tied to that step/action chain
   ↓
Scenarios that express, decompose, refine, and select support for those boundaries
   ↓
Capabilities recognized, brought into scope, and, where necessary, dependent capabilities revealed
   ↓
Specified Behavior
   ↓
Implementation
```

This chain does not redefine the distinction between Discovery and Realization.

It makes explicit how the system's knowledge moves:

- Use cases and journeys express broader paths by which problems are solved
- Steps express meaningful actions within those paths
- Those meaningful steps/actions reveal where enabling ability is required
- Hidden Events Analysis may clarify that a conflated scenario is actually compressing distinct event boundaries tied to that chain of steps
- Scenarios express those event boundaries as discrete behavioral units and support their decomposition, refinement, selection, and governed specification
- Capabilities are the required possibilities that must be supported across contexts for those steps and event boundaries to be supported
- Discovery artifacts may reveal Capability need and may expose dependent Capability need, but they do not define Capability identity
- Realization structurally realizes the selected need through Capability and Specified Behavior
- The PKB preserves the continuity of that knowledge, including the decisions and rationale that connect one part of the chain to another

The chain must not be collapsed.

In particular:

- Discovery artifacts do not define Capability identity
- Use cases, steps, actions, and event boundaries may reveal Capability need without defining what the Capability is
- A scenario is not an entire use case journey; it is a discrete behavioral unit within that broader journey
- Scenarios are not detached from steps; they are the behavioral refinement of the step/event chain under conditions
- Specified Behavior defines how a Capability must operate under conditions
- Implementation does not define Behavior
- The PKB is not a downstream container for completed outputs; it is the continuity layer through which the system preserves what was identified, clarified, selected, realized, and decided

---

### 5. Capability Independence

A Capability:

- is defined by what must be possible for required outcomes to be achieved
- is defined through the specified behaviors it must support
- is not defined by:
  - a specific solution
  - a use case
  - a step
  - a sequence

Capabilities may be:

- discovered through solutions
- exercised through use cases
- refined through scenarios

Their identity must remain stable across contexts, even as their behavioral expression is clarified and extended through use.

---

### 6. Non-Linear Entry and Context Reconstruction

Work does not always begin at the problem level.

It may begin at:

- a problem
- a use case
- a step
- a requested feature or behavior

Regardless of entry point:

The full context must be reconstructed before correct decisions can be made.

This means:

- A step must be understood within its use case
- A use case must be understood within the problem space
- Scenarios must be evaluated against stakeholder expectations
- The problem context must be reconstructed to determine correct scope selection
- Scenario selection must still be governed by stakeholder expectations and consent

Without reconstruction:

- incorrect scope is selected
- incorrect behavior is defined
- incorrect capabilities are created or modified

---

### 7. Capability Network Structure

Capabilities form a network, not a tree:

- They are reused across solutions
- They depend on one another
- They may appear in multiple contexts simultaneously

Hierarchical views are:

- valid for navigation
- invalid as a definition of structure

A Capability's placement within any structure is a matter of navigation and usage, not definition. Identity remains singular even when placement varies.

---

### 8. Governance Implication

Because capabilities are independent and shared:

- They must be actively managed
- Their definitions must be preserved
- Their specified behavior must remain consistent across contexts

This requires:

- explicit ownership of capability definition
- cross-context coordination
- prevention of duplication and drift
- preservation of definitions and decisions within the PKB

---

### 9. Knowledge Preservation as a First-Class System Concern

Both solution discovery and solution realization are not just processes. They are knowledge-generating activities that must be explicitly captured and preserved.

This occurs through the PKB.

---

### 10. PKB as the System of Record for Discovery and Realization

The PKB stores:

#### A. Solution-Level Knowledge (Discovery + Strategic Decisions)

At the Solution / Initiative level, the PKB must capture:

- problem framing
- use cases and flows
- steps and scenarios identified and evaluated
- explicit record of selection decisions across scenarios and scope
- what is:
  - selected
  - postponed
  - rejected
- why those decisions were made
- stakeholder context and expectations

This ensures:

Discovery is not lost, reinterpreted, or recreated inconsistently.

---

#### B. Capability-Level Knowledge (Realization + Structural Decisions)

At the Capability level, the PKB must capture:

- capability definition and responsibility boundary
- capability-level scenarios and specified behavior rules
- variations and constraints
- dependencies
- design decisions, including:
  - alternatives considered
  - tradeoffs
  - reasons for selection

This ensures:

Capability behavior and structure remain coherent and evolvable.

---

### 11. Decision and Rationale as First-Class Artifacts

The system does not only preserve:

- what was decided

It must preserve:

- why it was decided

Because:

- future changes depend on prior reasoning
- capability evolution requires understanding tradeoffs
- AI-assisted systems must reason over intent, not just outcomes

If rationale is lost:

- decisions degrade into guesswork
- capabilities drift
- behavior fragments

---

### 12. Role-Based Interaction with the Same System

This clarifies something important you said:

You are not describing two systems. You are describing two roles interacting with the same system at different structural levels.

#### Solution Manager (Discovery focus)

- operates at solution / initiative level
- defines scope through selection decisions
- captures business context and decisions

#### Capability Manager (Realization focus)

- operates at capability level
- defines and governs specified behavior within the constraints of capability
- captures structural and behavioral decisions

Both:

- write to the same PKB
- preserve different layers of meaning
- must remain aligned

---

### 13. Updated Relationship (Discovery ↔ Realization ↔ PKB)

The corrected model is:

```
Solution Discovery
   ↓
(Selection + Decisions + Rationale)
   ↓
[Persisted in PKB — Solution Layer]

   ↓ (drives capability definition and refinement)

Capability Realization
   ↓
(Specified Behavior + Decisions + Rationale)
   ↓
[Persisted in PKB — Capability Layer]

   ↓

Implementation
```

This is critical:

The PKB is not downstream of the system.
It is the system's memory and continuity layer.

---

### 14. Implication for AI-Assisted Work

This unlocks something major:

AI must not only:

- read capabilities
- read scenarios

It must also:

- read decision history
- understand why constraints exist
- respect prior tradeoffs
- reconstruct context before producing outputs

Otherwise:

AI will optimize locally and break global system integrity.

---

### Final Canonical Statement

A system is formed by selecting which problems and scenarios to support, and realizing those selections through a stable network of capabilities whose specified behavior is explicitly defined and preserved across contexts. Discovery determines scope through stakeholder-informed and stakeholder-consented selection. Capabilities determine structure. Specified behavior determines correctness. Decisions and their rationale preserve continuity.

---
