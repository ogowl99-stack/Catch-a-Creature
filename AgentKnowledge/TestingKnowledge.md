# Testing Knowledge

## Knowledge entry: Memory Tree hero-center acceptance

- Date: 2026-07-21
- Agent: Codex / QA, Map, Gameplay, UI, and Performance roles
- System affected: Whole-map geometry, player routes, forage projection, camera composition, regression, logs, and rollback
- Situation: Expanding the main focal landmark changed every radial dependency and added 118 parts.
- Decision made: Pair a repository-owned 2,456-check edit validator with fresh-server module tests, forage raycasts/live-node counts, authored waypoint traversal, boundary collision, real-HUD captures, syntax/build checks, and log inspection.
- Reasoning summary: Static geometry proves exact contracts; live movement and cameras prove player-scale usability; fresh module tests protect unrelated gameplay.
- Result: All final acceptance evidence passed. One direct Hub-to-Plot automation attempt swam into the pond and was rerun successfully through authored bridge/ring waypoints; it was not counted as a geometry failure.
- Test evidence: Validator PASS (802 descendants, 720 BaseParts, 484 land, 30 ring, canopy top 255); 58/58 gameplay cases; 18/18 forage ground; six nodes; Hub/Plot 4/east trail navigation; Z≈544.5 wall stop; zero client/server warnings/errors; Rojo PASS at 214,125 bytes.
- Mistakes discovered: The first validator omitted `SURFACE_Y`, causing a test-only false failure at Plot 1. The first migration preflight used historical names instead of the semantic tag.
- Recommended future approach: Keep the validator source in the repository, verify authored waypoints instead of interpreting free-form automation path choice, and rerun camera checks with phone/tablet/controller layouts.
- Confidence level: High for one-client desktop and deterministic geometry
- Verification status: Verified

## Knowledge entry: Held-item and selling acceptance

- Date: 2026-07-21
- Agent: Codex / QA, Gameplay, UI, Data, and Security roles
- System affected: Equip, held presentation, inventory storage/favorites, and sale commands
- Situation: Single sale needed exact equip enforcement while full-inventory sale needed favorite protection.
- Decision made: Test pure domain/service invariants in a fresh VM, then exercise exact harvest/equip/store/restore/favorite/sell behavior through the live UI and direct malicious requests.
- Reasoning summary: UI success alone cannot prove the server rejects a forged unequipped sale or that a favorite-only bulk request is a no-op.
- Result: Server and live behavior matched the contract.
- Test evidence: Farm Domain 40, Farm Service 6; exact 1.12 Sunspud auto-equipped; direct unequipped sale rejected; favorite-only bulk no-op; equipped sale cleared item/equip/presentation.
- Mistakes discovered: Cached or stale source evidence is unsafe; the final run used a fresh play-server VM.
- Recommended future approach: Add real multi-item UI bulk sale, other-player held observation, R15 proportion variants, and touch/controller tests.
- Confidence level: High for one-client desktop memory mode
- Verification status: Verified

## Knowledge entry: Seed foraging and relocation acceptance

- Date: 2026-07-21
- Agent: Codex / QA, Gameplay, Data, Security, Map, and VFX roles
- System affected: Rarity selection, profile migration, reward transactions, cooldowns, node relocation, world ground points, and Mythic presentation
- Situation: The forage slice changes durable inventory and a shared world projection, so unit success alone cannot prove anti-macro relocation or prompt behavior.
- Decision made: Combine deterministic boundary tests with a fresh play VM and live prompt input. Require schema v1-v3 migration, atomic grant/replay/cooldown/full-capacity no-op, private-token rejection, rarity boundaries, eligibility filtering, different/unused relocation, no-location fallback, server distance, all-point ground resolution, post-success position change, cooldown position stability, presentation capture, cleanup, and clean console/build.
- Reasoning summary: Pure tests prove rare boundaries and no-op invariants; Studio interaction proves the actual prompt, remote path, runtime model, and client presentation are connected.
- Result: 37 FarmDomain, 5 FarmService, 5 CreatureWorldService, and 7 ForageWorldService cases passed (54 total). Live success granted Hearthpetal and moved the node from `west-01` to `south-03`; live cooldown retry changed neither profile nor position. All 18 ground points resolved. Mythic presentation rendered through a clearly labeled simulation.
- Test evidence: Fresh Roblox Studio server/client output, live keyboard input, server/client state queries, viewport capture, and console inspection on 2026-07-21.
- Mistakes discovered: A VFX instance query occurred after automatic cleanup and therefore could not serve as positive visual evidence; the timed screenshot is the evidence and the later absence is cleanup evidence.
- Recommended future approach: Add an isolated schema-v4 DataStore leave/rejoin, forced commit-failure relocation test, simultaneous two-player prompt test, distribution simulation, and touch/controller/low-end-device runs.
- Confidence level: High for one-client logic and presentation wiring; Low for production/multiplayer/device behavior
- Verification status: Verified within scope; Mythic visual Simulated

## Knowledge entry: Hearthpetal and Cozzle-arrival acceptance

