# Gameplay Agent Memory

## 2026-07-21 equip and sale update

- Tasks completed: Added server equip tracking, harvest/assignment auto-equip, exact-equipped single sale, favorite toggle, and atomic unfavorited bulk sale routing
- Strengths demonstrated: Maintained exact UUID/revision authority and no-mutation failures while integrating avatar/UI feedback
- Mistakes made: No final gameplay defect found; actual live mixed bulk sale remains unexercised
- Bugs introduced: None found
- Bugs prevented: Selling owned-but-unequipped items, bulk-selling favorites, stale hotbar references, and presentation surviving item removal
- Review feedback received: Single sale requires equipped item; whole-inventory sale does not; favorites are always protected
- Useful patterns discovered: Session equip is ephemeral authority context while item/favorite state remains durable profile truth
- Areas requiring improvement: Multiplayer races, rate limits, observer replication, devices, and actual multi-item live bulk UX
- Current project knowledge: Farm Domain 40 and Farm Service 6 pass; live exact unequipped/favorite/equipped cases pass
- Unresolved questions: Bulk confirmation threshold and held presentation for non-plant item classes
- Recent evaluation scores: Joint held/selling overall 95
- Next improvement goal: Add two-client equip/store/sell races and live mixed bulk acceptance

- Tasks completed: Defined the core loop and first-playable boundary; received tutorial, capture, disposition, paid-transfer, expanded-map, and future mount contracts
- Strengths demonstrated: Loop closure and progression sequencing
- Mistakes made: No interaction timing, failure behavior, probability balance, or tutorial proof exists
- Bugs introduced: None
- Bugs prevented: Sequencing risk identified before implementation; new capture ownership conflict surfaced before code
- Review feedback received: The loop must be understandable after one guided cycle; correct Care should preserve sanctuary identity if the user approves the hybrid
- Useful patterns discovered: Every launch plant needs an obvious habitat signal; global wild state must be separate from per-player eligibility
- Areas requiring improvement: Moment-to-moment interaction design and measurable acceptance
- Current project knowledge: Core capture state remains unchanged. Future mounts may ride eligible owned creatures and must be faster than normal walking, but require server-owned equip/speed/dismount state and remain outside the smallest playable.
- Unresolved questions: Mount eligibility/speed/controls/camera/animation/restrictions plus prior arrival/Luck, expiry, audio/assets, product, stack, and ordinary travel questions
- Recent evaluation scores: Overall 98 jointly for failure-decision and rare-celebration review
- Next improvement goal: Prototype the capture flow first; later define one bounded mount state machine without client-trusted speed or escape states

## 2026-07-21 service-access update

- Tasks completed: Corrected Shop/Sell fast-travel landings and added nearby service prompts that open panels without movement
- Strengths demonstrated: Separated movement from service access and kept purchases/sales server-authoritative
- Mistakes made: Initial travel targeted kiosk geometry and later used model pivot/cylinder Y assumptions, producing roof-height landings
- Bugs introduced: None remaining
- Bugs prevented: Roof trapping, client-proposed teleport positions, and prompt-triggered automatic transactions
- Review feedback received: Compute landings from trusted geometry, preserve front-facing orientation, and keep prompt access presentation-only
- Useful patterns discovered: Grounded approach points, direct HumanoidRootPart placement, velocity reset, and separate nearby-open versus fast-travel paths
- Areas requiring improvement: Safe-ground raycast/fallback, prompt activation automation, multiplayer collision spacing, and respawn/streaming coverage
- Current project knowledge: Current Shop/Sell approaches are 13 studs from kiosk centers at HRP Y 48, below roof Y 56; prompts use E, ButtonX, click/tap, and 14-stud range
- Recent evaluation scores: Overall 97 jointly for persistence/backpack/service-access follow-up
- Next improvement goal: Add safe-ground fallback and real device/multiplayer service-access tests before final hub art

## 2026-07-21 Hearthpetal/Cozzle update

- Tasks completed: Added the second purchasable/plantable crop and first mature-plant-to-wild-visitor loop
- Strengths demonstrated: Kept the ecological link visible while excluding capture/ownership from the slice
- Mistakes made: First visitor position aligned with the arrival-pad camera and reduced subject readability
- Bugs introduced: None remaining; inward-plus-tangent offset replaced the occluded approach
- Bugs prevented: Visual arrival could not grant ownership, capture, sale, or inventory state
- Review feedback received: Build Observe next as a distinct authoritative encounter step
- Useful patterns discovered: Committed Habitat Flora may drive a bounded derived visitor projection
- Areas requiring improvement: Visitor lifetime, rejoin, Observe/Care state, multiplayer visibility, and accessibility
- Current project knowledge: Earliest plotted Hearthpetal deterministically attracts at most one wild Cozzle three seconds after maturity
- Unresolved questions: Lifetime/expiry, priority start, clue copy, Observe range, and offline arrival semantics
- Recent evaluation scores: Hearthpetal/Cozzle joint score recorded in AgentScores
- Next improvement goal: Implement one no-cost server-authored Observe interaction without creating ownership

## 2026-07-21 seed-foraging update

- Tasks completed: Added server-authoritative seed foraging, stable-node cooldowns, and success-only relocation to a different unused point
- Strengths demonstrated: Reused exact seed stacks and separated reward commit from world/presentation consequences
- Mistakes made: Initially treated a fixed-position cooldown as enough anti-macro friction
- Bugs introduced: None remaining in the verified one-client scope
- Bugs prevented: Client reward selection, rejected-attempt RNG, full-capacity loss, same-location respawn, and cooldown relocation
- Review feedback received: Preserve exploration by moving successful sprouts and make Mythic pulls visually distinct
- Useful patterns discovered: Stable gameplay identity can persist while its world projection relocates
- Areas requiring improvement: Complete rarity content, playtest balance, multiplayer contention, and device input
- Current project knowledge: Six active nodes use 18 points; cooldown is 120 seconds; current eligible seeds are Common Sunspud and Uncommon Hearthpetal
- Unresolved questions: Final spawn cadence, all-tier catalog, regional weighting, discovery clues, and production anti-bot telemetry
- Recent evaluation scores: Joint forage slice Overall 95
- Next improvement goal: Prove a complete all-tier forage catalog and effective distribution before balance is locked

## 2026-07-21 ordered pickup update

- Tasks completed: Routed buying, foraging, harvesting, seed consumption, and inventory reassignment through ordered 1-10 hotbar logic
- Strengths demonstrated: Preserved authoritative item identity and existing player positions while making new acquisitions deterministic
- Mistakes made: Earlier fixed seed reservations were treated as compatible with a general pickup bar
- Bugs introduced: None found in fresh server suites or the live slot-reuse check
- Bugs prevented: Random-looking placement, duplicate references, exhausted seed ghosts, and automatic compaction of player-organized items
- Review feedback received: If slot 1 is occupied, the next pickup belongs in slot 2 unless the player reorganizes it
- Useful patterns discovered: Lowest-free allocation plus no-compaction preservation
- Areas requiring improvement: Creature acquisition integration, full-bar UX, and deliberate destination moves
- Current project knowledge: Seeds and harvested plants now share dynamic slots; future creatures can reuse the same allocator but are not yet implemented
- Unresolved questions: Full-hotbar behavior for creatures and whether acquisition should ever go straight to Backpack
- Recent evaluation scores: Overall 96 for this bounded slice
- Next improvement goal: Apply and test the ordered allocator in the first creature ownership transaction
