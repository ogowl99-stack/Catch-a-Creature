# Security Findings

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
