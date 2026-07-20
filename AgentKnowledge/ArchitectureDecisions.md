# Architecture Decisions

## ADR-011: Failure decisions are personal; rare celebration follows durable ownership

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent / UI Agent / VFX Agent / Audio Agent / Performance Agent / QA Agent / Codex
- System affected: Capture outcomes, decision tokens, queue state, Familiarity, consumables, ownership commit, cutscene, VFX, audio, and cleanup
- Situation: The user approved exact failed-attempt costs, Familiarity guarantees, round-robin retry, Retry/Let Go choice, and a rare-success cutscene/VFX.
- Decision made: Every accepted attempt consumes one Haven Tag and the selected free Luck aid, if any. A committed failure records one failure, advances exactly one +2-point Familiarity step, releases the global attempt lock, and returns the encounter to its current Wild phase before the server issues a one-use failure decision token. `Retry Capture` consumes that token once to create at most one queue intent, behind already-waiting distinct eligible contenders or immediately if none waits; it defaults to No Aid. Luck selection is disabled when the server preview marks the next attempt guaranteed. `Let Go` consumes the same decision token, removes only that player's pending intent, and leaves the global visitor, timer, traits, and all other contenders unchanged. During caretaker priority it preserves the remaining exclusive window and does not substitute for the separate `Open to Everyone` control. A decision cannot cancel an in-flight attempt, refund already-committed items, or change Familiarity. Success atomically consumes the accepted-attempt inputs, creates one immutable owned UUID with the fixed visitor payload, reserves capacity, resets only the matching Familiarity key, and records the outcome. Only after that durable commit may the server terminate the wild encounter and emit one idempotent sanitized `CaptureCommitted` celebration descriptor. Server-derived Mythic descriptors request the approved full sequence; Legendary descriptors request the shorter flourish. Celebration code is presentation-only and cannot award, reroll, remove, or roll back ownership.
- Reasoning summary: Separating the durable transaction from the optional decision and cosmetic phases prevents double consumption, queue duplication, global visitor release, false ownership, and cosmetic failure from corrupting gameplay state.
- Result: The state/transaction boundary is code-reviewed. Accepted-attempt consumption, No Aid retry default, guaranteed-attempt Luck disabling, caretaker Let Go behavior, Mythic/Legendary tiers, and visual duration/audience/settings are user-approved. Exact record fields, technical commit grace, Luck formula/recipes, audio configuration, and measured effect budgets remain unresolved. No implementation exists.
- Test evidence: Direct user direction and independent Security/Architecture, QA/UI, and VFX/Audio/Performance reviews on 2026-07-19. No Luau, schema, fault injection, multiplayer, Studio, device, accessibility, or performance evidence exists.
- Mistakes discovered: Treating Retry as automatic would bypass the user's choice and round-robin fairness. Treating Let Go as a global encounter command would let one contender remove a creature from everyone. Emitting success VFX before durable ownership would create false-capture and replay bugs.
- Recommended future approach: Use one-use request/decision/outcome IDs, a one-intent-per-user distinct queue, definition-version metadata that preserves Familiarity, client celebration dedupe, immediate cosmetic skip, guaranteed camera/input restoration, bounded effect lifetimes, and fault-injected commit/event tests before UI polish.
- Confidence level: High for transaction ordering and personal Let Go; Medium for record shape; Low for presentation budgets until measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## ADR-010: Immediate retry is serialized, idempotent, and Familiarity-backed

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent / Performance Agent / QA Agent / Game Design Agent / Codex
- System affected: Capture attempts, no-cooldown retry, request idempotency, Familiarity, consumables, contention, timers, persistence, UI, and performance
- Situation: The user approved rising capture chance after each valid failure and rejected any post-failure gameplay cooldown.
- Decision made: No artificial timer blocks a retry after a valid failure. A player may submit the next attempt as soon as the previous server result is durable and acknowledged. This does not permit overlapping rolls, client-side auto-repeat, or prebuffered attempts. Maintain at most one active roll per encounter and player, with a one-use server attempt token and idempotent request ID. Invalid, duplicate, stale, busy, out-of-range, full-storage, or expired requests cause no RNG, consumption, Familiarity, VFX, or persistence work. An accepted failure atomically consumes one Haven Tag and the selected free Luck aid, if any; records its outcome; and increments persistent player × stable creature-definition ID × rarity-tier Familiarity once. Each failure adds two absolute percentage points; guarantees occur on attempts 2/3/5/8/15/25 for Common/Uncommon/Rare/Epic/Legendary/Mythic. Progress persists across visitors, rejoins, and another winner and resets on matching creature-definition-ID success. Success durably creates one owner and terminates the encounter. Every preview is recomputed by the server and shows current/next chance and guarantee progress. The 60-second caretaker priority and five-minute public hard deadline do not extend because of retries; an attempt accepted before expiry may receive a bounded technical commit grace. Public ordering keeps at most one pending intent per player and places a failed player's deliberate retry behind already-waiting distinct contenders; it begins immediately if nobody waits.
- Reasoning summary: Immediate gameplay pacing and safe serialization are compatible. One-use tokens, idempotency, and conditional reservation stop spam from becoming multiple rolls, while persistent Familiarity makes a five-minute contested encounter's failed effort survive despawn or another winner.
- Result: No-cooldown immediate retry, all accepted-attempt consumption, +2-point Familiarity key/persistence/reset/guarantees, fair distinct-contender rotation, No Aid retry default, guaranteed-attempt Luck disabling, priority/lifetime, and exactly-one server result are approved directions. One-in-flight/idempotency and no-work rejection are required safeguards. Luck formula/recipes and technical commit-grace length remain provisional.
- Test evidence: Direct user approval plus read-only Architecture/Security/Performance and Game Design/Economy/QA reviews on 2026-07-19. No implementation, fault test, queue simulation, persistence measurement, or Studio evidence exists.
- Mistakes discovered: Equating “no cooldown” with accepting every click would allow concurrent requests, duplicate rolls, queue flooding, and multiple consumption/Familiarity commits. A server transport throttle is abuse protection, not a hidden gameplay cooldown.
- Recommended future approach: Implement a pure attempt state machine before UI/VFX; use bounded one-use tokens and idempotency records; persist Familiarity with definition versions; make outcome/consumption/progress one transaction; revalidate pending intents; and measure throughput under eight-player spam before tuning.
- Confidence level: High for serialization/idempotency; Medium for fair rotation; Low for persistence/throughput until tested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## ADR-009: Wild capture owns nothing until one atomic server commit

