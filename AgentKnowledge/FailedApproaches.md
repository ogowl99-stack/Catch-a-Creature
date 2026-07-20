# Failed Approaches

## FA-009: Let cosmetics or ambiguous failure controls mutate capture truth

- Date: 2026-07-19
- Agent: Architecture Agent / Security Agent / UI Agent / VFX Agent / Audio Agent / Performance Agent / QA Agent / Codex
- System affected: Retry/Let Go, ownership, queue, cutscene, VFX, audio, camera, accessibility, and cleanup
- Goal: Give failed capture attempts a clear next step and make the rarest success memorable.
- Attempted solution: Auto-retry or reuse a held button; let `Let Go` release the global visitor; play a global or optimistic success cinematic from the client roll result; use capsule/shake/jackpot expression; or leave camera, particles, sounds, and connections active until the sequence happens to finish.
- Why it failed: These patterns can spend unintended items, bypass round-robin, remove another player's opportunity, announce ownership that was never durably saved, imitate another franchise, interrupt unrelated players, trigger photosensitivity concerns, and leak presentation state.
- Symptoms: Duplicate queue entries, extra item consumption, disappearing wild visitor, false success followed by missing inventory, forced camera for observers, stuck input/camera, flashing, stacked audio/particles, or persistent instance/connection growth.
- Performance impact: Unbounded simultaneous hero effects, per-frame replication, global Lighting changes, and missing cleanup can reduce client frame rate and leak memory/connections.
- Security impact: High if client presentation is treated as proof of ownership or can request celebration tier; Medium if duplicate decisions mutate queue/items.
- Files affected: Design and knowledge documents only; no implementation or assets exist.
- Better replacement: Commit one attempt outcome and one personal decision token; personal-only Let Go; deliberate one-intent Retry; durable exact-one ownership before a sanitized idempotent celebration event; local skippable hero sequence; bounded nearby flourish; reduced-motion/low-effect fallbacks; hard cleanup and camera restoration.
- Situations where it may still be useful: A short nonblocking local preview may explain capture eligibility before a roll, but it must never use success language or ownership-only effects.

## FA-008: Interpret immediate retry as overlapping or unbounded capture rolls

- Date: 2026-07-19
- Agent: Codex / Architecture, Security, Data, Performance, Game Design, and QA Agents
- System affected: Capture UX, remotes, RNG, Familiarity, consumables, persistence, contention, VFX, and ownership
- Goal: Remove waiting after a failed capture.
- Attempted solution: Rejected interpretation: accept every click immediately, allow multiple rolls in flight, queue unlimited requests, or let the client raise its own displayed chance before the server commits the prior result.
- Why it failed: It turns no-cooldown pacing into autoclick advantage, duplicate rolls, double consumption/progress, stale odds, write/VFX floods, and possible multiple owners. A failed player can monopolize a public encounter before other eligible players receive the result.
- Symptoms: More RNG calls than committed attempts, skipped Familiarity levels, negative item counts, multiple effects, stale UI, starvation, save throttling, or duplicate ownership.
- Performance impact: Unbounded remote, RNG, DataStore/profile mutation, replication, and VFX work.
- Security impact: Critical risk from replay/new-ID spam, client prediction, race conditions, and denial of service.
- Files affected: Design and knowledge documents only; no implementation exists.
- Better replacement: No artificial post-result timer, but one authoritative in-flight roll, one-use server token, idempotent request, immediate re-enable on durable result, cheap rejection, and a fair bounded pending-intent rule if approved.
- Situations where it may still be useful: Immediate UI response is desirable for nonauthoritative presentation, but it cannot imply or grant another economic/RNG transaction before server resolution.

## FA-007: Treat ultra-low capture odds or familiar franchise expression as the catch design

