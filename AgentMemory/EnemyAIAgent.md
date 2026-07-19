# Enemy AI Agent Memory

- Tasks completed: Defined a low-cost initial visitor-state concept; confirmed hostile AI is outside the first playable; received the approved Observe → Care → Bond encounter contract
- Strengths demonstrated: Scope restraint
- Mistakes made: No behavior prototype exists
- Bugs introduced: None
- Bugs prevented: None; design risks identified before implementation: expensive pathfinding and hostile behavior before need is proven
- Review feedback received: Creature animation and clues should communicate state clearly
- Useful patterns discovered: Arrive, observe, approach, display clue, interact, resolve, leave/rest
- Areas requiring improvement: Deterministic state ownership and cleanup
- Current project knowledge: Creatures are visitors and companions; only an already captured/bonded creature that is roaming or displayed on its owner's plot can become eligible for the separately approved paid true-transfer feature; wild visitors and stored creatures are protected
- Unresolved questions: Navigation radius, obstacle response, flocking need, server/client simulation split
- Recent evaluation scores: Not yet numerically evaluated
- Next improvement goal: Design deterministic low-cost visitor behavior with explicit cleanup
