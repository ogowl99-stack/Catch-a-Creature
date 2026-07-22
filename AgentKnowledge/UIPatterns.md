# UI Patterns

## Entry: Held selection and favorite-safe selling

- Date: 2026-07-21
- Agent: Codex / UI and Gameplay roles
- System affected: Hotbar, inventory cards, avatar feedback, and Sell panel
- Situation: The selected seed/plant needed visible physical feedback, single sale needed an obvious equipped requirement, and bulk sale needed visible favorite protection.
- Decision made: Make click/number selection drive both the server equip request and local R15 held model; add a star toggle to inventory cards; present separate `SELL EQUIPPED` and `SELL ALL UNFAVORITED` actions with count and protection copy.
- Reasoning summary: Selection feedback should stay near the avatar/hotbar, while destructive inventory choices need explicit scope and loss-prevention language.
- Result: Exact item name/weight remains visible in the hotbar and Sell panel, storage round trips are reversible, and favorites are never included in bulk count/sale.
- Test evidence: Live harvested/equipped capture, stored-card return, favorite toggle, Sell panel capture, single-sale result, and 58 fresh-server cases.
- Mistakes discovered: Client-local held presentation does not communicate equip state to observers.
- Recommended future approach: Add bounded observer replication, touch/controller focus states, confirmation only for high-value bulk actions if player testing shows confusion, and responsive checks with the large tree behind the HUD.
- Confidence level: High for desktop
- Verification status: Verified

## Entry: Two-seed Habitat Shop and fixed Hearthpetal hotbar access

- Date: 2026-07-21
- Agent: Codex / UI, Gameplay, Data, and QA roles
- System affected: Shop modal, custom hotbar, placement preview, inventory names, sell presentation, growth labels, and creature-arrival readability
- Situation: The one-product shop and Sunspud-only labels could not present Hearthpetal or preserve number-key placement across two seed types.
- Decision made: Use a two-section `HABITAT SEEDS` modal with one clearly named Buy button per plant, separate price/growth copy, and an explicit experimental/unowned Cozzle note. Keep Sunspud in slot 1 and Hearthpetal in slot 2; unique harvested items use slots 3-10. Resolve all plant names from the server snapshot catalog for inventory, held-item, harvest, sell, and notices. Wrap the long Hearthpetal slot label as `HEARTH` / `PETAL`. Selecting either seed enters the existing direct world-placement mode with that server definition ID.
- Reasoning summary: Fixed numeric access preserves the user's low-cursor-travel preference, while server catalog text prevents Sunspud hard-coding from mislabeling another exact item. The unowned note stops a visual arrival from implying capture completion.
- Result: The modal cleanly shows both plants at the desktop test size; slot 2 projects Hearthpetal; live growth and mature labels render; Cozzle receives a smaller, higher label and a side-biased arrival to reduce overlap.
- Test evidence: Studio Habitat Seeds capture, hotbar/growth capture, mature Hearthpetal/Cozzle capture, live snapshot catalog/stack values, clean console, and client source sync inspection.
- Mistakes discovered: The first Cozzle placement aligned the visitor, plant, and arrival pad, making labels overlap. Inward plus tangential offset and a smaller/higher visitor label improve separation. Physical slot-2 key and Buy-button clicks remain manual checks because the live fixture invoked the same remotes directly.
- Recommended future approach: Keep Observe prompts below or beside visitor labels; add touch/controller seed selection and Observe focus checks; test narrow phone layout and label density before adding more seeds/visitors.
- Confidence level: High for current desktop layout; Medium for physical input wiring; Low for untested phone/controller readability
- Verification status: Visual/runtime Verified with physical-input and real-device gaps

This entry supersedes earlier UI pattern references to slot 1 plus item slots 2-10. Schema v3 uses seed slots 1-2 and item slots 3-10.

## Entry: Bottom-left backpack, reversible hotbar storage, and front-of-kiosk access

