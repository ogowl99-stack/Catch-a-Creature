# Successful Approaches

## Pattern: Exact equipped sale plus favorite-safe Backpack bulk sale

- Date: 2026-07-21
- Agent: Codex / Gameplay, Data, Security, and UI roles
- System affected: Inventory economy and loss prevention
- Purpose: Support quick single and bulk selling without trusting the client or accidentally selling protected items.
- Approved use cases: Exact-item single sale and whole-Backpack unfavorited sale.
- Example implementation: The server tracks the equipped hotbar item for the session; `SellItem` must match that exact item ID and revision; `SellAllUnfavorited` scans authoritative Backpack state atomically and skips `favorite == true` items.
- Limitations: Equip state does not survive rejoin; actual multi-item live bulk UX and multiplayer races remain untested.
- Performance characteristics: One bounded Backpack scan at the current 200-slot base capacity.
- Security considerations: Never accept client-authored payout, ownership, favorite exclusions, or fallback item selection.
- Required tests: Unequipped rejection/no mutation, exact equip success, favorite-only no-op, mixed exact payout, hotbar cleanup, replay, stale revision, capacity, disconnect/rejoin, and devices.
- Result: Live unequipped rejection, favorite no-op, and equipped exact sale passed; deterministic mixed bulk tests passed.
- Test evidence: Farm Domain 40 and Farm Service 6 inside the final 58-case fresh-server run.
- Mistakes discovered: None after the server equip gate became the authority boundary.
- Recommended future approach: Reuse this split for future creature/item markets and keep favorite protection free.
- Confidence level: High for current bounded inventory
- Verification status: Verified

## Pattern: Guarded non-Terrain graybox migration

- Date: 2026-07-21
- Agent: Codex / Map and Architecture roles
- System affected: Live Studio map iteration
- Purpose: Change a verified large map without destructive rebuild or Terrain risk.
- Approved use cases: Deterministic anchored-part layout revisions under one namespaced root.
- Example implementation: Refuse unexpected root/count/tag state; snapshot original CFrame/Size/Name and selected metadata on affected existing instances; tag additions; mutate in a pcall; ship a rollback that verifies expected state before restoration.
- Limitations: Attribute snapshots increase metadata and are not a substitute for source control, saved place versions, or final-art migration tooling.
- Performance characteristics: No runtime loops and no extra Instances for snapshots; 118 added parts in this revision.
- Security considerations: This is developer tooling only and must not be callable by players.
- Required tests: Syntax, refusal on changed baseline, exact final geometry, rollback syntax, expected-state guards, and post-migration gameplay regression.
- Result: First unsuitable name preflight refused; semantic-tag retry completed with Terrain untouched.
- Test evidence: 2,456 geometry checks, exact counts, fresh play, and clean logs.
- Mistakes discovered: Semantic identity must not be inferred from historical names.
- Recommended future approach: Keep the constructor, migration, rollback, and validator together for every major graybox revision.
- Confidence level: High
- Verification status: Verified

## Pattern: Commit, relocate, then present

- Date: 2026-07-21
- Agent: Codex / Architecture, Data, Gameplay, Map, and VFX roles
- System affected: Renewable world interactions with durable rewards
- Purpose: Keep durable inventory, shared world state, and optional celebration consistent.
- Approved use cases: Server-authoritative resource nodes whose successful reward should change world presentation.
- Example implementation: Validate and choose the reward server-side; commit the profile mutation; return a sanitized result; relocate the stable node to a different unused point; finally emit a local rare-presentation descriptor.
- Limitations: Global relocation plus per-player cooldown needs multiplayer contention tests; it is not complete bot prevention.
- Performance characteristics: Six active nodes, bounded descendants, no polling loops, and auto-cleaned local effects.
- Security considerations: Never relocate or celebrate an optimistic client result; never accept desired reward/rarity from the client.
- Required tests: Invalid/full/cooldown no-op, exact replay, current/occupied point exclusion, no-valid-point fallback, commit failure, multi-client contention, and presentation cleanup.
- Result: The live node, reward, and cooldown stayed consistent across success and rejection.
- Test evidence: 54 automated tests and one-client Studio interaction.
- Mistakes discovered: None after adopting the ordering; fixed-position-only design is recorded separately.
- Recommended future approach: Reuse this ordering for future world pickups and rare gathering events.
- Confidence level: High for one client
- Verification status: Verified

## SA-006: Reserve a new fixed seed slot without losing exact Backpack items

