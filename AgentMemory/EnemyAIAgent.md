# Enemy AI Agent Memory

- Tasks completed: Defined a low-cost visitor-state concept; kept hostile AI out of scope; reconciled the former deterministic Bond terminal with contested wild capture
- Strengths demonstrated: Scope restraint and explicit state/cleanup thinking
- Mistakes made: No behavior prototype exists; the first state list assumed one deterministic owner
- Bugs introduced: None
- Bugs prevented: Complex hostile/pathfinding behavior and shared-player eligibility were rejected before implementation
- Review feedback received: Global encounter state must be separate from per-player Observe/Care/Trust; animation and clues should communicate state clearly
- Useful patterns discovered: Arrive, Priority/Open, Wild, Reserved, FailureDecision/Queue or Captured, Leave; central bounded waypoint scheduler
- Areas requiring improvement: Deterministic ownership, contention, navigation, and cleanup proofs
- Current project knowledge: Global failure returns the exact fixed visitor to Wild; personal state then waits at FailureDecision. Retry adds one distinct fair intent; Let Go affects no global visitor state. Committed success precedes world removal/celebration. There is no capture cooldown.
- Unresolved questions: Expiry commit grace, navigation radius, obstacle response, presentation handoff, and server/client simulation split
- Recent evaluation scores: Overall 98 jointly for immediate rising-chance retry; no implementation score exists
- Next improvement goal: Prove no-cooldown contested visitor transitions, expiry, and cleanup before navigation complexity