> Follow-up (2026-07-19): ADR-010 removes the proposed post-failure cooldown and adds approved immediate rising-chance retry plus serialized attempt safeguards. ADR-009's exact-one ownership and capacity-before-RNG rules remain active.

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent / Monetization Agent / Performance Agent / QA Agent / Game Design Agent / Codex
- System affected: Wild encounters, Observe/Care, capture RNG, Backpack capacity, consumables, ownership, persistence, concurrency, remotes, UI, performance, and later paid theft
- Situation: The user changed the terminal visitor interaction from deterministic bonding to a chance-based capture direction and specified that an unclaimed visitor can be caught by anyone. If a player lacks storage, they cannot catch or claim it; it remains available.
- Decision made: A wild encounter has no owner until one server-authoritative capture transaction durably creates exactly one owned-creature record. The server owns stable encounter ID/revision, definition/rarity versions, host plot, state, timing, transform region, capture eligibility, exact integer probability, modifiers, roll, reservation, and result. A request first rejects invalid state, access/distance, stale revision, ineligibility, one-in-flight conflict, item, rate, or full Backpack before RNG or consumption. It then reserves one Backpack slot and conditionally reserves the encounter for one request. Busy or invalid contenders consume nothing and do not roll. One accepted attempt uses one recorded server roll; success durably consumes approved items, creates one immutable owned creature with origin/provenance, occupies the slot, and only then removes the wild visitor. An accepted failure consumes one Haven Tag and the selected free Luck aid, records one +2-point Familiarity step, releases slot/reservation, returns the visitor directly to Wild, and opens the deliberate Retry/Let Go decision. Duplicate request IDs return the recorded outcome. Wild visitors never qualify for later paid stealing.
- Reasoning summary: One conditional winner, revision checks, idempotency, and storage reservation prevent duplicate owners, lost consumables, final-slot races, and client-forged odds. Separating validation from accepted rolls keeps spam from triggering RNG, persistence, VFX, or pathfinding. Keeping all chance inputs free-only avoids unintentionally connecting Robux to randomized creature acquisition.
- Result: The no-owner-before-success, full-storage-no-roll/no-consumption, public-wild fallback, personal Observe/Care Trust gate, 60-second priority/open early, Haven Tag, capture table, no-cooldown deliberate retry, all accepted-attempt consumption, exact Familiarity increments/guarantees/persistence/reset, public round-robin, No Aid retry default, guaranteed-attempt Luck disabling, five-minute public lifetime, proximity, free next-attempt Luck boundary, starting caps, and exactly-one-winner boundaries are approved. Server transaction safeguards are code-reviewed requirements. Arrival tables, Luck formula/recipes, and technical commit grace remain provisional.
- Test evidence: Direct user direction plus independent Architecture/Data/Security/Monetization/Performance and Game Design/Economy/QA reviews on 2026-07-19. No Luau module, RNG simulation, DataStore fault test, multiplayer contest, performance measurement, or Studio test exists.
- Mistakes discovered: ADR-007's “full-capacity bonded creature remains owned on the plot” assumed ownership was already granted. That assumption is invalid for the new wild capture step. Arrival rarity and capture difficulty also require separate fields; otherwise a tiny number can be misinterpreted or multiplied twice.
- Recommended future approach: Define a pure encounter state machine and deterministic fault-injection tests before UI or world effects; use parts-per-million integer probabilities and checked caps; expose server-computed base/final odds; keep one in-flight attempt per creature/player; make free capture and luck materials account-bound and independent of every paid value chain; and measure bounded wandering rather than continuous pathfinding.
- Confidence level: High for transaction invariants; Medium for the proposed state flow; Low for thresholds and caps until approved and measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Supersession of ADR-007 bonding fallback

