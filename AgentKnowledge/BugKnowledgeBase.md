# Bug Knowledge Base

## 2026-07-21 Hero-island migration false preflight failure

- Date: 2026-07-21
- Agent: Codex / Map Agent
- System affected: Live graybox migration
- Situation: The guarded migration expected 372 `LandTile_*` parts and refused because 182 verified land parts retained a historical `LandExpansion_*` prefix.
- Cause: Identity was inferred from names instead of the existing `GrayboxLand` semantic attribute.
- Why not detected earlier: The repository constructor did not reflect every historical live name even though aggregate counts and attributes were documented.
- Detection owner: Map/Architecture preflight; it correctly refused before mutation.
- Recurrence risk: Medium for any future live migration that assumes constructor-era names.
- Resolution: Select semantic-tagged land, assert exact count/class/size/anchoring/bounds, and clean failed-attempt metadata.
- Prevention mechanism: FA-013, semantic-tag migration pattern, exact 484-position validator, and guarded rollback.
- Test evidence: First call refused before visible mutation; retry added exactly 118 tagged parts and passed 2,456 checks.
- Confidence level: High
- Verification status: Verified resolved

## 2026-07-21 Player HUD hid the first hero-tree scale

- Date: 2026-07-21
- Agent: Codex / Map and UI roles
- System affected: Arrival/plot visual hierarchy
- Situation: The 180-stud first hero revision looked dominant in edit overview but remained heavily covered by the top navigation/tutorial panels in the live player camera.
- Cause: Scale review initially prioritized top-down composition over the active HUD camera.
- Why not detected earlier: The live HUD capture occurred after the first geometry pass.
- Detection owner: Map/UI visual acceptance.
- Recurrence risk: High for future landmarks, VFX, creatures, and event signage.
- Resolution: Increase the graybox tree to about 255 studs with a 204-stud-wide broad crown and recapture from Plot 1/event views.
- Prevention mechanism: Add real-HUD camera views to map/VFX/UI review checklists.
- Test evidence: Final staged client Plot 1 capture shows the crown above and beside the HUD; static canopy top is exactly 255.
- Confidence level: High for desktop
- Verification status: Verified resolved; devices remain open

## Bug: Fixed forage respawn creates a predictable macro coordinate

- Date: 2026-07-21
- Agent: Codex / Gameplay, Map, Security, and QA roles
- System affected: Seed foraging and anti-macro behavior
- Situation: The first forage design used durable per-player cooldowns but left the visible sprout at a fixed location.
- Decision made: On successful durable forage, relocate the stable node to a randomly selected different and unused spawn point. Do not move on rejection.
- Reasoning summary: Cooldowns limit frequency but do not remove deterministic coordinates; relocation changes the next required world interaction while preserving cooldown identity.
- Result: Live `wild-sprout-1` moved from `west-01` to `south-03`; a cooldown retry left it at `south-03`.
- Test evidence: Relocation unit boundaries and live Studio before/after positions.
- Mistakes discovered: The original requirement analysis treated cooldown as sufficient anti-macro behavior.
- Recommended future approach: Include “same location excluded,” “occupied locations excluded,” and “failure does not move” in every renewable-node regression suite.
- Confidence level: High
- Verification status: Verified

## BUG-004: Fresh-looking Edit tests use stale FarmContracts

- Date: 2026-07-21
- Agent: Codex / QA Agent
- Severity: Medium test-integrity
- System: Roblox Studio ModuleScript cache and Rojo-synced tests
- Reproduction: Require FarmContracts in Edit mode, synchronize a newer source, clone only `ServerScriptService.CatchACreature`, and run the clone's FarmDomain tests. The domain hard-requires the original ReplicatedStorage ModuleScript and receives the cached table; new action keys are nil.
- Suspected cause: `require` caching is keyed by ModuleScript instance, not current Source text.
- Fix attempt: Restart play and run the full suite in the fresh Server DataModel VM. All 30+4+5 current cases pass.
- Prevention mechanism: Final test checklist requires a fresh play-server VM after contract or dependency changes; compare expected case count as well as `ok=true`.
- Resolution: Test process corrected; no game-code rollback required.
- Status: Resolved
- Regression test: Fresh Server suite plus expected case counts
- Codex approval: Verified

## BUG-006: Placement marker did not match the cursor tip

