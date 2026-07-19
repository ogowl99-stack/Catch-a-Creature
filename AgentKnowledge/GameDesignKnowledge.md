# Game Design Knowledge

## Entry: First-playable emotional contract and Phase 0 completion

- Date: 2026-07-19
- Agent: Codex / Game Design Agent
- System affected: First-playable scope, player loss, offline progress, PvP, cooperation, monetization boundaries, and production gates
- Situation: The final Phase 0 gate required an exact emotional contract after paid true-transfer stealing was assigned to a later update.
- Decision made: Lock the first playable as cozy and theft-free, with generous offline growth, no plant death from absence, no forced PvP, no random loss of plants, creatures, items, or Leafnotes, and cooperation that is optional rather than required. Deliberate player-authorized sale or release remains allowed under the approved disposition rules. Paid true-transfer stealing remains a separately approved later-update exception and is not part of the first playable.
- Reasoning summary: The contract preserves a low-pressure, understandable farming and bonding experience while allowing the later competitive monetization feature to be developed only after ownership, persistence, economy, and trust protections are proven.
- Result: Every listed Phase 0 design gate is user-approved. Phase 0 design is complete; Phase 1 planning, project scaffolding, game code, models, UI, audio, and Studio changes remain unauthorized until a separate user instruction.
- Test evidence: Direct user approval in the project conversation on 2026-07-19. Prior gate records passed targeted searches, strict UTF-8 validation, `git diff --check`, specialist reviews, and independent documentation reviews. No gameplay, economy, device, multiplayer, DataStore, performance, or Roblox Studio test exists.
- Mistakes discovered: The initial emotional-contract proposal treated theft as permanently excluded; user clarification required separating the theft-free first playable from the approved later-update paid true-transfer feature.
- Recommended future approach: Start Phase 1 only after explicit authorization, translate the approved contract into definitions and measurable acceptance tests before code, and reject any first-playable feature that introduces forced competition, absence punishment, or unapproved loss.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: Phase 0 to Phase 1

- What changed: Phase 0 design is complete with an approved first-playable emotional contract and a later-update boundary for paid stealing.
- Why it changed: Production needs a stable, testable design boundary before choosing schemas, module APIs, graybox scope, or asset standards.
- APIs affected: None; no production source scaffold, service, controller, remote, data schema, test harness, or Rojo project exists.
- Files affected: `README.md`, `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/LessonsLearned.md`, `AgentKnowledge/TestingKnowledge.md`, `AgentKnowledge/CodingPatterns.md`, `AgentKnowledge/ImprovementBacklog.md`, `AgentKnowledge/RiskRegister.md`, `AgentKnowledge/AgentScores.md`, and relevant personal memories.
- New requirements: The first playable must remain theft-free, absence-safe, non-PvP, non-random-loss, and optionally cooperative; all implementation claims require evidence; later-update paid stealing cannot leak into first-playable dependencies.
- Risks: Premature implementation, scope creep, unapproved balance assumptions, incomplete schemas, Studio/repository divergence, weak offline-save semantics, mobile accessibility gaps, performance uncertainty, and later-feature dependencies contaminating the vertical slice.
- Tests required: Documentation/schema validation; one guided-cycle comprehension test; plant growth/offline/harvest transitions; deterministic bonding; save/load and migration; economy simulation; server validation; multiplayer isolation; mobile/tablet/desktop/controller checks; crowded-plot performance; and Roblox Studio graybox evidence after authorization.
- Action required: Codex requests authorization before Phase 1 work; Game Design and Gameplay Agents produce the smallest measurable vertical-slice specification; Architecture/Data/Security/QA define boundaries and tests before code; Map/UI/Art agents validate scale and device constraints before content production.

## Entry: Paid true-transfer stealing and full ownership rights

