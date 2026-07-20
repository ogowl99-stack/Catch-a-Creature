# Original Game Direction

- Date: 2026-07-16
- Status: Phase 0 design complete; implementation details provisional
- Truth label: Not yet implemented

## Final game promise

> Grow Habitat Flora, attract and understand wild creatures, form bonds, cultivate adapted plant lineages, and transform a small plot into a living sanctuary.

- Approval: Direct user approval on 2026-07-18
- Scope note: Breeding remains deferred and is not part of the first-playable promise.

## Emotional contract

Approved for the first playable on 2026-07-19:

- Cozy and welcoming
- Cute but not visually noisy
- Discovery-driven rather than combat-driven
- Communal at its core, with competition limited to clearly wild and unowned visitors under disclosed capture rules
- Generous to offline and free-to-play users
- Rare outcomes feel like stories and trophies, not only economic multipliers
- Owned assets remain theft-free in the first playable; wild visitors can be contested before ownership
- Plants do not die because a player is absent
- No random loss of owned plants, owned creatures, items, or Leafnotes; a failed wild-capture roll does not remove something the player already owns
- Cooperation is available but never required for ordinary progression
- Deliberate player-authorized sale or release follows the approved disposition rules and is not treated as random loss

The first-playable emotional contract is locked for owned assets. Wild-capture competition exists only before ownership; the 60-second caretaker priority/open-early rule and distinct-contender public round-robin are approved. Exact offline caps, growth timers, tutorials, social rewards, and presentation remain provisional. The user approved paid true-transfer stealing on 2026-07-19 as a separate later-update exception; it is not part of the first playable. That later contract must account for voluntary plot exposure, free protection through held/inventory/favorite states, and permanent loss of an exposed stolen asset. Exact protection pacing remains unresolved.

## Core loop

The user reaffirmed on 2026-07-19 that the familiar Grow a Garden gameplay rhythm should remain the primary benchmark. The farming spine must stay prominent and easy to understand: `buy base seed → plant → wait/offline → harvest crop or produce → sell → reinvest → expand`. Creature ecology adds original depth around this spine; it does not authorize copied names, assets, writing, map expression, UI art, exact balance, or branded content.

## First-session tutorial flow

Approved direction through 2026-07-19:

1. A visually breathing/bouncing Shop button draws attention without blocking the player. A reduced-motion equivalent must use a static highlight.
2. Selecting Shop fast-travels the player to the seed shop and guides them to buy Sunspud, a new original super-common plant that is always in stock and separate from Hearthpetal.
3. After the shop closes, a `Your Plot` button fast-travels the player to their assigned garden.
4. A bottom-center ten-slot quick-access bar references the player's 200-slot Backpack; phones show stable slots 1–5 and 6–10 as two pages. Selecting Sunspud enters free placement mode anywhere valid inside the player's plot. A one-stud snap toggle defaults off; there is no required spacing, but the exact identical transform is rejected.
5. A plant-icon growth display shows progress as a percentage until it reaches 100%. Every Sunspud targets roughly 45 seconds to mature; exact world-versus-HUD placement remains unresolved.
6. At maturity, a Harvest button moves the entire server-authored weighted ordinary plant into Backpack. Trees remain planted and grant separate produce one selected item at a time. If no storage slot is available, the exact mature plant or selected ripe produce remains unchanged on the plot for a later attempt.
7. A permanently free Sell button fast-travels the player to the vendor. The three top-level actions are `Sell the Item I'm Holding`, `Sell All Unfavorited Harvests`, and `Appraise`; Appraise contains held-item value and whole-inventory value.
8. Wild creatures begin arriving around minutes 8–10, after the farming premise has been demonstrated.

The first buy-to-sale tutorial target is about five minutes. Shop, `Your Plot`, and Sell travel remain visible during ordinary gameplay and permanently free after onboarding. The ten assignments are quick access rather than storage. Base Backpack capacity is 200 occupied slots. Compatible ordinary seeds stack to 999; trait-bearing/Adapted Seeds are individual unless their complete canonical payloads match; unique weighted/mutated whole plants, weighted tree produce, and stored creatures are individual. Planted crops and roaming/displayed owned creatures consume separate capped plot slots rather than Backpack slots. Full storage retains the exact plant or selected produce; it blocks a wild capture before RNG or item consumption and leaves that visitor wild. An already-owned creature that cannot be recalled stays owned on the plot. Free favorite/lock stays available, but there is no special storage-resolution grace before ordinary later theft eligibility. Repeatable permanent +200 capacity uses a Developer Product, with five purchases and 1,200 total slots approved as the finite launch maximum subject to measurements and emergency receipt headroom. No Robux prompt may be triggered by a failed harvest, failed capture, full Backpack, expiring priority window, or theft risk.

The following full-loop outline uses the user-approved Trust/capture reconciliation:

