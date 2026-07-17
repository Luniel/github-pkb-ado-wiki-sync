
## Producore Canonical Note — Defect Analysis Through Current-State Specification

### Status

Canonical applied note.

This note defines an applied method for defect analysis and current-state clarification.

It derives from:

- Canonical Definition Guide - Behavior System  
- Canonical Guide - PKBDD Operating Doctrine  
- Canonical Guide - Producore Engineering Doctrine  

It does not define new ontology, new authority rules, or new lifecycle mechanics.

---

### 1. Purpose

This note defines how to analyze defects and unclear current behavior without collapsing:

- observed behavior  
- implemented behavior  
- current-state specified behavior  
- target-state specified behavior  

Its purpose is to prevent a recurring structural error:

- treating what the system currently does as equivalent to what the system should do  

This method applies in defect remediation, but is also useful for:

- onboarding unknown systems  
- reverse engineering  
- legacy system understanding  
- debugging beyond defects  
- validating behavioral assumptions  

---

### 2. Scope Boundary

This note does not define:

- what Behavior is  
- what makes Behavior authoritative  
- what makes a specification binding  
- new forms of Behavior  
- new lifecycle states or transitions  

Those concerns remain governed by higher canonical sources.

This note defines only how the existing canonical distinctions are applied when current system behavior must first be made explicit before it can be evaluated or corrected.

---

### 3. Core Distinction

Observation does not define normative Behavior.

Implemented Behavior does not define normative Behavior.

Current-state specification may be used to express what the system currently does.

That current-state specification is not, by itself, a statement of what the system should do.

Therefore:

- current behavior may need to be specified before it can be judged  
- current-state specification and target-state specification must remain distinct  
- defect analysis must not collapse descriptive clarity into normative approval  

---

### 4. Relevant Applied Forms

This note applies the canonical distinctions to defect analysis through the following working forms.

#### 4.1 Observed Behavior

Observed Behavior is what someone perceives or measures from the system.

It is:

- perspective-dependent  
- incomplete  
- non-authoritative  

Observed Behavior is evidence.

It is not definition.

---

#### 4.2 Implemented Behavior

Implemented Behavior is what the system is actually doing.

It is:

- objective system reality  
- potentially different from what is observed  
- potentially different from what is expected  
- non-authoritative  

Implemented Behavior may be correct or defective.

Its existence does not make it normative.

---

#### 4.3 Current-State Specified Behavior

Current-State Specified Behavior is a specification that accurately expresses current Implemented Behavior.

It is:

- derived through observation, analysis, and confirmation  
- used to make present system behavior explicit  
- validated against the current system  
- descriptive, not automatically normative  

Its role is clarification.

It answers:

- what is the system actually doing?  

It does not answer:

- what should the system do?  

A Current-State Specified Behavior does not become binding merely because it accurately captures current implemented behavior.

If behavior captured through this method is later to become binding, that must occur through a separately governed Specification progressing through PKBDD lifecycle to `Current`.

That adoption is outside the scope of this note.

This method does not introduce a third authority category between `Current` and non-binding target-state specifications.

A current-state specification may be analytically necessary even when the current implemented behavior is later adopted as the correct binding contract.

In such a case, the method surface and the later binding lifecycle outcome remain distinct, even if their behavioral content converges.

---

#### 4.4 Target-State Specified Behavior

Target-State Specified Behavior is the specification that defines the behavior the system should implement.

It is:

- aligned to Expected Behavior  
- intended to govern corrective realization  
- normative once governed through the proper authority model  

Its role is correction.

It answers:

- what should the system do instead?  

---

### 5. Method

#### 5.1 Step 1 — Observe the Problem

Start from Observed Behavior.

Use observation as evidence only.

Do not treat observation as authoritative definition.

At this stage, the problem is only that something appears wrong, unclear, unexpected, or disputed.

That appearance must not yet be treated as sufficient proof of either current reality or correct target behavior.

---

#### 5.2 Step 2 — Derive Current-State Specification

Create Current-State Specified Behavior that accurately expresses current Implemented Behavior.

This work must continue until the specification is clear enough to be checked against the existing system and confirmed as an accurate expression of what the system currently does.

At that point:

- Current-State Specified Behavior aligns with Implemented Behavior  

This step is necessary whenever current behavior is unclear, disputed, poorly understood, or only partially observable.

Without this step, remediation work risks targeting guesses rather than defined current reality.

---

#### 5.3 Step 3 — Define the Target-State Specification

Create Target-State Specified Behavior that defines the correct behavior the system should implement.

This work must continue until the intended behavior is explicit enough to be approved, governed, and used as the basis for corrective realization.

At that point:

- Target-State Specified Behavior aligns with Expected Behavior  

This step must remain distinct from current-state clarification.

The target state is not discovered merely by observing the present system.

It must be explicitly defined.

---

#### 5.4 Step 4 — Implement the Correction

Implement the target-state specification so that Implemented Behavior is brought into alignment with it.

Corrective work is complete only when the system no longer merely matches the clarified current state, but instead conforms to the approved target-state specification.

---

### 6. Alignment Logic

Current-state clarification and target-state correction answer different questions.

Current-State Specified Behavior answers:

- what is the system actually doing?  

Target-State Specified Behavior answers:

- what should the system do instead?  

These must never be collapsed.

If they are collapsed:

- current defects may be mistaken for correct behavior  
- target behavior may be asserted without understanding current reality  
- implementation changes may be made against an undefined baseline  

---

### 7. Use Cases for the Method

This method should be used when any of the following is true:

- current system behavior is unclear  
- observed behavior is disputed  
- legacy behavior exists without a valid specification  
- defect correction requires a stable definition of current reality before target correction can be designed  
- behavioral assumptions need to be validated before further engineering work proceeds  

This method is especially important when multiple people are inferring different meanings from the same observed system behavior.

---

### 8. Prohibitions

Do not:

- treat Observed Behavior as normative Behavior  
- treat current Implemented Behavior as correct merely because it exists  
- treat Current-State Specified Behavior as Target-State Specified Behavior  
- skip current-state specification when the current behavior is unclear  
- infer target behavior directly from current implementation  
- collapse descriptive clarification into behavioral approval  

---

### 9. Authority Boundary

This note does not make any specification authoritative.

It only describes how specifications may be used in analysis.

Whether a current-state or target-state specification is binding is determined only through the PKBDD Operating Doctrine.

Therefore:

- current-state specification may be analytically useful without being normative  
- target-state specification must still be governed before it becomes binding  
- this note provides analysis method, not authority  

---

### 10. Invariant

A defect can only be corrected reliably when:

- current Implemented Behavior is made explicit through Current-State Specified Behavior  
- target behavior is made explicit through Target-State Specified Behavior  
- the distinction between those two specifications remains clear  

If current-state and target-state specification are collapsed, defect analysis loses its structural integrity and correction becomes guesswork.
