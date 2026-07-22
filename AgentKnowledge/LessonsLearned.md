# Lessons Learned

## 2026-07-21 Memory Tree hero-center retrospective

- Date: 2026-07-21
- Agent: Codex / Map, Architecture, Gameplay, UI, Performance, and QA roles
- System affected: Map hierarchy, migration safety, player cameras, runtime dependencies, foraging, and evidence
- Situation: The user elevated the Memory Tree from central venue to the game's primary visual selling point.
- Decision made: Treat the revision as one reversible dependency-set change, then validate source, exact geometry, authored routes, HUD composition, gameplay regressions, forage projection, boundary collision, and logs.
- Reasoning summary: Landmark impact, route integrity, and runtime safety are inseparable when the central footprint changes.
- Result: The 1040×1080 graybox, 184-stud event island, and 255-stud tree are verified for Edit structure and one-client desktop traversal. Held/equip/selling work from the same milestone also remains regression-green.
- Test evidence: 2,456 static checks, 58 gameplay tests, 18/18 forage points, six live nodes, controlled traversal, wall stop, screenshots, empty final logs, Rojo PASS.
- Mistakes discovered: Historical names were mistaken for semantic identity; one validator constant was omitted; the first 180-stud tree was still HUD-occluded; free-form navigation chose the pond and had to be separated from authored-route evidence.
- Recommended future approach: Use semantic tags, run the repository validator after every edit, capture with the real HUD early, test routes by authored waypoints, and retain truthful device/crowd/performance gates.
- Confidence level: High for scoped evidence
- Verification status: Verified

- What worked: Guard refusal, non-Terrain mutation, exact validation, fresh-VM regression, and camera-driven scale iteration.
- What caused delay: Live/history name drift and a test-only missing constant.
- Bugs prevented: Destructive rebuild, pond/bridge separation, plot/trail overlap, invalid forage ground, stale gameplay regression, and false visual approval.
- Missing tests: Independent review, rollback execution on a safe clone, multiplayer crowding, streaming, final-density performance, and real devices.
- Next phase change: Keep the hero-center geometry stable while replacing the tree with production art in bounded stages and begin the next gameplay slice only after user visual feedback.

## Lesson: Persist identity, randomize projection, celebrate only after commit

- Date: 2026-07-21
- Agent: Codex
- System affected: Forage rewards, cooldowns, world projection, and rare VFX
- Situation: One collectible interaction needed durable anti-repeat state, unpredictable world placement, and a dramatic rare outcome.
- Decision made: Keep the logical node ID stable in persistence, move only its visual spawn point, and order work as validate/select/commit, relocate, then present.
- Reasoning summary: Persistence should follow gameplay identity rather than coordinates; optional world/VFX consequences must not run before valuable state is durable.
- Result: One node can move across map regions while the same player's cooldown follows it, and presentation cannot create or imply an unsaved reward.
- Test evidence: 54 automated cases plus live success, relocation, cooldown rejection, and simulated Mythic capture.
- Mistakes discovered: Cooldown-only reasoning overlooked predictable-coordinate automation.
- Recommended future approach: Apply the same identity/projection separation to future pickups, event objects, and visitors, with system-specific contention tests.
- Confidence level: High
- Verification status: Verified for current forage slice

## 2026-07-21 Hearthpetal/Cozzle slice lesson

- Date: 2026-07-21
- Agent: Codex / Gameplay, Data, Architecture, UI, Enemy AI, Security, Performance, and QA roles
- System affected: Multi-definition farming, schema migration, hotbar, visitor projection, testing, and visual evidence
- Situation: Extending the proven Sunspud loop exposed that a “small” second seed affects durable slots, labels, placement bounds, values, tests, and world services.
- Decision made: Generalize the transaction once, migrate references without mutating items, and keep the first creature as a derived wild projection outside ownership.
- Reasoning summary: Copy-pasting a second crop would multiply hard-coded bugs, while implementing capture simultaneously would mix visual success with valuable durable state.
- Result: Hearthpetal and one Cozzle work through bounded definitions/services with 39 automated cases across the three suites and live Studio evidence.
- Test evidence: 30/30 + 4/4 + 5/5, clean play console, live 60-second growth/arrival, projection cleanup fixture, and Rojo PASS.
- Mistakes discovered: Edit `require` caching invalidated a seemingly fresh test; camera-aligned spawn placement harmed readability.
- Recommended future approach: Use a fresh play VM for final tests and include visual sightline checks whenever an arrival model and two billboards share a small plot.
- Confidence level: High
- Verification status: Verified for the scoped slice

## 2026-07-21 Persistence and offline-growth lesson

- Date: 2026-07-21
- Agent: Codex / Data, Architecture, Security, QA, UI, and Gameplay Agents
- System affected: Persistent economy, item identity, hotbar, planted world state, offline time, and session ownership
- Situation: The playable loop made it clear that money, crops, and equipped slots are one continuity promise, not separate UI features.
- Decision made: Persist the canonical profile and derive every world/UI projection from it. Save absolute server timestamps once, exact item IDs in hotbar slots, and unique per-load lease tokens; freeze on unknown commit outcomes.
- Reasoning summary: Persisting only currency or Backpack contents would still make returning players lose the arrangement and visible farm they recognize.
- Result: The first slice now carries all required fields and testable transitions, while real DataStore behavior remains truthfully unverified.
- Test evidence: Independent review, pure schema/domain tests, Rojo build, and live Studio memory-mode startup.
- Mistakes discovered: Equal-revision acceptance is not proof that the same mutation was saved; a job-wide token is not a player-load lease; shallow validation is unsafe for valuable nested items; client-only hotbar ordering does not survive rejoin.
- Recommended future approach: Make persistent-state reviews include money, identity, location, timestamps, UI references, ambiguous outcomes, lease generations, corruption, migration, and rejoin evidence as one checklist.
- Confidence level: High
- Verification status: Code-reviewed and Simulated

Follow-up (2026-07-21): A real isolated Studio DataStore test replaced the prior simulated-only evidence for the scoped one-user path. Exact 100,000-Leafnote rejoin, seeds, item weights/IDs, slots 2 and 10, plotted timestamps/coordinates, offline maturity, world reconstruction, and idempotent replay passed. The test also showed that sparse numeric keys are not a durable hotbar representation and that startup paths need an in-flight player-load guard. A bounded lease is recovery, not proof that every Studio shutdown released cleanly; one final shutdown retained its lease and was fingerprint-cleaned from the isolated key. Future persistence tests should disable incidental player input, use authoritative `UpdateAsync` observations instead of trusting a potentially cached `GetAsync`, and preserve the distinction between isolated Studio verification and production/fault/multiserver evidence.