- Date: 2026-07-19
- Agent: Codex / Game Design, Monetization, Architecture, Data, Security, and QA Agents
- System affected: Public plots, plants, creatures, inventory, ownership, Robux purchases, Leafnotes, provenance, player trust, and persistence
- Situation: The user requested a paid steal function, clarified that stealing must transfer the one real item without duplication, limited eligibility to assets exposed on the owner's plot, and approved normal ownership and sale rights for the buyer.
- Decision made: Plan a repeatable paid Steal Credit with a proposed 99 Robux base price. A plant is eligible only while planted on its online owner's plot; a creature is eligible only after capture/bonding and while roaming or displayed on that owner's plot. Held, stored, inventory, favorited, or locked assets and wild visitors are ineligible. A successful server-authoritative action transfers the exact persistent item and immutable identity to the buyer's protected inventory, preserving mutations, size, weight, history, and provenance. No duplicate or replacement is created. The buyer may keep the item, place or deploy it again, use its normal functions, or sell it for its server-calculated Leafnote value. The original owner permanently loses ownership but retains journal discovery. A failed or invalidated target does not consume the paid credit.
- Reasoning summary: True one-for-one transfer matches the requested theft fantasy; state-based exposure gives owners a free defense; a durable credit separates Robux receipt delivery from a mutable cross-player target; and atomic ownership movement is necessary to prevent duplication or loss.
- Result: True transfer, exposed-plot eligibility, inventory/held protection, trait preservation, no duplication, full buyer economic rights, and later-update release order are user-approved. This deliberately supersedes the earlier blanket boundaries against theft, paid offensive power, and paid acquisition of mutation/size/weight value for this feature only. Direct Robux-to-Leafnote exchange remains prohibited, but an approved stolen asset may later be sold normally. The base price, Managed Pricing choice, cooldown and grace durations, reservation timing, exact UI, protected item classes beyond those named, private-server behavior, and platform classification remain provisional.
- Test evidence: Direct user clarification and approvals in the project conversation on 2026-07-19, including explicit approval of the later-update release order; current official Roblox documentation review; independent Monetization/Game Design, Architecture/Data/Security, and QA/Player Trust reviews. No implementation, receipt test, policy test, DataStore test, multiplayer test, economy simulation, player-trust test, or Roblox Studio test exists.
- Mistakes discovered: A naive purchase-to-live-target grant cannot safely fulfill a developer-product receipt because the target can change or disappear and the receipt contains no custom target intent. Economic compensation or replacement would create inflation, collusion, or duplication contrary to the approved rule.
- Recommended future approach: Keep the feature out of implementation until the ownership ledger, receipt ledger, policy gate, transfer inbox, cooldown protections, and fault-injection tests exist; seek Roblox policy or Developer Relations confirmation before launch because official documentation does not explicitly classify paid non-consensual transfers.
- Confidence level: High for the user-approved gameplay contract; Medium for platform compatibility until Roblox confirms classification
- Verification status: Verified
- Implementation status: Not yet implemented
- Launch status: Blocked
- Launch blocker: Roblox policy or Developer Relations must confirm the platform classification before launch.

### Cross-agent handoff: paid true-transfer stealing

