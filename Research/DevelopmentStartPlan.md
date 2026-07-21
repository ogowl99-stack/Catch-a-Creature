# Proposed Development Start Plan

- Date: 2026-07-16
- Status: Phase 2 graybox v1 implemented and single-client desktop-verified; Phase 3 gameplay implementation not authorized
- Truth label: Verified

This document describes how production should begin. The user authorized Phase 1 on 2026-07-19 and Phase 2 on 2026-07-20; later phases still require separate gates.

## Phase 0: Lock the design — complete 2026-07-19

Locked decisions through 2026-07-19, with the paid-transfer release-order follow-up recorded on 2026-07-20:

- Final game promise: Grow Habitat Flora, attract and understand wild creatures, form bonds, cultivate adapted plant lineages, and transform a small plot into a living sanctuary.
- Gameplay reference priority: Keep the familiar Grow a Garden-style `buy seed → plant → wait/offline → harvest → sell → reinvest → expand` rhythm prominent and understandable while keeping Catch a Creature's content and creative expression original
- First three Habitat Flora: Hearthpetal (warmth and light), Ripplecup (water and gentle sound), and Nuzzlefern (shelter and calming scent)
- First three creatures: Cozzle prefers Hearthpetal warmth and light, Rillibob prefers Ripplecup water and gentle sound, and Mossnub prefers Nuzzlefern shelter and calming scent
- First functional Adaptation: Emberkeep lets a Cozzle-influenced Hearthpetal retain its warmth and light signal into early night
- First cosmetic Bloommark: Starlace adds pale star-thread veins and occasional soft motes without changing attraction, growth, yield, sale value, or progression
- First weather state: Soft Rain is natural server-wide light rain with softer and cooler lighting, gentle rain ambience, and water ripples; it has no growth multiplier, rarity boost, paid activation, exclusive creature, or progression requirement
- Currency and reinvestment: Leafnotes are the sole first-playable soft currency, earned by selling approved plant harvests and bonded creatures, then spent on base seeds; there is no direct premium conversion, upkeep, currency loss, debt, or passive interest. The separately gated paid-steal launch feature may acquire an existing asset that can provisionally be sold normally, subject to economy and anti-laundering review
- Visitor interaction amendment: A wild visitor remains unowned until successful capture. Each contender personally completes Observe and correct Care to earn Trust, then uses a leaf-shaped Haven Tag for a disclosed server roll. The caretaker receives 60 seconds of exclusive priority and may open early; the visitor then remains public for five minutes. The tutorial capture is guaranteed. A committed failure consumes one Haven Tag and selected free aid, adds two absolute Familiarity points toward approved tier guarantees, and opens deliberate Retry/Let Go with fair distinct-contender round-robin and no gameplay cooldown. Full storage grants no ownership and leaves the visitor available. Wrong Care remains a no-cost retry
- Harvesting and disposition: Ordinary crops are single-harvest and require replanting; only explicit regrowing classes such as trees remain and produce again. Plant harvests can be sold individually or through favorite-safe bulk sale. Bonded owned creatures can be displayed, stored, individually sold for Leafnotes, or released for no currency; creature mutations, size, and weight affect server-calculated value; favorite protection, journal retention, and first-playable Adapted Seed storage/planting rules apply
- Paid true-transfer stealing: An eligible exposed plant or captured roaming/displayed creature can be moved exactly once to a buyer using a paid Steal Credit, with no duplicate; held/inventory/favorited/locked assets are protected, all traits and provisional normal ownership/sale rights transfer, and failed attempts retain the credit. It is a conditional initial-public-release target built last and feature-flagged off until every launch gate passes; the proposed 99 Robux base price remains provisional
- First-playable emotional contract: Cozy and theft-free for owned assets; generous offline growth; no plant death from absence; no random loss of owned plants, owned creatures, items, or Leafnotes; cooperation is optional. Wild unowned visitors are competitively catchable under disclosed rules, while deliberate sale/release follows the approved disposition rules

Before production, decide:

- Final one-sentence game promise (locked above)
- Cozy/community emotional contract (locked above)
- First three Habitat Flora (locked above)
- First three creatures (locked above)
- First adaptation and first Bloommark (locked above)
- First weather state (locked above)
- Currency and reinvestment relationship (locked above)
- Wild-until-success ownership, full-storage behavior, Care-to-Trust-to-capture reconciliation, Familiarity, item cost, public ordering, No Aid/guaranteed-attempt behavior, and Mythic/Legendary visual celebration direction (locked above); only arrival weights, Luck formula/recipes, technical expiry grace, audio/assets, and measured budgets remain unresolved
- What can be harvested, sold, released, displayed, or preserved (locked above)

Phase 0 is complete. The user authorized the bounded Phase 1 standards, source-link, and import-test work on 2026-07-19, then explicitly authorized Phase 2 map grayboxing on 2026-07-20. Neither authorization includes Phase 3 gameplay, a production asset catalog, or publishing.

## Phase 1: Roblox and Blender standards

Approved Phase 1 foundations through 2026-07-19:

