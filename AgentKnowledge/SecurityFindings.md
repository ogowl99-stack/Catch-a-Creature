# Security Findings

## Entry: Single sale is exact-equipped; bulk sale is authoritative and favorite-safe

- Date: 2026-07-21
- Agent: Codex / Security, Data, and Gameplay roles
- System affected: Equip remote, single sale, bulk sale, item identity, payout, and replay
- Situation: Owning an item was not sufficient authorization for the user's requested single-item sale flow; bulk sale had to work without equip while excluding favorites.
- Decision made: Track equipped UUID/slot server-side for the session; reject `SellItem` unless it matches; derive every bulk candidate and payout from authoritative profile/definitions; commit bulk atomically; keep request fingerprinting/replay.
- Reasoning summary: Client selection, displayed card, weight, favorite set, and payout are all forgeable presentation inputs.
- Result: A direct unequipped sale returned `ITEM_NOT_EQUIPPED` with no revision/item change. Favorite-only bulk returned `NO_SELLABLE_ITEMS`; tested mixed bulk removes only eligible items and exact hotbar references.
- Test evidence: Farm Domain and Farm Service suites plus live malicious/no-op checks.
- Mistakes discovered: None in the final authority boundary.
- Recommended future approach: Add rate limits/telemetry before public release and multiplayer races against store/favorite/sell/harvest operations.
- Confidence level: High for deterministic and one-client behavior
- Verification status: Verified

## Finding: Forage rewards must never be client-selected

- Date: 2026-07-21
- Agent: Codex / Security, Data, and Gameplay roles
- System affected: Forage remote surface, RNG, inventory grants, cooldowns, and world prompts
- Situation: A client-visible prompt and RemoteFunction could otherwise be forged to request Mythic rewards, bypass distance, reroll rejected attempts, or move nodes without a durable grant.
- Decision made: The world service performs humanoid/root/distance validation and calls a server-only service method. FarmService selects the eligible definition and injects a private table-identity grant token that cannot survive client serialization. FarmDomain revalidates the token, node, definition, cooldown, capacity, and stack bounds. Invalid/full/cooldown/no-reward paths perform no RNG or mutation, and only `ok=true` relocates/presents.
- Reasoning summary: Keeping reward choice and authorization entirely server-side removes the attacker-controlled rarity/result input and preserves deterministic rejection behavior.
- Result: Forged public forage commands fail; exact replay remains idempotent; one live cooldown retry produced no reward or relocation.
- Test evidence: Five service tests, 37 domain/schema tests, seven forage-world tests, and live one-client distance/prompt/cooldown evidence.
- Mistakes discovered: Per-player cooldown alone does not prevent a player from automating a fixed coordinate; relocation is a complementary friction control, not a complete anti-cheat system.
- Recommended future approach: Add rate telemetry and bounded per-player request throttling only from observed abuse; test simultaneous prompts with two clients; never expose desired rarity or definition as an accepted client contract.
- Confidence level: High for current forgery boundary; Medium for macro resistance; Low for adversarial multiplayer behavior until tested
- Verification status: Code-reviewed and one-client Verified; multiplayer Requires Roblox Studio testing

## Entry: First Cozzle projection cannot create ownership

- Date: 2026-07-21
- Agent: Codex / Security, Architecture, Data, Gameplay, and QA roles
- System affected: Plant definition requests, visitor creation, ownership, capture eligibility, runtime attributes, and client presentation
- Situation: A visible creature arrival can accidentally become an ownership shortcut if the client chooses definitions or the world model is treated as authoritative inventory.
- Decision made: Allowlist BuySeed/PlaceSeed definition IDs on the server; derive Cozzle only from committed plotted Hearthpetal state; cap one projection; set `Wild=true`, `Owned=false`, and `CaptureEnabled=false`; introduce no creature mutation remote, Backpack record, sale value, or ownership profile field in this slice.
- Reasoning summary: A world model proves presentation, not entitlement. Ownership must later be a separate durable server transaction with replay, capacity, and contention checks.
- Result: Unknown definitions fail `INVALID_REQUEST`; Sunspud never attracts Cozzle; the live visitor has the required negative ownership attributes and disappears when no plotted attractor remains.
- Test evidence: Domain invalid-definition case, five attraction-selection cases, live runtime attribute inspection, removal integration fixture, and clean console.
- Mistakes discovered: None in the ownership boundary. The main remaining risk is future code treating the projection model as an encounter database rather than deriving or looking up authoritative server state.
- Recommended future approach: Introduce opaque encounter ID/revision only with Observe; never accept a client-owned Cozzle instance or definition as proof; keep capture disabled until storage, retry, RNG, and durable ownership tests pass.
- Confidence level: High for the current non-owning slice; Low for future capture until implemented and attacked
- Verification status: Verified for current visitor projection

