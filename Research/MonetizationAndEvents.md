# Monetization and Live Events

- Date: 2026-07-16
- Status: Design guardrails
- Truth labels: Verified for directly cited Roblox platform requirements; Not yet implemented for product and event designs
- Evidence classes: Official source for platform requirements; Experimental design for local proposals

## Monetization promise

> Players may pay for beauty, certainty, convenience, community celebration, and one transparent deterministic true-transfer Steal Credit—but never to alter trait-generation odds, create duplicate value, or obtain exclusive ecological content.

All functionally distinct flora, creatures, habitat roles, adaptations, and breeding traits must remain obtainable for free.

The paid stealing exception was approved on 2026-07-19. It can transfer an existing mutation/size/weight outcome with normal economic rights, but it cannot improve generation odds, create traits, strengthen traits, or create an additional copy.

Shop, `Your Plot`, and Sell fast travel are permanently free navigation functions. They must never require Leafnotes, Robux, a pass, a developer product, a subscription, or another entitlement.

## Repeatable permanent storage expansion

The user replaced the earlier one-time pass direction with repeatable permanent +200 capacity purchases. Roblox documents Developer Products—not passes—as the product type a player may buy multiple times. One allowed Developer Product will therefore grant one permanent +200 capacity unit through the server's idempotent `ProcessReceipt` callback. Five purchases/1,200 total slots is the approved launch operational maximum. Exact runtime price, product name/ID, proof that the approved maximum is safe to deliver, and emergency receipt headroom remain provisional. Literal “infinite” storage must not be advertised because platform storage, throughput, memory, replication, and device/UI limits are finite.

Required boundaries:

- Query and display current product information, price, exact +200 benefit, current capacity, resulting capacity, and current tested maximum; do not hard-code a Robux price in UI.
- Grant only through server `ProcessReceipt`. A unique `PurchaseId` durably increments the permanent grant count exactly once; duplicate/replayed/out-of-order receipts return the prior decision without another increment.
- Return `NotProcessedYet` when the profile or grant cannot be durably updated. `PromptProductPurchaseFinished` is never proof of purchase.
- Disable external sales and allow one outstanding in-game storage prompt per player. Stop prompts before the measured maximum and retain tested headroom for a late valid receipt.
- Never delete, hide, auto-sell, or push items onto a plot because capacity or entitlement state changes. Use protected over-capacity recovery that permits slot-reducing actions and blocks new slot additions.
- The product changes Backpack capacity only. It cannot change hotbar size, plot density, active-creature limits, growth, yield, traits, mutation/weight odds, sale value, travel, or theft protection.
- Never prompt the product because a harvest fails, storage is nearly/full, a valuable plant or creature is exposed, or theft is possible. Free selling, organization, favorite/lock protection, and truthful status come first.
- The base 200 slots must support the tutorial, ordinary progression, and first-playable collection without purchase.

The user approved five purchases at launch, producing 1,200 total slots. This is the launch operational maximum, not a measurement claim: store exposure remains blocked until 1,200-slot persistence/UI/load testing and separate emergency receipt headroom prove that every prompted purchase can be delivered. Future increases require the same safety and player-trust gates.

