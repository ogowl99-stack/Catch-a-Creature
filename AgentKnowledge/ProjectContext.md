# Project Context

## Entry: Memory Tree hero-center revision

- Date: 2026-07-21
- Agent: Codex / Map, Architecture, Gameplay, Performance, and QA roles
- System affected: Central event island, tree silhouette, pond, bridges, public ring, plots, Hub, meadows, gate, boards, forage regions, trail, hills, walls, spawn, and progress media
- Situation: The user identified the Memory Tree as the game's main selling point and asked for a larger center island with the rest of the map pushed outward.
- Decision made: Expand the event island from 104 to 184 studs; use a 255-stud graybox tree with a broad crown; expand the pond/bridges/ring; move the 96×96 plots to 150/340 offsets; move all dependent spaces outward; enlarge the walkable island to about 1040×1080; apply the live change through a guarded reversible migration without changing Terrain.
- Reasoning summary: A focal landmark needs visual hierarchy from the player camera, not only a larger footprint in top-down view. Every connected footprint had to move as one dependency set.
- Result: The live map has 802 descendants, 720 BaseParts, 484 land tiles, and 30 central-ring segments. The tree is the dominant silhouette in overview, inside-gate, event, and Plot 1 compositions.
- Test evidence: 2,456 edit checks; 58 fresh-server gameplay cases; 18/18 forage ground hits; six live forage nodes; authored bridge/ring/Hub, Plot 4, and east-trail traversal; south boundary stopped at Z≈544.5; empty final client/server warning and error logs; Rojo PASS.
- Mistakes discovered: The first migration preflight assumed every land part retained the `LandTile_` prefix; the historical expansion used `LandExpansion_` for 182 tagged land parts. The first validator also omitted its local surface-height constant. Real UI framing showed the 180-stud first revision was still too hidden, so the final silhouette increased to 255 studs.
- Recommended future approach: Identify map parts by stable semantic attributes, keep deterministic repository-owned acceptance, validate with the real HUD and player camera, and preserve the migration/rollback pair until final-art replacement is approved.
- Confidence level: High for current Edit geometry and one-client desktop traversal; Medium for final visual scale pending user/device/crowd approval
- Verification status: Verified

## Entry: Held item and favorite-safe selling

- Date: 2026-07-21
- Agent: Codex / Gameplay, UI, Data, Security, and QA roles
- System affected: Hotbar equip, R15 presentation, inventory, favorites, single sale, bulk sale, remotes, and profile projection
- Situation: The user wanted the selected plant visible in the avatar's hand, single-item sale restricted to the equipped item, and full-inventory sale to protect favorites without requiring equip.
- Decision made: Maintain server-tracked session equip state; present supported held items locally through bounded R15 IK; gate `SellItem` on the exact equipped item ID; persist the favorite flag; and implement atomic `SellAllUnfavorited` over the Backpack.
- Reasoning summary: Presentation can be local, but economic authority must use the exact server-tracked UUID/revision. Favorites provide a free loss-prevention path for bulk selling.
- Result: Click/number equip, harvest auto-equip, storage round trip, favorite toggle, equipped single sale, and favorite-safe bulk behavior are implemented.
- Test evidence: 58 fresh-server cases; live 1.12-weight harvested Sunspud auto-equipped; unequipped single sale rejected without mutation; favorite-only bulk rejected without mutation; equipped sale cleared exact item/equip/model.
- Mistakes discovered: The first client patch was briefly overwritten by a stale Rojo writer; the server was restarted and exact live source patterns were rechecked.
- Recommended future approach: Keep equip ephemeral, item/favorite state durable, server-gate all value changes, add other-player held replication only as a separately bounded feature, and test touch/controller/avatar variants.
- Confidence level: High for one-client desktop memory mode
- Verification status: Verified

## Knowledge entry format

Every meaningful entry must record: date, agent, system affected, situation, decision, reasoning summary, result, test evidence, mistakes discovered, recommended future approach, confidence, and verification status.

## Entry: Seed foraging, relocation, and Mythic pull presentation

