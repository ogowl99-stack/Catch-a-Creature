# Game Design Knowledge

## Entry: Approved Retry/Let Go, Familiarity guarantees, and Mythic-capture celebration

- Date: 2026-07-19
- Agent: Codex / Game Design, Gameplay, Architecture, Data, Security, UI, VFX, Audio, Performance, and QA Agents
- System affected: Capture failure, consumables, Familiarity, public contention, UI, ownership, rare-success cutscene, VFX, audio, accessibility, and performance
- Situation: The user resolved the remaining failed-attempt cost, Familiarity, and fair public-ordering decisions, then required a post-failure `Retry Capture`/`Let Go` choice and a cutscene with VFX for a super-rare success.
- Decision made: Every valid accepted attempt, including success, consumes exactly one Haven Tag and the selected free Luck aid, if any; rejected, stale, busy, full, out-of-range, expired, or lost-race traffic consumes nothing. Familiarity is keyed per player × stable creature-definition ID × rarity tier, adds two absolute percentage points after each committed failure, guarantees success on attempts 2/3/5/8/15/25 for Common/Uncommon/Rare/Epic/Legendary/Mythic, persists across visitors, rejoins, and another contender winning, and resets only when that player captures the matching creature-definition ID. Public retries use distinct-contender round-robin: a failed player must deliberately choose Retry, joins behind eligible players already waiting, and retries immediately when nobody waits. Retry defaults to No Aid after the prior aid is consumed; Luck selection is disabled on a guaranteed attempt. `Let Go` closes only that player's current capture flow, removes their pending intent, consumes nothing further, preserves Familiarity, and leaves the visitor wild/public; it cannot cancel an in-flight attempt. During caretaker priority, Let Go does not open public access or end the remaining exclusive window; `Open to Everyone` remains the separate explicit control. Only a durable `CaptureCommitted` result may trigger presentation. Mythic is the approved full celebration tier, not a seventh rarity: an approximately five-second immediately skippable capturer-local sequence uses Haven Tag glow, a leaf/constellation sanctuary ribbon, trait-colored motes, voluntary sanctuary-mark acceptance, and a field-journal reveal of name/tier/mutation/size/weight. Nearby players see only a brief bounded world flourish, Legendary receives a shorter two-to-three-second flourish, and Full/Short/Off plus Reduced Motion settings are supported. Exact original audio remains provisional.
- Reasoning summary: Deliberate decisions preserve fast pacing without auto-repeat or accidental consumable loss. Round-robin protects distinct contenders. Ownership-before-celebration prevents a cutscene from promising an asset that has not been saved, while local/accessibility-scaled presentation avoids disrupting other players.
- Result: Accepted-attempt consumption, Familiarity math/key/persistence/reset/guarantees, fair round-robin, Retry/Let Go behavior including caretaker priority, No Aid retry default, guaranteed-attempt Luck disabling, Mythic/Legendary presentation tiers, exact visual sequence/audience/duration/settings, and post-commit celebration requirement are user-approved. Transaction/idempotency/cleanup boundaries are code-reviewed. Exact audio, assets, copy, numerical VFX budgets, and technical expiry grace remain unresolved. No code, schema, UI, asset, audio, cutscene, simulation, Studio result, device test, or performance measurement exists.
- Test evidence: Direct user decisions plus independent Security/Architecture, QA/UI, and VFX/Audio/Performance reviews on 2026-07-19. No executable or runtime evidence exists.
- Mistakes discovered: The previous documentation still labeled three resolved choices as provisional. A failure-choice button could also be misread as globally releasing the creature, and a success cutscene could be triggered too early from an optimistic client result.
- Recommended future approach: Implement a pure state/transaction contract before presentation; use one-use result and decision tokens; show exact next odds, guarantee, costs, remaining time, and queue position; commit ownership before emitting an idempotent celebration descriptor; and prototype the approved sequence on low-end mobile before locking particle/audio budgets.
- Confidence level: High for approved mechanics and presentation direction; Low for runtime quality/performance until Studio/device tests run
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff: failure decision and rare-success presentation

- What changed: The three capture-economy/fairness choices are resolved. Every committed failure consumes its approved inputs and adds one +2-point Familiarity step; tier guarantees and round-robin are fixed. Failure now branches through Retry or personal Let Go. A qualifying success requires post-commit cutscene/VFX.
- Why it changed: The user wants transparent escalating capture attempts, an explicit opt-out, and a memorable celebration for the rarest wins.
- APIs affected: Future attempt outcome, decision token, queue intent, Familiarity key/version, item transaction, owned-creature commit, celebration descriptor, UI state, local camera, VFX/audio cleanup, and metrics; none exists.
- Files affected: Project context, design/research, architecture, security, testing, UI/VFX/audio/performance patterns, risk/failure/success libraries, feedback, lessons, scores, backlog, and personal memories.
- New requirements: No auto-retry; one decision token; one intent/user; exact cost/progress disclosure; no Let Go mutation of the global visitor; ownership before celebration; event dedupe; immediate skip; reduced-motion/low-effect fallback; camera/input restoration; bounded nearby effects; original non-capsule expression.
- Risks: Ambiguous Let Go semantics, held-button repeat, useless aid consumption on a guaranteed attempt, queue starvation, optimistic celebration, duplicate VFX, forced-camera grief, photosensitivity, audio fatigue, and cleanup/performance leaks.
- Tests required: Golden guarantee math; transaction fault injection; Retry-versus-Let-Go race; eight-player queue fairness; expiry/disconnect/replay; item/progress exact-once; success-before-celebration ordering; duplicate celebration; skip/reduced motion/respawn/streaming/camera restoration; mobile/controller/accessibility; and crowded effect/audio measurements.
- Action required: No further stakeholder choice is needed for this capture decision batch. Architecture/Data/Security define the pure contract; UI/VFX/Audio prototype the approved direction; QA/Performance test before gameplay approval. Exact Luck formula/recipes, audio production, technical expiry grace, and measured budgets remain later design/test work.

## Entry: Approved capture package with immediate rising-chance retry

> Follow-up (2026-07-19): The newer entry above supersedes this checkpoint's pending decisions. All accepted-attempt cost, exact Familiarity key/increment/guarantees/persistence/reset, distinct-contender round-robin, Retry/Let Go, No Aid/guaranteed-attempt rules, and Mythic/Legendary visual celebration details are now approved; exact Luck formula/recipes, audio, expiry grace, assets, and measured budgets remain open.

- Date: 2026-07-19
- Agent: Codex / Game Design, Gameplay, Architecture, Data, Security, Monetization, UI, Performance, Enemy AI, and QA Agents
- System affected: Observe/Care, priority, rarity, capture, Familiarity, consumables, competition, visitor lifetime, traits, UI, economy, security, and performance
- Situation: The user approved the twelve-part recommended capture package except the proposed post-failure cooldown. They replaced that cooldown with immediate retry and a slightly higher chance after every valid failure.
- Decision made: Lock `Habitat attraction → personal Observe → correct Care → Trust → Haven Tag → disclosed server roll → Owned`. The caretaker has 60 seconds of exclusive priority and may open early; public access then lasts five minutes and requires physical proximity. The tutorial capture is guaranteed. Base capture chances are Common 95%, Uncommon 80%, Rare 55%, Epic 30%, Legendary 12%, and Mythic 3%; 0.01% is not a capture chance and is reserved only as a possible later arrival-weight experiment. A leaf-shaped Haven Tag is placed near the visitor and draws a ribbon of sanctuary light. A valid failure leaves the visitor and its visible mutation/size/weight unchanged, has no post-result gameplay cooldown, permits immediate retry after the authoritative result, increases persistent personal species Familiarity slightly, and progresses toward a hard guarantee. Free craftable Luck or Super Luck applies to the next valid attempt, with at most one aid. Starting caps are two wild and six displayed owned creatures per plot and 64 simulated creatures per server; they remain unmeasured. The earlier recommended failed-roll item consumption was bundled into the amended item and remains ambiguous, so it is not locked.
- Reasoning summary: The approved package preserves the sanctuary interaction, gives the host a fair first opportunity, then supports competition with transparent and increasingly forgiving odds. Immediate retry removes dead time, while serialized server attempts are still required to prevent overlapping rolls, duplicate ownership, autoclick exploitation, and persistence races.
- Result: The flow, priority, tutorial guarantee, rarity labels/base chances, Haven Tag expression, no-cooldown immediate retry, rising persistent Familiarity/hard-guarantee direction, five-minute public window, proximity, fixed visible traits, free next-attempt Luck boundary, and starting caps are user-approved. Exact failed-roll Haven Tag/Luck consumption, Familiarity increase/bucket/reset/guarantee table, public retry ordering, arrival weights, Luck multipliers/recipes, and in-flight expiry grace remain provisional. No code, Studio content, assets, simulation, or playtest exists.
- Test evidence: Direct user approval and two read-only immediate-retry reviews on 2026-07-19. No executable state, RNG, economy, persistence, contention, bot, device, performance, or Studio test exists.
- Mistakes discovered: The prior proposal treated a cooldown as necessary for failure pacing; the user prefers continuous retries. Removing the visible cooldown without preserving one authoritative in-flight result would turn the mechanic into overlapping click spam and could duplicate consumption or Familiarity. “Approve except #4” did not unambiguously resolve the failed-roll Haven Tag consumption clause bundled into that item.
- Recommended future approach: Treat transaction/acknowledgment time and transport throttling as technical safeguards, never player-facing cooldowns. Accept one active roll per player and visitor; issue the next attempt only after the durable result; do not consume or increment on invalid/busy/full/lost-race requests. Ask the user to lock failed-roll consumption, the Familiarity table, and fair public retry ordering; then simulate economy/acquisition time and eight-player contention before implementation.
- Confidence level: High for the user-approved flow and no-cooldown meaning; Medium for the serialized/fairness contract; Low for balance until the remaining numbers are approved and simulated
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff: immediate retry and Familiarity

