# Enemy AI Patterns

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