## 2026-07-21 Rojo connection repair

- Date: 2026-07-21
- Agent: Codex / Architecture and QA Agents
- System affected: Development workflow, source authority, Studio synchronization, and process launch
- Situation: Studio had a working Rojo plugin but no project mapping or server to contact.
- Decision made: Establish one selective namespaced mapping, keep `Workspace` out of Rojo, validate the project before serving, and verify both live propagation and graybox preservation.
- Reasoning summary: Source linkage is a safety boundary, not merely a convenience; proving the intended files appear is only half the test unless pre-existing place content is also shown unchanged.
- Result: The repository and Studio are connected through Rojo 7.7.0. Phase 3A can now proceed repository-first.
- Test evidence: Pinned-version, authorized-place, sourcemap freshness, temporary place build, HTTP, cross-command process persistence, server restart/reconnect, Studio hierarchy/source, live edit/revert, and graybox-count checks all passed; the reusable repository test reports PASS.
- Mistakes discovered: Plugin installation was mistaken for a complete connection path; no `default.project.json` or server existed. Sandboxed detached children did not persist, and duplicate environment-key casing broke `Start-Process` with redirected output.
- Recommended future approach: Diagnose Rojo in the order `project file -> binary -> server process -> listening port -> plugin -> mapped instances -> live edit -> preservation regression`.
- Confidence level: High
- Verification status: Verified

## 2026-07-20 Phase 2 graybox retrospective

- Date: 2026-07-20
- Agent: Codex / Map, QA, and Performance Agents
- System affected: Studio construction, map validation, reference-image use, evidence, and rollback
- Situation: The project moved from design-only map decisions to its first live Studio world shell.
- Decision made: Build the complete island circulation shell, but keep every gameplay surface nonfunctional and labeled; combine reference images, numeric dimensions, direct Studio assertions, R15 traversal, and scoped performance evidence.
- Reasoning summary: The whole island was needed to test the central event venue and eight-plot flow, while a reversible graybox kept the phase from turning into premature final production.
- Result: Phase 2 graybox v1 is built and verified for edit structure and one-client desktop movement. Five approved reference images are attached as named metadata. No Phase 3 gameplay, final art, publishing, or destructive rollback occurred.
- Test evidence: 104/104 edit checks, passed spawn/land/swim/exit/under-bridge/arrival-pad tests, empty console, and one SceneAnalysisService baseline.
- Mistakes discovered: Shell command wrappers must never be forwarded as source; large parallel screenshot batches are less reliable than sequential captures; generated counts must be updated after all metadata children exist; radial paths can miss cardinal fence openings; visual inspection can miss a two-stud gate-width error; Terrain rollback must refuse later voxel changes; truth labels must remain one exact allowed value.
- Recommended future approach: Keep source and rollback paired, derive connected geometry from shared definitions, assert exact contract dimensions, capture one viewport at a time, make destructive tooling fail closed, scope every Verified label, and require multiplayer/device evidence before art replacement or functional gate/plot work.
- Confidence level: High
- Verification status: Verified

Milestone answers:

- Completed: Reversible island shell, eight plots, gate axis, pond/bridges/swim exits, event island, Hub, meadows, outer landscape, reference traceability, and first map test evidence.
- Worked well: Written dimensions plus approved concept images; exact edit assertions paired with humanoid traversal; one-root rollback boundary.
- Delays: One source-wrapper parse failure and one screenshot timeout, neither of which changed or damaged the place.
- Bugs occurred: Stale generated-count metadata, eight path/fence alignment mismatches, a 22-stud gate opening against a 24-stud contract, unsafe unconditional Terrain clearing in rollback, and one composite truth label. Independent review found them; source and Studio geometry were corrected and regression-tested.
- Bugs prevented: Overwriting existing Studio content, clearing user-edited Terrain, confusing placeholders with functional gameplay, blocked plot arrival pads, narrow bridges, root-blocked event circulation, and unsupported performance claims.
- Agents needing support: Map/QA still need multi-client and real-device evidence; Performance still needs frame-time/memory/network measurements under representative density.
- Helpful architecture: Additive namespaced root, Terrain-region record, spawn rollback record, and exact visual/dimension authority metadata.
- Missing tests: Eight-player crowding, mobile/tablet/controller, functional gate/plot ownership, ocean return, streaming re-entry, final assets, and production persistence.
- Automate next: Repository-owned graybox validator after source linkage and repeatable evidence export for the command center.
- Change next phase: Review the graybox visually with the user, then authorize only a small Phase 3 vertical-slice scaffold if the scale feels right.

Follow-up (2026-07-20): The user rejected visible gray beyond the ocean. The first 800×904 envelope and an intermediate 2048×2048 correction did not cover the widest top-down review camera. A preflighted 4096×4096 Terrain ocean now fills that view, with all 4,194,304 voxels verified as generated Water. Future environment envelopes must be accepted against gameplay, overview, and promotional cameras rather than normal player distance alone.

Follow-up (2026-07-20): Scaling is relational. Enlarging the island while keeping 72×72 plots made the playable content feel undersized; enlarging plots at their old centers then crowded shared spaces; widening the mount trail at its first radii touched four plots. The stable result came from moving the 96×96 plot ring outward, relocating reserves into unused outer gaps, and moving the trail outward before re-running exact overlaps and humanoid traversal. Future footprint changes must trigger a complete dependency/clearance pass.

## 2026-07-20 Launch-scope and event-center amendment lesson