- What changed: A paid Steal Credit may permanently move one eligible exposed plant or bonded creature between players with full normal ownership and economic rights.
- Why it changed: The user wants a Grow a Garden-like paid stealing risk while preserving a strict no-duplicate transfer.
- APIs affected: Future `MarketplaceService.ProcessReceipt`, `PolicyService:GetPolicyInfoForPlayerAsync`, dynamic product-info pricing, ownership/provenance records, item state revisions, inventory/transfer inbox, plot exposure, creature display state, journal, appraisal, sale, and transaction audit APIs. None exists yet.
- Files affected: `README.md`, `Research/ResearchBaseline.md`, `Research/OriginalGameDirection.md`, `Research/MonetizationAndEvents.md`, `Research/DevelopmentStartPlan.md`, `Research/Sources.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/PlayerFeedback.md`, `AgentKnowledge/ArchitectureDecisions.md`, `AgentKnowledge/SecurityFindings.md`, `AgentKnowledge/TestingKnowledge.md`, `AgentKnowledge/FailedApproaches.md`, `AgentKnowledge/LessonsLearned.md`, `AgentKnowledge/AgentScores.md`, and relevant personal agent memories.
- New requirements: `ProcessReceipt` idempotently grants one buyer-bound nontradeable credit and never directly moves a volatile target; both players and the exact item are revalidated server-side; the exact UUID changes owner once through a durable atomic transaction; no random fallback or duplicate occurs; invalid attempts retain the credit; paid-steal provenance persists; buyer capacity cannot lose the paid grant; both players fail closed on required policy checks.
- Risks: Pay-to-grief behavior, targeted rare-item loss, player churn, collusion, alt abuse, Robux-to-Leafnote value flow, duplicate receipts, double ownership, permanent item loss, target reservation grief, cross-player DataStore races, policy ineligibility, regional price arbitrage, and accidental mobile/controller purchase.
- Tests required: Eligibility matrix; duplicate and replayed receipts; simultaneous thieves; recall/favorite/sell/release/harvest versus reservation; disconnects and server shutdown at every transaction state; stale ownership; full inventory; policy false/failure for either player; regional-price behavior; DataStore fault injection; exact identity/trait preservation; journal retention; cooldown and alt-abuse checks; economy simulation; player-trust playtest; and an invariant proving exactly one owner and one consumed credit.
- Action required: Keep the feature outside the first playable. Architecture and Data Agents design the item-centric ledger and reconciler only after the core ownership/economy foundations are proven; Security Agent threat-models every state and policy check; Monetization Agent confirms transparent dynamic pricing and platform eligibility; UI Agent designs deliberate purchase and victim notices; QA Agent builds adversarial and device coverage; Codex requires a later implementation gate.

## Entry: First-playable harvesting, creature value, and disposition

- Date: 2026-07-19
- Agent: Codex / Game Design Agent, with Economy and Data/Security review
- System affected: Harvesting, inventory, creature traits, Leafnotes, display, storage, release, journal, and persistence
- Situation: Phase 0 required an exact disposition policy, and the user approved the proposed flora rules while adding first-playable creature sales and creature mutations, size, and weight.
- Decision made: Renewable flora outputs can be harvested while the parent plant remains and regrows. Harvests can be sold individually or through `Sell All`, which excludes favorited items. Only bonded, player-owned creatures—not wild visitors—can be displayed, stored, sold, or released. Each creature has persistent server-owned mutation traits, size, and weight that affect its server-calculated Leafnote sale value. Creature sales are individual, require explicit confirmation, and permanently exchange that creature for Leafnotes; release is a separate confirmed action that grants no currency. Favorited creatures cannot be sold or released until unfavorited. Sale or release preserves the species journal discovery. Adapted Seeds can be planted, stored, or favorited but cannot be sold in the first playable.
- Reasoning summary: The policy preserves the familiar harvest-to-sale loop, adds a collectible creature-value chase requested by the user, protects meaningful companions from accidental bulk sale, and keeps release emotionally distinct from sale.
- Result: Flora harvesting/sale, bonded-creature sale, value-affecting creature mutation/size/weight, favorite protection, display/storage, release, journal retention, and Adapted Seed disposition are approved. Flora output identities, creature mutation catalog and behavior, trait generation, appearance, size/weight units and ranges, exact valuation, prices, yields, timers, capacities, UI, and individual-trait journal retention remain provisional.
- Test evidence: Direct user approval and amendment in the project conversation on 2026-07-19, followed by read-only Economy and Data/Security reviews. No implementation, economy simulation, save/load test, transaction test, UI test, or Roblox Studio test exists.
- Mistakes discovered: The initial proposal prohibited creature sales and was superseded by the user's amendment. Older documentation also restricted Leafnote generation to flora and described creature sales as later or unresolved; those statements required explicit supersession.
- Recommended future approach: Keep renewable flora the dependable income source and creature sales optional; use original creature mutations and value curves; calculate value only from bounded persisted server data; and make sale/release atomic, idempotent, ownership-validated terminal actions.
- Confidence level: High for the approved design boundary; Medium for future balance until simulation and playtesting
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: harvesting and creature disposition