## Entry: Retry/Let Go uses one decision token and celebration follows commit

- Date: 2026-07-19
- Agent: Security Agent / Architecture Agent / Data Agent / UI Agent / VFX Agent / Performance Agent / QA Agent / Codex
- System affected: Failed-attempt transaction, decision token, queue, Familiarity, items, ownership, celebration event, replay, disconnect, and expiry
- Situation: The user approved all accepted-attempt item consumption, exact Familiarity guarantees, fair round-robin, Retry/Let Go after failure, No Aid/guaranteed-attempt rules, caretaker Let Go behavior, and Mythic/Legendary success presentation.
- Decision made: Commit the failed attempt first: decrement one Haven Tag and selected free aid exactly once, record the outcome/idempotency key, and increment the matching Familiarity failure count once. Then issue one opaque decision token. Retry and Let Go race on that token; exactly one terminal decision is recorded. Retry adds at most one user intent after existing distinct waiters without reserving items/storage while queued. Let Go removes only that user's intent, preserves Familiarity, and leaves the encounter unchanged. Queue-front processing revalidates Trust, proximity, capacity, item/aid, revision, phase, and deadline before RNG. On success, retain the attempt lock through durable capacity use, input decrement, immutable owned-UUID creation, exact trait/provenance copy, matching Familiarity reset, and outcome record. Only then emit a sanitized, deduplicated celebration event. The client cannot request a celebration tier or mutate ownership.
- Reasoning summary: A one-use decision token prevents duplicate Retry, duplicate Let Go, and simultaneous-decision races. Post-commit cosmetic emission prevents optimistic ownership, replay rewards, and cosmetic rollback of valuable state.
- Result: Exact security/state boundary is code-reviewed. User-approved all-attempt costs, progress/fairness, No Aid retry default, guaranteed-attempt Luck disabling, caretaker Let Go behavior, and Mythic/Legendary celebration tiers are represented. Exact schema, token lifetimes, Luck formula, technical commit grace, audio, and measured budgets remain unresolved. No implementation exists.
- Test evidence: Independent Security/Architecture, QA/UI, and VFX/Audio/Performance reviews on 2026-07-19. No remote, fault, concurrency, replay, Studio, or device test exists.
- Mistakes discovered: A queue that reserves consumables before a turn could strand or over-consume them. Let Go without a one-use token could race Retry. A client-driven success cutscene could be forged or replayed.
- Recommended future approach: Build deterministic state/property tests and fault injection around every transaction boundary; dedupe outcome/decision/celebration IDs; treat disconnect while deciding as personal Let Go for queue purposes; stop new intents at expiry; allow only bounded in-flight commit grace; keep invalid decisions constant-time and side-effect-free.
- Confidence level: High for transaction/replay boundaries; Medium for record implementation; Low for throughput until tested
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Entry: No-cooldown capture retry cannot overlap rolls

