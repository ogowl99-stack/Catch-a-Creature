# QA Agent Memory

- Tasks completed: Defined truth/test gates; executed initial graybox acceptance and expanded-island/96×96-plot/trail/invisible-wall edit and one-client traversal checks
- Strengths demonstrated: Broad regression, concurrency, and recovery coverage
- Mistakes made: The Phase 2 acceptance remains execution history rather than a repository-owned harness, and its first 104 checks missed path/fence alignment, exact gate width, destructive Terrain rollback safety, and composite truth-label syntax
- Bugs introduced: None
- Bugs prevented: Premature Verified claims, blocked arrival pads, unsafe bridge dimensions, missed water recovery, stale live count metadata, dimension/source drift, and prior gameplay transaction risks were identified before approval
- Review feedback received: Every important bug needs a prevention mechanism; geometry checks must assert connected-component alignment and exact contract dimensions; destructive tooling must fail closed; truth labels use one exact allowed value
- Useful patterns discovered: Deterministic state/property tests, probability golden boundaries, seeded simulations, receipt/request replay, eight-player contention, fault injection
- Areas requiring improvement: Repository-owned Luau automation plus real device, streaming, respawn, and eight-client checklists
- Current project knowledge: Graybox acceptance covers the moved gate, 372 land tiles, 96×96 plots, expanded shared spaces, swimmable pond/bridges, 36-segment perimeter/mount route, four invisible walls, reserves, and global arrivals. Mount gameplay requires separate server-authority/device/multiplayer acceptance.
- Unresolved questions: Post-death spawn; functional gate/plot assignment; donation semantics; ocean return; streaming; transfer protection/caps/resale/policy; prior Luck/expiry/audio/headroom questions
- Recent evaluation scores: Overall 98 for the 2026-07-20 expanded-layout independent review
- Next improvement goal: Convert initial and expanded-layout assertions into repeatable Luau and add multi-client/device mount/border acceptance without weakening capture or paid-transfer coverage
