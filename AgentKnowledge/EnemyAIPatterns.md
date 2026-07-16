# Enemy AI Patterns

## Current state

No hostile enemy system is planned for the first playable. Creature behavior should begin with deterministic, low-cost visitor states:

- Arrive
- Observe
- Approach habitat signal
- Display clue
- Interact
- Bond/flee/leave
- Rest or follow a bounded local route

Pathfinding, flocking, and hostile behavior require separate performance and fairness review before adoption.

Status: Not yet implemented.

Document type: Baseline guidelines, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.
