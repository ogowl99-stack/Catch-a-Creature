# Performance Agent Memory

## 2026-07-21 seed-foraging update

- Tasks completed: Bounded the system to six event-driven nodes and an auto-cleaned local Mythic effect
- Strengths demonstrated: Avoided polling, pathfinding, per-frame replication, and permanent VFX
- Mistakes made: No frame-time, memory, or network profiling was run
- Bugs introduced: None found by instance/cleanup checks
- Bugs prevented: Unbounded node multiplication and leaked Mythic instances
- Review feedback received: Instance counts are evidence of boundedness, not proof of device performance
- Useful patterns discovered: Success-only work and fixed-lifetime local presentation keep ordinary idle cost low
- Areas requiring improvement: Minimum-device profiling and concurrent rare-effect stress
- Current project knowledge: Each node has 13 descendants; Mythic creates 18 motes and cleans after 3.5 seconds
- Unresolved questions: p95 frame impact, memory recovery, graphics degradation, and remote traffic
- Recent evaluation scores: Joint forage slice Overall 95
- Next improvement goal: Measure six nodes plus overlapping simulated Mythic effects on the target low-end device

- Tasks completed: Identified multiplicity risks and collected scoped Studio scene baselines before and after the expanded land/plot/trail layout
- Strengths demonstrated: Refusal to fabricate measurements and multiplicity-first analysis
- Mistakes made: The first measurement is only one desktop camera view and includes default Roblox player/runtime content
- Bugs introduced: None
- Bugs prevented: Premature catalog multiplication, unbounded storage claims, continuous pathfinding, and expensive invalid-request feedback were blocked in design
- Review feedback received: Measure representative crowded multiplicity; estimates must stay labeled Estimated
- Useful patterns discovered: Central low-frequency wandering, globally budgeted recovery, one attempt per creature/player, rejected-spam fast path, performance gates before content multiplication
- Areas requiring improvement: Roblox profiling workflow and device matrix
- Current project knowledge: The expanded Phase 2 root has 684 descendants and 602 BaseParts. One current play view measured 1,149 scene instances, 55,898 non-shadow triangles, and 63 non-shadow draws; this is a scoped baseline, not a production or device budget. Future mount rigs/physics remain unmeasured.
- Unresolved questions: Client/server frame time, memory growth, network/path costs, crowded gardens, lowest-device behavior, retry/write throughput, effect cleanup, emergency storage ceiling, and 1,200+ records
- Recent evaluation scores: Overall 95 for the first baseline; expanded-layout baseline recorded without a new score yet
- Next improvement goal: Extend fixed-camera baselines to frame time, memory, streaming, physics, network, crowded 96×96 plots, creatures, mounts, and lowest-target-device evidence

## 2026-07-21 Hearthpetal/Cozzle update

- Tasks completed: Bounded first visitor to one anchored model and one pending record per player
- Strengths demonstrated: Avoided pathfinding, physics, particles, per-frame movement, and idle server animation
- Mistakes made: No profiler capture was taken during the first live arrival
- Bugs introduced: None observed
- Bugs prevented: Unbounded visitor multiplication and movement-loop cost
- Review feedback received: Replace 0.25-second polling before broader creature counts
- Useful patterns discovered: One Tween entrance plus hard model cleanup is enough for the first visual proof
- Areas requiring improvement: Actual frame/memory/network measurement and eight-player arrivals
- Current project knowledge: Fixture model has 20 descendants; performance remains unmeasured
- Unresolved questions: Streaming visibility, simultaneous Tweens, and future roaming budget
- Recent evaluation scores: Hearthpetal/Cozzle joint score recorded in AgentScores
- Next improvement goal: Profile one and eight simultaneous visitor arrivals before adding movement
