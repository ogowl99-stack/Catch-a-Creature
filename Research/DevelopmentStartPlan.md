# Proposed Development Start Plan

- Date: 2026-07-16
- Status: Approved direction, not authorized for implementation
- Truth label: Not yet implemented

This document describes how production should begin. It does not authorize game code, models, or assets.

## Phase 0: Lock the design

Locked decisions as of 2026-07-18:

- Final game promise: Grow Habitat Flora, attract and understand wild creatures, form bonds, cultivate adapted plant lineages, and transform a small plot into a living sanctuary.
- First three Habitat Flora: Hearthpetal (warmth and light), Ripplecup (water and gentle sound), and Nuzzlefern (shelter and calming scent)
- First three creatures: Cozzle prefers Hearthpetal warmth and light, Rillibob prefers Ripplecup water and gentle sound, and Mossnub prefers Nuzzlefern shelter and calming scent
- First functional Adaptation: Emberkeep lets a Cozzle-influenced Hearthpetal retain its warmth and light signal into early night
- First cosmetic Bloommark: Starlace adds pale star-thread veins and occasional soft motes without changing attraction, growth, yield, sale value, or progression
- First weather state: Soft Rain is natural server-wide light rain with softer and cooler lighting, gentle rain ambience, and water ripples; it has no growth multiplier, rarity boost, paid activation, exclusive creature, or progression requirement
- Currency and reinvestment: Leafnotes are the sole first-playable soft currency, earned by selling approved renewable flora harvests and spent on Hearthpetal, Ripplecup, and Nuzzlefern seeds; there is no premium conversion, upkeep, currency loss, debt, or passive interest

Before production, decide:

- Final one-sentence game promise (locked above)
- Cozy/community emotional contract
- First three Habitat Flora (locked above)
- First three creatures (locked above)
- First adaptation and first Bloommark (locked above)
- First weather state (locked above)
- Currency and reinvestment relationship (locked above)
- Exact player interaction used to understand and bond with a visitor
- What can be sold, released, displayed, or preserved

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
- Harvesting, selling, and reinvestment
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
- Theft, decay, and defense
- Full developer command room

## Verification gate

Before marking the first playable verified, connect to the authorized Roblox Studio place, run edit/play-mode tests, inspect console output, and capture evidence. Real mobile, controller, multi-client, production DataStore, publishing, analytics, and player feedback remain separate validation steps.
