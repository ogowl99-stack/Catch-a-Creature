# Security Findings

## Entry: Paid true-transfer stealing boundary

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent
- System affected: Developer-product receipts, policy eligibility, cross-player item ownership, plot exposure, inventory, provenance, appraisal, and Leafnotes
- Situation: The user approved a paid mechanic that permanently transfers one exposed plant or bonded roaming/displayed creature, including its economic traits and sale rights.
- Decision made: Treat stealing conservatively as paid cross-player item transfer. Both users must be online in the same eligible server and pass required `PolicyService` checks; policy failure fails closed. The server validates immutable item ID, owner, plot, state, revision, protection, distance, and eligibility. `ProcessReceipt` grants only a nontradeable persistent credit. A revision-checked item-centric transaction moves ownership exactly once, preserves traits/provenance, projects to a capacity-safe buyer inbox, and consumes one credit. Invalid targets retain the credit and never trigger a random fallback.
- Reasoning summary: The mechanic combines a paid receipt with non-consensual persistent transfer, so client trust, stale target state, concurrent actions, regional arbitrage, alt collusion, and partial saves can cause fraud, duplication, or irreversible loss.
- Result: Security requirements and launch blockers are recorded. Official Roblox documentation does not explicitly approve or classify paid non-consensual transfers, so platform compatibility is unresolved pending Roblox confirmation.
- Test evidence: Current official Roblox documentation review plus independent security/design review on 2026-07-19. No implementation, adversarial test, policy test, purchase test, DataStore test, or Studio test exists.
- Mistakes discovered: A live target must not be encoded as an implicit “latest selection” for a receipt; victim compensation would create a repeatable alt-account currency-generation path; a duplicate replacement violates the user's exact-transfer rule.
- Recommended future approach: Obtain policy confirmation, retain complete audit/provenance, use bounded free anti-chain safeguards, block protected/account-bound content, reconcile uncertain commits, and launch only after closed multiplayer trust testing.
- Confidence level: High for security risks and receipt rules; Medium for platform eligibility until Roblox confirms classification
- Verification status: Code-reviewed
- Implementation status: Not yet implemented
- Launch status: Blocked
- Launch blocker: Roblox policy or Developer Relations must confirm the platform classification before launch.

## Entry: Creature appraisal and terminal transaction boundary

- Date: 2026-07-19
- Agent: Data Agent / Security Agent
- System affected: Creature persistence, appraisal, sale, release, favorites, journal, and Leafnotes
- Situation: The approved first-playable economy now permits bonded creatures with mutation, size, and weight variation to be sold for Leafnotes or released without currency.
- Decision made: The client may identify an owned creature and request a confirmed action, but the server reads the persisted creature instance and versioned definitions, validates ownership/state/favorite protection, calculates bounded value, and atomically commits exactly one sale or release. Sale/release requests require idempotency records, and a terminal creature cannot be paid or removed twice.
- Reasoning summary: Client fields, tool attributes, rendered model scale, UI labels, or Workspace objects can be forged or stale. Server-owned persisted inputs and atomic terminal transitions prevent value forgery, duplication, cross-player sale, and sale/release races.
- Result: A security and persistence boundary is defined for future implementation. Exact schema, fixed-point units, value formula, quote behavior, ledger retention, and failure UX remain provisional.
- Test evidence: Read-only Data/Security design review on 2026-07-19. No code, remote, DataStore, adversarial, disconnect, multiplayer, or Roblox Studio test exists.
- Mistakes discovered: Earlier design records did not need a creature transaction boundary because first-playable creature selling had not yet been approved.
- Recommended future approach: Persist stable valuation inputs rather than sale prices, use checked bounded arithmetic, version valuation definitions, filter favorites server-side, reconcile uncertain commits from the ledger, and fail closed without item loss or duplicate payout.
- Confidence level: High for the security boundary; Medium for transaction details until a schema and failure model are approved
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Entry: Public repository disclosure review

