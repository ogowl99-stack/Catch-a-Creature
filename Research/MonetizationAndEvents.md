# Monetization and Live Events

- Date: 2026-07-16
- Status: Design guardrails
- Truth labels: Verified for directly cited Roblox platform requirements; Not yet implemented for product and event designs
- Evidence classes: Official source for platform requirements; Experimental design for local proposals

## Monetization promise

> Players may pay for beauty, certainty, convenience, and community celebration—but never for superior genetics, exclusive ecological power, or ownership of the most prestigious discoveries.

All functionally distinct flora, creatures, habitat roles, adaptations, and breeding traits must remain obtainable for free.

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
