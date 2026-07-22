# QA Agent Memory

## 2026-07-21 hero-center and selling update

- Tasks completed: Added/run 2,456 map checks; reran 58 gameplay cases; resolved 18 forage points and six nodes; verified authored Hub/Plot/trail routes, wall collision, camera evidence, and clean logs; verified exact equip/favorite/sale behavior
- Strengths demonstrated: Separated free-form automation path choice from authored-route evidence, used fresh VMs after source changes, and kept visual, static, and economic authority evidence distinct
- Mistakes made: First map validator omitted `SURFACE_Y`; the failure was test-only and fixed before approval
- Bugs introduced: None found
- Bugs prevented: False migration failure, plot-path drift, invalid forage positions, stale tests, hidden HUD focal point, unequipped sale, favorite loss, and false clean-console claims
- Review feedback received: Native multi-client/device evidence and independent review remain required; a staged camera is not natural player analytics
- Useful patterns discovered: Exact geometry plus authored waypoint traversal plus real-HUD captures is a stronger map gate than unconstrained navigation alone
- Areas requiring improvement: Rollback-on-clone, multi-client crowding, streaming, devices, and live mixed bulk sale
- Current project knowledge: Final map evidence is 2,456/2,456; gameplay 58/58; forage 18/18 with six active; final logs empty
- Unresolved questions: Eight-player event flow, real device framing, final-art performance, and production persistence/multiplayer sale races
- Recent evaluation scores: Map/Codex overall 95; held/selling joint overall 95
- Next improvement goal: Build a safe-clone rollback test and device/crowd acceptance matrix before final-tree production

## 2026-07-21 seed-foraging update

- Tasks completed: Verified 54 fresh-VM cases, live prompt reward/relocation/cooldown behavior, all 18 ground points, simulated Mythic presentation, cleanup, and console state
- Strengths demonstrated: Combined deterministic rare-boundary tests with real client input and authoritative state inspection
- Mistakes made: The first VFX inspection missed the active window and could only prove cleanup
- Bugs introduced: None
- Bugs prevented: Same-point relocation, occupied-point relocation, cooldown mutation, no-reward RNG, and stale schema migrations
- Review feedback received: Clearly separate natural loot evidence from a presentation-only simulation
- Useful patterns discovered: For shared-world reward features, test both pure transaction invariants and actual prompt/world projection wiring
- Areas requiring improvement: Two clients, isolated v4 DataStore rejoin, commit faults, devices, and distribution simulations
- Current project knowledge: Current natural pool is Common/Uncommon only despite the complete future rarity table
- Unresolved questions: Contention winner behavior and user-perceived search balance
- Recent evaluation scores: Joint forage slice Overall 95
- Next improvement goal: Build the two-client and schema-v4 regression matrix before higher-tier content ships

- Tasks completed: Defined truth/test gates; executed initial graybox acceptance, expanded-island/96×96-plot/trail/invisible-wall checks, and Phase 3A Rojo source-link acceptance
- Strengths demonstrated: Broad regression, concurrency, and recovery coverage
- Mistakes made: The Phase 2 acceptance remains execution history rather than a repository-owned harness, and its first 104 checks missed path/fence alignment, exact gate width, destructive Terrain rollback safety, and composite truth-label syntax
- Bugs introduced: None
- Bugs prevented: Premature Verified claims, blocked arrival pads, unsafe bridge dimensions, missed water recovery, stale live count metadata, dimension/source drift, and prior gameplay transaction risks were identified before approval
- Review feedback received: Every important bug needs a prevention mechanism; geometry checks must assert connected-component alignment and exact contract dimensions; destructive tooling must fail closed; truth labels use one exact allowed value
- Useful patterns discovered: Deterministic state/property tests, probability golden boundaries, seeded simulations, receipt/request replay, eight-player contention, fault injection
- Areas requiring improvement: Repository-owned Luau automation plus real device, streaming, respawn, and eight-client checklists
- Current project knowledge: Rojo source-link acceptance covers sourcemap freshness, authorized-place restriction, localhost service, exact namespaced sources, build/restart/edit/revert propagation, and unchanged graybox counts. Graybox acceptance covers the moved gate, 372 land tiles, 96×96 plots, expanded shared spaces, swimmable pond/bridges, 36-segment perimeter/mount route, four invisible walls, reserves, and global arrivals. Mount gameplay requires separate server-authority/device/multiplayer acceptance.
- Unresolved questions: Post-death spawn; functional gate/plot assignment; donation semantics; ocean return; streaming; transfer protection/caps/resale/policy; prior Luck/expiry/audio/headroom questions
- Recent evaluation scores: Overall 98 for the 2026-07-20 expanded-layout independent review
- Next improvement goal: Add repeatable Sunspud transaction tests, then convert expanded-layout assertions into repository-owned Luau without weakening capture or paid-transfer coverage

## 2026-07-21 persistence-test update