- Date: 2026-07-21
- Agent: UI Agent / Gameplay Agent / Data Agent / Architecture Agent / QA Agent / Codex
- System affected: Backpack panel, custom hotbar, exact-item references, Shop/Sell access, service travel, mouse input, and kiosk prompts
- Situation: The old top-left `Backpack: 0/200` text was redundant and its inventory button did not work. Service travel placed the character on kiosk roofs, while standing in front of Shop/Sell offered no direct access. The stakeholder requested a bottom-left backpack button, reversible right-click hotbar storage, and an in-front service button.
- Decision made: Keep only Leafnotes plus the development truth label in the top-left stats card. A rounded backpack-symbol button sits in the bottom-left above the responsive hotbar and toggles a scrollable inventory panel. Cards show `SUNSPUD`, server weight, and `Hotbar N` or `Stored`. Right-clicking hotbar slots 2-10 durably clears only that reference and leaves the exact item in Backpack; right-clicking a stored card durably assigns the exact eligible Backpack item to the lowest free slot 2-10. Slot 1 remains server-locked. Both commands use the existing RemoteFunction, profile/item revisions, bounded request journal, commit-before-acknowledgement, replay protection, and server-derived player ownership. Shop/Sell travel computes a grounded approach from trusted kiosk geometry and places the HumanoidRootPart in front of the kiosk; one `E` / controller `X` / clickable ProximityPrompt per kiosk opens its panel without moving the player.
- Reasoning summary: The hotbar is a quick-access projection of Backpack-owned items, so changing assignment must never create, delete, reweight, relocate, or change the item revision. Nearby prompts remove the need to teleport merely to open a service, while safe front landings preserve fast travel.
- Result: The bottom-left panel and removal of the redundant top-left Backpack count are implemented. Live right-click changed slot 2 to `EMPTY`, advanced the profile once, and retained the same 875-milli item as `Stored`. Shop and Sell fast travel landed exactly at root Y 48, 13 studs in front of each kiosk, below roof Y 56. Exactly one prompt per kiosk is present and visually rendered. Stored-card assignment and prompt callback wiring are implemented and domain/code-reviewed; physical right-click-to-reassign and actual prompt activation still require stakeholder/manual confirmation.
- Test evidence: Clean 115,139-byte Rojo build and source-link PASS; 24/24 domain/schema cases plus 4/4 FarmService lifecycle cases; live open-panel and closed-panel hotbar removal evidence; exact item ID/weight preservation; bottom-left responsive viewport captures; prompt property/count inspection; visible Sell prompt capture; and exact Shop/Sell landing coordinates. Studio virtual keyboard input did not activate the visible prompt, so prompt activation itself is not marked Verified.
- Mistakes discovered: The first model-level travel used a character pivot offset; the first grounded approach incorrectly treated a rotated cylinder's Y dimension as thickness. Direct HumanoidRootPart placement plus the minimum cylinder dimension corrected both. The first save-load guard covered only overlapping loads, not sequential calls or departure cleanup; independent review drove the final lifecycle tests.
- Recommended future approach: Add a visible touch/controller `Store` / `Add to hotbar` action because right-click alone is desktop-only; physically test both card directions, prompts, controller focus, and touch; add safe-ground raycast/fallback checks before final kiosk art changes.
- Confidence level: High for panel layout, live unassignment, exact-item preservation, and corrected landing; Medium for stored-card assignment and prompt callback until physical confirmation; Low for real touch/controller behavior
- Verification status: Mixed — Verified, Code-reviewed, and Requires manual device testing as scoped above

## Entry: Direct planting, numbered hotbar, and centered travel row

