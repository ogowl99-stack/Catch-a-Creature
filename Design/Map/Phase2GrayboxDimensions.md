# Phase 2 Graybox Dimensions

- Date: 2026-07-20
- Status: Authorized for Roblox Studio construction
- Truth label: Verified
- Verification scope: Edit-mode structure and one-client desktop traversal
- Remaining validation: Multi-client, real mobile/tablet/controller, production persistence, and user visual approval
- Coordinate convention: Memory Tree at `X=0, Z=0`; south/Welcome Gate is positive `Z`

## Construction envelope

Visual composition remains governed by the five approved images in `Design/ConceptArt/Approved/`. Numeric requirements in this document take precedence when perspective art implies a conflicting scale.

Approved visual references attached to the Studio graybox root:

- `whole-map-top-down-v2.png`
- `welcome-gate-centered-tree.png`
- `standard-player-plot-72x72.png`
- `crescent-pond-sanctuary-overview.png`
- `caretaker-hub-correct-orientation.png`

- Playable island: approximately `880×920` studs after the user-requested outer-land expansion
- Ocean coverage region: `4096×4096` studs so wide development views show continuous water rather than the gray Studio void
- Main land surface: approximately `Y=44`
- Water surface: approximately `Y=36`
- Water depth: `16` studs in the graybox region
- Main circulation path: `16` studs clear
- Secondary paths and plot entrances: `12` studs clear
- Future mount/perimeter trail: `20` studs clear, approximately `360×400` ellipse radii, inside the hill band and outside all plots

## Central sanctuary

- Memory Tree center: `(0, 0)`
- Event island diameter: `104` studs
- Tree root collision footprint: no more than `40` studs across
- Swimmable pond ring: approximately radius `52–96`
- Bridges: north, east, south, and west
- Bridge clear walking width: `12` studs; rails may increase total width
- Swim exits: one broad stepped exit in each diagonal pond quadrant
- Event pads: eight safe staging markers around the tree

## Player plots

Every plot is axis-aligned and exactly `96×96` studs. This supersedes the earlier `72×72` rule; the approved 72-stud concept image remains composition-only.

| Plot | X | Z |
|---|---:|---:|
| 1 | -110 | -250 |
| 2 | 110 | -250 |
| 3 | 250 | -110 |
| 4 | 250 | 110 |
| 5 | 110 | 250 |
| 6 | -110 | 250 |
| 7 | -250 | 110 |
| 8 | -250 | -110 |

Each plot receives an inward-facing entrance, a non-plantable `12×12` arrival pad, visible bounds, and metadata that permits public visits while denying ordinary non-owner mutation.

## Shared spaces

- Welcome Gate: centered near `(0, 390)` with a `24`-stud clear opening
- Join apron: approximately `70×32`, centered near `(0, 420)`
- Future gate trigger marker: inside the gate near `Z=382`, separate from the join spawn
- Wealth leaderboard footprint: approximately `(-48, 398)`
- Donation board footprint: approximately `(48, 398)`
- Caretaker Hub: centered near `(-120, 120)`, `80×80` envelope, opening toward the sanctuary center
- Shop, Sell, and Appraise: grouped within the Hub courtyard
- Future meadow A: centered near `(-290, 0)`, approximately `80×64`
- Future meadow B / mount reserve: centered near `(0, -330)`, approximately `80×64`, beside the future perimeter mount trail

## Safety and verification

- Preserve a centered Welcome Gate to Memory Tree sightline.
- Keep event props at least `12` studs from every bridge landing.
- Preserve at least `60%` of the event-island annulus for players.
- Keep bridge undersides at least `7` studs above the water surface.
- Keep a minimum flat margin between plot fences and outer hills.
- Use four fully invisible collidable walls beyond the expanded hills at approximately `X=±450` and `Z=±470`; keep them outside the walkable land edge, plots, and arrival gate.
- No leaderboard, donation, gate movement, event, or return-boundary gameplay is implemented by this graybox.
- Real multi-client, mobile, tablet, controller, and production persistence tests remain separate gates.

## Rollback

All generated instances are placed under `Workspace.CatchACreature_Graybox_v1`. The build refuses to run unless the exact Terrain-water region is empty. The rollback verifies that every recorded voxel is still the exact generated water and refuses to clear anything if the region changed after construction; otherwise it removes that one model, clears only the recorded block, and restores the captured default `SpawnLocation` transform.
