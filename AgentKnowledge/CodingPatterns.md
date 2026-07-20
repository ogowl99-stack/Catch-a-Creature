# Coding Patterns

## Current state

No production code exists. No pattern is approved merely because it is familiar.

## Candidate patterns requiring implementation evidence

- Server-owned content definition registry
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
