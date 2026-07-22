# Map Agent Memory

## 2026-07-21 Memory Tree hero-center update

- Tasks completed: Expanded the live graybox to 1040×1080, enlarged the event island to 184 studs, raised/broadened the tree to a 255-stud hero silhouette, moved every radial dependency, and added guarded migration/rollback/validation sources
- Strengths demonstrated: Dependency-set scaling, non-Terrain reversibility, semantic-tag recovery, HUD-aware camera iteration, and exact route/clearance validation
- Mistakes made: First migration assumed all land retained the `LandTile_` prefix; first visual pass stopped at 180 studs before testing the live HUD
- Bugs introduced: None remaining; first migration refused before geometry mutation
- Bugs prevented: Destructive rebuild, land/pond gaps, bridge/ring disconnects, plot/trail overlap, invalid forage ground, wall gaps, and HUD-hidden focal art
- Review feedback received: The Memory Tree must be the game's main focal point and selling point; everything else should move outward to support it
- Useful patterns discovered: Use semantic tags for migrated geometry and review hero scale through actual gameplay HUD cameras
- Areas requiring improvement: Safe-clone rollback execution, device cameras, eight-player crowding, streaming, and final-density profiling
- Current project knowledge: Live hero center is 184 studs; tree top is 255; plot centers use 150/340 offsets; Hub is at -220/220; meadows at -390/0 and 0/-420; trail uses 450/480 radii; walls are at X±530/Z±550
- Unresolved questions: Final tree model/canopy shape, event staging density, device framing, streaming, and user visual approval
- Recent evaluation scores: Overall 95 for the hero-center task
- Next improvement goal: Make final landmark reviews HUD-aware on desktop, phone, tablet, and controller before art lock

## 2026-07-21 seed-foraging update

- Tasks completed: Defined and ground-validated an 18-point forage pool across three map regions for six active nodes
- Strengths demonstrated: Used named X/Z points plus authoritative graybox raycasts and occupancy exclusions
- Mistakes made: No final-art visibility, line-of-sight, or crowd-route evaluation exists
- Bugs introduced: None found; all 18 points resolved
- Bugs prevented: Floating nodes, occupied-point overlap, and same-point relocation
- Review feedback received: A collected seed must not respawn at the same location
- Useful patterns discovered: Maintain more valid spawn points than simultaneous nodes and re-audit after terrain edits
- Areas requiring improvement: Final-art occlusion, route variety, streaming, and multi-player search density
- Current project knowledge: Ground points span west, south, and east regions between Y 44 and 45
- Unresolved questions: Final biome weighting and whether event states temporarily alter the pool
- Recent evaluation scores: Joint forage slice Overall 95
- Next improvement goal: Validate visibility and route variety after production foliage is added

- Tasks completed: Established the sanctuary direction and references; built and expanded the reversible graybox to an 880×920 island with eight 96×96 plots, moved gate, scaled Hub/meadows, perimeter/mount trail, hills, continuous ocean, and invisible border
- Strengths demonstrated: Navigation-first ambience reasoning and iteration from direct spatial feedback
- Mistakes made: Initial concepts had alignment/scale issues; the first Studio source handoff included shell-wrapper text; generated-count metadata became stale twice after live additions; radial plot paths missed cardinal fence gaps; the Welcome Gate was two studs narrower than specified; rollback originally cleared Terrain without detecting later edits; and the expanded dimension note initially retained a 10×10 pad value after source/live pads changed to 12×12
- Bugs introduced: None
- Bugs prevented: Existing Studio content was not overwritten; blocked arrival pads, narrow bridges, an oversized root footprint, lost gate/tree sightline, and premature functional gameplay were caught by the graybox contract
- Review feedback received: Plants/creatures remain the spectacle; center and reserve rules remain active; derive path, pad, and fence openings from one axis definition; assert the exact 24-stud gate opening; refuse Terrain rollback after voxel changes; keep truth label and scope separate; do not expose gray void around the ocean in full-map views; compare dimension notes and generated-count metadata directly with the live model before approval
- Useful patterns discovered: Small visual rooms, clear central orientation, reusable event footprint, written spatial rules paired with concept images
- Areas requiring improvement: Multi-client crowded navigation, streaming, real mobile/tablet/controller camera validation, and environment-envelope testing across gameplay/overview/promotional cameras
- Current project knowledge: Living-storybook Crescent Pond Sanctuary direction; eight-player public servers with eight equal 96×96 plots on an outward ring; standard R15/camera scale; Welcome Gate aligned to the Memory Tree; board footprints beside the gate; future gate assignment; public/read-only plot visits; 80×80 Caretaker Hub; swimmable pond/bridges; 880×920 walkable island; 20-stud perimeter/mount route; invisible collidable border; continuous ocean; global arrivals; Memory Tree event venue; expanded future meadows including a mount reserve.
- Unresolved questions: Post-death spawn behavior; functional gate assignment; donation/ranking semantics; ocean-return behavior; expansion seams; final crescent-water shaping; density caps; and streaming strategy
- Recent evaluation scores: Overall 97 for the expanded island/plot/border/mount-reserve task after independent review
- Next improvement goal: Validate the 96×96 plot ring, mount trail, walls, and shared spaces at representative garden density with eight-player crowd routes and real-device camera evidence
