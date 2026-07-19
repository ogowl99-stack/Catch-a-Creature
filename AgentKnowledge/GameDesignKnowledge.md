# Game Design Knowledge

## Entry: First-playable currency and reinvestment

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: Economy, harvesting, selling, seed acquisition, and first-playable progression
- Situation: Phase 0 required a simple currency relationship that closes the harvest-to-reinvestment loop without premium exchange, maintenance pressure, loss, debt, or passive accumulation.
- Decision made: Lock Leafnotes as the sole first-playable soft currency. Players earn them by selling approved renewable flora harvests and spend them on Hearthpetal, Ripplecup, and Nuzzlefern seeds. Leafnotes have no premium conversion, upkeep, currency loss, debt, or passive interest.
- Reasoning summary: One bounded soft currency keeps the economic loop readable and server-authoritative while avoiding coercive loss systems and speculative currency infrastructure.
- Result: The Leafnotes identity and harvest-to-base-seed reinvestment relationship are approved. Starter grants, prices, yields, inventory limits, and creature or Adapted Seed sale rules remain unapproved or unresolved.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No economy simulation, transaction, UI, persistence, security, multiplayer, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. The approval needed to preserve the later disposition gate instead of silently authorizing creature or Adapted Seed sales.
- Recommended future approach: Keep prices and yields in validated server-owned definitions, model every Leafnote mutation as a server transaction, and simulate loop solvency before approving balance values.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: Leafnotes

- What changed: Leafnotes are the approved sole first-playable soft currency with a renewable-flora-harvest-to-base-seed loop.
- Why it changed: The smallest playable needs a clear reinvestment cycle without multiplying currencies or introducing loss and premium-conversion systems.
- APIs affected: None; no economy service, remote, data schema, inventory contract, shop API, or UI controller exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, and the Game Design, Gameplay, Data, Security, UI, and Monetization agent memories.
- New requirements: The server owns every Leafnote grant and spend; clients cannot select prices, quantities, rewards, or balances; only later-approved renewable flora harvests may generate Leafnotes; first-playable spending is limited to the three base seeds.
- Risks: Client-authoritative balances, duplicate sales, negative balances, unbounded inflation, unclear no-loss behavior, or accidentally treating creatures and Adapted Seeds as approved sellables.
- Tests required: Definition validation, earn/spend state transitions, replay and rate-limit rejection, insufficient-funds handling, nonnegative balance invariants, save/load round trips, disconnect recovery, economy simulations, and Roblox Studio shop-flow tests.
- Action required: Gameplay Agent defines the later sell/reinvest flow; Data Agent proposes the minimal balance schema; Security Agent threat-models transactions and remotes; UI Agent presents affordability and results; Monetization Agent preserves the no-premium-conversion boundary.

## Entry: First weather state

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: Weather, lighting, audio, VFX, and first-playable scope
- Situation: Phase 0 required one simple weather state without introducing economy multipliers, paid activation, exclusive rewards, or progression dependencies.
- Decision made: Lock Soft Rain as natural server-wide light rain with softer and cooler lighting, gentle rain ambience, and water ripples. It provides no growth multiplier, rarity boost, paid activation, exclusive creature, or progression requirement.
- Reasoning summary: A synchronized presentation-only state validates the weather architecture and sanctuary ambience without expanding the vertical slice's economy, monetization, or content dependencies.
- Result: Soft Rain's identity, server-wide scope, presentation pillars, and nonfunctional boundary are approved. Duration, frequency, scheduling, transitions, values, particles, audio implementation, and performance budgets remain unapproved.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No lighting, audio, VFX, weather-state, multiplayer, performance, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. The weather scope needed explicit exclusions so a simple ambience state would not silently become a reward or monetization system.
- Recommended future approach: Keep the server authoritative over the weather state and timing, let clients render bounded presentation, and test synchronized transitions and cleanup without economic mutations.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: Soft Rain