Sources: [Roblox Developer Products](https://create.roblox.com/docs/production/monetization/developer-products), [Roblox Data Store limits](https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits), and [Roblox monetization guidance](https://create.roblox.com/docs/production/monetization).

## Recommended product families

- Guaranteed cosmetic cultivars with clearly displayed outcomes
- Creature accessories, poses, and harmless trails
- Plot themes, decorations, palettes, and photo tools
- Additional saved layout presets and presentation storage
- Fixed-content care supplies with bounded routine-growth acceleration
- Community weather sponsorship that benefits the entire public server
- Cosmetic Bloommark discovery support with complete numerical disclosure when randomness is involved

## Paid-random-item boundary

Roblox explicitly treats paid prize wheels, luck boosts, pity systems, rerolls, enhanced drops, and rate-up effects as paid random items. Before purchase or activation, every final outcome and its actual numerical probability must be disclosed. Active modifiers require dynamically updated true odds.

The experience must check `PolicyService:GetPolicyInfoForPlayerAsync()` and honor `ArePaidRandomItemsRestricted` and `IsPaidItemTradingAllowed`. If policy information cannot be obtained, paid randomness should fail closed.

Source: [Roblox paid random items policy](https://create.roblox.com/docs/production/monetization/paid-random-items)

### Free-only wild-capture boundary

The user approved a leaf-shaped Haven Tag plus craftable Luck and Super Luck aids for the chance-based capture system. Each player may select at most one free next-valid-attempt aid. Every valid accepted attempt consumes one Haven Tag and the selected aid, if any, while rejected/full/stale/busy/lost-race traffic consumes nothing. The approved personal Familiarity system adds two absolute points per committed failure and guarantees capture on tier attempts 2/3/5/8/15/25. Retry defaults to No Aid and Luck selection is disabled on guaranteed attempts so an aid cannot be wasted. For the first implementation, every Haven Tag, luck aid, and required ingredient must be gameplay-earned through a dedicated account-bound path, nontradeable, nonstealable, and unavailable through Robux, Robux-purchased currency, passes, Developer Products, subscriptions, paid events, paid boosts, or resources created by paid stealing. The game discloses the exact server-computed base and final capture odds, Familiarity contribution, guarantee progress, valid-roll item cost, and deliberate Retry/Let Go choice. No purchase prompt appears on failure, retry, Let Go, guarantee progress, or the rare-success celebration.

If any paid or indirectly paid path later modifies capture chance, arrival chance, pity, rerolls, attempt count, crafting access, or ingredient acquisition, it reopens the paid-random-item review, dynamic numerical disclosure, `ArePaidRandomItemsRestricted`, and possibly paid-item-transfer restrictions. No paid luck is approved.

## Community Weather Calling

A player may eventually sponsor a public-server phenomenon. The whole server experiences the same visual weather and capped opportunity. The purchaser receives recognition, not a stronger private multiplier.

Proposed safeguards:

- Natural and free cooperative activation paths also exist
- Exact weather odds, duration, queue behavior, and effects are visible before purchase
- Weather cannot overwrite, stack with, or shorten an active event
- A buyer leaving does not cancel a paid activation
- Each player receives the same bounded number of eligible interactions
- Paid weather cannot create tradeable functional jackpots or exclusive creatures
- Resulting premium-influenced cosmetics are account-bound until policy and trading reviews are complete
- Rare events such as Crown Eclipse are memorable spectacles, not required progression

Server-wide paid randomness has unresolved provenance and eligibility questions for non-purchasing players. It requires a separate implementation review before approval.

## Paid true-transfer stealing

The user approved the gameplay contract on 2026-07-19:

Release order amended by the user on 2026-07-20: conditional initial-public-release target, implemented only after core farming, inventory, immutable identity, ownership, persistence, appraisal, ordinary selling, and generic receipt handling are proven. It is not part of the smallest internal first-playable prototype. It remains feature-flagged off and blocks public launch until policy classification, free protection, cross-profile recovery, anti-abuse limits, economy/trust stop metrics, and closed multiplayer validation pass.

- One repeatable purchase grants one persistent, buyer-bound, nontradeable Steal Credit.
- The proposed base price is 99 Robux. Final pricing, Managed Pricing, and regional transfer controls remain provisional.
- The exact selected plant or creature is disclosed; no random target or fallback is permitted.
- Plants qualify only while planted on the online owner's plot. Creatures qualify only after capture/bonding and while roaming or displayed there.
- Held, stored, inventory, favorited, or locked assets and wild visitors do not qualify.
- One successful action moves the exact persistent item into the buyer's protected inventory with traits, size, weight, history, and provenance unchanged.
- No duplicate, replacement, victim Leafnote payment, or paid shield is created.
- The buyer may keep, place, deploy, use, or sell the stolen asset normally. This is an explicit indirect premium-to-economic-value exception; direct Robux-to-Leafnote exchange remains prohibited.
- Invalidated or failed targets do not consume the credit. Free grace periods and anti-chain protections are required, with exact durations provisional.

Implementation must conservatively treat the action as a paid cross-player item transfer: check both players' `IsPaidItemTradingAllowed` status, fail closed when policy lookup fails, display the runtime product price, and preserve paid-steal provenance. Exact-target selection is deterministic; any future random fallback would reopen paid-random-item requirements. Official documentation does not explicitly confirm paid non-consensual transfer classification, so Roblox policy or Developer Relations confirmation is required before launch.

## Receipt and pricing requirements

Repeatable purchases must be granted through `MarketplaceService.ProcessReceipt`, never client-reported completion or `PromptProductPurchaseFinished`. Grants must be server-authoritative, idempotent, persistent, and recoverable after disconnects.

Displayed Robux prices must be queried dynamically to respect managed and regional pricing.

Sources:

- [Developer products](https://create.roblox.com/docs/production/monetization/developer-products)
- [Regional pricing](https://create.roblox.com/docs/production/monetization/regional-pricing)
- [Roblox monetization guidance](https://create.roblox.com/docs/production/monetization)

## Event lessons

Grow a Garden's strongest event pattern is:

`scheduled world state -> normal resources gain event meaning -> bounded contribution -> visible shared transformation -> guaranteed personal progress`

Representative reference structures include hourly mutation windows, contribution carts, processing machines, evolving landmarks, global unlocks, and developer-hosted update spectacles.

## Original event frameworks

### Whispering Migration

A scheduled migration brings creature families that respond to habitat composition, calls, food, water, light, and shelter. Players inspect clues and prepare the right response.

### Great Sanctuary Restoration

The server completes normalized care and research tasks to restore a central living habitat through visible stages. Every contribution produces personal progress; no top-contributor functional prize exists.

### Community Weather Calling

Natural, earned, or sponsored phenomena change the entire public server. Paid activation is community patronage, not private power.

### Growth Memory Surge

Weather changes creature-plant interactions and can produce Growth Memories or cosmetic Bloommarks.

### Lostling Emergency

Unusual visitors arrive with ambiguous symptoms. Players use the clue and care systems to diagnose, help, bond, or release them.

### Nursery Constellation

A later lineage festival challenges players to create healthy, visually distinct families without selling breeding luck.

### Caretaker Festival

A developer-hosted celebration uses scripted phenomena, votes, migrations, cooperative activities, and multiple time-zone windows. Attendance-only rewards remain cosmetic; functional content receives a catch-up path.

## Live-event rules

- One temporary event currency maximum
- One personal track and one shared objective
- Overflow contributions roll forward
- Normalized tasks prevent veteran inventories from dominating
- No rank-one functional reward
- Missed scheduled windows have replay or banked catch-up paths
- Functional creatures and plants are not permanently attendance-exclusive
- One polished event should deepen a permanent system
- Avoid weekly replacement cadence until saving, economy, rollback, and testing are proven