- Date: 2026-07-19
- Agent: Security Agent / Architecture Agent / Data Agent / Performance Agent / QA Agent / Codex
- System affected: Capture RemoteEvents, attempt tokens, idempotency, Familiarity, items, contention, visitor expiry, and abuse prevention
- Situation: The user removed the post-failure cooldown and approved immediate rising-chance retries.
- Decision made: Interpret immediate as “as soon as the prior authoritative result is durable,” never “accept all buffered clicks.” Use a server-issued one-use attempt token tied to player, encounter, eligibility revision, and selected inputs; one active roll per player and encounter; one bounded pending intent per contender; and idempotent request replay. Rejected traffic receives no RNG, item mutation, Familiarity, VFX, save, or navigation work. Valid failure consumes one Haven Tag and the selected free aid and increments the approved Familiarity bucket exactly once in the same transaction. Success creates one owner. Rate limits and server saturation controls are transport safeguards, not gameplay cooldowns.
- Reasoning summary: Without serialization, an autoclicker can create overlapping odds, double-consumption, duplicate progress, excessive writes, and latency monopoly while the UI appears to allow a single immediate retry.
- Result: Security boundary is code-reviewed. User-approved pacing, all accepted-attempt consumption, +2-point Familiarity/guarantees, fair distinct-contender ordering, No Aid retry default, and guaranteed-attempt Luck disabling are preserved. Token lifetime, audit retention, Luck formula/recipes, and commit grace remain provisional.
- Test evidence: Read-only security/architecture review on 2026-07-19. No adversarial, bot, latency, persistence, queue, or Studio test exists.
- Mistakes discovered: The earlier cooldown proposal incidentally limited request rate; removing it requires explicit one-in-flight and no-work rejection rules rather than a hidden replacement timer.
- Recommended future approach: Threat-model final remotes; prove duplicate/new-ID spam, lost acknowledgment, disconnect/save faults, expiry, and eight-player contention; measure accepted/rejected throughput; expose exact result/next chance without trusting the client.
- Confidence level: High for safeguards; Medium for queue fairness until selected and simulated
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Entry: Wild-capture authority and free-only chance boundary

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent / Monetization Agent / QA Agent / Codex
- System affected: Encounter remotes, capture RNG, consumables, Backpack capacity, ownership, persistence, rate limits, paid-random policy, and later paid theft
- Situation: A competitively available wild visitor can receive near-simultaneous capture requests from up to eight players, while capture and luck items modify a chance-based result.
- Decision made: Clients may send only encounter/item identifiers and idempotent request IDs. The server derives encounter revision, access/distance, personal eligibility, rarity, base/final chance, modifier validity, Backpack capacity, roll, winner, and owned record. Invalid, stale, busy, rate-limited, or full-storage requests fail before RNG and consumption. One request conditionally reserves the encounter and one player slot; an accepted roll is recorded exactly once; success commits one owner before despawn. Replays return the prior result. Capture items, luck aids, and all required ingredients remain gameplay-earned, account-bound, nontradeable, nonstealable, and disconnected from Robux or Robux-derived value for the first implementation. Wild visitors cannot be paid-steal targets.
- Reasoning summary: Client-authored odds or ownership enable forgery, while non-atomic contention enables duplicate owners and lost items. A paid or indirectly paid route into chance modifiers would trigger additional disclosure and policy restrictions and could make a cozy competitive encounter coercive.
- Result: Security boundaries are code-reviewed. All accepted-attempt consumption, No Aid retry default, and guaranteed-attempt Luck disabling are approved. Exact remotes, rates, audit retention, item recipes/formula, policy-source tagging, and plot access remain provisional. No implementation exists.
- Test evidence: Independent read-only Architecture/Data/Security/Monetization/Performance review on 2026-07-19. No adversarial remote, RNG, persistence, contention, policy, or Studio test exists.
- Mistakes discovered: The prior deterministic bonding contract had no contested RNG transaction. Leafnotes later sourced from paid-stolen assets could create an indirect paid-to-random path if capture materials were sold for ordinary currency; dedicated free-only crafting avoids that ambiguity.
- Recommended future approach: Threat-model the final remote contract; use checked integer probability units, revision/CAS locks, bounded idempotency records, token buckets, and fault injection; add a static provenance test preventing every paid-to-capture path; reopen PolicyService review before any future paid modifier.
- Confidence level: High for authority/atomicity requirements; Medium for the free-only provenance design until recipes and economy are defined
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Entry: Paid true-transfer stealing boundary

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent
- System affected: Developer-product receipts, policy eligibility, cross-player item ownership, plot exposure, inventory, provenance, appraisal, and Leafnotes
- Situation: The user approved a paid mechanic that permanently transfers one exposed plant or bonded roaming/displayed creature, including its economic traits and sale rights.
- Decision made: Treat stealing conservatively as paid cross-player item transfer. Both users must be online in the same eligible server and pass required `PolicyService` checks; policy failure fails closed. The server validates immutable item ID, owner, plot, state, revision, protection, distance, and eligibility. `ProcessReceipt` grants only a nontradeable persistent credit. A revision-checked item-centric transaction moves ownership exactly once, preserves traits/provenance, projects to a capacity-safe buyer inbox, and consumes one credit. Invalid targets retain the credit and never trigger a random fallback.
- Reasoning summary: The mechanic combines a paid receipt with non-consensual persistent transfer, so client trust, stale target state, concurrent actions, regional arbitrage, alt collusion, and partial saves can cause fraud, duplication, or irreversible loss.
- Result: Security requirements and launch blockers are recorded. Official Roblox documentation does not explicitly approve or classify paid non-consensual transfers, so platform compatibility is unresolved pending Roblox confirmation.
- Test evidence: Current official Roblox documentation review plus independent security/design review on 2026-07-19. No implementation, adversarial test, policy test, purchase test, DataStore test, or Studio test exists.
- Mistakes discovered: A live target must not be encoded as an implicit “latest selection” for a receipt; victim compensation would create a repeatable alt-account currency-generation path; a duplicate replacement violates the user's exact-transfer rule.
- Recommended future approach: Obtain policy confirmation, retain complete audit/provenance, use bounded free anti-chain safeguards, block protected/account-bound content, reconcile uncertain commits, and launch only after closed multiplayer trust testing.
- Confidence level: High for security risks and receipt rules; Medium for platform eligibility until Roblox confirms classification
- Verification status: Code-reviewed
- Implementation status: Not yet implemented
- Launch status: Blocked
- Launch blocker: Roblox policy or Developer Relations must confirm the platform classification before launch.