1. Obtain or buy a Habitat Flora seed.
2. Plant it and let it grow online or offline.
3. The plant creates habitat signals such as food, shelter, warmth, light, water, scent, or sound.
4. A compatible wild creature visits the plot.
5. The player inspects tracks, posture, calls, appetite, and plant interactions.
6. The player chooses the correct care response and earns personal Trust/capture eligibility.
7. The player uses a leaf-shaped Haven Tag; one disclosed server-authoritative chance roll can create exactly one owned bond.
8. On a valid failure, the player deliberately chooses `Retry Capture` under fair round-robin or `Let Go` while retaining personal Familiarity; the visitor stays wild.
9. A qualifying rare success is durably owned before an original skippable celebration begins.
10. Repeated creature-plant interactions create Growth Memories and Adapted Seeds.
11. The player sells plant harvests and optionally bonded creatures for Leafnotes, buys more seeds, and plants or preserves adapted lineages.
12. More specialized habitats attract rarer and more complex visitors.

## First-playable Habitat Flora

The first three Habitat Flora and their primary signals were approved on 2026-07-18:

- **Hearthpetal:** warmth and light
- **Ripplecup:** water and gentle sound
- **Nuzzlefern:** shelter and calming scent

Their names, primary signals, and ordinary `SingleHarvest` classification are locked. Their species-specific growth timing, stages, prices, appearance details, and balance remain provisional; ordinary harvest moves each entire weighted plant into Backpack.

## First-playable creatures

The first three creatures and their primary Habitat Flora preferences were approved on 2026-07-18:

- **Cozzle:** prefers Hearthpetal warmth and light
- **Rillibob:** prefers Ripplecup water and gentle sound
- **Mossnub:** prefers Nuzzlefern shelter and calming scent

Their names, primary preferences, and the care-to-capture sequence below are locked. Appearance, scale, animation, exact clue language, broader visitor behavior, utility, species rarity assignment, and arrival balance remain provisional until separately approved.

## First-playable clue, trust, and capture interaction

The earlier **Observe → Care → Bond** terminal rule was superseded by the user-approved **Observe → Care → Trust → Capture → Own** sequence:

1. The player approaches a visitor on their plot and uses `Observe`.
2. The server supplies two truthful visual/text clues for the current visitor state.
3. The player chooses one of three care responses:
   - **Offer Warmth** for Cozzle
   - **Echo the Chime** for Rillibob
   - **Give Quiet Shelter** for Mossnub
4. The correct response deterministically records personal `Trusted`/capture-eligible state after server validation. It does not grant ownership.
5. A wrong response costs nothing, reveals a clearer clue, and permits another Care attempt after a short cooldown. It never consumes a capture item and does not permanently drive the visitor away.
6. A capture-eligible player uses a leaf-shaped `Haven Tag`, placed near the visitor with a ribbon of sanctuary light. It must not copy a spherical capsule, name, art, animation, sound, or UI expression from another creature-collection franchise.
7. The server discloses the actual final chance, validates the encounter, personal eligibility, access, distance, item, one-in-flight availability, revision, and Backpack space, then resolves at most one atomic attempt. The client never supplies rarity, odds, modifiers, roll, or ownership.
8. The creature stays wild and unowned until one successful attempt durably creates exactly one owned creature. If Backpack capacity is unavailable, the server performs no roll and consumes no item; the visitor remains wild for eligible players.
9. The plot caretaker has 60 seconds of exclusive first-welcome priority and may open capture early. After priority, the encounter is public for five minutes and requires physical proximity.
10. The first tutorial capture is guaranteed. Later base capture chances are Common 95%, Uncommon 80%, Rare 55%, Epic 30%, Legendary 12%, and Mythic 3%.
11. Every valid accepted attempt, including success, consumes one Haven Tag and the selected free Luck aid, if any; rejected/full/stale/busy/out-of-range/expired/lost-race requests consume nothing. Failure does not change or remove the visitor. There is no post-result gameplay cooldown or automatic repeat.
12. The visitor's visible mutation, size, and weight are fixed before capture and transfer unchanged on success. Failure never rerolls them.
13. Familiarity is keyed per player × stable creature-definition ID × rarity tier, adds two absolute percentage points per committed failure, guarantees Common/Uncommon/Rare/Epic/Legendary/Mythic success on attempts 2/3/5/8/15/25, persists across visitors/rejoins/another winner, and resets only when that player captures the matching creature-definition ID.
14. After a durable failure, `Retry Capture` deliberately requests another turn, defaults to No Aid, and in public contention joins behind distinct eligible contenders already waiting or begins immediately when nobody waits. Luck selection is disabled on a guaranteed attempt. `Let Go` closes only that player's current capture flow, consumes nothing further, preserves Familiarity, and leaves the visitor wild/public. During caretaker priority it preserves the remaining exclusive window; `Open to Everyone` is the separate early-open control.
15. Luck and Super Luck are free, craftable, next-valid-attempt aids. At most one applies to an attempt.
16. Mythic is the approved super-rare celebration tier; no seventh tier is added. Only after one owned creature is durably committed, play an approximately five-second immediately skippable capturer-local Haven Tag glow → leaf/constellation sanctuary ribbon → trait-colored motes → voluntary sanctuary-mark acceptance → field-journal reveal. Nearby players see only a restrained brief flourish; Legendary receives a shorter two-to-three-second flourish; Full/Short/Off and Reduced Motion settings are supported.

