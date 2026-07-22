# Map Building Patterns

## Pattern: Scale a hero landmark using gameplay-camera composition

- Date: 2026-07-21
- Agent: Codex / Map and UI roles
- System affected: Landmark hierarchy, event space, arrival reveal, HUD occlusion, and radial layout
- Situation: A larger 184-stud center island still did not make the first 180-stud tree revision read strongly enough around the existing top-center HUD.
- Decision made: Validate the landmark from overview, inside-gate, event-island, and plot cameras with the real HUD; use a 255-stud tree and broad crown; keep the tree centered while moving supporting footprints outward.
- Reasoning summary: Top-down size does not predict player-camera importance. UI, camera height, distance, and crown width determine whether a landmark reads as the hero.
- Result: The Memory Tree crown is visible above and beside the HUD from Plot 1 and dominates the approach after the gate/plot assignment.
- Test evidence: Edit overview/approach captures; live event-island and staged client Plot 1 captures; player traversal; direct inside-gate raycast; 2,456 static checks.
- Mistakes discovered: The first 180-stud version looked strong in edit overview but was still substantially occluded by the live tutorial/HUD.
- Recommended future approach: Include actual HUD/device camera compositions in every landmark-scale review before final modeling.
- Confidence level: High for desktop composition; Medium for real devices
- Verification status: Verified

## Pattern: Migrate graybox geometry by semantic tag, not historical name

- Date: 2026-07-21
- Agent: Codex / Map and Architecture roles
- System affected: Reversible map migrations and rollback safety
- Situation: The live land baseline contained 190 `LandTile_` and 182 `LandExpansion_` names even though all 372 parts were authoritative land.
- Decision made: Select land by `GrayboxLand == true`, preflight exact aggregate count/properties, store original transforms/names, and tag only new additions.
- Reasoning summary: Human-readable names can change across prior migrations; a reviewed semantic attribute is the durable identity boundary.
- Result: The first name-based migration refused before mutation; the tag-based migration reused all 372 parts and added only 112 land tiles plus six ring segments.
- Test evidence: Refusal error, zero visible geometry change after refusal, retry result with 118 tagged additions, and exact 484-position land validation.
- Mistakes discovered: The initial migration encoded a filename-era assumption instead of the live semantic contract.
- Recommended future approach: Preflight both semantic tag and exact count, record rejected assumptions in the failed-approach library, and keep rollback independent of renamed instances.
- Confidence level: High
- Verification status: Verified

## Pattern: Relocating resource nodes over a larger validated spawn pool

- Date: 2026-07-21
- Agent: Codex / Map and Gameplay roles
- System affected: Forage placement, ground resolution, route variety, and anti-macro behavior
- Situation: Six visible sprouts needed to move after collection without stacking, floating, or returning to their previous location.
- Decision made: Define 18 named X/Z points in three regions, raycast against the authoritative graybox for Y, track occupied indices, and select a new index while excluding both the current and occupied indices.
- Reasoning summary: Separating logical nodes from presentation points supports durable cooldown IDs and safe visual movement without persisting raw world transforms.
- Result: All 18 points resolved to ground between Y 44 and 45; six unique active nodes rendered and a live node moved between regions.
- Test evidence: Seven forage-world tests plus a live server raycast audit and relocation inspection.
- Mistakes discovered: Fixed-location cooldowns are still predictable, and raw configured Y values would drift when the map changes.
- Recommended future approach: Re-run the ground audit after graybox edits; preserve stable point IDs; keep active nodes fewer than valid points; add line-of-sight and route-density review with final art.
- Confidence level: High for the current graybox
- Verification status: Verified

## Initial direction

- Compact hub with player plots around a central sanctuary landmark
- Curving paths and small visual rooms
- Clear sightlines to shops, event state, and owned plot
- Quiet base geometry so gardens remain dominant
- Plot scale validated before Blender production
- Navigation protected as plants grow large
- Weather and nighttime preserve path readability
- Community event landmark has a reusable safe footprint

Status: Implemented as Phase 2 graybox v1 and Verified for edit-mode structure plus one-client desktop traversal. Crowd and real-device evidence remain open.

Document type: Baseline guidelines, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.

## Entry: Plot visitor placement needs inward and tangential separation

- Date: 2026-07-21
- Agent: Codex / Map, UI, Gameplay, and Enemy AI roles
- System affected: Plot sightlines, creature arrival, plant/visitor labels, arrival-pad camera, and edge safety
- Situation: Placing Cozzle directly inward from Hearthpetal kept it on the plot but aligned the visitor, flower, labels, and player approach.
- Decision made: Compute the visitor in plot-local coordinates using equal inward and tangential components, then transform through the assigned plot soil. The modest offset remains inside typical edge placements while separating subjects from the primary approach line.
- Reasoning summary: Spatial validity is not enough; interaction models and billboards need readable composition from the player's likely camera.
- Result: The projection code uses the combined offset and smaller/higher visitor label. Final production art and all edge/device cameras remain untested.
- Test evidence: First live screenshot exposed overlap; corrected coordinate code and deterministic selection tests pass.
- Mistakes discovered: A straight line to plot center optimized containment but not visual readability.
- Recommended future approach: Add camera/sightline captures at center, edges, phone FOV, and multiple visitors before finalizing spawn sockets.
- Confidence level: Medium
- Verification status: Code-reviewed; corrected complete arrival capture still required