## Entry: Creature appraisal and terminal transaction boundary

- Date: 2026-07-19
- Agent: Data Agent / Security Agent
- System affected: Creature persistence, appraisal, sale, release, favorites, journal, and Leafnotes
- Situation: The approved first-playable economy now permits bonded creatures with mutation, size, and weight variation to be sold for Leafnotes or released without currency.
- Decision made: The client may identify an owned creature and request a confirmed action, but the server reads the persisted creature instance and versioned definitions, validates ownership/state/favorite protection, calculates bounded value, and atomically commits exactly one sale or release. Sale/release requests require idempotency records, and a terminal creature cannot be paid or removed twice.
- Reasoning summary: Client fields, tool attributes, rendered model scale, UI labels, or Workspace objects can be forged or stale. Server-owned persisted inputs and atomic terminal transitions prevent value forgery, duplication, cross-player sale, and sale/release races.
- Result: A security and persistence boundary is defined for future implementation. Exact schema, fixed-point units, value formula, quote behavior, ledger retention, and failure UX remain provisional.
- Test evidence: Read-only Data/Security design review on 2026-07-19. No code, remote, DataStore, adversarial, disconnect, multiplayer, or Roblox Studio test exists.
- Mistakes discovered: Earlier design records did not need a creature transaction boundary because first-playable creature selling had not yet been approved.
- Recommended future approach: Persist stable valuation inputs rather than sale prices, use checked bounded arithmetic, version valuation definitions, filter favorites server-side, reconcile uncertain commits from the ledger, and fail closed without item loss or duplicate payout.
- Confidence level: High for the security boundary; Medium for transaction details until a schema and failure model are approved
- Verification status: Code-reviewed
- Implementation status: Not yet implemented

## Entry: Public repository disclosure review