- What changed: The broader capture package is approved, but the proposed post-failure cooldown is rejected. A failed valid roll may be retried immediately after its server result and slightly increases persistent personal species Familiarity.
- Why it changed: The user wants continuous capture momentum and visible progress after every failure.
- APIs affected: Future attempt token/request/result, capture preview, encounter reservation, queue/pending intent, Familiarity record, consumable transaction, owned-creature commit, visitor timer, UI, and metrics; none exists.
- Files affected: Current direction/start plan/README, architecture, testing, security, risk, failure library, UI/AI/performance knowledge, feedback, lessons, scores, improvement goals, monetization, and personal memories.
- New requirements: No artificial failure cooldown or auto-repeat; one in-flight roll; exact next odds after each valid failure; persistent personal species progress; fixed visitor traits; five-minute hard public deadline; free-only chance inputs; no rejected-request consumption/Familiarity; one exact owner.
- Risks: Autoclick/latency monopoly, overlapping or replayed rolls, free retry economy collapse, cross-tier Familiarity farming, write/VFX floods, misleading odds, queued expiry, and another player winning before a guaranteed contender acts.
- Tests required: One-in-flight/idempotency; immediate re-enable; failure progression; guarantee boundaries; invalid-versus-accepted consumption; persistence/reset; eight-player fairness; visitor expiry; fixed trait payload; free-only provenance; economy simulation; device UI; and measured attempt/write/VFX budgets.
- Action required: User answers the three remaining capture-economy/fairness questions. Architecture/Data/Security define attempt/Familiarity contracts; QA writes transition/fault/contention tests; Game Design/Monetization simulate attempts and Tag costs; UI exposes exact progress; Performance measures throughput.

## Entry: Competitive wild capture and completed storage choices

> Follow-up (2026-07-19): The approved-package entry above resolves the proposed hybrid, priority, tutorial, rarity table, Haven Tag, no-cooldown retry, Familiarity direction, public lifetime, proximity, fixed traits, free Luck boundary, and starting caps. Only the explicitly listed numerical/economy/fairness details remain provisional.

- Date: 2026-07-19
- Agent: Codex / Game Design, Gameplay, Architecture, Data, Security, Monetization, Performance, QA, UI, and Enemy AI Agents
- System affected: Wild visitors, bonding, capture, rarity, storage, competition, creature ownership, tree collection, vendor actions, originality, economy, and later stealing
- Situation: The user approved the proposed five-purchase storage maximum, favorite protection for Sell Held, and individual tree-produce collection/full-storage retention, then introduced a chance-based creature-capture step. A visitor spawned by a plot remains unclaimed and available to anyone until one player successfully catches it; a full Backpack cannot claim or reserve it. The user gave 95% Common and 0.01% Super Rare examples and asked to preserve future craftable Luck and Super Luck ideas.
- Decision made: Lock five repeatable +200 capacity purchases as the launch operational maximum, producing 1,200 total slots from the 200-slot base, still subject to implementation, measurement, and emergency receipt headroom. Favorites block Sell Held. Tree produce is collected one item at a time; a selected fruit with no available slot stays unchanged on the tree. For wild visitors, no ownership exists before successful capture, and insufficient storage leaves the creature wild and available. The capture tool must have an original name, shape, art, animation, audio, and UI rather than copying another creature-collection franchise. Preserve the user's 95% and 0.01% numbers only as examples until their meaning is clarified. Record craftable Luck/Super Luck as a future design goal, not approved balance or implementation.
- Reasoning summary: The ownership point must be unambiguous so full storage, simultaneous players, paid theft, and persistence cannot create duplicate or phantom owners. An original hybrid can retain Catch a Creature's habitat/care identity while adding the competitive catch moment, but exact care gating, odds, priority, failure, and pity require explicit decisions. The 0.01% example would average 10,000 attempts if it were a capture chance, so treating it as locked would create severe frustration and potion pressure.
- Result: The storage ceiling, Sell Held protection, individual tree-produce behavior, wild-until-caught ownership rule, full-storage capture behavior, public competition direction, and originality boundary are user-approved. Cross-functional review recommends `Habitat attraction → Observe → correct Care → personal Trust → original capture item → disclosed server roll → Owned`, a short caretaker priority window, a guaranteed tutorial capture, sane rarity-tier capture floors, accepted-failure item consumption with durable Familiarity, and free-only next-attempt luck; all remain proposals pending user answers. No code, assets, product, Studio content, simulation, or playtest was created.
- Test evidence: Direct user answers on 2026-07-19; one independent Game Design/Economy/QA review and one Architecture/Data/Security/Monetization/Performance review. Probability analysis shows a 0.01% per-attempt success rate has an expected 10,000 attempts and a median of roughly 6,932. No executable, economy, multiplayer, device, performance, persistence, or Studio test exists.
- Mistakes discovered: The earlier deterministic correct-Care-to-ownership rule conflicts with the new chance-based capture requirement. The earlier full-capacity bonding fallback also cannot grant ownership under the new wild-until-success rule. Arrival rarity and capture-success chance were initially discussed without separate names, which could accidentally multiply two tiny probabilities or mislead players.
- Recommended future approach: Explicitly confirm whether correct Care earns personal Trust, whether the caretaker receives a priority window, whether failed valid attempts consume one free item, whether a Familiarity guarantee exists, and whether the example percentages describe arrival or capture. Store arrival and capture odds in separate server definitions; show the exact final capture chance; resolve one server-authoritative atomic winner; block full storage before RNG/consumption; and keep every luck input gameplay-earned, account-bound, nontradeable, nonstealable, and disconnected from Robux or Robux-derived currency unless a later policy review deliberately changes that boundary.
- Confidence level: High for the user-approved ownership/storage rules and atomicity need; Medium for the hybrid recommendation; Low for balance until choices, simulation, and playtesting
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff: competitive wild capture

- What changed: Correct Care can no longer be assumed to create ownership; a visitor stays wild until successful capture, and full storage leaves it available to competitors. Five +200 capacity purchases/1,200 total, Sell Held favorite protection, and individual tree-produce collection are approved.
- Why it changed: The user wants an original rarity-based capture moment and open competition for any unclaimed visitor.
- APIs affected: Future encounter definitions, arrival pools, per-player Observe/Care/Trust state, capture preview/request, Backpack reservation, item/potion inventory, RNG audit, owned-creature creation, visitor roaming, UI, persistence, appraisal/sale, and later steal eligibility; none exists yet.
- Files affected: Project context, research direction/start plan/monetization/sources, architecture decisions, tests, risks, failed approaches, lessons, scores, improvement goals, feedback, UI guidance, and relevant personal memories.
- New requirements: Server owns encounter ID/revision, arrival and capture values, eligibility, odds, modifiers, roll, storage check, reservation, winner, and ownership commit. Full storage, invalid targets, or a lost reservation consume nothing and do not roll. Wild visitors never qualify for paid theft; only successfully owned deployed creatures can. Original expression must avoid protected names, capsule silhouettes, copied animations, sounds, UI, or character designs.
- Risks: Plot camping, latency advantage, bot spam, full-storage purchase pressure, ultra-low odds, potion dependency, economy dominance from creature sales, duplicate owners, stale capture attempts, paid-random-policy contamination, copied expression, and excessive roaming/pathfinding/VFX cost.
- Tests required: Definition separation; probability simulation; exact odds display; personal eligibility; storage and final-slot races; eight-player same-frame contention; replay/disconnect/save faults; accepted versus rejected consumption; winner uniqueness; priority/public lifetime/immediate retry; economy; free-only item provenance; mobile/controller accessibility; original visual review; crowded-server performance; and later paid-theft exclusion.
- Action required: User resolves the remaining interaction and balance questions. Architecture/Data/Security then define a minimal atomic encounter contract; QA authors executable state/concurrency tests; Game Design/Monetization simulate rates and economy; UI prototypes transparent mobile-first capture information; Enemy AI/Performance bound visitor simulation; Documentation maintains explicit approved-versus-proposed labels.

## Entry: Repeatable storage expansion and finite operational ceiling

