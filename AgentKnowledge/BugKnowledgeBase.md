# Bug Knowledge Base

No game-bug reports are recorded because no game implementation exists to inspect or test.

## Tooling incident: GitHub authentication validation

- Date: 2026-07-16
- Agent: Codex
- Severity: Medium tooling blocker
- System: GitHub publishing
- Reproduction: Complete GitHub CLI device authorization successfully, then run `gh auth status`; the token is reported invalid and `gh api user` receives an unexpected HTML response.
- Suspected cause: Credential/keyring or environment-specific GitHub CLI authentication behavior; direct GitHub API and Git transport endpoints are reachable.
- Fix attempt: Clean logout, fresh device codes, explicit repository scope, and endpoint checks.
- Prevention mechanism: Keep portable tooling ignored; verify authentication before staging; retain Git Credential Manager as the secure Git-transport fallback; never expose or persist tokens manually.
- Status: Under investigation during initial publish
- Regression test: `gh auth status`, authenticated identity query, and read-only remote check before future publish workflows
- Codex approval: Pending successful push
