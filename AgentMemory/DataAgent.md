# Data Agent Memory

- Tasks completed: Established versioned schemas, provenance, migrations, offline timestamps, receipt ledgers, harvest/storage transactions, inventory identity, creature disposition, paid true transfer, and wild-capture encounter/ownership requirements
- Strengths demonstrated: Persistence-risk identification
- Mistakes made: No schema is defined or tested yet
- Bugs introduced: None
- Bugs prevented: Paid-origin laundering, duplicate receipts, client-trusted timers, and duplicate or phantom capture owners were identified before implementation
- Review feedback received: Persist valuation and provenance inputs; a successful capture must commit ownership before world despawn
- Useful patterns discovered: Unique IDs, definition versions, request idempotency, per-player encounter state, item origin/provenance, bounded audit records
- Areas requiring improvement: Atomic save boundaries, migration tests, and compact profile design
- Current project knowledge: Familiarity is approved per player × stable creature-definition ID × rarity tier, one failure count/+2 points per committed failure, tier guarantees 2/3/5/8/15/25, persistence across visitors/rejoins/another winner, and reset on matching creature-definition-ID success. Every accepted attempt consumes its Tag/selected aid; guaranteed attempts disable aid; one owned UUID commits before celebration.
- Unresolved questions: Attempt/decision/outcome/celebration schema, definition-version migration without progress loss, Luck formula fields, queue records, canonical stack key, receipt/audit retention, emergency headroom, and profile budget
- Recent evaluation scores: Overall 98 jointly for immediate rising-chance retry; prior capture score 97
- Next improvement goal: Draft minimal versioned attempt, decision-token, Familiarity, capture-provenance, celebration-dedupe, and capacity schemas before persistence code