- Date: 2026-07-19
- Agent: Codex / Game Design, Monetization, Architecture, Data, Security, UI, Performance, and QA Agents
- System affected: Backpack capacity, developer products, receipts, seed stacking, deployed assets, tree produce, bonding, favorite/lock protection, later theft, persistence, and mobile UI
- Situation: The user approved all remaining storage details, rejected any full-storage theft grace, and replaced the one-time pass with a desired repeatable +200 purchase that could be bought without limit.
- Decision made: Compatible ordinary seed stacks cap at 999. Trait-bearing or Adapted Seeds remain individual unless their complete server-canonical immutable payloads are identical. Planted crops and roaming/displayed owned creatures consume no Backpack slot but require separate finite server-owned caps. Weighted tree produce is individual and collected one selected item at a time; if full, that item stays unchanged. An already-owned roaming creature that cannot be recalled remains owned on the plot. The later wild-capture amendment instead grants no ownership when full and leaves the visitor wild. Favorite/lock protection remains free and blocks Sell Held. No special storage-resolution grace exists in the later theft update: an otherwise eligible exposed, unfavorited, and unlocked owned asset is immediately stealable. Repeatable permanent +200 capacity uses one Roblox Developer Product, not a game pass, and each valid unique receipt grants exactly one durable +200 unit through server `ProcessReceipt`. Literal infinite storage cannot be advertised because systems are finite. Five purchases and 1,200 total slots are the user-approved launch operational maximum, still gated on measurement and emergency receipt headroom.
- Reasoning summary: Roblox passes are one-time entitlements, whereas developer products support repeat purchases. A finite operational ceiling is required so every paid receipt can be durably delivered; “infinite” would sell a benefit the game cannot prove it can store, load, render, or recover.
- Result: Stack maximum, broad stack identity, deployed-slot behavior, individual tree produce, free favorite/lock availability, no storage-resolution theft grace, and the repeatable +200 product direction are approved. Product type is corrected to Developer Product. Follow-up: the user approved five purchases/1,200 total as the launch maximum, favorites blocking Sell Held, and one-at-a-time tree-produce collection with full selected produce remaining unchanged. The later wild-capture amendment supersedes ownership-on-full bonding: a full Backpack creates no ownership and leaves the visitor wild. Emergency headroom, price, product ID, exact deployed caps, sharding threshold, and cross-page Sell All remain unresolved.
- Test evidence: Direct user answers; current official Roblox Developer Product, monetization, and Data Store limit documentation; independent Architecture/Data/Security and Game Design/Monetization/QA reviews. No receipt, persistence, capacity, economy, performance, device, multiplayer, or Studio test exists.
- Mistakes discovered: The prior design used a game pass, which cannot be purchased repeatedly by the same user. Treating “stackable infinitely” literally would ignore finite platform and device limits and could acknowledge paid purchases that the game cannot safely grant.
- Recommended future approach: Use a durable idempotent receipt ledger; grant one +200 unit per unique `PurchaseId`; return `NotProcessedYet` on uncertain persistence; allow one outstanding prompt; disable external sales; stop prompts before a measured operational maximum while retaining emergency receipt headroom; use paged/virtualized UI; never trigger an upsell from fullness or theft risk; raise the ceiling only after worst-case profile, join, UI, economy, and player-trust tests pass.
- Confidence level: High for the platform correction and receipt/capacity invariants; Medium for the five-purchase proposal until user approval and measurements
- Verification status: Code-reviewed
- Implementation status: Not yet implemented
- Blocked request: Literal infinite permanent storage is not technically or truthfully deliverable. A finite tested ceiling is required.

### Cross-agent handoff: repeatable capacity product

- What changed: The one-time pass direction is superseded by one repeatable +200 Developer Product; storage subrules are resolved; literal infinity is replaced by a finite measured ceiling proposal.
- Why it changed: The user wants repeat purchases, which Roblox supports through developer products, while finite persistence and device budgets prevent an unlimited guarantee.
- APIs affected: Future `MarketplaceService.ProcessReceipt`, product configuration, purchase ledger, capacity grant count, paged inventory, stack keys, plot/roaming caps, tree collection, bonding fallback, favorite/lock, later steal eligibility, and batch sale; none exists yet.
- Files affected: Research direction/monetization/sources, project context, architecture decisions, testing, risks, failed approaches, lessons, scores, UI patterns, and relevant personal memories.
- New requirements: Each unique receipt durably adds +200 exactly once; duplicate/out-of-order/cross-server retries cannot double-grant; no successful receipt is acknowledged before durable grant; no client supplies price/receipt/capacity; external sales stay off; one prompt is outstanding; purchased grants never alter plot/roaming caps or item power; capacity reduction never deletes items; free favorite/lock remains; no later storage grace applies to eligible exposed unlocked assets.
- Risks: Undeliverable paid receipts, unbounded save/profile growth, DataStore throttling, join latency, mobile UI failure, concurrent cap races, payer hoarding advantage, full-storage theft pressure, cross-page transaction complexity, and minor spending concentration.
- Tests required: Receipt replay/order/concurrency/crash/save failure; grant-cap and emergency-headroom boundaries; 998/999/1000 stack cases; full crop/selected-tree-produce/existing-owned-creature recall behavior; full-storage wild-capture rejection; deploy/recall and separate caps; free lock versus immediate steal race; paged storage/search/sort; cross-page appraisal/Sell All recovery; 200 through approved 1,200 profile/load/UI measurements; base-versus-expanded economy; and no pressure prompts.
- Action required: Architecture/Data define receipt/page and capture contracts; Performance measures every tier through the approved 1,200 maximum plus emergency headroom; Monetization uses neutral runtime pricing; QA blocks creation of a live product until grant and recovery tests pass.

## Entry: Two-hundred-slot backpack and permanent expansion-pass direction

> Follow-up (2026-07-19): The one-time pass in this earlier entry is superseded by the repeatable Developer Product entry above. Base capacity and inventory behavior remain active.

- Date: 2026-07-19
- Agent: Codex / Game Design, Gameplay, UI, Architecture, Data, Security, Monetization, Performance, and QA Agents
- System affected: Backpack, hotbar, harvests, seeds, creatures, tutorials, mobile UI, placement, travel, paid storage, persistence, economy, and later theft
- Situation: The user answered the remaining tutorial/UI questions, increased the proposed free capacity from 100 to 200, approved stackable seeds and individual unique assets, requested a Robux game pass that permanently increases storage, and clarified that a mature plant stranded by full storage remains exposed on the plot.
- Decision made: Base Backpack capacity is 200 occupied slots. Compatible ordinary seeds use server-owned stacks; each unique weighted or mutated whole-plant harvest and each stored creature uses one individual slot. The ten hotbar positions remain zero-capacity references into that Backpack. Harvesting an ordinary plant moves the entire server-authored weighted plant into storage; explicit tree-class regrowers grant separate produce. Sunspud's roughly 45-second growth target applies universally, not only to a hidden tutorial variant. If capacity cannot be reserved, harvest changes nothing: the exact mature plant or ripe tree produce remains on the plot, with no reroll, removal, reset, duplicate, or loss; in the separately deferred theft update, an otherwise eligible exposed plant remains stealable under the approved free protection rules, while any extra storage-resolution grace remains provisional. Exact identical-position placement is rejected while arbitrarily close valid placement remains allowed. Grid snap defaults off at one-stud increments. Phones show two stable pages of five slots across the ten assignments. Shop, `Your Plot`, and Sell remain visible during ordinary gameplay and permanently free. One optional, nonstacking Roblox pass may grant a fixed permanent storage bonus; exact bonus, runtime price, name, and pass ID remain provisional.
- Reasoning summary: A generous free baseline keeps ordinary play viable, while occupied-slot semantics and one inventory preserve clarity and prevent hotbar duplication. A permanent pass fits Roblox's one-time privilege model, but it must remain convenience rather than a forced response to full storage or later theft risk.
- Result: At this checkpoint, capacity, broad stacking, harvest/tree semantics, timing, full-storage behavior, placement, paging, travel, and a paid expansion direction were approved. Later amendments resolve the 999 maximum, special seeds, individual weighted tree produce, deployed slots, favorite-protected Sell Held, one-at-a-time tree collection/full retention, five-purchase/1,200 launch maximum, and no-grace choice while superseding the pass and new-bond-on-full fallback. Product price/name/ID, emergency headroom, canonical stack key, exact caps, and UI details remain unresolved.
- Test evidence: Direct user answers on 2026-07-19; current official Roblox pass/monetization documentation; read-only Architecture/Data/Security/Monetization and Game Design/QA reviews. No implementation, serialization measurement, economy simulation, purchase test, device test, multiplayer test, or Studio playtest exists.
- Mistakes discovered: The initial recommendation proposed 100 slots rather than the user's 200. “Safely harvestable” was ambiguous until the full-storage invariant was restated. A capacity pass combined with later exposed-plot theft could become coercive if prompted at failure or marketed as protection.
- Recommended future approach: Model capacity as server-derived occupied slots; bound seed stacks; preflight and revision-lock harvest capacity; never prompt Robux because storage is full; show free Sell/favorite/organize choices first; verify pass ownership server-side and preserve previously verified benefits through temporary lookup failures; measure worst-case 200-plus-bonus persistence and UI load before locking the bonus.
- Confidence level: High for the user-approved contract and one-pass platform fit; Medium for pass sizing and performance until measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff: storage, harvest, mobile hotbar, and pass

- What changed: Base storage is 200 occupied slots; ordinary seeds stack; unique whole-plant harvests and creatures are individual; Sunspud is universally about 45 seconds; full storage leaves the exact harvest on the plot; placement/paging/travel behavior is resolved; one permanent storage-expansion pass is approved in principle.
- Why it changed: The user selected concrete capacity and interaction behavior and added an optional permanent storage purchase.
- APIs affected: Future inventory capacity, stack key, harvest transaction, tree produce, creature storage, hotbar projection, placement, responsive HUD, travel, pass configuration, entitlement verification, profile migration, and later steal reservation; none exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `Research/MonetizationAndEvents.md`, `Research/Sources.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ArchitectureDecisions.md`, `AgentKnowledge/UIPatterns.md`, `AgentKnowledge/TestingKnowledge.md`, risks, lessons, scores, and relevant personal memories.
- New requirements: Derive used slots server-side; serialize last-slot races; existing seed-stack increments may succeed at 200 but new stacks/unique additions may not; full harvest is a no-op; one pass grants one fixed configured bonus after authoritative ownership verification; transient entitlement errors never delete items; over-capacity recovery blocks additions but preserves and exposes all existing items; pass capacity never changes hotbar, plot, active-creature, growth, yield, trait, value, travel, or theft-protection rules.
- Risks: Profile-size overflow, slow 200/expanded inventory UI, forged stacks/capacity/entitlements, duplicate last-slot grants, premium pressure when a rare harvest is exposed, paid hoarding advantage, lost benefit after lookup failure, pass tiers or repeat stacking, and mobile page confusion.
- Tests required: Slot boundaries; stack keys/max/overflow; concurrent final-slot grants; unique plant/creature counts; stale hotbar refs; full SingleHarvest/tree behavior and retry; reconnect/save failure; universal Sunspud timing; pass true/false/error/purchase/rejoin/off-sale/over-cap cases; dynamic price/disclosure; no failure-triggered prompt; serialized profile size; virtualized 200/expanded UI; two five-slot phone pages; modal focus; and later harvest-versus-steal revision races.
- Action required: User selects pass bonus and later price, seed maximum/key, deployed-creature capacity behavior, favorite/lock scope, and later grace duration; Architecture/Data/Security define the schema and entitlement cache; UI prototypes virtualized responsive storage; Performance measures worst case; Monetization preserves neutral presentation; QA writes the acceptance suite before implementation.

