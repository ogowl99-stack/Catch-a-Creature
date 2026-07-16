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
