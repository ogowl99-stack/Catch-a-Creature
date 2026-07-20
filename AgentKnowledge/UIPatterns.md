# UI Patterns

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