## Entry: Sunspud and explicit plant harvest modes

- Date: 2026-07-19
- Agent: Codex / Game Design, Gameplay, Economy, Architecture, Data, UI, and QA Agents
- System affected: Plant catalog, tutorial, growth, harvesting, inventory, vendor actions, placement, fast travel, economy, persistence, and UI
- Situation: The user named the always-stock tutorial plant, clarified that ordinary plants are consumed on harvest, approved a separate backpack beyond the ten quick slots, made Shop/Plot/Sell travel permanently free, and approved optional rather than mandatory placement snapping.
- Decision made: Use `Sunspud` as the original super-common plant that is always in stock and separate from Hearthpetal. Every Sunspud targets roughly 45 seconds to mature. Every plant definition must explicitly declare a server-owned `HarvestMode`: ordinary crops, including Sunspud, default to `SingleHarvest`, while only allow-listed definitions such as trees may use `Regrower`. A `SingleHarvest` transition atomically removes the mature planted instance and grants exactly one harvested output; a `Regrower` retains the parent and advances a server-authored production cycle. The bottom ten slots are quick-access references into the 200-slot authoritative Backpack, while a backpack button opens full storage. Shop, `Your Plot`, and Sell fast travel remain free permanently. Placement is free within the player's valid plot, with one-stud snapping defaulting off, no required plant-to-plant spacing, and exact-transform rejection.
- Reasoning summary: Explicit harvest modes prevent old blanket-regrowth assumptions from leaking into content, while one authoritative inventory avoids duplication between the hotbar and backpack. Permanent free travel and flexible placement preserve the requested low-friction Grow a Garden-like rhythm without copying its creative expression.
- Result: This entry supersedes the earlier blanket renewable-parent rule and resolves the tutorial plant name, universal growth target, quick-bar/200-slot Backpack relationship, travel price, ordinary whole-plant harvest behavior, and placement behavior. Later entries additionally lock the 999 maximum, special-seed and weighted-produce behavior, one-at-a-time tree collection/full retention, deployed-slot rules, five-grant/1,200 capacity maximum, and repeatable Developer Product direction. Sunspud price/yield/art/balance, canonical stack key, product price/ID/headroom/page design, exact caps, and UI copy remain unresolved.
- Test evidence: Direct user decisions on 2026-07-19 plus read-only Architecture/Data/Security, Economy/Game Design, and QA reviews. No implementation, module test, economy simulation, device test, multiplayer test, or Roblox Studio playtest exists.
- Mistakes discovered: Earlier records treated all flora as renewable parents and left the tutorial plant, storage relationship, and harvest behavior unresolved. That assumption conflicted with the user's later explicit single-harvest rule and could have produced an incorrect data schema and economy.
- Recommended future approach: Require `HarvestMode` validation in every plant definition; use `SingleHarvest` as the fail-safe default; preserve immutable item IDs and revision checks; make harvest idempotent and no-loss under full storage; simulate Sunspud profit per minute and tree amortization; and test placement density on low-end devices before setting plot caps.
- Confidence level: High for the approved contract; Medium for balance, storage, and density until tested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff: plant harvest, storage, and tutorial contract

- What changed: Sunspud, its universal roughly 45-second target, explicit `SingleHarvest`/`Regrower` modes, ten quick-access references plus 200-slot Backpack storage, permanently free Shop/Plot/Sell travel, and one-stud snap defaulting off with no required spacing are now approved.
- Why it changed: The user replaced the prior blanket-regrowth assumption and clarified the exact first-session interaction model.
- APIs affected: Future plant definitions, planted-instance state, inventory, hotbar projection, harvest transaction, growth timer, placement, travel, appraisal, sale, and tutorial-state contracts; none exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ArchitectureDecisions.md`, `AgentKnowledge/UIPatterns.md`, `AgentKnowledge/TestingKnowledge.md`, and relevant personal memories.
- New requirements: Definitions declare behavior and schema version; server-authoritative harvest changes one item/location/revision exactly once; hotbar slots reference inventory items rather than duplicating them; full storage cannot destroy an output; free travel never checks currency, Robux, or entitlement; placement validates plot ownership, finite transforms, bounds, safety exclusions, rate limits, and per-plot performance caps.
- Risks: Duplicate or lost harvests, hidden behavior inferred from names/models, Sunspud economic dominance, regrower tree dominance, backpack overflow, hotbar/backpack divergence, exact-position visual stacking, excessive plot density, fast-travel disorientation, and copied reference UI expression.
- Tests required: Definition validation; default/allow-list checks; SingleHarvest and Regrower state transitions; replay/concurrency/full-storage/reconnect cases; inventory-hotbar identity; Sunspud solvency and profit simulation; tree amortization; free-travel authorization and orientation; placement bounds/NaN/rate/density; optional snap; no-required-spacing behavior; device/reduced-motion use; and Studio comprehension playtests.
- Action required: Architecture/Data define the harvest and inventory contracts; Gameplay implements only after acceptance tests exist; Economy balances Sunspud and later trees; UI designs original responsive navigation/hotbar/backpack/vendor interactions; Performance sets measured density caps; QA owns regression evidence.

## Entry: Five-minute tutorial farming hook

- Date: 2026-07-19
- Agent: Codex / Game Design, Gameplay, UI, Economy, and QA Agents
- System affected: Onboarding, first-session retention, plant growth, tutorial economy, pacing, and player comprehension
- Situation: The first Phase 1 question combined the full farming and creature-bonding loop, so the user clarified that the immediate hook must demonstrate the farming premise quickly before players become bored and leave.
- Decision made: Target an approximately five-minute first guided farming cycle using Sunspud, an original super-common plant separate from Hearthpetal that is always in stock and always targets roughly 45 seconds to mature. Guide the player through a breathing Shop button and permanently free fast travel, purchase, a permanently free `Your Plot` return button, ten quick-access references into a 200-slot Backpack, valid free placement with one-stud snap off by default, no required spacing, and exact-transform rejection, plant-icon percentage growth, whole-plant Harvest and server-authored weight reveal, permanently free Sell travel, and the approved vendor actions. Phones page between slots 1–5 and 6–10. Begin wild creature arrivals around minutes 8–10. Use studs across most world and constructed surfaces with tested readability exceptions.
- Reasoning summary: A complete early reward loop gives new players agency and visible progress before ordinary timers or deeper creature ecology ask for more patience.
- Result: The farming tutorial route, Sunspud name/universal roughly 45-second target, broad stud coverage, permanent free visible travel, 200-slot Backpack with ten refs/two phone pages, one-stud snap off, no required spacing, exact-transform rejection, percentage growth, whole-plant harvest/weight reveal, vendor actions, ordinary single-harvest rule, and creature-arrival window are approved. Plant art, seed price/yield, balance, remaining product details, exact vendor wording, first capture timing, and normal pacing remain unresolved.
- Test evidence: Direct user clarifications on 2026-07-19. No prototype, retention analytics, comprehension test, economy simulation, device test, teleport test, reduced-motion review, or Studio playtest exists.
- Mistakes discovered: The earlier question described farming and bonding as one timing target, while the user intended the first five minutes to prove the core farming premise specifically.
- Recommended future approach: Design one distinct always-stock common species with a clear silhouette and low long-term ceiling; make tutorial state and growth server-authored and recovery-safe; keep the ten slots as references into the one authoritative backpack inventory regardless of later capacity or stacking choices; preserve favorite-safe and individual sale paths; add reduced-motion alternatives; and test whether fast travel helps rather than disorients first-time players.
- Confidence level: High for the user-approved hook; Medium for the five-minute target until playtested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff: Tutorial farming hook

- What changed: The first guided farming reward cycle now targets about five minutes with always-stock Sunspud, permanently free UI-directed travel, ten quick-access slots plus backpack storage, optional-snap free plot placement with no required spacing, percentage growth, harvest weight reveal, approved vendor actions, and creature arrivals around minutes 8–10.
- Why it changed: The user wants the premise proven before new players become bored and exit.
- APIs affected: Future tutorial state, seed catalog, growth timer, harvest, sale, and analytics contracts; none exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/TestingKnowledge.md`, and Gameplay/UI/QA/Game Design memories.
- New requirements: Server-authored deterministic tutorial currency/purchase/timing; full farming loop completion; no random blocker; valid in-plot placement; fast travel that preserves state; reduced-motion guidance; favorite-safe selling; no repeatable tutorial economy exploit; skip/resume/reconnect behavior must not lose the plant or reward.
- Risks: Common-plant economic dominance, misleading normal pacing, disorienting teleport, motion sensitivity, UI clutter, ten slots becoming accidental total capacity, invalid overlaps, accidental Sell All loss, repetitive unskippable steps, or device friction.
- Tests required: Completion-time observation; step drop-off; reduced-motion mode; teleport orientation/state; retry/resume/reconnect; duplicate currency/purchase/reward; quick-bar and full-inventory recovery; placement bounds/overlap; growth percentage truth; forged weight/value/step order; favorite-safe Sell All; individual sale accessibility; mobile/controller interaction; comprehension; and tutorial-versus-normal economy simulation.
- Action required: Game Design balances and illustrates Sunspud; Architecture/Data define explicit harvest modes and one authoritative inventory; Gameplay specifies tutorial and fast-travel states; UI designs original responsive/reduced-motion guidance, backpack, and vendor menus; Data/Security own idempotent purchase, weight, growth, harvest, and payout state; Performance proposes measured density caps; QA defines acceptance before implementation.