- What changed: Renewable flora harvest sale and first-playable bonded-creature sale are approved Leafnote sources; creature mutations, size, and weight now affect individual creature value; disposition protections are locked.
- Why it changed: The first playable needs a Grow a Garden-like sell/reinvest rhythm and a distinctive collectible-creature value layer without enabling accidental loss or client-forged rewards.
- APIs affected: None; no harvest service, inventory service, creature instance schema, appraisal service, transaction API, journal API, UI controller, or persistence implementation exists yet.
- Files affected: `README.md`, `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/PlayerFeedback.md`, `AgentKnowledge/SecurityFindings.md`, `AgentKnowledge/TestingKnowledge.md`, `AgentKnowledge/AgentScores.md`, `AgentKnowledge/LessonsLearned.md`, and the relevant Game Design, Gameplay, Data, Security, UI, QA, and Monetization agent memories.
- New requirements: The server owns harvest eligibility, creature identity and ownership, mutation IDs, bounded size/weight inputs, favorite state, disposition state, appraisal, removal, and Leafnote grants. Generic harvest `Sell All` excludes favorites and never includes creatures. Creature sale/release uses an owned creature ID and an explicit confirmed request; journal discovery survives either terminal action.
- Risks: Client-forged traits or prices, duplicate payout, sale/release races, wrong-owner sale, favorite bypass, item loss without payout, payout without removal, value overflow or multiplier explosion, farming becoming economically obsolete, and copied reference mutations or formulas.
- Tests required: Definition and bounds validation; flora harvest/regrow transitions; `Sell All` favorite exclusion; save/load and migration round trips for creature identity, provenance, mutations, size, weight, favorite, and state; valuation golden cases and overflow boundaries; wrong-owner and forged-value rejection; idempotent replay; sale/release concurrency; disconnect and uncertain-save recovery; zero-currency release; journal retention; economy simulation; multiplayer isolation; and mobile/tablet/desktop/controller confirmation checks.
- Action required: Gameplay Agent defines the later state transitions; Data and Architecture Agents propose a versioned creature schema and transaction ledger; Security Agent threat-models every remote; UI Agent separates harvest bulk sale from confirmed creature actions; QA Agent builds regression coverage; Monetization Agent prevents paid products from changing mutation, size, or weight generation odds while preserving the separately approved paid true-transfer exception recorded above.

## Entry: Grow a Garden gameplay-rhythm priority reaffirmed

- Date: 2026-07-19
- Agent: Codex / Game Design Agent
- System affected: Core progression, harvesting, economy, onboarding, and feature scope
- Situation: The user asked that Catch a Creature stay as similar to Grow a Garden as practical in gameplay.
- Decision made: Treat the familiar `buy base seed → plant → wait/offline → harvest renewable output → sell → reinvest → expand` rhythm as the primary progression spine. Creature observation, bonding, habitat signals, and adaptation add original depth around that spine rather than replacing or obscuring it. Protected names, assets, writing, map expression, UI art, exact balance, and branded content remain original to Catch a Creature.
- Reasoning summary: Familiar loop structure supports immediate comprehension and satisfies the user's reference preference; original creature ecology and presentation preserve the project's own identity.
- Result: The gameplay-rhythm priority is verified stakeholder direction. It does not approve exact reference formulas, probabilities, prices, timers, capacities, copied assets, or one-to-one feature parity.
- Test evidence: Direct user direction in the project conversation on 2026-07-19. No prototype, comprehension test, economy simulation, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. “Similar” must remain a gameplay-structure requirement rather than being misread as permission to copy protected creative expression.
- Recommended future approach: Make the farming loop independently legible and satisfying, then introduce creature layers one step at a time and test whether new players can explain both the basic economy and the sanctuary differentiator.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