- Purpose: Add a new always-addressable seed type to a saved custom hotbar without deleting or mutating an item that occupied the newly reserved slot.
- Approved use cases: Small bounded additions to fixed seed/tool slots when exact inventory items live separately and hotbar entries are zero-capacity references.
- Example implementation: Bump the schema; add the canonical stack; overwrite the newly reserved slot with its stable seed reference; validate the displaced reference resolves to the caller's Backpack item; move only that reference to the lowest free eligible item slot; if no slot is free, leave the exact item safely stored and unassigned; then validate the full migrated profile.
- Limitations: This does not scale to frequent slot reshuffling or arbitrary player layouts. Once schema v3 is written, rollback must retain v3 decode support.
- Performance characteristics: Bounded scan across eight item slots and profile validation; negligible at current limits.
- Security considerations: Never trust a client-proposed destination, never change item identity/revision/location/capacity during reference migration, and fail closed on malformed or foreign references.
- Required tests: v1 and v2 inputs; occupied slot; full quick slots; exact item preservation; duplicate/malformed references; deterministic destination; save/rejoin; and no profile-revision mutation from decode alone.

## SA-005: Fingerprinted isolated DataStore rejoin test

- Purpose: Prove ordinary Studio DataStore continuity without touching production player data.
- Approved use cases: Schema migrations, money/inventory/hotbar/plot rejoin checks, offline timestamp behavior, request replay, and cleanup verification.
- Example implementation: Use a dated non-production namespace and one exact user key; seed deterministic IDs, weights, revisions, timestamps, and money; validate the write through an authoritative `UpdateAsync`; enable the test store with a Studio-only ServerStorage flag; mutate through the normal RemoteFunction; leave and verify the lease clears; rejoin and compare public projection, raw state, and runtime world model; replay the fixed request ID; fingerprint the final record; then remove only that key and flag and reconfirm default memory mode.
- Limitations: One Studio client does not prove production scale, hard-crash recovery, throttling, ambiguous commits, multi-server takeover, real devices, or multiplayer.
- Performance characteristics: Uses a small bounded number of DataStore requests against one isolated key; do not run repeatedly or in parallel.
- Security considerations: Production must ignore the Studio test flag. Never print session tokens, clear an unrecognized lease, remove an unfingerprinted key, or use the production namespace.
- Required tests: Schema validation/readback, exact before/after assertions, clean release, offline maturity, duplicate-request replay, exact runtime model count, cleanup confirmation, default-mode confirmation, unit regression suite, and clean build.

## SA-001: Research-to-originality transformation

- Purpose: Learn from a successful reference without copying its content.
- Approved use cases: Mechanics research, event analysis, presentation analysis, progression sequencing.
- Pattern: Identify the player need served by a reference mechanic, separate it from names/assets/balance, then design an original expression tied to Catch a Creature's sanctuary loop.
- Example: Crop-mutating weather becomes a habitat phenomenon that changes visitor behavior and Growth Memories.
- Limitations: Similarity must be re-evaluated during art, terminology, map, and content production.
- Performance characteristics: Not applicable.
- Security considerations: Economy consequences still require threat modeling.
- Required tests: Design review, player comprehension, originality review, and prototype evidence.

## SA-002: Truth-labeled project memory

- Purpose: Prevent assumptions from becoming fake implementation facts.
- Approved use cases: Research, architecture, tests, performance, Studio results, player feedback.
- Pattern: Record date, source/evidence, confidence, and one allowed truth label with each material claim.
- Limitations: Labels require maintenance as evidence changes.
- Performance characteristics: Not applicable.
- Security considerations: Do not store secrets, tokens, receipts, or private player data in documentation.
- Required tests: Documentation review and link/source checks.

## SA-003: Commit gameplay truth before optional celebration

- Purpose: Keep valuable random-acquisition state correct even when UI, camera, VFX, audio, streaming, or the client fails.
- Approved use cases: Rare capture, mutation reveal, milestone reward, paid receipt acknowledgment, achievement reveal, and other celebrations that follow a durable server result.
- Pattern: Validate and atomically commit authoritative ownership/currency/progress first; record an idempotent outcome; emit one sanitized presentation descriptor; dedupe locally; let presentation skip/degrade/fail without changing the committed result; restore camera/input and clean every temporary resource.
- Example implementation: A Mythic capture creates one owned creature UUID with exact traits and resets the matching Familiarity bucket before emitting `CaptureCommitted(outcomeId, summary, celebrationTier)` to the winner and a smaller nearby descriptor.
- Limitations: This pattern does not replace transaction recovery, schema migration, or Studio/device testing. The descriptor must not expose secrets or trust client-authored values.
- Performance characteristics: One compact network event; client-local animation; configurable effect tiers; bounded concurrency and lifetime.
- Security considerations: Server derives eligibility/tier/summary; duplicate outcome IDs cannot award again; cosmetics never mutate ownership.
- Required tests: Fault injection before/after commit/event; event replay; disconnect/rejoin; skip; missing assets; respawn/teleport; reduced motion; camera/input restoration; cleanup; and crowded-device profiling.

## SA-004: Scale connected map footprints as one dependency set

