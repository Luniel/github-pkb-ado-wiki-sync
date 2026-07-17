
## Producore Canonical Definition Guide — Capability System

### 1. Core Principle

A Capability defines an ability that must exist for required outcomes to be achieved, independent of how that ability is realized.

Capability is the structural anchor of intent. Behavior depends on it. Implementation realizes it while remaining free to innovate within specified behavioral conditions and constraints.

---

### 2. Foundational Definition

#### Capability

A Capability defines what must be possible in order to achieve required outcomes.

A Capability is:

- an ability required for an intended outcome  
- independent of any single Implementation  
- defined by responsibility rather than organizational or technical convenience  
- structurally connected to other Capabilities  
- the anchor for Behavior  

A Capability is not:

- a feature  
- a component or service  
- a team or organizational boundary  
- a project or delivery unit  
- an Implementation artifact  


The underlying ability may belong to a business, product, service, user, customer, stakeholder, team, operation, software system, hardware system, material, technical mechanism, or other solution context.

Not every implementation detail is a Capability. A lower-level concern becomes a Capability when it must be governed as an ability that can carry behavior, responsibility, variation, substitution, or future change.

A Capability gives that required possibility a governed structural home so its responsibility, behavior, relationships, and realization can be preserved over time.

When realized, a Capability enables someone or something to accomplish, perform, maintain, or otherwise achieve what the required outcome depends on.

Before realization, a Capability is not yet an operating fact. It is a required possibility that has been identified, defined, and governed, but not yet made real through implementation or operational means.

---

### 3. Structural Properties of Capability

#### 3.1 Independence from Implementation

A Capability must remain stable as Implementations change.

If it changes due to Implementation, it is incorrectly defined.

---

#### 3.2 Clear Responsibility Boundary

A Capability must have a coherent boundary.

Its responsibility must remain stable and understandable across contexts.

---

#### 3.3 Enduring Functional Intent

A Capability represents an enduring required possibility, not temporary work.

---

#### 3.4 Structural Connectedness

Capabilities exist within a network of dependencies.

They must be defined in a way that preserves these relationships.

---

#### 3.5 Scenario-Relevant Realization

A Capability is not a scenario.

It enables Behavior across scenarios.

---

#### 3.6 Recursive Composition

Capabilities may be composed of or decomposed into other Capabilities.

This composition must:

- preserve behavioral coherence  
- maintain structural boundaries  
- not be driven by Implementation, organization, or convenience  

---

#### 3.7 Independence from Discovery Artifacts

Capabilities may be identified through analysis of problems, use cases, user journeys, step sequences, or solution scope.

These artifacts do not define Capability identity.

A Capability is defined by what must be possible for required outcomes to be achieved and must remain independent of:

- specific use cases  
- step sequences or flows  
- solution decomposition  
- product or feature framing  

Discovery artifacts may reveal which Capabilities are relevant or must be realized.

They must not be used to define what a Capability is.

Solution scoping determines which Capabilities are brought into scope for realization. It does not determine Capability identity, boundaries, or meaning.

---

### 4. Capability and Behavior

- Capability defines what must be possible  
- Behavior defines what must occur under conditions  
- Implementation defines how that is realized  

This relationship is directional:

- Capability constrains what Behavior must exist  
- Specified Behavior constrains Implementation  

This relationship is not reversible.

---

### 5. Capability and Specification

Capability does not directly define Specified Behavior.

Specified Behavior is defined through an Authoritative Contract Artifact (see: Behavior System).

A Capability:

- anchors Behavior  
- constrains what Behavior must exist  
- defines the scope within which Behavior is valid  

A Capability must be defined such that:

- Behavior can be explicitly specified  
- Behavior can be evaluated for correctness  
- Behavior can be expressed as governed specification  

---

### 6. Capability as Structural Continuity

Capability is the unit through which meaning remains stable as work moves.

Without Capability:

- Behavior loses its anchor  
- meaning fragments  
- Implementation becomes a competing source of truth  

---

### 7. Capability Change

Capabilities may evolve only when the required outcome, responsibility, or underlying intent changes.

Valid reasons:

- stakeholder needs change  
- business rules change  
- system obligations change  

Invalid reasons:

- architecture changes  
- team structure changes  
- technology changes  

---

### 8. Capability Management

Capability Management is required for the system to remain structurally coherent over time.

Without Capability Management:

- Capability definitions will drift  
- boundaries will degrade  
- Behavior will lose alignment  
- Implementation will become a competing source of truth  

Capability Management:

- maintains definition authority  
- preserves Capability boundaries  
- ensures alignment between Capability and Behavior  
- ensures that Specified Behavior is defined through governed artifacts  
- maintains structural coherence across Capabilities  

Capability Management must align to Capability structure—not organization or Implementation.

---

### 9. Structural Tests

A Capability is invalid if:

- it changes with Implementation  
- it reflects how something is built  
- it cannot anchor Behavior  
- Specified Behavior cannot be explicitly defined for it  
- it is fragmented by system structure  

---

### 10. Invariant

Without correctly defined Capabilities:

Behavior cannot remain coherent.  
Specified Behavior cannot be properly defined.  
Meaning cannot persist.  
The system will fragment.

---
