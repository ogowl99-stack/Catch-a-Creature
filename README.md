# Catch a Creature

Catch a Creature is an original Roblox sanctuary, creature-discovery, and habitat-building game currently in research and pre-production.

## Current status

- Phase: Phase 1 standards and source-link work authorized and in progress; Phase 2 grayboxing and gameplay remain unauthorized
- Game implementation: Not yet implemented
- Roblox Studio connection: Verified against the authorized default place; no gameplay or repository-source verification exists
- Blender assets: Not yet created
- Public release: Not yet published

No gameplay code, models, audio, UI, or production assets exist yet. The current repository preserves the project research and the decisions made before production begins.

## Core game promise

> Grow Habitat Flora, attract and understand wild creatures, form bonds, cultivate adapted plant lineages, and transform a small plot into a living sanctuary.

The planned core loop is:

`buy seed -> plant -> wait/offline growth -> harvest -> sell for Leafnotes -> reinvest and expand -> attract a visitor -> observe/care -> earn Trust -> attempt an original chance-based capture -> display, store, sell, or release owned creatures -> cultivate adapted lineages`

Wild visitors remain unowned until one successful server-authoritative capture. Every contender personally Observes and completes correct Care before using a leaf-shaped Haven Tag. The caretaker receives 60 seconds of priority and may open early; the visitor is then public for five minutes. Every accepted attempt consumes one Haven Tag and its selected free Luck aid; rejected requests consume nothing. A failure adds two absolute percentage points of persistent personal Familiarity and advances toward guarantees on attempts 2/3/5/8/15/25. `Retry Capture` deliberately requests the next fair round-robin turn and defaults to No Aid; `Let Go` exits only that player's attempt, preserves Familiarity, leaves the visitor wild, and does not open caretaker priority early. Luck selection is disabled on a guaranteed attempt. There is no post-result gameplay cooldown or automatic repeat. A full Backpack cannot claim a visitor. Mythic success receives the approved original post-commit five-second skippable local sanctuary cutscene; nearby players see a brief flourish, Legendary receives a shorter flourish, and Full/Short/Off plus Reduced Motion settings are supported. Arrival weights, exact Luck formulas/recipes, technical expiry grace, and final measured presentation budgets remain unresolved. No gameplay has been implemented.

Later progression may add breeding, inherited traits, plot showcases, community migrations, and carefully bounded trading. These systems are not approved for implementation until the smallest complete loop is proven.

Paid true-transfer stealing is approved for a later update after the core farming, inventory, ownership, persistence, appraisal, and ordinary selling systems are proven. It will move one exact eligible plot-exposed plant or successfully captured owned creature without duplication; wild visitors never qualify. Implementation remains blocked on receipt, policy, protection, transaction-recovery, and multiplayer validation.

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
- `AgentKnowledge/` - shared project-specific knowledge, decisions, findings, and prevention rules
- `AgentMemory/` - specialized agent memory and improvement goals

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