- Purpose: Preserve readable circulation and nonoverlapping functional zones when an island, plot, route, or shared-space footprint changes.
- Approved use cases: Plot-ring expansion, hub or event-space enlargement, reserve placement, mount roads, paths, gates, hills, and containment walls.
- Pattern: Keep numeric authority in one dimension contract; identify every dependent footprint; change centers and sizes together; derive entrances and paths from shared axes; run exact bounds/SAT checks; then verify representative humanoid routes and boundary collisions in Studio.
- Example implementation: The 96×96 plot change moved all eight centers outward, expanded the Hub and meadows, moved the gate and hills, placed a 20-stud 360×400-radius route, and closed the island with four invisible collidable walls. Static checks found zero final overlaps, and one-client traversal covered cardinal plots and every trail quadrant.
- Limitations: Graybox clearance does not prove final garden density, eight-player crowding, streaming behavior, real-device camera usability, or mount physics.
- Performance characteristics: The current expanded scene measured 55,898 non-shadow triangles and 63 non-shadow draw calls in one default desktop client view; this is a scoped baseline, not production approval.
- Security considerations: Geometry does not enforce plot ownership. Any future build, steal, mount, or teleport interaction must remain server-authoritative even when zones are spatially clear.
- Required tests: Source/dimension consistency, pairwise footprint overlap, generated-count metadata, land continuity, path/opening alignment, representative plot/trail traversal, four-side boundary collision, crowded multiplayer, real devices, streaming, and final-density performance.

## SA-007: Minimum-joint held-item presentation

- Purpose: Show an equipped item clearly without breaking avatar locomotion.
- Approved use cases: Client-local seed, plant, tool-preview, and inspect poses that do not affect server gameplay state.
- Pattern: Keep the held model noninteractive and locally rendered; update its position from the hand; constrain R15 IK to the arm; for R6, apply one shoulder transform after Animator output; restore the joint transform and disconnect frame callbacks on unequip/respawn.
- Example implementation: `HeldItemPresentation` places the R6 right hand at approximately torso-local `(1.5, 0.5, -1.5)` with `Right Shoulder.Transform = CFrame.Angles(0, 0, math.rad(90))` while the held Sunspud follows the arm endpoint.
- Limitations: R6 and R15 need separate branches; body scaling, emotes, swimming, climbing, tools, first person, touch, and controller still require coverage.
- Performance characteristics: One Motor6D write and one model pivot per frame for R6; one arm-only IKControl plus one model pivot per frame for R15.
- Security considerations: Visual state never grants inventory, placement, sale, or rewards; server state remains authoritative.
- Required tests: Equip/unequip, respawn, forward-hand geometry, movement, torso/root upright, no orphan model/callback, R6/R15, multiple body scales, emotes, and real device controls.

## SA-008: Share one pointer coordinate between reticle and ray

- Purpose: Make screen-space placement feedback match the server-bound world target.
- Approved use cases: Mouse/touch placement, build tools, world pings, and other cursor-targeted interactions.
- Pattern: Read one pointer coordinate, place the 2D reticle at it, and pass the same coordinate to the matching camera ray API. Color the reticle from the current local validity result, but let the server decide ownership, range, duplicates, and the canonical transform.
- Example implementation: Desktop placement uses `UserInputService:GetMouseLocation()` for both `UDim2.fromOffset(pointer.X, pointer.Y)` and `Camera:ScreenPointToRay(pointer.X, pointer.Y)`.
- Limitations: Touch and controller coordinate conventions need separate device tests; a local green state is not transaction approval.
- Performance characteristics: One bounded raycast while placement is active; no world preview Part or per-frame model pivot.
- Security considerations: The server ignores client claims of validity and rechecks the target against the assigned plot and distance limits.
- Required tests: Window inset, camera angles, plot edges, invalid surfaces, duplicate position, distance rejection, touch/controller, and exact saved-coordinate comparison.

## SA-009: Lowest-free durable hotbar allocator

- Purpose: Make acquisitions predictable while preserving deliberate player organization.
- Approved use cases: Seeds, harvested plants, and future creatures/items that reference authoritative inventory records.
- Pattern: Scan canonical string slots `"1"` through `"10"`, assign the first nil reference, remove references whose inventory truth no longer exists, and never compact other valid slots. Return the assigned slot in the authoritative command result.
- Example implementation: With an item in slot 1, a new harvest receives slot 2; with an item manually retained at slot 6 and slot 1 empty, a new harvest receives slot 1 while slot 6 remains unchanged.
- Limitations: A full hotbar needs an explicit no-loss policy; arbitrary drag-to-slot is a separate interaction contract; future creature storage is not yet implemented.
- Performance characteristics: At most ten comparisons per acquisition or lookup.
- Security considerations: The server selects slots and validates exact references; clients cannot invent item IDs, quantities, or ownership.
- Required tests: Every occupied-prefix length, gaps, full bar, duplicate refs, exhausted seed cleanup, migration, rejoin, manual-position preservation, and every acquisition type.
