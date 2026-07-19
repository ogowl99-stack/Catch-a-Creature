# Testing Knowledge

## Initial test priorities

1. Content-definition validation
2. Plant growth and harvest state transitions
3. Timestamp and offline-progress boundaries
4. Save/load round trips and schema migrations
5. Inventory capacity and no-loss mailbox behavior
6. Deterministic RNG distribution simulations
7. Creature attraction eligibility and clue resolution
8. Adaptation/Bloommark separation
9. Breeding inheritance invariants
10. Receipt idempotency and disconnect recovery
11. RemoteEvent validation and rate limits
12. Weather queue and no-overwrite behavior
13. Mobile/controller interaction coverage
14. Crowded-plot performance

## Current evidence

No game tests exist because no game has been implemented. Repository documentation validation was recorded in the research foundation and is detailed in the completed entry below.

Document type: Test backlog and baseline guidance, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.

## Knowledge entry: Phase 1 test-first gate

- Date: 2026-07-19
- Agent: QA Agent / Codex
- System affected: Phase 1 standards, definitions, source linkage, first-playable loop, persistence, devices, and evidence
- Situation: Phase 0 design is complete, but no code, source scaffold, game test, or Studio-linked workflow exists.
- Decision made: Phase 1 planning must define executable acceptance criteria before implementation. Minimum gates are strict content-definition validation; one guided-cycle state test; timestamp/offline boundaries; save/load/migration round trip; server-authoritative action validation; economy simulation; device interaction checklist; representative crowded-plot budget; and verified Studio/source linkage.
- Reasoning summary: Translating approved prose directly into broad gameplay code would hide assumptions and make regressions difficult to localize.
- Result: A test-first entry gate is recorded. No test harness or gameplay test is implemented, and Phase 1 remains unauthorized.
- Test evidence: Phase 0 documentation checks and final independent milestone review PASS only; no game execution evidence.
- Mistakes discovered: Earlier planning listed broad test categories without tying them to a Phase 1 authorization gate.
- Recommended future approach: For every authorized module, write the invariant, failure cases, test command or Studio procedure, expected evidence artifact, and rollback before implementation.
- Confidence level: High
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Paid true-transfer stealing acceptance requirements

- Date: 2026-07-19
- Agent: QA Agent with Architecture/Data/Security and Monetization review
- System affected: Paid credits, target eligibility, ownership transfer, policy, pricing, inventory, provenance, player trust, and recovery
- Situation: One Robux purchase can now expose another player's valuable persistent asset to permanent ownership transfer while concurrent recall, storage, sale, release, harvest, or other steal attempts occur.
- Decision made: Require eligibility matrices; exact-target disclosure; duplicate/replayed/out-of-order receipt tests; two-buyer contention; recall/favorite/sell/release/harvest versus reserve races; disconnect and shutdown at every transaction phase; stale owner/revision; full inventory; policy false/failure for both users; regional-price checks; DataStore fault injection; invariant scans for one owner/one consumed credit; provenance preservation; retained credit on failure; rate-limit/alt abuse; player-trust playtests; and mobile/controller purchase safety.
- Reasoning summary: A happy-path purchase test cannot prove that a permanent cross-player paid transfer is safe, fair, recoverable, or resistant to griefing and duplication.
- Result: Acceptance scope is defined before implementation. No test harness, code, metrics, analytics, policy confirmation, or Roblox Studio evidence exists.
- Test evidence: Read-only QA/Player Trust and Architecture/Data/Security reviews on 2026-07-19.
- Mistakes discovered: None in code; no code exists. The initial idea lacked explicit failure, receipt, policy, and player-trust behavior.
- Recommended future approach: Prove deterministic module invariants first, then closed same-server multiplayer tests, then an opt-in playtest measuring hide rate, theft concentration, exits, reports, and retaliation spending before launch approval.
- Confidence level: High
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Creature appraisal and disposition test requirements

- Date: 2026-07-19
- Agent: QA Agent with Data/Security review
- System affected: Creature persistence, valuation, favorites, sale, release, Leafnotes, journal, and transaction recovery
- Situation: Value-affecting creature mutation, size, and weight plus permanent sale/release actions introduce forgery, duplication, race, overflow, and accidental-loss risks.
- Decision made: Future acceptance coverage must include schema/save-load migration; mutation and numeric bounds; versioned valuation cases; wrong-owner and forged-value rejection; favorite enforcement; replay/idempotency; concurrent sale/sale and sale/release; disconnect and uncertain commit recovery; checked Leafnote arithmetic; zero-currency release; journal retention; economy simulation; multiplayer isolation; and device confirmation flows.
- Reasoning summary: A creature transaction is only correct when removal, payout, persistence, retry behavior, and user protection remain consistent under both ordinary and adversarial failure paths.
- Result: Regression requirements are recorded before implementation. No harness or test case is implemented.
- Test evidence: Economy and Data/Security design reviews on 2026-07-19; no executed game evidence.
- Mistakes discovered: None in code; no code exists. Generic economy test notes were insufficient for creature-specific terminal-state races.
- Recommended future approach: Build deterministic server-module tests first, then Studio integration tests with forced disconnect/duplicate scenarios and manual mobile/controller confirmation checks.
- Confidence level: High
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Phase 0 documentation validation

- Date: 2026-07-16
- Agent: Documentation Agent and QA reviewer
- System affected: Repository documentation and persistent agent memory
- Situation: The first durable project snapshot needed structural, encoding, schema, credential, and independent-review evidence before publication.
- Decision made: Validate every required memory path, require nonempty strict UTF-8 Markdown, parse the proposed dashboard JSON, scan tracked-scope files for credential patterns, and require an independent review pass.
- Reasoning summary: Documentation is the project's current product; broken structure or unsupported truth claims would damage future agent decisions even without game code.
- Result: All 19 shared and 14 personal memory files passed; dashboard JSON parsed; no credential-pattern matches were found; the independent reviewer returned `PASS` after fixes.
- Test evidence: Local Node.js validation commands, `rg` credential scan, Git status/ignore inspection, and `/root/documentation_review` final result.
- Mistakes discovered: The first dashboard contract left several records as non-validatable placeholders, and composite research scores were initially attributed too broadly.
- Recommended future approach: Keep documentation validators in the first dashboard/tooling slice and repeat the independent review at every major milestone.
- Confidence level: High
- Verification status: Code-reviewed
- Evidence class: Local automated checks and independent review