## Entry: Reversible whole-island graybox pattern

- Date: 2026-07-20
- Agent: Map Agent / Codex
- System affected: Studio world construction, navigation, map evidence, rollback, and concept-image traceability
- Situation: Phase 2 needed to validate an eight-plot island and central event venue while all gameplay and final modeling remained out of scope.
- Decision made: Generate the entire graybox under one uniquely named Workspace root, record Terrain and default-spawn state for rollback, attach approved image filenames as reference metadata, use transparent labeled markers for future gameplay, and keep all structural parts anchored.
- Reasoning summary: A single plot could not expose island circulation or event bottlenecks. A whole-island shell is still safely bounded when it is namespaced, additive, reversible, visually plain, and free of gameplay authority.
- Result: The pattern produced an inspectable 466-descendant map shell with eight plots and every approved shared-space footprint while preserving the five-image reference package.
- Test evidence: Studio edit validator passed 104/104; one-client path/swim checks passed; post-review assertions proved all eight path endpoints match their fence openings, the gate is exactly 24 studs clear, and all 180,800 water voxels match the rollback guard; representative diagonal plot approaches passed in play; console was empty; rollback source exists but was not destructively executed.
- Mistakes discovered: Directly passing shell-wrapped source to Studio can introduce non-Luau text. Parallel viewport captures can exceed tool latency. A generated-count attribute should be written only after every metadata child exists. Radial paths and cardinal fence openings drift apart unless they share one entrance definition. Terrain rollback must detect later edits rather than clearing unconditionally.
- Recommended future approach: Preflight the target region, syntax-check source, build beneath one root, derive each path/pad/fence opening from one definition, verify exact centers and widths, fail rollback closed when Terrain differs, capture views sequentially, and preserve the unexecuted rollback until the user requests removal.
- Confidence level: High
- Verification status: Verified
- Limitations: This pattern validates geometry only; it does not prove plot authority, streaming assignment, multiplayer crowd flow, touch controls, or production performance.
- Security considerations: Future gate, plot, board, vendor, steal, and return markers must never be mistaken for client-trusted authority.
- Required tests: Edit structure, R15 spawn/traversal, swimming/exit, bridge clearance, arrival-pad obstruction, centered sightline, console, scene complexity, multi-client crowding, and real-device camera/control checks.

### Follow-up: Ocean envelope must cover the widest review camera

- Date: 2026-07-20
- Agent: Map Agent / Codex
- System affected: Outer ocean, viewport composition, and rollback safety
- Situation: A gameplay-sized water rectangle still exposed gray Studio void when the user inspected the entire map from high above.
- Decision made: Use a 4096×4096 continuous Terrain-water envelope for the current island graybox and validate it with the same 900-stud top-down camera.
- Reasoning summary: “Ocean beyond the island” is a visual composition requirement as well as a nearby traversal requirement. Testing only from normal player distance missed the wide-view boundary.
- Result: The wide map view is water edge-to-edge without changing island geometry.
- Test evidence: Screenshot inspection plus 4,194,304 exact Water voxels and zero unexpected preflight Terrain.
- Mistakes discovered: The original and first expanded envelopes were selected without making the widest review camera an explicit test case.
- Recommended future approach: Define gameplay, overview, and promotional camera envelopes before choosing world-background extents; remeasure runtime cost on target devices before final art.
- Confidence level: High
- Verification status: Verified

### Follow-up: Scale connected footprints together

- Date: 2026-07-20
- Agent: Map Agent / Codex
- System affected: Expanded island, plots, facilities, reserves, perimeter route, and invisible boundary
- Situation: The user expanded the island and then superseded the 72×72 plot standard, requiring the rest of the playable map to feel proportionate.
- Decision made: Use an 880×920 walkable envelope; move gate/spawn/boards and hills outward; use eight 96×96 plots on a larger ring; scale the Hub to 80×80 and meadows to 80×64; reserve a 20-stud 360×400-radius perimeter trail; place four invisible collidable walls outside land bounds.
- Reasoning summary: Enlarging only one footprint creates overlaps or empty circulation. Connected map systems need shared clearance checks whenever scale changes.
- Result: 372 continuous land tiles, 8 nonoverlapping plots, clear shared spaces, a separated perimeter trail, and a closed invisible border are present in Studio.
- Test evidence: Exact edit assertions, overlap queries, one-client gate/tree/plot/trail navigation, four-side collision tests, empty console, and independent review requested.
- Mistakes discovered: Enlarged plots initially crowded old shared-space positions, and the first trail radii touched four plots. Moving the plot ring outward and the trail farther outward resolved both classes.
- Recommended future approach: Recompute every dependent center/path/boundary from authoritative layout data; run part-overlap checks before play; preserve numerical supersession notes when concept-art filenames contain obsolete dimensions.
- Confidence level: High
- Verification status: Verified