ADR-007 remains authoritative for occupied-slot counting, ordinary harvest/produce retention, existing owned-creature recall, and no-deletion over-capacity recovery. Its statement that a new full-capacity bond becomes owned on the plot is superseded for wild capture: no Backpack reservation means no roll, no item consumption, no ownership grant, and the visitor remains wild.

## ADR-008: Repeatable permanent capacity uses idempotent Developer Product grants

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent / Monetization Agent / Performance Agent / QA Agent / Codex
- System affected: Marketplace receipts, permanent capacity units, purchase caps, persistence, paged inventory, recovery, and UI
- Situation: The user replaced a one-time storage pass with repeatable permanent +200 purchases and requested unlimited stacking. Roblox passes cannot be repurchased, while developer products can; all paid benefits still require finite, testable delivery guarantees.
- Decision made: Supersede the storage-pass entitlement design in ADR-007 only for paid grant delivery. One allow-listed Developer Product grants one permanent +200 capacity unit per unique `PurchaseId`. The single server-owned `ProcessReceipt` callback validates player/product, session-locks the profile, durably records the receipt and increment exactly once, then returns `PurchaseGranted`; uncertain or failed persistence returns `NotProcessedYet`. `PromptProductPurchaseFinished` may refresh presentation but never grants. Duplicate, delayed, concurrent, out-of-order, or cross-server retries read the durable ledger and cannot increment twice. Configuration declares base 200, +200 per grant, a measured finite `MaxOperationalGrants`, and tested emergency headroom so a late valid receipt can still be honored. External sales are disabled, only one storage prompt may be outstanding per player, and prompts stop before the operational maximum. Capacity remains derived with checked arithmetic. Literal infinite capacity is rejected as an architectural promise; finite paged/sharded storage may increase tested ceilings later.
- Reasoning summary: Developer products match repeat purchase semantics, but Roblox does not make storage, throughput, server memory, replication, or clients infinite. A receipt may only be acknowledged after the exact paid benefit is durable, so the game must know and enforce a tested deliverable range before prompting.
- Result: Product type and receipt transaction boundary are approved. Follow-up: the user approved five grants/1,200 total slots as the launch operational maximum; implementation remains blocked on measurement and tested emergency receipt headroom. Price, product ID, ledger retention, page/shard layout, refund/revocation source, and cross-page batch transaction design remain provisional.
- Test evidence: Current official Roblox Developer Product and Data Store limit documentation plus two read-only specialist reviews on 2026-07-19. No Marketplace, DataStore, receipt, load, profile-size, UI, economy, device, or Studio evidence exists.
- Mistakes discovered: A game pass cannot provide repeat purchases. A naive unbounded integer grant count would let UI prompts sell benefits beyond the architecture's proven persistence and rendering capacity.
- Recommended future approach: Prototype an idempotent receipt ledger and compact capacity counter; measure one-profile versus paged storage through every proposed tier; choose maximum and headroom from evidence; then test receipt crashes/races before creating or exposing a live Developer Product.
- Confidence level: High for Developer Product and receipt invariants; Medium for finite ceiling/page design until measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Supersession of ADR-007 paid-entitlement mechanism