## Entry: Phase 1 platform and presentation foundations

- Date: 2026-07-19
- Agent: Codex / Game Design, Architecture, UI, Map, and Performance Agents
- System affected: Server scale, devices, source workflow, camera, avatars, audience, art direction, and Phase 1 scope
- Situation: After authorizing Phase 1, the user asked Codex to ask as many questions as needed and answered the first foundation batch.
- Decision made: Target eight-player public servers; optimize both mobile and desktop by treating mobile-safe performance and interaction as the minimum while scaling desktop quality upward; use selective Rojo repository-first source authority; keep standard Roblox third-person camera behavior and standard R15 avatars; design for all ages; and pursue an original classic-Roblox stud-textured garden look influenced by the genre without copying Grow a Garden's protected expression.
- Reasoning summary: These choices preserve the approved eight-plot sanctuary, broad Roblox accessibility, familiar controls, safe collaboration, and the tactile visual language the user wants while leaving room for original plants, creatures, map composition, UI, palette, and polish.
- Result: Phase 1 standards and source-link work may proceed on the dedicated branch. Phase 2 grayboxing, gameplay, final assets, and publishing remain outside the current authorization. The follow-up entry above resolves the first guided farming cycle at about five minutes; stud coverage across most surfaces is approved, while exact readability exceptions remain unresolved.
- Test evidence: Direct user answers on 2026-07-19 plus read-only repository and live Studio preflight. No Rojo sync, gameplay, device, Blender import, multiplayer, or performance test exists.
- Mistakes discovered: The phrase “optimize both” required an explicit scalable-quality interpretation so it would not imply two divergent builds; visual inspiration needs an originality boundary before asset production.
- Recommended future approach: Use one responsive cross-device experience, prove selective repository-to-Studio linkage before source expansion, validate scale with R15 in Studio, and compare selective versus broad stud coverage before locking materials.
- Confidence level: High for the approved choices; Medium for the recommended optimization and stud-coverage implementation until tested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Cross-agent handoff: Phase 1 foundation

- What changed: Phase 1 is authorized with eight-player, cross-device, repository-first, standard-camera, standard-R15, all-ages, and stud-textured visual boundaries.
- Why it changed: Source, scale, performance, and art standards need stable user decisions before tools or assets multiply.
- APIs affected: None yet; no gameplay API, remote, persistence schema, or content registry exists.
- Files affected: `README.md`, `Research/DevelopmentStartPlan.md`, `Research/AmbienceAndArtDirection.md`, shared knowledge, and relevant personal memories.
- New requirements: Selective Rojo ownership must protect the default place; mobile is the performance floor; desktop improvements must be scalable; every visual remains original; R15 and the standard camera define scale tests.
- Risks: Whole-place Rojo ownership, desktop-only art density, copied reference expression, unreadable blanket stud texture, or premature Phase 2 work.
- Tests required: Rojo build/sourcemap and live sync, hierarchy preservation, Edit/Play smoke test, R15 scale capture, stud-coverage comparison, device emulation, real-device follow-up, and measured representative multiplicity.
- Action required: Architecture leads the source-link slice; Map/UI/Performance prepare R15 and device acceptance; Art/Blender work waits for the scale and coverage decision; QA reviews evidence before Phase 1 completion.

## Entry: First-playable emotional contract and Phase 0 completion

> Follow-up (2026-07-19): The user subsequently authorized bounded Phase 1 standards, selective source-link, and import-test work. Phase 2 grayboxing, gameplay implementation, production asset multiplication, and publishing remain unauthorized. Later that day, the user approved competitive capture only while a visitor is wild and unowned, including a 60-second caretaker priority/open-early rule and distinct-contender public round-robin. The no-random-loss and no-forced-PvP promises remain active for owned assets.

- Date: 2026-07-19
- Agent: Codex / Game Design Agent
- System affected: First-playable scope, player loss, offline progress, PvP, cooperation, monetization boundaries, and production gates
- Situation: The final Phase 0 gate required an exact emotional contract after paid true-transfer stealing was assigned to a later update.
- Decision made: Lock the first playable as cozy and theft-free, with generous offline growth, no plant death from absence, no forced PvP, no random loss of plants, creatures, items, or Leafnotes, and cooperation that is optional rather than required. Deliberate player-authorized sale or release remains allowed under the approved disposition rules. Paid true-transfer stealing remains a separately approved later-update exception and is not part of the first playable.
- Reasoning summary: The contract preserves a low-pressure, understandable farming and bonding experience while allowing the later competitive monetization feature to be developed only after ownership, persistence, economy, and trust protections are proven.
- Result: Every listed Phase 0 design gate is user-approved. Phase 0 design is complete; Phase 1 planning, project scaffolding, game code, models, UI, audio, and Studio changes remain unauthorized until a separate user instruction.
- Test evidence: Direct user approval in the project conversation on 2026-07-19. Prior gate records passed targeted searches, strict UTF-8 validation, `git diff --check`, specialist reviews, and independent documentation reviews. No gameplay, economy, device, multiplayer, DataStore, performance, or Roblox Studio test exists.
- Mistakes discovered: The initial emotional-contract proposal treated theft as permanently excluded; user clarification required separating the theft-free first playable from the approved later-update paid true-transfer feature.
- Recommended future approach: Continue only within the authorized Phase 1 gate, translate approved rules into definitions/tests before code, confine competition to wild unowned visitors, and reject absence punishment or unapproved loss of owned value.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: Phase 0 to Phase 1

- What changed: Phase 0 design is complete with an approved first-playable emotional contract and a later-update boundary for paid stealing.
- Why it changed: Production needs a stable, testable design boundary before choosing schemas, module APIs, graybox scope, or asset standards.
- APIs affected: None; no production source scaffold, service, controller, remote, data schema, test harness, or Rojo project exists.
- Files affected: `README.md`, `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/LessonsLearned.md`, `AgentKnowledge/TestingKnowledge.md`, `AgentKnowledge/CodingPatterns.md`, `AgentKnowledge/ImprovementBacklog.md`, `AgentKnowledge/RiskRegister.md`, `AgentKnowledge/AgentScores.md`, and relevant personal memories.
- New requirements: Owned assets remain theft-free, absence-safe, and protected from random loss in the first playable; competition is confined to wild unowned visitors under later-approved disclosed capture rules; all implementation claims require evidence; later-update paid stealing cannot leak into first-playable dependencies.
- Risks: Premature implementation, scope creep, unapproved balance assumptions, incomplete schemas, Studio/repository divergence, weak offline-save semantics, mobile accessibility gaps, performance uncertainty, and later-feature dependencies contaminating the vertical slice.
- Tests required: Documentation/schema validation; one guided-cycle comprehension test; plant growth/offline/harvest transitions; approved capture-state and exact-one ownership tests after the remaining choices; save/load and migration; economy simulation; server validation; multiplayer contention/isolation; mobile/tablet/desktop/controller checks; crowded-plot performance; and Roblox Studio graybox evidence after authorization.
- Action required: Codex requests authorization before Phase 1 work; Game Design and Gameplay Agents produce the smallest measurable vertical-slice specification; Architecture/Data/Security/QA define boundaries and tests before code; Map/UI/Art agents validate scale and device constraints before content production.

## Entry: Paid true-transfer stealing and full ownership rights

- Date: 2026-07-19
- Agent: Codex / Game Design, Monetization, Architecture, Data, Security, and QA Agents
- System affected: Public plots, plants, creatures, inventory, ownership, Robux purchases, Leafnotes, provenance, player trust, and persistence
- Situation: The user requested a paid steal function, clarified that stealing must transfer the one real item without duplication, limited eligibility to assets exposed on the owner's plot, and approved normal ownership and sale rights for the buyer.
- Decision made: Plan a repeatable paid Steal Credit with a proposed 99 Robux base price. A plant is eligible only while planted on its online owner's plot; a creature is eligible only after capture/bonding and while roaming or displayed on that owner's plot. Held, stored, inventory, favorited, or locked assets and wild visitors are ineligible. A successful server-authoritative action transfers the exact persistent item and immutable identity to the buyer's protected inventory, preserving mutations, size, weight, history, and provenance. No duplicate or replacement is created. The buyer may keep the item, place or deploy it again, use its normal functions, or sell it for its server-calculated Leafnote value. The original owner permanently loses ownership but retains journal discovery. A failed or invalidated target does not consume the paid credit.
- Reasoning summary: True one-for-one transfer matches the requested theft fantasy; state-based exposure gives owners a free defense; a durable credit separates Robux receipt delivery from a mutable cross-player target; and atomic ownership movement is necessary to prevent duplication or loss.
- Result: True transfer, exposed-plot eligibility, inventory/held protection, trait preservation, no duplication, full buyer economic rights, and later-update release order are user-approved. This deliberately supersedes the earlier blanket boundaries against theft, paid offensive power, and paid acquisition of mutation/size/weight value for this feature only. Direct Robux-to-Leafnote exchange remains prohibited, but an approved stolen asset may later be sold normally. The base price, Managed Pricing choice, cooldown and grace durations, reservation timing, exact UI, protected item classes beyond those named, private-server behavior, and platform classification remain provisional.
- Test evidence: Direct user clarification and approvals in the project conversation on 2026-07-19, including explicit approval of the later-update release order; current official Roblox documentation review; independent Monetization/Game Design, Architecture/Data/Security, and QA/Player Trust reviews. No implementation, receipt test, policy test, DataStore test, multiplayer test, economy simulation, player-trust test, or Roblox Studio test exists.
- Mistakes discovered: A naive purchase-to-live-target grant cannot safely fulfill a developer-product receipt because the target can change or disappear and the receipt contains no custom target intent. Economic compensation or replacement would create inflation, collusion, or duplication contrary to the approved rule.
- Recommended future approach: Keep the feature out of implementation until the ownership ledger, receipt ledger, policy gate, transfer inbox, cooldown protections, and fault-injection tests exist; seek Roblox policy or Developer Relations confirmation before launch because official documentation does not explicitly classify paid non-consensual transfers.
- Confidence level: High for the user-approved gameplay contract; Medium for platform compatibility until Roblox confirms classification
- Verification status: Verified
- Implementation status: Not yet implemented
- Launch status: Blocked
- Launch blocker: Roblox policy or Developer Relations must confirm the platform classification before launch.

