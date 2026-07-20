# Testing Knowledge

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

No game tests exist because no game has been implemented. Repository documentation validation was recorded in the research foundation and is detailed in the completed entry below.

Document type: Test backlog and baseline guidance, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.

## Knowledge entry: Phase 1 test-first gate

> Follow-up (2026-07-19): Phase 1 standards and source-link work are now authorized. The test-first requirements remain active; Phase 2 grayboxing and gameplay implementation are not authorized.

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