- Date: 2026-07-21
- Agent: Codex / UI and QA roles
- System affected: Desktop plot placement, screen-to-world projection, and placement feedback
- Situation: The world-space placement bubble could appear away from the cursor, so the player could not confidently predict the final plant position.
- Cause: A 3D preview was trying to communicate a 2D pointer target, and one attempted fix mixed `InputObject.Position` with `Camera:ScreenPointToRay` while Studio applied a 58-pixel top inset.
- Why not detected earlier: Placement was first accepted by visual approximation rather than comparing the reticle coordinate, ray coordinate, and saved plot-local coordinate.
- Resolution: Remove the world preview entirely. Draw a fixed-size 2D reticle at `UserInputService:GetMouseLocation()` and use that exact same coordinate for the desktop screen ray. Keep server plot and distance validation authoritative.
- Prevention mechanism: Any pointer placement test must compare the displayed reticle center with the coordinate passed to `ScreenPointToRay`, then verify the server-canonical saved transform.
- Test evidence: A staged reticle centered at screen `(400,300)` used the inset-aware pointer `(400,358)` for the ray and saved plot-local `(-20.000,-20.000)` exactly. The reticle was green, the plant count increased to one, and the seed stack was consumed. The rejected `InputObject.Position` attempt saved `(-19.750,-34.250)` and is retained as regression evidence.
- Confidence level: High for one-client desktop mouse placement
- Status: Verified; touch/controller and real-device insets still require testing
- Codex approval: Approved within the stated boundary

## BUG-007: Fixed seed reservations skipped the next visible hotbar slot

- Date: 2026-07-21
- Agent: Codex / Data, Gameplay, and QA roles
- System affected: Persistent hotbar schema, seed acquisition, harvest pickup, migration, and UI projection
- Situation: Reserved seed definitions occupied logical slots even at zero quantity, making later pickups appear in higher numbered slots instead of the first visible empty slot.
- Cause: Schema v4 treated content categories as permanent slot ownership rather than saving only actual player-owned references.
- Why not detected earlier: Earlier tests checked whether exact item IDs survived, but did not assert the player's visible lowest-free-slot expectation.
- Resolution: Schema v5 stores only real seed stacks and item references. Buy, forage, harvest, and inventory reassignment scan slots 1 through 10 in order; an exhausted seed reference is removed; existing valid manual item positions are preserved during migration and later pickups.
- Prevention mechanism: Regression cases assert slot 1 occupied means next pickup uses slot 2, and an item manually retained in slot 6 is not compacted while the next pickup uses slot 1.
- Test evidence: Fresh Server VM passed FarmDomain 43/43, FarmService 6/6, CreatureWorldService 5/5, and ForageWorldService 7/7 (61/61). A live second Sunspud purchase after consuming slot 1 rendered `1 / SUNSPUD / SEED x1` while slots 2-10 stayed empty.
- Confidence level: High for current seed and harvested-plant paths
- Status: Verified; future creature pickup must reuse and separately test the same allocator
- Codex approval: Approved within one-client and automated-suite boundaries

## BUG-005: Zero-count seed looked owned and torso IK fought walking

- Date: 2026-07-21
- Agent: Codex / UI and QA roles
- Severity: High usability
- System: Numbered hotbar and held-item character presentation
- Reproduction: Join with zero Sunspud seeds; slot 1 rendered `SUNSPUD SEED x0`, but activation correctly failed with a purchase message. On R15, the held-item IK chain included the upper torso and could fight locomotion while walking.
- Suspected cause: Fixed seed slots were projected into the hotbar even when quantity was zero, and the IK solver was allowed to move the torso for a hand-only presentation.
- Fix attempt: Omit zero-quantity seed assignments so reserved slots use the normal `EMPTY` state; restrict the R15 IK chain to `RightUpperArm`; add an R6-only `Right Shoulder` pose that runs after animation and never controls the torso.
- Prevention mechanism: Zero-owned-quantity UI/click regression, chain-root assertion, R6 no-IK assertion, forward-hand geometry check, and movement/upright checks.
- Resolution: A fresh Studio client showed `1\nEMPTY`; clicking it reported `That hotbar slot is empty.` and created no held model. R15 movement kept `UpperTorso.UpVector.Y = 0.9992`. An isolated R6 rig kept its hand at torso-local `(1.50, 0.50, -1.50)`, retained the held seed after movement, used no IKControl, and kept torso/root upright.
- Status: Verified for zero-count UI and R15 desktop behavior; R6 pose is Simulated in an isolated Studio R6 character pending the place-level Avatar Settings toggle.
- Regression test: Fresh client UI interaction plus R15/R6 runtime geometry and movement assertions
- Codex approval: Code-reviewed and runtime-tested within the stated boundaries

## BUG-003: Shop/Sell travel lands at roof height