- Date: 2026-07-21
- Agent: UI Agent / Gameplay Agent / QA Agent / Codex
- System affected: Phase 3A farm HUD, placement input, hotbar projection, held-item selection, and free travel
- Situation: The first playable farm slice required a separate `Place` button after seed selection, harvested items were not projected into visible hotbar slots, and the three travel controls were stacked at the upper-right. The stakeholder requested fewer cursor trips and a centered top navigation row.
- Decision made: Selecting the seed enters placement immediately; the next unprocessed mouse click or touch on valid plot soil sends the server-authoritative placement request, while `Escape`, controller `B`, or Cancel exits and optional snapping remains available. Keyboard `1`-`9` select slots 1-9 and `0` selects slot 10, with keypad equivalents; the built-in Roblox Backpack CoreGui is disabled to avoid competing hotbar ownership. Saved slot 1 always references Sunspud seeds, while each harvest stores its exact item ID in the first free saved slot 2-10; the same slot map is returned in every snapshot and survived the scoped isolated Studio DataStore rejoin, while production durability remains unverified. Each harvested Sunspud shows `SUNSPUD` plus its server-authored weight, and selecting it sets the exact item ID used by Sell Held. Free travel is a centered horizontal `SHOP` / `YOUR PLOT` / `SELL` row with the objective below it; width constraints and compact stats relocation prevent overlap/clipping.
- Reasoning summary: The revised path reduces routine cursor travel to one equip keystroke and one world click, keeps server validation intact, makes the harvest reward immediately legible, and groups the three repeated destinations by task order.
- Result: The controller implements the requested direct-input and layout behavior. The stakeholder completed live planting with the separate Place control absent and described the revision as "much better." A live harvest placed exact item `c20d9b9d-76ea-405f-9e9b-22bec8488b5a` into saved slot 2 and rendered `SUNSPUD` plus `1.08 wt`; a narrow capture then drove a smaller nonwrapping label revision. Top-row number-key behavior is code-reviewed; exact top-row virtual-key automation remains blocked by Studio's virtual-input reservation and needs a short physical-key confirmation.
- Test evidence: Rojo clean-build test passed; Studio loaded direct placement, saved-hotbar, weight-label, number-key, CoreGui-disable, responsive width, and screen-coordinate ray paths with no Place button; live state showed server-canonical plants; `StarterGui:GetCoreGuiEnabled(Backpack)` returned false; Studio captures verified the centered travel row and harvested slot 2; the snapshot hotbar item ID matched the Backpack item ID and GUI weight; no farm client/server errors appeared. The automated top-row key sender refused Roblox-reserved number keys, so this does not count as a physical keyboard test.
- Mistakes discovered: The first travel-row pass overlapped the stats card at narrow width; the first number-key pass did not explicitly disable Roblox's built-in Backpack hotbar; pointer screen coordinates were initially passed to a viewport ray; client-only slot rebuilding shifted item keys; and 13-point wrapped slot labels broke `SUNSPUD` across lines. All were corrected.
- Recommended future approach: Reuse one hotbar activation function for GUI and keyboard input; keep number labels identical to their key bindings; guard shortcuts while a text box is focused; physically test `1`, `0`, touch placement, controller placement, and both phone pages; keep exact item IDs in server-saved slots.
- Confidence level: High for mouse/direct placement, travel layout, and harvest presentation; Medium for keyboard until physical-key testing
- Verification status: Mixed — Verified, Code-reviewed, and Requires manual device testing as identified above

## Entry: Failure decision sheet and post-commit rare reveal

- Date: 2026-07-19
- Agent: UI Agent / Gameplay Agent / Security Agent / VFX Agent / QA Agent / Codex
- System affected: Capture failure, Retry/Let Go, odds, consumption, Familiarity, queue, mobile/controller, accessibility, and rare-success reveal
- Situation: The user approved deliberate Retry/Let Go after capture failure, exact failed-attempt cost/Familiarity/round-robin rules, and a super-rare success cutscene with VFX.
- Decision made: Open the decision sheet only after the durable failure result. State that the visitor stayed wild; disclose one Haven Tag used, the selected aid used if any, `Familiarity +2`, exact next chance, guarantee attempt/progress, remaining Tags, public time, and queue state. Use primary `Retry Capture (1 Haven Tag)` and secondary `Let Go`. Retry creates one intent, defaults to No Aid, and never auto-repeats; if others wait, show `Waiting — N ahead` rather than a promised time. Disable Luck selection when the next attempt is guaranteed. Let Go closes only this player's panel/intent, preserves Familiarity, and does not despawn or open the creature globally; during caretaker priority the separate `Open to Everyone` control remains available. On committed Mythic success, replace capture controls with the approved immediately skippable five-second local sanctuary sequence/journal reveal; Legendary uses the shorter flourish; nearby players receive no forced camera. Support Full/Short/Off and Reduced Motion. No success language appears before ownership. Mobile uses a compact world-preserving bottom sheet with stacked large targets; controller uses fresh press/release, clear focus, and `A = Retry`, `B = Let Go`; reduced motion replaces camera motion with a short static reveal.
- Reasoning summary: A post-result decision prevents held-button retries and makes every new item cost deliberate. Exact outcome/progress/queue disclosure helps players distinguish immediate retry from automatic priority, while post-commit celebration avoids false ownership.
- Result: Two-button failure choice, No Aid retry default, guaranteed-attempt Luck disabling, personal-only Let Go including caretaker-priority behavior, Mythic/Legendary tiers, sequence/duration/audience, and Full/Short/Off plus Reduced Motion settings are user-approved. Exact panel geometry, wording, controller mapping validation, audio, and asset treatment remain provisional. No wireframe or implementation exists.
- Test evidence: Direct user direction and independent QA/UI, Security/Architecture, and VFX/Audio/Performance reviews on 2026-07-19. No visual, comprehension, controller, mobile, accessibility, or Studio test exists.
- Mistakes discovered: Reusing a held Capture input for Retry could immediately spend another item. `Let Go` without personal-scope copy could imply despawning the creature for everyone. Optimistic success UI could appear before the owned record exists.
- Recommended future approach: Prototype Ready, In Flight, Failure Decision, Queued, invalidated, other-winner, expired, ownership-committed, skip, and reduced-motion states; test fresh-button guards, no click-through, focus restoration, exact odds, and low-width text before art polish.
- Confidence level: High for state/disclosure requirements; Medium for interaction layout; Low for animation until prototyped
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Entry: Transparent competitive capture panel

