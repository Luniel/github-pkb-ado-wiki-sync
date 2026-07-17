# PCEOOD / PKBDD BDD-Codex Guardrails

Use these guardrails when BDD automation is ordered from Codex.

## Authority stack

Preserve the downstream chain:

```text
Capability -> Behavior -> Specification -> Implementation -> Tests / Automation
```

Rules:

- Implementation must not define behavior.
- Tests must not define behavior.
- Automation bindings must not infer missing behavior.
- Source code and current implementation are evidence for feasibility and mechanics, not product authority.
- If implementation and specification diverge, specification governs unless the specification is formally superseded through the appropriate lifecycle.

## Governance preflight

For BDD automation work, repo-local governance files are mandatory:

```text
AGENTS.md
CODEX_WORKFLOW_SOP.md
PCEOOD/01 - README.md
PCEOOD/09 - Producore Canonical Guide - Producore Engineering Doctrine.md
.agents/skills/pceood-bdd-craftsmanship/SKILL.md
```

Codex must also read all references required by the repo-local BDD craftsmanship skill.

If any required governance file cannot be loaded, stop and report. Do not proceed under fallback governance. Do not let Codex or ChatGPT decide that prompt-only governance is sufficient for BDD automation work.

## BDD meaning

Treat valid Gherkin as a deterministic mapping:

```text
Given state + When event -> Then resulting state
```

For automation:

- Given arranges explicit state only.
- When triggers the event under evaluation.
- Then observes the resulting state or approved evidence surface.
- Bindings must not create the evidence they later assert.
- Hidden implementation choreography in a When clause is a defect unless the choreography itself is the behavior.

## Collaboration posture

Do not force source automation to satisfy text at all costs.

Use Engineering friction as feedback into shared understanding. Decide whether to:

- keep the scenario executable as-is;
- implement with an approved test-side seam;
- narrow or phase executable coverage;
- move a scenario to PKB-only / Seam-only / manual validation for now;
- revise PKB Gherkin or maturation notes before automation;
- bring a concrete question to Engineering.

## Product / Engineering boundary

Product and behavioral specification authors must avoid pushing missing behavior definition into Engineering. Engineering and QA may challenge ambiguity and weak specification, but they must not silently become behavior authors through code, tests, or automation bindings.

## Required stop conditions

Stop before producing an implementation prompt if:

- exact approved wording cannot be supported;
- required governance cannot be loaded;
- the required proof path is ambiguous;
- automation would require production behavior changes not explicitly authorized;
- the test seam would define behavior instead of observing behavior;
- a test would validate incidental representation rather than specified behavior;
- Codex would need to choose product meaning, lifecycle status, or Engineering architecture boundary.