- Date: 2026-07-21
- Agent: Codex / QA, Data, Architecture, Security, Gameplay, Enemy AI, UI, and Performance roles
- System affected: Multi-definition farm domain, schema v1/v2-to-v3 migration, fixed seed slots, item quick slots, Hearthpetal world model, deterministic Cozzle attraction, ownership labeling, and Rojo synchronization
- Situation: The first creature-facing slice changed a durable schema and generalized previously hard-coded Sunspud logic, so visual success alone could hide lost slot references, forged definitions, incorrect values, or accidental ownership.
- Decision made: Acceptance requires unknown-definition rejection; exact per-definition price/growth/weight/sale; v1/v2 migration; occupied and full slot-2 displacement without item loss; protected seed slots 1-2; deterministic item slots 3-10 including middle-gap/full cases; deterministic earliest Hearthpetal/tie-break selection; Sunspud non-attraction; no attractor after harvest; exactly one Cozzle; wild/unowned/capture-disabled attributes; clean console; and fresh Rojo build.
- Reasoning summary: The most damaging regression would be durable item loss during migration or a visual visitor being treated as owned. Tests therefore assert exact item preservation and negative ownership attributes before presentation quality.
- Result: Farm/schema suite passes 30/30, FarmService lifecycle passes 4/4, and CreatureWorldService selection passes 5/5 in a fresh play-server VM. Live Studio purchased and placed Hearthpetal, charged 8, wrote a 60-second clock, matured it, and produced one Cozzle. A projection fixture created one model with 20 descendants and removed it after attractor deletion.
- Test evidence: Fresh Server execution result; live snapshots and runtime attributes; Habitat Seeds and growth/arrival screenshots; clean console; `scripts/Test-Rojo.ps1` PASS; fresh sourcemap; 151,351-byte build.
- Mistakes discovered: Edit-mode `require` cached a pre-sync FarmContracts table and produced a false `INVALID_REQUEST`; a complete fresh dependency clone or new play-server VM is required after source changes. The first live screenshot also revealed subject/label occlusion and drove a tangential spawn offset plus smaller/higher visitor label.
- Recommended future approach: Add a repeatable fresh-VM test runner, schema-v3 isolated DataStore rejoin, physical shop/slot-2 placement, real touch/controller checks, two-player visitor visibility, visitor lifetime tests, and performance measurement before raising creature caps.
- Confidence level: High for pure migration/domain and one-player projection behavior; Medium for live client button/input wiring; Low for production persistence, real devices, multiplayer, and measured performance
- Verification status: Verified in current one-player Studio and repository tests; production/device/multiplayer tests required

## Knowledge entry: Backpack organization and service-access acceptance

- Date: 2026-07-21
- Agent: QA Agent / UI Agent / Gameplay Agent / Architecture Agent / Data Agent / Codex
- System affected: Backpack/hotbar references, idempotent organization commands, player-load lifecycle, migration failure handling, Shop/Sell prompts, and travel landing
- Situation: Live feedback identified a nonworking inventory entry point, redundant top-left capacity text, roof-height service travel, missing nearby service access, and a need to move exact items both directions between Backpack-only storage and numbered hotbar references.
- Decision made: Acceptance requires server rejection of protected/invalid slots; exact item preservation; revision-once replay; no-change without mutation; slot-10 behavior; deterministic first-free assignment; malformed legacy-key failure without throw; overlapping/sequential player-load guards; successful/failed departed-player cleanup; one prompt per kiosk; panel-only nearby access; and grounded front-of-kiosk fast travel.
- Reasoning summary: A UI-only slot change can still lose or duplicate valuable durable state if it is not serialized with sale/harvest and committed before acknowledgement. Travel correctness requires root position evidence, not just an apparently nearby camera.
- Result: Domain/schema tests pass 24/24 and FarmService lifecycle tests pass 4/4. Live unassignment cleared slot 2 and preserved the same 875-milli item in Backpack. Shop/Sell fast travel both landed at Y 48, 13 studs in front of their kiosks and below roof Y 56. One correctly configured prompt is visible on each kiosk. The stakeholder then physically confirmed in Studio that the requested inventory and kiosk interactions work.
- Test evidence: Fresh cloned-module Studio executions; exact public snapshots and GUI card text; prompt instance/property counts; viewport capture; clean console; Rojo source-link PASS; clean 115,399-byte build.
- Mistakes discovered: Initial travel used model pivot placement, then calculated ground from a rotated cylinder's large Y dimension. The first load guard missed sequential duplicates and failed departed-load cleanup. The first v1 migration called `tonumber` on arbitrary key types.
- Recommended future approach: Add full-hotbar and middle-gap assignment cases, injected repository release faults, prompt callback automation, safe-ground raycast/fallback validation, simultaneous-player kiosk tests, and real mouse/touch/controller confirmation.
- Confidence level: High for tested desktop domain/lifecycle/landing/input behavior; Low for untested touch/controller devices and multiplayer
- Verification status: Verified in the current one-player desktop Studio test; real devices and multiplayer remain unverified

## Knowledge entry: Phase 3A profile, saved-hotbar, and offline-growth acceptance

- Date: 2026-07-21
- Agent: Data Agent / Security Agent / QA Agent / Gameplay Agent / UI Agent / Codex
- System affected: Leafnotes, seeds, planted/harvested item identity, hotbar references, offline clocks, validation, leases, shutdown, and world/UI reconstruction
- Situation: The stakeholder required exact currency, crops, and hotbar contents after logout/rejoin and real-time crop growth while offline.
- Decision made: Pure acceptance covers a 100,000-Leafnote profile clone, preserved UUID/weight/local position/timestamps, T+44 rejection, T+45 success, long-absence maturity, first free saved item slot, sale cleanup, missing-hotbar rejection, backward-clock rejection, replay safety, and no-loss full Backpack. Repository acceptance additionally requires unique per-load tokens, no equal-revision shortcut, fail-closed nested validation, commit-failure freeze, load-after-leave cleanup, and bounded parallel release. Production acceptance requires an isolated published DataStore rejoin and fault/lease tests.
- Reasoning summary: Offline progress is correct only if the exact saved plant becomes mature without duplicated rewards, while persistent UI is correct only if a hotbar reference resolves to the same authoritative Backpack item.
- Result: The pure suite passes 12 cases. Live Studio memory mode showed the same harvested item ID in Backpack and saved hotbar slot 2, with `SUNSPUD` and `1.08 wt` rendered. Production durability remains unverified.
- Test evidence: Fresh cloned-module Studio execution returned 12/12; live query/capture matched item ID `c20d9b9d-76ea-405f-9e9b-22bec8488b5a` across Backpack and hotbar; client/server booted without errors; Rojo test PASS and clean build. Independent Data/Architecture and Security/QA reviews supplied additional fake-store, lease, corruption, shutdown, and published-test gates.
- Mistakes discovered: A job-wide lease token allowed stale releases; equal candidate revision could acknowledge the wrong mutation; shallow validation accepted corrupt nested data; client-only hotbar ordering could not survive rejoin.
- Recommended future approach: Inject a fake atomic store to test fail-before-write, commit-then-timeout, callback retry, stale writer, token takeover, delayed release, and shutdown; then use a non-production DataStore namespace to leave with exactly 100,000 Leafnotes and crops at several ages and rejoin a different server.
- Confidence level: High for pure/domain/UI evidence; Medium for repository code; Low for real DataStore until published testing
- Verification status: Simulated and Code-reviewed; Requires production testing

