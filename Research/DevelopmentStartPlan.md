# Proposed Development Start Plan

- Date: 2026-07-16
- Status: Phase 0 design complete; Phase 1 and implementation not authorized
- Truth label: Not yet implemented

This document describes how production should begin. It does not authorize game code, models, or assets.

## Phase 0: Lock the design — complete 2026-07-19

Locked decisions through 2026-07-19:

- Final game promise: Grow Habitat Flora, attract and understand wild creatures, form bonds, cultivate adapted plant lineages, and transform a small plot into a living sanctuary.
- Gameplay reference priority: Keep the familiar Grow a Garden-style `buy seed → plant → wait/offline → harvest → sell → reinvest → expand` rhythm prominent and understandable while keeping Catch a Creature's content and creative expression original
- First three Habitat Flora: Hearthpetal (warmth and light), Ripplecup (water and gentle sound), and Nuzzlefern (shelter and calming scent)
- First three creatures: Cozzle prefers Hearthpetal warmth and light, Rillibob prefers Ripplecup water and gentle sound, and Mossnub prefers Nuzzlefern shelter and calming scent
- First functional Adaptation: Emberkeep lets a Cozzle-influenced Hearthpetal retain its warmth and light signal into early night
- First cosmetic Bloommark: Starlace adds pale star-thread veins and occasional soft motes without changing attraction, growth, yield, sale value, or progression
- First weather state: Soft Rain is natural server-wide light rain with softer and cooler lighting, gentle rain ambience, and water ripples; it has no growth multiplier, rarity boost, paid activation, exclusive creature, or progression requirement
- Currency and reinvestment: Leafnotes are the sole first-playable soft currency, earned by selling approved renewable flora harvests and spent on Hearthpetal, Ripplecup, and Nuzzlefern seeds; there is no direct premium conversion, upkeep, currency loss, debt, or passive interest. The separately approved later-update paid-steal feature may acquire an existing asset that can later be sold normally
- Visitor interaction: Observe a visitor to receive two truthful server-supplied visual/text clues, choose Offer Warmth, Echo the Chime, or Give Quiet Shelter, and bond deterministically after the correct response; a wrong response costs nothing, reveals a clearer clue, and permits another attempt after a short provisional cooldown without permanent fleeing
- Harvesting and disposition: Renewable flora outputs can be sold individually or through favorite-safe `Sell All` while parent plants regrow; bonded owned creatures can be displayed, stored, individually sold for Leafnotes, or released for no currency; creature mutations, size, and weight affect server-calculated value; favorite protection, journal retention, and first-playable Adapted Seed storage/planting rules apply
- Paid true-transfer stealing: An eligible exposed plant or captured roaming/displayed creature can be moved exactly once to a buyer using a paid Steal Credit, with no duplicate; held/inventory/favorited/locked assets are protected, all traits and normal ownership/sale rights transfer, and failed attempts retain the credit. It is approved for a later update; the proposed 99 Robux base price remains provisional
- First-playable emotional contract: Cozy and theft-free; generous offline growth; no plant death from absence; no forced PvP; no random loss of plants, creatures, items, or Leafnotes; cooperation is optional; deliberate sale/release follows the approved disposition rules

Before production, decide:

- Final one-sentence game promise (locked above)
- Cozy/community emotional contract (locked above)
- First three Habitat Flora (locked above)
- First three creatures (locked above)
- First adaptation and first Bloommark (locked above)
- First weather state (locked above)
- Currency and reinvestment relationship (locked above)
- Exact player interaction used to understand and bond with a visitor (locked above)
- What can be harvested, sold, released, displayed, or preserved (locked above)

Phase 0 is complete. The sections below describe the approved order for future work but do not authorize Phase 1, a source scaffold, Roblox Studio edits, game code, models, or assets.

## Phase 1: Roblox and Blender standards

Establish:

- Shared avatar and plot scale reference
- Naming and folder conventions
- Ground/root pivot conventions
- Applied Blender transforms
- Creature rig and animation conventions
- Plant growth-stage organization
- Material and texture style
- Collision strategy
- Measured polygon, texture, instance, particle, and audio budgets
- A tested export/import preset using one simple plant and one creature

Create a small art bible before producing many assets.

## Phase 2: Roblox graybox

Build only:

- One grayboxed player plot
- Seed source
- Planting area
- Harvest/sell/reinvestment point
- Creature visitation location
- Small central hub
- Temporary block models

Validate plot scale, movement, camera distance, sightlines, and interaction flow before final modeling.

## Phase 3: Smallest complete playable

Target vertical slice:

- Three Habitat Flora
- Three creatures
- Planting and timed growth
- Basic timestamp-based offline growth
- One habitat attraction rule
- One clue-inspection encounter
- One bonding or catching resolution
- One creature-plant interaction
- One Adapted Seed
- Renewable-flora harvesting, optional confirmed creature selling, and Leafnote reinvestment
- Saving and loading
- One simple weather state

The complete loop must be understandable and worth repeating before adding breeding, trading, events, or monetization.

## Phase 4: Replace grayboxes

1. Finalize plant silhouettes and growth stages in Blender.
2. Model and rig the first creatures.
3. Create original animations.
4. Import through the tested pipeline.
5. Add collision and interaction points.
6. Apply the established visual style.
7. Test crowded plots and mobile performance.
8. Expand the asset catalog only after validation.

## Phase 5: Depth order

1. Additional adaptations and Bloommarks
2. Plot organization and customization
3. Weather and migration variety
4. Creature bonding utility
5. Breeding and inheritance
6. Collection journal and achievements
7. Community events
8. Safe gifting or trading
9. Monetization
10. Seasonal live operations

## Deferred from the first playable

- Breeding
- Trading
- Guilds
- Ascension/rebirth
- Paid weather wheel
- Paid luck
- Large event catalog
- Competitive leaderboards
- Destructive decay and mandatory defense
- Paid true-transfer stealing, until a later update after core ownership and economy systems are proven
- Full developer command room

The paid true-transfer stealing contract is approved for a later update and is not part of the first playable. It must not enter implementation until the farming, inventory, ownership, persistence, appraisal, ordinary selling, receipt, policy, transaction-recovery, protection, and multiplayer foundations pass their gates.

## Verification gate

Before marking the first playable verified, connect to the authorized Roblox Studio place, run edit/play-mode tests, inspect console output, and capture evidence. Real mobile, controller, multi-client, production DataStore, publishing, analytics, and player feedback remain separate validation steps.