The sequence, personal Care requirement, priority/open timing, tutorial guarantee, Haven Tag expression, base capture table, all accepted-attempt consumption, no-cooldown deliberate retry, exact Familiarity key/increment/guarantees/persistence/reset, distinct-contender round-robin, Retry/Let Go including caretaker-priority behavior, No Aid retry default, guaranteed-attempt Luck disabling, five-minute public lifetime, proximity, fixed visible traits, free next-attempt Luck boundary, starting creature caps, Mythic/Legendary celebration tiers, and exact visual sequence/duration/audience/settings are user-approved. `0.01%` is not a capture chance and may only be considered later as an optional arrival-weight experiment. Exact arrival tables, Luck formula/recipes, technical in-flight completion grace, audio, assets, and measured budgets remain provisional. Immediate retry never means overlapping rolls, automatic repeat, or client-authored results.

## Plant roles

Habitat Flora can:

- Produce food scents
- Form nests or resting hollows
- Store and release water
- Generate warmth or light
- Record and replay creature calls
- Reveal hidden tracks or markings
- Calm frightened visitors
- Change form after repeated creature interaction

Plants are ecological tools, collectibles, plot decorations, and lineage carriers. They should not be fantasy reskins of ordinary vegetables with only higher sell values.

## Creature roles

Creatures can:

- Visit based on habitat composition
- Express readable clues and needs
- Pollinate, nest, burrow, forage, sleep, sing, or carry seeds
- Modify plant behavior and appearance
- Provide bounded sanctuary utility
- Carry inheritable cosmetic and behavioral traits
- Be bonded, displayed, stored, released, or sold through the approved first-playable disposition rules; breeding remains deferred

## Adaptations and Bloommarks

Two mutation layers prevent power and presentation from becoming confused:

- **Adaptations:** functional ecological changes earned through gameplay. They can affect habitat signals, creature compatibility, or plant behavior.
- **Bloommarks:** rare cosmetic changes such as color, geometry, glow, particles, patterns, and sounds. They do not change sale value, breeding power, or creature rarity.

First-playable approvals from 2026-07-18:

- **Emberkeep Adaptation:** a Cozzle-influenced Hearthpetal retains its warmth and light signal into early night.
- **Starlace Bloommark:** pale star-thread veins with occasional soft motes. It is purely cosmetic and does not affect attraction, growth, yield, sale value, or progression.

The Emberkeep function and Starlace cosmetic-only boundary are locked. Trigger counts, duration, signal strength, Adapted Seed generation, inheritance, exact visual treatment, particle density, and performance cost remain provisional until separately approved and tested.

## Breeding concept

Breeding is a later system. Compatible parents, a breeding habitat, care quality, and environmental history influence offspring. Inheritance should favor readable trait combinations rather than unlimited multiplier stacking.

Paid purchases must never increase functional breeding odds, offspring power, mutation strength, or exclusive genetics.

## Plot identity

Players should be able to build recognizable sanctuary styles through:

- Original terrain and fence themes
- Paths, water features, lanterns, benches, nests, and shelters
- Habitat-specific flora groupings
- Creature accessories and resting areas
- Lighting and ambient presets within safe readability limits
- Saved layout presets after the core build system is stable

## First-playable weather

**Soft Rain** was approved as the first weather state on 2026-07-18.

- Natural and server-wide
- Light rain with softer and cooler lighting
- Gentle rain ambience and water ripples
- No growth multiplier, rarity boost, paid activation, exclusive creature, or progression requirement

The weather identity and nonfunctional boundary are locked. Duration, frequency, scheduling, transition timing, exact lighting values, particles, audio implementation, and performance budgets remain provisional until separately approved and tested.

## First-playable currency and reinvestment

**Leafnotes** were approved as the sole first-playable soft currency on 2026-07-18.

- Earned by selling approved plant harvests
- Earned by individually selling bonded, player-owned creatures under the confirmed disposition rules
- Spent on Hearthpetal, Ripplecup, and Nuzzlefern seeds
- No direct premium-currency conversion; the separately approved paid-steal exception can acquire an existing asset that may later be sold normally
- No upkeep, currency loss, debt, or passive interest