- Date: 2026-07-20
- Agent: Codex with Architecture, Data, Security, Game Design, Monetization, Map, and QA Agents
- System affected: Map, launch scope, ownership, monetization, policy, testing, and project memory
- Situation: The user clarified the island's join/social/water/event flow and moved paid stealing from a later update into the initial public-release target.
- Decision made: Record the map brief and explicitly supersede the old release-order statement. Keep the internal first playable theft-free, implement paid transfer last, keep it feature-flagged off, and block public launch until every hard gate passes. Preserve ordinary plot visits as read-only and exact steals as a separate server-authoritative transaction.
- Reasoning summary: A release target must not silently reorder technical dependencies or erase previous risk findings. Separating launch intent, implementation order, and verification status preserves user direction without fabricating readiness.
- Result: Current project context, research, architecture, map patterns, risks, testing, design knowledge, agent memories, goals, and scores were updated. No Studio content or gameplay code was changed.
- Test evidence: Direct user decisions, repository recall, current blank Studio inspection earlier in the session, approved concept review, three independent specialist reviews, and documentation checks. No gameplay/runtime evidence exists.
- Mistakes discovered: The earlier design treated the Memory Tree mainly as a landmark rather than a measured gathering venue. The phrase “initial release” could be mistaken for immediate implementation permission. Donation and post-death behavior remain unresolved details rather than blockers for the dimensioned map.
- Recommended future approach: Maintain explicit supersession notes; dimension and test the island before art production; build ordinary item ownership before any paid cross-profile transfer; require policy confirmation and closed multiplayer stop metrics before enabling theft.
- Confidence level: High for the recorded decisions and sequencing; Low for runtime, policy, and player-trust outcomes until tested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## 2026-07-19 Deliberate failure choice and post-commit celebration lesson

- Date: 2026-07-19
- Agent: Codex with Game Design, Gameplay, Architecture, Data, Security, Monetization, UI, VFX, Audio, Performance, Enemy AI, QA, and Documentation Agents
- System affected: Capture items, Familiarity, round-robin, Retry/Let Go, ownership, cutscene, VFX/audio, accessibility, performance, testing, and documentation
- Situation: The user approved the remaining capture cost/progress/fairness choices, required Retry/Let Go after failure, and asked for a cutscene/VFX on super-rare success.
- Decision made: Record every accepted-attempt Tag/selected-aid cost, +2-point player × stable creature-definition ID × tier Familiarity, 2/3/5/8/15/25 guarantees, persistence/reset, and distinct-contender round-robin as approved. Retry is a fresh deliberate one-intent decision and defaults to No Aid; Luck is disabled on guaranteed attempts. Let Go is personal abandonment that preserves Familiarity/visitor state and, during caretaker priority, preserves the remaining exclusive window; `Open to Everyone` stays separate. Require durable exact-one ownership before an idempotent cosmetic event. Treat Mythic as the approved super-rare tier with the approved roughly five-second local/immediately skippable Haven Tag/leaf-constellation/trait-mote/acceptance-mark/journal sequence, bounded nearby flourish, Full/Short/Off/Reduced Motion settings, and a shorter Legendary flourish. Exact audio remains provisional.
- Reasoning summary: The result, next decision, and cosmetic feedback are three different phases. Keeping them separate prevents accidental spending, queue bypass, global visitor mutation, false ownership, and presentation failures from corrupting gameplay state.
- Result: The complete decision batch, including tier/visual/aid/priority choices, is synchronized across design, architecture, security, testing, presentation, performance, risk, research, feedback, and personal memory. Exact Luck formula/recipes, audio, technical expiry grace, production assets, and measured budgets remain unresolved. No gameplay or assets were created.
- Test evidence: Direct stakeholder decisions and independent Security/Architecture, QA/UI, and VFX/Audio/Performance read-only reviews on 2026-07-19; approved base/+2/hard-guarantee table sanity check passed; `git diff --check` passed aside from benign LF-to-CRLF notices; strict UTF-8/nonempty/NUL/final-newline checks passed for all 39 changed files; targeted capture-decision/stable-key/presentation-boundary/active-status consistency passed. The final-approval audit initially found stale Phase 0 wording, an over-specific nearby-effect duration, and one stale VFX-memory label; all were corrected and the independent recheck returned PASS. No Luau, schema, RNG, multiplayer, Studio, device, asset, audio, accessibility, performance, or player evidence exists.
- Mistakes discovered: Stale files still called three resolved decisions provisional. `Let Go` can sound like a global release unless its personal scope is explicit. A rare cinematic can be mistakenly treated as harmless polish even though camera/input/cleanup failures affect play.
- Recommended future approach: After every high-impact answer batch, search all unresolved/status language, update personal memories and improvement goals, and add regression tests at the transaction-to-presentation boundary. Never let a client animation become evidence of ownership.
- Confidence level: High for approved mechanics, presentation direction, and separation pattern; Low for runtime balance/budgets until implemented and tested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff

- What changed: Failure cost/Familiarity/fairness are locked; failure now requires Retry/Let Go; qualifying success requires post-commit celebration.
- Why it changed: The user wants rapid but deliberate retries, an opt-out, and a memorable rare capture.
- APIs affected: Future attempt result, decision token, queue intent, Familiarity record, item transaction, owned-creature commit, celebration descriptor, UI/camera/VFX/audio/cleanup/metrics; none exists.
- Files affected: Shared knowledge, personal memories, research direction/start plan/art direction, risk, README, and testing requirements.
- New requirements: Exact-once cost/progress; fair queue; personal Let Go; ownership-before-celebration; event dedupe; immediate skip; reduced motion; no forced observer camera; hard cleanup.
- Risks: Decision replay, held-input extra spending, ambiguous priority, false success, duplicated effects, camera lock, photosensitivity, audio fatigue, and unmeasured mobile load.
- Tests required: Golden guarantees, transaction faults, decision races, eight-player queue, expiry/disconnect, outcome/event replay, skip/settings/camera restoration, effect/audio cleanup, and device performance.
- Action required: No further user choice is required for this capture decision batch. Agents implement only after the current Phase 1 authorization expands to gameplay; exact Luck formula/recipes, audio, technical expiry grace, and measured budgets remain later work.

## 2026-07-19 Immediate retry without overlapping attempts lesson

> Follow-up (2026-07-19): The newer lesson above records the user's subsequent approval of failure consumption, exact Familiarity, public round-robin, Retry/Let Go, and rare-celebration requirement. The unresolved list below is historical.

