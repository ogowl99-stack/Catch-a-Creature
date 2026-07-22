# Data Agent Memory

## 2026-07-21 favorite-safe sale update

- Tasks completed: Integrated favorite persistence/revision changes and atomic bulk removal with exact payout/hotbar cleanup
- Strengths demonstrated: Kept equip session-only while preserving durable identity, favorite, weight, location, and replay semantics
- Mistakes made: No final data defect found; production/fault-injection evidence remains open
- Bugs introduced: None found
- Bugs prevented: Favorite loss, partial bulk commit, orphaned hotbar references, and mutation on no-sellable request
- Review feedback received: Favorites must survive full-inventory sale and do not require equip; exact-item single sale does
- Useful patterns discovered: Bulk inventory mutation should build one candidate from authoritative state and commit once
- Areas requiring improvement: Mixed live bulk rejoin, datastore faults, multi-server races, and migration fixtures containing favorites
- Current project knowledge: Deterministic bulk/favorite/replay cases pass; live favorite-only no-op preserves profile revision
- Unresolved questions: Favorite count limits and bulk-sale audit/telemetry requirements at launch
- Recent evaluation scores: Joint held/selling overall 95
- Next improvement goal: Add isolated rejoin and injected-write-failure coverage for mixed favorite bulk sale

## 2026-07-21 seed-foraging update

- Tasks completed: Added schema v4 forage cooldown records and v1-v3 migrations without changing exact inventory/hotbar authority
- Strengths demonstrated: Bounded known node IDs/timestamps and reused commit-before-acknowledgement/replay behavior
- Mistakes made: No schema-v4 isolated DataStore rejoin was completed in this slice
- Bugs introduced: None found in automated migration/domain tests
- Bugs prevented: Unknown-node persistence, cooldown mutation on full inventory, and replay duplication
- Review feedback received: Keep cooldown identity stable across world relocation
- Useful patterns discovered: Persist logical resource identity, not presentation coordinates
- Areas requiring improvement: Isolated v4 leave/rejoin, commit-failure fault injection, and multi-server behavior
- Current project knowledge: `foraging.nextAvailableAtByNodeId` is versioned, bounded, and included in recent command results
- Unresolved questions: Production retention/migration telemetry and future node-ID deprecation policy
- Recent evaluation scores: Joint forage slice Overall 95
- Next improvement goal: Verify schema v4 in an isolated DataStore rejoin while preserving all v3 data

- Tasks completed: Established versioned schemas, provenance, migration requirements, offline timestamps, receipt ledgers, harvest/storage transactions, inventory identity, creature disposition, paid true transfer, wild-capture encounter/ownership requirements, and implemented the Phase 3A farm profile with saved Leafnotes/crops/hotbar
- Strengths demonstrated: Persistence-risk identification
- Mistakes made: The first Phase 3A repository reused a job-wide lease token, used an unsafe equal-revision acceptance shortcut, validated nested state too shallowly, and left hotbar item slots client-only
- Bugs introduced: None
- Bugs prevented: Paid-origin laundering, duplicate receipts, client-trusted timers, and duplicate or phantom capture owners were identified before implementation
- Review feedback received: Persist valuation and provenance inputs; a successful capture must commit ownership before world despawn
- Useful patterns discovered: Unique IDs, definition versions, request idempotency, per-player encounter state, item origin/provenance, bounded audit records
- Areas requiring improvement: Ambiguous-commit reconciliation, injected-store fault tests, sequential migrations, isolated published rejoin tests, and compact profile measurement
- Current project knowledge: Familiarity is approved per player × stable creature-definition ID × rarity tier, one failure count/+2 points per committed failure, tier guarantees 2/3/5/8/15/25, persistence across visitors/rejoins/another winner, and reset on matching creature-definition-ID success. Every accepted attempt consumes its Tag/selected aid; guaranteed attempts disable aid; one owned UUID commits before celebration.
- Unresolved questions: Attempt/decision/outcome/celebration schema, definition-version migration without progress loss, Luck formula fields, queue records, canonical stack key, receipt/audit retention, emergency headroom, and profile budget
- Recent evaluation scores: Overall 98 jointly for immediate rising-chance retry; prior capture score 97
- Next improvement goal: Prove the Phase 3A profile under fake-store faults and an isolated published leave/rejoin test before extending it with capture/Familiarity data

## 2026-07-21 persistence-test update

