# UI Agent Memory

## 2026-07-21 held item, selling, and hero-view update

- Tasks completed: Added held-item feedback, favorite star controls, equipped/bulk sell choices, favorite-protection copy, and real-HUD map composition review
- Strengths demonstrated: Preserved exact name/weight visibility, separated destructive scopes, and used the existing top-center navigation layout while scaling the landmark around it
- Mistakes made: Initial map review did not include the active tutorial/HUD, so the 180-stud tree was still visually covered
- Bugs introduced: None found
- Bugs prevented: Ambiguous single sale, accidental favorite sale, invisible equip feedback, and a focal landmark hidden by the HUD
- Review feedback received: Shop/Your Plot/Sell remain top-center; the Memory Tree must still dominate the scene
- Useful patterns discovered: Review focal world art with every persistent HUD layer visible, not only clean viewport shots
- Areas requiring improvement: Touch/controller focus, reduced motion, observer equip state, narrow screens, and other avatar proportions
- Current project knowledge: Sell panel exposes exact equipped item plus `SELL ALL UNFAVORITED`; Plot 1 staged camera shows the 255-stud crown above and beside the HUD
- Unresolved questions: Whether tutorial panel should collapse sooner and whether bulk sale needs confirmation for high-value inventories
- Recent evaluation scores: Joint held/selling overall 95
- Next improvement goal: Make item-selection and landmark readability equally clear on phone/tablet/controller layouts

## 2026-07-21 seed-foraging update

- Tasks completed: Added forage success/cooldown messaging and a prominent Mythic seed-found banner
- Strengths demonstrated: Reused the existing inventory/hotbar projection and kept ordinary feedback lightweight
- Mistakes made: No real touch/controller or reduced-motion UI test exists
- Bugs introduced: None found in desktop Studio
- Bugs prevented: Presentation awarding items and ambiguous Mythic wording
- Review feedback received: Mythic should look special but not require a disruptive camera sequence
- Useful patterns discovered: World prompt, small ordinary notice, and rare hero banner can share one authoritative result
- Areas requiring improvement: Responsive banner layout, localization, Reduced Motion/Off, and real-device focus/input
- Current project knowledge: The ProximityPrompt supports E, ButtonX, click, and touch; only desktop E was physically tested
- Unresolved questions: Final copy, rarity colors, sound/caption behavior, and inventory discovery cues
- Recent evaluation scores: Joint forage slice Overall 95
- Next improvement goal: Verify the prompt and banner across phone, tablet, and controller

- Tasks completed: Established field-journal/multi-device direction; reviewed UI reference boundaries; reconciled tutorial, inventory/vendor/capacity UI; defined transparent original capture-panel requirements; and implemented/reviewed the Phase 3A direct-placement, numbered-hotbar, harvested-item label, and centered-travel revision
- Strengths demonstrated: Tone, readability, accessibility, and monetization-presentation awareness
- Mistakes made: The first centered travel-row pass overlapped the stats card on a compact viewport, and the first shortcut pass did not explicitly disable Roblox's built-in Backpack hotbar
- Bugs introduced: None
- Bugs prevented: Color-only meaning, copied UI expression, rounded-to-zero odds, accidental item consumption, aggressive notifications, and purchase prompts after failure were identified before implementation
- Review feedback received: Keep the world visible; separate arrival rarity from capture chance; show actual server-computed odds and no-consumption reasons; reduce planting cursor travel; bind 1-9/0 to matching hotbar slots; show harvested item name/weight; group Shop/Plot/Sell at top center
- Useful patterns discovered: Icon + color + text; compact journal tabs; stable hotbar pages; exact odds/details; clear priority/open/storage states
- Areas requiring improvement: Physical top-row shortcut verification, post-harvest label capture, mobile scaling, controller focus, reduced motion, and stale-contention feedback
- Current project knowledge: After durable failure, show consumed Tag/aid, `Familiarity +2`, exact next chance/guarantee, time, inventory, and queue, then require fresh `Retry Capture` or `Let Go`. Retry may enter `Waiting — N ahead`; personal Let Go preserves progress. Success UI/cutscene appears only after ownership commit and must support immediate skip/reduced motion.
- Unresolved questions: Exact wireframe/copy; Luck formula/recipes; exact audio/assets; runtime product display; modal/controller focus; HUD/Appraise presentation
- Recent evaluation scores: Overall 98 jointly for failure-decision and rare-celebration review; prior capture score 97
- Next improvement goal: Finish physical keyboard/touch/controller hotbar verification and preserve stable multi-item slot assignments before expanding the inventory UI

## 2026-07-21 backpack and kiosk-access update