- Date: 2026-07-19
- Agent: Codex with Game Design, Gameplay, Architecture, Data, Security, Monetization, UI, Performance, Enemy AI, QA, and Documentation Agents
- System affected: Capture pacing, RNG, Familiarity, consumables, contention, persistence, UI, economy, and performance
- Situation: The user approved the recommended capture package but rejected a post-failure cooldown, requiring immediate retry and a slightly higher chance after each valid failure.
- Decision made: Remove the gameplay cooldown while preserving one authoritative attempt at a time. Record the flow, priority, tutorial guarantee, capture table, Haven Tag, Familiarity/hard-guarantee direction, five-minute public lifetime, proximity, fixed traits, free Luck boundary, and starting caps as approved. Keep failed-roll item consumption, exact Familiarity table/reset/bucket, and public retry ordering provisional because the amended bundled item does not resolve them.
- Reasoning summary: Fast pacing and safe transactions are not opposites. The UI can re-enable immediately after the durable result while tokens, idempotency, capacity checks, and one-in-flight state prevent overlapping economic/RNG mutations. Clause-level approval parsing avoids silently treating an amended item as approval of every bundled subclause.
- Result: The active design has no post-failure capture cooldown. Immediate retry, rising persistent progress, approved balance table, original expression, fairness window, lifetime, trait retention, and caps are synchronized. Three precise decisions remain for the user. No implementation or test exists.
- Test evidence: Direct user approval; two independent read-only reviews; targeted approved-versus-provisional consistency PASS; `git diff --check` PASS aside from benign line-ending warnings; strict UTF-8/nonempty/final-newline PASS across all 34 changed Markdown files; and final independent documentation audit PASS after four wording/completeness findings were corrected. No simulation, Luau, multiplayer, persistence, economy, device, performance, player, or Studio evidence exists.
- Mistakes discovered: The first recommendation bundled item consumption, creature retention, and cooldown in one numbered clause, making the user's “except #4” ambiguous for consumption. A visible cooldown had also been doing hidden abuse-control work that must now be replaced explicitly with serialization rather than another timer.
- Recommended future approach: Keep decision questions atomic; distinguish player-facing pacing from server transport controls; treat accepted outcomes and rejected traffic differently; and require probability/economy/contention simulations after the three remaining values are locked.
- Confidence level: High for the approved pacing and process lesson; Medium for technical fairness; Low for exact economy until the remaining choices are approved and tested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff

- What changed: No capture failure cooldown; immediate post-result retry with slightly higher persistent Familiarity. The rest of the recommended package is approved.
- Why it changed: The user wants rapid repeated attempts without dead time.
- APIs affected: Future attempt token/request/result, Familiarity, preview, pending intent, item transaction, visitor timer, and metrics; none exists.
- Files affected: Design, architecture, testing, security, risk, feedback, UI, AI, performance, monetization, scores, improvement goals, and memories.
- New requirements: One in-flight roll, no auto-repeat, immediate re-enable, exact next odds, durable one-step progress, five-minute hard deadline, fixed traits, no rejected-request work, and no hidden cooldown.
- Risks: Spam, latency monopoly, duplicate outcomes, unclear Tag cost, cross-tier pity farming, persistence/VFX load, and starvation.
- Tests required: Retry/idempotency, consumption/progress atomicity, guarantee math, persistence/reset, contention/expiry, economy, bot/latency, accessibility, and performance.
- Action required: User answers the three remaining questions; agents then define and simulate the final contract before any gameplay implementation.

## 2026-07-19 Wild-until-caught ownership amendment lesson

- Date: 2026-07-19
- Agent: Codex with Game Design, Gameplay, Architecture, Data, Security, Monetization, UI, Performance, Enemy AI, QA, and Documentation Agents
- System affected: Visitor interaction, capture, rarity, storage, ownership, competition, economy, originality, monetization, and testing
- Situation: The user added an original chance-based capture mechanic and clarified that a plot-spawned visitor remains available to anyone until successfully caught, including when the first player lacks storage.
- Decision made: Record the public-wild/full-storage rules immediately, explicitly flag the conflict with deterministic correct-Care ownership, and keep the exact hybrid, percentages, priority, failure, pity, and luck formulas provisional. Require one atomic server winner, separate arrival from capture odds, original non-ball expression, exact odds disclosure, and a free-only capture/luck material path.
- Reasoning summary: A high-impact gameplay amendment cannot be layered over an incompatible ownership rule. Separating user-approved outcomes from code-reviewed proposals lets development continue without fabricating balance approval.
- Result: Shared and personal knowledge now distinguish `Wild` from `Owned`, full-storage wild capture from existing-owned recall, and arrival rarity from capture difficulty. Five +200 purchases/1,200 total, favorite-blocked Sell Held, and one-at-a-time tree collection/full retention are recorded as approved. The remaining capture questions are ready for explicit user selection. No gameplay, asset, product, or Studio content was created.
- Test evidence: Direct user input; two independent specialist reviews; analytical probability checks; strict UTF-8/NUL PASS; targeted approved-versus-provisional consistency PASS; `git diff --check` PASS aside from benign line-ending warnings; and final independent documentation audit PASS after three wording findings were corrected. No simulation, Luau, multiplayer, economy, performance, device, player, or Studio test exists.
- Mistakes discovered: Earlier documentation made correct Care and full-capacity bonding terminal ownership states. The new mechanic invalidates both assumptions. Treating the example 0.01% as a catch rate without clarification would silently approve an average 10,000-attempt loop.
- Recommended future approach: For every probability feature, name each random stage, disclose actual odds, simulate effective acquisition time, and record the ownership commit point. When an amendment conflicts with a locked design, preserve the history but add an explicit supersession rather than silently editing the old decision.
- Confidence level: High for the ownership and process lesson; Medium for the hybrid proposal; Low for balance until user decisions and tests
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff

- What changed: Wild visitors are unowned until one successful capture; full storage performs no roll/consumption and leaves the visitor public. Storage ceiling, Sell Held protection, and tree collection are also resolved.
- Why it changed: The user wants competitive collection and an original rarity-based catch moment.
- APIs affected: Future encounter definitions/state, personal eligibility, capture preview/request, storage reservation, consumables, RNG audit, ownership commit, UI, roaming, and later paid-theft filtering; none exists.
- Files affected: Shared knowledge, personal memories, research direction/start plan/monetization/sources, tests, risks, scores, and improvement goals.
- New requirements: Exact-one server winner, no client odds/ownership, distinct arrival/capture fields, free-only chance inputs, original expression, truthful proposal labels, and no pressure upsell.
- Risks: Camping, latency/bot advantage, ultra-low odds, capture-item grind, full-storage pressure, duplicate owners, paid-random contamination, copied expression, and runtime multiplicity.
- Tests required: State/property tests, probability simulation, contention/fault injection, economy, provenance, device/accessibility, originality, and crowded-server performance.
- Action required: User resolves the remaining interaction/balance choices; technical design and executable tests follow before any gameplay implementation gate.

## 2026-07-19 Repeatable storage product and finite-delivery lesson

