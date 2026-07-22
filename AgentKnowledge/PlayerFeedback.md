# Player Feedback

## Entry: Make the Memory Tree the main selling point

- Date: 2026-07-21
- Agent: Codex / Map and UI roles
- Category: Map / visual focus / request
- Feedback: The center island and future big tree should be larger, everything else should move outward, and the tree must be the main focal point and selling point.
- Evaluation: Direct stakeholder feedback matches the existing event-center architecture and can improve orientation without changing the gameplay loop. The main risks are crowd space, HUD occlusion, route breakage, and final-art performance.
- Decision made: Implement a coordinated hero-center revision and validate it through exact geometry, real HUD cameras, and one-client routes rather than changing the tree alone.
- Result: 184-stud event island, 255-stud tree silhouette, expanded pond/ring, outward plot/service/reserve/trail/boundary positions, and progress stills.
- Evidence: User request; verified live Studio geometry and one-client desktop tests. User visual approval of the result remains pending.
- Confidence level: High for intent; Medium for final-art scale
- Verification status: Verified implementation; awaiting player visual approval

## Entry: Forage discovery, anti-macro relocation, and rare pull feedback

- Date: 2026-07-21
- Agent: Stakeholder / Codex
- System affected: Exploration, seed economy, map nodes, and VFX
- Situation: The stakeholder requested map foraging for seeds across the rarity spectrum, specifically warned that a harvested seed must not respawn in the same location, and requested a special Mythic pull animation.
- Decision made: Treat the request as an economy-bearing exploration loop with server-selected loot, post-success relocation, and a Mythic-only capturer-local celebration.
- Reasoning summary: The relocation directly addresses predictable macro coordinates, while the rare visual creates a shareable high-impact moment without changing reward authority.
- Result: The requested prototype is implemented and verified in one-client Studio. Higher-tier natural drops remain blocked by missing content definitions, not silently substituted.
- Test evidence: Live forage/relocation/cooldown and simulated Mythic presentation capture.
- Mistakes discovered: The first cooldown-only design did not fully satisfy the anti-macro intent.
- Recommended future approach: Ask for player feedback on search fun, spawn readability, prompt time, and VFX intensity after Rare-Mythic content is added; do not tune from one developer session.
- Confidence level: High that the implementation matches the stated interaction intent
- Verification status: Verified prototype response to direct stakeholder feedback

No external player feedback or analytics exist.

## User design preferences recorded