### Cross-agent handoff: paid true-transfer stealing

- What changed: A paid Steal Credit may permanently move one eligible exposed plant or bonded creature between players with full normal ownership and economic rights.
- Why it changed: The user wants a Grow a Garden-like paid stealing risk while preserving a strict no-duplicate transfer.
- APIs affected: Future `MarketplaceService.ProcessReceipt`, `PolicyService:GetPolicyInfoForPlayerAsync`, dynamic product-info pricing, ownership/provenance records, item state revisions, inventory/transfer inbox, plot exposure, creature display state, journal, appraisal, sale, and transaction audit APIs. None exists yet.
- Files affected: `README.md`, `Research/ResearchBaseline.md`, `Research/OriginalGameDirection.md`, `Research/MonetizationAndEvents.md`, `Research/DevelopmentStartPlan.md`, `Research/Sources.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/PlayerFeedback.md`, `AgentKnowledge/ArchitectureDecisions.md`, `AgentKnowledge/SecurityFindings.md`, `AgentKnowledge/TestingKnowledge.md`, `AgentKnowledge/FailedApproaches.md`, `AgentKnowledge/LessonsLearned.md`, `AgentKnowledge/AgentScores.md`, and relevant personal agent memories.
- New requirements: `ProcessReceipt` idempotently grants one buyer-bound nontradeable credit and never directly moves a volatile target; both players and the exact item are revalidated server-side; the exact UUID changes owner once through a durable atomic transaction; no random fallback or duplicate occurs; invalid attempts retain the credit; paid-steal provenance persists; buyer capacity cannot lose the paid grant; both players fail closed on required policy checks.
- Risks: Pay-to-grief behavior, targeted rare-item loss, player churn, collusion, alt abuse, Robux-to-Leafnote value flow, duplicate receipts, double ownership, permanent item loss, target reservation grief, cross-player DataStore races, policy ineligibility, regional price arbitrage, and accidental mobile/controller purchase.
- Tests required: Eligibility matrix; duplicate and replayed receipts; simultaneous thieves; recall/favorite/sell/release/harvest versus reservation; disconnects and server shutdown at every transaction state; stale ownership; full inventory; policy false/failure for either player; regional-price behavior; DataStore fault injection; exact identity/trait preservation; journal retention; cooldown and alt-abuse checks; economy simulation; player-trust playtest; and an invariant proving exactly one owner and one consumed credit.
- Action required: Keep the feature outside the first playable. Architecture and Data Agents design the item-centric ledger and reconciler only after the core ownership/economy foundations are proven; Security Agent threat-models every state and policy check; Monetization Agent confirms transparent dynamic pricing and platform eligibility; UI Agent designs deliberate purchase and victim notices; QA Agent builds adversarial and device coverage; Codex requires a later implementation gate.

## Entry: First-playable harvesting, creature value, and disposition

> Follow-up (2026-07-19): The blanket renewable-parent plant rule in this historical approval was superseded by the later explicit harvest-mode amendment. Current active rule: ordinary plants are `SingleHarvest` and require replanting; only explicitly allow-listed classes such as trees are `Regrower`. Creature disposition rules in this entry remain active.

- Date: 2026-07-19
- Agent: Codex / Game Design Agent, with Economy and Data/Security review
- System affected: Harvesting, inventory, creature traits, Leafnotes, display, storage, release, journal, and persistence
- Situation: Phase 0 required an exact disposition policy, and the user approved the proposed flora rules while adding first-playable creature sales and creature mutations, size, and weight.
- Decision made: Renewable flora outputs can be harvested while the parent plant remains and regrows. Harvests can be sold individually or through `Sell All`, which excludes favorited items. Only bonded, player-owned creatures—not wild visitors—can be displayed, stored, sold, or released. Each creature has persistent server-owned mutation traits, size, and weight that affect its server-calculated Leafnote sale value. Creature sales are individual, require explicit confirmation, and permanently exchange that creature for Leafnotes; release is a separate confirmed action that grants no currency. Favorited creatures cannot be sold or released until unfavorited. Sale or release preserves the species journal discovery. Adapted Seeds can be planted, stored, or favorited but cannot be sold in the first playable.
- Reasoning summary: The policy preserves the familiar harvest-to-sale loop, adds a collectible creature-value chase requested by the user, protects meaningful companions from accidental bulk sale, and keeps release emotionally distinct from sale.
- Result: Flora harvesting/sale, captured-owned-creature sale, value-affecting creature mutation/size/weight, favorite protection including Sell Held, display/storage, release, journal retention, and Adapted Seed disposition are approved. Later decisions lock 200 base slots, five grants/1,200 total, 999 compatible ordinary-seed stacks, special-seed/unique-asset counting, weighted tree produce, one-at-a-time tree collection/full retention, and deployed-slot behavior. Flora output identities beyond the whole-plant/tree-produce boundary, creature mutation catalog and behavior, trait generation, appearance, size/weight units and ranges, exact valuation, prices, yields, timers, canonical stack key, product price/ID/headroom/page design, exact planted/roaming caps, UI, and individual-trait journal retention remain provisional.
- Test evidence: Direct user approval and amendment in the project conversation on 2026-07-19, followed by read-only Economy and Data/Security reviews. No implementation, economy simulation, save/load test, transaction test, UI test, or Roblox Studio test exists.
- Mistakes discovered: The initial proposal prohibited creature sales and was superseded by the user's amendment. Older documentation also restricted Leafnote generation to flora and described creature sales as later or unresolved; those statements required explicit supersession.
- Recommended future approach: Keep plant farming a dependable income source without letting Sunspud or regrowing trees dominate; keep creature sales optional; use original creature mutations and value curves; calculate value only from bounded persisted server data; and make harvest, sale, and release atomic, idempotent, ownership-validated transitions.
- Confidence level: High for the approved design boundary; Medium for future balance until simulation and playtesting
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: harvesting and creature disposition

- What changed: Plant-harvest sale and first-playable bonded-creature sale are approved Leafnote sources; ordinary plants are now single-harvest while explicit classes such as trees may regrow; creature mutations, size, and weight affect individual creature value; disposition protections are locked.
- Why it changed: The first playable needs a Grow a Garden-like sell/reinvest rhythm and a distinctive collectible-creature value layer without enabling accidental loss or client-forged rewards.
- APIs affected: None; no harvest service, inventory service, creature instance schema, appraisal service, transaction API, journal API, UI controller, or persistence implementation exists yet.
- Files affected: `README.md`, `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/PlayerFeedback.md`, `AgentKnowledge/SecurityFindings.md`, `AgentKnowledge/TestingKnowledge.md`, `AgentKnowledge/AgentScores.md`, `AgentKnowledge/LessonsLearned.md`, and the relevant Game Design, Gameplay, Data, Security, UI, QA, and Monetization agent memories.
- New requirements: The server owns plant `HarvestMode`, harvest eligibility, creature identity and ownership, mutation IDs, bounded size/weight inputs, favorite state, disposition state, appraisal, removal, and Leafnote grants. `SingleHarvest` atomically removes the parent and grants one output; `Regrower` retains it and starts another cycle. Harvest `Sell All` excludes favorites and never includes creatures. Creature sale/release uses an owned creature ID and an explicit confirmed request; journal discovery survives either terminal action.
- Risks: Client-forged traits or prices, duplicate payout, sale/release races, wrong-owner sale, favorite bypass, item loss without payout, payout without removal, value overflow or multiplier explosion, farming becoming economically obsolete, and copied reference mutations or formulas.
- Tests required: Definition and bounds validation; `SingleHarvest` removal/grant and `Regrower` cycle transitions; full-storage no-loss; `Sell All` favorite exclusion; save/load and migration round trips for plant behavior and creature identity, provenance, mutations, size, weight, favorite, and state; valuation golden cases and overflow boundaries; wrong-owner and forged-value rejection; idempotent replay; sale/release concurrency; disconnect and uncertain-save recovery; zero-currency release; journal retention; economy simulation; multiplayer isolation; and mobile/tablet/desktop/controller confirmation checks.
- Action required: Gameplay Agent defines the later state transitions; Data and Architecture Agents propose a versioned creature schema and transaction ledger; Security Agent threat-models every remote; UI Agent separates harvest bulk sale from confirmed creature actions; QA Agent builds regression coverage; Monetization Agent prevents paid products from changing mutation, size, or weight generation odds while preserving the separately approved paid true-transfer exception recorded above.

## Entry: Grow a Garden gameplay-rhythm priority reaffirmed

