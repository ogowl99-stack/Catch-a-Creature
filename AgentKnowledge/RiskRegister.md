# Risk Register

- Updated: 2026-07-19
- Milestone: Phase 0 design completion
- Truth label: Code-reviewed
- Evidence boundary: Design and repository evidence only; no implemented-game measurements exist

| ID | Owner | System | Risk and situation | Likelihood | Impact | Current mitigation / decision | Evidence and status |
|---|---|---|---|---|---|---|---|
| R-001 | Codex / Game Design | Scope | Phase 1 or later-update systems could begin before explicit authorization and contaminate the smallest playable. | Medium (Estimated) | High | Phase 0 completion does not authorize implementation; later paid stealing remains outside the first playable. | User-approved gates and start plan; Active |
| R-002 | Architecture / Data / Security | Persistence | Valuable plants or creatures could duplicate, disappear, or acquire conflicting owners during save, sale, release, or future transfer failures. | High (Estimated before implementation) | Critical | Immutable IDs, server authority, versioned schemas, idempotent ledgers, conditional transitions, recovery tests, and fail-closed grants are required before code approval. | Architecture/security reviews; Active |
| R-003 | Gameplay / Data / Monetization | Economy | Unproven prices, yields, mutation/size/weight valuation, and creature-sale income could make progression trivial, grindy, or dominated by one source. | High (Estimated) | High | Keep values provisional; simulate the renewable-flora and optional-creature-sale loop before balance approval. | No economy simulation exists; Active |
| R-004 | Monetization / Security / QA | Paid stealing | Later paid true-transfer stealing could cause policy violations, pay-to-grief concentration, retaliation spending, alt abuse, or player churn. | High (Estimated) | Critical | Defer to later update; obtain Roblox policy confirmation; require free protections, receipt/policy gates, audit, closed multiplayer tests, and stop metrics. | Specialist reviews; Launch status Blocked |
| R-005 | Architecture / Documentation | Source linkage | The authorized Studio place is not linked to repository source and no Rojo project/server is active, creating future Studio/repository divergence risk. | High (Verified current state) | High | Phase 1 must explicitly choose and verify the source workflow before production edits. | Read-only repository/Studio preflight; Active |
| R-006 | Performance / Map / VFX / Audio | Runtime scale | Crowded plots, creatures, particles, sounds, connections, and navigation may exceed low-end device budgets. | Medium (Estimated) | High | Establish measured representative-plot budgets before catalog expansion; use graybox and restrained first effects. | No measurements exist; Active |
| R-007 | UI / QA | Device accessibility | Bonding, inventory, appraisal, selling, and later theft interactions may fail on mobile, tablet, or controller. | High (Estimated) | High | Require parity from first wireframe, text/icon redundancy, focus testing, and manual real-device validation. | No device tests exist; Active |
| R-008 | Security / Documentation | Public repository privacy | Public history exposes two commits with a personal author email; three PNG binary metadata candidates remain unclassified. | Medium (Code-reviewed) | Medium | Use a noreply Git identity, add dedicated secret scanning, and classify/strip nonstandard metadata before public asset milestones. | 2026-07-18 publication review; Active |

## Review rule

Each milestone review must update likelihood, impact, mitigation, evidence, and status. Estimated risks become Verified only after direct evidence; resolved risks require a prevention mechanism and regression evidence.