Follow-up evidence (2026-07-21): Studio API access was enabled and the exact user key was tested in the isolated `CatchACreature_StudioPersistenceTest_20260721_v1` namespace, never the production store. A deterministic schema-v2 fixture loaded at 100,005 Leafnotes with two seeds, Backpack items in saved slots 2 and 10 (weights 1,078 and 950 milli), and one plotted item at local `(0, 0)`. A normal `BuySeed` durably produced exactly 100,000 Leafnotes, three seeds, seed revision 5, and profile revision 41. After a clean leave, an authoritative `UpdateAsync` read observed the exact values, both item identities/weights, the plotted item identity/weight/timestamps, one request-journal entry, and a cleared lease. The crop matured while Studio was stopped. Rejoin reconstructed one mature unharvested world model with its prompt enabled, restored the exact money/seeds/items/hotbar/plot timestamps, and replaying the original request ID returned `replay = true` without charging or incrementing again. The isolated key and flag were fingerprint-checked and deleted, normal `Memory (Simulated)` mode was restored, the controller was re-enabled, the expanded suite passed 13/13, and a clean Rojo build produced 91,506 bytes before its temporary artifact was removed.

Test-discovered regressions (2026-07-21): Sparse numeric hotbar keys did not round-trip through DataStore (slot 10 disappeared), so schema v2 uses canonical string keys and includes a v1 migration/regression case. Studio startup could also schedule the same player load twice, causing the second load to overwrite the valid in-memory session with `SESSION_BUSY`; a per-player load guard now prevents it. One final Studio shutdown retained a valid 120-second lease despite correct data; the exact isolated record was safely cleared during test cleanup and release now retries transient DataStore failures three times. This scoped test verifies one-user isolated Studio DataStore durability, clean first leave/rejoin, offline maturity, sparse hotbar persistence, and replay safety. It does not verify the production namespace, hard-crash recovery, throttling, ambiguous commits, multi-server takeover, multi-client behavior, production scale, or real devices.

- Follow-up confidence level: High for the scoped isolated Studio test; Low for the explicitly untested production/fault/multiserver cases
- Follow-up verification status: Verified for the isolated Studio test only; Requires production testing for launch durability


## Knowledge entry: Phase 3A direct-placement and hotbar-input acceptance

- Date: 2026-07-21
- Agent: UI Agent / QA Agent / Codex
- System affected: Farm controller input, placement presentation, hotbar projection, held-item selection, and travel layout
- Situation: Placement and inventory controls were revised during a live playtest based on stakeholder feedback.
- Decision made: Acceptance checks include absence of the separate Place button; direct world click/tap wiring; server-canonical plant creation; `1`-`9`/`0` and keypad mappings; disabled default Backpack CoreGui; visible Sunspud name/weight projection; exact held-item ID sale wiring; centered travel order; compact-width overlap handling; clean console; and a clean Rojo build.
- Reasoning summary: A visually correct hotbar can still fail if Roblox consumes its shortcut keys, while a responsive travel row can hide other HUD cards at narrower widths. Both behavior and layout must be checked.
- Result: Direct placement, centered travel, and harvested Sunspud name/weight projection are verified in Studio. The exact harvested item ID appeared in saved snapshot slot 2 and the GUI rendered `SUNSPUD` / `1.08 wt`. Physical top-row key input remains required before number shortcuts are fully verified.
- Test evidence: Studio live source inspection, runtime profile revisions and canonical planted coordinates, centered-row and post-harvest captures, exact snapshot/Backpack/hotbar item-ID match, exact GUI label, `Backpack` CoreGui false result, console inspection, and `scripts/Test-Rojo.ps1` PASS. Studio's virtual input tool rejected top-row number simulation because Roblox reserves those keys; keypad injection was available but does not replace a real top-row test.
- Mistakes discovered: The initial narrow capture exposed stats/travel overlap and later cramped item text; the initial shortcut implementation competed with Roblox's built-in hotbar; screen coordinates initially used a viewport ray; client-only slot rebuilding was unstable.
- Recommended future approach: Always disable or formally arbitrate CoreGui input before implementing a custom numbered hotbar; use one screen-coordinate ray path; persist item IDs server-side; include 527-pixel and desktop HUD captures; do one physical `1` and `0` confirmation.
- Confidence level: High for direct placement/layout/harvest label; Medium for uncompleted physical shortcut check
- Verification status: Mixed

## Knowledge entry: Rojo source-link acceptance

- Date: 2026-07-21
- Agent: QA Agent / Architecture Agent / Codex
- System affected: Rojo configuration, local server, Studio synchronization, and Phase 2 graybox isolation
- Situation: The installed Studio plugin reported that it could not reach a Rojo server, and the repository had no executable source mapping.
- Decision made: Acceptance requires a valid sourcemap; a listening localhost server returning HTTP 200; the exact shared/server/client folders and ModuleScript sources in Studio; one observed repository-to-Studio edit; and unchanged graybox existence, descendant count, and BasePart count.
- Reasoning summary: Seeing the plugin connect is insufficient evidence if the wrong project is served, source does not propagate, or the sync boundary can damage existing Studio work.
- Result: Every source-link acceptance check passed. The authorized place restriction and repository-owned Rojo 7.7.0 pin are present; the graybox remained at 684 descendants and 602 BaseParts.
- Test evidence: Rojo 7.7.0 CLI output; generated `sourcemap.json`; clean 2,048-byte temporary place build; HTTP endpoint response; server restart/reconnect; MCP hierarchy searches and complete script reads; post-reconnect live `ProjectInfo.luau` update; edit-mode Luau graybox count.
- Mistakes discovered: A detached process looked alive inside its launch command but was removed when the sandboxed shell ended. Process persistence must be checked from a second command.
- Recommended future approach: Add a repeatable source-link smoke test and rerun it after every `default.project.json` change; add file-change assertions for each mapped context before gameplay modules expand.
- Confidence level: High
- Verification status: Verified

## Knowledge entry: Initial-release paid-transfer and island-graybox acceptance