- Date: 2026-07-19
- Agent: Codex / Game Design, Economy, QA, Architecture, Security, Monetization, and Performance Agents
- System affected: Wild capture, rarity, crafting, originality, economy, retention, monetization, and player trust
- Goal: Add a competitive rarity-based creature-catching moment.
- Attempted solution: Treat the example 0.01% Super Rare number as an approved per-attempt capture chance, blur arrival rarity with capture difficulty, or express the item/presentation as a renamed version of a recognizable spherical capture capsule.
- Why it failed: A 0.01% success chance averages 10,000 attempts and creates severe frustration, camping, consumable pressure, and paid-luck temptation, especially after the visitor was already rare enough to spawn. Conflating two probability stages hides the true acquisition rate. Renaming while copying protected visual/audio/UI expression would not make the work original.
- Symptoms: Thousands of expected attempts, misleading odds, potions becoming mandatory, common farming being displaced by camping, full-storage spending pressure, copied capsule/shake/sound/UI patterns, or IP complaints.
- Performance impact: Unbounded retry spam, capture VFX, remote traffic, persistence writes, and crowded visitor camping.
- Security impact: Very low odds increase exploit incentives; client-supplied odds/modifiers or paid crafting routes create abuse and policy risk.
- Files affected: Design and knowledge documents only; no game code, asset, or Studio content exists.
- Better replacement: Separate `ArrivalWeight` from `BaseCaptureChance`; use an original sanctuary-themed non-ball item and presentation; keep exact odds visible and server-owned; use humane capture ranges and, if approved, persistent Familiarity/hard guarantees; keep capture/luck inputs gameplay-earned and outside every Robux-derived path.
- Situations where it may still be useful: A 0.01% arrival weight may be tested later for an optional spectacle with a sane capture chance and no required progression, but only after spawn frequency and effective acquisition time are simulated and disclosed.

## FA-006: Promise infinitely stackable permanent storage through a game pass

- Date: 2026-07-19
- Agent: Codex / Architecture, Data, Security, Monetization, Performance, and QA Agents
- System affected: Roblox commerce, receipts, inventory persistence, UI, performance, and player trust
- Goal: Let a player repeatedly buy +200 permanent slots without a ceiling.
- Attempted solution: Call the product a stackable game pass and advertise unlimited capacity purchases.
- Why it failed: Roblox passes are one-time privileges, so repeat purchases require a Developer Product. Literal infinity cannot be guaranteed on finite Data Store size/throughput, server memory, replication, indexing, join time, or client UI. Selling beyond a tested deliverable maximum could leave a valid paid receipt without the promised benefit.
- Symptoms: A pass cannot be repurchased; capacity integers/profile payloads grow without a proven bound; join/save/UI time degrades; receipt grant may exceed supported storage; or paid value is clamped/lost.
- Performance impact: Potentially unbounded serialization, save/load work, network payload, batch transactions, memory, and mobile UI cost.
- Security impact: Critical if duplicate receipts double-grant, client events are trusted, or a paid receipt is acknowledged without durable capacity.
- Files affected: Design and knowledge documents only; no product, code, or Studio content exists.
- Better replacement: One repeatable +200 Developer Product, idempotent server `ProcessReceipt`, a durable receipt ledger, finite measured operational maximum, emergency receipt headroom, external sales disabled, paged/virtualized UI, and later ceiling increases gated by evidence.
- Situations where it may still be useful: “Expandable” is an acceptable player-facing concept, but the exact current finite maximum must be disclosed and enforced before every prompt; never claim literal infinity.

## FA-005: Treat full storage or entitlement uncertainty as a loss or upsell trigger

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent / Monetization Agent / Game Design Agent / QA Agent / Codex
- System affected: Backpack capacity, harvesting, Roblox passes, player trust, persistence, and later theft
- Goal: Resolve a full Backpack or uncertain paid entitlement quickly.
- Attempted solution: Design-review rejected patterns included removing/rerolling a harvest, auto-selling or hiding excess items, trusting a client purchase-completion event, acknowledging a receipt before a durable grant, removing capacity without over-cap recovery, or immediately prompting the storage product when an asset is exposed.
- Why it failed: These patterns can lose or duplicate valuable persistent items, forge or revoke a paid benefit incorrectly, pressure players to spend under threat, and violate the approved no-loss/fairness contract.
- Symptoms: Missing plant or produce, changed weight/mutation on retry, over-cap item deletion, paid bonus disappearing during an API outage, repeated purchase prompts, or storage being marketed as theft protection.
- Performance impact: Repeated ownership checks, mass item migration, or unvirtualized over-cap UI could create avoidable latency and memory cost.
- Security impact: Critical risk from client-trusted purchase state, last-slot races, forged capacity, inconsistent ownership, and destructive recovery.
- Files affected: Design and knowledge documents only; no implementation exists.
- Better replacement: Revision-lock slot reservation; full-asset retention; exactly-once Developer Product grants through durable `ProcessReceipt`; a finite tested ceiling; protected over-capacity recovery; neutral store presentation; and free sell/favorite/organize paths.
- Situations where it may still be useful: A neutral player-opened store may show the repeatable capacity product below the tested ceiling, but never as an automatic response to fullness, harvest failure, rare exposure, or theft risk.

