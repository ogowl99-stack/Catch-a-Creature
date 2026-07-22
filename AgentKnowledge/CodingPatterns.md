# Coding Patterns

## Current state

Repository-owned gameplay code now exists for the Phase 3 farming and first attraction slices. Patterns are approved only within their recorded evidence boundaries.

## Approved pattern: Definition-authoritative content transactions

- Date: 2026-07-21
- Agent: Codex / Architecture, Data, Security, Gameplay, and QA roles
- Purpose: Support multiple content definitions without duplicating transaction logic or trusting client prices/timers/values.
- Approved use cases: Plant seed purchase, placement, harvest, sale, snapshots, and UI catalog projection.
- Example implementation: Client submits an allowlisted definition ID; server resolves the frozen definition; placed item saves ID/version; later harvest/sale resolve from the saved item rather than the current selection; snapshot returns only presentation-safe catalog fields.
- Limitations: Changing an existing definition version still requires migration/balance policy. This pattern does not define creature ownership.
- Performance characteristics: Constant-time definition lookup plus existing bounded profile scans.
- Security considerations: Reject unknown IDs; never accept client price, growth time, weight, sale value, attraction, or ownership state.
- Required tests: Every definition's value path, unknown ID, replay, save migration, stale revision, capacity, and generic UI labels.
- Confidence level: High
- Verification status: Verified for Sunspud and Hearthpetal

## Candidate patterns requiring implementation evidence

- Server-owned content definition registry (implemented for plants and first creature projection)
- Explicit plant harvest-mode state machine: required `SingleHarvest` or allow-listed `Regrower`, with `SingleHarvest` as the fail-safe default
- One authoritative inventory with hotbar slots stored as item references rather than copied item records
- Occupied-slot capacity reservation inside the same revision-checked transaction as each item-state change
- Exactly-once Developer Product capacity grant keyed by `PurchaseId`, durably committed before `PurchaseGranted`, plus protected over-capacity recovery
- Validated action request/result event pattern
- One-use post-result decision token: exactly one of Retry or Let Go, with duplicate decisions returning the recorded outcome
- Idempotent transaction and receipt ledger
- Durable gameplay commit before sanitized idempotent presentation event; cosmetics never award or roll back ownership
- Persistent paid-credit grant separated from mutable target redemption
- Immutable item identity with revision-checked ownership transitions and a recovery ledger
- Timestamp-based offline progress calculation
- Versioned player-data schema with migrations
- Deterministic seeded simulation for tests
- Connection and instance cleanup ownership
- Object pooling only after measured need

Each future approved pattern must document purpose, use cases, example implementation, limitations, performance, security, and required tests.

Document type: Candidate-pattern backlog, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.
