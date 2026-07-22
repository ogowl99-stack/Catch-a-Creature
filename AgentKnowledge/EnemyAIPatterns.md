# Enemy AI Patterns

## Entry: Derived one-visitor attraction projection before AI movement

- Date: 2026-07-21
- Agent: Codex / Enemy AI, Gameplay, Architecture, Security, Performance, and QA roles
- System affected: First Cozzle arrival, attractor selection, model projection, cleanup, and future encounter state
- Situation: The project needed a visible creature milestone before authoritative Observe/Care/Capture or roaming was ready.
- Decision made: Select the earliest plotted Hearthpetal with item-ID tie-break, schedule one Cozzle three seconds after maturity, cap one per player, mark it wild/unowned/non-capturable, and remove/reselect it when the attractor leaves. Use a single Tween entrance and anchored parts; no pathfinding or idle movement.
- Reasoning summary: Deterministic derived presentation proves the ecology link without inventing untested ownership, contention, or navigation.
- Result: One live Cozzle arrived and the integration fixture removed it after attractor deletion; five selection tests pass.
- Test evidence: 5/5 pure cases, live runtime attributes, one-model/20-descendant fixture, clean console.
- Mistakes discovered: Pure inward placement aligned subjects; adding a tangent improves sightline separation.
- Recommended future approach: Add authoritative lifetime and Observe state before any roaming; replace polling with scheduled deadlines before increasing counts.
- Confidence level: High for current projection; Low for AI/navigation because none exists
- Verification status: Verified projection; movement not implemented

## Entry: Wild visitor contest state model

> Follow-up (2026-07-19): Personal Observe/Care/Trust, 60-second caretaker priority/open early, five-minute public lifetime, proximity, fixed traits, and immediate no-cooldown rising-chance retry are now user-approved. A failed attempt returns directly to Wild after its authoritative commit; there is no gameplay Cooldown state.

- Date: 2026-07-19
- Agent: Enemy AI Agent / Gameplay Agent / Architecture Agent / Performance Agent / QA Agent / Codex
- System affected: Visitor arrival, host plot, Observe/Care, public capture, reservation, cooldown, despawn, roaming, and cleanup
- Situation: A visitor now remains wild through multiple players' interactions and may receive capture attempts before one player owns it.
- Decision made: Replace the old terminal `Bond` state with global `Arrive → Priority → Open/Wild → AttemptReserved → Captured | AttemptFailed → Wild → Leave`, plus per-player `Unobserved → Observed → Cared/Trusted → Eligible → AttemptInFlight → FailureDecision/Owned`. `FailureDecision` branches to one fair pending Retry intent or personal Let Go; neither creates a global Cooldown state. Capture failure must not transfer ownership or change the fixed visible trait payload; full storage and Let Go must not reserve, despawn, or change the visitor. Only committed success creates the owned companion representation. Use bounded local waypoint roaming and explicit cleanup for visitor, prompt, reservation, queue intent, personal state, timers, and connections.
- Reasoning summary: Global encounter state and personal eligibility cannot be one shared flag: one player's Care progress must not silently create ownership or eligibility for everyone. Separating them also supports fair contention and bounded cleanup.
- Result: The state sequence, personal Care requirement, priority/open timing, deliberate no-cooldown Retry/Let Go including caretaker-priority preservation, five-minute public lifetime, all accepted-attempt consumption, No Aid retry default, guaranteed-attempt Luck disabling, distinct-contender round-robin, and starting caps are approved directions. Expiry commit grace, exact Luck formula/recipes, and navigation values remain provisional and unimplemented.
- Test evidence: Two cross-functional design reviews on 2026-07-19. No AI module, pathfinding, multiplayer, cleanup, performance, or Studio test exists.
- Mistakes discovered: The baseline `Bond/flee/leave` terminal list assumed a single deterministic owner and could not represent contested reservations or player-specific progress.
- Recommended future approach: Confirm the remaining choices, then implement a pure transition table before any model animation; prove cleanup and exact-one capture under disconnect, despawn, and simultaneous attempts; add movement only after state tests pass.
- Confidence level: High for state separation; Low for timing and movement until approved and tested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Current state

No hostile enemy system is planned for the first playable. Creature behavior should begin with deterministic, low-cost visitor states:

- Arrive
- Observe
- Approach habitat signal
- Display clue
- Interact
- Trust/capture/fail/leave
- Rest or follow a bounded local route

Pathfinding, flocking, and hostile behavior require separate performance and fairness review before adoption.

Status: Not yet implemented.

Document type: Baseline guidelines, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.