- Date: 2026-07-21
- Agent: Codex acting across Gameplay, Data, Architecture, Map, Security, UI/VFX, Performance, and QA roles
- System affected: Seed acquisition, rarity definitions, profile schema, farm inventory, runtime world nodes, anti-macro behavior, remotes, presentation, tests, and progress media
- Situation: The stakeholder requested map-wide seed foraging from Common through super rare, then required a collected sprout not to return at the same location and requested a special Mythic pull animation.
- Decision made: Implement six stable logical nodes projected into 18 named graybox-ground points. The server exclusively selects an eligible reward and commits it to schema v4 before moving the node to a different unused point and, for Mythic only, emitting a capturer-local presentation. Keep per-player cooldown keyed to the stable node across relocation. Treat current rarity weights as Experimental and do not claim higher tiers are obtainable without matching seed definitions.
- Reasoning summary: Stable IDs preserve durable cooldowns; movable projections reduce fixed-coordinate automation; commit-before-world/presentation ordering keeps inventory, map, and feedback truthful.
- Result: Common Sunspud and Uncommon Hearthpetal can be foraged into saved seed stacks. A successful sprout relocates, a cooldown retry does not mutate or relocate, and the bounded Mythic visual is implemented for future eligible content.
- Test evidence: 54 fresh Studio automated tests; live one-client grant and cross-region relocation; live cooldown no-op; all 18 ground points resolved; simulated Mythic visual capture; error-free Studio console.
- Mistakes discovered: Fixed-position cooldowns were initially treated as sufficient. The full rarity table needed an explicit current-catalog limitation.
- Recommended future approach: Add reviewed Rare-Mythic seed definitions, simulate effective drop distributions, run schema-v4 isolated rejoin and two-client contention, and test the prompt/VFX on real devices.
- Confidence level: High for current one-client behavior; Medium for experimental balance; Low for production persistence, devices, and multiplayer until tested
- Verification status: Verified one-client slice; Mythic presentation Simulated; production behavior unverified

## Entry: Hearthpetal and first wild Cozzle arrival

- Date: 2026-07-21
- Agent: Codex acting across Gameplay, Data, Architecture, UI, Enemy AI, Security, Performance, and QA roles
- System affected: Plant catalog, profile schema, seed hotbar, shop UI, placement, plant projection, creature attraction, runtime world projection, tests, and progress media
- Situation: After the Sunspud farm/save/inventory foundation passed, the stakeholder authorized the next step: begin Hearthpetal growth and Cozzle arrival.
- Decision made: Add Hearthpetal as experimental server-owned Habitat Flora with an 8-Leafnote seed price, 60-second growth time, 650-1050 milli weight, 14 base sale value, and fixed seed hotbar slot 2. Schema v3 adds the stack and reserves slot 2 while moving a displaced saved item reference to the first free slot 3-10 or leaving that exact item safely stored when full. Cozzle is derived from the earliest plotted Hearthpetal, appears three seconds after maturity, is capped to one projection per player, and is explicitly `Wild=true`, `Owned=false`, and `CaptureEnabled=false`. Observe/Care/Capture and persistent visitor ownership remain out of this slice.
- Reasoning summary: A visible attraction moment advances the game's core promise, while derived wild projection avoids inventing premature ownership or capture transactions. A schema migration is required because fixed seed access must not delete a harvested item that previously occupied slot 2.
- Result: Hearthpetal can be bought, selected with key 2, planted, grown, harvested, sold, rendered distinctly, and represented in snapshots/profile validation. One Cozzle appears with a bounded entrance and is removed/reselected when its attractor leaves the plot. The two-seed shop and hotbar render in Studio.
- Test evidence: Fresh play-server suites passed 30/30 farm/schema cases, 4/4 FarmService lifecycle cases, and 5/5 attraction-selection cases. Live Studio bought Hearthpetal, charged exactly 8 Leafnotes, planted one exact item with a 60-second maturity, rendered growth/maturity, and produced exactly one Cozzle with the required wild/unowned/non-capturable attributes. A separate world-projection fixture created one 20-descendant visitor and removed it after attractor deletion. Console was clean; Rojo validation passed with a fresh sourcemap and 151,351-byte build.
- Mistakes discovered: Edit-mode `require` returned cached pre-sync contracts and caused a false test failure; fresh play-server VMs are required for final module tests. The first Cozzle approach sat directly between the arrival pad and plant, causing label/subject occlusion; the projection now combines inward and tangential offsets.
- Recommended future approach: Build Observe as the next server-authored encounter step without granting ownership; add accessible proximity/controller/touch interaction, visitor lifetime/rejoin rules, one-player state tests, then multiplayer contention only after the single-player encounter contract passes.
- Confidence level: High for one-player Studio farm/arrival projection and pure migration/domain behavior; Medium for repository persistence of schema v3; Low for untested multiplayer, real devices, production DataStore, visitor lifetime, and performance scale
- Verification status: Verified in one-player Studio and repository tests; experimental balance/prototype visuals; requires production, device, and multiplayer testing

