# Agent Learning and Command Center Plan

- Date: 2026-07-16
- Status: Documentation foundation created; dashboard not yet implemented
- Truth label: Not yet implemented unless noted

## Project-specific learning model

The agent system does not claim to retrain or permanently alter underlying AI models. It improves project work through persistent shared knowledge, specialized memory, evaluation history, reusable patterns, explicit failures, tests, and retrospectives.

Important-task cycle:

`recall -> plan -> implement -> self-review -> independent review -> testing -> reflection -> knowledge update -> Codex approval`

Before an important task, the assigned agent must record:

- Intended approach and files affected
- Dependencies and formal handoffs
- Correctness, security, performance, compatibility, and mobile risks
- Automated, Studio, multiplayer, device, and manual tests required
- A rollback or safe-disable approach

Self-review must cover correctness, completeness, cleanup, architecture, server authority, performance, mobile/controller compatibility, documentation, test coverage, and possible regressions. Independent review is routed by risk: Architecture for boundaries, Security for remotes or purchases, Data for persistence, Performance for expensive systems, UI for player-facing interaction, and QA for behavior and regression coverage.

A bug is not complete until its cause and detection gap are understood and at least one prevention mechanism exists: regression test, validation rule, architecture constraint, checklist addition, monitoring rule, or knowledge entry.

For an important bug, the record must answer:

1. What caused it?
2. Why was it not detected earlier?
3. Which role or process should have detected it?
4. Is the issue likely to recur?
5. Can a test prevent it?
6. Can validation prevent it?
7. Can architecture make it impossible?
8. Is a new coding rule required?
9. Must a checklist change?
10. Which other agents need the warning?

## Shared and personal memory

The required `AgentKnowledge/` structure contains project context, decisions, design knowledge, discipline patterns, findings, test knowledge, failure and success libraries, bug knowledge, feedback, scores, improvement goals, and lessons.

The required `AgentMemory/` structure contains project-specific memories for game design, architecture, map, gameplay, enemy AI, UI, VFX, audio, data, monetization, security, performance, QA, and documentation.

Every agent reviews relevant shared and personal memory before a task and updates it after meaningful work. A formal cross-agent handoff records what and why something changed, APIs and files affected, new requirements, risks, tests required, and the receiving agent's required action.

## Evaluation and adaptive assignment

Evidence-supported scores use 0-100 for correctness, code quality, architecture compliance, security, performance, test quality, documentation, creativity, visual quality, collaboration, task completion, and regression prevention. Irrelevant categories are `N/A`; output volume is not a quality measure.

Codex assigns work using role specialty, historical score, recent mistakes, active improvement goal, workload, dependencies, risk, and required review experience. Repeated weakness results in narrower instructions, smaller task scope, additional review, relevant memory references, and required tests. Every agent keeps one active improvement goal.

## Decision, experiment, and feedback workflows

High-impact changes to architecture, schemas, remotes, the main loop, monetization, expensive AI, streaming, or asset loading require a focused debate: primary proposal, Architecture compatibility review, Security risk review, Performance cost review, QA test plan, one relevant alternative, Codex decision, recorded rationale, and knowledge update.

Experiments must record hypothesis, change, success and failure metrics, environment or test group, required data, risks, rollback, result, and decision. An unverified experiment cannot silently become the production design.

When player feedback or analytics exist, classify them as bugs, confusion, difficulty, performance, mobile controls, UI, audio, fairness, monetization, requests, or positive feedback. Evaluate frequency, evidence, fit with the game's goals, security/performance risks, impact on other players, and whether an experiment is needed. No analytics or feedback may be invented.

## Retrospectives

At every major milestone, record completed work, what worked, delays, bugs introduced or avoided, helpful and harmful decisions, useful and missing tests, agent performance and support needs, automation opportunities, next-phase changes, and knowledge to preserve. Update shared memory, personal memory, coding standards, tests, risk records, goals, and task-assignment strategy.

## Minimal command center recommendation

When the user authorizes implementation, the first implementation task before game production is a small, read-only command center:

- Node.js HTTP server
- Static HTML, CSS, and JavaScript
- JSON data plus Markdown knowledge
- SVG for task and architecture graphs
- No package installation or build pipeline for version one

It is intentionally unbuilt now because the user explicitly paused implementation while the main game details are decided. Once authorized, version one will be time-boxed so it supports the first playable instead of delaying it.

## Visual system and mock layout

Use pastel colors, rounded cards, soft shadows, readable labels, cute role-specific agent avatars, and a central Codex operator. Status motion is driven only by real status data; no random progress or simulated work animations are allowed.

```text
+------------------------------------------------------------------+
| Project Status / Objective / Health                              |
| Build | Tests | Blockers | Bugs | Security | Performance | Review|
+------------------------+-----------------------------------------+
| Live Activity Feed     | Central Codex Operator                  |
| filters + truth labels | real task and review state              |
+------------------------+-----------------------------------------+
| Task Dependency Map    | Agent workstations and warnings         |
+------------------------+-----------------------------------------+
| Architecture | Tests | Bugs | Learning | Previews | Performance  |
+------------------------------------------------------------------+
```