- Cozy, cute, welcoming ambience
- Strong ambient lighting and a peaceful feeling
- All production assets created from scratch
- Roblox used for the game and Blender for modeling
- Free-to-play access with optional rare cosmetics and faster routine progress
- Public-server purchases should benefit the whole server when possible
- Creature breeding and rare inherited appearances are desired later
- Mutated/adapted plants should be able to produce distinctive seeds
- Research and design should precede implementation
- Preserve short, visually impactful development captures for TikTok-style "day N of making a Roblox game" progress posts; skip routine work and never present staged or simulated footage as verified gameplay
- After the farm, persistence, backpack, and service-access foundation worked, begin the first creature-facing slice with Hearthpetal growth and Cozzle arrival
- Use a bottom-left backpack-symbol button to open inventory; keep Leafnotes visible but remove the redundant top-left `Backpack 0/200` text
- Allow right-clicking a hotbar item whether the backpack panel is open or closed to store it without deleting it, and right-clicking a stored inventory card to return that exact item to the first free hotbar slot
- Make Shop and Caretaker Hub usable from ground level: free travel must land in front rather than on the roof, and a nearby interaction button must open the correct panel without another teleport
- Enter planting by selecting the seed's hotbar slot, then click or tap valid plot soil directly; do not require a separate on-screen `Place` button
- Map keyboard `1` through `9` to hotbar slots 1 through 9 and `0` to slot 10 so desktop players do not have to move the cursor back to the hotbar
- Put a harvested plant into the first available hotbar slot immediately and show its name and server-authored weight on that slot
- Keep the free-travel buttons together in one centered top row ordered `SHOP`, `YOUR PLOT`, `SELL`
- Stakeholder described the direct world-placement revision as "much better" during the live Studio playtest
- Persist exact Leafnotes across sessions; for example, leaving with 100,000 Leafnotes must restore exactly 100,000 on rejoin
- Persist planted crops, their identity, position, hidden weight, and growth timestamps; crops continue growing while the player is offline and return mature when enough real time elapsed
- Persist hotbar assignments so the same seeds/items return to the same numbered slots after logging out and back in
- Keep the gameplay rhythm as similar to Grow a Garden as practical, especially the buy, plant, wait/offline, harvest, sell, reinvest, and expand progression spine; retain original Catch a Creature content and expression
- Allow bonded creatures to be sold, with mutations, size, and weight affecting each creature and its value
- Add paid true-transfer stealing for an exposed planted plant or captured roaming creature: no duplicate, inventory/held assets are protected, and the buyer may keep or sell the exact stolen item for its normal value
- Target paid true-transfer stealing for the initial public release, but build it last and keep it disabled until core farming, inventory, ownership, persistence, appraisal, selling, policy, protection, receipt, recovery, economy, and closed multiplayer gates pass
- Use Sunspud as a separate always-stock super-common plant, with every Sunspud targeting roughly 45 seconds to grow
- Make ordinary plants single-harvest and require replanting; only explicit classes such as trees regrow
- Keep Shop, `Your Plot`, and Sell travel permanently free
- Present ten quick-access slots plus a backpack for full storage; allow free placement with optional snapping and no required spacing
- Use Grow a Garden's UI only as a functional clarity reference while keeping Catch a Creature's art, component design, terminology, and composition original
- Use 200 occupied Backpack slots as the free base; stack compatible ordinary seeds; keep unique weighted/mutated plant harvests and creatures individual
- Harvest the entire weighted ordinary plant, while trees remain and grant separate produce; every Sunspud targets roughly 45 seconds
- If storage is full, leave the exact mature plant or ripe produce unchanged and exposed on the plot; allow repeatable permanent +200 Developer Product grants under a finite tested operational ceiling
- Reject exact identical-position planting; default an optional one-stud grid off; show five of ten hotbar assignments per phone page; keep free Shop/Plot/Sell travel visible in ordinary gameplay
- Cap compatible ordinary seed stacks at 999; keep trait-bearing/Adapted Seeds individual unless completely canonically identical; keep weighted tree produce individual
- Let planted crops and roaming/displayed creatures free Backpack slots under separate caps; if storage is full, keep the exact bonded creature safely on the plot
- Keep favorite/lock free on exposed mature assets; do not add a storage-resolution grace before ordinary launch-theft eligibility. Separate universal new-player/placement/post-transfer protections remain unresolved and must not be confused with storage recovery.
- Make permanent +200 storage repeatable. Stakeholder requested unlimited purchases; platform review corrects the product to Developer Product and requires a finite tested operational maximum before launch
- Approve five repeatable +200 purchases as the launch maximum: 200 base plus 1,000 purchased equals 1,200 total slots, still subject to implementation and measured safety gates
- Make favorites block Sell Held; collect tree produce one item at a time and leave the selected produce on the tree when storage is full
- Keep every visiting creature wild and unowned until one player successfully catches it; if a contender has no storage space, they receive no ownership and the creature remains available to anyone eligible
- Add an original rarity-based capture system with a leaf-shaped Haven Tag; lock Common capture at 95% and the approved six-tier table, while excluding 0.01% from capture and retaining it only as a possible later arrival-weight experiment
- Preserve future craftable Luck and Super Luck item ideas, but do not treat their names, ingredients, formula, stacking, or monetization as approved yet
- Approve the complete capture package: personal Observe/Correct Care Trust, 60-second caretaker priority/open early, guaranteed tutorial, Common/Uncommon/Rare/Epic/Legendary/Mythic base chances of 95/80/55/30/12/3 percent, leaf-shaped Haven Tag/ribbon presentation, persistent species Familiarity and hard guarantee, free next-attempt Luck/Super Luck, fixed visible traits, five-minute public lifetime, physical proximity, and starting caps of two wild plus six displayed owned creatures per plot/64 simulated per server
- Reject a post-failure gameplay cooldown: after the authoritative result, allow immediate retry and slightly raise capture chance after every valid failure
- Consume one Haven Tag and the selected free Luck aid on every valid accepted failure; rejected, full, stale, busy, and lost-race requests consume nothing
- Track Familiarity per player × stable creature-definition ID × rarity tier; add two absolute percentage points per valid accepted failure; guarantee Common/Uncommon/Rare/Epic/Legendary/Mythic capture on attempts 2/3/5/8/15/25; persist it across visitors, rejoins, and another player winning; reset it only when that player succeeds on the matching creature-definition ID
- During public contention, place a failed contender's deliberate retry behind already-waiting distinct eligible contenders; retry immediately when nobody is waiting
- After a failure, offer `Retry Capture` or `Let Go`; interpret `Let Go` as that contender stopping their current attempt while retaining Familiarity and leaving the visitor wild/public
- Treat `super rare` as the existing Mythic tier, not a seventh tier. After durable ownership, play an approximately five-second immediately skippable local Haven Tag → leaf/constellation ribbon → trait-colored motes → voluntary sanctuary mark → journal reveal sequence; nearby players see only a brief flourish; Legendary receives a shorter two-to-three-second flourish; support Full/Short/Off and Reduced Motion
- `Let Go` during caretaker priority closes only that player's capture flow and preserves the remaining exclusive window; `Open to Everyone` remains the separate explicit early-open control
- After a failed attempt, Retry defaults to No Aid. Disable Luck selection on a guaranteed attempt. Every accepted successful attempt also consumes its Haven Tag and selected free Luck aid
- Research the Catch a Monster Pets page and main community wiki for useful feature patterns. Preserve only high-level lessons that strengthen Catch a Creature; do not copy the reference game's names, assets, exact balance, or presentation.

Status: Direct stakeholder input, verified from project conversation. This is not player-market validation.