> Follow-up (2026-07-19): The user later approved accepted-failure consumption, +2-point Familiarity with tier guarantees/persistence/reset, distinct-contender round-robin, and deliberate Retry/Let Go. The newer entry above governs the failure-result UI.

- Date: 2026-07-19
- Agent: UI Agent / Game Design Agent / Security Agent / Monetization Agent / QA Agent / Codex
- System affected: Wild visitor interaction, rarity, capture odds, storage, priority/open state, items, luck, accessibility, mobile/controller, and originality
- Situation: Players need to distinguish a visitor's arrival rarity from capture chance, understand who may try, and know whether an attempt will consume a free item without copying a familiar capture-game interface.
- Decision made: The future panel must show visitor name, visible tier, `Arrival rarity` separately from `Capture chance`, server-authored base and final chance, selected capture item, selected free luck aid if any, Backpack status, caretaker-priority/open state, and visit time. If Familiarity is approved, show its exact contribution and guarantee progress. Confirmation must state which item will be consumed on a valid accepted roll; invalid/full/busy requests show no-consumption status. Preserve enough decimal precision that a small nonzero value never displays as zero. Use original sanctuary/field-journal components and a non-ball item/presentation; avoid copied capsule, shake-count, sound, icon, catchphrase, layout, and “almost won” expression. Never surface a storage purchase from a full or expiring wild encounter.
- Reasoning summary: Transparent two-stage odds prevent misunderstanding, while explicit status prevents accidental consumption and premium pressure. Original expression protects the game's identity.
- Result: Tier labels/base chances, Haven Tag identity/expression, priority timing/open early, tutorial certainty, deliberate immediate retry, all accepted-attempt cost, exact Familiarity increment/guarantees/persistence/reset, public round-robin, No Aid retry default, guaranteed-attempt Luck disabling, caretaker Let Go behavior, five-minute timer, proximity, fixed traits, and one free next-attempt aid are user-approved. Exact panel geometry, Luck multipliers/recipes, normal animation details, and copy remain provisional. No wireframe exists.
- Test evidence: Game Design/Economy/QA and Architecture/Data/Security/Monetization/Performance reviews on 2026-07-19. No visual, accessibility, device, comprehension, or Studio test exists.
- Mistakes discovered: One generic “rarity” label would conflate spawn scarcity with success chance. Rounding 0.01% to 0% would be deceptive even when the value is only an example.
- Recommended future approach: Disable Capture only while its authoritative roll is in flight, then re-enable immediately with exact updated chance/guarantee progress and no timer. Wireframe full, invalid, busy, queued, lost-race, expired, failure, and success states; test touch, autoclick, controller focus, reduced motion, stale updates, contention, and first-time comprehension.
- Confidence level: High for disclosure/accessibility needs; Medium for layout until prototyped
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Entry: Grow a Garden UI reference boundary