- What changed: Soft Rain is the approved first natural, server-wide, presentation-only weather state.
- Why it changed: The first playable needs one coherent weather state while keeping economy, rarity, monetization, and progression behavior out of scope.
- APIs affected: None; no weather module, remote, definition, or rendering API exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `Research/AmbienceAndArtDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, and the Architecture, Audio, VFX, Performance, Monetization, and Game Design agent memories.
- New requirements: The server owns active weather and timing; clients only render the approved presentation; Soft Rain cannot mutate growth, rarity, creature eligibility, purchases, or progression.
- Risks: Unsynchronized transitions, excessive particles or audio, client-authored weather, hidden gameplay effects, and accidental monetization would violate the approval.
- Tests required: Definition validation, server/client state synchronization, join-in-progress behavior, transition cleanup, lighting readability, audio throttling, particle cleanup, multiplayer consistency, and measured Roblox Studio performance.
- Action required: Architecture Agent defines the later weather contract; Audio and VFX Agents propose restrained presentation; Performance Agent measures it; Monetization Agent preserves the no-paid-activation boundary.

## Entry: First Adaptation and Bloommark

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: Adapted Seeds, habitat signals, cosmetic rarity, and first-playable progression
- Situation: Phase 0 required one functional Adaptation and one cosmetic Bloommark that demonstrate the approved separation between ecological function and presentation.
- Decision made: Lock Emberkeep as a Cozzle-influenced Hearthpetal Adaptation that retains warmth and light into early night. Lock Starlace as pale star-thread veins with occasional soft motes and no effect on attraction, growth, yield, sale value, or progression.
- Reasoning summary: Emberkeep closes the creature-to-plant relationship loop with a readable functional change, while Starlace demonstrates cosmetic rarity without selling or multiplying ecological power.
- Result: Emberkeep's functional identity and Starlace's cosmetic-only boundary are approved. Trigger counts, timing, strength, Adapted Seed generation, inheritance, implementation visuals, particle density, rarity, and performance cost remain unapproved.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No gameplay, economy, persistence, VFX, performance, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. Functional and cosmetic approval scopes needed explicit negative rules to prevent Starlace from silently gaining economic or progression value.
- Recommended future approach: Store functional Adaptations and cosmetic Bloommarks in separate validated fields, generate outcomes on the server, and test Emberkeep behavior independently from Starlace presentation.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: Emberkeep and Starlace

- What changed: Emberkeep is the approved first functional Adaptation; Starlace is the approved first cosmetic Bloommark.
- Why it changed: The vertical slice needs one creature-influenced plant function and one clearly nonfunctional rarity treatment.
- APIs affected: None; no module, remote, definition schema, or persistence API exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentMemory/GameDesignAgent.md`, `AgentMemory/GameplayAgent.md`, `AgentMemory/DataAgent.md`, `AgentMemory/VFXAgent.md`, and `AgentMemory/MonetizationAgent.md`.
- New requirements: Future schemas must separate Adaptations from Bloommarks; the server owns generation; Starlace cannot change functional or economic outcomes.
- Risks: Combining both traits in one mutation multiplier, client-selected outcomes, unclear nighttime boundaries, or unbounded motes would violate the approval or create security/performance problems.
- Tests required: Definition validation, server-authoritative generation, day/night boundary behavior, save/load round trips, Adaptation/Bloommark separation, zero Starlace economic effect, effect cleanup, and Roblox Studio readability/performance tests.
- Action required: Gameplay and Data Agents define Emberkeep state and persistence after remaining Phase 0 gates; VFX Agent proposes a restrained Starlace treatment after budgets exist; Monetization Agent preserves the no-functional-value boundary.

## Entry: First three creatures

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: First-playable creatures and habitat attraction
- Situation: The approved Habitat Flora trio required three original visitors with readable primary preferences for the Phase 3 attraction loop.
- Decision made: Lock Cozzle with a primary preference for Hearthpetal warmth and light, Rillibob with a primary preference for Ripplecup water and gentle sound, and Mossnub with a primary preference for Nuzzlefern shelter and calming scent.
- Reasoning summary: One clear primary preference per visitor makes the initial habitat-attraction rule legible while leaving later behavior, clue, and balance design open for focused approval.
- Result: The three creature names and primary preferences are approved. Appearance, scale, animation, clues, state transitions, bonding outcomes, utility, rarity, and balance are not approved by this decision.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No gameplay, comprehension, behavior, multiplayer, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. The approval needed a narrow boundary so a preference pairing would not silently approve creature behavior or bonding mechanics.
- Recommended future approach: Define the exact clue-inspection and bonding interaction next, then test whether players can infer each visitor's preferred habitat without reading hidden definition data.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: first creature trio