## FA-001: Conversation-only memory

- Date: 2026-07-16
- Agent: Codex
- System affected: Documentation and continuity
- Goal: Preserve research for later development.
- Attempted solution: Rely on the ongoing conversation as the primary record.
- Why it failed: Chat history is not a versioned project artifact and cannot be reviewed through Git like source files.
- Symptoms: The local repository remained empty even after substantial research.
- Performance impact: None.
- Security impact: None.
- Files affected: None before this foundation.
- Better replacement: Source-dated Markdown research, shared knowledge, agent memories, and committed decisions.
- Situations where it may still be useful: Temporary brainstorming before synthesis.

## FA-002: Content breadth before core depth

- Date: 2026-07-16
- Agent: Game Design Agent
- System affected: Roadmap
- Goal: Make the game feel rich and viral.
- Attempted solution: Brainstorm breeding, trading, events, monetization, rare weather, and customization before a playable loop existed.
- Why it failed: Ideas created dependencies without evidence that planting, attraction, and bonding were fun.
- Symptoms: Large design surface and unclear first prototype.
- Performance impact: High future risk if implemented simultaneously.
- Security impact: Trading and monetization would expand attack surface prematurely.
- Files affected: Research documents only.
- Better replacement: Smallest complete vertical slice followed by gated depth.
- Situations where it may still be useful: Long-term visioning when explicitly kept outside implementation scope.

## FA-003: Installing GitHub CLI through the Windows installer

- Date: 2026-07-16
- Agent: Codex
- System affected: Development tooling
- Goal: Meet the authenticated GitHub publishing workflow prerequisite.
- Attempted solution: Install GitHub CLI with Winget/MSI.
- Why it failed: The installer remained idle without placing the executable.
- Symptoms: Responsive but stalled `winget` and child `msiexec` processes.
- Performance impact: Temporary background processes only.
- Security impact: None observed.
- Files affected: No project files.
- Better replacement: Official portable GitHub CLI under ignored `.tools/` or Git Credential Manager for Git transport.
- Situations where it may still be useful: Normal interactive Windows environments where MSI installation completes.

## FA-004: Bind a developer-product receipt directly to a live steal target

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent
- System affected: Paid stealing, receipts, ownership, persistence, and recovery
- Goal: Charge once and immediately transfer the plant or creature selected before the Roblox prompt.
- Attempted solution: Treat the buyer's latest client-selected plot target as the item granted by `ProcessReceipt`.
- Why it failed: The receipt contains no trusted custom target intent, and a live target can be stored, sold, released, harvested, re-owned, disconnected, or concurrently reserved while the prompt is open. Retrying the receipt against mutable state can lose the purchase, steal the wrong item, or duplicate ownership.
- Symptoms: Stale-target transfer, indefinite `NotProcessedYet`, random substitution pressure, duplicate payout, double ownership, or permanent item loss.
- Performance impact: Repeated receipt retries and cross-profile lock contention could add unbounded work.
- Security impact: Critical risk of client target forgery, replay, wrong-owner transfer, and paid grant loss.
- Files affected: Design and knowledge documents only; no implementation exists.
- Better replacement: Grant one persistent buyer-bound Steal Credit idempotently, then redeem it through a separate exact-item conditional ownership transaction with a durable ledger and reconciler.
- Situations where it may still be useful: None for persistent paid cross-player items; a direct callback may grant a self-contained buyer-only product that does not depend on live external state.