- Date: 2026-07-20
- Agent: QA Agent / Architecture Agent / Data Agent / Security Agent / Game Design Agent / Monetization Agent / Map Agent / Codex
- System affected: Join flow, plots, pond, event plaza, item ownership, paid credits, policy, cross-profile recovery, abuse prevention, economy, and player trust
- Situation: The user locked the island circulation/event direction and moved paid true-transfer stealing into the initial public-release target.
- Decision made: Graybox acceptance must prove a centered gate/tree sightline; spawn outside the gate trigger; exactly one assigned-plot movement per crossing; eight unique plot assignments; physical public plot access without unauthorized mutation; safe plot arrival pads; optional bridge routes and escapable swimmable water; recoverable ocean boundary; unobstructed board standing space; eight-player tree-event circulation with multiple exits; meadow reserves that make no dated promise; and global rather than region-locked creature arrivals. Paid-transfer launch acceptance must prove idempotent receipt credit, exact UUID/revision selection, one owner, no duplication, retained credit on invalid transfer, fail-closed eligibility for both users, free protection, immutable provenance, capacity-safe recovery, crash reconciliation at every phase, race safety against lock/recall/harvest/sale/release, anti-alt/repeat-victim limits, feature-flag rollback, and predeclared economy/trust stop metrics.
- Reasoning summary: The busiest world space and the riskiest ownership system both need observable pass/fail contracts before visual polish or product exposure. A launch target is not evidence that either system works.
- Result: Acceptance requirements are code-reviewed. Exact dimensions, protection timings/classes, product configuration, policy classification, resale rules, trust thresholds, and test harness remain unresolved. No test has run.
- Test evidence: Direct user decisions and three independent read-only reviews on 2026-07-20. No Studio graybox, Luau, DataStore, Marketplace, multiplayer, device, performance, economy, or player evidence exists.
- Mistakes discovered: A spawn inside the gate could skip orientation; the event tree could become a bridge bottleneck; normal plot visitation could accidentally inherit edit remotes; a paid receipt tied to a volatile target could acknowledge an undelivered purchase.
- Recommended future approach: Test the dimensioned graybox first; keep theft out of the internal first playable; later use deterministic fault injection, two-buyer races, closed eight-player trust tests, and a hard launch checklist with kill-switch evidence.
- Confidence level: High for required test classes; Low for runtime quality until implemented
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Failure decision and rare-celebration acceptance

- Date: 2026-07-19
- Agent: QA Agent / Security Agent / Architecture Agent / UI Agent / VFX Agent / Audio Agent / Performance Agent / Codex
- System affected: Failed-attempt transaction, Familiarity, tier guarantee, Retry/Let Go, public queue, ownership commit, cutscene, VFX/audio, accessibility, and cleanup
- Situation: The user resolved capture cost/progress/fairness and added a deliberate failure choice plus super-rare success celebration.
- Decision made: Acceptance must prove: every committed accepted attempt consumes exactly one Haven Tag and selected aid, if any; a committed failure also increments exactly one matching Familiarity failure; rejected traffic mutates nothing; +2-point previews and guaranteed attempts 2/3/5/8/15/25 are exact; Retry defaults to No Aid; guaranteed attempts expose no selectable aid; progress persists and resets only in the matching approved bucket; Retry and Let Go are mutually exclusive/idempotent; Retry creates one fair intent and is immediate only when no distinct contender waits; caretaker Let Go preserves the remaining priority window and changes no encounter/Familiarity/item state beyond closing that player's flow; queue-front revalidation handles lost eligibility; success creates one exact owner before any celebration; Mythic/Legendary descriptors select only their approved presentation; duplicate/late celebration events do not duplicate state or presentation; skip/reduced-motion/off/disconnect/respawn/streaming failure restore camera/input and clean up; nearby players never receive forced camera/control changes.
- Reasoning summary: The mechanic crosses random acquisition, persistent economy, concurrent public fairness, and optional high-impact presentation, so state, transaction, UI, and cleanup invariants must be tested together and independently.
- Result: Acceptance requirements are code-reviewed. Mythic/Legendary triggers, caretaker Let Go behavior, No Aid retry default, guaranteed-attempt Luck disabling, and visual sequence/audience/duration/settings are approved. Exact Luck formula, expiry grace, audio, creative assets, and measured budgets remain unresolved. No tests have run.
- Test evidence: Direct user decisions and three independent specialist reviews on 2026-07-19. No executable evidence exists.
- Mistakes discovered: Existing tests were still parameterized for choices the user has now resolved. Celebration tests could be omitted as “cosmetic,” even though camera/input/cleanup failures can block play.
- Recommended future approach: Add golden probability tests, deterministic state/property tests, fault injection at each item/Familiarity/ownership/event boundary, eight-player high/low-latency contention, held-input and decision-race tests, and synthetic concurrent celebration profiling across the device/accessibility matrix.
- Confidence level: High for required invariants; Low for runtime behavior until implemented
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Immediate-retry and Familiarity acceptance

- Date: 2026-07-19
- Agent: QA Agent with Game Design, Economy, Architecture, Data, Security, UI, Performance, and Codex review
- System affected: Capture retry, Familiarity, attempts, items, public contention, expiry, persistence, odds UI, bot resistance, and economy
- Situation: The user approved no post-failure cooldown, immediate retry after a result, and slightly rising chance toward a persistent hard guarantee.
- Decision made: Acceptance must prove that the Capture action reaches the deliberate Retry/Let Go decision immediately after the authoritative terminal result with no artificial timer; at most one active roll exists per player/visitor; prebuffered/new-ID spam produces no extra roll; duplicate request IDs return one outcome; valid failure consumes one Haven Tag and the selected free aid and increments Familiarity exactly once; invalid/busy/full/stale/out-of-range/lost-race/expired requests increment nothing and consume nothing; exact current/next odds and guarantee progress update after every failure; fixed visitor traits never reroll; the 60-second priority and five-minute public deadline behave under queued/in-flight requests; and eight-player distinct-contender round-robin cannot starve an eligible player.
- Reasoning summary: Immediate retry is a UX promise, not permission to bypass the atomic transaction. The test oracle must distinguish valid committed failure from rejected traffic and prove that progress, item cost, RNG calls, VFX, and ownership remain exactly once.
- Result: Acceptance scope is code-reviewed. Familiarity numbers/guarantees, all accepted-attempt consumption, queue ordering, No Aid retry default, guaranteed-attempt Luck disabling, and caretaker Let Go behavior are approved. Luck formula/recipes and expiry grace remain unresolved. No tests have run.
- Test evidence: Two read-only cross-functional reviews on 2026-07-19; no simulation, Luau, multiplayer, persistence, economy, performance, or Studio evidence.
- Mistakes discovered: The previous suite expected a post-failure cooldown and would incorrectly reject the approved immediate-retry behavior. It also did not define prebuffer/autoclick cases.
- Recommended future approach: Convert the locked choices into golden probability/guarantee tests, deterministic state/property tests, fault-injected item/Familiarity transactions, high/low-latency eight-player contention, and accepted-attempt throughput measurements before presentation implementation.
- Confidence level: High for required invariants; Low for thresholds until approved and measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Competitive wild-capture acceptance