- Date: 2026-07-19
- Agent: Codex / Game Design Agent
- System affected: Core progression, harvesting, economy, onboarding, and feature scope
- Situation: The user asked that Catch a Creature stay as similar to Grow a Garden as practical in gameplay.
- Decision made: Treat the familiar `buy base seed → plant → wait/offline → harvest crop or produce → sell → reinvest → expand` rhythm as the primary progression spine. Ordinary crops are single-harvest; explicitly classified plants such as trees may regrow. Creature observation, bonding, habitat signals, and adaptation add original depth around that spine rather than replacing or obscuring it. Protected names, assets, writing, map expression, UI art, exact balance, and branded content remain original to Catch a Creature.
- Reasoning summary: Familiar loop structure supports immediate comprehension and satisfies the user's reference preference; original creature ecology and presentation preserve the project's own identity.
- Result: The gameplay-rhythm priority is verified stakeholder direction. It does not approve exact reference formulas, probabilities, prices, timers, capacities, copied assets, or one-to-one feature parity.
- Test evidence: Direct user direction in the project conversation on 2026-07-19. No prototype, comprehension test, economy simulation, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. “Similar” must remain a gameplay-structure requirement rather than being misread as permission to copy protected creative expression.
- Recommended future approach: Make the farming loop independently legible and satisfying, then introduce creature layers one step at a time and test whether new players can explain both the basic economy and the sanctuary differentiator.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

## Entry: First-playable clue and bonding interaction

> Follow-up (2026-07-19): The later chance-capture direction supersedes correct Care as the terminal ownership grant. The care choices and no-cost clearer-clue retry remain historical approvals; the recommended `Observe → Care → Trust → Capture → Own` reconciliation awaits explicit user confirmation. See the competitive wild-capture entry at the top of this file.

- Date: 2026-07-19
- Agent: Codex / Game Design Agent
- System affected: Creature encounters, clues, care choices, bonding, UI, persistence, and remote validation
- Situation: Phase 0 required one exact, understandable visitor-inspection and bonding interaction that remains cozy, deterministic, secure, and usable across input devices.
- Decision made: Lock Observe → Care → Bond. Observing a visitor on the player's plot returns two truthful server-supplied visual/text clues. The player chooses Offer Warmth for Cozzle, Echo the Chime for Rillibob, or Give Quiet Shelter for Mossnub. A correct response bonds deterministically after server validation; a wrong response costs nothing, provides a clearer clue, and allows another attempt after a short provisional cooldown without permanent fleeing.
- Reasoning summary: Three legible care responses connect the approved habitat signals to creature understanding, while deterministic bonding and no-loss retries preserve the cozy emotional contract and avoid hidden capture odds.
- Result: The interaction sequence, response identities and mapping, deterministic success, and no-loss retry behavior are approved. Clue wording, animation, timing, cooldown length, capacity behavior, failure presentation, UI layout, interaction presentation, implementation details, and styling remain unapproved.
- Test evidence: Direct user approval in the project conversation on 2026-07-19. No interaction, remote, persistence, device, multiplayer, comprehension, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. The prior checkpoint correctly preserved this proposal as unapproved until explicit confirmation.
- Recommended future approach: Keep encounter state and clue/action definitions server-owned, validate plot ownership and distance, make resolution idempotent, and evaluate a proposed fail-closed safeguard that does not consume the visitor when persistence or capacity state is uncertain. This safeguard is not an approved capacity rule.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: Observe → Care → Bond

- What changed: The first-playable inspection and bonding contract is approved with three mapped care responses, deterministic correct resolution, and no-loss retries.
- Why it changed: The vertical slice needs one complete, understandable creature encounter that rewards observation without random capture odds or punitive failure.
- APIs affected: None; no encounter service, remote, data schema, UI controller, creature state machine, or persistence API exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/LessonsLearned.md`, and the Game Design, Gameplay, Enemy AI, UI, Security, Data, and QA agent memories.
- New requirements: The server owns clues, valid responses, encounter state, cooldown eligibility, bonding resolution, and persistent grants; clients request Observe or one allow-listed care response and render server results.
- Risks: Client-selected clues or rewards, replayed responses, duplicate bonds, resolving another player's visitor, distance spoofing, inaccessible clue presentation, full-capacity loss, and inconsistent device input.
- Tests required: Definition validation, clue truthfulness, correct/incorrect transitions, clearer-clue retry, cooldown boundaries, no permanent flee, plot ownership and distance validation, replay/rate-limit rejection, idempotent bonding, capacity/persistence failure, save/load, multiplayer isolation, and mobile/tablet/desktop/controller interaction checks.
- Action required: Do not implement this historical terminal Bond step. Obtain the remaining capture decisions, then Gameplay/Enemy AI/UI/Security/Data/QA define and test the amended encounter contract.

## Entry: First-playable currency and reinvestment

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: Economy, harvesting, selling, seed acquisition, and first-playable progression
- Situation: Phase 0 required a simple currency relationship that closes the harvest-to-reinvestment loop without premium exchange, maintenance pressure, loss, debt, or passive accumulation.
- Decision made: Lock Leafnotes as the sole first-playable soft currency. Players earn them by selling approved plant harvests—single-harvest crops or produce from explicit regrowers—and approved bonded creatures, then spend them on approved seeds. Leafnotes have no direct premium conversion, upkeep, currency loss, debt, or passive interest.
- Reasoning summary: One bounded soft currency keeps the economic loop readable and server-authoritative while avoiding coercive loss systems and speculative currency infrastructure.
- Result: At the 2026-07-18 approval, the Leafnotes identity and harvest-to-base-seed reinvestment relationship were approved while starter grants, prices, yields, inventory limits, and creature or Adapted Seed sale rules remained unresolved. The 2026-07-19 supersession below approves bonded-creature sale and makes Adapted Seeds nonsellable in the first playable.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No economy simulation, transaction, UI, persistence, security, multiplayer, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. The approval needed to preserve the later disposition gate instead of silently authorizing creature or Adapted Seed sales.
- Recommended future approach: Keep prices and yields in validated server-owned definitions, model every Leafnote mutation as a server transaction, and simulate loop solvency before approving balance values.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: Leafnotes

- What changed: Leafnotes are the approved sole first-playable soft currency with a plant-harvest-to-seed loop and optional individual bonded-creature sales.
- Why it changed: The smallest playable needs a clear reinvestment cycle without multiplying currencies or introducing loss and premium-conversion systems.
- APIs affected: None; no economy service, remote, data schema, inventory contract, shop API, or UI controller exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, and the Game Design, Gameplay, Data, Security, UI, and Monetization agent memories.
- New requirements at the 2026-07-18 approval, as amended on 2026-07-19: The server owns every Leafnote grant and spend; clients cannot select prices, quantities, rewards, or balances; approved plant harvests and individually sold bonded creatures generate Leafnotes; first-playable spending remains limited to approved seeds until expanded by a later decision.
- Risks: Client-authoritative balances, duplicate sales, negative balances, unbounded inflation, unclear no-loss behavior, or accidentally treating creatures and Adapted Seeds as approved sellables.
- Tests required: Definition validation, earn/spend state transitions, replay and rate-limit rejection, insufficient-funds handling, nonnegative balance invariants, save/load round trips, disconnect recovery, economy simulations, and Roblox Studio shop-flow tests.
- Action required: Gameplay Agent defines the later sell/reinvest flow; Data Agent proposes the minimal balance schema; Security Agent threat-models transactions and remotes; UI Agent presents affordability and results; Monetization Agent preserves the direct no-premium-conversion boundary and audits the separately approved paid-steal exception.

### Supersession: creature sales added as a Leafnote source

On 2026-07-19, the user approved sales of bonded, player-owned creatures as a second Leafnote source. The earlier flora-only source restriction is superseded only to that extent. Leafnotes remain the sole first-playable soft currency.

Later on 2026-07-19, the user approved paid true-transfer stealing with full ownership and sale rights. Direct Robux-to-Leafnote exchange remains prohibited, but the buyer may sell an approved stolen asset normally. This is an explicit indirect-value exception; upkeep, currency loss, debt, and passive-interest boundaries remain unchanged.

## Entry: First weather state

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: Weather, lighting, audio, VFX, and first-playable scope
- Situation: Phase 0 required one simple weather state without introducing economy multipliers, paid activation, exclusive rewards, or progression dependencies.
- Decision made: Lock Soft Rain as natural server-wide light rain with softer and cooler lighting, gentle rain ambience, and water ripples. It provides no growth multiplier, rarity boost, paid activation, exclusive creature, or progression requirement.
- Reasoning summary: A synchronized presentation-only state validates the weather architecture and sanctuary ambience without expanding the vertical slice's economy, monetization, or content dependencies.
- Result: Soft Rain's identity, server-wide scope, presentation pillars, and nonfunctional boundary are approved. Duration, frequency, scheduling, transitions, values, particles, audio implementation, and performance budgets remain unapproved.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No lighting, audio, VFX, weather-state, multiplayer, performance, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. The weather scope needed explicit exclusions so a simple ambience state would not silently become a reward or monetization system.
- Recommended future approach: Keep the server authoritative over the weather state and timing, let clients render bounded presentation, and test synchronized transitions and cleanup without economic mutations.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: Soft Rain

- What changed: Soft Rain is the approved first natural, server-wide, presentation-only weather state.
- Why it changed: The first playable needs one coherent weather state while keeping economy, rarity, monetization, and progression behavior out of scope.
- APIs affected: None; no weather module, remote, definition, or rendering API exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `Research/AmbienceAndArtDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, and the Architecture, Audio, VFX, Performance, Monetization, and Game Design agent memories.
- New requirements: The server owns active weather and timing; clients only render the approved presentation; Soft Rain cannot mutate growth, rarity, creature eligibility, purchases, or progression.
- Risks: Unsynchronized transitions, excessive particles or audio, client-authored weather, hidden gameplay effects, and accidental monetization would violate the approval.
- Tests required: Definition validation, server/client state synchronization, join-in-progress behavior, transition cleanup, lighting readability, audio throttling, particle cleanup, multiplayer consistency, and measured Roblox Studio performance.
- Action required: Architecture Agent defines the later weather contract; Audio and VFX Agents propose restrained presentation; Performance Agent measures it; Monetization Agent preserves the no-paid-activation boundary.