- Date: 2026-07-19
- Agent: Codex / UI and Game Design Agents
- System affected: Navigation, HUD, hotbar, inventory, vendor dialogue, currency display, world signage, onboarding, and originality
- Situation: The user asked Codex to inspect Grow a Garden's UI as a direct usability reference before Catch a Creature's Phase 1 interface is designed.
- Decision made: Borrow the reference's interaction clarity—not its exact expression. Useful patterns observed in current screenshots are persistent destination actions for seed shopping, garden return, and selling; a bottom quick-access bar that exposes item names, quantities, weight, or age where useful; a simple NPC sell conversation with sell/appraise choices; a visible currency balance; and readable market-stall signage. Catch a Creature will reinterpret these needs through original pastel field-journal panels, rounded shapes, custom icons, original copy and placement, `Leafnotes`, `Sunspud`, a separate backpack, creature-journal language, and accessible responsive layouts. Do not trace, reproduce, or imitate the reference's exact assets, colors, typography, panel geometry, labels, screen composition, or branded terms.
- Reasoning summary: The reference reduces navigation uncertainty and keeps the farming economy visible, but a clear originality boundary is required so Catch a Creature develops its own recognizable visual and narrative identity.
- Result: The Phase 1 wireframe may use a small persistent Shop / Your Plot / Sell destination cluster, bottom ten-slot quick access plus backpack access, visible Leafnotes, weight on relevant harvested items and creatures, and a concise vendor dialogue. Exact screen positions, icon art, component shapes, animation, copy, and responsive breakpoints remain unresolved and require original design.
- Test evidence: Visual review of publicly indexed gameplay screenshots on 2026-07-19. No Catch a Creature wireframe, implementation, accessibility review, device test, comparison study, or Roblox Studio playtest exists.
- Mistakes discovered: Treating “similar gameplay” as permission to reproduce the source UI would collapse the project's identity and create unnecessary copying risk. Functional reference notes must stay separate from final creative expression.
- Recommended future approach: Build low-fidelity original wireframes around player tasks, then test first-session comprehension without naming the reference. Confirm every control works on touch, keyboard/mouse, and controller; offer a nonanimated tutorial cue; and keep routine menus from obscuring the garden.
- Confidence level: High for the observed interaction patterns; Medium for their fit until wireframed and playtested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented
- Sources: [Grow a Garden beginner seed-shop screenshot](https://www.sportskeeda.com/roblox-news/grow-garden-a-beginner-s-guide), [Grow a Garden market-stall screenshot](https://www.sportskeeda.com/roblox-news/iconic-gnome-crate-grow-garden-price-items-chance), and [Grow a Garden inventory screenshot](https://deltiasgaming.com/how-to-do-the-sprinkler-glitch-in-grow-a-garden-roblox/). These are community/editorial references, not authoritative product specifications.

## Entry: Guided first-session travel and farming UI

- Date: 2026-07-19
- Agent: UI Agent / Gameplay Agent / Codex
- System affected: Tutorial guidance, fast travel, shop, plot placement, hotbar, growth, harvest, appraisal, and selling
- Situation: The user specified the first-session UI sequence in detail after approving a five-minute farming hook.
- Decision made: Draw attention to Shop with a breathing/bouncing treatment and a nonanimated reduced-motion alternative; clicking it uses permanently free travel to the shop and guides purchase of always-stock Sunspud. After shop exit, `Your Plot` permanently fast-travels home. Use ten bottom-center quick-access slots that reference the 200-slot authoritative Backpack, plus a small backpack button that opens virtualized full storage. Desktop/tablet may show all ten; phones show stable slots 1–5 or 6–10 with explicit paging controls and an off-page equipped indicator. Selecting Sunspud enters free placement anywhere valid within the plot; one-stud snapping defaults off, no minimum spacing is required, and the exact identical transform is rejected. Show plant-icon percentage growth to 100%, then Harvest and server-authored whole-plant weight reveal. A permanently free Sell action travels to the vendor, whose approved top-level choices are `Sell the item I'm holding`, `Sell all unfavorited harvests`, and `Appraise`; Appraise exposes held-item value and total-inventory value. Shop, `Your Plot`, and Sell remain visible in ordinary gameplay but cannot click through an open Backpack, vendor menu, confirmation, or Roblox modal.
- Reasoning summary: Each visible action points directly to the next meaningful farming step and removes early navigation uncertainty.
- Result: The UI flow, Sunspud identity/universal timing, permanent free travel, 200-slot Backpack, 999 compatible ordinary-seed maximum, individual special seeds/weighted assets, ten logical hotbar positions, five-at-once phone paging, snap default/size, exact-transform rejection, no required spacing, whole-plant weight, favorite-protected Sell Held, favorite-safe harvest bulk sale, and appraisal split are approved for design. Repeatable +200 capacity is presented as paged Developer Product storage up to the approved 1,200-slot launch maximum after measurement gates pass. Exact component layout, original copy, animation amplitude, reduced-motion presentation, canonical stack key, product price/name/ID, page/shard presentation, and travel presentation remain provisional.
- Test evidence: Direct user direction on 2026-07-19; no wireframe, device test, accessibility review, or Studio evidence exists.
- Mistakes discovered: Treating ten visible slots as total storage would create no-loss and capacity problems. The first interpretation also treated valuation requests as replacing the approved individual sale action; the final menu now separates Sell Held, favorite-safe Sell All, and Appraise.
- Recommended future approach: Keep the hotbar as references into one authoritative inventory; virtualize and search/filter paged 200-plus inventory; show current and resulting capacity before deliberate Developer Product prompts; stop prompts at the tested maximum; make phone hotbar page buttons/dots primary so swipes do not fight camera controls; auto-reveal or indicate off-page equipped slots; use scale/glow plus a nonanimated outline for reduced motion; keep touch targets large; preserve camera orientation on travel; show free full-storage actions before neutral store access; never trigger a product prompt from harvest failure or theft risk; show clear favorites and sale eligibility; and make Appraise explicitly read-only.
- Confidence level: High for the requested sequence; Medium for exact navigation and menu behavior until wireframed
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Initial direction

- Friendly illustrated field-journal language
- Rounded cream panels and soft brown outlines
- Original iconography
- Category color plus icon plus text; never color alone
- Large mobile-friendly interaction targets
- Desktop, mobile, tablet, and controller parity
- Purchase information separated from failure or disappointment moments
- Exact odds and live prices wherever policy requires them
- World view remains visible during routine actions

Status: Not yet implemented. Accessibility and device behavior require real testing.

Document type: Baseline guidelines, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.

## 2026-07-21 Empty quick slots and rig-safe held items

- Date: 2026-07-21
- Agent: Codex / UI Agent
- System affected: Hotbar state projection and avatar-held item feedback
- Situation: Reserved seed slots visually claimed ownership at quantity zero, while the R15 hand pose could distort walking.
- Decision made: Represent absence as a nil hotbar assignment rendered as `EMPTY`; never make unavailable content selectable. Use one-joint R6 posing and an arm-only R15 IK chain.
- Reasoning summary: Visual availability must match authoritative inventory state, and cosmetic holding must never own torso locomotion joints.
- Result: Empty selection is honest and inert; held seeds/items remain visible with a forward R6 arm and a walk-safe R15 fallback.
- Test evidence: Fresh Studio click test, R15 walk assertions, isolated R6 geometry/movement assertions, and a progress still.
- Mistakes discovered: A fixed-slot label was treated as an owned stack, and the first IK chain was broader than the visual requirement.
- Recommended future approach: Derive slot interactivity from positive authoritative quantity and constrain character presentation to the smallest possible joint chain.
- Confidence level: High for desktop logic; Medium for final R6 place configuration until Avatar Settings is applied and a normal spawn is retested.
- Verification status: Verified for hotbar/R15; R6 presentation Simulated

## 2026-07-21 Exact cursor reticle and ordered acquisition

- Date: 2026-07-21
- Agent: Codex / UI Agent
- System affected: Placement overlay and numbered hotbar
- Situation: Players need the plant to land at the cursor tip and new pickups to fill the next visible number without hidden reservations.
- Decision made: Use a small screen-space ring and center dot whose center is the exact desktop coordinate supplied to `ScreenPointToRay`; show green only for a valid server-eligible plot hit and red otherwise. Keep the world free of placement bubbles. Render only saved, positive inventory references and allocate the lowest open slot from 1 through 10.
- Reasoning summary: One coordinate source eliminates inset drift, while visible-state-only hotbar ownership makes the next slot predictable.
- Result: The reticle aligns with the committed plot coordinate, and current seed/plant acquisitions fill and reuse slots numerically without moving existing references.
- Test evidence: Exact `(-20.000,-20.000)` saved plot-local placement; green reticle capture; schema v5 migration tests; fresh 61/61 Server VM cases; live slot-1 reuse.
- Mistakes discovered: A world marker obscured precision, `InputObject.Position` did not match the ray's inset convention in Studio, and fixed empty seed reservations contradicted visible emptiness.
- Recommended future approach: Every pointer UI must share its coordinate source with the hit-test API. Every hotbar acquisition type, including future creatures, must call the same ordered allocator and add a full-hotbar test.
- Confidence level: High for desktop mouse and current seed/plant types
- Verification status: Verified; real touch/controller and creature acquisition remain open