- What changed: Cozzle, Rillibob, and Mossnub are the approved first-playable visitors, paired respectively with Hearthpetal, Ripplecup, and Nuzzlefern primary signals.
- Why it changed: Phase 0 requires a bounded three-flora, three-creature ecology before behavior, data, UI, or placeholder contracts can be approved.
- APIs affected: None; no module, remote, or data API exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentMemory/GameDesignAgent.md`, `AgentMemory/GameplayAgent.md`, and `AgentMemory/EnemyAIAgent.md`.
- New requirements: Future definitions must preserve these stable names and primary preferences while keeping server authority and data-driven content boundaries.
- Risks: One-to-one preferences could feel automatic or shallow if clues and bonding choices do not add understandable decisions.
- Tests required: Definition validation, attraction eligibility, clue comprehension, deterministic visitor-state transitions, cleanup, multiplayer separation, and Roblox Studio interaction tests.
- Action required: Gameplay Agent proposes the exact clue/bonding loop; Enemy AI Agent proposes a bounded visitor state model only after that interaction is approved.

## Entry: First three Habitat Flora

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: First-playable content and habitat signals
- Situation: The Phase 3 loop requires three original Habitat Flora with immediately readable ecological roles.
- Decision made: Lock Hearthpetal for warmth and light, Ripplecup for water and gentle sound, and Nuzzlefern for shelter and calming scent.
- Reasoning summary: The trio supplies three visually and behaviorally distinct signal combinations that can support understandable visitor attraction without requiring a large content catalog.
- Result: The three names and primary habitat signals are approved. No growth timing, yield, price, appearance, attraction strength, or other balance value is approved by this decision.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No gameplay, comprehension, economy, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. The approval needed an explicit boundary so names and signals would not silently lock unreviewed balance or art details.
- Recommended future approach: Pair each launch creature with a readable preference among these signals, then validate the trio through definitions, primitive placeholders, and one guided-cycle comprehension test after later gates approve implementation.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

## Entry: Final game promise

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: Project identity and Phase 0 scope
- Situation: Two compatible but differently scoped promise candidates existed; one included eventual breeding while breeding is deferred from the first playable.
- Decision made: Lock the promise as: “Grow Habitat Flora, attract and understand wild creatures, form bonds, cultivate adapted plant lineages, and transform a small plot into a living sanctuary.”
- Reasoning summary: The approved wording preserves the planting, discovery, bonding, adaptation, and sanctuary transformation loop without implying that deferred breeding belongs in the first playable.
- Result: The final game promise is approved; no implementation was authorized beyond recording this Phase 0 decision.
- Test evidence: Direct user approval in the project conversation on 2026-07-18. No gameplay or player-comprehension test exists.
- Mistakes discovered: Earlier promise candidates did not clearly separate the long-term breeding vision from the first-playable identity.
- Recommended future approach: Evaluate every Phase 0 content and interaction decision against this promise; treat breeding as deferred unless separately approved later.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

## Entry: Proven atomic loop

- Date: 2026-07-16
- Agent: Game Design Agent
- System affected: Core progression
- Situation: Grow a Garden research showed that feature breadth is secondary to a legible farming loop.
- Decision made: Preserve planting, waiting/offline progress, harvesting, selling, and reinvestment as the economic backbone while making creature ecology the original differentiator.
- Reasoning summary: Players need an immediately understandable source of progress before learning habitat and creature systems.
- Result: Original closed loop documented.
- Test evidence: Reference research only; our loop requires prototype testing.
- Mistakes discovered: None in implementation; risk identified that creature systems could obscure the simple backbone.
- Recommended future approach: Measure whether a new player can explain the loop after one guided cycle.
- Confidence level: High
- Verification status: Estimated
- Evidence class: Community-derived reference synthesis; local implementation absent

## Entry: Habitat Flora

- Date: 2026-07-16
- Agent: Game Design Agent
- System affected: Plants and creature attraction
- Situation: Ordinary crop reskins would leave the project too close to its references.
- Decision made: Plants create ecological signals and react to creature relationships.
- Reasoning summary: Functional habitats close the loop between farming, catching, care, and collection.
- Result: Habitat Flora roles and Growth Memories defined conceptually.
- Test evidence: Requires prototype testing.
- Mistakes discovered: None yet.
- Recommended future approach: Give every launch plant one visually obvious habitat role and one creature interaction.
- Confidence level: High
- Verification status: Not yet implemented

## Entry: Adaptations versus Bloommarks

- Date: 2026-07-16
- Agent: Game Design Agent / Monetization Agent
- System affected: Mutations, economy, breeding, monetization
- Situation: Paid luck and extreme visual rarity can undermine functional prestige if both use one mutation system.
- Decision made: Separate functional Adaptations from cosmetic Bloommarks.
- Reasoning summary: Paid or event-supported cosmetic discovery can remain exciting without selling ecological power or superior genetics.
- Result: Two-layer mutation vocabulary established.
- Test evidence: Requires economy and UX testing.
- Mistakes discovered: Early brainstorming used “mutation” for both appearance and function, creating ambiguity.
- Recommended future approach: Every trait definition must state whether it is functional, cosmetic, inheritable, tradeable, progression-eligible, and value-bearing.
- Confidence level: High
- Verification status: Not yet implemented

## Entry: Emotional contract

- Date: 2026-07-16
- Agent: Game Design Agent
- System affected: Whole game
- Situation: Grow a Garden 2 demonstrates that theft, defense, and decay change the audience and emotional experience.
- Decision made: Target cozy, communal opportunity rather than destructive competition for the first release.
- Reasoning summary: Creature care, plot expression, and shared weather are more coherent when players are not protecting progress from one another.
- Result: Theft, destructive decay, and paid offensive power deferred.
- Test evidence: Requires player research and prototype feedback.
- Mistakes discovered: None yet.
- Recommended future approach: Treat any future competitive proposal as a new contract requiring explicit approval.
- Confidence level: High
- Verification status: Not yet implemented
