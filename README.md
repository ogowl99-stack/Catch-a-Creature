# Catch a Creature

Catch a Creature is an original Roblox sanctuary, creature-discovery, and habitat-building game currently in research and pre-production.

## Current status

- Phase: Phase 3A farming foundation verified in Studio; Hearthpetal/Cozzle arrival slice implemented as the first creature-attraction prototype
- Game implementation: Server-authoritative seed buying, planting, offline growth, harvesting, selling, saving, custom hotbar/backpack, service access, Hearthpetal Habitat Flora, and one wild/unowned Cozzle projection
- Roblox Studio connection: Verified against the authorized place; Rojo 7.7.0 now synchronizes the repository-owned shared, server, and client namespaces while leaving the graybox outside Rojo authority
- Blender assets: Not yet created
- Public release: Not yet published

Gameplay code and prototype UI/models now exist, but production models, animations, audio, final UI art, creature Observe/Care/Capture, multiplayer validation, and publishing do not. The repository retains the dimensioned Phase 2 graybox recipe and rollback script alongside the repository-owned Phase 3 source.

## Core game promise

> Grow Habitat Flora, attract and understand wild creatures, form bonds, cultivate adapted plant lineages, and transform a small plot into a living sanctuary.

The planned core loop is:

`buy seed -> plant -> wait/offline growth -> harvest -> sell for Leafnotes -> reinvest and expand -> attract a visitor -> observe/care -> earn Trust -> attempt an original chance-based capture -> display, store, sell, or release owned creatures -> cultivate adapted lineages`

Wild visitors remain unowned until one successful server-authoritative capture. Every contender personally Observes and completes correct Care before using a leaf-shaped Haven Tag. The caretaker receives 60 seconds of priority and may open early; the visitor is then public for five minutes. Every accepted attempt consumes one Haven Tag and its selected free Luck aid; rejected requests consume nothing. A failure adds two absolute percentage points of persistent personal Familiarity and advances toward guarantees on attempts 2/3/5/8/15/25. `Retry Capture` deliberately requests the next fair round-robin turn and defaults to No Aid; `Let Go` exits only that player's attempt, preserves Familiarity, leaves the visitor wild, and does not open caretaker priority early. Luck selection is disabled on a guaranteed attempt. There is no post-result gameplay cooldown or automatic repeat. A full Backpack cannot claim a visitor. Mythic success receives the approved original post-commit five-second skippable local sanctuary cutscene; nearby players see a brief flourish, Legendary receives a shorter flourish, and Full/Short/Off plus Reduced Motion settings are supported. Arrival weights, exact Luck formulas/recipes, technical expiry grace, and final measured presentation budgets remain unresolved. The current Cozzle is only a wild/unowned attraction projection; Observe, Care, capture, ownership, and disposition are not implemented.

Later progression may add breeding, inherited traits, plot showcases, community migrations, and carefully bounded trading. These systems are not approved for implementation until the smallest complete loop is proven.

Paid true-transfer stealing is now a conditional initial-release target after the core farming, inventory, ownership, persistence, appraisal, and ordinary selling systems are proven during development. It will move one exact eligible plot-exposed plant or successfully captured owned creature without duplication; wild visitors never qualify. It must be implemented last, remain disabled behind a server feature flag, and block public launch until receipt, policy, protection, transaction-recovery, and closed multiplayer validation pass.

The expanded Phase 2 map graybox uses eight equal 96×96 plots around Crescent Pond Sanctuary on an approximately 880×920 walkable island. Players spawn at the Welcome Gate, pass wealth-leaderboard and donation-board footprints, and will later cross the gate to move to an assigned plot. The ranking metric, donation mechanism, gate transport, plot authority, services, events, creature spawning, and mount gameplay remain nonfunctional future markers. The swimmable pond, bridges, 20-stud perimeter/mount trail, invisible collidable island border, gentle outer hills, continuous ocean, Memory Tree event venue, and natural-meadow reserves are present and one-client desktop-verified.

## Originality commitment

Grow a Garden and Grow a Garden 2 are mechanical references, not asset or content sources. Catch a Creature will use original:

- Branding and terminology
- Map and plot layouts
- Plants and creatures
- Models, rigs, animations, and textures
- Interface artwork
- Audio and music
- Progression content
- Event themes and narrative

All production models are planned to be made from scratch in Blender and integrated into Roblox Studio.

## Repository map

- `Research/` - researched references, original design synthesis, sources, and the proposed development order
- `Design/` - approved concept art, spatial decisions, and the remaining concept-generation plan
- `StudioBuild/` - reversible Studio construction and rollback recipes for authorized grayboxes
- `src/` - repository-authoritative shared, server, and client Luau source synchronized through Rojo
- `default.project.json` - selective Rojo mapping; `Workspace` is intentionally excluded
- `ProgressMedia/` - truthful milestone-capture rules and clip manifest for short development videos
- `AgentKnowledge/` - shared project-specific knowledge, decisions, findings, and prevention rules
- `AgentMemory/` - specialized agent memory and improvement goals

## Rojo development connection

The project pins Rojo 7.7.0 in `rokit.toml` and restricts live synchronization to the authorized Catch A Creature place ID. For a clean clone with [Rokit](https://github.com/rojo-rbx/rokit), run:

```powershell
rokit install
rojo serve default.project.json
```

This machine also has an ignored project-local binary, so its equivalent command is:

```powershell
.\.tools\rojo\rojo.exe serve default.project.json
```

Then open the Rojo Studio plugin and connect to `localhost:34872`. The mapping intentionally excludes `Workspace`; the Phase 2 graybox remains managed by its repository build and rollback recipes.

The three mapped `CatchACreature` folders are fully repository-owned: Studio-only children or edits inside them may be overwritten or removed by synchronization. Unrelated instances outside those namespaces are preserved. `sourcemap.json` is a committed generated artifact and should be regenerated with `rojo sourcemap default.project.json --output sourcemap.json` whenever the mapping changes.

Run `powershell -ExecutionPolicy Bypass -File .\scripts\Test-Rojo.ps1` to verify the pinned version, authorized place restriction, Workspace exclusion, sourcemap freshness, and a clean temporary build.

## Truth labels and evidence classes

Every mutable or implementation-related claim should use one of these labels:

- Verified
- Code-reviewed
- Simulated
- Estimated
- Requires Roblox Studio testing
- Requires user asset
- Blocked
- Not yet implemented

Research provenance is recorded separately as an evidence class, for example `Official source`, `Community-derived`, or `Experimental`. Evidence classes do not replace the truth label.

“Verified” must be supported by direct evidence. Community wiki formulas, odds, timers, and balance values remain experimental until independently tested.