Real collaboration edges can glow or warn only when a matching `dependencyEdges` or review event exists in the data. The dashboard includes project status, agent cards, activity filters, task dependencies, architecture, tests, bugs, learning, previews, and measured performance.

## Versioned dashboard contract

Allowed truth labels are exactly: `Verified`, `Code-reviewed`, `Simulated`, `Estimated`, `Requires Roblox Studio testing`, `Requires user asset`, `Blocked`, and `Not yet implemented`.

```json
{
  "schemaVersion": 1,
  "generatedAt": "2026-07-16T00:00:00Z",
  "project": {
    "name": "Catch a Creature",
    "phase": "Research",
    "objective": "Establish the core game design",
    "health": "not-yet-implemented",
    "truthLabel": "Not yet implemented",
    "evidence": ["Research/ResearchBaseline.md"],
    "updatedAt": "2026-07-16T00:00:00Z"
  },
  "codex": {
    "reviewQueue": 0,
    "blockers": 0,
    "decisions": [],
    "truthLabel": "Code-reviewed",
    "evidence": ["AgentKnowledge/ArchitectureDecisions.md"],
    "updatedAt": "2026-07-16T00:00:00Z"
  },
  "agents": [
    {
      "id": "gameplay-agent",
      "name": "Gameplay Agent",
      "role": "Core gameplay systems",
      "avatar": {"icon": "sprout-robot", "color": "#8FD6A3"},
      "status": "waiting",
      "taskId": null,
      "progress": null,
      "score": null,
      "confidence": null,
      "improvementGoal": "Finish the smallest complete loop first",
      "files": [],
      "dependencies": [],
      "latestResult": null,
      "warnings": [],
      "reviewRequired": false,
      "history": [],
      "truthLabel": "Not yet implemented",
      "evidence": ["AgentMemory/GameplayAgent.md"],
      "updatedAt": "2026-07-16T00:00:00Z"
    }
  ],
  "tasks": [
    {
      "id": "task-id",
      "title": "Example task shape",
      "status": "pending",
      "priority": "medium",
      "agentId": null,
      "dependencyIds": [],
      "systems": [],
      "files": [],
      "progress": null,
      "review": {"required": true, "reviewerIds": [], "status": "pending"},
      "testIds": [],
      "truthLabel": "Not yet implemented",
      "evidence": [],
      "updatedAt": "2026-07-16T00:00:00Z"
    }
  ],
  "dependencyEdges": [
    {
      "id": "edge-id",
      "fromId": "task-id",
      "toId": "gameplay-agent",
      "type": "assignment",
      "status": "inactive",
      "label": "Example only",
      "truthLabel": "Not yet implemented",
      "evidence": [],
      "updatedAt": "2026-07-16T00:00:00Z"
    }
  ],
  "events": [
    {
      "id": "event-id",
      "occurredAt": "2026-07-16T00:00:00Z",
      "agentId": "gameplay-agent",
      "taskId": "task-id",
      "system": "gameplay",
      "severity": "low",
      "type": "task-assigned",
      "message": "Example event shape",
      "truthLabel": "Not yet implemented",
      "evidence": [],
      "updatedAt": "2026-07-16T00:00:00Z"
    }
  ],
  "architecture": {
    "modules": [
      {
        "id": "module-id",
        "name": "ExampleModule",
        "authority": "server",
        "purpose": "Example module shape",
        "publicApi": [],
        "dependencyIds": [],
        "dependentIds": [],
        "testIds": [],
        "knownIssueIds": [],
        "assignedAgentId": null,
        "lastModifiedAt": null,
        "truthLabel": "Not yet implemented",
        "evidence": [],
        "updatedAt": "2026-07-16T00:00:00Z"
      }
    ],
    "remotes": [
      {
        "id": "remote-id",
        "name": "ExampleRemote",
        "direction": "client-to-server",
        "serverValidation": [],
        "rateLimit": null,
        "producerIds": [],
        "consumerIds": [],
        "truthLabel": "Not yet implemented",
        "evidence": [],
        "updatedAt": "2026-07-16T00:00:00Z"
      }
    ],
    "dataFlows": [
      {
        "id": "flow-id",
        "fromId": "remote-id",
        "toId": "module-id",
        "dataType": "example",
        "securityBoundary": true,
        "description": "Example data-flow shape",
        "truthLabel": "Not yet implemented",
        "evidence": [],
        "updatedAt": "2026-07-16T00:00:00Z"
      }
    ]
  },
  "tests": [
    {
      "id": "test-id",
      "suite": "example",
      "name": "Example test shape",
      "status": "not-run",
      "commandOrProcedure": null,
      "outputReference": null,
      "reproductionSteps": [],
      "affectedFiles": [],
      "bugId": null,
      "truthLabel": "Not yet implemented",
      "evidence": [],
      "updatedAt": "2026-07-16T00:00:00Z"
    }
  ],
  "bugs": [
    {
      "id": "bug-id",
      "title": "Example bug shape",
      "severity": "low",
      "system": "example",
      "assignedAgentId": null,
      "status": "pending",
      "reproductionSteps": [],
      "suspectedCause": null,
      "fixAttempts": [],
      "regressionTestId": null,
      "codexApproval": "pending",
      "truthLabel": "Not yet implemented",
      "evidence": [],
      "updatedAt": "2026-07-16T00:00:00Z"
    }
  ],
  "knowledgeUpdates": [
    {
      "id": "knowledge-id",
      "agentId": "gameplay-agent",
      "system": "gameplay",
      "memoryPath": "AgentMemory/GameplayAgent.md",
      "summary": "Example knowledge-update shape",
      "verificationStatus": "Not yet implemented",
      "confidence": null,
      "truthLabel": "Not yet implemented",
      "evidence": [],
      "updatedAt": "2026-07-16T00:00:00Z"
    }
  ],
  "previews": [
    {
      "id": "preview-id",
      "type": "map",
      "title": "Example preview shape",
      "assetReference": null,
      "captureEnvironment": null,
      "warnings": [],
      "truthLabel": "Not yet implemented",
      "evidence": [],
      "updatedAt": "2026-07-16T00:00:00Z"
    }
  ],
  "metrics": [
    {
      "id": "metric-id",
      "name": "Example metric shape",
      "value": null,
      "unit": null,
      "collectionEnvironment": null,
      "collectedAt": null,
      "truthLabel": "Not yet implemented",
      "evidence": [],
      "updatedAt": "2026-07-16T00:00:00Z"
    }
  ]
}
```