> Follow-up (2026-07-19): The newer failure-decision entry above also records the now-approved accepted-failure cost, exact Familiarity key/math/guarantees/persistence/reset, distinct-contender round-robin, Retry/Let Go, and post-commit celebration requirement. Any unresolved wording below is historical.

- Date: 2026-07-19
- Agent: QA Agent with Game Design, Economy, Architecture, Data, Security, Monetization, Performance, UI, Enemy AI, and Codex review
- System affected: Arrival rarity, Observe/Care eligibility, capture odds, consumables, storage, concurrency, ownership, persistence, UI, economy, performance, originality, and later paid theft
- Situation: The user approved chance-based capture, open availability until capture, and full-storage no-ownership behavior. The exact integration and balance remain undecided.
- Decision made: Acceptance must separately validate habitat-eligible arrival pools and capture-success definitions; the approved 95/80/55/30/12/3 table; exact server-computed base/final odds; one roll per accepted attempt; no RNG/item consumption for wrong Care, invalid/stale/busy/out-of-range/full-storage requests; one slot reservation and at most one owner under eight-player same-frame contention; idempotent replay; disconnect/save fault recovery; no wild visitor in paid-theft eligibility; and a static provenance test proving no Robux, paid currency, paid boost, paid-stolen asset, or trade path can fund capture/luck. Tests must cover personal Trust, 60-second priority/open early, tutorial certainty, five-minute public lifetime, deliberate no-cooldown retry, accepted-failure cost, approved Familiarity/hard-guarantee table, distinct-contender round-robin, fixed visible traits, proximity, at most one free next-attempt aid, and the approved starting caps.
- Reasoning summary: Random acquisition plus public contention is unsafe unless definitions, player eligibility, capacity, consumption, RNG, and ownership commit are all independently observable and serialized. A documentation-only probability example is not balance evidence.
- Result: Test scope is code-reviewed. No exact rarity table, capture curve, priority window, item/potion formula, pity schedule, visitor cap, or executable harness is approved. No test has run.
- Test evidence: Direct user direction and two read-only cross-functional reviews on 2026-07-19. Analytical check only: 0.01% success implies 10,000 expected attempts and roughly 6,932 median attempts. No simulation, Luau, Studio, multiplayer, device, performance, economy, or player evidence exists.
- Mistakes discovered: Earlier test plans assumed deterministic bonding and ownership-on-full fallback; neither can remain an acceptance oracle for the new capture direction. Arrival and capture odds also need distinct test namespaces and UI labels.
- Recommended future approach: Lock the remaining choices, write deterministic pure-module transition/property tests, run large seeded probability simulations for every modifier boundary, fault-inject the ownership transaction, then perform Studio single-client integration and closed eight-player contention testing before calling the mechanic Verified.
- Confidence level: High for required invariants; Low for balance and experience quality until measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Repeatable capacity receipt and scaling acceptance

- Date: 2026-07-19
- Agent: QA Agent with Architecture, Data, Security, Monetization, Performance, UI, and Codex review
- System affected: Developer Product receipts, capacity grants, stack limits, deployed assets, tree produce, bonding fallback, later theft, persistence, paged UI, and fairness
- Situation: The user replaced one-time paid capacity with repeatable permanent +200 purchases, completed the remaining item-counting decisions, and requested literal unlimited stacking.
- Decision made: Acceptance must prove exactly-one +200 durable grant per unique receipt under replay, concurrency, order changes, disconnect, crash, save failure, and cross-server retry; `NotProcessedYet` on uncertainty; finite operational maximum plus emergency headroom; prompt blocking at the measured maximum; 998/999/1000 compatible ordinary-seed behavior; trait-bearing/Adapted Seeds stacking only when their complete canonical payloads match; individual weighted tree produce/harvests/creatures; deploy/recall slot movement and separate caps; full crop/selected-produce/existing-owned-creature identity retention; full-storage wild capture with no roll/consumption/owner; free lock versus immediate no-grace later theft; paged/virtualized inventory; recoverable cross-page Appraise/Sell All; and measured persistence, join, memory, network, UI, economy, and player-trust results through every capacity tier.
- Reasoning summary: A repeatable purchase increases both receipt-failure surface and persistent-data multiplicity. Literal infinity cannot have a finite test oracle, so a measurable operational ceiling is a required acceptance input.
- Result: Test scope is recorded. Follow-up: five purchases/1,200 total slots is user-approved as the launch operational maximum but remains unmeasured and unimplemented. Product price/ID, emergency headroom, deployed caps, page architecture, refund/revocation source, and executable harness remain unresolved. ADR-009 replaces the old new-bond-on-full fallback with no roll, consumption, or ownership.
- Test evidence: User decisions and two read-only specialist reviews only; no test executed.
- Mistakes discovered: The prior pass tests did not cover repeat receipts, unique purchase ledgers, prompt-at-cap races, or page-scale batch operations.
- Recommended future approach: Build receipt state-machine tests before store UI; benchmark 200, 400, 600, 800, 1,000, and the approved 1,200 worst-case profiles; require a safe margin and receipt headroom; then gate every later ceiling increase through the same suite.
- Confidence level: High for the required tests; Low for maximum capacity until measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Backpack capacity and permanent-pass acceptance

> Follow-up (2026-07-19): The one-time pass tests in this historical entry are superseded by the repeatable Developer Product receipt tests above. Base capacity and inventory behavior remain active.