- Eight-player public servers, matching the eight equal plot concept
- Mobile-safe performance and interaction as the minimum, with scalable desktop enhancements rather than separate game versions
- Git and a selective Rojo mapping as the authoritative workflow for repository-owned scripts and configuration
- Standard Roblox third-person camera behavior and standard R15 avatars
- All-ages accessibility with deeper collection systems layered behind a readable first experience
- An original classic-Roblox, stud-textured garden look across most world and constructed surfaces, with tested exceptions where studs harm water, character, foliage, animation, or UI readability; do not copy Grow a Garden assets, map expression, UI, names, or exact content
- First guided farming hook: A new player should complete a guaranteed buy → plant → fast grow → harvest → sell tutorial cycle in about five minutes using Sunspud, a new original single-harvest super-common plant that is always in stock and separate from Hearthpetal; every Sunspud targets roughly 45 seconds to mature
- Tutorial route: breathing Shop button → permanently free shop fast travel and Sunspud purchase → permanently free `Your Plot` travel → ten logical quick slots referencing a 200-slot Backpack, with five per phone page → valid free placement with one-stud snap defaulting off, no required spacing, and exact-transform rejection → plant-icon growth percentage → whole-plant Harvest button and weight reveal → permanently free Sell travel → Sell Held / favorite-safe Sell All / Appraise submenu
- Storage: compatible ordinary seeds stack to 999; trait-bearing/Adapted Seeds are individual unless their full canonical payloads match; every unique weighted/mutated whole-plant harvest, weighted tree produce, and stored creature uses one slot; planted crops and roaming/displayed owned creatures free Backpack slots under separate caps; tree produce is collected individually and remains on the tree when full; a full Backpack blocks wild capture before RNG/consumption and leaves the visitor wild; an already-owned creature that cannot be recalled remains owned on the plot; free favorite/lock stays available; there is no special storage-resolution grace before ordinary launch-theft eligibility for exposed unlocked owned assets
- Paid capacity: one repeatable Developer Product—not a game pass—may permanently add +200 per durably processed unique receipt. Five purchases and 1,200 total slots are the approved launch operational maximum, still gated on measurement and tested emergency receipt headroom. The product never changes hotbar, plot/roaming caps, growth, traits, value, travel, capture odds, or theft protection and is never prompted by fullness or threat
- First wild creatures begin arriving around minutes 8–10
- Wild-capture direction: successful capture creates exactly one owned creature; full storage leaves the visitor wild. Base capture chances are Common 95%, Uncommon 80%, Rare 55%, Epic 30%, Legendary 12%, and Mythic 3%. Every contender needs personal Trust and physical proximity. Visible traits never reroll. One free next-attempt Luck or Super Luck aid may modify a roll. Every accepted attempt consumes its Haven Tag/selected aid; every accepted failure adds +2 absolute points to persistent player × stable creature-definition ID × rarity-tier Familiarity and advances toward guarantees on attempts 2/3/5/8/15/25. Retry is deliberate/fair and defaults to No Aid; guaranteed attempts disable Luck; Let Go is personal, preserves progress, and does not open caretaker priority early. No Robux-derived path may fund capture chance. Two wild and six displayed owned creatures per plot, with 64 simulated per server, are approved starting caps that remain unmeasured
- Rare-success presentation: Mythic is the approved super-rare tier. After durable ownership, play the approved roughly five-second immediately skippable capturer-local Haven Tag/leaf-constellation/trait-mote/acceptance-mark/journal sequence; nearby players see a bounded flourish; Legendary receives a shorter two-to-three-second flourish; support Full/Short/Off plus Reduced Motion. Studio/device measurement is still required
- Sunspud art, price and yield; canonical stack key; Developer Product price/name/ID, emergency ceiling/headroom, and page design; arrival-weight tables; Luck formula/recipes; technical expiry grace; exact celebration/audio assets and measured budgets; exact vendor copy; and normal pacing remain unresolved. There is no capture gameplay cooldown; one authoritative roll must complete before a deliberate retry

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

Status: Graybox v1 built in the authorized Studio place on 2026-07-20. Edit-mode structure and one-client desktop traversal are Verified. Real multi-client, mobile, tablet, controller, production persistence, and user visual-approval gates remain open.

Build only:

- Eight repeated grayboxed player plots using the superseding exact 96×96 standard and outward plot ring
- Seed-source placeholder at the grouped Caretaker Hub
- Planting-area footprints and non-plantable arrival pads
- Harvest/sell/reinvestment placeholders
- Global creature-visitation markers
- Small central sanctuary and service hub
- Temporary block models with no gameplay authority

The expanded graybox also reserves a 20-stud perimeter route and one natural meadow for a future creature-mount update. Mount gameplay is not part of Phase 2 or the smallest playable.

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
- Single-harvest crop replanting, explicit tree regrowth, optional confirmed creature selling, and Leafnote reinvestment
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
- Paid true-transfer stealing, until the final launch-system slice after core ownership and economy systems are proven
- Full developer command room
- Creature mounts, mounted controls/animation, and mounted-speed progression

Paid true-transfer stealing is not part of the smallest internal first-playable prototype, but it is now a conditional initial-public-release target. It must not enter implementation until the farming, inventory, immutable identity, ownership, persistence, appraisal, ordinary selling, generic receipt, policy, transaction-recovery, protection, and multiplayer foundations pass their gates. It is implemented last, stays disabled behind a server feature flag, and blocks public launch rather than weakening those gates.

## Verification gate

Before marking the first playable verified, connect to the authorized Roblox Studio place, run edit/play-mode tests, inspect console output, and capture evidence. Real mobile, controller, multi-client, production DataStore, publishing, analytics, and player feedback remain separate validation steps.
