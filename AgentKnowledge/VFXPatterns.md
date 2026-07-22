# VFX Patterns

## Pattern: Post-commit local Mythic forage celebration

- Date: 2026-07-21
- Agent: Codex / VFX and UI roles
- System affected: Rare forage feedback, client presentation, cleanup, and accessibility
- Situation: The user requested a special animation and cool VFX when a super-rare/Mythic seed is pulled from the ground.
- Decision made: After a successful server grant, send only the capturer a sanitized event ID, definition ID, rarity, and world position. Render a brief gold/purple ground bloom, rising seed, 18 motes, world label, and top banner locally. Deduplicate event IDs and destroy the effect automatically; do not move the camera or use flashing.
- Reasoning summary: A local bounded celebration feels special without granting authority, interrupting nearby players, or leaving replicated effect debris.
- Result: The presentation rendered in Studio and disappeared after its lifetime. It was triggered as a presentation-only simulation because no Mythic seed exists in the current catalog.
- Test evidence: Studio screen capture and post-lifetime absence check; console remained error-free.
- Mistakes discovered: The first active-instance query occurred after the 3.5-second lifetime, so the retained screenshot—not the late query—is the positive visual evidence.
- Recommended future approach: Add Reduced Motion/Off settings before release, test on low-end mobile, and activate naturally only after a real Mythic definition and committed reward exist.
- Confidence level: High for bounded desktop presentation; Low for device performance/accessibility until tested
- Verification status: Simulated presentation; cleanup Verified

## Entry: Approved post-commit Mythic-capture celebration direction

- Date: 2026-07-19
- Agent: VFX Agent / UI Agent / Audio Agent / Performance Agent / Security Agent / QA Agent / Codex
- System affected: Rare capture, local camera, particles, beams, world effects, accessibility, cleanup, networking, and originality
- Situation: The user required a cutscene and VFX when a super-rare creature is captured, then approved mapping super rare to the existing Mythic tier and approved the proposed presentation choices.
- Decision made: Treat super rare as Mythic rather than silently creating a seventh tier. After durable ownership only, play an approximately five-second, immediately skippable capturer-local sequence: the placed Haven Tag settles and glows; one pastel sanctuary ribbon forms leaf/constellation shapes around the creature; trait-colored motes gather without rerolling traits; the creature voluntarily accepts a small luminous sanctuary mark; a gentle leaf-shaped burst leads into an original field-journal card showing name, tier, mutation, size, and weight. Nearby players see only a restrained brief world flourish with no forced camera/control change. Legendary receives a shorter two-to-three-second flourish. Support `Full / Short / Off`, Reduced Motion, and low-effect/mobile modes. Avoid capsules, shake counts, containment, copied silhouettes/sounds/layout, strobe, white flash, rapid color alternation, heavy bloom/shake, and jackpot expression.
- Reasoning summary: The sequence turns capture into willing sanctuary acceptance, matches the game's identity, and preserves other players' control. Post-commit triggering and bounded local presentation separate valuable state from optional cosmetics.
- Result: Mythic tier mapping, exact sequence, Legendary treatment, approximate duration, capturer/nearby audience split, immediate skip, and Full/Short/Off plus Reduced Motion settings are user-approved. Numerical budgets remain Estimated and final art/audio implementation requires prototype evidence. No VFX, animation, UI, model, audio, or Studio scene exists.
- Test evidence: Independent VFX/Audio/Performance, Security/Architecture, and QA/UI reviews on 2026-07-19. No asset, screenshot, Studio, device, photosensitivity, cleanup, or performance evidence exists.
- Mistakes discovered: Triggering from the client roll animation could celebrate an uncommitted or replayed success. A global cinematic could interrupt unrelated players. A capsule/shake motif would weaken originality. Unbounded particles/camera connections could leak or stack.
- Recommended future approach: Receive one compact sanitized celebration descriptor keyed by outcome ID; allow one hero celebration per client; degrade overlaps to the reveal card; restore exact camera/input state on completion, immediate skip, respawn, teleport, streaming failure, or missing assets; set a hard cleanup deadline; measure before locking budgets.
- Confidence level: High for approved direction and post-commit/accessibility/originality boundaries; Low for numerical budgets and runtime quality until measured
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

### Estimated prototype budget — not a measured limit

- Winner: start at no more than three emitters, about 60 live particles, and one beam/trail
- Nearby viewer: start near two emitters and 24 particles; no camera or post-processing takeover
- One full hero celebration per client; overlapping successes degrade to Short or journal-only
- One compact server descriptor; no per-frame replication or global Lighting mutation
- Hard cleanup target near seven seconds; all instances, sounds, connections, camera effects, and UI locks return to baseline
- Mobile/low-effect: roughly half particles, no camera movement/post-processing, preserve the journal reveal
- Measure p95/worst frame time, memory recovery, instance/connection delta, particle/audio concurrency, network payload, skip latency, and camera restoration before approval

## Initial direction

- Communicate rarity through several restrained signals: color, material, geometry, motion, particles, and sound
- Use weather as a coordinated world state rather than only a UI icon
- Preserve silhouettes and interaction prompts
- Avoid constant high-intensity particles
- Pool or reuse effects only after profiling proves benefit
- Provide reduced-motion and lower-effect options where feasible
- Rare effects may be dramatic but cannot flash, obscure navigation, or overwhelm mobile devices

Status: Not yet implemented. Effect budgets require measurement.

Document type: Baseline guidelines, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.