- Date: 2026-07-19
- Agent: QA Agent with Architecture, Data, Security, Monetization, Performance, UI, and Codex review
- System affected: Inventory slots, stacks, harvests, creatures, hotbar, mobile paging, persistence, paid entitlement, economy, and later theft races
- Situation: The user approved 200 free slots, stackable seeds, individual unique assets, full-storage no-loss behavior, a permanent storage pass, universal Sunspud timing, and exact mobile/placement/travel behavior.
- Decision made: Future acceptance must prove slot boundaries at 0/199/200/201; existing-stack increment versus new-stack/unique rejection; bounded canonical stack behavior; concurrent final-slot serialization; hotbar reference uniqueness; full SingleHarvest and tree-produce no-op/retry; exact identity and trait retention; save/rejoin/fault recovery; universal roughly 45-second Sunspud timing; pass nonowner/owner/error/purchase/rejoin/off-sale/over-cap behavior; no client entitlement; no loss on lookup failure; dynamic price/bonus disclosure; no full-storage Robux prompt; 200/expanded serialization and virtualized UI performance; two stable phone pages of five; and later harvest/favorite/steal revision races.
- Reasoning summary: The feature crosses persistence, economy, monetization, mobile UX, and later ownership transfer; boundary and failure tests are required before the happy path can be trusted.
- Result: At this checkpoint, base acceptance coverage was defined. Later entries resolve the 999 maximum, individual weighted produce, one-at-a-time tree collection, deployed-slot direction, existing-owned recall, free favorite/lock including Sell Held, five-grant/1,200 launch maximum, and no-grace choice while superseding pass and new-bond-on-full tests. Product price/ID/headroom, canonical stack key, exact caps, page architecture, and executable harness remain unresolved.
- Test evidence: User-approved rules plus two read-only specialist reviews; no tests have executed.
- Mistakes discovered: Capacity originally remained abstract, and a generic full-inventory check would not catch stack increments, last-slot races, paid lookup failure, or exact planted-item retention.
- Recommended future approach: Implement pure deterministic capacity tests first; add profile-size/UI-load measurements before choosing the pass bonus; then verify Marketplace behavior and responsive UI in Studio without creating or selling a live pass during this phase.
- Confidence level: High for test scope; Medium for thresholds until measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Five-minute tutorial acceptance requirements

- Date: 2026-07-19
- Agent: QA Agent / Gameplay Agent / Codex
- System affected: Tutorial state, seed grant, growth, harvest, sale, reconnect, economy, devices, and first-session comprehension
- Situation: The user approved an approximately five-minute farming tutorial hook using always-stock Sunspud with a universal roughly 45-second growth target, ordinary whole-plant single-harvest behavior, ten quick slots referencing 200-slot storage, permanently free travel, and flexible placement.
- Decision made: Before implementation approval, define deterministic tests for one starter-currency/purchase path; Sunspud always-stock availability and universal roughly 45-second maturity; valid step order; permanently free shop/plot/vendor travel state and orientation; ten-slot quick access referencing one authoritative backpack inventory; optional snap and no-required-spacing placement; truthful percentage growth; atomic `SingleHarvest` removal plus exactly-one output; allow-listed `Regrower` retention plus next cycle; server-owned weight; vendor Sell Held, favorite-safe Sell All, and read-only Appraise behavior; reconnect/resume at every step; no duplicate rewards; full-storage no-loss recovery; reduced-motion guidance; completion within the target; mobile/controller parity; creature arrival around minutes 8–10; and economy simulations proving Sunspud and future regrowing trees cannot dominate repeat play.
- Reasoning summary: A fast hook only helps if players understand it, cannot lose progress, and cannot farm a tutorial-only reward exploit.
- Result: Acceptance scope is recorded. The plant name/universal target, harvest modes and whole-plant semantics, 200-slot Backpack/quick-reference relationship, seed stacking direction, full-storage no-op, free travel, exact-transform rejection, snap behavior, phone paging, and vendor action structure are resolved. Later entries resolve stack, capacity ceiling, tree collection, and Sell Held favorite behavior. Sunspud art/price/yield, remaining product details, exact capture timing, density caps, and the executable harness remain unresolved.
- Test evidence: User-approved timing goal and read-only QA design review only; no game execution or player data exists.
- Mistakes discovered: The earlier Phase 1 gate named a guided cycle without separating the five-minute farming hook from later creature bonding.
- Recommended future approach: Add a documentation regression check for stale blanket-regrowth, unnamed-tutorial-plant, paid-travel, and ten-slots-as-total-storage language; then use deterministic module tests and observed Studio playtests with new-player instructions hidden from the tester. Instrument step timestamps and abandonment only after consent-compliant analytics exists.
- Confidence level: High for required invariants; Medium for the five-minute target until observed
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Initial test priorities

1. Content-definition validation
2. Plant growth and harvest state transitions
3. Timestamp and offline-progress boundaries
4. Save/load round trips and schema migrations
5. Inventory capacity and no-loss mature-plant/selected-ripe-produce retention on the plot
6. Deterministic RNG distribution and capture-modifier simulations
7. Creature attraction, clue/Care eligibility, wild-capture contention, and exact-one ownership
8. Adaptation/Bloommark separation
9. Breeding inheritance invariants
10. Receipt idempotency and disconnect recovery
11. RemoteEvent validation and rate limits
12. Weather queue and no-overwrite behavior
13. Mobile/controller interaction coverage
14. Crowded-plot performance

## Current evidence

Phase 2 now has edit-mode structural and one-client desktop traversal evidence. No gameplay-module, save/load, multi-client, mobile, tablet, controller, or production DataStore tests exist.

Document type: Test backlog and baseline guidance, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.

## Knowledge entry: Phase 2 graybox acceptance run

