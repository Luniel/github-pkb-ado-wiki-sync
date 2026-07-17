---
name: pceood-dangling-elements-analysis
description: perform technique-specific dangling-elements analysis for bdd scenarios, scenario templates, behavior specifications, connected specification sets, and repo-backed analysis to detect ungrounded elements, unused elements, and implied transformations before drafting.
---

# PCEOOD Dangling Elements Analysis

## Purpose
Use this skill for analysis-only evaluation of BDD scenarios, Scenario Templates, behavior specifications, and connected specification sets, including repo-backed analysis when behavior evidence spans multiple files.

## Authority Boundary

This skill performs analysis only.

It does not:
- decide capability identity
- decide structural ownership
- decide lifecycle state
- confer binding authority
- select implementation scope
- produce final PKB-ready behavioral specifications unless invoked through a broader drafting workflow

Findings must be treated as candidate analysis outputs.

Every candidate must be processed into one of:
- current-spec correction
- candidate scenario
- deferred scope decision
- rejected concern
- upstream dependency concern
- downstream realization concern
- additional aspect candidate
- support artifact / decision note
- open research question


## Multi-Spec Analysis Mode

When the input includes multiple files, repo paths, or related specifications:

1. Identify the primary specification under analysis.
2. Identify supporting specifications and support artifacts.
3. Identify source/consumer relationships between specs.
4. Do not treat support artifacts as behavior specifications.
5. Do not move upstream-owned behavior into the current specification.
6. Classify findings by likely owner.
7. Preserve cross-spec dependency questions explicitly.

A missing condition in the current specification may indicate:
- a defect in the current specification,
- missing behavior in an upstream dependency,
- a valid out-of-scope concern,
- a support-artifact clarification need,
- or a stakeholder research question.

Do not assume all missing conditions belong in the current scenario.


## Guardrails
- Do not draft final replacement scenarios in this skill.
- Do not inject implementation mechanics.
- Preserve traceability evidence for every finding.

## Output
Return analysis only using `references/output-contract.md`.