- Date: 2026-07-19
- Agent: Codex with Game Design, Monetization, Architecture, Data, Security, UI, Performance, QA, and Documentation Agents
- System affected: Storage monetization, receipts, persistence, stacking, deployed assets, later theft, performance, and truthful product communication
- Situation: The user requested repeated permanent +200 storage purchases with no purchase limit after first approving a one-time game pass.
- Decision made: Correct the product type to Developer Product; grant through idempotent durable `ProcessReceipt`; reject literal infinite capacity as an implementable promise; require a published tested operational maximum plus emergency receipt headroom; preserve the approved 999 stacks, unique assets, deployed-slot rules, full-asset retention, free favorite/lock, and no later storage grace.
- Reasoning summary: A monetization request can be conceptually valid while its named platform primitive and requested scale are impossible. Codex must preserve the intent—repeatable permanent expansion—without selling a benefit finite systems cannot guarantee.
- Result: Architecture, product, safety, and test contracts are synchronized. Follow-up: the user approved five purchases/1,200 total as the launch operational maximum; it remains unmeasured and no Developer Product exists or Robux was spent.
- Test evidence: Direct user answers; current official Roblox Developer Product, monetization, and Data Store limits documentation; two independent specialist reviews; strict UTF-8 PASS; `git diff --check` PASS aside from line-ending notices; targeted stale-contract searches; and independent final documentation review PASS after four findings were corrected. No receipt, persistence, performance, economy, device, multiplayer, or Studio gameplay test exists.
- Mistakes discovered: The prior one-time pass design did not match repeatable intent. Taking “infinite” literally would ignore finite platform and mobile limits and could create an undeliverable paid receipt.
- Recommended future approach: Validate product semantics against current official documentation as soon as purchase frequency changes; define durable receipt and recovery invariants; measure every proposed capacity tier; disclose the current maximum; reserve headroom; and refuse launch claims that cannot be proven.
- Confidence level: High for the platform/product correction and approved ceiling decision; Medium for delivery until measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff

- What changed: Storage monetization moves from one-time pass ownership to repeatable Developer Product receipts under a finite ceiling.
- Why it changed: The user requested repeat purchases; Roblox product semantics and finite infrastructure require the correction.
- APIs affected: Future `MarketplaceService.ProcessReceipt`, receipt ledger, inventory page manifest, capacity counter, and store UI; none exists.
- Files affected: Game design, architecture, monetization, testing, risk, failed approaches, source list, project context, memories, and scores.
- New requirements: Exactly-once +200 grant, no client grant, durable acknowledgment, finite maximum/headroom, external sales off, no pressure prompt, and no item deletion.
- Risks: Receipt loss/duplication, unsupported paid capacity, data/UI scaling, payer advantage, and minor spending concentration.
- Tests required: Receipt faults/races, every capacity tier, paged UI/batch operations, economy/fairness, mobile performance, and cap disclosure.
- Action required: Technical agents measure the approved 1,200-slot tier and emergency headroom before a live product exists; ADR-009 now governs full-storage wild capture, so no stranded-new-owner lock is created.

## 2026-07-19 Storage capacity and permanent-pass lesson

> Follow-up (2026-07-19): The repeatable Developer Product entry above supersedes this checkpoint's one-time pass mechanism. Its base-capacity and no-loss rules remain active.

- Date: 2026-07-19
- Agent: Codex with Game Design, Gameplay, UI, Architecture, Data, Security, Monetization, Performance, and QA Agents
- System affected: Inventory, harvests, seeds, creatures, mobile UI, persistence, economy, paid entitlement, and later theft
- Situation: The user approved 200 free storage slots and a permanent Robux capacity pass while also choosing no-loss full harvesting and later on-plot theft exposure.
- Decision made: Define capacity as occupied authoritative slots; stack compatible ordinary seeds; keep unique harvests and creatures individual; make full harvest a no-op; use one fixed permanent pass verified server-side; preserve paid benefits and all items during lookup/migration problems; separate storage from hotbar, plot, active utility, value, and theft protection; prohibit failure- or threat-triggered upsells.
- Reasoning summary: Storage looks like a UI convenience but determines persistent object count, transaction races, DataStore size, economy pacing, and whether later theft can pressure a player into spending. These boundaries must be set before schema or store UI work.
- Result: At this checkpoint, free capacity and the broad item-counting contract were synchronized. The repeatable-product entry above later resolves the 999 maximum, special seeds, weighted tree produce, deployed slots, free favorite/lock, and no-grace behavior while superseding the pass. Product ceiling/price/name/ID, canonical stack key, exact caps, tree collection, default lock, and measured budgets remain unresolved. No paid storage product was created or sold.
- Test evidence: Direct user answers, current official Roblox pass/monetization documentation, two independent specialist reviews, strict UTF-8 PASS, `git diff --check` PASS aside from line-ending notices, targeted contradiction searches, and independent final documentation review PASS after four findings were corrected. No implementation, purchase, economy, performance, device, multiplayer, or Studio gameplay test exists.
- Mistakes discovered: The first recommendation proposed 100 rather than 200 slots. Without explicit no-op and entitlement-recovery rules, full storage or a temporary Marketplace failure could lose valuable items or turn the pass into perceived theft protection.
- Recommended future approach: Set stack keys/max and creature counting next; measure worst-case serialization/UI before choosing the bonus; use neutral store placement and free resolution tools; build capacity/fault tests before Marketplace UI; independently review all active records after amendments.
- Confidence level: High for the approved rules and safety model; Medium for pass sizing until measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## 2026-07-19 Tutorial harvest and UI-reference amendment

> Follow-up (2026-07-19): The later storage entries resolve base capacity, the 999 seed maximum, special-seed equality exception, weighted produce, deployed slots, exact-position overlap, and universal Sunspud timing. Repeatable Developer Product ceiling/price/ID, canonical stack-key implementation, exact caps, and original wireframes remain open.