- Date: 2026-07-20
- Agent: QA Agent / Codex
- System affected: Island structure, R15 spawn and movement, plots, water, bridges, event circulation, Hub, meadow reserves, and evidence labeling
- Situation: The first authorized Studio map shell required direct evidence before it could be called Verified.
- Decision made: Combine exact edit-mode assertions with one-client play navigation. Verify every plot center/size/metadata/arrival pad, bridge width and clearance, swim exits, event footprint, Hub/meadow envelopes, gate separation and sightline, reference metadata, anchoring, Terrain water, R15 spawn, land routes, swimming, water recovery, and under-bridge movement.
- Reasoning summary: Screenshots alone cannot prove dimensions or collision, while static assertions alone cannot prove a Humanoid can traverse the intended routes.
- Result: All 104 initial static checks passed. Spawn was within 3.5 studs of the gate SpawnLocation. Navigation passed from gate to trigger, trigger to Memory Tree, tree to Plot 1, water entry, diagonal swim exit, beneath the south bridge, and onward to Plot 5. All eight arrival pads had zero blocking parts. Independent review found four missed contract errors; after correction, all eight path endpoints matched their shared fence openings with zero positional error, the gate measured exactly 24 studs clear, the rollback guard found zero changed voxels across 180,800 generated-water voxels, and ring-to-pad navigation passed for representative diagonal Plots 2, 4, 6, and 8. Console output remained empty.
- Test evidence: Direct Roblox Studio Edit, Client, and Server MCP outputs on 2026-07-20.
- Mistakes discovered: The first player state drifted before the controlled test, so the server explicitly reloaded the character and reset the start point. The initial validator checked arrival-pad obstruction but not path-to-fence alignment, and checked the sightline without asserting the exact gate opening. It also did not audit rollback against later Terrain edits. A screenshot request timing out is not a failed game test and was kept separate from gameplay evidence.
- Recommended future approach: Turn the assertions into a repository-owned repeatable Luau test after source linkage; require contract-level dimensions and cross-component alignment, not only existence/clearance; add destructive-tool fail-closed review; then add eight-player crowd routes, streaming re-entry, respawn policy, touch camera, controller focus, and ocean-return behavior when those systems exist.
- Confidence level: High for one-client desktop graybox; Low for untested device and multiplayer behavior
- Verification status: Verified
- Remaining tests: Multi-client, mobile/tablet/controller, production persistence, user visual approval, and functional gameplay markers

Follow-up evidence (2026-07-20): The user rejected gray void beyond the ocean. The final 4096×4096 Terrain-water envelope passed a same-camera top-down visual check and an exact 4,194,304-voxel Water scan with zero changed voxels. Build and fail-closed rollback sources both passed Studio `loadstring` syntax checks. Runtime device cost remains unmeasured.

Follow-up evidence (2026-07-20): The expanded 880×920 island passed exact 372-tile coverage and bound checks. All eight 96×96 plots, 18-stud openings, 12×12 arrival pads, paths, expanded Hub/meadows, 36-segment mount route, and four invisible collidable walls passed static checks with no overlaps, scripts, or unanchored parts. One-client navigation passed the moved gate/tree, representative Plots 1/3/5/7, and all four trail quadrants; four-side outward movement stopped at the walls; console output was empty. Independent review then confirmed zero trail SAT overlap, closed wall corners, exact live count metadata, and fail-closed rollback after correcting one 10×10/12×12 documentation mismatch and one stale live count attribute. Mount gameplay remains `Not yet implemented` and needs server-authority, eligibility, speed, camera, animation, mobile/controller, collision, dismount, multiplayer, and persistence tests.

## Knowledge entry: Phase 1 test-first gate

> Follow-up (2026-07-19): Phase 1 standards and source-link work are now authorized. The test-first requirements remain active; Phase 2 grayboxing and gameplay implementation are not authorized.

> Follow-up (2026-07-20): Phase 2 grayboxing was subsequently authorized and its v1 geometry passed the scoped acceptance entry above. Phase 3 gameplay remains unauthorized.

- Date: 2026-07-19
- Agent: QA Agent / Codex
- System affected: Phase 1 standards, definitions, source linkage, first-playable loop, persistence, devices, and evidence
- Situation: Phase 0 design is complete, but no code, source scaffold, game test, or Studio-linked workflow exists.
- Decision made: Phase 1 planning must define executable acceptance criteria before implementation. Minimum gates are strict content-definition validation; one guided-cycle state test; timestamp/offline boundaries; save/load/migration round trip; server-authoritative action validation; economy simulation; device interaction checklist; representative crowded-plot budget; and verified Studio/source linkage.
- Reasoning summary: Translating approved prose directly into broad gameplay code would hide assumptions and make regressions difficult to localize.
- Result: A test-first entry gate is recorded. No test harness or gameplay test is implemented. The later authorization covers Phase 1 standards/source linkage only, so these gates must be satisfied before gameplay work expands.
- Test evidence: Phase 0 documentation checks and final independent milestone review PASS only; no game execution evidence.
- Mistakes discovered: Earlier planning listed broad test categories without tying them to a Phase 1 authorization gate.
- Recommended future approach: For every authorized module, write the invariant, failure cases, test command or Studio procedure, expected evidence artifact, and rollback before implementation.
- Confidence level: High
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Paid true-transfer stealing acceptance requirements

- Date: 2026-07-19
- Agent: QA Agent with Architecture/Data/Security and Monetization review
- System affected: Paid credits, target eligibility, ownership transfer, policy, pricing, inventory, provenance, player trust, and recovery
- Situation: One Robux purchase can now expose another player's valuable persistent asset to permanent ownership transfer while concurrent recall, storage, sale, release, harvest, or other steal attempts occur.
- Decision made: Require eligibility matrices; exact-target disclosure; duplicate/replayed/out-of-order receipt tests; two-buyer contention; recall/favorite/sell/release/harvest versus reserve races; disconnect and shutdown at every transaction phase; stale owner/revision; full inventory; policy false/failure for both users; regional-price checks; DataStore fault injection; invariant scans for one owner/one consumed credit; provenance preservation; retained credit on failure; rate-limit/alt abuse; player-trust playtests; and mobile/controller purchase safety.
- Reasoning summary: A happy-path purchase test cannot prove that a permanent cross-player paid transfer is safe, fair, recoverable, or resistant to griefing and duplication.
- Result: Acceptance scope is defined before implementation. No test harness, code, metrics, analytics, policy confirmation, or Roblox Studio evidence exists.
- Test evidence: Read-only QA/Player Trust and Architecture/Data/Security reviews on 2026-07-19.
- Mistakes discovered: None in code; no code exists. The initial idea lacked explicit failure, receipt, policy, and player-trust behavior.
- Recommended future approach: Prove deterministic module invariants first, then closed same-server multiplayer tests, then an opt-in playtest measuring hide rate, theft concentration, exits, reports, and retaliation spending before launch approval.
- Confidence level: High
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Creature appraisal and disposition test requirements