## Entry: Phase 3A durable farm-profile requirement

- Date: 2026-07-21
- Agent: Codex / Data, Architecture, Security, QA, UI, and Gameplay Agents
- System affected: Leafnotes, farm inventory, planted Sunspuds, hotbar, rejoin, offline growth, and DataStore safety
- Situation: During the live first-playable iteration, the stakeholder required exact currency, crops, and hotbar contents to return after logout and required crops to grow while offline.
- Decision made: Treat one versioned server profile as durable truth. Save Leafnotes, seed counts, exact plant/item identity and weight, location, plot-local coordinates, absolute planted/maturity times, and numbered hotbar references. Rebuild plot and UI projections on load. Do not auto-harvest or auto-award money offline.
- Reasoning summary: A timestamped item state supports rejoin and offline maturity without trusting clients or running absent-player simulation.
- Result: Phase 3A implements the profile shape, saved slots, stricter validation, safer unique load leases, commit-failure freeze, and offline round-trip/boundary tests. Studio is still simulated memory; controlled published DataStore verification is outstanding.
- Test evidence: Rojo build PASS, fresh cloned-module domain/schema tests, live Studio boot/console, and independent persistence/security reviews.
- Mistakes discovered: Early hotbar projection was client-only; early repository validation and lease identity were insufficient for valuable persistent data.
- Recommended future approach: Complete fake-store fault injection and isolated published rejoin tests before labeling persistence Verified or raising economy stakes.
- Confidence level: High for requirements and state model; Medium for implementation pending real DataStore tests
- Verification status: Code-reviewed / Simulated / Requires production testing

## Entry: Phase 0 foundation

- Date: 2026-07-16
- Agent: Codex
- System affected: Entire project
- Situation: The repository began empty while the user requested deep reference research before any game implementation.
- Decision made: Preserve research and design decisions first. Do not begin game code or asset production until the core thesis, emotional contract, art direction, and first playable scope are approved.
- Reasoning summary: A small proven loop should be validated before expensive models, live events, breeding, trading, or monetization create dependency and balance risk.
- Result: Research documentation and persistent agent-memory structures created. No game implementation was added.
- Test evidence: Required-file/nonempty check passed for 19 shared and 14 personal memories; all Markdown passed strict UTF-8 and NUL-byte checks; the dashboard example parsed as valid JSON; credential-pattern scan returned no findings; independent documentation review returned `PASS`.
- Mistakes discovered: Conversation history alone is not durable project memory. The local Git repository initially had no commit or remote connection.
- Recommended future approach: Read relevant knowledge before every task; update it after meaningful work; commit source-dated decisions at milestones.
- Confidence level: High
- Verification status: Code-reviewed
- Evidence class: Local repository inspection, automated documentation checks, and independent documentation review

## Entry: Phase 3A source linkage established