- Date: 2026-07-18
- Agent: Codex / Security Agent
- System affected: Source control, repository privacy, contributor workflow
- Situation: The user asked to make `ogowl99-stack/Catch-a-Creature` public so a friend could help. Public visibility exposes committed files, branches, and reachable history to anyone.
- Decision made: Change the repository from private to public only after an informed confirmation, a read-only credential scan, and an independent Security Agent review.
- Reasoning summary: Public collaboration is useful, but visibility changes can disclose secrets and personal metadata irreversibly through clones or forks.
- Result: GitHub visibility changed to `PUBLIC` and was verified with `gh repo view`. The repository remains approved from a credential-risk perspective, with privacy caveats.
- Test evidence: Primary and independent heuristic scans covered 49 tracked files, 54 unique blobs, and all four locally reachable commits. They found no credential signatures or sensitive filenames. Tracked text contained no email addresses, local Windows user paths, or IPv4-like strings.
- Mistakes discovered: The GitHub CLI token had expired and required reauthentication. Two commits expose a non-noreply Gmail author address. Five PNGs contain nonstandard `caBX` chunks; three produced unclassified email-like binary candidates, so image-metadata privacy review is not fully conclusive.
- Recommended future approach: Use GitHub's noreply commit address, add an automated dedicated secret scanner before publication milestones, review nonstandard image metadata, and remember that public visibility does not grant direct push access without collaborator permission.
- Confidence level: High for GitHub visibility and scanned credential patterns; Medium for PNG privacy because three binary candidates remain unclassified
- Verification status: Verified
- Heuristic security scan status: Code-reviewed
- PNG metadata status: Blocked
- PNG metadata evidence note: Three binary candidates remain unclassified; no personal-data finding is verified.
- Independent review: Security Agent approved remaining public from a credential-risk perspective and recorded the author-email privacy warning.

## Entry: Economy authority

- Date: 2026-07-16
- Agent: Security Agent
- System affected: Purchases, inventory, economy, breeding, trading, weather, rewards
- Situation: Valuable persistent objects and randomized outcomes create duplication and forgery risks.
- Decision made: Every economic mutation is validated and resolved on the server. The client never selects item definitions, traits, quantities, prices, parents, provenance, or RNG outcomes.
- Reasoning summary: Client trust would allow exploiters to mint rare plants, creatures, currency, or purchase grants.
- Result: Security boundary recorded.
- Test evidence: Requires code review, adversarial tests, and Roblox Studio validation.
- Mistakes discovered: None yet.
- Recommended future approach: Threat-model every RemoteEvent and transaction before implementation approval.
- Confidence level: High
- Verification status: Not yet implemented

## Entry: Purchase processing

- Date: 2026-07-16
- Agent: Security Agent / Data Agent
- System affected: Monetization
- Situation: Repeatable purchases may include care supplies or community-event credits.
- Decision made: Use `MarketplaceService.ProcessReceipt` with an idempotent persistent receipt ledger. Never grant from client prompt completion.
- Reasoning summary: Receipt callbacks can retry and client events do not prove payment.
- Result: Purchase architecture requirement recorded.
- Test evidence: Official Roblox documentation; local implementation absent.
- Mistakes discovered: None yet.
- Recommended future approach: Test duplicate delivery, disconnects, full inventory, unknown products, stale catalogs, and uncertain saves.
- Confidence level: High
- Verification status: Verified
- Evidence class: Official Roblox platform documentation
- Local implementation: Not yet implemented

## Entry: Provenance

- Date: 2026-07-16
- Agent: Security Agent / Data Agent
- System affected: Plants, creatures, breeding, trading
- Situation: Paid, event, wild, bred, and adapted origins may have different eligibility and policy rules.
- Decision made: Persistent objects require unique IDs, definition IDs, owner/origin data, parent references where applicable, paid-origin markers, functional and cosmetic trait separation, and trade/progression eligibility.
- Reasoning summary: Provenance is necessary to prevent laundering paid or duplicated value through breeding and trading.
- Result: Data requirement recorded.
- Test evidence: Requires schema and tests.
- Mistakes discovered: None yet.
- Recommended future approach: Define provenance before any persistent item can reproduce or transfer.
- Confidence level: High
- Verification status: Not yet implemented
