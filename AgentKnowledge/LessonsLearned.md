# Lessons Learned

## 2026-07-16 Phase 0 research retrospective

- Date: 2026-07-16
- Agent: Codex
- System affected: Research, design, process, repository
- Situation: A broad reference study expanded into original game design, monetization, event, and ambience decisions while the repository remained empty.
- Decision made: Stop treating the conversation as durable memory and create a versioned research/learning foundation before production.
- Reasoning summary: The project needs continuity, evidence labels, and explicit deferral gates to avoid repeating research or implementing untested breadth.
- Result: Research, shared knowledge, agent memory, and first-development-order documents prepared for the initial commit.
- Test evidence: Required-file/nonempty, strict UTF-8, NUL-byte, JSON parsing, ignore-rule, and credential-pattern checks passed; independent documentation review returned `PASS`. Git commit and push evidence will close repository publication.
- Mistakes discovered: GitHub connectivity and CLI authentication were addressed later than ideal; too many later-phase features were brainstormed before the first-playable boundary was fixed.
- Recommended future approach: Begin each milestone with recall and a scoped plan; end with review, tests, reflection, knowledge updates, and a commit.
- Confidence level: High
- Verification status: Code-reviewed
- Evidence class: Automated documentation checks plus independent review; game remains not yet implemented

## Milestone answers

- Completed: Reference research, original thesis, monetization boundaries, event frameworks, ambience direction, production order, and memory architecture
- Worked well: Parallel research, source comparison, explicit separation of functional and cosmetic rarity
- Delays: GitHub tooling installation and authentication validation
- Bugs occurred: Tooling-only authentication anomaly; no game bugs
- Game bugs: None; no game implementation exists. Design risks kept out of the approved direction include client-authoritative economy, duplicate receipts, paid-genetics inflation, event currency bloat, and premature asset production.
- Helpful architecture: Server authority, data-driven definitions, Roblox graybox before Blender catalog
- Missing tests: All gameplay, save, economy, device, performance, and Studio tests
- Automate next: Documentation validation, content schemas, economy simulations, save round trips, and receipt idempotency
- Change next phase: Lock the first three plants and creatures before implementation