- Tasks completed: Executed the isolated one-user Studio DataStore leave/rejoin/offline-growth/replay acceptance and cleanup checks
- Strengths demonstrated: Detected sparse slot loss, duplicate startup loading, incidental-input contamination, cached `GetAsync` observations, and a retained shutdown lease without overstating failure or success
- Mistakes made: The first timed crop fixture matured before the test step, and the first controlled run allowed incidental client input to mutate the deterministic fixture
- Bugs introduced: None
- Bugs prevented: Slot-10 state loss and same-player startup lease races were fixed before production; deterministic rerun disabled the client controller during remote mutation
- Review feedback received: The evidence is one-user isolated Studio durability, not production or fault-tolerant proof
- Useful patterns discovered: Fixed fingerprinted fixtures, input-disabled test sessions, authoritative store observation, exact replay payloads, offline maturity boundaries, and cleanup confirmation
- Areas requiring improvement: Mocked repository/service tests, hard-crash and ambiguous-write faults, multiserver, throttling, real devices, and multiplayer
- Current project knowledge: Exact 100,000 Leafnotes, seeds, item IDs/weights, hotbar slots 2/10, plot time/position, offline maturity, one runtime model, replay protection, cleanup, 13/13 regression cases, and clean build passed. One final Studio shutdown retained a bounded lease and was explicitly cleaned.
- Unresolved questions: Production fault behavior, shutdown retry effectiveness under injected errors, and real device/multiplayer behavior
- Recent evaluation scores: Pending final independent review for this follow-up
- Next improvement goal: Build deterministic fake-store repository faults and a duplicate-load service regression before expanding gameplay

Follow-up (2026-07-21): The duplicate-load service regression now exists and passes overlapping, sequential, departed-success, and departed-failure cases. Domain/schema coverage is 24/24, including malformed migration keys and reversible exact-item hotbar references. Shop/Sell landing coordinates and prompt counts/properties passed. Independent final review returned PASS. Remaining QA goals are injected DataStore faults, physical prompt/stored-card activation, touch/controller alternatives, safe-ground fallback, multiplayer, and production durability.

Stakeholder confirmation (2026-07-21): The user physically tested the completed desktop inventory and kiosk-access interactions in Studio and reported that they work. Remove desktop prompt/stored-card activation from the open QA gaps; touch/controller alternatives, safe-ground fallback, multiplayer, injected faults, and production durability remain open.

## 2026-07-21 Hearthpetal/Cozzle update

- Tasks completed: Expanded fresh play-server coverage to 30 farm/schema, 4 lifecycle, and 5 attraction cases; ran live growth/arrival and projection cleanup checks
- Strengths demonstrated: Asserted expected case counts and negative ownership state, not only successful visuals
- Mistakes made: First final run trusted Edit-mode require caching and returned stale contracts
- Bugs introduced: None
- Bugs prevented: False approval from stale tests, slot migration loss, duplicate visitors, and accidental capture enablement
- Review feedback received: Fresh VM is mandatory after contract/source changes
- Useful patterns discovered: Pair pure deterministic selection tests with one runtime model/cleanup fixture
- Areas requiring improvement: Schema-v3 isolated rejoin, physical inputs, real devices, multiplayer, and performance profiling
- Current project knowledge: Current final evidence is 30/30 + 4/4 + 5/5, clean console, Rojo PASS
- Unresolved questions: Visitor rejoin/expiry and two-player visibility
- Recent evaluation scores: Hearthpetal/Cozzle joint score recorded in AgentScores
- Next improvement goal: Add Observe acceptance with replay, distance, wrong-player, cleanup, and device cases

## 2026-07-21 hotbar and avatar regression update

- Tasks completed: Ran fresh zero-seed GUI/click checks, R15 equip/walk assertions, an isolated R6 pose/walk fixture, Rojo build validation, serialized-property inspection, and all four server suites
- Strengths demonstrated: Distinguished normal R15 verification from temporary-rig R6 simulation and checked behavior rather than relying on a screenshot
- Mistakes made: Initially expected the hidden R6 project property might live-sync into the already-open place; the fresh spawn proved it remained R15
- Bugs introduced: None
- Bugs prevented: False R6 verification, torso IK regression, phantom seed selection, and regression approval without suite totals
- Review feedback received: The place-level R6 setting needs one manual Studio step before normal-spawn acceptance
- Useful patterns discovered: Check hand position in torso-local coordinates and assert torso/root up vectors after movement
- Areas requiring improvement: Normal R6 spawn, real movement animation set, emotes, tools, swimming/climbing, respawn loop, mobile/controller, and multiplayer
- Current project knowledge: Current evidence is Rojo PASS, 58/58 suites, verified R15 behavior, and simulated R6 behavior with no IKControl
- Unresolved questions: Whether published avatar settings override player choice exactly as the source token indicates
- Recent evaluation scores: 97 test-quality score for the bounded regression pass
- Next improvement goal: Complete a clean normal-spawn R6 matrix after Avatar Settings is applied

## 2026-07-21 placement and ordered-slot regression update

- Tasks completed: Compared two coordinate conventions, asserted the exact saved plot position, ran 61 fresh Server VM cases, reran the Rojo build, and verified live slot reuse
- Strengths demonstrated: Used the failed mapping as a control and inspected authoritative state instead of approving only a screenshot
- Mistakes made: The first visual pass did not quantify the cursor-to-commit mismatch
- Bugs introduced: None
- Bugs prevented: False cursor-alignment approval, stale-suite approval, seed-reference leaks, and hidden hotbar reservations
- Review feedback received: Keep truth labels scoped to one-client desktop and current seed/plant paths
- Useful patterns discovered: Exact numeric state comparisons catch subtle screen-inset errors
- Areas requiring improvement: Touch/controller/device matrix, production DataStore migration, multi-client acquisition, and creature pickup
- Current project knowledge: Final desktop evidence is exact `(-20,-20)`, green reticle, live slot-1 reuse, 61/61 suites, and Rojo PASS
- Unresolved questions: Touch coordinate convention, controller reticle movement, and full-bar creature policy
- Recent evaluation scores: Overall 97 for this bounded slice
- Next improvement goal: Build the real-device placement matrix and a full-hotbar no-loss acceptance test