- Date: 2026-07-21
- Agent: Codex / Gameplay Agent / Map Agent / QA Agent
- Severity: High usability
- System: Caretaker Hub fast travel and service access
- Reproduction: Use the top Shop or Sell button. The initial implementation targeted the kiosk part center plus a vertical offset; later model-pivot placement and rotated-cylinder thickness assumptions also produced root Y values around 75-86 while kiosk roof Y was 56.
- Suspected cause: A kiosk is not an arrival pad, character model pivots can have offsets, and the Courtyard cylinder's thin axis is not its Y dimension after rotation.
- Fix attempt: Compute a 13-stud horizontal approach toward the hub interior, derive ground from the cylinder's minimum dimension, set HumanoidRootPart directly to Y 48, zero velocity, and face the kiosk. Add one nearby ProximityPrompt per Shop/Sell kiosk so opening a service does not require travel.
- Prevention mechanism: Assert root landing position, roof separation, horizontal approach distance, prompt count/properties, and collision/ground safety whenever hub geometry changes.
- Resolution: Both Shop and Sell landed at Y 48, 13 studs in front, below roof Y 56; one visible prompt exists per kiosk.
- Status: Resolved for the current graybox; physical prompt activation and final-geometry safe-ground fallback remain manual/future tests
- Regression test: Live coordinate assertions plus prompt count/property inspection
- Codex approval: Verified for current fast-travel landing; prompt activation Code-reviewed

## BUG-002: Duplicate startup loads orphan a valid profile session

- Date: 2026-07-21
- Agent: Codex / Data Agent / QA Agent
- Severity: High
- System: Player profile loading and session leases
- Reproduction: Start a Studio play session while `PlayerAdded` and the startup `GetPlayers()` sweep both schedule `_loadPlayer` for the same player. The first load acquires the lease; the second generates another token, reports `SESSION_BUSY`, and overwrites the repository's valid in-memory session with a non-writable entry.
- Suspected cause: No per-player in-flight load guard around the two legitimate startup paths.
- Fix attempt: Added `_loading[player]` serialization with cleanup on success, failure, plot failure, and removal.
- Prevention mechanism: Keep the load guard; add a future mocked concurrency test that calls `_loadPlayer` twice and asserts one repository load, one writable session, and no orphaned lease.
- Resolution: The same isolated fixture subsequently loaded and saved successfully without `SESSION_BUSY`.
- Status: Resolved in ordinary Studio startup; mocked concurrency regression still required
- Regression test: Live isolated Studio rejoin plus future service-level duplicate-load unit test
- Codex approval: Verified for the reproduced Studio race

## BUG-001: Sparse numeric hotbar keys lose slot 10 in DataStore

- Date: 2026-07-21
- Agent: Codex / Data Agent / QA Agent
- Severity: High
- System: Profile schema, hotbar persistence, DataStore serialization
- Reproduction: Save a hotbar table with numeric keys `1`, `2`, and `10`; the DataStore readback retains the contiguous early entries but drops sparse slot `10`.
- Suspected cause: Roblox serialization interprets numeric-key tables as arrays; a sparse tail is not a safe durable dictionary representation.
- Fix attempt: Advanced the schema to v2, stored hotbar slots as canonical string keys, migrated v1 numeric keys, and updated domain/snapshot/client consumers.
- Prevention mechanism: The 13-case suite includes `migrate-sparse-hotbar-string-keys`, and the isolated DataStore test verified exact slot-2 and slot-10 item IDs and weights across leave/rejoin.
- Resolution: Schema-v2 readback and rejoin retained both slots.
- Status: Resolved
- Regression test: Schema migration case plus isolated DataStore slot-2/slot-10 rejoin
- Codex approval: Verified

## Tooling incident: GitHub authentication validation

- Date: 2026-07-16
- Agent: Codex
- Severity: Medium tooling blocker
- System: GitHub publishing
- Reproduction: Complete GitHub CLI device authorization successfully, then run `gh auth status`; the token is reported invalid and `gh api user` receives an unexpected HTML response.
- Suspected cause: Credential/keyring or environment-specific GitHub CLI authentication behavior; direct GitHub API and Git transport endpoints are reachable.
- Fix attempt: Clean logout, fresh device codes, explicit repository scope, and endpoint checks.
- Prevention mechanism: Keep portable tooling ignored; verify authentication before staging; retain Git Credential Manager as the secure Git-transport fallback; never expose or persist tokens manually.
- Resolution: Reauthenticated through GitHub's device flow on 2026-07-18, verified the authenticated account with `gh auth status`, changed the repository to public after explicit informed approval, and verified `visibility: PUBLIC` with `gh repo view`.
- Status: Resolved
- Regression test: `gh auth status`, authenticated identity query, and read-only remote check before future publish workflows
- Codex approval: Verified
