# Map Building Patterns

## Initial direction

- Compact hub with player plots around a central sanctuary landmark
- Curving paths and small visual rooms
- Clear sightlines to shops, event state, and owned plot
- Quiet base geometry so gardens remain dominant
- Plot scale validated before Blender production
- Navigation protected as plants grow large
- Weather and nighttime preserve path readability
- Community event landmark has a reusable safe footprint

Status: Not yet implemented. Requires graybox and Roblox Studio viewport evidence.

Document type: Baseline guidelines, not a completed knowledge entry. Add future findings using the full metadata format in `ProjectContext.md`.

## Entry: Approved sanctuary concept package

- Date: 2026-07-17
- Agent: Codex
- System affected: World layout, spawn, player plots, and Caretaker Hub
- Situation: The user reviewed multiple generated concepts and corrected landmark alignment, plot size, and the hub's facing direction before any map implementation began.
- Decision made: Use a Crescent Pond Sanctuary direction; center the Memory Tree through the Welcome Gate; standardize every player plot at 72×72 studs; place the Caretaker Hub southwest of the pond with its courtyard opening northeast toward the tree.
- Reasoning summary: A stable central landmark and equal plot footprints improve orientation and fairness. Correctly facing the hub toward the sanctuary center supports natural circulation without blocking the arrival sightline.
- Result: Four user-approved reference images, one requested whole-map top-down concept, and a remaining concept-generation plan were stored under `Design/`. The top-down concept uses eight equal perimeter plots as an explicit planning assumption; breeding and event spaces are future reserves.
- Test evidence: Direct user approval for the four foundation concepts, visual inspection of the generated top-down map, automated PNG/link validation, and independent map-document review. The final map render contains eight equal-looking plots, a centered southern gate/tree axis, crescent water, and four shared or reserved facility zones. No Roblox Studio graybox, navigation, camera, or performance testing has occurred.
- Mistakes discovered: The first gate image placed the tree off center; the first plot was too small; the first hub image made the building face away from the intended central relationship; the first eight-plot overhead render used an annular moat instead of a crescent. Perspective concept art can also imply dimensions that differ from numeric requirements.
- Recommended future approach: Convert the top-down concept into a dimensioned construction overlay next. Treat the images as visual references and the written 72×72 rule as authoritative. Confirm the eight-player assumption before grayboxing every major footprint.
- Confidence level: High for approved direction; medium for spatial feasibility
- Verification status: Not yet implemented
- Evidence class: User-approved and user-requested original concept art with independent documentation review