- Date: 2026-07-21
- Agent: Codex / Architecture Agent / QA Agent
- System affected: Git-to-Studio source authority, Rojo server, shared/server/client namespaces, and Phase 2 graybox isolation
- Situation: The user authorized the next implementation step, but the installed Studio plugin could not connect because this repository had no Rojo project file, no project-local binary, and no running server.
- Decision made: Add a selective `default.project.json` that maps only `ReplicatedStorage.CatchACreature`, `ServerScriptService.CatchACreature`, and `StarterPlayer.StarterPlayerScripts.CatchACreature`; set `$ignoreUnknownInstances` on mapped services; exclude `Workspace`; restrict live sync to place `72745225515549`; pin Rojo 7.7.0 in `rokit.toml`; install the same binary into the ignored project `.tools` directory for this machine; and serve only on `127.0.0.1:34872`.
- Reasoning summary: A narrow namespaced mapping establishes repository authority for future code without letting an initial sync replace the live graybox or unrelated Studio instances.
- Result: The server returned HTTP 200, Studio synchronized all three folders, and a repository edit to `ProjectInfo.luau` propagated live. `Workspace.CatchACreature_Graybox_v1` remained present with exactly 684 descendants and 602 BaseParts.
- Test evidence: Rojo 7.7.0 version/hash check, repeatable `scripts/Test-Rojo.ps1` PASS, fresh sourcemap, clean temporary place build, live-server HTTP 200, server restart/reconnect, Studio hierarchy and complete source reads, live edit/revert propagation, authorized place-ID assertion, and direct graybox recount on 2026-07-21.
- Mistakes discovered: The earlier project status described source linkage as a future choice without creating the executable project file. A sandboxed detached Rojo process was terminated when its shell ended, and PowerShell `Start-Process` encountered duplicate `Path`/`PATH` environment entries; a reviewed unsandboxed hidden process using `ProcessStartInfo` was required for the persistent local server.
- Recommended future approach: Start `rojo serve default.project.json` before opening the Studio connection; keep `Workspace` excluded until a separately reviewed migration exists; use namespaced roots with unknown-instance preservation; validate the sourcemap and graybox counts after mapping changes; then add Phase 3A modules in small tested increments.
- Confidence level: High
- Verification status: Verified

## Current facts

