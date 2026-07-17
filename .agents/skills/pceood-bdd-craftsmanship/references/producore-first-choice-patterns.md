# Producore First-Choice Patterns

## Purpose

This file records Producore-local first-choice drafting patterns that should be preferred unless the behavior clearly requires a different structure.

These are not excuses to skip analysis. They are tie-breakers to help preserve Producore-local craftsmanship rather than drifting back to generic BDD habits.

## General Preferences

- Prefer object-first scenario wording over actor-first wording unless the actor materially changes the behavior.
- Prefer explicit state expression over prose compression.
- Prefer relational and property assertions over conversational summaries.
- Prefer formulations that make the transformation graph easier to inspect directly.
- Prefer repeated end-state assertions when they materially preserve:
  - identity continuity
  - non-creation
  - non-duplication
  - exact cardinality
  - explicit resulting state
- Prefer the user's demonstrated Producore-local scenario shape when present and corpus-compatible.

## First-Choice Wording Patterns

Prefer patterns like these when they fit the behavior:

- `the determined fields of document [X] are:`
- `document [X] does not have both a determined supplier and a determined invoice number`
- `the fields of invoice record [Y] are:`
- `invoice record [Y] has:`
- `no invoice record has:`
- `there is one invoice record with:`
- `the upload is identified as a duplicate`
- `the upload is not identified as a duplicate`
- `a duplicate detection message is shown`
- `the upload is in review for manual processing`

Prefer these over looser paraphrases such as:

- "the file can be parsed well enough to determine ..."
- "an existing invoice already exists ..."
- "the clerk is shown that a duplicate was detected ..."
- "the upload remains in review ..."
- other prose formulations that compress structured state into summary language

## Data Table Preferences

Prefer data tables when they materially improve explicitness of:

- determined fields
- record fields
- object properties
- exact matching criteria
- end-state constraints
- identity-preserving comparisons

Do not use a table merely because a table is possible.
Use one when it preserves the contract more explicitly than prose.

## Actor Usage

Prefer not to introduce a named actor when:

- the event is already clear without the actor
- the actor does not change the business meaning
- the stronger scenario surface is the document, record, request, or state transition itself

Introduce the actor when:

- permissions, role, visibility, or ownership materially affect the behavior
- different actors produce different outcomes
- the event is ambiguous without the actor

## Repetition Policy

Do not remove repeated assertions just because they look redundant.

Keep repeated assertions when they materially express different constraints, for example:

- one assertion preserves identity of an existing record
- another assertion preserves that no second matching record was created
- one assertion preserves exact state of a specific object
- another assertion preserves overall resulting cardinality

A formulation can be repetitive and still be stronger craftsmanship than a shorter paraphrase.

## Example Pattern: Duplicate Detection

Stronger Producore-shaped formulation:

```Gherkin
Scenario: Uploading a supplier invoice document with a matching existing invoice record
    Given a supplier invoice document [SupplierInvoiceDocument]
      And the determined fields of document [SupplierInvoiceDocument] are:
        | field          | value                   |
        | supplier       | [DocumentSupplier]      |
        | invoice number | [DocumentInvoiceNumber] |
      And an invoice record [ExistingInvoiceRecord]
      And the fields of invoice record [ExistingInvoiceRecord] are:
        | field          | value                   |
        | supplier       | [DocumentSupplier]      |
        | invoice number | [DocumentInvoiceNumber] |
     When the supplier invoice document [SupplierInvoiceDocument] is uploaded
     Then the upload is identified as a duplicate
      And invoice record [ExistingInvoiceRecord] has:
        | field          | value                   |
        | supplier       | [DocumentSupplier]      |
        | invoice number | [DocumentInvoiceNumber] |
      And there is one invoice record with:
        | field          | value                   |
        | supplier       | [DocumentSupplier]      |
        | invoice number | [DocumentInvoiceNumber] |
      And a duplicate detection message is shown
      And invoice record [ExistingInvoiceRecord] can be opened from that message
```

Weaker generic-normalized drift:

```Gherkin
Scenario: AP clerk uploads a supplier invoice file if an invoice record already exists for the same supplier and invoice number
    Given AP clerk [Clerk] has supplier invoice file [File] available for upload
     And file [File] can be parsed well enough to determine supplier [Supplier] and invoice number [Invoice Number]
     And invoice record [Existing Invoice] already exists for supplier [Supplier] and invoice number [Invoice Number]
     When AP clerk [Clerk] uploads file [File]
     Then the upload does not create another invoice record for supplier [Supplier] and invoice number [Invoice Number]
      And the clerk is shown that a duplicate was detected
```

Why the stronger pattern is preferred here:

- it preserves explicit determined-field state
- it preserves explicit matching criteria
- it preserves object identity and overall cardinality separately
- it avoids unnecessary actor introduction
- it avoids prose compression
- it better matches Producore-local contract shape

## Final Check

Before finalizing, prefer the draft that a Producore reviewer would judge stronger as a contract surface, even if a general BDD reviewer might call the alternative "cleaner" or "more idiomatic."