- Tasks completed: Ran the fingerprinted one-user isolated Studio DataStore leave/rejoin test at exactly 100,000 Leafnotes, including seeds, item IDs/weights, slots 2/10, plotted timestamps/coordinates, offline maturity, one reconstructed mature plant, request replay, cleanup, and default-mode restoration
- Strengths demonstrated: Exact durable-state comparison across public snapshot, authoritative store observation, and runtime world projection
- Mistakes made: Sparse hotbar slots were initially encoded as numeric keys, and the first startup path lacked duplicate-load serialization
- Bugs introduced: Numeric slot 10 was dropped by DataStore serialization; a duplicate load could replace the valid in-memory session with `SESSION_BUSY`
- Bugs prevented: Both regressions were reproduced and fixed before production use; the isolated key and flag were removed after fingerprint validation
- Review feedback received: Keep the claim scoped to isolated one-user Studio evidence; production, hard crash, throttling, ambiguous commits, multiserver, scale, and real devices remain unverified
- Useful patterns discovered: Canonical string keys for sparse durable dictionaries; per-player in-flight load guards; fixed request IDs; authoritative `UpdateAsync` test observations; exact-key cleanup
- Areas requiring improvement: Injected atomic-store faults, callback retry semantics, release failure, hard shutdown, lease takeover, migration chains, and compact-profile measurement
- Current project knowledge: Schema v2, release retry, and the duplicate-load guard are implemented. The regression suite passes 13/13 and the Rojo build passes. One final Studio shutdown retained a bounded lease despite correct data, so shutdown fault coverage remains necessary.
- Unresolved questions: Ambiguous-commit reconciliation, fake-store interface, multiserver takeover timing, production profile budget, and migration rollout policy
- Recent evaluation scores: Pending final independent review for this follow-up
- Next improvement goal: Add an injected atomic-store adapter and prove fail-before-write, commit-then-timeout, callback retry, stale writer, duplicate load, release failure, and lease takeover before extending the schema

Follow-up (2026-07-21): Hotbar organization is now an idempotent saved-reference mutation in both directions. Unassign clears only one slot; assign validates the exact Backpack item/revision and selects the lowest free slot 2-10. Neither changes item identity, weight, favorite, provenance, location, capacity, or item revision. The suite now passes 24 domain/schema cases plus four FarmService lifecycle cases, including overlapping/sequential loads and departed success/failure cleanup. Independent review returned PASS. The active improvement goal remains injected DataStore fault coverage.

## 2026-07-21 Hearthpetal/Cozzle update

- Tasks completed: Added schema v3, Hearthpetal stack, generic plant validation, and v1/v2 migration to two fixed seed slots
- Strengths demonstrated: Preserved displaced slot-2 items exactly, including a full-hotbar stored fallback
- Mistakes made: Initial test plan did not include a full v2 quick-slot migration until self-review
- Bugs introduced: None observed
- Bugs prevented: Slot-2 item deletion, client-chosen plant definitions, wrong-definition sale values, and duplicate hotbar references
- Review feedback received: Keep decode migration separate from durable item mutation
- Useful patterns discovered: Reserve fixed references while moving only optional quick-slot references
- Areas requiring improvement: Isolated schema-v3 DataStore rejoin and injected store faults
- Current project knowledge: Schema v3 uses seed slots 1-2 and item slots 3-10; Cozzle itself is not persisted
- Unresolved questions: Durable visitor identity/lifetime and future encounter schema
- Recent evaluation scores: Hearthpetal/Cozzle joint score recorded in AgentScores
- Next improvement goal: Run a fingerprinted schema-v2-to-v3 isolated rejoin before durable encounter state is added

## 2026-07-21 schema-v5 dynamic-hotbar update

- Tasks completed: Added schema v5, removed zero-count seed reservations, validated dynamic seed/item refs, and migrated v4 while preserving valid manual slots
- Strengths demonstrated: Used canonical string keys, exact item identity, uniqueness checks, and noncompacting migration
- Mistakes made: Schema v4 encoded content categories as hotbar ownership
- Bugs introduced: None found in the 61-case fresh Server VM run
- Bugs prevented: Phantom refs, duplicate refs, slot jumps, and migration movement of valid player-organized items
- Review feedback received: Acquisitions must use the next open number while saved player positions remain stable
- Useful patterns discovered: Inventory truth and hotbar presentation should remain separate persistent layers
- Areas requiring improvement: Production v4-to-v5 migration, injected-store faults, and full-hotbar acquisition policy
- Current project knowledge: Positive seeds use `seed:<definitionId>` and exact items use their Backpack ID in string slots `"1"`-`"10"`
- Unresolved questions: Creature reference prefix/record location and manual reorder command contract
- Recent evaluation scores: Overall 97 for this bounded slice
- Next improvement goal: Prove a fingerprinted v4-to-v5 DataStore rejoin with gaps and a manually retained slot
