# Failed Approaches

## FA-001: Conversation-only memory

- Date: 2026-07-16
- Agent: Codex
- System affected: Documentation and continuity
- Goal: Preserve research for later development.
- Attempted solution: Rely on the ongoing conversation as the primary record.
- Why it failed: Chat history is not a versioned project artifact and cannot be reviewed through Git like source files.
- Symptoms: The local repository remained empty even after substantial research.
- Performance impact: None.
- Security impact: None.
- Files affected: None before this foundation.
- Better replacement: Source-dated Markdown research, shared knowledge, agent memories, and committed decisions.
- Situations where it may still be useful: Temporary brainstorming before synthesis.

## FA-002: Content breadth before core depth

- Date: 2026-07-16
- Agent: Game Design Agent
- System affected: Roadmap
- Goal: Make the game feel rich and viral.
- Attempted solution: Brainstorm breeding, trading, events, monetization, rare weather, and customization before a playable loop existed.
- Why it failed: Ideas created dependencies without evidence that planting, attraction, and bonding were fun.
- Symptoms: Large design surface and unclear first prototype.
- Performance impact: High future risk if implemented simultaneously.
- Security impact: Trading and monetization would expand attack surface prematurely.
- Files affected: Research documents only.
- Better replacement: Smallest complete vertical slice followed by gated depth.
- Situations where it may still be useful: Long-term visioning when explicitly kept outside implementation scope.

## FA-003: Installing GitHub CLI through the Windows installer

- Date: 2026-07-16
- Agent: Codex
- System affected: Development tooling
- Goal: Meet the authenticated GitHub publishing workflow prerequisite.
- Attempted solution: Install GitHub CLI with Winget/MSI.
- Why it failed: The installer remained idle without placing the executable.
- Symptoms: Responsive but stalled `winget` and child `msiexec` processes.
- Performance impact: Temporary background processes only.
- Security impact: None observed.
- Files affected: No project files.
- Better replacement: Official portable GitHub CLI under ignored `.tools/` or Git Credential Manager for Git transport.
- Situations where it may still be useful: Normal interactive Windows environments where MSI installation completes.

## FA-004: Bind a developer-product receipt directly to a live steal target

- Date: 2026-07-19
- Agent: Architecture Agent / Data Agent / Security Agent
- System affected: Paid stealing, receipts, ownership, persistence, and recovery
- Goal: Charge once and immediately transfer the plant or creature selected before the Roblox prompt.
- Attempted solution: Treat the buyer's latest client-selected plot target as the item granted by `ProcessReceipt`.
- Why it failed: The receipt contains no trusted custom target intent, and a live target can be stored, sold, released, harvested, re-owned, disconnected, or concurrently reserved while the prompt is open. Retrying the receipt against mutable state can lose the purchase, steal the wrong item, or duplicate ownership.
- Symptoms: Stale-target transfer, indefinite `NotProcessedYet`, random substitution pressure, duplicate payout, double ownership, or permanent item loss.
- Performance impact: Repeated receipt retries and cross-profile lock contention could add unbounded work.
- Security impact: Critical risk of client target forgery, replay, wrong-owner transfer, and paid grant loss.
- Files affected: Design and knowledge documents only; no implementation exists.
- Better replacement: Grant one persistent buyer-bound Steal Credit idempotently, then redeem it through a separate exact-item conditional ownership transaction with a durable ledger and reconciler.
- Situations where it may still be useful: None for persistent paid cross-player items; a direct callback may grant a self-contained buyer-only product that does not depend on live external state.
