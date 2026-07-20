# Performance Findings

## Entry: Rare-capture celebration must degrade without delaying ownership

- Date: 2026-07-19
- Agent: Performance Agent / VFX Agent / Audio Agent / Security Agent / QA Agent / Codex
- System affected: Capture celebration, client frame time, memory, particles, sounds, connections, networking, camera, cleanup, and crowded servers
- Situation: The user requested a super-rare capture cutscene/VFX while capture already permits rapid contested retries and up to 64 estimated simulated creatures per server.
- Decision made: Keep ownership and queue resolution independent of presentation. Emit one compact post-commit descriptor; animate locally; allow at most one full hero celebration per client; downgrade overlaps/low graphics/streaming failures to Short or journal-only; cap nearby effects globally; never mutate global Lighting or replicate per-frame animation; and hard-clean temporary instances, sounds, connections, camera state, and UI locks. The VFX knowledge file records intentionally conservative starting estimates, not safe budgets.
- Reasoning summary: Even naturally rare events must be stress-tested concurrently. Cosmetic load may degrade, but valuable ownership and other players' controls may not wait on it.
- Result: Performance architecture is code-reviewed; all counts and frame goals remain Estimated. No profiler or Studio measurement exists.
- Test evidence: Independent VFX/Audio/Performance and Security/Architecture reviews on 2026-07-19. No runtime measurement exists.
- Mistakes discovered: Assuming Mythic rarity prevents simultaneous effects would leave event/admin/test scenarios unbounded. Cosmetic cleanup failure can produce persistent memory, connection, camera, or sound growth.
- Recommended future approach: Stress synthetic concurrent qualifying captures; measure p95/worst client/server frame time, memory recovery, instances, connections, particles, sounds, network payload, skip latency, camera restoration, and cleanup failures on the target device matrix before locking caps.
- Confidence level: High for degrade/cleanup architecture; Low for every numerical target until measured
- Verification status: Estimated
- Implementation status: Not yet implemented

## Entry: Initial wild and owned creature multiplicity estimates

> Follow-up (2026-07-19): The user approved two wild and six displayed owned creatures per plot and 64 simulated creatures per server as starting caps. They are approved configuration targets, not measured safe budgets. Immediate retry adds an attempt-throughput measurement requirement.

- Date: 2026-07-19
- Agent: Performance Agent / Enemy AI Agent / Security Agent / QA Agent / Codex
- System affected: Wild visitors, deployed owned creatures, wandering, pathfinding, capture requests, VFX, replication, memory, connections, and eight-player servers
- Situation: Open wild capture and roaming owned creatures increase simultaneous agents, interactions, and visual effects without any measured runtime budget.
- Decision made: Treat the following only as graybox starting estimates: at most two wild visitors per occupied plot and 16 per eight-player server; six roaming/displayed owned creatures per plot and 48 per server; 64 server-simulated creatures total; one active capture attempt per player and visitor; and at most eight active capture effects. Use bounded waypoint wandering through a central low-frequency scheduler, client presentation/interpolation, and globally budgeted stuck-recovery pathfinding rather than per-creature Heartbeat, Touch, continuous pathfinding, or per-frame CFrame remotes. Rejected spam produces no RNG, VFX, pathfinding, or persistence work.
- Reasoning summary: The feature multiplies by plots, visitors, owned displays, contenders, and retries. Central scheduling and hard provisional caps create a measurable starting point without pretending the limits are safe.
- Result: The numerical starting caps are user-approved but remain unmeasured. Central scheduling, attempt/effect limits, and no-work rejection are code-reviewed architecture directions. No implementation exists.
- Test evidence: Read-only Performance/Security review on 2026-07-19. No frame-time, memory, instance, connection, pathfinding, remote, VFX, device, or Studio measurement exists.
- Mistakes discovered: A chance-based public retry loop could accidentally produce work on every invalid client request; expensive feedback must start only after server acceptance.
- Recommended future approach: Measure one, crowded, and eight-plot scenarios plus sustained immediate retries; capture server/client frame time, memory, instances, connections, network traffic, path calculations, accepted/rejected attempts, durable outcome latency, queue depth, RNG calls, active effects, and cleanup; lower or raise caps only from evidence.
- Confidence level: Medium for the low-cost pattern; Low for all numerical caps until measured
- Verification status: Estimated
- Implementation status: Not yet implemented

## Entry: Budget before multiplication

- Date: 2026-07-16
- Agent: Performance Agent
- System affected: Models, plants, creatures, VFX, audio, connections
- Situation: The design may place many growing plants, creatures, decorations, particles, and sounds in each plot.
- Decision made: Establish measured budgets using a representative crowded plot before content multiplication.
- Reasoning summary: A small asset that is safe once may be expensive when duplicated across all plots and players.
- Result: Performance gate added to the production plan.
- Test evidence: No measurements exist; requires Roblox Studio and device testing.
- Mistakes discovered: No fabricated budgets will be accepted.
- Recommended future approach: Measure frame time, memory, instances, particles, active sounds, connections, and network traffic with realistic multiplicity.
- Confidence level: High
- Verification status: Not yet implemented

## Current measurements

None. Any future number must be labeled measured, simulated, or estimated.
