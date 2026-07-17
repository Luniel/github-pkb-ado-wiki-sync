# Method: Dangling Elements Analysis

Run this six-step pass strictly in analysis mode:

1. Find Given clauses that imply a transformation not explicitly stipulated.
2. Find entities/values introduced in Given that do not influence When or Then.
3. Find entities/values introduced in When that should be introduced earlier.
4. Find entities/values introduced in When that do not influence Then.
5. Find entities/values introduced in Then that should be introduced earlier.
6. Find Then clauses that imply a transformation from an original state not stipulated in Given/When.

## Classification
For each finding, classify as one of:
- `ungrounded_element`
- `unused_element`
- `implied_transformation`
- `misplaced_introduction`

## Severity
- `hard_fail`: interpretation or invention would be required.
- `major_defect`: structural weakness blocks safe downstream use.
- `drift`: non-preferred but recoverable shape.
