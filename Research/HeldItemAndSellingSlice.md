# Held Item and Favorite-Safe Selling Slice

- Date: 2026-07-21
- Agent: Codex / Gameplay, UI, Data, Security, and QA roles
- Status: Implemented
- Truth label: Verified
- Verification scope: One-client desktop Studio memory mode plus deterministic server tests

## Player behavior

- Clicking a hotbar slot or pressing its number equips that exact slot.
- Supported seeds and harvested plants appear in the local R15 character's outstretched right hand.
- Harvesting auto-equips the exact new item, including its saved item ID, name, and weight.
- Right-clicking a hotbar item stores it; right-clicking a stored inventory item assigns it back to the hotbar and equips it.
- Inventory cards can toggle favorite state.
- `SELL EQUIPPED` sells only the exact server-tracked equipped item.
- `SELL ALL UNFAVORITED` scans the whole Backpack without requiring an equipped item and always skips favorites.

## Authority and persistence

- Equip state is server validated and intentionally session-only.
- Item identity, item revision, location, hotbar reference, favorite flag, weight, and Leafnotes remain profile state.
- A client cannot sell an owned-but-unequipped item through the single-sale command.
- Bulk sale is atomic in the domain, clears sold hotbar references, and returns `NO_SELLABLE_ITEMS` without mutation when only favorites remain.

## Evidence

- Fresh server suites: Farm Domain 40, Farm Service 6, Creature World 5, Forage World 7; total 58 passed.
- Live harvested Sunspud: exact item ID auto-equipped in slot 3 at weight 1.12.
- Live stored-card round trip preserved identity and restored the held model.
- Live favorite-only bulk request returned `NO_SELLABLE_ITEMS` with the item and profile revision unchanged.
- Live unfavorited equipped Sunspud sold for the expected Leafnotes and cleared the held model/equip state.
- Direct unequipped single-sale request returned `ITEM_NOT_EQUIPPED` without mutation.

## Limitations

- The held model is client-local, so other players do not yet see it.
- The arm presentation currently targets R15 and the two implemented plant definitions.
- Real touch/controller interaction, other avatar proportions, multiplayer observation, and production persistence scale remain untested.
- Actual live bulk sale of multiple unfavorited items was not performed; its atomic behavior is deterministic-test evidence.