- Tasks completed: Built the bottom-left backpack toggle/panel; removed the redundant top-left Backpack count; displayed exact Sunspud weights and Hotbar/Stored state; wired two-way right-click organization; added visible Shop/Sell proximity prompts
- Strengths demonstrated: Compact responsive placement, clear item-state language, exact identity projection, and minimal interruption of the world view
- Mistakes made: The first inventory interaction patch lacked its button connection during one live run; immediate source/UI inspection caught it before approval
- Bugs introduced: None remaining
- Bugs prevented: Item deletion during organization, slot-1 removal, hidden capacity duplication, roof-only service access, and client-authoritative slot mutation
- Review feedback received: Right-click should work whether the panel is open or closed; nearby prompts may open presentation only; touch/controller need visible alternatives
- Useful patterns discovered: Backpack owns items while hotbar owns references; `Hotbar N` versus `Stored` card copy; bottom-left button above responsive hotbar; server snapshot rerender after durable commit
- Areas requiring improvement: Touch/controller Store/Add controls, focus order, and narrow travel-label clipping
- Current project knowledge: Live unassignment preserved the exact item and changed the card to Stored. Assignment uses the first free server slot. Fast travel lands in front; prompts visibly offer E/ButtonX/click access without movement.
- Unresolved questions: Final inventory art/icons, drag/drop policy, sorting/filtering, touch context menu, controller focus, and large-inventory virtualization
- Recent evaluation scores: Overall 97 jointly for persistence/backpack/service-access follow-up
- Next improvement goal: Add accessible touch/controller Store/Add actions and verify those alternatives on real devices

Stakeholder confirmation (2026-07-21): The user physically tested the completed inventory and kiosk-access revision in Studio and reported, "it works." This verifies the requested desktop right-click movement and nearby service access in the current one-player Studio environment; it does not verify touch, controller, multiplayer, or production behavior.

## 2026-07-21 Hearthpetal/Cozzle update

- Tasks completed: Built the two-section Habitat Seeds modal, slot-2 Hearthpetal projection, generic item names, and first visitor label
- Strengths demonstrated: Clear experimental/unowned copy and distinct warm plant/button color
- Mistakes made: First Cozzle/plant labels overlapped along the arrival-pad sightline
- Bugs introduced: None remaining; label size/offset and visitor approach were adjusted
- Bugs prevented: Sunspud-only inventory/sell text and cramped one-line Hearthpetal hotbar text
- Review feedback received: Keep long seed names wrapped and ownership state explicit
- Useful patterns discovered: Snapshot catalog drives all definition-specific UI copy
- Areas requiring improvement: Physical slot-2 input, phone layout, controller focus, touch Observe, and label density
- Current project knowledge: Current shop has two experimental seeds; Cozzle is visibly wild/unowned
- Unresolved questions: Observe card/prompt presentation and final icon/art system
- Recent evaluation scores: Hearthpetal/Cozzle joint score recorded in AgentScores
- Next improvement goal: Design and test an accessible Observe prompt/state card on desktop, touch, and controller

## 2026-07-21 honest empty slots and R6 hold pose

- Tasks completed: Changed zero-quantity seed slots to `EMPTY`; blocked empty equip/placement; added a straight-forward R6 right-arm hold pose; constrained the R15 fallback to the right arm
- Strengths demonstrated: Matched visual availability to authoritative state and isolated cosmetic posing from torso locomotion
- Mistakes made: The earlier renderer exposed fixed seed definitions at quantity zero, and the first R15 IK chain began at the torso
- Bugs introduced: None found in the completed desktop checks
- Bugs prevented: Phantom owned seeds, misleading purchase errors, torso twist/jitter, orphan R6 shoulder transforms on cleanup
- Review feedback received: User wants the arm straight forward and selected R6 as the target rig
- Useful patterns discovered: Nil assignment is the canonical empty-slot state; smallest-joint-chain posing is safer than broad IK
- Areas requiring improvement: Normal-spawn R6 verification, mobile/controller input, emotes, climbing/swimming, body scales, and first-person behavior
- Current project knowledge: Rojo builds R6, but the already-open place still requires the one-time Avatar Settings change; R15 remains supported during transition
- Unresolved questions: Whether final held plants should stay upright or rotate with the R6 wrist, and how two-hand items should be presented
- Recent evaluation scores: 96 overall for this bounded hotbar/held-pose revision
- Next improvement goal: Verify the normal R6 spawn and held pose across movement states and device inputs

## 2026-07-21 exact placement reticle update

- Tasks completed: Replaced the world placement bubble with a green/red 2D reticle and projected dynamic saved slots 1-10
- Strengths demonstrated: Made the precision indicator use the same coordinate as the ray and kept the placement overlay visually small
- Mistakes made: Initially tried `InputObject.Position`, which ignored the Studio window inset expected by `ScreenPointToRay`
- Bugs introduced: None remaining in the one-client desktop pass
- Bugs prevented: Cursor drift, same-click accidental placement, phantom zero-count seeds, and misleading slot order
- Review feedback received: The plant must land at the cursor tip and acquisitions must fill numbers predictably
- Useful patterns discovered: One pointer source for presentation and hit testing; visible owned refs only
- Areas requiring improvement: Touch/controller coordinates, real-device safe areas, arbitrary drag/reorder UX, and accessibility states
- Current project knowledge: Desktop reticle placement saved the exact intended plot-local coordinate; slot 1 was released and reused after seed consumption
- Unresolved questions: Final reticle art, reduced-motion feedback, and touch finger-occlusion offset
- Recent evaluation scores: Overall 96 for this bounded slice
- Next improvement goal: Verify touch/controller placement coordinates and design a deliberate slot-reorder interaction
