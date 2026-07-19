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
- Communal without requiring competition
- Generous to offline and free-to-play users
- Rare outcomes feel like stories and trophies, not only economic multipliers
- Theft-free and without forced PvP
- Plants do not die because a player is absent
- No random loss of plants, creatures, items, or Leafnotes
- Cooperation is available but never required for ordinary progression
- Deliberate player-authorized sale or release follows the approved disposition rules and is not treated as random loss

The first-playable emotional contract is locked. Exact offline caps, growth timers, tutorials, social rewards, and presentation remain provisional. The user approved paid true-transfer stealing on 2026-07-19 as an explicit later-update exception; it is not part of the first playable. The later emotional contract must account for voluntary plot exposure, free protection through held/inventory/favorite states, and permanent loss of an exposed stolen asset. Exact protection pacing remains unresolved.

## Core loop

The user reaffirmed on 2026-07-19 that the familiar Grow a Garden gameplay rhythm should remain the primary benchmark. The farming spine must stay prominent and easy to understand: `buy base seed → plant → wait/offline → harvest renewable output → sell → reinvest → expand`. Creature ecology adds original depth around this spine; it does not authorize copied names, assets, writing, map expression, UI art, exact balance, or branded content.

1. Obtain or buy a Habitat Flora seed.
2. Plant it and let it grow online or offline.
3. The plant creates habitat signals such as food, shelter, warmth, light, water, scent, or sound.
4. A compatible wild creature visits the plot.
5. The player inspects tracks, posture, calls, appetite, and plant interactions.
6. The player chooses the correct lure, care action, or bonding approach.
7. A bonded creature changes how the sanctuary functions.
8. Repeated creature-plant interactions create Growth Memories and Adapted Seeds.
9. The player sells renewable harvests and optionally bonded creatures for Leafnotes, buys more seeds, and plants or preserves adapted lineages.
10. More specialized habitats attract rarer and more complex visitors.

## First-playable Habitat Flora

The first three Habitat Flora and their primary signals were approved on 2026-07-18:

- **Hearthpetal:** warmth and light
- **Ripplecup:** water and gentle sound
- **Nuzzlefern:** shelter and calming scent

Their names and primary signals are locked. Growth timing, stages, harvest outputs, prices, appearance details, and balance remain provisional until separately approved.

## First-playable creatures

The first three creatures and their primary Habitat Flora preferences were approved on 2026-07-18:

- **Cozzle:** prefers Hearthpetal warmth and light
- **Rillibob:** prefers Ripplecup water and gentle sound
- **Mossnub:** prefers Nuzzlefern shelter and calming scent

Their names and primary preferences are locked. Appearance, scale, animation, exact clue language, broader visitor behavior, utility, rarity, and balance remain provisional until separately approved. The first-playable bonding resolution is locked in the following section.

## First-playable clue and bonding interaction

The **Observe → Care → Bond** interaction was approved on 2026-07-19:

1. The player approaches a visitor on their plot and uses `Observe`.
2. The server supplies two truthful visual/text clues for the current visitor state.
3. The player chooses one of three care responses:
   - **Offer Warmth** for Cozzle
   - **Echo the Chime** for Rillibob
   - **Give Quiet Shelter** for Mossnub
4. The correct response bonds the creature deterministically after server validation.
5. A wrong response costs nothing, reveals a clearer clue, and permits another attempt after a short cooldown. The visitor does not permanently flee because of a wrong response.

The interaction sequence, three response identities, creature mapping, deterministic correct resolution, and no-loss retry rule are locked. Exact clue copy, animation, timing, cooldown length, capacity handling, failure presentation, UI layout, interaction presentation, implementation details, and styling remain provisional until separately approved and tested.

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

- Earned by selling approved renewable flora harvests
- Earned by individually selling bonded, player-owned creatures under the confirmed disposition rules
- Spent on Hearthpetal, Ripplecup, and Nuzzlefern seeds
- No direct premium-currency conversion; the separately approved paid-steal exception can acquire an existing asset that may later be sold normally
- No upkeep, currency loss, debt, or passive interest

The currency identity, approved flora and creature sale sources, and base-seed reinvestment relationship are locked. Starter grants, prices, yields, inventory limits, and exact value formulas remain provisional until separately approved.

## First-playable harvesting and disposition

The harvesting, creature-value, and disposition rules were approved on 2026-07-19:

- A mature Habitat Flora parent remains planted and regrows after its approved renewable output is harvested.
- Renewable flora harvests can be sold individually or through `Sell All`; server-side favorite protection excludes favorited harvests.
- Only a bonded, player-owned creature can be displayed, stored, sold, or released. A wild visitor cannot be sold.
- Creature mutations, size, and weight are persistent server-owned traits that affect the server-calculated Leafnote sale value of that individual.
- Creature sales are individual and explicitly confirmed; creatures are excluded from the general harvest `Sell All` action.
- Selling permanently exchanges the creature for Leafnotes. Releasing is separately confirmed, permanently removes the creature, and grants no currency.
- A favorited creature cannot be sold or released until the player intentionally unfavorites it.
- The species journal discovery survives sale or release.
- Adapted Seeds can be planted, stored, or favorited but cannot be sold in the first playable.
- Renewable flora remains the dependable repeatable income source; creature selling is an optional variable-value route and must not make farming obsolete.

The mutation catalog, mutation sources and odds, stacking and inheritance, functional effects, exact visuals, size/weight units and ranges, valuation formulas and rounding, base prices, yields, regrowth timers, capacities, journal retention of exact individual traits, and UI presentation remain provisional. Paid products will not change mutation, size, or weight generation odds, ranges, strength, or valuation formulas; the separately approved paid-steal exception may transfer an already-generated asset at its existing value. The approved Starlace plant Bloommark remains cosmetic-only and has no economic effect.

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
