# Successful Approaches

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