The currency identity, approved flora and creature sale sources, base-seed reinvestment relationship, 200-slot base Backpack, and five-purchase/1,200-slot launch capacity maximum are locked. Capture starting caps of two wild and six displayed owned creatures per plot/64 simulated per server are approved but unmeasured. Starter grants, prices, yields, canonical stack key, repeatable capacity-product price/ID/emergency headroom/page design, exact plant/other deployed caps, and exact value formulas remain provisional until separately approved and tested.

## First-playable harvesting and disposition

The harvesting, creature-value, and disposition rules were approved on 2026-07-19 and amended later that day:

- Ordinary crop definitions, including Sunspud and non-tree Habitat Flora, are single-harvest: harvesting removes the mature plant and the player must plant another seed.
- Only explicitly classified regrowing plants, such as trees, remain planted and generate another harvest. Regrowth is opt-in per server-owned definition rather than the default.
- Plant harvest items can be sold individually or through favorite-safe `Sell All Unfavorited Harvests`.
- Sell Held cannot sell a favorited item until the player intentionally unfavorites it.
- Tree produce is collected one item at a time. If Backpack capacity is unavailable, the exact selected produce remains unchanged on the tree.
- Only a successfully captured, player-owned creature can be displayed, stored, sold, or released. A wild visitor cannot be sold.
- Creature mutations, size, and weight are persistent server-owned traits that affect the server-calculated Leafnote sale value of that individual.
- Creature sales are individual and explicitly confirmed; creatures are excluded from the general harvest `Sell All` action.
- Selling permanently exchanges the creature for Leafnotes. Releasing is separately confirmed, permanently removes the creature, and grants no currency.
- A favorited creature cannot be sold or released until the player intentionally unfavorites it.
- The species journal discovery survives sale or release.
- Adapted Seeds can be planted, stored, or favorited but cannot be sold in the first playable.
- Replanting and explicitly regrowing plants together form the dependable farming income source; creature selling is optional and must not make farming obsolete.

The plant harvest-mode catalog beyond the approved ordinary/tree boundary, exact tree catalog, mutation catalog, mutation sources and odds, stacking and inheritance, functional effects, exact visuals, size/weight units and ranges, valuation formulas and rounding, base prices, yields, growth/regrowth timers, canonical seed stack key, repeatable capacity-product price/ID/emergency headroom/page design, exact plant/other deployed caps, journal retention of exact individual traits, and UI presentation remain provisional. The 200-slot base Backpack, five-purchase/1,200-slot launch maximum, 999 compatible ordinary-seed maximum, special-seed/unique-asset counting, weighted tree produce, one-at-a-time tree collection/full selected-produce retention, deployed-slot behavior, capture starting caps of two wild/six displayed owned per plot and 64 simulated per server, free favorite/lock including Sell Held, and no storage-resolution grace are locked. The creature caps are unmeasured and may be lowered after testing. Paid products will not change mutation, size, weight, arrival, or capture odds, ranges, strength, or valuation formulas; the separately approved paid-steal exception may transfer an already-generated asset at its existing value. The approved Starlace plant Bloommark remains cosmetic-only and has no economic effect.

## Paid true-transfer stealing

The gameplay contract and later-update release order were approved on 2026-07-19; price remains provisional:

- A repeatable paid purchase grants one persistent, buyer-bound Steal Credit. The proposed base price is 99 Robux, but the final configured and displayed price is not yet locked.
- The owner and buyer must be present in the same eligible live server.
- A plant is eligible only while planted on its owner's plot.
- A creature is eligible only after capture/bonding and while roaming or displayed on its owner's plot.
- Held, stored, inventory, favorited, or locked assets and wild visitors are not eligible.
- The server transfers the exact persistent item to the buyer's protected inventory. Its immutable ID, mutations, size, weight, history, origin, and paid-steal provenance remain attached.
- The original owner permanently loses that item. No duplicate, replacement specimen, or Leafnote compensation is created; species journal discovery remains.
- The buyer receives normal ownership rights and may keep the item in inventory, place or deploy it again, use its normal functions, or sell it for its server-calculated Leafnote value.
- If the target is invalidated or the transfer cannot safely commit, the item stays with its owner and the buyer keeps the paid credit for another exact eligible target. There is no random substitute.
- Free grace periods, rate limits, per-victim cooldowns, and post-theft protection are required; exact durations remain provisional. Paid shields are not approved.

This approval intentionally permits paid acquisition of an existing item's economic value, including mutation, size, and weight value. It does not allow paid changes to trait-generation odds or strength. The feature is deferred until a later update after the core farming, inventory, ownership, persistence, appraisal, and ordinary selling systems are proven. Exact product price, Managed Pricing behavior, protected content classes, reservation timing, cooldowns, private-server behavior, UI, and platform classification remain provisional. Roblox policy confirmation is required before launch.