- Project name: Catch a Creature
- Platform: Roblox
- Modeling: Blender
- Phase: Phase 3A playable prototype with Sunspud/Hearthpetal farming, saved inventory, one wild Cozzle projection, and seed foraging; production art, broader creature gameplay, and publishing remain incomplete
- Workspace: Local Git repository connected to public GitHub repository `ogowl99-stack/Catch-a-Creature` (visibility verified 2026-07-18)
- Roblox game: Reversible Phase 2 map graybox, Rojo source scaffold, farm/inventory/persistence prototype, first wild visitor projection, and seed-foraging prototype implemented
- Blender assets: Not yet created
- Tests: Documentation checks, structural map validation, one-client traversal, 54 current gameplay/service/schema tests, isolated schema-v2 DataStore rejoin evidence, and one-client forage relocation evidence; no multi-client or real-device tests exist
- Roblox Studio evidence: Live MCP connection verified to the authorized `Catch A Creature` place ID `72745225515549`. On 2026-07-20, the additive `Workspace.CatchACreature_Graybox_v1` map root was built, expanded, and tested in the open Studio session. On 2026-07-21, Rojo 7.7.0 source linkage was verified for namespaced shared/server/client folders; the graybox remained outside Rojo authority with 684 descendants and 602 BaseParts.
- Phase 1 platform choices: Eight-player public servers; mobile-safe performance/interaction floor with scalable desktop enhancements; selective Rojo repository-first source authority; standard Roblox third-person camera; standard R15 avatars; all-ages accessibility; original classic-Roblox stud-textured garden direction. (User-approved 2026-07-19; not yet implemented or device-tested)
- First-session hook: Target an approximately five-minute guaranteed farming cycle using Sunspud, an original always-stock single-harvest common plant separate from Hearthpetal; every Sunspud targets roughly 45 seconds. A breathing Shop button and permanently free always-visible travel guide purchase, plot return, and selling. Ten logical quick slots reference a 200-slot Backpack; phones show five per page. Free placement uses an optional one-stud snap that defaults off, no required spacing, and exact-transform rejection. Percentage growth, whole-plant Harvest/weight reveal, Sell Held, favorite-safe Sell All, and Appraise are approved. Wild creatures begin arriving around minutes 8–10. (User-approved 2026-07-19; not yet implemented or playtested)
- Publishing: Roblox experience publishing not performed
- Emotional contract: The smallest internal first-playable prototype remains cozy and theft-free while core ownership/economy foundations are proven. The user changed the public initial-release target on 2026-07-20 to include paid true-transfer risk for deliberately exposed eligible plot assets. This is a conditional launch target, not implementation approval: it is built last, feature-flagged off, and blocks public launch until policy, protection, receipt, recovery, economy, and closed multiplayer trust gates pass. Wild unowned visitors retain the approved competitive capture rules before ownership.
- Map direction: Eight equal 96×96 plots on an outward ring surround Crescent Pond Sanctuary; this supersedes the earlier 72×72 standard. Every fresh server join begins outside the Welcome Gate; a later gameplay phase will move the player to an assigned plot after crossing the gate. Wealth-leaderboard and donation-board footprints sit beside the gate without blocking the centered Memory Tree sightline; the ranking metric and donation mechanism remain unresolved. Plots are publicly walkable, but later ordinary interactions must deny non-owner mutation. Shop, Sell, and Appraise share the expanded 80×80 Caretaker Hub. The pond is swimmable with bridges; the approximately 880×920 walkable island has gentle outer hills, a 20-stud perimeter trail, four invisible collidable border walls, and a continuous 4096×4096 ocean. Wild creatures will use a global arrival pool rather than region-locked species spawning. The Memory Tree island is the permanent event venue. One expanded natural meadow is reserved for future creature mounts; mount gameplay is not implemented. (User-approved direction; expanded Phase 2 geometry Verified 2026-07-20)
- Final game promise: Grow Habitat Flora, attract and understand wild creatures, form bonds, cultivate adapted plant lineages, and transform a small plot into a living sanctuary. (User-approved 2026-07-18)
- Gameplay reference priority: Keep the familiar `buy seed → plant → wait/offline → harvest → sell → reinvest → expand` rhythm as prominent and understandable as practical while surrounding it with original creature ecology, content, assets, balance, and presentation. (User direction 2026-07-19; not yet implemented or playtested)
- First three Habitat Flora: Hearthpetal (warmth and light), Ripplecup (water and gentle sound), and Nuzzlefern (shelter and calming scent). (User-approved 2026-07-18; not yet implemented)
- First three creatures: Cozzle prefers Hearthpetal warmth and light, Rillibob prefers Ripplecup water and gentle sound, and Mossnub prefers Nuzzlefern shelter and calming scent. (User-approved 2026-07-18; not yet implemented)
- First functional Adaptation: Emberkeep lets a Cozzle-influenced Hearthpetal retain warmth and light into early night. (User-approved 2026-07-18; not yet implemented)
- First cosmetic Bloommark: Starlace adds pale star-thread veins and occasional soft motes with no functional or economic effect. (User-approved 2026-07-18; not yet implemented)
- First weather state: Soft Rain is natural server-wide light rain with softer/cooler lighting, gentle ambience, and water ripples, without gameplay, economic, monetization, exclusive-content, or progression effects. (User-approved 2026-07-18; not yet implemented)
- First-playable currency: Leafnotes are earned from approved single-harvest crops, explicit regrowing-plant produce, and individually sold bonded creatures, then spent on approved seeds, with no direct premium conversion, upkeep, loss, debt, or passive interest. The separately gated paid-steal feature can indirectly acquire an existing asset that may later be sold normally under the current provisional contract; economy and anti-laundering review remain launch gates. (Plant-source amendment, creature, and paid-steal exceptions user-approved; not yet implemented)
- First-playable visitor interaction: A compatible creature arrives wild and unowned. Every contender personally completes Observe and correct Care to earn Trust/capture eligibility, then uses an original leaf-shaped `Haven Tag` for a disclosed server-authoritative roll. The caretaker has 60 seconds of exclusive priority and may open the visitor early; it then remains public for five minutes. The tutorial capture is guaranteed. Later base capture chances are Common 95%, Uncommon 80%, Rare 55%, Epic 30%, Legendary 12%, and Mythic 3%; 0.01% is not a capture chance and is reserved only as a possible later arrival-weight experiment. Every accepted attempt consumes one Haven Tag and the selected free Luck aid, if any; rejected/full/stale/busy/lost-race requests consume nothing. Familiarity is persistent per player × stable creature-definition ID × rarity tier, adds two absolute percentage points per accepted failure, guarantees capture on attempts 2/3/5/8/15/25 for Common/Uncommon/Rare/Epic/Legendary/Mythic, survives visitors, rejoins, and another contender winning, and resets only when that player captures the matching creature-definition ID. The next attempt has no gameplay cooldown but cannot overlap the durable prior result. In public contention, a failed contender's deliberate retry goes behind already-waiting distinct eligible contenders; it is immediate when nobody is waiting and defaults to No Aid. Luck selection is disabled on a guaranteed attempt. After failure, `Retry Capture` requests another turn while `Let Go` exits only that player's current attempt, preserves Familiarity, and leaves the visitor wild/public; during caretaker priority it does not open access early, because `Open to Everyone` remains the separate explicit control. Mythic success receives the approved original post-commit approximately five-second immediately skippable local sanctuary sequence—Haven Tag glow, leaf/constellation ribbon, trait-colored motes, voluntary acceptance mark, and journal reveal—while nearby players see a brief flourish, Legendary receives a shorter two-to-three-second flourish, and Full/Short/Off plus Reduced Motion settings are supported. Arrival tables, exact Luck formula/recipes, technical expiry grace, exact audio, production assets, and measured presentation budgets remain provisional. (User-approved direction 2026-07-19; transaction safeguards code-reviewed; not yet implemented, simulated, or playtested)
- First-playable disposition: Ordinary crops are single-harvest and require replanting; only explicit classes such as trees regrow. Plant harvests support favorite-protected Sell Held and favorite-safe bulk sale. Tree produce is collected one item at a time; when no slot is available, the selected produce stays unchanged on the tree. Successfully captured owned creatures can be displayed, stored, individually sold for Leafnotes, or released for no currency; persistent server-owned creature mutations, size, and weight affect appraisal; favorites block Sell Held, creature sale, and release; species journal discovery survives; Adapted Seeds can be planted or stored but not sold. (User-approved and amended 2026-07-19; not yet implemented)
- Storage and harvest capacity: Base Backpack capacity is 200 occupied slots. Compatible ordinary seeds stack to 999; trait-bearing/Adapted Seeds are individual unless their complete canonical payloads match; unique weighted/mutated whole plants, weighted tree produce, and stored creatures are individual. Ten hotbar assignments add no capacity. Planted crops and roaming/displayed owned creatures free Backpack slots. Capture starts with approved but unmeasured caps of two wild and six displayed owned creatures per plot and 64 simulated creatures per server; exact plant and other deployed limits remain provisional. Full storage leaves the exact mature plant or selected ripe produce unchanged; it blocks wild capture before RNG or item consumption, grants no ownership, and leaves the visitor wild. An already-owned roaming creature that cannot be recalled remains owned on the plot. Free favorite/lock remains available. There is no later storage-resolution theft grace for otherwise eligible exposed unlocked owned assets. One repeatable Developer Product may permanently add +200 per valid receipt, with five purchases and 1,200 total slots approved as the launch operational maximum subject to implementation and measured safety gates. Price, product ID, emergency receipt headroom, and page design remain provisional. (User-approved gameplay/product direction and platform correction 2026-07-19; not yet implemented, measured, created, or sold)
- Paid true-transfer stealing: A paid credit may move one exact exposed planted plant or captured roaming/displayed creature to the buyer's protected inventory without duplication; held/inventory/favorited/locked assets are protected; traits and provisional normal ownership/use/sale rights transfer; failed attempts retain the credit. On 2026-07-20 the user moved this from a later-update target to the initial public-release target. It remains last in the implementation order, disabled behind a server feature flag, and a hard public-launch blocker until core systems, policy classification, free protection, receipts, cross-profile recovery, anti-abuse limits, economy/trust stop metrics, and closed multiplayer tests pass. The proposed 99 Robux base price, sale/resale rules, timings, protected classes, private-server behavior, and platform classification remain provisional. (User-approved launch direction; architecture/security/design review Code-reviewed; Not yet implemented)
- Originality rule: All branded content and production assets will be original

