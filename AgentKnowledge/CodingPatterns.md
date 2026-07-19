# Coding Patterns

## Current state

No production code exists. No pattern is approved merely because it is familiar.

## Candidate patterns requiring implementation evidence

- Server-owned content definition registry
- Validated action request/result event pattern
- Idempotent transaction and receipt ledger
- Persistent paid-credit grant separated from mutable target redemption
- Immutable item identity with revision-checked ownership transitions and a recovery ledger
- Timestamp-based offline progress calculation
- Versioned player-data schema with migrations
- Deterministic seeded simulation for tests
- Connection and instance cleanup ownership
- Object pooling only after measured need

Each future approved pattern must document purpose, use cases, example implementation, limitations, performance, security, and required tests.

Document type: Candidate-pattern backlog, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.
