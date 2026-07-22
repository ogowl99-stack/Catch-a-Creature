# Security Agent Memory

## 2026-07-21 sale authority update

- Tasks completed: Reviewed and enforced server-tracked exact equip for single sale and authoritative favorite exclusions/payouts for bulk sale
- Strengths demonstrated: Rejected forged ownership-only sale attempts without mutation and kept replay/revision protection intact
- Mistakes made: No final security defect found
- Bugs introduced: None found
- Bugs prevented: Client-selected fallback sale, favorite bypass, forged payout, stale-item sale, and partial bulk deletion
- Review feedback received: Equip is required only for one-item sale; bulk scans inventory and always protects favorites
- Useful patterns discovered: UI selection is intent; server equip plus exact UUID/revision is authorization context
- Areas requiring improvement: Rate limits, multiplayer race tests, suspicious-request telemetry, and production audit events
- Current project knowledge: Direct unequipped request fails `ITEM_NOT_EQUIPPED`; favorite-only bulk fails `NO_SELLABLE_ITEMS` with no mutation
- Unresolved questions: Launch thresholds for sale throttling and audit retention
- Recent evaluation scores: Joint held/selling security 98
- Next improvement goal: Add concurrent equip/store/favorite/sell threat tests and bounded telemetry

## 2026-07-21 seed-foraging update

- Tasks completed: Enforced server-selected forage rewards, private grant authorization, distance/node/cooldown/capacity validation, and no-RNG rejection
- Strengths demonstrated: Kept rarity and definition choice out of the public client contract
- Mistakes made: Initial cooldown-only design underestimated fixed-coordinate automation
- Bugs introduced: None found in current tests
- Bugs prevented: Forged Mythic rewards, remote-only collection, replay duplication, capacity overflow, and optimistic relocation
- Review feedback received: Relocation is complementary macro friction, not a claim of complete bot prevention
- Useful patterns discovered: A table-identity token can distinguish an internal server call from serialized client data within the existing service boundary
- Areas requiring improvement: Two-client contention, throttling evidence, forced commit failures, and production abuse telemetry
- Current project knowledge: Only successful durable forage returns `ok=true` to the world service and permits relocation/presentation
- Unresolved questions: Final rate thresholds and server-wide contention semantics
- Recent evaluation scores: Joint forage slice Overall 95
- Next improvement goal: Add multi-client contention and commit-failure no-relocation coverage

- Tasks completed: Threat-modeled inventory, economy, purchases, paid randomness, provenance, creature disposition, paid true transfer, harvest/capacity/receipts, wild-capture contention and free-only provenance, travel/placement, and public-repository exposure
- Strengths demonstrated: Abuse-case coverage, prevention-first reasoning, and truthful evidence boundaries
- Mistakes made: No game code validates the controls; repository scanning still lacks a dedicated secret scanner and conclusive classification of three PNG candidates
- Bugs introduced: None
- Bugs prevented: Client-authored odds/ownership, duplicate capture winners, paid-luck contamination, duplicate receipts, and unsafe publication patterns were blocked at design/review time
- Review feedback received: Fail closed on uncertain paid/persistent state; rejected capture spam must cause no RNG, VFX, pathfinding, or persistence work
- Useful patterns discovered: Idempotent ledgers, revision/CAS locks, capacity-before-RNG, free-only provenance, server catalogs, token buckets, bounded audit
- Areas requiring improvement: Turn findings into automated adversarial and provenance tests
- Current project knowledge: Launch-target paid transfer is built last and feature-flagged off. It requires idempotent receipt credits, exact UUID/revision validation, fail-closed eligibility for both users, cross-profile recovery, immutable provenance, audit, anti-chain limits, protected capacity, and a kill switch. Ordinary visitors never gain plot mutation authority.
- Unresolved questions: Policy classification; transfer state/ledger retention; protection/cap/alt/private-server rules; incident tooling; exact Luck/expiry/audit details; storage headroom; and PNG candidates
- Recent evaluation scores: Overall 98 jointly for failure-decision and rare-celebration review; prior capture score 97
- Next improvement goal: Add deterministic receipt/transfer fault and unauthorized-plot-mutation cases to the existing attempt/replay/provenance regression plan

## 2026-07-21 Hearthpetal/Cozzle update

- Tasks completed: Reviewed definition allowlisting and negative creature-ownership boundary
- Strengths demonstrated: No new ownership/economy remote was added for a presentation milestone
- Mistakes made: None
- Bugs introduced: None
- Bugs prevented: Forged plant definitions and visitor-model ownership claims
- Review feedback received: Future Observe must use server encounter identity, not client Instance authority
- Useful patterns discovered: Negative attributes plus absent mutation APIs make prototype limits inspectable
- Areas requiring improvement: Adversarial Observe requests, replay, distance, and destroyed-attractor races
- Current project knowledge: Current Cozzle cannot be captured or sold and does not occupy Backpack/profile state
- Unresolved questions: Encounter IDs, visibility/priority, and lifetime tokens
- Recent evaluation scores: Hearthpetal/Cozzle joint score recorded in AgentScores
- Next improvement goal: Threat-model Observe before any Care or Capture command exists