- Date: 2026-07-19
- Agent: Codex with Game Design, Gameplay, Economy, Architecture, Data, UI, Performance, Monetization, and QA Agents
- System affected: Tutorial, plants, harvesting, inventory, economy, placement, navigation, UI references, documentation, and regression prevention
- Situation: Detailed user answers named Sunspud, made ordinary plants single-harvest, reserved regrowth for explicit classes such as trees, separated ten quick slots from backpack storage, made Shop/Plot/Sell travel permanently free, allowed close placement with optional snapping, and requested Grow a Garden UI review.
- Decision made: Replace the old blanket-regrowth assumption with definition-owned `SingleHarvest`/`Regrower` behavior; keep one authoritative inventory with hotbar references; protect harvests from overflow loss; keep all destination travel free; retain free placement with server safety/performance validation; and borrow only broad UI usability patterns while making all Catch a Creature creative expression original.
- Reasoning summary: A small wording change about harvest persistence affects economy, data schemas, transaction semantics, tutorial solvency, UI, map density, and tests. Recording the amendment across every consumer before code is cheaper and safer than migrating an incorrect implementation later.
- Result: At this checkpoint, the active Phase 1 documents, shared knowledge, architecture decision, risks, test requirements, source notes, and relevant personal memories used the amended contract. The later storage decision above resolves the capacity/stacking direction and exact-position overlap; Sunspud balance/art, tree catalog/produce details, pass details, and original wireframe remain unresolved. No game or Studio content was changed.
- Test evidence: Direct user decisions; visual review of public reference screenshots; three read-only specialist reviews; targeted contradiction searches; strict UTF-8 PASS; `git diff --check` PASS aside from line-ending notices; and independent final documentation review PASS after its two memory/wording findings were corrected. No Luau, economy, device, multiplayer, performance, or Studio gameplay test exists.
- Mistakes discovered: The earlier record generalized renewable-parent behavior to all flora and treated ten visible slots and vendor choices ambiguously. Those assumptions would have produced incorrect inventory, harvesting, and onboarding contracts.
- Recommended future approach: Translate every design amendment into one authoritative active entry plus explicit historical supersession; search all derived documents; require definition validation, atomic transaction tests, economy simulation, responsive wireframes, and independent review before implementation.
- Confidence level: High for the user-approved contract and reference observations; Medium for balance and UI fit until prototyped
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## 2026-07-19 Phase 0 completion retrospective

> Follow-up (2026-07-19): The user subsequently authorized bounded Phase 1 standards, selective source-link, and import-test work. Phase 2 grayboxing, gameplay implementation, production asset multiplication, and publishing remain unauthorized.

- Date: 2026-07-19
- Agent: Codex with Game Design, Gameplay, Architecture, Data, Security, QA, Monetization, UI, Map, Performance, VFX, Audio, and Documentation agents
- System affected: Whole project, first-playable scope, production gating, agent learning, testing, risk management, and task assignment
- Situation: The user approved the final first-playable emotional contract after all prior Phase 0 promise, content, bonding, adaptation, weather, economy, disposition, and later paid-stealing decisions were recorded.
- Decision made: Mark Phase 0 design complete without authorizing Phase 1 or implementation. Preserve the approved first-playable as cozy, theft-free, absence-safe, non-PvP, non-random-loss, and optionally cooperative; keep paid true-transfer stealing in a separately gated later update.
- Reasoning summary: Closing the milestone provides a stable boundary for future standards and tests while preventing the extensive later-feature design from expanding the initial playable or becoming an implementation claim.
- Result: Phase 0 decisions, shared knowledge, personal memories, risks, improvement goals, test priorities, architecture boundaries, and roadmap status are synchronized. No gameplay source, models, UI, audio, production scaffold, Studio content, publish action, commit, or push was created by this completion step.
- Test evidence: Targeted consistency searches, strict UTF-8 validation across all 28 changed/new Markdown files, repeated `git diff --check` passes, official-source review for monetization, multiple specialist reviews, and a final independent Phase 0 milestone review PASS after its three stale-wording findings were corrected. No game or Studio behavior has been tested.
- Mistakes discovered: Early research expanded into later systems before the vertical slice was fully bounded; several approvals required explicit supersession; combined truth labels and stale historical wording were caught by independent review; bulk patches with imperfect anchors required reinspection.
- Recommended future approach: Request explicit Phase 1 authorization; define standards, source linkage, schemas, module boundaries, acceptance tests, rollback, and measured budgets before creating gameplay; keep later paid stealing outside first-playable dependencies.
- Confidence level: High for recorded approvals and repository state; Low for game quality/performance because no implementation exists
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Milestone answers

- Completed at that milestone: Final promise; Grow a Garden-style progression priority; first three Habitat Flora and creatures; the then-current Observe → Care → Bond rule (later amended by wild capture); Emberkeep; Starlace; Soft Rain; Leafnotes; harvesting/disposition; creature mutation/size/weight value; later-update paid true-transfer contract and release order; first-playable emotional contract; learning/memory system; visual command-center design; repository publication and checkpoint.
- Worked well: Narrow user approval gates, explicit locked/provisional boundaries, specialist debate for high-impact monetization, server-authority planning, truth labels, targeted searches, and independent reviews.
- Caused delays: Authentication/tooling setup, Rojo/Studio source-link uncertainty, repeated design amendments, policy research, and the need to supersede earlier no-theft/no-paid-value statements carefully.
- Bugs occurred: No game bugs because no game exists. Documentation defects included stale superseded language, composite truth labels, incomplete dashboard shapes in the earlier foundation, and partial patch application after anchor mismatches.
- Bugs prevented: Client-authoritative rewards; accidental bulk creature sale; random or duplicate paid theft; receipt-to-volatile-target binding; duplicate ownership; paid trait-generation odds; premature Studio/source divergence; first-playable scope contamination.
- Agents performing well: Architecture/Data/Security scored 97 on paid transfer review; QA/Player Trust scored 96; Monetization/Game Design scored 95; prior Documentation scored 93 and Map scored 91. Scores reflect review evidence only, not implemented-game quality.
- Agents needing support: Gameplay, Enemy AI, UI, Performance, VFX, and Audio lack prototype or measurement evidence and need small tasks, explicit acceptance tests, and QA/Architecture review before broader work.
- Architecture that helped: Server authority, data-driven definitions, immutable provenance, idempotent transactions, receipt-credit separation, and Roblox graybox before Blender catalog.
- Architecture still risky: Cross-profile persistence, source linkage, offline progress, capacity/no-loss behavior, and later paid transfer have no implementation evidence.
- Most useful tests: Strict UTF-8 decoding, `git diff --check`, exact-text consistency searches, repository/status inspection, structured-data validation from the foundation, security scans, and independent review.
- Missing tests: All Luau unit/integration tests, save/load/migration, offline progress, economy simulation, receipt faults, multiplayer isolation, device checks, crowded-plot performance, Blender import, and Studio playtests.
- Automate next: Required-field/truth-label validation, definition schemas, cross-document contradiction checks, economy simulations, save round trips, transaction invariants, and test evidence export for the dashboard.
- Change next phase: Keep Phase 1 standards and interfaces small; prove one plot, one guided cycle, one plant, one creature, and one save round trip before catalog production.
- Knowledge preserved: Approved decisions, rejected/superseded approaches, agent scores, improvement goals, risks, security boundaries, test requirements, and current no-implementation truth state.
- Task assignment strategy: Game Design and Gameplay lead the vertical-slice specification; Architecture/Data/Security define boundaries; QA defines acceptance first; Map/UI validate scale and devices; Performance reviews budgets; Documentation maintains evidence; later paid stealing remains unassigned until its prerequisites and policy gate are satisfied.

