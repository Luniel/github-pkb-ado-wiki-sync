
## Producore Canonical Guide - Capability Structure Design Framework

### Status

Canonical. Normative. Binding within the Producore Canonical Engineering Ontology and Operating Doctrine.

This document defines how capabilities are placed, promoted, and evolved within the system.

It operates strictly as a placement and evolution framework.

---

### 1. Scope and Role

This guide defines:

- how capabilities are placed across structural layers  
- when capabilities should be promoted or elevated  
- how placement evolves over time  
- how to recognize valid reuse and structural pressure  

This guide does not define:

- what a Capability is (see Capability System)  
- how behavior is assigned to capabilities (see Capability Structuring and Authority Doctrine)  
- how specifications become authoritative (see PKBDD Operating Doctrine)  

All placement decisions must respect those upstream constraints.

---

### 2. Core Principle

Capability identity is independent of placement.

Placement is:

- a management decision  
- a reflection of current scope of use  
- a reflection of reuse and maturity  

Placement must not:

- define capability meaning  
- alter behavioral ownership  
- imply authority  

Invariant:

A capability remains the same capability regardless of where it is placed.

---

### 3. Structural Layers

Capabilities may be placed in three structural layers.

These layers represent scope of use and reuse maturity, not different kinds of capability.

---

#### 3.1 Product Capability (Local)

A capability placed within a single product or solution.

Characteristics:

- used by one product  
- responsibility is expressed within that product context  
- reuse has not yet emerged  

---

#### 3.2 Shared Product Capability

A capability used across multiple products within a solution space or platform.

Characteristics:

- reused by multiple products  
- behavior is substantively the same across those products  
- maintained as a single authoritative capability  

---

#### 3.3 Business Capability

A capability representing enduring business ability independent of any specific product.

Characteristics:

- persists across products and implementations  
- expresses stable business-level responsibility  
- not tied to a single system realization  

---

### 4. Placement Decision Framework

#### 4.1 Step 1 — Validate Capability Integrity

Before placement, confirm:

- the capability satisfies all structural rules (see Capability System and Structuring Doctrine)  
- its responsibility is clear and bounded  
- behavior can be assigned to it without ambiguity  

If this is not satisfied, placement must not proceed.

---

#### 4.2 Step 2 — Determine Scope of Use

Evaluate current usage:

- is the capability used by one product?  
- is it used by multiple products?  
- is reuse actual or only anticipated?  

Placement must reflect current reality, not expectation.

---

### 5. Placement Rules

#### 5.1 Rule — Keep Local

Place a capability at the product level when:

- it is used by a single product  
- its responsibility is tightly scoped to that product  
- reuse has not yet emerged  

Rationale:

Premature generalization weakens boundaries and introduces ambiguity.

---

#### 5.2 Rule — Promote to Shared Product Capability

Promote a capability when all conditions are true:

1. it is used by two or more products  
2. the responsibility is substantively the same across those products  
3. behavior can be unified without contradiction  
4. maintaining separate instances introduces duplication or drift  
5. a single definition preserves clarity  

After promotion:

- the shared capability becomes the single authoritative location  
- products must reference it rather than redefine it  

---

#### 5.3 Rule — Elevate to Business Capability

Elevate a capability when all conditions are true:

1. it represents enduring business ability  
2. it remains valid independent of any specific product  
3. it persists across product or system changes  

Test:

If all current implementations were replaced, would the capability still exist?

- if yes, it is a candidate for business-level placement  
- if no, it remains product or shared-product level  

---

### 6. Promotion and Evolution

Capabilities evolve through structural pressure:

Product → Shared Product → Business

This evolution is:

- not mandatory  
- not automatic  
- driven by actual reuse and stability  

A capability must earn promotion through demonstrated need.

---

### 7. Anti-Patterns

The following are structural errors:

---

#### 7.1 Premature Promotion

Promoting a capability before reuse is real.

Result:

- weak abstraction  
- unclear boundaries  
- low adoption  

---

#### 7.2 Duplicate Capabilities

Multiple capabilities representing the same responsibility across products.

Result:

- behavioral inconsistency  
- drift  
- loss of structural coherence  

---

#### 7.3 Product-Driven Identity

Allowing product context to define capability meaning.

Result:

- instability  
- violation of capability independence  

---

#### 7.4 Forced Unification

Combining capabilities that do not share a coherent responsibility.

Result:

- loss of clarity  
- ambiguous behavior  

---

### 8. Structural Inheritance

All placement decisions must respect:

- capability identity (Capability System)  
- behavioral ownership and exclusivity (Structuring Doctrine)  
- specification authority (PKBDD)  

This framework does not override those rules.

It operates within them.

---

### 9. Governance Implication

Capability management must:

- monitor reuse across products  
- detect duplication and drift  
- trigger promotion when conditions are met  
- prevent premature abstraction  

Without governance:

- capabilities fragment  
- reuse becomes inconsistent  
- structure degrades  

---

### 10. Operational Interpretation for AI Systems

AI agents must:

- treat placement as non-authoritative for identity  
- determine placement based on actual usage, not speculation  
- avoid introducing shared capabilities without evidence of reuse  
- detect duplicate capabilities across products  
- recommend promotion only when conditions are satisfied  

If reuse is unclear, default to local placement.

---

### 11. Final Assertion

If placement:

- defines capability meaning,  
- precedes demonstrated reuse,  
- or forces abstraction without structural need,  

then the structure is invalid and must be corrected.

---
