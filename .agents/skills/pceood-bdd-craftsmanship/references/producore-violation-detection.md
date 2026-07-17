# Producore Violation Detection

This reference defines explicit Producore craftsmanship violations that must be identified before final drafting, review approval, or validation.

## Core Rule

The main BDD craftsmanship skill must compile a Producore Violation Inventory during early analysis and must fail final validation if blocking violations remain unresolved.

The skill must not silently repair violations without reporting them. If a scenario contains a hardcoded literal such as an invoice number, order ID, user ID, UUID, timestamp, email address, database ID, or other fixture-like value, the skill must explicitly report the original violation before proposing a corrected abstraction.

## Output: Producore Violation Inventory

Use this shape when violations are present:

| Severity | Violation | Evidence | Why it violates Producore | Required correction |
|---|---|---|---|---|

Severity values:
- `blocking`
- `major`
- `minor`
- `watch`

A `blocking` violation prevents a spec from being treated as implementation-ready, promotion-ready, or validated as Producore-compliant.

## Violation: Example or Fixture Literal Used as Requirement

A scenario violates Producore craftsmanship when it uses a concrete literal value as though that value defines the behavior, unless the literal is itself the governed domain rule, configured identity label, required output, boundary value, or behavior under analysis.

Suspicious hardcoded literals include:
- invoice numbers
- order numbers
- claim numbers
- user IDs
- account IDs
- UUIDs
- database IDs
- email addresses
- timestamps
- arbitrary dates
- monetary amounts
- arbitrary counts
- addresses
- phone numbers
- product SKUs
- route fragments
- magic strings
- sample names
- fixture-only values

Example violation:

```Gherkin
Given invoice "INV-12345" exists
When invoice "INV-12345" is submitted
Then invoice "INV-12345" is marked as paid
```

Why it fails:
- `INV-12345` is fixture data masquerading as behavior.
- The scenario specifies one example instance instead of the governing rule.
- Future automation may accidentally bind to a sample value.
- The reader may infer that the specific number, number format, or sample instance matters.

Preferred correction:

```Gherkin
Given invoice [SubjectInvoice] exists
When invoice [SubjectInvoice] is submitted
Then invoice [SubjectInvoice] is marked as paid
```

If invoice number matters:

```Gherkin
Given invoice [SubjectInvoice] has invoice number [InvoiceNumber]
When invoice [SubjectInvoice] is displayed
Then invoice [SubjectInvoice] is displayed with invoice number [InvoiceNumber]
```

## Allowed Literals

Do not reject all literals mechanically.

A literal may be valid when:
- the exact value is the behavior being specified
- the value is a named domain constant
- the value is a configured identity label
- the value is a required user-visible output
- the value is a boundary value used to expose a rule
- the value appears in a Scenario Template row and the governing rule is explicit
- the value is explicitly illustrative and outside the authoritative contract surface

Valid example:

```Gherkin
Then platform [BasinWorksLabsPlatform] has platform identity label "BasinWorks Labs"
```

This is valid if `"BasinWorks Labs"` is the actual specified platform identity label.

Potentially valid example:

```Gherkin
Given discount rate [DiscountRate] is 10%
```

This is valid if the behavior under analysis is specifically a 10% discount rule.

## Violation: Specification by Example

A scenario violates Producore craftsmanship when examples are used as the specification and the reader must infer the governing rule.

Examples may illustrate. Explicit requirements define.

Failure indicators:
- only concrete examples are provided, with no rule or relationship made explicit
- scenario table rows imply a formula that is never stated
- implementation must reverse-engineer behavior from sample rows
- concrete data values are treated as exhaustive scope
- test data is confused with requirement meaning

Required correction:
- state the governing rule, relationship, or transformation explicitly
- use role variables for arbitrary objects or values
- keep examples only where they illustrate a defined rule
- separate example data from authoritative behavior

## Violation: Arbitrary Concrete Value Where Role Variable Is Required