## 2026-07-19 Paid true-transfer exception lesson

- Date: 2026-07-19
- Agent: Codex / Game Design, Monetization, Architecture, Data, Security, and QA Agents
- System affected: Emotional contract, monetization, ownership, economy, receipts, policy, and task assignment
- Situation: The user deliberately changed the earlier cozy/no-theft direction and required one paid steal to transfer the real exposed plant or creature with full economic rights and no duplicate.
- Decision made: Record the theft contract as an explicit narrow supersession, preserve the no-random and no-duplicate boundaries, separate receipt credit from target transfer, and initially leave price, release phase, and policy details provisional rather than implying blanket approval. The follow-up below records the later release-phase approval.
- Reasoning summary: High-impact amendments must identify every rule they reverse. Pretending the new feature fits the old no-paid-economic-advantage promise would make future design, security, and monetization work internally inconsistent.
- Result: The project now distinguishes direct premium currency conversion from the approved indirect value of a stolen asset and records the ownership, receipt, policy, test, and player-trust gates required before implementation.
- Test evidence: Current official Roblox documentation review, three read-only specialist reviews, strict UTF-8 and diff checks, and an independent documentation review PASS covering the contract and later-update release order. No game or Studio evidence exists.
- Mistakes discovered: The first emotional-contract proposal assumed theft should remain excluded; the paid-theft idea initially lacked a defined victim-state boundary, receipt fulfillment model, and economic-rights decision.
- Recommended future approach: When a monetization idea overrides a fairness boundary, require explicit user supersession, multiple discipline reviews, a non-client-trusted transaction invariant, failure behavior, and platform-policy confirmation before implementation.
- Confidence level: High
- Verification status: Code-reviewed
- Implementation status: Not yet implemented
- Follow-up: The user approved the recommended later-update release order on 2026-07-19. Paid true-transfer stealing is not part of the first playable and remains gated behind proven core ownership/economy systems and policy confirmation.
- Follow-up (2026-07-20): The user superseded that release order and made paid true transfer a conditional initial-public-release target. It remains outside the smallest internal first playable, is implemented last, stays feature-flagged off, and blocks public launch until the existing policy, ownership, protection, receipt, recovery, economy, and multiplayer gates pass.

## 2026-07-19 Approval amendment and disposition lesson

- Date: 2026-07-19
- Agent: Codex / Game Design, Economy, Data, Security, and QA Agents
- System affected: Phase 0 approvals, harvesting, creature traits, economy, persistence, and documentation
- Situation: The user approved a disposition proposal but explicitly replaced its “creatures are never sold” clause with first-playable creature sales and added mutations, size, and weight.
- Decision made: Preserve the accepted parts, supersede the rejected clause everywhere, record creature sales as a second Leafnote source, and require server-owned value inputs plus atomic terminal transactions before implementation.
- Reasoning summary: Treating a qualified approval as an unmodified yes would preserve a contradiction; silently rewriting older dated entries would erase decision history. Explicit supersession keeps both the current rule and its provenance clear.
- Result: The active design and memories now distinguish current rules from the historical flora-only/creature-later boundary, and economy/security/QA requirements exist before code.
- Test evidence: Targeted repository searches, strict UTF-8 validation, `git diff --check`, two specialist read-only reviews, and a final independent QA review requested on 2026-07-19. No game or Roblox Studio test exists.
- Mistakes discovered: The first proposal was too restrictive for the user's intended collectible economy; one bulk patch partially applied before an anchor mismatch, so each resulting file was re-inspected and validated.
- Recommended future approach: Parse approval amendments clause by clause, keep dated history explicit, audit every derived statement, and review valuable persistent-object transactions with Economy, Data, Security, and QA before implementation.
- Confidence level: High
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## 2026-07-18 Phase 0 decision checkpoint

- Date: 2026-07-18
- Agent: Codex with independent documentation review
- System affected: Game identity, first-playable content, progression, weather, economy, and development process
- Situation: The user approved a sequence of Phase 0 decisions after the read-only repository and Roblox Studio preflight, then requested a durable stopping point for the day.
- Decision made: Lock the final game promise; Hearthpetal, Ripplecup, and Nuzzlefern; Cozzle, Rillibob, and Mossnub with their primary flora preferences; Emberkeep; Starlace; Soft Rain; and Leafnotes with its harvest-to-base-seed relationship. Keep the proposed Observe → Care → Bond interaction and every remaining Phase 0 item unapproved.
- Reasoning summary: Recording each narrow approval with explicit exclusions preserves progress without allowing names or concepts to silently approve balance, art, behavior, APIs, persistence, or implementation.
- Result: Approved decisions, truth labels, personal memories, and cross-agent handoffs are synchronized. Phase 0 remains in progress; no gameplay code, production scaffold, Studio content, or Roblox publish action exists.
- Test evidence: Repeated `git diff --check` passes, exact-text searches for each approved decision, read-only Studio hierarchy inspection, and independent review passes for the promise, flora, creatures, Adaptation/Bloommark, weather, and currency records.
- Mistakes discovered: An initial combined verification-status sentence did not use one exact allowed truth label; independent review caught it and the status was split into `Verified` plus a separate `Not yet implemented` implementation status. A first independent review was interrupted and was rerun successfully with a bounded scope.
- Recommended future approach: Resume at the exact clue-inspection and bonding decision, continue one approval gate at a time, and do not create a Rojo scaffold or gameplay logic until every remaining Phase 0 gate is approved.
- Confidence level: High
- Verification status: Code-reviewed
- Follow-up: The Observe → Care → Bond proposal and every other remaining Phase 0 gate were subsequently approved on 2026-07-19. The historical in-progress state and next-step instructions above describe only the 2026-07-18 checkpoint and are superseded by the 2026-07-19 Phase 0 completion retrospective at the top of this file. Bounded Phase 1 standards/source-link work was then authorized; Phase 2 grayboxing and gameplay implementation remain unauthorized.

## 2026-07-18 Repository publication lesson

