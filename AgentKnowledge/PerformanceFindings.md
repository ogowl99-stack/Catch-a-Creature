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

Phase 2 graybox, one-client desktop play view on 2026-07-20: SceneAnalysisService reported 104,666 total triangles and 114 total draws including 50,454 shadow triangles and 46 shadow draws. Excluding the shadow pass, the measured view was approximately 54,212 triangles and 68 draw calls. Composition included the default player/runtime as well as the 466-descendant graybox. This is one camera/view and is not a mobile, crowded, or production budget.

## Entry: First measured graybox scene baseline

- Date: 2026-07-20
- Agent: Performance Agent / Codex
- System affected: Phase 2 world geometry, rendering composition, instance multiplicity, and future modeling budget
- Situation: The first full island graybox created a chance to replace the project's no-measurement state with a scoped baseline.
- Decision made: Measure the running one-client scene through Studio SceneAnalysisService and report total plus shadow-excluded composition without declaring a final performance budget.
- Reasoning summary: A desktop graybox snapshot is useful for detecting future growth, but it cannot predict low-end mobile, eight-player gardens, creatures, VFX, UI, or network cost.
- Result: The current graybox root has 466 descendants and 384 BaseParts. One view measured about 54,212 non-shadow triangles and 68 non-shadow draw calls; reported totals including shadows were 104,666 triangles and 114 draws.
- Test evidence: Direct Studio play-mode SceneAnalysisService output on 2026-07-20.
- Mistakes discovered: The scene totals include Roblox/default character/runtime content, and a single view cannot be generalized to the whole device matrix. Raw total triangles double-count shadow work for a simple controllable-geometry comparison.
- Recommended future approach: Repeat the same camera baselines after each art-replacement milestone, then profile a representative crowded plot and eight-player server on the lowest target device. Record frame time, memory, network, instances, particles, sounds, connections, and cleanup in addition to draw complexity.
- Confidence level: High for the recorded snapshot; Low for production capacity conclusions
- Verification status: Verified
- Measurement boundary: One desktop client, one graybox view, no gameplay load

### Follow-up: Expanded-land scene baseline

- Date: 2026-07-20
- Agent: Performance Agent / Codex
- System affected: Expanded land grid, larger plot ring, perimeter trail, Terrain ocean, and client rendering
- Situation: The island expansion added 182 land parts and 36 trail parts, increasing the graybox root from 466 descendants/384 BaseParts to 684 descendants/602 BaseParts.
- Decision made: Collect a new scoped one-client SceneAnalysisService baseline after the final layout instead of inferring cost from instance count.
- Reasoning summary: Graybox primitives are cheap individually, but multiplicity should still be measured before final art, mounts, creatures, and gardens add more work.
- Result: One default client view measured 1,149 scene instances, 55,898 non-shadow triangles, and 63 non-shadow draw calls. The earlier scoped view measured about 54,212 triangles and 68 draws; differing camera/runtime state means the comparison is directional, not a controlled benchmark.
- Test evidence: Direct Studio play-mode SceneAnalysisService output on 2026-07-20.
- Mistakes discovered: A larger authoring footprint cannot be judged from part counts or a single view, and the two snapshots are not identical-camera experiments.
- Recommended future approach: Establish fixed camera transforms and collect client/server frame time, memory, streaming, physics, and network evidence on the lowest target device with eight players, gardens, creatures, and future mounts.
- Confidence level: High for the recorded snapshot; Low for production performance conclusions
- Verification status: Verified
- Performance approval: Estimated

### Follow-up: Expanded ocean coverage

- Date: 2026-07-20
- Agent: Performance Agent / Map Agent / Codex
- System affected: Terrain extent, streaming, place size, memory, and wide-view rendering
- Situation: The user required the gray Studio void outside the ocean to disappear from full-map views.
- Decision made: Expand the uniform water region to 4096×4096 only after verifying the added region contained no unrelated Terrain; keep production performance approval open.
- Reasoning summary: Uniform Terrain water provides continuous visual and swimming behavior, but a larger authored region may affect place size, memory, streaming, and wide-view rendering even when ordinary player views cull most distant chunks.
- Result: 4,194,304 exact Water voxels are present with zero changed/unexpected voxels. No new frame-time, memory, place-size, or device measurement was collected.
- Test evidence: Edit-mode voxel scan and same-camera viewport comparison on 2026-07-20.
- Mistakes discovered: The first two ocean extents were chosen without an explicit widest-camera acceptance target.
- Recommended future approach: Measure published-place size, client/server memory, streaming behavior, and frame time on the lowest target device before final ocean materials or effects; shrink the authored region only if a sky/fog/horizon solution can still meet the no-gray requirement.
- Confidence level: High for voxel and visual coverage; Low for runtime cost
- Verification status: Verified
- Performance impact: Estimated