## Entry: First-playable clue and bonding interaction

- Date: 2026-07-19
- Agent: Codex / Game Design Agent
- System affected: Creature encounters, clues, care choices, bonding, UI, persistence, and remote validation
- Situation: Phase 0 required one exact, understandable visitor-inspection and bonding interaction that remains cozy, deterministic, secure, and usable across input devices.
- Decision made: Lock Observe → Care → Bond. Observing a visitor on the player's plot returns two truthful server-supplied visual/text clues. The player chooses Offer Warmth for Cozzle, Echo the Chime for Rillibob, or Give Quiet Shelter for Mossnub. A correct response bonds deterministically after server validation; a wrong response costs nothing, provides a clearer clue, and allows another attempt after a short provisional cooldown without permanent fleeing.
- Reasoning summary: Three legible care responses connect the approved habitat signals to creature understanding, while deterministic bonding and no-loss retries preserve the cozy emotional contract and avoid hidden capture odds.
- Result: The interaction sequence, response identities and mapping, deterministic success, and no-loss retry behavior are approved. Clue wording, animation, timing, cooldown length, capacity behavior, failure presentation, UI layout, interaction presentation, implementation details, and styling remain unapproved.
- Test evidence: Direct user approval in the project conversation on 2026-07-19. No interaction, remote, persistence, device, multiplayer, comprehension, or Roblox Studio test exists.
- Mistakes discovered: None in implementation; no implementation exists. The prior checkpoint correctly preserved this proposal as unapproved until explicit confirmation.
- Recommended future approach: Keep encounter state and clue/action definitions server-owned, validate plot ownership and distance, make resolution idempotent, and evaluate a proposed fail-closed safeguard that does not consume the visitor when persistence or capacity state is uncertain. This safeguard is not an approved capacity rule.
- Confidence level: High
- Verification status: Verified
- Implementation status: Not yet implemented

### Cross-agent handoff: Observe → Care → Bond

- What changed: The first-playable inspection and bonding contract is approved with three mapped care responses, deterministic correct resolution, and no-loss retries.
- Why it changed: The vertical slice needs one complete, understandable creature encounter that rewards observation without random capture odds or punitive failure.
- APIs affected: None; no encounter service, remote, data schema, UI controller, creature state machine, or persistence API exists yet.
- Files affected: `Research/DevelopmentStartPlan.md`, `Research/OriginalGameDirection.md`, `AgentKnowledge/GameDesignKnowledge.md`, `AgentKnowledge/ProjectContext.md`, `AgentKnowledge/LessonsLearned.md`, and the Game Design, Gameplay, Enemy AI, UI, Security, Data, and QA agent memories.
- New requirements: The server owns clues, valid responses, encounter state, cooldown eligibility, bonding resolution, and persistent grants; clients request Observe or one allow-listed care response and render server results.
- Risks: Client-selected clues or rewards, replayed responses, duplicate bonds, resolving another player's visitor, distance spoofing, inaccessible clue presentation, full-capacity loss, and inconsistent device input.
- Tests required: Definition validation, clue truthfulness, correct/incorrect transitions, clearer-clue retry, cooldown boundaries, no permanent flee, plot ownership and distance validation, replay/rate-limit rejection, idempotent bonding, capacity/persistence failure, save/load, multiplayer isolation, and mobile/tablet/desktop/controller interaction checks.
- Action required: Gameplay Agent defines the later encounter contract; Enemy AI Agent aligns bounded visitor states; UI Agent designs accessible clue/action presentation; Security and Data Agents validate grants; QA Agent builds transition and regression coverage.

## Entry: First-playable currency and reinvestment