ADR-007 remains authoritative for occupied-slot counting, ordinary harvest/produce retention, existing-owned-creature recall, and over-capacity no-deletion recovery. Its `UserOwnsGamePassAsync` paid-grant mechanism is superseded by this Developer Product receipt ledger; ADR-009 supersedes its new-bond-on-full fallback.

## ADR-007: Occupied-slot capacity and verified permanent expansion

> Follow-up (2026-07-19): ADR-008 supersedes this entry's one-time pass mechanism with repeatable +200 Developer Product receipt grants and a finite tested operational maximum. Occupied-slot, reservation, and no-deletion recovery rules remain active.

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent / Monetization Agent / QA Agent / Codex
- System affected: Inventory, hotbar, stacking, harvesting, tree produce, creatures, deployed assets, persistence, over-capacity recovery, and later theft concurrency
- Situation: The approved storage rules require one authoritative counting and recovery definition that cannot delete items, duplicate final-slot grants, or lose exposed assets when storage is full.
- Decision made: Capacity counts occupied authoritative Backpack slots. Ten hotbar references add no capacity. Compatible ordinary-seed stacks cap at 999. Trait-bearing/Adapted Seeds share a stack only when their complete server-canonical immutable payloads match. Unique weighted/mutated whole plants, weighted tree produce, and stored creatures each occupy one slot. Planted crops and roaming/displayed owned creatures consume no Backpack slot but use separate finite server-owned caps. Every slot-increasing operation reserves capacity inside the same revision-checked transaction that changes item state. A full ordinary harvest leaves the exact mature UUID unchanged; one-at-a-time tree collection retains the exact selected ripe produce; an already-owned roaming creature that cannot be recalled remains the exact owned creature on the plot. ADR-009 governs new wild capture: full storage means no roll, consumption, or ownership, and the visitor remains wild. Capacity reductions never delete or hide items: an over-capacity profile retains everything and may perform slot-reducing actions but cannot add occupied slots until within capacity. Paid grant delivery is governed only by ADR-008.
- Reasoning summary: Slot reservation closes final-slot races, complete canonical stack equality prevents trait/provenance merging, separate deployed caps preserve performance, and over-capacity recovery preserves the no-loss promise under migrations or later corrections.
- Result: The 200 base slots, 999 compatible ordinary-seed maximum, special-seed equality exception, individual weighted tree produce and other unique assets, zero-capacity hotbar, deployed-slot behavior, one-at-a-time tree collection/full selected-produce retention, existing-owned-creature recall fallback, and capture starting caps of two wild/six displayed owned creatures per plot and 64 simulated per server are approved. The creature caps remain unmeasured. Wild capture uses ADR-009/010. Exact canonical stack key implementation, plant/other deployed cap numbers, item/page schemas, migration policy, and remote contracts remain provisional.
- Test evidence: Direct user decisions and read-only Architecture/Data/Security/Monetization plus Game Design/QA reviews on 2026-07-19. No schema, persistence test, capacity race, migration, performance measurement, or Studio evidence exists.
- Mistakes discovered: Counting Roblox Tools as storage would duplicate inventory authority. The earlier one-time pass mechanism in this ADR was later superseded by ADR-008.
- Recommended future approach: Define pure capacity/stack/harvest/deploy state transitions and fault tests; measure separate plot/roaming caps; virtualize inventory rendering; and use ADR-008 for every paid grant.
- Confidence level: High for the invariants; Medium for exact caps and schemas until implemented and tested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## ADR-006: Explicit plant harvest modes and one authoritative inventory

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent / Gameplay Agent / Codex
- System affected: Plant definitions, growth, harvesting, inventory, hotbar, persistence, selling, and migrations
- Situation: The user superseded an earlier blanket-regrowth assumption by making ordinary plants single-harvest while reserving repeat production for explicit classes such as trees. The user also clarified that ten visible slots are quick access and a backpack exposes the wider inventory.
- Decision made: Every versioned server-owned plant definition must declare `HarvestMode = SingleHarvest | Regrower`. Missing, invalid, or unapproved behavior fails validation; ordinary definitions use `SingleHarvest`, and `Regrower` is restricted to an explicit allow-list. Each planted instance records the behavior/schema version needed for safe migration. A mature `SingleHarvest` transaction revision-checks the item, atomically removes the parent, and grants exactly one harvested output. A mature `Regrower` transaction grants its approved output, retains the parent, and advances the authoritative cycle timestamp. One authoritative inventory owns item records; hotbar slots store references to eligible item IDs and never duplicate items.
- Reasoning summary: Definition-owned behavior avoids inferring persistence from names or models, and one item identity across backpack/hotbar prevents divergent ownership, duplication, and loss.
- Result: The architectural contract is approved for design. ADR-007 locks 200 base slots, occupied-slot reservation, hotbar zero capacity, and ordinary full-storage retention; ADR-008 plus user follow-up lock the 999 maximum, special-seed/weighted-produce/deployed-slot behavior, one-at-a-time tree collection, and five-grant/1,200 launch capacity; ADR-009/010 govern wild capture, including approved but unmeasured starting caps of two wild/six displayed owned per plot and 64 simulated per server. Exact Luau types, canonical stack key, product price/ID/emergency headroom, plant/other deployed caps, transaction/page storage, migration policy, tree catalog, and remote contracts remain provisional.
- Test evidence: Direct user decisions plus read-only Architecture/Data/Security and QA review on 2026-07-19. No code, schema validator, transaction test, migration test, or Studio evidence exists.
- Mistakes discovered: The prior design language generalized one regrowth behavior to all flora and could have encoded an incorrect default. Treating hotbar slots as separate storage would create multiple representations of ownership.
- Recommended future approach: Implement definition validation and pure state-transition tests before UI or world models; use immutable item IDs, expected revisions, idempotency keys, and a no-loss full-storage rule; then prove save/load and migration before enabling harvest remotes.
- Confidence level: High for the boundary; Medium for persistence details until prototyped
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

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