- Date: 2026-07-19
- Agent: QA Agent with Data/Security review
- System affected: Creature persistence, valuation, favorites, sale, release, Leafnotes, journal, and transaction recovery
- Situation: Value-affecting creature mutation, size, and weight plus permanent sale/release actions introduce forgery, duplication, race, overflow, and accidental-loss risks.
- Decision made: Future acceptance coverage must include schema/save-load migration; mutation and numeric bounds; versioned valuation cases; wrong-owner and forged-value rejection; favorite enforcement; replay/idempotency; concurrent sale/sale and sale/release; disconnect and uncertain commit recovery; checked Leafnote arithmetic; zero-currency release; journal retention; economy simulation; multiplayer isolation; and device confirmation flows.
- Reasoning summary: A creature transaction is only correct when removal, payout, persistence, retry behavior, and user protection remain consistent under both ordinary and adversarial failure paths.
- Result: Regression requirements are recorded before implementation. No harness or test case is implemented.
- Test evidence: Economy and Data/Security design reviews on 2026-07-19; no executed game evidence.
- Mistakes discovered: None in code; no code exists. Generic economy test notes were insufficient for creature-specific terminal-state races.
- Recommended future approach: Build deterministic server-module tests first, then Studio integration tests with forced disconnect/duplicate scenarios and manual mobile/controller confirmation checks.
- Confidence level: High
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Knowledge entry: Phase 0 documentation validation

- Date: 2026-07-16
- Agent: Documentation Agent and QA reviewer
- System affected: Repository documentation and persistent agent memory
- Situation: The first durable project snapshot needed structural, encoding, schema, credential, and independent-review evidence before publication.
- Decision made: Validate every required memory path, require nonempty strict UTF-8 Markdown, parse the proposed dashboard JSON, scan tracked-scope files for credential patterns, and require an independent review pass.
- Reasoning summary: Documentation is the project's current product; broken structure or unsupported truth claims would damage future agent decisions even without game code.
- Result: All 19 shared and 14 personal memory files passed; dashboard JSON parsed; no credential-pattern matches were found; the independent reviewer returned `PASS` after fixes.
- Test evidence: Local Node.js validation commands, `rg` credential scan, Git status/ignore inspection, and `/root/documentation_review` final result.
- Mistakes discovered: The first dashboard contract left several records as non-validatable placeholders, and composite research scores were initially attributed too broadly.
- Recommended future approach: Keep documentation validators in the first dashboard/tooling slice and repeat the independent review at every major milestone.
- Confidence level: High
- Verification status: Code-reviewed
- Evidence class: Local automated checks and independent review

## 2026-07-21 hotbar-empty and held-rig regression evidence

- Date: 2026-07-21
- Agent: Codex / QA role
- System affected: Client hotbar, held-item presentation, R6 project configuration
- Situation: The regression crossed authoritative inventory projection, GUI input, character joints, locomotion, and a hidden place-level avatar setting.
- Decision made: Combine a fresh client click test with exact runtime joint/geometry checks and inspect the serialized Rojo place property.
- Reasoning summary: A screenshot alone cannot prove the empty slot is inert or the torso is stable, and a source property alone cannot prove the already-open place changed rig type.
- Result: `Test-Rojo.ps1` passed; all four server suites passed 58/58; zero-seed slot 1 rendered `EMPTY`, click feedback was correct, and no held model appeared; R15 and isolated R6 movement checks passed; the built place contains `GameSettingsAvatar = 0`.
- Test evidence: FarmDomain 40/40, FarmService 6/6, CreatureWorldService 5/5, ForageWorldService 7/7; R15 chain root `RightUpperArm`; R6 no-IK, hand-local `(1.50, 0.50, -1.50)`, upright torso/root after movement.
- Mistakes discovered: Rojo can serialize the hidden R6 setting but did not change the currently open place through live sync; a normal R6 spawn remains unverified until the one-time Studio setting is applied.
- Recommended future approach: After changing Avatar Settings to R6, restart play and repeat the normal-spawn equip/walk test without the temporary-rig harness.
- Confidence level: High within one-client desktop scope
- Verification status: Mixed: Verified hotbar/R15/build; Simulated R6 runtime; Requires Roblox Studio testing for normal R6 spawn
- Evidence class: Automated build/suites plus direct Studio GUI and runtime assertions

## 2026-07-21 exact placement and ordered-hotbar regression evidence

- Date: 2026-07-21
- Agent: Codex / QA role
- System affected: Mouse placement, schema v5 migration, seed use, harvest pickup, hotbar projection, and Rojo build
- Situation: The change crossed a Studio window inset, client raycasting, server canonicalization, persistent migration, and visible slot ordering.
- Decision made: Keep the failed coordinate attempt as a control, assert exact saved plot-local coordinates, run every fresh Server VM suite, and perform a live buy-place-buy slot reuse check.
- Result: `InputObject.Position` produced the wrong `(-19.750,-34.250)` plot-local result. The final shared-coordinate reticle/ray saved `(-20.000,-20.000)` exactly. The server accepted one plant and consumed the last seed. A later buy reused slot 1.
- Test evidence: FarmDomain 43/43, FarmService 6/6, CreatureWorldService 5/5, ForageWorldService 7/7, total 61/61; `scripts/Test-Rojo.ps1` PASS with Rojo 7.7.0 and a 225,076-byte build; green reticle capture; no workspace placement preview was created.
- Mistakes discovered: Passing a coordinate to a ray API without proving its inset convention can look nearly correct while committing a materially different location.
- Recommended future approach: Add touch/controller coordinate fixtures, screen-inset variants, edge-of-plot invalid cases, zoom/camera-angle cases, and a future creature-pickup ordered-slot case.
- Confidence level: High for one-client desktop and pure server logic
- Verification status: Verified within the listed scope; production persistence and real devices remain open
- Evidence class: Fresh automated Server VM suites, clean Rojo build, direct UI input, runtime inspection, and server snapshot comparison