The example records above document shapes only; they are omitted from live project data until corresponding evidence exists.

Agent status enum: `thinking`, `planning`, `building`, `coding`, `testing`, `reviewing`, `blocked`, `waiting`, `fixing`, `complete`, `rejected`, `approved`. Task status enum: `pending`, `in-progress`, `blocked`, `in-review`, `complete`, `rejected`, `approved`. Priority and bug severity enum: `blocker`, `critical`, `high`, `medium`, `low`. Test status enum: `not-run`, `running`, `passed`, `failed`, `skipped`, `blocked`.

Architecture authority enum: `server`, `client`, `shared`, `data`, `external`. Remote direction enum: `client-to-server`, `server-to-client`, `bidirectional`. Preview type enum: `map`, `ui`, `vfx`, `architecture`. Activity event types are allow-listed from task assignment, planning, file change, testing, bug, review, knowledge, security, performance, and milestone events; each type must supply the corresponding agent, task, system, severity, time, and evidence fields needed by feed filters.

Every event, architecture module, remote, flow, test, bug, knowledge update, preview, and metric follows the same evidence envelope: stable `id`, relevant typed fields, `truthLabel`, `evidence` array, and ISO-8601 `updatedAt`. Tests additionally store suite, command or Studio procedure, status, output/error reference, reproduction steps, affected files, and related bug. Bugs store severity, system, assignee, status, reproduction, suspected cause, fix attempts, regression test, and Codex approval. Metrics store value, unit, collection environment, and collection time; estimates are labeled `Estimated`.

## Validation and safe controls

- Invalid JSON or schema versions render an explicit error and a safe empty state.
- Missing fields remain `null` or unavailable; the UI never invents replacements.
- Unknown enum values display as invalid, stale timestamps create a warning, and progress is clamped to 0-100 only when reported.
- Text is rendered as text, not trusted HTML; file paths and evidence references are non-executable labels.
- A test can display `passed` only with a recorded command/procedure and evidence reference.
- Version one is read-only.
- Later safe controls may request review, pause/reassign a task, change priority, or add a test/improvement goal through validated project data.
- Source changes, publishing, purchases, deletion, DataStore actions, and destructive operations always require explicit confirmation and never appear in the public game.

## Data that can be truly live

From repository/project data:

- Git and file-change activity
- Real task and review states written by the project
- Test command results and linked errors
- Bug status and knowledge updates
- Declared architecture, dependencies, warnings, and evaluation history

With an active Roblox Studio MCP connection:

- Instance hierarchy and RemoteEvent map
- Edit/play-mode console output
- Viewport screenshots
- Measured client/server performance
- Actual interaction verification
- Map and UI preview captures

The Studio connection must be checked each time. If unavailable, the dashboard shows `Blocked` or `Requires Roblox Studio testing` instead of fabricating results.

## Still manual or user-controlled

- Publishing
- Multi-client testing without additional tooling
- Physical mobile, tablet, and controller testing
- Production-scale DataStore behavior
- Real analytics and player feedback
- Asset ownership and licensing review

## Developer-only Roblox agent room

A later private development build may visualize Codex at a central desk with specialist workstations for architecture, scripting, map, UI, VFX, audio, data, security, performance, and QA. A holographic dependency map, test wall, bug board, learning history, and sanitized previews can reflect the same versioned snapshot.

Access uses a server-side developer allowlist. The room reads a sanitized project-status snapshot and cannot expose publishing, purchases, DataStore deletion, source modification, or other destructive controls to ordinary players.