- Date: 2026-07-18
- Agent: Codex / Security Agent
- System affected: GitHub access and repository privacy
- Situation: Public visibility was requested to support a friend contributing to the project.
- Decision made: Require explicit informed approval and scan current tracked content plus reachable Git history before changing visibility.
- Reasoning summary: A public repository is easy to collaborate around, but it exposes history and metadata beyond the current working tree, and public visibility alone does not grant push permission.
- Result: The repository is verified public. No credential patterns were found; a personal author email in two commits and inconclusive PNG metadata candidates were disclosed as privacy caveats.
- Test evidence: `gh repo view` returned `visibility: PUBLIC` and `isPrivate: false`; independent review examined 49 tracked files, 54 blobs, and four commits.
- Mistakes discovered: CLI authentication freshness was not checked until execution, and prior commits used a non-noreply author email.
- Recommended future approach: Check authentication early, use a noreply author address, run dedicated secret and asset-metadata scans before public releases, and add collaborators separately when direct push access is intended.
- Confidence level: High
- Verification status: Verified
- Scan review status: Code-reviewed

## 2026-07-16 Phase 0 research retrospective

- Date: 2026-07-16
- Agent: Codex
- System affected: Research, design, process, repository
- Situation: A broad reference study expanded into original game design, monetization, event, and ambience decisions while the repository remained empty.
- Decision made: Stop treating the conversation as durable memory and create a versioned research/learning foundation before production.
- Reasoning summary: The project needs continuity, evidence labels, and explicit deferral gates to avoid repeating research or implementing untested breadth.
- Result: Research, shared knowledge, agent memory, and first-development-order documents prepared for the initial commit.
- Test evidence: Required-file/nonempty, strict UTF-8, NUL-byte, JSON parsing, ignore-rule, and credential-pattern checks passed; independent documentation review returned `PASS`. Git commit and push evidence will close repository publication.
- Mistakes discovered: GitHub connectivity and CLI authentication were addressed later than ideal; too many later-phase features were brainstormed before the first-playable boundary was fixed.
- Recommended future approach: Begin each milestone with recall and a scoped plan; end with review, tests, reflection, knowledge updates, and a commit.
- Confidence level: High
- Verification status: Code-reviewed
- Evidence class: Automated documentation checks plus independent review; game remains not yet implemented

## Milestone answers

- Completed: Reference research, original thesis, monetization boundaries, event frameworks, ambience direction, production order, and memory architecture
- Worked well: Parallel research, source comparison, explicit separation of functional and cosmetic rarity
- Delays: GitHub tooling installation and authentication validation
- Bugs occurred: Tooling-only authentication anomaly; no game bugs
- Game bugs: None; no game implementation exists. Design risks kept out of the approved direction include client-authoritative economy, duplicate receipts, paid-genetics inflation, event currency bloat, and premature asset production.
- Helpful architecture: Server authority, data-driven definitions, Roblox graybox before Blender catalog
- Missing tests: All gameplay, save, economy, device, performance, and Studio tests
- Automate next: Documentation validation, content schemas, economy simulations, save round trips, and receipt idempotency
- Change next phase: Lock the first three plants and creatures before implementation

## 2026-07-21 Catch a Monster reference-study lesson

- Date: 2026-07-21
- Agent: Codex / Game Design Agent
- System affected: Reference research, creature discovery, progression, originality
- Situation: A user-supplied Pets page led to a connected review of the reference game's collection, weather, evolution, fusion, egg, event, and repeatable-mode pages.
- Decision made: Adopt world-conditioned discovery and a useful collection index as design principles, reinterpret progression through sanctuary relationships, and defer combat/fusion/tower scope.
- Reasoning summary: Reference research is most valuable when it reveals why a system motivates players, not when its content or numbers are copied.
- Result: A durable source-labeled study now connects the next Observe slice to a future `Seen` Field Journal state.
- Test evidence: Community pages reviewed and cross-checked against current project decisions; no new code or Studio behavior was claimed.
- Mistakes discovered: The wiki contains unfinished, inconsistent, and explicitly speculative values, so exact figures cannot be treated as verified.
- Recommended future approach: Review connected mechanics, label reliability, preserve copying boundaries, and test the translated idea inside our own loop.
- Confidence level: High
- Verification status: Code-reviewed research

## 2026-07-21 avatar-rig and held-item lesson

- Date: 2026-07-21
- Agent: Codex
- System affected: Avatar configuration, animation, held-item feedback
- Situation: The user requested a straight forward arm and an R6 game after reporting a walking glitch with equipped items.
- Decision made: Configure R6 in the Rojo place build, implement a single-shoulder R6 pose, and retain an arm-only R15 fallback during transition.
- Reasoning summary: Game-wide rig selection is a Studio/avatar setting, while the held pose belongs in client presentation; separating them keeps the feature safe during local transition and source builds.
- Result: The source build serializes R6, both rig branches are supported, and isolated runtime checks show the R6 arm remains forward without torso distortion.
- Test evidence: Rojo PASS, serialized `GameSettingsAvatar` token `0`, 58/58 server tests, and direct R15/R6 movement assertions.
- Mistakes discovered: A live Rojo session should not be assumed to update hidden place settings; the already-open place still spawned R15.
- Recommended future approach: Treat hidden build properties and live Studio settings as separate verification boundaries, then retest a normal spawn after the manual setting change.
- Confidence level: High
- Verification status: Code-reviewed; normal R6 spawn Requires Roblox Studio testing

## 2026-07-21 exact placement and visible-order lesson

- Date: 2026-07-21
- Agent: Codex across UI, Gameplay, Data, and QA roles
- System affected: Placement interaction and persistent hotbar ordering
- Situation: Two small visual inconsistencies had deeper causes: the cursor and ray used different coordinate conventions, and the hotbar saved invisible category reservations.
- Decision made: Make displayed state a direct projection of authoritative owned references, and make placement feedback and hit testing consume one coordinate source.
- Reasoning summary: When visuals and logic derive from separate representations, nearly-correct behavior can hide durable errors.
- Result: Placement commits at the reticle center, empty means truly unassigned, and acquisitions use the first visible open number without compacting existing references.
- Test evidence: Exact saved coordinate, live slot reuse, schema migration cases, fresh 61/61 suites, and clean Rojo build.
- Mistakes discovered: Visual approximation was accepted too early; fixed seed categories leaked into general inventory ordering.
- Recommended future approach: Add an equality assertion between displayed input and logical input for every precision interaction, and centralize all future item/creature pickup allocation.
- Confidence level: High for the tested desktop/current-content scope
- Verification status: Verified with documented device and future-creature gaps