## Entry: Phase 2 island graybox v1

- Date: 2026-07-20
- Agent: Codex / Map Agent, with QA and Performance review
- System affected: Welcome Gate, eight plots, Crescent Pond, bridges, swim exits, Memory Tree event island, Caretaker Hub, future meadows, outer hills, ocean, and Studio evidence
- Situation: The user authorized Phase 2 after approving five concept images and the island behavior. The open Studio place contained no occupied Terrain in the intended build region.
- Decision made: Build one additive, reversible, part-based graybox under `Workspace.CatchACreature_Graybox_v1`; treat the approved images as visual authority and `Design/Map/Phase2GrayboxDimensions.md` as numeric authority; leave gate transport, plot ownership, boards, services, events, creature spawning, and ocean return as labeled nonfunctional markers.
- Reasoning summary: A complete island shell tests scale, circulation, camera, swimming, and shared-space placement without leaking into Phase 3 gameplay or final art. One namespaced root and an exact rollback recipe make the exploratory build recoverable.
- Result: Studio contains an approximately 880×920 walkable island, 8 exact 96×96 plots on a larger outward ring, the centered gate/tree axis, a continuous 4096×4096 Terrain ocean, 4 bridges, 4 diagonal swim exits, a 104-stud event island, an expanded 80×80 Caretaker Hub, 2 expanded future meadows, a 20-stud perimeter/mount trail, board footprints, global arrival markers, outer hills, and four invisible collidable border walls. The root contains five `References` values naming the approved concept images; the former 72×72 plot image is composition-only.
- Test evidence: Edit-mode validator passed 104 of 104 checks with 466 descendants and 384 anchored BaseParts. One-client desktop play verified spawn at the gate, gate-to-center travel, center-to-plot travel, swimming, a diagonal water exit, navigation beneath the south bridge, and all eight nonblocking plot arrival pads. Post-review regression checks proved zero path-endpoint error for all eight dominant-axis fence openings, an exact 24-stud gate opening, 180,800 unchanged generated-water voxels, and successful ring-to-pad navigation for representative diagonal Plots 2, 4, 6, and 8. Studio console output was empty. Scene analysis from one play view measured about 54,212 non-shadow triangles and 68 non-shadow draw calls.
- Mistakes discovered: The first raw script handoff included command-wrapper text and failed to parse; source syntax was checked before retrying and no partial Studio change occurred. The first multi-screenshot request timed out, so captures were taken one at a time. `GeneratedPartCount` became stale after reference values were attached. Independent review then caught radial path endpoints missing cardinal fence openings, a 22-stud gate where 24 was required, rollback that could clear later Terrain changes, and a composite truth label. All four were corrected and regression-tested.
- Recommended future approach: Preserve the namespaced root and build/rollback pair; use single-purpose Studio calls; validate source text before execution; derive paths, pads, and fence gaps from one entrance definition; require exact dimensional assertions; keep Terrain rollback fail-closed; continue using approved images for composition and written dimensions for scale; test multiplayer crowding and real devices before final modeling or gameplay placement.
- Confidence level: High for structural and one-client desktop evidence; Medium for crowd/device usability
- Verification status: Verified
- Remaining validation: Multi-client, real mobile/tablet/controller, production DataStore, source-link synchronization, and user visual approval

