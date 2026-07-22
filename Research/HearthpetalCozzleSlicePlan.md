# Hearthpetal and Cozzle Arrival Slice

- Date: 2026-07-21
- Agent: Codex (Gameplay / Data / UI / QA roles)
- Status: Implemented and one-player Studio-verified; experimental values/prototype visuals; no creature ownership yet

## Objective

Add Hearthpetal as a purchasable, plantable, harvestable, and durable Habitat Flora, then project one wild Cozzle visitor beside the player's earliest mature plotted Hearthpetal with a short visible entrance.

## Intended approach

- Generalize the existing server-authoritative farm domain from one hard-coded plant to approved plant definitions.
- Reserve hotbar slot 1 for Sunspud seed and slot 2 for Hearthpetal seed; use slots 3-10 for exact Backpack-item references.
- Migrate schema-v2 profiles to schema v3 without deleting items. A harvested item displaced from slot 2 moves to the first free slot 3-10 or remains safely stored when no quick slot is free.
- Keep the Sunspud tutorial unchanged. Hearthpetal is an optional next crop with explicitly experimental price, growth, weight, and sale values.
- Derive the first Cozzle arrival from authoritative plotted Hearthpetal state. The visitor is wild, unowned, non-capturable, and reconstructed from the mature attractor; no client request creates ownership.
- Use a separate creature world-projection service so later Observe/Care/Capture logic does not become coupled to crop persistence or presentation.

## Files expected to change

- `src/server/Definitions/PlantDefinitions.luau`
- `src/server/Definitions/CreatureDefinitions.luau`
- `src/server/Data/ProfileSchema.luau`
- `src/server/Domain/FarmDomain.luau`
- `src/server/Services/FarmService.luau`
- `src/server/Services/PlotService.luau`
- `src/server/Services/PlantWorldService.luau`
- `src/server/Services/CreatureWorldService.luau`
- `src/server/FarmBootstrap.server.luau`
- `src/client/FarmController.client.luau`
- repository-owned test modules and project knowledge

## Dependencies

- Existing Rojo source link and authorized Studio place
- Existing plot assignment/world-position mapping
- Existing durable profile repository and idempotent farm command ledger
- Existing custom hotbar/backpack UI

## Risks

- Data: Slot-2 migration could lose a quick-slot reference if it mutates the item instead of only the hotbar map.
- Security: Client-supplied definition IDs could buy/place nonexistent or unintended plants.
- Gameplay: A derived visitor could be mistaken for owned or capturable before those transactions exist.
- Performance: One loop or animation per plant could scale poorly; the slice must cap one projected Cozzle per player and avoid per-frame server work.
- UI: Two fixed seed slots reduce quick item slots from nine to eight and require clear names/colors.
- Compatibility: The Sunspud tutorial, old schema-v1/v2 profiles, and existing isolated persistence behavior must continue working.

## Expected impact

- Performance: Low estimated cost—one pending attractor record and at most one anchored Cozzle model per player, checked four times per second. Requires measurement before higher creature caps.
- Security: Server remains authoritative over catalog, price, placement bounds, maturity, attraction, and ownership labels. No new ownership or economy remote is introduced.

## Required tests

- Schema-v1 and v2 migrations, including occupied slot 2, full quick slots, malformed keys, and exact-item preservation.
- Both seed definitions: purchase price, stack, placement consumption, growth timestamp, weight bounds, harvest, sale, replay, and invalid definition rejection.
- Hotbar protection for slots 1-2 and deterministic item assignment to slots 3-10.
- Cozzle attractor selection: Hearthpetal-only, earliest maturity, deterministic tie-break, one visitor maximum, removal after attractor harvest.
- Studio play mode: buy/place/grow Hearthpetal; visible distinct plant; one Cozzle arrival; wild/unowned attributes; no console errors; Sunspud regression.
- Rojo source-link, sourcemap, and clean place build.

## Rollback

Remove the new creature service and Hearthpetal UI/catalog paths, but retain schema-v3 migration support once any v3 profile has been written. Do not downgrade saved profiles or delete Hearthpetal/item records. Disable the attraction projection independently if runtime issues appear.

## Evidence boundary

The slice may be marked Verified only for behavior actually observed in the current one-player Studio environment plus passing repository tests. It will not verify production DataStore scale, multiplayer contention, mobile/controller input, creature capture, ownership, or final assets.

## Completion result

- Farm/schema tests: 30/30
- FarmService lifecycle tests: 4/4
- Cozzle attractor tests: 5/5
- Runtime projection fixture: one wild/unowned/non-capturable Cozzle created; removed after attractor deletion
- Live Studio: 8-Leafnote Hearthpetal purchase, 60-second growth, mature flower, and one Cozzle arrival observed
- Rojo: PASS, fresh sourcemap, authorized place, Workspace excluded, 151,351-byte clean build
- Remaining gates: physical client button/key confirmation, schema-v3 isolated rejoin, corrected final arrival capture, Observe/Care/Capture, visitor lifetime/rejoin, real devices, multiplayer, performance measurement, production art, and publishing
