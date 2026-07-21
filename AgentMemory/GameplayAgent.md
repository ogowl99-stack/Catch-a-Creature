# Gameplay Agent Memory

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