A concrete value must usually be replaced by a role variable when the value is not itself the subject of the behavior.

Preferred role-variable pattern:
- `invoice [SubjectInvoice]`
- `order [SubjectOrder]`
- `user [SubjectUser]`
- `account [SubjectAccount]`
- `payment [SubjectPayment]`
- `product [SubjectProduct]`

Bad:

```Gherkin
Given user "john.smith@example.com" exists
```

Better:

```Gherkin
Given user [SubjectUser] exists
  And user [SubjectUser] has email address [EmailAddress]
```

Only keep `"john.smith@example.com"` if that exact address is itself the governed rule or required output, which is rare.

## Violation: Implementation Leakage

A scenario violates Producore craftsmanship when it specifies how the system works internally rather than the required resulting state.

Failure indicators:
- database operations
- service calls
- API calls
- queue messages
- cache invalidation
- internal function names
- class names
- implementation pipeline steps
- algorithmic choreography

Required correction:
- restate the required externally meaningful state, constraint, or outcome
- move implementation details to implementation notes only if they are non-authoritative aids and do not define behavior

## Violation: Automation or Test-Data Leakage

A scenario violates Producore craftsmanship when it reads like an automation script or test fixture.

Failure indicators:
- hardcoded fixture IDs
- test user names
- Selenium/Cypress/Playwright-style actions
- click/type/wait assertions when the behavior is not UI mechanics
- references to mocks, stubs, seeded records, or test databases
- expected values chosen only because they are convenient test data

Required correction:
- express the behavior in domain terms
- reserve automation mechanics for test implementation, not behavior specification

## Violation: UI Choreography Mistaken for Behavior

A scenario violates Producore craftsmanship when the `When` clause encodes UI interaction sequence instead of the event under analysis, unless the behavior under analysis is specifically UI interaction behavior.

Bad:

```Gherkin
When the user enters a username
And enters a password
And clicks the login button
```

Better:

```Gherkin
When credentials are submitted for user [SubjectUser]
```

## Violation: Missing Given State

A scenario violates Producore craftsmanship when a Then outcome requires state that was not established in Given or When.

Failure indicators:
- Then introduces entities not previously grounded
- Then relies on relationships not established
- Then implies prior values not stated
- Then assumes defaults not made explicit

## Violation: Ungrounded Then Outcome

A Then clause violates Producore craftsmanship when it introduces an outcome whose source, subject, or governing rule cannot be traced backward.

Example:
- `Then a confirmation message is displayed`

This is weak unless the message owner, recipient, content rule, and behavioral relevance are clear enough for the scenario’s purpose.

## Violation: Hidden Event Chain

A scenario violates Producore craftsmanship when it compresses multiple business events into one scenario.

Delegate or align with `pceood-hidden-events-analysis` where helpful.

## Violation: Non-Critical Aspect Embedded in Scenario

A scenario may fail when a Given, Then, variable, table column, or data element is not critical to the behavior under analysis.

This includes the Critical Aspects pass:
- Is every Given clause critical?
- Is every Then clause critical?
- Is every variable critical?
- Is every data-table element critical?
- Is every Scenario Template column critical?
- Would the scenario remain clear and accurate if the element were removed?

A non-critical element may indicate:
- noise
- copied residue
- a separate concern lens
- a missing scenario
- a misplaced additional aspect
- test fixture leakage

## Violation: Support Surface Used as Behavior Authority

A support artifact, implementation note, work item, visual design page, comment thread, or template must not carry missing behavior that belongs in a behavior specification.

Required correction:
- move clarified behavioral meaning into the appropriate specification surface
- keep support-only or unresolved material outside the authoritative behavior contract

## Review Instruction

When reviewing or drafting, do this before producing final behavior:

1. Identify all potential Producore violations.
2. Classify severity.
3. Explain why each is or is not a violation.
4. Propose correction direction.
5. Do not silently rewrite violations away.
6. If a violation is accepted as intentionally valid, explain the domain reason.