### Follow-up: Full ocean coverage correction

- Date: 2026-07-20
- Agent: Codex / Map Agent
- System affected: Outer-ocean presentation, Terrain rollback boundary, and map viewport
- Situation: The user rejected exposed gray beyond the initial ocean rectangle and requested that the map cover the full visible area.
- Decision made: Expand the surrounding Terrain ocean from 800×904 through a checked intermediate 2048×2048 size to 4096×4096, while leaving the island, pond, plots, paths, and landmarks unchanged.
- Reasoning summary: The gray came from the Studio void outside the Terrain-water block, not a missing island surface. A larger continuous ocean preserves the approved island composition and removes the unwanted background from wide development views.
- Result: The same 900-stud top-down viewport now contains water edge-to-edge with no exposed gray void.
- Test evidence: Preflight found only existing generated water plus empty voxels and zero unrelated Terrain. Final verification found 4,194,304 of 4,194,304 voxels as exact full Water, zero changed voxels, and build/rollback source syntax passed.
- Mistakes discovered: The original 800×904 test region was large enough for gameplay around the island but not for high top-down inspection. The first 2048×2048 correction still exposed far corners in the same viewport.
- Recommended future approach: Include the widest intended development-preview camera in initial ocean-envelope acceptance; preserve the rollback guard and avoid adding unrelated Terrain inside its recorded region.
- Confidence level: High for edit-time coverage and voxel evidence; Medium for final horizon art and low-end-device runtime cost
- Verification status: Verified

### Follow-up: Expanded island, plots, borders, and future mounts

