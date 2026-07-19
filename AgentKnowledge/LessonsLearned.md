# Lessons Learned

## 2026-07-18 Phase 0 decision checkpoint

- Date: 2026-07-18
- Agent: Codex with independent documentation review
- System affected: Game identity, first-playable content, progression, weather, economy, and development process
- Situation: The user approved a sequence of Phase 0 decisions after the read-only repository and Roblox Studio preflight, then requested a durable stopping point for the day.
- Decision made: Lock the final game promise; Hearthpetal, Ripplecup, and Nuzzlefern; Cozzle, Rillibob, and Mossnub with their primary flora preferences; Emberkeep; Starlace; Soft Rain; and Leafnotes with its harvest-to-base-seed relationship. Keep the proposed Observe → Care → Bond interaction and every remaining Phase 0 item unapproved.
- Reasoning summary: Recording each narrow approval with explicit exclusions preserves progress without allowing names or concepts to silently approve balance, art, behavior, APIs, persistence, or implementation.
- Result: Approved decisions, truth labels, personal memories, and cross-agent handoffs are synchronized. Phase 0 remains in progress; no gameplay code, production scaffold, Studio content, or Roblox publish action exists.
- Test evidence: Repeated `git diff --check` passes, exact-text searches for each approved decision, read-only Studio hierarchy inspection, and independent review passes for the promise, flora, creatures, Adaptation/Bloommark, weather, and currency records.
- Mistakes discovered: An initial combined verification-status sentence did not use one exact allowed truth label; independent review caught it and the status was split into `Verified` plus a separate `Not yet implemented` implementation status. A first independent review was interrupted and was rerun successfully with a bounded scope.
- Recommended future approach: Resume at the exact clue-inspection and bonding decision, continue one approval gate at a time, and do not create a Rojo scaffold or gameplay logic until every remaining Phase 0 gate is approved.
- Confidence level: High
- Verification status: Code-reviewed

## 2026-07-18 Repository publication lesson

- Date: 2026-07-18
- Agent: Codex / Security Agent
- System affected: GitHub access and repository privacy
- Situation: Public visibility was requested to support a friend contributing to the project.
- Decision made: Require explicit informed approval and scan current tracked content plus reachable Git history before changing visibility.
- Reasoning summary: A public repository is easy to collaborate around, but it exposes history and metadata beyond the current working tree, and public visibility alone does not grant push permission.
- Result: The repository is verified public. No credential patterns were found; a personal author email in two commits and inconclusive PNG metadata candidates were disclosed as privacy caveats.
- Test evidence: `gh repo view` returned `visibility: PUBLIC` and `isPrivate: false`; independent review examined 49 tracked files, 54 blobs, and four commits.
- Mistakes discovered: CLI authentication freshness was not checked until execution, and prior commits used a non-noreply author email.
- Recommended future approach: Check authentication early, use a noreply author address, run dedicated secret and asset-metadata scans before public releases, and add collaborators separately when direct push access is intended.
- Confidence level: High
- Verification status: Verified
- Scan review status: Code-reviewed

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