- Date: 2026-07-18
- Agent: Codex / Security Agent
- System affected: Source control, repository privacy, contributor workflow
- Situation: The user asked to make `ogowl99-stack/Catch-a-Creature` public so a friend could help. Public visibility exposes committed files, branches, and reachable history to anyone.
- Decision made: Change the repository from private to public only after an informed confirmation, a read-only credential scan, and an independent Security Agent review.
- Reasoning summary: Public collaboration is useful, but visibility changes can disclose secrets and personal metadata irreversibly through clones or forks.
- Result: GitHub visibility changed to `PUBLIC` and was verified with `gh repo view`. The repository remains approved from a credential-risk perspective, with privacy caveats.
- Test evidence: Primary and independent heuristic scans covered 49 tracked files, 54 unique blobs, and all four locally reachable commits. They found no credential signatures or sensitive filenames. Tracked text contained no email addresses, local Windows user paths, or IPv4-like strings.
- Mistakes discovered: The GitHub CLI token had expired and required reauthentication. Two commits expose a non-noreply Gmail author address. Five PNGs contain nonstandard `caBX` chunks; three produced unclassified email-like binary candidates, so image-metadata privacy review is not fully conclusive.
- Recommended future approach: Use GitHub's noreply commit address, add an automated dedicated secret scanner before publication milestones, review nonstandard image metadata, and remember that public visibility does not grant direct push access without collaborator permission.
- Confidence level: High for GitHub visibility and scanned credential patterns; Medium for PNG privacy because three binary candidates remain unclassified
- Verification status: Verified
- Heuristic security scan status: Code-reviewed
- PNG metadata status: Blocked
- PNG metadata evidence note: Three binary candidates remain unclassified; no personal-data finding is verified.
- Independent review: Security Agent approved remaining public from a credential-risk perspective and recorded the author-email privacy warning.

## Entry: Economy authority

- Date: 2026-07-16
- Agent: Security Agent
- System affected: Purchases, inventory, economy, breeding, trading, weather, rewards
- Situation: Valuable persistent objects and randomized outcomes create duplication and forgery risks.
- Decision made: Every economic mutation is validated and resolved on the server. The client never selects item definitions, traits, quantities, prices, parents, provenance, or RNG outcomes.
- Reasoning summary: Client trust would allow exploiters to mint rare plants, creatures, currency, or purchase grants.
- Result: Security boundary recorded.
- Test evidence: Requires code review, adversarial tests, and Roblox Studio validation.
- Mistakes discovered: None yet.
- Recommended future approach: Threat-model every RemoteEvent and transaction before implementation approval.
- Confidence level: High
- Verification status: Not yet implemented

## Entry: Purchase processing

- Date: 2026-07-16
- Agent: Security Agent / Data Agent
- System affected: Monetization
- Situation: Repeatable purchases may include care supplies or community-event credits.
- Decision made: Use `MarketplaceService.ProcessReceipt` with an idempotent persistent receipt ledger. Never grant from client prompt completion.
- Reasoning summary: Receipt callbacks can retry and client events do not prove payment.
- Result: Purchase architecture requirement recorded.
- Test evidence: Official Roblox documentation; local implementation absent.
- Mistakes discovered: None yet.
- Recommended future approach: Test duplicate delivery, disconnects, full inventory, unknown products, stale catalogs, and uncertain saves.
- Confidence level: High
- Verification status: Verified
- Evidence class: Official Roblox platform documentation
- Local implementation: Not yet implemented

## Entry: Provenance

- Date: 2026-07-16
- Agent: Security Agent / Data Agent
- System affected: Plants, creatures, breeding, trading
- Situation: Paid, event, wild, bred, and adapted origins may have different eligibility and policy rules.
- Decision made: Persistent objects require unique IDs, definition IDs, owner/origin data, parent references where applicable, paid-origin markers, functional and cosmetic trait separation, and trade/progression eligibility.
- Reasoning summary: Provenance is necessary to prevent laundering paid or duplicated value through breeding and trading.
- Result: Data requirement recorded.
- Test evidence: Requires schema and tests.
- Mistakes discovered: None yet.
- Recommended future approach: Define provenance before any persistent item can reproduce or transfer.
- Confidence level: High
- Verification status: Not yet implemented
