# Security Findings

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