## Entry: Approved sanctuary concept package

- Date: 2026-07-17
- Agent: Codex
- System affected: World layout, spawn, player plots, and Caretaker Hub
- Situation: The user reviewed multiple generated concepts and corrected landmark alignment, plot size, and the hub's facing direction before any map implementation began.
- Decision made: Use a Crescent Pond Sanctuary direction; center the Memory Tree through the Welcome Gate; standardize every player plot at 72×72 studs; place the Caretaker Hub southwest of the pond with its courtyard opening northeast toward the tree.
- Reasoning summary: A stable central landmark and equal plot footprints improve orientation and fairness. Correctly facing the hub toward the sanctuary center supports natural circulation without blocking the arrival sightline.
- Result: Four user-approved reference images, one requested whole-map top-down concept, and a remaining concept-generation plan were stored under `Design/`. The top-down concept uses eight equal perimeter plots as an explicit planning assumption; breeding and event spaces are future reserves.
- Test evidence: Direct user approval for the four foundation concepts, visual inspection of the generated top-down map, automated PNG/link validation, and independent map-document review. The final map render contains eight equal-looking plots, a centered southern gate/tree axis, crescent water, and four shared or reserved facility zones. No Roblox Studio graybox, navigation, camera, or performance testing has occurred.
- Mistakes discovered: The first gate image placed the tree off center; the first plot was too small; the first hub image made the building face away from the intended central relationship; the first eight-plot overhead render used an annular moat instead of a crescent. Perspective concept art can also imply dimensions that differ from numeric requirements.
- Recommended future approach: Convert the top-down concept into a dimensioned construction overlay next. Treat the images as visual references and the written 72×72 rule as authoritative. Confirm the eight-player assumption before grayboxing every major footprint.
- Confidence level: High for approved direction; medium for spatial feasibility
- Verification status: Not yet implemented
- Evidence class: User-approved and user-requested original concept art with independent documentation review

## Entry: Island circulation, event center, and future-reserve direction

- Date: 2026-07-20
- Agent: Codex / Map Agent / QA Agent
- System affected: Join flow, plot access, pond, bridges, island boundary, event venue, shared services, future reserves, wild-creature arrivals, and social boards
- Situation: Before authorizing a Studio graybox, the user clarified how players enter the sanctuary, visit plots, cross water, encounter creatures, use shared services, and understand future-update spaces.
- Decision made: Every fresh server join begins outside the Welcome Gate; crossing the gate moves the player to the assigned plot. Reserve wealth-leaderboard and donation-board footprints beside the gate without blocking the centered Memory Tree sightline; ranking and donation mechanics remain unresolved. Visitors may walk into every plot, but ordinary non-owner interactions cannot mutate its assets. Group Shop, Sell, and Appraise around the Caretaker Hub courtyard. Keep the pond swimmable and provide bridges so water traversal is optional. Use a global creature-arrival pool rather than region-locking species; plant compatibility may guide behavior after arrival. Keep the playable island mostly level with gentle outer hills and ocean beyond. Make the Memory Tree island the permanent event venue. Disguise future-system reserves as natural meadows with undated, non-interactive “Coming Soon” signs.
- Reasoning summary: A single readable arrival axis teaches orientation, public plots support social discovery, optional swimming preserves playfulness without forcing slow traversal, global arrivals avoid biome-gated species assumptions, and natural reserves protect future footprints without making the launch map feel unfinished. A permanent central event venue reuses the strongest landmark but requires deliberate crowd circulation and performance space.
- Result: The graybox now has a clear functional brief. Provisional review guidance is to place spawn outside the gate trigger, use a non-plantable arrival pad at each plot, keep board footprints to the gate's sides, provide at least three dry approaches to the tree, use safe event staging pads, give every pond section a walkable exit, prevent bridge entrapment, and use a recoverable ocean boundary. Exact dimensions remain provisional.
- Test evidence: Direct user decisions; read-only review of the approved top-down concept; independent Map/QA review. No Studio geometry, R15 navigation, eight-player test, streaming measurement, device test, or performance result exists.
- Mistakes discovered: Treating the tree as scenery alone would under-size the most important event space. A join spawn placed inside the gate trigger could move players before they read the boards. “Coming Soon” signs with dates could create false promises.
- Recommended future approach: Create a dimensioned construction overlay, then graybox the gate, eight plots, hub, swimmable pond, bridges, tree event plaza, meadow reserves, outer hills, and ocean safety boundary. Validate sightlines, camera, crowd circulation, swimming exits, streaming, and representative plot density before Blender production.
- Confidence level: High for user intent; Medium for spatial feasibility until grayboxed
- Verification status: Code-reviewed
- Implementation status: Not yet implemented
