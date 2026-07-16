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

No game tests exist because no game has been implemented. Repository documentation validation will be recorded in the first research commit.

Document type: Test backlog and baseline guidance, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.

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
