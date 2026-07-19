# Architecture Decisions

## ADR-005: Separate paid credit delivery from live ownership transfer

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent / Codex
- System affected: Developer products, paid stealing, persistent items, cross-player ownership, inventory, provenance, and recovery
- Situation: A developer-product receipt identifies the buyer and product but cannot safely carry a mutable plot target through purchase, disconnect, ownership changes, or DataStore failure.
- Decision made: `MarketplaceService.ProcessReceipt` idempotently grants one persistent buyer-bound Steal Credit keyed by purchase ID. A separate server-authoritative transaction conditionally transfers one immutable item ID from its expected owner/state into a protected buyer inbox, appends paid-steal provenance, and consumes the credit exactly once. A durable ledger and reconciler complete projections after interruption; the authoritative invariant is one item ID, one owner, and one successful credit consumption.
- Reasoning summary: Separating durable purchase fulfillment from volatile target selection prevents lost purchases, random substitutions, duplicate grants, and partial cross-profile transfers.
- Result: The future architectural boundary is approved for design. Exact record schema, storage topology, conditional-write implementation, reservation TTL, reconciliation schedule, and retention remain provisional.
- Test evidence: Official Roblox developer-product documentation and read-only Architecture/Data/Security review on 2026-07-19. No code, DataStore, receipt, multiplayer, or Studio test exists.
- Mistakes discovered: A direct receipt callback cannot promise a selected live target; waiting indefinitely on that target would fail purchase fulfillment, while blindly transferring it risks stale ownership or duplication.
- Recommended future approach: Prototype the credit ledger and item ownership state machine with deterministic fault injection before enabling any Robux prompt.
- Confidence level: High for the separation principle; Medium for the cross-profile implementation until prototyped
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## ADR-001: Server authority

- Date: 2026-07-16
- Agent: Architecture Agent / Codex
- System affected: Economy, inventory, RNG, progression, purchases, trading, weather
- Situation: The design contains valuable items, mutation chances, offline progress, and possible future trading.
- Decision made: The server will authoritatively resolve inventory mutations, purchases, harvests, creature grants, breeding, adaptations, weather results, and economic transactions.
- Reasoning summary: Client authority would enable duplication, forged outcomes, impossible traits, and fraudulent purchase grants.
- Result: Architecture rule established; no implementation exists.
- Test evidence: Requires automated validation and Roblox Studio testing.
- Mistakes discovered: None yet.
- Recommended future approach: Clients request allowed actions; the server validates context, resolves results, persists state, and emits presentation events.
- Confidence level: High
- Verification status: Not yet implemented
## ADR-002: Data-driven content

- Date: 2026-07-16
- Agent: Architecture Agent / Codex
- System affected: Flora, creatures, traits, weather, rewards, events
- Situation: The game may eventually contain many content definitions and live-event variants.
- Decision made: Keep content values in versioned server-owned definitions rather than scattered conditional code.
- Reasoning summary: Data-driven definitions improve balancing, testing, migrations, source review, and controlled event reuse.
- Result: Architectural direction recorded.
- Test evidence: Requires implementation.
- Mistakes discovered: None yet.
- Recommended future approach: Define stable identifiers, schema versions, validation, and migration rules before persistent data is released.
- Confidence level: High
- Verification status: Not yet implemented

## ADR-003: Roblox-first validation, Blender-after-scale lock

- Date: 2026-07-16
- Agent: Architecture Agent / Map Agent
- System affected: World, models, interactions, production pipeline
- Situation: Final assets will be produced in Blender, but plot, camera, navigation, and interaction scale are not proven.
- Decision made: Graybox in Roblox first; validate one representative plant and creature through the Blender import pipeline before producing the full catalog.
- Reasoning summary: Scale and interaction changes are cheap in a graybox and expensive after modeling, rigging, texturing, and animation.
- Result: Production order established.
- Test evidence: Requires Roblox Studio and Blender tests.
- Mistakes discovered: None yet.
- Recommended future approach: Lock a shared avatar reference, pivot convention, transforms, collision approach, and export preset through a small test scene.
- Confidence level: High
- Verification status: Not yet implemented

## ADR-004: Feature order

- Date: 2026-07-16
- Agent: Gameplay Agent / Codex
- System affected: Roadmap
- Situation: The design includes planting, visitors, breeding, events, monetization, customization, and possible trading.
- Decision made: Complete the smallest planting-attraction-bonding-adaptation loop before breeding, trading, events, or monetization.
- Reasoning summary: Later features depend on a stable economy, persistence model, and compelling atomic loop.
- Result: First-playable scope recorded.
- Test evidence: Requires prototype testing.
- Mistakes discovered: Initial brainstorming accumulated later-game ideas before the core was formally bounded.
- Recommended future approach: Treat deferred systems as design notes until acceptance gates are satisfied.
- Confidence level: High
- Verification status: Not yet implemented