## Entry: First Adaptation and Bloommark

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: Adapted Seeds, habitat signals, cosmetic rarity, and first-playable progression
- Situation: Phase 0 required one functional Adaptation and one cosmetic Bloommark that demonstrate the approved separation between ecological function and presentation.
- Decision made: Lock Emberkeep as a Cozzle-influenced Hearthpetal Adaptation that retains warmth and light into early night. Lock Starlace as pale star-thread veins with occasional soft motes and no effect on attraction, growth, yield, sale value, or progression.
- Reasoning summary: Emberkeep closes the creature-to-plant relationship loop with a readable functional change, while Starlace demonstrates cosmetic rarity without selling or multiplying ecological power.
- Result: Emberkeep's functional identity and Starlace's cosmetic-only boundary are approved. Trigger counts, timing, strength, Adapted Seed generation, inheritance, implementation visuals, particle density, rarity, and performance cost remain unapproved.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No gameplay, economy, persistence, VFX, performance, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. Functional and cosmetic approval scopes needed explicit negative rules to prevent Starlace from silently gaining economic or progression value.
- Recommended future approach: Store functional Adaptations and cosmetic Bloommarks in separate validated fields, generate outcomes on the server, and test Emberkeep behavior independently from Starlace presentation.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: Emberkeep and Starlace

- What changed: Emberkeep is the approved first functional Adaptation; Starlace is the approved first cosmetic Bloommark.
- Why it changed: The vertical slice needs one creature-influenced plant function and one clearly nonfunctional rarity treatment.
- APIs affected: None; no module, remote, definition schema, or persistence API exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentMemory/GameDesignAgent.md`, `AgentMemory/GameplayAgent.md`, `AgentMemory/DataAgent.md`, `AgentMemory/VFXAgent.md`, and `AgentMemory/MonetizationAgent.md`.
- New requirements: Future schemas must separate Adaptations from Bloommarks; the server owns generation; Starlace cannot change functional or economic outcomes.
- Risks: Combining both traits in one mutation multiplier, client-selected outcomes, unclear nighttime boundaries, or unbounded motes would violate the approval or create security/performance problems.
- Tests required: Definition validation, server-authoritative generation, day/night boundary behavior, save/load round trips, Adaptation/Bloommark separation, zero Starlace economic effect, effect cleanup, and Roblox Studio readability/performance tests.
- Action required: After explicit Phase 1 authorization, Gameplay and Data Agents define Emberkeep state and persistence; VFX Agent proposes a restrained Starlace treatment after budgets exist; Monetization Agent preserves the no-functional-value boundary.

## Entry: First three creatures

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: First-playable creatures and habitat attraction
- Situation: The approved Habitat Flora trio required three original visitors with readable primary preferences for the Phase 3 attraction loop.
- Decision made: Lock Cozzle with a primary preference for Hearthpetal warmth and light, Rillibob with a primary preference for Ripplecup water and gentle sound, and Mossnub with a primary preference for Nuzzlefern shelter and calming scent.
- Reasoning summary: One clear primary preference per visitor makes the initial habitat-attraction rule legible while leaving later behavior, clue, and balance design open for focused approval.
- Result: The three creature names and primary preferences are approved. Appearance, scale, animation, clues, state transitions, bonding outcomes, utility, rarity, and balance are not approved by this decision.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No gameplay, comprehension, behavior, multiplayer, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. The approval needed a narrow boundary so a preference pairing would not silently approve creature behavior or bonding mechanics.
- Recommended future approach: Define the exact clue-inspection and bonding interaction next, then test whether players can infer each visitor's preferred habitat without reading hidden definition data.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: first creature trio

- What changed: Cozzle, Rillibob, and Mossnub are the approved first-playable visitors, paired respectively with Hearthpetal, Ripplecup, and Nuzzlefern primary signals.
- Why it changed: Phase 0 requires a bounded three-flora, three-creature ecology before behavior, data, UI, or placeholder contracts can be approved.
- APIs affected: None; no module, remote, or data API exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentMemory/GameDesignAgent.md`, `AgentMemory/GameplayAgent.md`, and `AgentMemory/EnemyAIAgent.md`.
- New requirements: Future definitions must preserve these stable names and primary preferences while keeping server authority and data-driven content boundaries.
- Risks: One-to-one preferences could feel automatic or shallow if clues and bonding choices do not add understandable decisions.
- Tests required: Definition validation, attraction eligibility, clue comprehension, deterministic visitor-state transitions, cleanup, multiplayer separation, and Roblox Studio interaction tests.
- Action required: Use the amended wild-capture entry at the top of this file; the historical Observe → Care → Bond terminal contract is not an implementation instruction.

## Entry: First three Habitat Flora

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: First-playable content and habitat signals
- Situation: The Phase 3 loop requires three original Habitat Flora with immediately readable ecological roles.
- Decision made: Lock Hearthpetal for warmth and light, Ripplecup for water and gentle sound, and Nuzzlefern for shelter and calming scent.
- Reasoning summary: The trio supplies three visually and behaviorally distinct signal combinations that can support understandable visitor attraction without requiring a large content catalog.
- Result: The three names and primary habitat signals are approved. No growth timing, yield, price, appearance, attraction strength, or other balance value is approved by this decision.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No gameplay, comprehension, economy, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. The approval needed an explicit boundary so names and signals would not silently lock unreviewed balance or art details.
- Recommended future approach: Pair each launch creature with a readable preference among these signals, then validate the trio through definitions, primitive placeholders, and one guided-cycle comprehension test after later gates approve implementation.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

## Entry: Final game promise

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: Project identity and Phase 0 scope
- Situation: Two compatible but differently scoped promise candidates existed; one included eventual breeding while breeding is deferred from the first playable.
- Decision made: Lock the promise as: “Grow Habitat Flora, attract and understand wild creatures, form bonds, cultivate adapted plant lineages, and transform a small plot into a living sanctuary.”
- Reasoning summary: The approved wording preserves the planting, discovery, bonding, adaptation, and sanctuary transformation loop without implying that deferred breeding belongs in the first playable.
- Result: The final game promise is approved; no implementation was authorized beyond recording this Phase 0 decision.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No gameplay or player-comprehension test exists.
- Mistakes discovered: Earlier promise candidates did not clearly separate the long-term breeding vision from the first-playable identity.
- Recommended future approach: Evaluate every Phase 0 content and interaction decision against this promise; treat breeding as deferred unless separately approved later.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

## Entry: Proven atomic loop

- Date: 2026-07-16
- Agent: Game Design Agent
- System affected: Core progression
- Situation: Grow a Garden research showed that feature breadth is secondary to a legible farming loop.
- Decision made: Preserve planting, waiting/offline progress, harvesting, selling, and reinvestment as the economic backbone while making creature ecology the original differentiator.
- Reasoning summary: Players need an immediately understandable source of progress before learning habitat and creature systems.
- Result: Original closed loop documented.
- Test evidence: Reference research only; our loop requires prototype testing.
- Mistakes discovered: None in implementation; risk identified that creature systems could obscure the simple backbone.
- Recommended future approach: Measure whether a new player can explain the loop after one guided cycle.
- Confidence level: High
- Verification status: Estimated
- Evidence class: Community-derived reference synthesis; local implementation absent

## Entry: Habitat Flora

- Date: 2026-07-16
- Agent: Game Design Agent
- System affected: Plants and creature attraction
- Situation: Ordinary crop reskins would leave the project too close to its references.
- Decision made: Plants create ecological signals and react to creature relationships.
- Reasoning summary: Functional habitats close the loop between farming, catching, care, and collection.
- Result: Habitat Flora roles and Growth Memories defined conceptually.
- Test evidence: Requires prototype testing.
- Mistakes discovered: None yet.
- Recommended future approach: Give every launch plant one visually obvious habitat role and one creature interaction.
- Confidence level: High
- Verification status: Not yet implemented

## Entry: Adaptations versus Bloommarks

- Date: 2026-07-16
- Agent: Game Design Agent / Monetization Agent
- System affected: Mutations, economy, breeding, monetization
- Situation: Paid luck and extreme visual rarity can undermine functional prestige if both use one mutation system.
- Decision made: Separate functional Adaptations from cosmetic Bloommarks.
- Reasoning summary: Paid or event-supported cosmetic discovery can remain exciting without selling ecological power or superior genetics.
- Result: Two-layer mutation vocabulary established.
- Test evidence: Requires economy and UX testing.
- Mistakes discovered: Early brainstorming used “mutation” for both appearance and function, creating ambiguity.
- Recommended future approach: Every trait definition must state whether it is functional, cosmetic, inheritable, tradeable, progression-eligible, and value-bearing.
- Confidence level: High
- Verification status: Not yet implemented

## Entry: Emotional contract

- Date: 2026-07-16
- Agent: Game Design Agent
- System affected: Whole game
- Situation: Grow a Garden 2 demonstrates that theft, defense, and decay change the audience and emotional experience.
- Decision made: Initially target cozy, communal opportunity rather than destructive competition for the first release.
- Reasoning summary: Creature care, plot expression, and shared weather are more coherent when players are not protecting progress from one another.
- Result: At the 2026-07-16 decision, theft, destructive decay, and paid offensive power were deferred.
- Test evidence: Requires player research and prototype feedback.
- Mistakes discovered: None yet.
- Recommended future approach: Treat any future competitive proposal as a new contract requiring explicit approval.
- Confidence level: High
- Verification status: Not yet implemented

### Supersession: paid true-transfer stealing

On 2026-07-19, the user approved paid true-transfer stealing as a narrow later-update exception with free inventory/held/favorite protection, no duplication, and full buyer ownership/economic rights. It is not part of the first playable. Destructive decay and mandatory defense remain outside the approved direction; exact protection timing remains unresolved.
