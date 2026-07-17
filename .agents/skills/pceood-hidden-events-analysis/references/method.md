# Method: Hidden Events Analysis

## Objective
Ensure each scenario expresses one bounded primary event.

## Steps
1. Locate the declared event in `When`.
2. Scan Given for buried predecessor events masquerading as state history.
3. Scan Then for successor events or temporal progression language.
4. Mark evidence of event-chain compression (and/then/after/eventually/starts/finishes).
5. Derive candidate event boundaries as separate behavioral units.
6. Recommend split map (analysis only):
   - predecessor event scenario(s)
   - focal event scenario
   - successor event scenario(s)

## Severity guidance
- Multi-event compression requiring interpretation => hard_fail.
- Temporal leakage in Then => major_defect.
