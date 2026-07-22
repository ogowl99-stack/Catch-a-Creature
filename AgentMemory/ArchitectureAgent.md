# Architecture Agent Memory

## 2026-07-21 seed-foraging update

- Tasks completed: Approved stable persisted node identity with relocatable global projection and commit-relocate-present ordering
- Strengths demonstrated: Extended the farm/profile architecture without duplicating inventory or exposing a reward remote
- Mistakes made: The first design stopped at fixed-location cooldowns
- Bugs introduced: None found
- Bugs prevented: Saved world-coordinate drift, optimistic presentation, and client-selected grants
- Review feedback received: Global movement and per-player cooldown must share one stable node ID
- Useful patterns discovered: Durable identity and world presentation should be separately modeled
- Areas requiring improvement: Multi-client contention and node-catalog migration policy
- Current project knowledge: ADR-016 extends ADR-014/015; schema v4 stores cooldowns only, not spawn coordinates
- Unresolved questions: Future cross-server event-node placement and node retirement migrations
- Recent evaluation scores: Joint forage slice Overall 95
- Next improvement goal: Define safe versioning for future biome/event forage pools

- Tasks completed: Established server authority, data-driven content, phased scope, verified selective Rojo source linkage, harvest modes, capacity/reservation, repeatable receipt recovery, inventory/hotbar identity, paid true transfer, and the wild-capture exact-one ownership boundary
- Strengths demonstrated: Dependency ordering and boundary definition
- Mistakes made: Selective Rojo remained a prose direction until Phase 3A; no gameplay API plan exists yet
- Bugs introduced: None
- Bugs prevented: Premature metagame dependencies, client-authoritative economy, duplicate capture ownership, and unsafe full-storage ownership fallback were blocked at design time
- Review feedback received: Architecture must remain proportional; paid receipts and capture attempts need durable idempotent boundaries
- Useful patterns discovered: Stable IDs, revisions, server-owned definitions, capacity reservation, conditional encounter reservation, explicit provenance
- Areas requiring improvement: Convert design boundaries into minimal modules/remotes and fault-testable transitions
- Current project knowledge: ADR-013 verifies repository authority for namespaced shared/server/client roots while excluding Workspace and restricting sync to the authorized place. ADR-012 makes paid true transfer a final, feature-flagged launch system after core ownership is proven. Receipts grant durable buyer-bound credits rather than volatile targets; exact-item transfer requires immutable UUID/revision, an item-centric cross-profile ledger/reconciler, capacity-safe inbox, provenance, audit, fail-closed policy, and a kill switch. ADR-011 retains the capture/decision/celebration boundary.
- Unresolved questions: Exact item ownership topology, transfer states, ledger retention/recovery, protected inbox, protection/cap rules, resale policy, private servers, policy classification, plus the prior attempt/decision/Luck/expiry/schema questions
- Recent evaluation scores: Overall 98 jointly for failure-decision and rare-celebration review; prior capture score 97
- Next improvement goal: Define one authoritative revision-checked item transition service that supports ordinary actions before any paid cross-profile transfer

## 2026-07-21 Hearthpetal/Cozzle update

- Tasks completed: Generalized plant definitions, approved schema v3 migration, and separated plant/creature world projections
- Strengths demonstrated: Maintained exact-item and ownership boundaries while adding visible gameplay
- Mistakes made: Initial implementation plan underweighted test-runtime cache behavior
- Bugs introduced: None remaining
- Bugs prevented: Copy-pasted plant transactions, lossy fixed-slot migration, and model-as-ownership authority
- Review feedback received: Introduce EncounterService only when Observe adds authoritative state
- Useful patterns discovered: Derived presentation service plus durable farm profile; no premature creature schema
- Areas requiring improvement: Encounter identity/lifetime contract and scheduled projection updates
- Current project knowledge: ADR-015 supersedes schema/slot portions of ADR-014 while retaining commit/replay/lease invariants
- Unresolved questions: Visitor rejoin, expiry, priority, and future durable encounter topology
- Recent evaluation scores: Hearthpetal/Cozzle joint score recorded in AgentScores
- Next improvement goal: Define the minimal Observe encounter contract and its cleanup/rejoin boundary
