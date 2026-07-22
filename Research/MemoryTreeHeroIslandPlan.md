# Memory Tree Hero-Island Revision

- Date: 2026-07-21
- Agent: Codex / Map, Architecture, Gameplay, Performance, and QA roles
- Status: Implemented
- Truth label: Verified

## Objective

Make the Memory Tree the first and strongest visual read from the Welcome Gate, plots, and overview camera. The center must support events and social circulation while the surrounding plots and services remain useful but visually subordinate.

## Intended approach

- Grow the event island from 104 to 184 studs.
- Replace the roughly 100-stud-tall tree stand-in with an approximately 255-stud hero silhouette whose crown remains readable around the existing top-center HUD.
- Expand the pond gap, bridges, and public ring together.
- Move all eight 96×96 plots, the Caretaker Hub, meadows, gate, boards, forage regions, trail, hills, walls, and spawn outward as one dependency set.
- Expand the walkable island from about 880×920 to about 1040×1080 studs.
- Keep Workspace outside Rojo authority and apply the live revision through a guarded, reversible Studio migration.

## Files affected

- `StudioBuild/Phase2Graybox.lua`
- `StudioBuild/Phase2HeroIslandExpansion.lua`
- `StudioBuild/Phase2HeroIslandExpansionRollback.lua`
- `Design/Map/Phase2GrayboxDimensions.md`
- `src/server/Definitions/ForageDefinitions.luau`
- Project knowledge and test evidence files after validation

## Dependencies

- Existing `Workspace.CatchACreature_Graybox_v1` root with the verified 684-descendant/602-BasePart baseline
- Stable plot, kiosk, bridge, path, marker, boundary, and SpawnLocation names
- Runtime services that resolve plot/kiosk instances by name rather than fixed world coordinates
- Forage points must continue raycasting to authoritative graybox ground

## Risks

- Moving only the island would break pond, bridge, ring, and path connections.
- Moving plots without changing the land/trail could create overlap or water gaps.
- A larger tree could hide event state or dominate the player camera.
- Existing forage coordinates could land in water or inside moved footprints.
- Direct destructive rebuild would risk losing the currently verified graybox.

## Performance impact

Estimated: modest edit/runtime instance increase from additional land tiles. The tree uses the same five canopy parts; no scripts, effects, or unanchored physics are added. Fresh scene measurements are required.

## Security impact

None to authority contracts. Geometry still does not grant plot, shop, sell, event, forage, or ownership authority. Existing server validation remains required.

## Tests required

- Source syntax/build and dimension consistency
- Exact event-island/tree/plot/hub/meadow/gate/trail/wall positions
- Land coverage and center-water separation
- Bridge-to-island/ring overlap and plot-path-to-fence alignment
- Pairwise plot/shared-space/trail separation
- All 18 forage points resolve to ground
- One-client gate/tree/plot/hub/trail traversal and boundary collision
- Gate hero sightline plus overview and player-height captures
- Clean console and fresh automated gameplay regression suite

## Rollback approach

The migration stores original CFrame, Size, selected property, name, and model-attribute values on affected existing instances. New instances are tagged. Rollback must first verify the expected expanded state, then restore the original instances and remove only tagged additions. The whole-graybox rollback remains separate and fail-closed for Terrain.

## Result

- Live root: 802 descendants and 720 BaseParts, all anchored, with zero scripts.
- Static acceptance: 2,456 checks passed after fixing one test-only missing constant.
- Gameplay regression: 58 fresh-server cases passed.
- Foraging: all 18 configured positions hit graybox ground at Y 44–45 and all six live nodes spawned.
- Traversal: spawn/gate assignment, event island, authored west bridge/ring/Hub route, Plot 4 route, and east trail were reached in one desktop client.
- Boundary: south-wall movement stopped at approximately Z 544.5 against the inner face of the Z 550 wall.
- Logs: final fresh play VM contained no client or server warnings/errors.
- Visual evidence: overview, inside-gate, event-island, and plot sightlines show the tree as the dominant silhouette around the existing HUD.
- Independent review: not run because subagent delegation was unavailable for this task; repository-owned validation, guarded migration, syntax checks, and fresh-VM play evidence were used instead.

## Remaining gates

User visual approval, multi-client crowd flow, streaming, real phone/tablet/controller cameras, final-tree art, event VFX readability, and final-density performance remain open.
