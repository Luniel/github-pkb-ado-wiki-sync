# Producore Local Drafting Overrides

## Purpose

These rules exist to suppress fallback to generic BDD norms when drafting Producore behavioral specifications.

Use this file whenever:
- a draft feels generally acceptable but not fully Producore-shaped
- a scenario has been compressed into prose
- repeated assertions have been simplified away
- actor-centered or narrative wording has replaced stronger object-state formulations
- the user has shown a preferred Producore scenario shape and the current draft drifts away from it

## Mandatory Override

- Do not optimize for generic Gherkin quality.
- Optimize only for Producore-local craftsmanship quality.
- If a drafting choice could be resolved by either generic BDD practice or a Producore-local pattern, choose the Producore-local pattern.
- A draft is non-compliant if it is merely broadly acceptable under mainstream BDD but weaker than the strongest Producore-consistent formulation available.
- Do not normalize, paraphrase, simplify, or "clean up" a scenario merely because the result would be shorter, more idiomatic, or more familiar in general BDD.

## When This Override Matters Most

Apply this override especially when deciding between:

- explicit state expression vs prose compression
- object-first wording vs actor-first wording
- structured field assertions vs conversational paraphrase
- repeated end-state assertions vs brevity
- explicit cardinality constraints vs implied non-duplication
- explicit identity continuity vs implied continuity
- explicit review or status assertions vs softened natural-language summaries

## Non-Compliant Drift Patterns

Treat the following as drift signals:

- replacing explicit field tables with prose summaries
- replacing object-state or relationship assertions with looser descriptive language
- removing repeated assertions that materially constrain identity, continuity, non-creation, non-duplication, or cardinality
- introducing actors when the actor is not behaviorally necessary
- rewording a user-provided Producore-shaped example into more mainstream Gherkin phrasing
- preferring "cleaner" language that makes the scenario easier to read but weaker as a behavioral contract
- treating a formulation as good enough because it would pass in ordinary BDD review

## Correction Rule

When drift is found:

1. Identify the stronger Producore-consistent form available from:
   - the Producore corpus
   - the user's demonstrated preferred shape
   - a more explicit stateful or relational formulation
2. Replace the weaker wording with the stronger wording.
3. Re-check whether the stronger wording improves:
   - explicitness
   - traceability of elements
   - transformation visibility
   - identity continuity
   - cardinality visibility
   - resistance to reader inference
4. Keep the stronger wording even if it is less conventional in mainstream BDD.

## Priority Order for Tie-Breaking

When two formulations are both plausible, prefer the one that is:

1. more explicitly grounded
2. less inferential
3. more structurally connected across Given, When, and Then
4. more faithful to the user's demonstrated Producore-local shape
5. more resistant to generic BDD normalization
6. more concise only after the above conditions are satisfied

## Anti-Drift Pass

Before returning results, perform this check explicitly:

1. Identify every place where the current draft may have been influenced by generic BDD instincts or mainstream acceptable practices.
2. For each place, ask:
   - Is there a more explicit Producore-consistent formulation?
   - Did I paraphrase structured state into prose?
   - Did I remove repetition that materially preserved the contract?
   - Did I introduce an actor or narrative framing that is not required?
   - Did I choose a generally acceptable wording instead of the strongest Producore-local wording?
3. Replace any such wording or structure.
4. Do not return the draft until this pass is complete.

## Review Question

Before finalizing, ask:

- Is this the strongest Producore-consistent formulation available, or merely one that would be acceptable under general BDD?

If the answer is the latter, revise.