# Security Agent Memory

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