- Date: 2026-07-20
- Agent: Codex / Map, Game Design, QA, and Performance Agents
- System affected: Walkable island, plot scale, shared facilities, perimeter circulation, ocean containment, and future creature mounts
- Situation: The user required the walkable island to scale with the larger ocean, requested an invisible boundary that prevents leaving from every side, superseded the 72×72 plot limit, and approved faster rideable owned creatures as a future update.
- Decision made: Expand the walkable island to approximately 880×920, move the gate/spawn/boards and outer hills to the new edge, enlarge and move all plots to a nonoverlapping 96×96 outward ring, expand the Hub to 80×80 and meadows to 80×64, install four invisible collidable ocean walls, build a 20-stud walkable perimeter trail, and reserve Future Meadow 2 for mounts. Mount gameplay remains unimplemented; the future contract requires mounted speed to be materially above normal walking, with exact speed and eligibility unresolved.
- Reasoning summary: Larger plots and faster traversal should feel intentional rather than leaving empty land. The trail makes the island useful on foot today and creates a measurable future mount route, while server/gameplay work stays outside Phase 2. Physical walls provide immediate containment before a future return service exists.
- Result: The active Studio map now has 372 continuous land tiles, 8 separated 96×96 plots, widened 18-stud entrances and 12×12 arrival pads, scaled shared spaces, 36 perimeter-trail segments, one labeled mount reserve, and a closed invisible wall rectangle outside the land and hill band. The five approved images remain visual references; the filename containing 72×72 is now explicitly composition-only.
- Test evidence: Static validation passed for land coverage/bounds, plot centers/sizes/nonoverlap, path endpoints, shared-space clearance, 36 trail segments, wall invisibility/collision, zero scripts, and zero unanchored parts. One-client play respawned at the moved gate, reached the trigger/tree, reached Plots 1/3/5/7 and four trail quadrants, and previously proved all four walls stop outward movement. Console output was empty. Current client scene analysis measured 1,149 instances, 55,898 non-shadow triangles, and 63 non-shadow draw calls from one default play view. Independent review returned `PASS` after confirming zero trail overlap, closed wall corners, fail-closed Terrain rollback, 684 live descendants, 602 live BaseParts, and truthful mount/deferred-test labels.
- Mistakes discovered: Enlarging plots at their original centers crowded the Hub/reserves; moving the plots outward resolved it. The first mount-trail radii touched four enlarged plots; moving the route from 340×380 to 360×400 radii resolved every overlap. The historical 72×72 reference filename could be misread as active numeric authority, so it now carries an explicit supersession note. Independent review found the dimension file still called the live 12×12 arrival pads 10×10 and found the live `GeneratedPartCount` attribute left at its pre-expansion value; both were corrected, and future acceptance must compare documentation and count metadata directly with live/source values.
- Recommended future approach: Keep all numeric layout authority in the dimension file; run overlap checks whenever one footprint grows; treat mount speed/seat/camera/control/authority as a later tested system; make mounted movement server-authoritative and prove borders, dismount recovery, plots, pond, event crowding, mobile controls, and eight-player load before enabling mounts.
- Confidence level: High for edit geometry, one-client traversal, and physical boundary evidence; Medium for final visual density; Low for unimplemented mount behavior and real-device performance
- Verification status: Verified
- Mount implementation status: Not yet implemented
- Independent review: PASS

## 2026-07-21 R6 held-item transition

- Date: 2026-07-21
- Agent: Codex
- System affected: Avatar rig, hotbar truthfulness, held seed/plant presentation
- Situation: Slot 1 looked occupied at zero seeds, and held-item IK visibly conflicted with walking; the user selected R6 as the target rig and requested the arm straight forward.
- Decision made: Render zero-owned seed slots as `EMPTY`, set R6 in the source project, use a one-shoulder R6 pose, and limit the R15 fallback to the right arm.
- Reasoning summary: Inventory display must match authoritative ownership, and visual posing must not control locomotion joints.
- Result: Hotbar behavior is verified; R15 fallback is verified; R6 pose is simulated successfully; project build contains the R6 property.
- Test evidence: Rojo PASS, 58/58 server suites, direct GUI click evidence, R15 walk check, isolated R6 walk/geometry check, and Studio still capture.
- Mistakes discovered: Live source sync did not change the open place's hidden avatar setting.
- Recommended future approach: User applies the one-time R6 Avatar Settings change; Codex then repeats the normal-spawn R6 acceptance test.
- Confidence level: High within documented boundaries
- Verification status: Mixed: Verified, Simulated, and Requires Roblox Studio testing as stated above