- Date: 2026-07-18
- Agent: Codex / Game Design Agent
- System affected: Economy, harvesting, selling, seed acquisition, and first-playable progression
- Situation: Phase 0 required a simple currency relationship that closes the harvest-to-reinvestment loop without premium exchange, maintenance pressure, loss, debt, or passive accumulation.
- Decision made: Lock Leafnotes as the sole first-playable soft currency. Players earn them by selling approved renewable flora harvests and spend them on Hearthpetal, Ripplecup, and Nuzzlefern seeds. Leafnotes have no premium conversion, upkeep, currency loss, debt, or passive interest.
- Reasoning summary: One bounded soft currency keeps the economic loop readable and server-authoritative while avoiding coercive loss systems and speculative currency infrastructure.
- Result: At the 2026-07-18 approval, the Leafnotes identity and harvest-to-base-seed reinvestment relationship were approved while starter grants, prices, yields, inventory limits, and creature or Adapted Seed sale rules remained unresolved. The 2026-07-19 supersession below approves bonded-creature sale and makes Adapted Seeds nonsellable in the first playable.
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
- New requirements at the 2026-07-18 approval: The server owns every Leafnote grant and spend; clients cannot select prices, quantities, rewards, or balances; renewable flora harvests generate Leafnotes; first-playable spending is limited to the three base seeds. The flora-only source boundary is superseded below by approved bonded-creature sales.
- Risks: Client-authoritative balances, duplicate sales, negative balances, unbounded inflation, unclear no-loss behavior, or accidentally treating creatures and Adapted Seeds as approved sellables.
- Tests required: Definition validation, earn/spend state transitions, replay and rate-limit rejection, insufficient-funds handling, nonnegative balance invariants, save/load round trips, disconnect recovery, economy simulations, and Roblox Studio shop-flow tests.
- Action required: Gameplay Agent defines the later sell/reinvest flow; Data Agent proposes the minimal balance schema; Security Agent threat-models transactions and remotes; UI Agent presents affordability and results; Monetization Agent preserves the direct no-premium-conversion boundary and audits the separately approved paid-steal exception.

### Supersession: creature sales added as a Leafnote source

On 2026-07-19, the user approved sales of bonded, player-owned creatures as a second Leafnote source. The earlier flora-only source restriction is superseded only to that extent. Leafnotes remain the sole first-playable soft currency.

Later on 2026-07-19, the user approved paid true-transfer stealing with full ownership and sale rights. Direct Robux-to-Leafnote exchange remains prohibited, but the buyer may sell an approved stolen asset normally. This is an explicit indirect-value exception; upkeep, currency loss, debt, and passive-interest boundaries remain unchanged.

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
- Action required: After explicit Phase 1 authorization, Gameplay and Data Agents define Emberkeep state and persistence; VFX Agent proposes a restrained Starlace treatment after budgets exist; Monetization Agent preserves the no-functional-value boundary.

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
- Action required: Use the approved Observe → Care → Bond contract recorded above; Gameplay Agent translates it into a later encounter contract, and Enemy AI Agent aligns a bounded visitor state model with it.

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
- Decision made: Initially target cozy, communal opportunity rather than destructive competition for the first release.
- Reasoning summary: Creature care, plot expression, and shared weather are more coherent when players are not protecting progress from one another.
- Result: At the 2026-07-16 decision, theft, destructive decay, and paid offensive power were deferred.
- Test evidence: Requires player research and prototype feedback.
- Mistakes discovered: None yet.
- Recommended future approach: Treat any future competitive proposal as a new contract requiring explicit approval.
- Confidence level: High
- Verification status: Not yet implemented

### Supersession: paid true-transfer stealing

On 2026-07-19, the user approved paid true-transfer stealing as a narrow later-update exception with free inventory/held/favorite protection, no duplication, and full buyer ownership/economic rights. It is not part of the first playable. Destructive decay and mandatory defense remain outside the approved direction; exact protection timing remains unresolved.
