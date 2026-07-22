# Phase 2 Graybox Dimensions

- Date: 2026-07-20
- Status: Hero-center revision implemented
- Truth label: Verified
- Verification scope: 2026-07-21 live Edit structure and one-client desktop traversal; user visual approval remains pending
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

- Playable island: approximately `1040×1080` studs after the Memory Tree hero-center revision
- Ocean coverage region: `4096×4096` studs so wide development views show continuous water rather than the gray Studio void
- Main land surface: approximately `Y=44`
- Water surface: approximately `Y=36`
- Water depth: `16` studs in the graybox region
- Main circulation path: `18` studs clear around the central sanctuary
- Secondary paths and plot entrances: `12` studs clear
- Future mount/perimeter trail: `20` studs clear, approximately `450×480` ellipse radii, inside the hill band and outside all plots

## Central sanctuary

- Memory Tree center: `(0, 0)`
- Event island diameter: `184` studs
- Tree root collision footprint: `58` studs across in the hero graybox, leaving a broad player annulus
- Graybox tree height: approximately `255` studs with a broad crown so the final-tree scale reads above and around the top-center HUD from the gate and plots
- Swimmable pond ring: approximately radius `92–170`
- Bridges: north, east, south, and west
- Bridge clear walking width: `16` studs; rails increase total width to `18` studs
- Swim exits: one broad stepped exit in each diagonal pond quadrant
- Event pads: eight safe staging markers around the tree

## Player plots

Every plot is axis-aligned and exactly `96×96` studs. This supersedes the earlier `72×72` rule; the approved 72-stud concept image remains composition-only.

| Plot | X | Z |
|---|---:|---:|
| 1 | -150 | -340 |
| 2 | 150 | -340 |
| 3 | 340 | -150 |
| 4 | 340 | 150 |
| 5 | 150 | 340 |
| 6 | -150 | 340 |
| 7 | -340 | 150 |
| 8 | -340 | -150 |

Each plot receives an inward-facing entrance, a non-plantable `12×12` arrival pad, visible bounds, and metadata that permits public visits while denying ordinary non-owner mutation.

## Shared spaces

- Welcome Gate: centered near `(0, 490)` with a `24`-stud clear opening
- Join apron: approximately `70×32`, centered near `(0, 525)`
- Future gate trigger marker: inside the gate near `Z=482`, separate from the join spawn
- Wealth leaderboard footprint: approximately `(-48, 498)`
- Donation board footprint: approximately `(48, 498)`
- Caretaker Hub: centered near `(-220, 220)`, `80×80` envelope, opening toward the sanctuary center
- Shop, Sell, and Appraise: grouped within the Hub courtyard
- Future meadow A: centered near `(-390, 0)`, approximately `80×64`
- Future meadow B / mount reserve: centered near `(0, -420)`, approximately `80×64`, beside the future perimeter mount trail

## Safety and verification

- Preserve a centered Welcome Gate to Memory Tree sightline.
- Keep event props at least `12` studs from every bridge landing.
- Preserve at least `60%` of the event-island annulus for players.
- Keep bridge undersides at least `7` studs above the water surface.
- Keep a minimum flat margin between plot fences and outer hills.
- Use four fully invisible collidable walls beyond the expanded hills at approximately `X=±530` and `Z=±550`; keep them outside the walkable land edge, plots, and arrival gate.
- No leaderboard, donation, gate movement, event, or return-boundary gameplay is implemented by this graybox.
- Real multi-client, mobile, tablet, controller, and production persistence tests remain separate gates.

## Rollback

All generated instances are placed under `Workspace.CatchACreature_Graybox_v1`. The build refuses to run unless the exact Terrain-water region is empty. The rollback verifies that every recorded voxel is still the exact generated water and refuses to clear anything if the region changed after construction; otherwise it removes that one model, clears only the recorded block, and restores the captured default `SpawnLocation` transform.
