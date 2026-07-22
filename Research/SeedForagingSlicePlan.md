# Seed Foraging Slice Plan and Result

- Date: 2026-07-21
- Owner: Codex acting in Gameplay, Data, Map, Security, UI/VFX, Performance, and QA roles
- Truth status: Verified for the one-client Studio behavior described below; production DataStore and multi-client behavior remain unverified

## Recall

The slice reuses the existing server-authoritative farm domain, profile repository, exact seed stacks, 200-slot Backpack limit, numbered hotbar projection, commit-before-acknowledgement rule, and Rojo-owned code roots. Mythic remains the highest existing rarity; “super rare” is not a seventh tier.

## Intended approach

1. Define a bounded rarity table and more possible ground locations than active sprouts.
2. Let the server choose a reward only after validating player state, distance, node identity, cooldown, and inventory capacity.
3. Store per-player cooldowns by stable node ID in profile schema v4.
4. After a successful durable grant, relocate the globally visible node to a different unused ground location. Rejected or cooldown attempts do not move it.
5. Emit a sanitized capturer-only Mythic presentation event only after the successful mutation; presentation never grants an item.

## Files affected

- `src/server/Definitions/ForageDefinitions.luau`
- `src/server/Definitions/PlantDefinitions.luau`
- `src/server/Data/ProfileSchema.luau`
- `src/server/Domain/FarmDomain.luau`
- `src/server/Services/FarmService.luau`
- `src/server/Services/ForageWorldService.luau`
- `src/server/FarmBootstrap.server.luau`
- `src/shared/FarmContracts.luau`
- `src/shared/Remotes.model.json`
- `src/client/FarmController.client.luau`
- farm, service, and forage test modules

## Dependencies and risks

- Depends on the existing profile repository, farm snapshots, plant definitions, and runtime graybox.
- Security risks: forged rewards, remote reward selection, remote calls from outside the prompt, cooldown bypass, repeated RNG attempts, and full-inventory loss.
- Performance risks: unbounded nodes/effects, permanent particles, and repeated world scans.
- Compatibility risks: schema migration, preserved exact hotbar references, and no natural Mythic result while the catalog lacks a Mythic seed definition.

## Rollback approach

Remove `ForageWorldService` startup and the `ForagePresentation` connection first, leaving schema v4 fields harmless and empty. Then remove the forage action/definition modules and tests in one reviewed source change. Never downgrade or wipe a saved profile merely to remove this feature.

## Result

- Six active sprouts use 18 valid spawn points across west, south, and east meadow/grove regions.
- A successful forage grants exactly one eligible server-selected seed and starts a 120-second per-player cooldown on the stable node ID.
- The successful sprout moves to another unoccupied spawn point and cannot remain at its previous point.
- Cooldown, invalid, out-of-range, busy, full-inventory, and no-eligible-reward attempts do not roll or relocate.
- The rarity weights are experimental. The complete table reserves 70% Common, 20% Uncommon, 7% Rare, 2.5% Epic, 0.45% Legendary, and 0.05% Mythic when all six tiers have eligible seed definitions. Empty tiers are excluded and remaining weights are renormalized.
- The current catalog only has Common Sunspud and Uncommon Hearthpetal, so Rare through Mythic cannot naturally drop yet.
- A Mythic success descriptor produces local gold/purple ground energy, a rising seed, bounded motes, a world label, and a brief banner, then cleans itself up.

## Test evidence

- Fresh Studio run: 37 FarmDomain, 5 FarmService, 5 CreatureWorldService, and 7 ForageWorldService tests passed (54 total).
- Live one-client prompt activation granted one Hearthpetal and advanced the profile revision from 0 to 1.
- The same `wild-sprout-1` moved from `west-01` at `(-316, 45.16, -20)` to `south-03` at `(28, 45.16, -350)` after success.
- A retry during cooldown kept the profile revision at 1, the Hearthpetal quantity at 1, and the node at `south-03`.
- All 18 candidate locations raycast to graybox ground; zero were missing.
- A presentation-only Mythic event rendered correctly in Studio and cleaned up. This is `Simulated`, not evidence of a natural Mythic reward.
- Studio console showed no forage errors. Strict UTF-8 passed for 69 project files, `clips.json` parsed, `git diff --check` passed, and the final Rojo 7.7.0 validation produced a fresh sourcemap and a 190,410-byte build for the authorized place while keeping Workspace unmapped.

## Self-review and reflection

- Correctness: reward selection, profile mutation, relocation, and presentation are separated and ordered.
- Security: the client cannot supply the private grant token or select its reward; distance is rechecked on the server.
- Performance: only six nodes exist, each node is bounded, and Mythic effects use automatic cleanup.
- Cleanup: node connections and presentation instances have bounded teardown paths.
- Compatibility: v1-v3 profiles migrate to schema v4 and preserve existing farm state.
- Mobile/controller: the ProximityPrompt exposes keyboard, gamepad, click, and touch activation, but real device tests remain required.
- Multiplayer: global relocation with per-player stable-node cooldown is intentional, but multi-client contention remains required.
- Independent review: not run in this turn; current evidence is Codex self-review plus automated and live Studio tests.

## Recommended next work

Add at least one reviewed seed definition for each intended rarity before balancing the table, run deterministic distribution simulations, test simultaneous two-player activation, verify schema v4 in an isolated DataStore leave/rejoin, and test the prompt/VFX on phone, tablet, controller, and a low-end device.
