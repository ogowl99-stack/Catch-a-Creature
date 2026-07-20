# Security Agent Memory

- Tasks completed: Threat-modeled inventory, economy, purchases, paid randomness, provenance, creature disposition, paid true transfer, harvest/capacity/receipts, wild-capture contention and free-only provenance, travel/placement, and public-repository exposure
- Strengths demonstrated: Abuse-case coverage, prevention-first reasoning, and truthful evidence boundaries
- Mistakes made: No game code validates the controls; repository scanning still lacks a dedicated secret scanner and conclusive classification of three PNG candidates
- Bugs introduced: None
- Bugs prevented: Client-authored odds/ownership, duplicate capture winners, paid-luck contamination, duplicate receipts, and unsafe publication patterns were blocked at design/review time
- Review feedback received: Fail closed on uncertain paid/persistent state; rejected capture spam must cause no RNG, VFX, pathfinding, or persistence work
- Useful patterns discovered: Idempotent ledgers, revision/CAS locks, capacity-before-RNG, free-only provenance, server catalogs, token buckets, bounded audit
- Areas requiring improvement: Turn findings into automated adversarial and provenance tests
- Current project knowledge: One committed failure atomically consumes its Tag/aid, adds one approved Familiarity step, and issues one decision token. Retry/Let Go are mutually exclusive and idempotent; Retry adds one fair intent, personal Let Go changes no encounter/progress. Success commits one owned UUID before a sanitized deduplicated celebration event.
- Unresolved questions: Token/rate/audit details; exact Luck formula/recipes; expiry grace; free recipes; celebration-event validation; cap/headroom; paid-theft policy; incident tooling; and PNG candidates
- Recent evaluation scores: Overall 98 jointly for failure-decision and rare-celebration review; prior capture score 97
- Next improvement goal: Automate attempt/decision/event replay, transaction fault, capture authority, and free-only provenance regression scans
