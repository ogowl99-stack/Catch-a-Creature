--!strict

local ServerRoot = script.Parent.Parent
local PlantDefinitions = require(ServerRoot.Definitions.PlantDefinitions)
local ProfileSchema = require(ServerRoot.Data.ProfileSchema)
local FarmDomain = require(ServerRoot.Domain.FarmDomain)

local FarmDomainTests = {}

local function expect(condition: boolean, message: string)
	if not condition then
		error(message, 2)
	end
end

function FarmDomainTests.run()
	local passed = {}
	local nextId = 0
	local function generateId()
		nextId += 1
		return string.format("plant-%04d", nextId)
	end
	local function fixedWeight(_definition: any)
		return 1000
	end
	local function backpackSunspud(itemId: string)
		return {
			id = itemId,
			kind = "Plant",
			definitionId = "sunspud",
			definitionVersion = 1,
			revision = 2,
			weightMilli = 1000,
			favorite = false,
			origin = { kind = "PlacedFromSeed", createdAtUnix = 90 },
			location = { kind = "Backpack", harvestedAtUnix = 100 },
		}
	end
	local function plottedSunspud(itemId: string, maturesAtUnix: number)
		return {
			id = itemId,
			kind = "Plant",
			definitionId = "sunspud",
			definitionVersion = 1,
			revision = 1,
			weightMilli = 1000,
			favorite = false,
			origin = { kind = "PlacedFromSeed", createdAtUnix = maturesAtUnix - 45 },
			location = {
				kind = "Plot",
				localXMilli = 2000,
				localZMilli = 2000,
				plantedAtUnix = maturesAtUnix - 45,
				maturesAtUnix = maturesAtUnix,
			},
		}
	end

	local profile = ProfileSchema.new(100)
	expect(profile.leafnotes == 10, "new profile should use experimental starting Leafnotes")
	expect(profile.schemaVersion == 5 and profile.foraging.version == 1, "new profile should include schema-v5 ordered hotbar state")
	table.insert(passed, "new-profile")

	local versionOne = ProfileSchema.new(100)
	versionOne.schemaVersion = 1
	versionOne.seedStacks.hearthpetal = nil
	versionOne.foraging = nil
	versionOne.itemsById["migrate-slot-2"] = {
		id = "migrate-slot-2",
		kind = "Plant",
		definitionId = "sunspud",
		definitionVersion = 1,
		revision = 2,
		weightMilli = 1078,
		favorite = false,
		origin = { kind = "PlacedFromSeed", createdAtUnix = 90 },
		location = { kind = "Backpack", harvestedAtUnix = 100 },
	}
	versionOne.itemsById["migrate-slot-10"] = {
		id = "migrate-slot-10",
		kind = "Plant",
		definitionId = "sunspud",
		definitionVersion = 1,
		revision = 2,
		weightMilli = 950,
		favorite = false,
		origin = { kind = "PlacedFromSeed", createdAtUnix = 90 },
		location = { kind = "Backpack", harvestedAtUnix = 100 },
	}
	versionOne.hotbar = {
		[1] = "seed:sunspud",
		[2] = "migrate-slot-2",
		[10] = "migrate-slot-10",
	}
	local migrated, migrationReason = ProfileSchema.decodeAndMigrate(versionOne, 100)
	expect(migrated ~= nil, "version 1 numeric hotbar should migrate: " .. tostring(migrationReason))
	expect(migrated.schemaVersion == 5, "version 1 profile should migrate through schema version 5")
	expect(migrated.hotbar["1"] == nil and migrated.hotbar["2"] == nil, "migration must release zero-quantity seed slots")
	expect(migrated.hotbar["3"] == "migrate-slot-2" and migrated.hotbar["10"] == "migrate-slot-10", "migration must preserve displaced slot 2 and sparse slot 10 item references")
	expect(migrated.hotbar[2] == nil and migrated.hotbar[10] == nil, "migrated hotbar must not retain numeric keys")
	expect(migrated.seedStacks.hearthpetal.quantity == 0, "migration must add an empty Hearthpetal seed stack")
	local migratedValid = ProfileSchema.validate(migrated)
	expect(migratedValid, "migrated sparse hotbar profile should validate")
	table.insert(passed, "migrate-sparse-hotbar-string-keys")

	local versionTwo = ProfileSchema.clone(versionOne)
	versionTwo.schemaVersion = 2
	versionTwo.hotbar = {
		["1"] = "seed:sunspud",
		["2"] = "migrate-slot-2",
		["10"] = "migrate-slot-10",
	}
	local migratedVersionTwo, versionTwoReason = ProfileSchema.decodeAndMigrate(versionTwo, 100)
	expect(migratedVersionTwo ~= nil, "version 2 profile should migrate: " .. tostring(versionTwoReason))
	expect(migratedVersionTwo.hotbar["2"] == nil and migratedVersionTwo.hotbar["3"] == "migrate-slot-2", "version 2 migration must preserve the displaced item and release the empty seed slot")
	expect(migratedVersionTwo.itemsById["migrate-slot-2"].location.kind == "Backpack", "slot migration must not mutate the displaced item")
	table.insert(passed, "migrate-version-2-hearthpetal-slot")

	local versionThree = ProfileSchema.new(100)
	versionThree.schemaVersion = 3
	versionThree.foraging = nil
	local migratedVersionThree, versionThreeReason = ProfileSchema.decodeAndMigrate(versionThree, 100)
	expect(migratedVersionThree ~= nil, "version 3 profile should migrate: " .. tostring(versionThreeReason))
	expect(migratedVersionThree.schemaVersion == 5 and migratedVersionThree.foraging.version == 1, "version 3 migration must add forage and ordered-hotbar state")
	expect(next(migratedVersionThree.foraging.nextAvailableAtByNodeId) == nil, "version 3 migration should start with no forage cooldowns")
	table.insert(passed, "migrate-version-3-forage-state")

	local fullVersionTwo = ProfileSchema.clone(versionTwo)
	for slotIndex = 3, 9 do
		local blockerId = "legacy-block-" .. slotIndex
		fullVersionTwo.itemsById[blockerId] = backpackSunspud(blockerId)
		fullVersionTwo.hotbar[tostring(slotIndex)] = blockerId
	end
	local migratedFullVersionTwo, fullVersionTwoReason = ProfileSchema.decodeAndMigrate(fullVersionTwo, 100)
	expect(migratedFullVersionTwo ~= nil, "full version 2 hotbar should migrate without item loss: " .. tostring(fullVersionTwoReason))
	expect(migratedFullVersionTwo.hotbar["1"] == nil and migratedFullVersionTwo.hotbar["2"] == nil, "full migration must release zero-quantity seed slots")
	local displacedStillStored = migratedFullVersionTwo.itemsById["migrate-slot-2"]
	expect(displacedStillStored ~= nil and displacedStillStored.location.kind == "Backpack", "a displaced full-hotbar item must remain stored")
	local displacedReferenceCount = 0
	for slotIndex = 3, 10 do
		if migratedFullVersionTwo.hotbar[tostring(slotIndex)] == "migrate-slot-2" then
			displacedReferenceCount += 1
		end
	end
	expect(displacedReferenceCount == 0, "a displaced item may remain safely unassigned when every item slot is occupied")
	table.insert(passed, "migrate-version-2-full-hotbar-no-loss")

	local versionFour = ProfileSchema.new(100)
	versionFour.schemaVersion = 4
	versionFour.hotbar = {
		["1"] = "seed:sunspud",
		["2"] = "seed:hearthpetal",
		["6"] = "migrate-slot-2",
	}
	versionFour.itemsById["migrate-slot-2"] = backpackSunspud("migrate-slot-2")
	local migratedVersionFour, versionFourReason = ProfileSchema.decodeAndMigrate(versionFour, 100)
	expect(migratedVersionFour ~= nil, "version 4 profile should migrate: " .. tostring(versionFourReason))
	expect(migratedVersionFour.hotbar["1"] == nil and migratedVersionFour.hotbar["2"] == nil, "version 4 migration should remove empty seed reservations")
	expect(migratedVersionFour.hotbar["6"] == "migrate-slot-2", "version 4 migration must preserve an existing manual item slot")
	table.insert(passed, "migrate-version-4-ordered-hotbar")

	local invalidLegacySlot = ProfileSchema.clone(versionOne)
	invalidLegacySlot.hotbar[11] = "migrate-slot-2"
	local invalidSlotMigration = ProfileSchema.decodeAndMigrate(invalidLegacySlot, 100)
	expect(invalidSlotMigration == nil, "migration must reject an out-of-range legacy hotbar slot")
	table.insert(passed, "migration-rejects-invalid-legacy-slot")

	local duplicateLegacyReference = ProfileSchema.clone(versionOne)
	duplicateLegacyReference.hotbar[10] = "migrate-slot-2"
	local duplicateReferenceMigration = ProfileSchema.decodeAndMigrate(duplicateLegacyReference, 100)
	expect(duplicateReferenceMigration == nil, "migration must reject duplicate legacy item references")
	table.insert(passed, "migration-rejects-duplicate-legacy-item")

	local malformedLegacyKey = ProfileSchema.clone(versionOne)
	malformedLegacyKey.hotbar[{}] = "migrate-slot-2"
	local malformedKeyMigration, malformedKeyReason = ProfileSchema.decodeAndMigrate(malformedLegacyKey, 100)
	expect(malformedKeyMigration == nil and type(malformedKeyReason) == "string", "migration must return a reason instead of throwing for a malformed key type")
	table.insert(passed, "migration-rejects-malformed-key-type")

	local foraged, forageResult = FarmDomain.apply(ProfileSchema.new(100), {
		requestId = "forage-west-a-0001",
		expectedProfileRevision = 0,
		action = "ForageSeed",
		nodeId = "wild-sprout-1",
		definitionId = "sunspud",
	}, 100, generateId, fixedWeight)
	expect(foraged ~= nil and forageResult.ok, "foraging an available node should succeed")
	expect(foraged.leafnotes == 10 and foraged.seedStacks.sunspud.quantity == 1, "foraging should add exactly one seed without charging Leafnotes")
	expect(forageResult.rarity == "Common" and forageResult.nextAvailableAtUnix == 220, "foraging should return the server rarity and saved cooldown")
	local foragedValid, foragedReason = ProfileSchema.validate(foraged)
	expect(foragedValid, "foraged profile should validate: " .. tostring(foragedReason))
	table.insert(passed, "forage-seed-atomic-grant")

	local forageReplayCandidate, forageReplayResult = FarmDomain.apply(foraged, {
		requestId = "forage-west-a-0001",
		expectedProfileRevision = 0,
		action = "ForageSeed",
		nodeId = "wild-sprout-1",
		definitionId = "sunspud",
	}, 101, generateId, fixedWeight)
	expect(forageReplayCandidate == nil and forageReplayResult.replay == true and forageReplayResult.definitionId == "sunspud", "forage replay should return the original reward without adding another seed")
	table.insert(passed, "forage-replay")

	local cooldownCandidate, cooldownResult = FarmDomain.apply(foraged, {
		requestId = "forage-west-a-0002",
		expectedProfileRevision = 1,
		action = "ForageSeed",
		nodeId = "wild-sprout-1",
		definitionId = "sunspud",
	}, 150, generateId, fixedWeight)
	expect(cooldownCandidate == nil and cooldownResult.code == "FORAGE_COOLDOWN" and cooldownResult.retryAfterSeconds == 70, "same forage node should reject before its saved cooldown expires")
	expect(foraged.seedStacks.sunspud.quantity == 1, "cooldown rejection must not add a seed")
	table.insert(passed, "forage-saved-cooldown")

	local secondNodeCandidate, secondNodeResult = FarmDomain.apply(foraged, {
		requestId = "forage-west-b-0001",
		expectedProfileRevision = 1,
		action = "ForageSeed",
		nodeId = "wild-sprout-2",
		definitionId = "hearthpetal",
	}, 150, generateId, fixedWeight)
	expect(secondNodeCandidate ~= nil and secondNodeResult.rarity == "Uncommon", "a different node should independently grant an eligible seed")
	expect(secondNodeCandidate.seedStacks.hearthpetal.quantity == 1, "second node should add exactly one Hearthpetal seed")
	table.insert(passed, "forage-node-independent")

	local invalidForageCandidate, invalidForageResult = FarmDomain.apply(ProfileSchema.new(100), {
		requestId = "forage-invalid-node-0001",
		expectedProfileRevision = 0,
		action = "ForageSeed",
		nodeId = "not-a-node",
		definitionId = "sunspud",
	}, 100, generateId, fixedWeight)
	expect(invalidForageCandidate == nil and invalidForageResult.code == "INVALID_REQUEST", "unknown forage nodes must fail closed")
	table.insert(passed, "forage-rejects-unknown-node")

	local fullForageProfile = ProfileSchema.new(100)
	for index = 1, PlantDefinitions.baseBackpackCapacity do
		fullForageProfile.itemsById["forage-full-" .. index] = {
			location = { kind = "Backpack" },
		}
	end
	local fullForageCandidate, fullForageResult = FarmDomain.apply(fullForageProfile, {
		requestId = "forage-full-backpack-0001",
		expectedProfileRevision = 0,
		action = "ForageSeed",
		nodeId = "wild-sprout-1",
		definitionId = "sunspud",
	}, 100, generateId, fixedWeight)
	expect(fullForageCandidate == nil and fullForageResult.code == "BACKPACK_FULL", "foraging must not roll in a new seed stack when Backpack is full")
	expect(fullForageProfile.foraging.nextAvailableAtByNodeId["wild-sprout-1"] == nil, "failed full-Backpack forage must not start cooldown")
	table.insert(passed, "forage-full-backpack-no-cooldown")

	local buyCommand = {
		requestId = "buy-0001",
		expectedProfileRevision = 0,
		action = "BuySeed",
	}
	local bought, buyResult = FarmDomain.apply(profile, buyCommand, 100, generateId, fixedWeight)
	expect(bought ~= nil and buyResult.ok, "buy should succeed")
	expect(bought.leafnotes == 5 and bought.seedStacks.sunspud.quantity == 1, "buy should charge once and add one seed")
	expect(bought.hotbar["1"] == "seed:sunspud" and buyResult.hotbarSlot == 1, "first acquired seed should use hotbar slot 1")
	table.insert(passed, "buy")

	local replayed, replayResult = FarmDomain.apply(bought, buyCommand, 101, generateId, fixedWeight)
	expect(replayed == nil and replayResult.replay == true and replayResult.profileRevision == 1, "same request should replay")
	table.insert(passed, "buy-replay")

	local hearthpetalProfile = ProfileSchema.new(100)
	local hearthpetalBought, hearthpetalBuyResult = FarmDomain.apply(hearthpetalProfile, {
		requestId = "buy-hearthpetal-0001",
		expectedProfileRevision = 0,
		action = "BuySeed",
		definitionId = "hearthpetal",
	}, 100, generateId, fixedWeight)
	expect(hearthpetalBought ~= nil and hearthpetalBuyResult.definitionId == "hearthpetal", "Hearthpetal purchase should use the requested server definition")
	expect(hearthpetalBought.leafnotes == 2 and hearthpetalBought.seedStacks.hearthpetal.quantity == 1, "Hearthpetal purchase should charge eight experimental Leafnotes")
	local hearthpetalPlanted, hearthpetalPlaceResult = FarmDomain.apply(hearthpetalBought, {
		requestId = "place-hearthpetal-0001",
		expectedProfileRevision = 1,
		action = "PlaceSeed",
		definitionId = "hearthpetal",
		localXMilli = 1000,
		localZMilli = 1000,
	}, 102, generateId, fixedWeight)
	expect(hearthpetalPlanted ~= nil and hearthpetalPlaceResult.definitionId == "hearthpetal", "Hearthpetal placement should succeed")
	local hearthpetalItem = hearthpetalPlanted.itemsById[hearthpetalPlaceResult.itemId]
	expect(hearthpetalItem.definitionId == "hearthpetal" and hearthpetalItem.location.maturesAtUnix == 162, "Hearthpetal should persist its definition and 60-second maturity")
	local mixedValid, mixedReason = ProfileSchema.validate(hearthpetalPlanted)
	expect(mixedValid, "Hearthpetal profile should validate: " .. tostring(mixedReason))
	local hearthpetalHarvested, hearthpetalHarvestResult = FarmDomain.apply(hearthpetalPlanted, {
		requestId = "harvest-hearthpetal-0001",
		expectedProfileRevision = 2,
		action = "HarvestPlant",
		itemId = hearthpetalPlaceResult.itemId,
		expectedItemRevision = 1,
	}, 162, generateId, fixedWeight)
	expect(hearthpetalHarvested ~= nil and hearthpetalHarvestResult.definitionId == "hearthpetal", "mature Hearthpetal should harvest as the same definition")
	expect(hearthpetalHarvested.hotbar["1"] == hearthpetalPlaceResult.itemId and hearthpetalHarvestResult.hotbarSlot == 1, "Hearthpetal harvest should use the lowest visible open slot")
	local hearthpetalSold, hearthpetalSellResult = FarmDomain.apply(hearthpetalHarvested, {
		requestId = "sell-hearthpetal-0001",
		expectedProfileRevision = 3,
		action = "SellItem",
		itemId = hearthpetalPlaceResult.itemId,
		expectedItemRevision = 2,
	}, 163, generateId, fixedWeight)
	expect(hearthpetalSold ~= nil and hearthpetalSellResult.leafnoteDelta == 14 and hearthpetalSold.leafnotes == 16, "Hearthpetal sale should use its own experimental value")
	table.insert(passed, "hearthpetal-buy-place-persistence")

	local invalidDefinitionCandidate, invalidDefinitionResult = FarmDomain.apply(ProfileSchema.new(100), {
		requestId = "buy-invalid-definition-0001",
		expectedProfileRevision = 0,
		action = "BuySeed",
		definitionId = "not-a-plant",
	}, 100, generateId, fixedWeight)
	expect(invalidDefinitionCandidate == nil and invalidDefinitionResult.code == "INVALID_REQUEST", "unknown plant definitions must fail closed")
	table.insert(passed, "rejects-unknown-plant-definition")

	local placeCommand = {
		requestId = "place-0001",
		expectedProfileRevision = 1,
		action = "PlaceSeed",
		localXMilli = 0,
		localZMilli = 0,
	}
	local planted, placeResult = FarmDomain.apply(bought, placeCommand, 102, generateId, fixedWeight)
	expect(planted ~= nil and placeResult.ok and planted.seedStacks.sunspud.quantity == 0, "place should consume one seed")
	expect(planted.hotbar["1"] == nil, "using the last seed should release its hotbar slot")
	local itemId = placeResult.itemId
	expect(planted.itemsById[itemId].location.maturesAtUnix == 147, "Sunspud should mature exactly 45 seconds after placement")
	table.insert(passed, "place")

	local persisted = ProfileSchema.clone(planted)
	persisted.leafnotes = 100_000
	local persistedValid = ProfileSchema.validate(persisted)
	expect(persistedValid, "profile with 100,000 Leafnotes and a planted Sunspud should validate")
	local reloaded = ProfileSchema.clone(persisted)
	expect(reloaded.leafnotes == 100_000, "Leafnotes must survive a profile round trip")
	expect(reloaded.itemsById[itemId].location.localXMilli == 0 and reloaded.itemsById[itemId].location.maturesAtUnix == 147, "planted identity, position, and maturity time must survive a profile round trip")
	table.insert(passed, "persistence-round-trip")

	local invalidHotbar = ProfileSchema.clone(reloaded)
	invalidHotbar.hotbar["3"] = "missing-item"
	local hotbarValid = ProfileSchema.validate(invalidHotbar)
	expect(not hotbarValid, "a saved hotbar must not reference a missing item")
	table.insert(passed, "schema-rejects-missing-hotbar-item")

	local invalidClock = ProfileSchema.clone(reloaded)
	invalidClock.itemsById[itemId].location.maturesAtUnix = 99
	local clockValid = ProfileSchema.validate(invalidClock)
	expect(not clockValid, "a saved plant must not mature before it was planted")
	table.insert(passed, "schema-rejects-backward-growth-clock")

	local earlyHarvest = {
		requestId = "harvest-early-0001",
		expectedProfileRevision = 2,
		action = "HarvestPlant",
		itemId = itemId,
		expectedItemRevision = 1,
	}
	local earlyCandidate, earlyResult = FarmDomain.apply(planted, earlyHarvest, 146, generateId, fixedWeight)
	expect(earlyCandidate == nil and earlyResult.code == "NOT_MATURE", "44-second harvest should fail without mutation")
	table.insert(passed, "growth-boundary-44")

	local harvest = {
		requestId = "harvest-0001",
		expectedProfileRevision = 2,
		action = "HarvestPlant",
		itemId = itemId,
		expectedItemRevision = 1,
	}
	local harvested, harvestResult = FarmDomain.apply(planted, harvest, 147, generateId, fixedWeight)
	expect(harvested ~= nil and harvestResult.ok, "45-second harvest should succeed")
	expect(harvested.itemsById[itemId].location.kind == "Backpack", "harvest must move the same identity into the Backpack")
	expect(harvested.hotbar["1"] == itemId and harvestResult.hotbarSlot == 1, "harvest should persist the exact item in the lowest open slot")
	table.insert(passed, "growth-boundary-45")

	local secondPickupProfile = ProfileSchema.clone(harvested)
	secondPickupProfile.itemsById["second-pickup"] = plottedSunspud("second-pickup", 147)
	local secondPickup, secondPickupResult = FarmDomain.apply(secondPickupProfile, {
		requestId = "harvest-second-pickup-0001",
		expectedProfileRevision = 3,
		action = "HarvestPlant",
		itemId = "second-pickup",
		expectedItemRevision = 1,
	}, 147, generateId, fixedWeight)
	expect(secondPickup ~= nil and secondPickupResult.hotbarSlot == 2, "a second pickup should use slot 2 when slot 1 is occupied")
	expect(secondPickup.hotbar["1"] == itemId and secondPickup.hotbar["2"] == "second-pickup", "sequential pickup must preserve slot 1 and append into slot 2")
	table.insert(passed, "pickup-fills-next-numeric-slot")

	local manualSlotProfile = ProfileSchema.clone(harvested)
	manualSlotProfile.hotbar["1"] = nil
	manualSlotProfile.hotbar["6"] = itemId
	manualSlotProfile.itemsById["after-manual-move"] = plottedSunspud("after-manual-move", 147)
	local afterManualMove, afterManualMoveResult = FarmDomain.apply(manualSlotProfile, {
		requestId = "harvest-after-manual-0001",
		expectedProfileRevision = 3,
		action = "HarvestPlant",
		itemId = "after-manual-move",
		expectedItemRevision = 1,
	}, 147, generateId, fixedWeight)
	expect(afterManualMove ~= nil and afterManualMoveResult.hotbarSlot == 1, "a pickup after a manual move should use the lowest newly open slot")
	expect(afterManualMove.hotbar["6"] == itemId and afterManualMove.hotbar["1"] == "after-manual-move", "new pickups must not move an existing manual assignment")
	table.insert(passed, "pickup-preserves-manual-slot")

	local unassignCommand = {
		requestId = "unassign-slot-0001",
		expectedProfileRevision = 3,
		action = "UnassignHotbarSlot",
		slotIndex = 1,
	}
	local unassigned, unassignResult = FarmDomain.apply(harvested, unassignCommand, 148, generateId, fixedWeight)
	expect(unassigned ~= nil and unassignResult.ok and unassignResult.hotbarSlot == 1, "right-click storage should clear one hotbar slot")
	expect(unassigned.hotbar["1"] == nil, "unassigned item must leave hotbar slot 1")
	expect(unassigned.itemsById[itemId] ~= nil and unassigned.itemsById[itemId].location.kind == "Backpack", "unassigned item must remain exactly once in Backpack")
	table.insert(passed, "unassign-hotbar-keeps-item")

	local slotTenProfile = ProfileSchema.clone(harvested)
	slotTenProfile.hotbar["1"] = nil
	slotTenProfile.hotbar["10"] = itemId
	local slotTenCommand = {
		requestId = "unassign-slot-0010",
		expectedProfileRevision = 3,
		action = "UnassignHotbarSlot",
		slotIndex = 10,
	}
	local slotTenUnassigned, slotTenResult = FarmDomain.apply(slotTenProfile, slotTenCommand, 148, generateId, fixedWeight)
	expect(slotTenUnassigned ~= nil and slotTenResult.hotbarSlot == 10 and slotTenUnassigned.hotbar["10"] == nil, "slot 10 should unassign without losing its item")
	expect(slotTenUnassigned.itemsById[itemId] ~= nil, "slot 10 unassign must preserve exact item identity")
	table.insert(passed, "unassign-hotbar-slot-10")

	local replayedUnassign, replayedUnassignResult = FarmDomain.apply(unassigned, unassignCommand, 149, generateId, fixedWeight)
	expect(replayedUnassign == nil and replayedUnassignResult.replay == true and replayedUnassignResult.profileRevision == 4, "unassign replay should not increment twice")
	table.insert(passed, "unassign-hotbar-replay")

	local noChangeUnassign = {
		requestId = "unassign-empty-0001",
		expectedProfileRevision = 4,
		action = "UnassignHotbarSlot",
		slotIndex = 1,
	}
	local noChangeCandidate, noChangeResult = FarmDomain.apply(unassigned, noChangeUnassign, 150, generateId, fixedWeight)
	expect(noChangeCandidate == nil and noChangeResult.code == "NO_CHANGE" and unassigned.profileRevision == 4, "empty-slot unassign must not mutate revision")
	table.insert(passed, "unassign-empty-no-change")

	local seedProtectedProfile = ProfileSchema.new(100)
	seedProtectedProfile.seedStacks.sunspud.quantity = 1
	seedProtectedProfile.hotbar["2"] = "seed:sunspud"
	local protectedSeedUnassign = {
		requestId = "unassign-seed-0001",
		expectedProfileRevision = 0,
		action = "UnassignHotbarSlot",
		slotIndex = 2,
	}
	local protectedSeedCandidate, protectedSeedResult = FarmDomain.apply(seedProtectedProfile, protectedSeedUnassign, 150, generateId, fixedWeight)
	expect(protectedSeedCandidate == nil and protectedSeedResult.code == "ITEM_STATE_INVALID", "item-storage action must reject a seed stack reference")
	table.insert(passed, "unassign-protects-seed-slot")

	local assignCommand = {
		requestId = "assign-item-0001",
		expectedProfileRevision = 4,
		action = "AssignHotbarItem",
		itemId = itemId,
		expectedItemRevision = 2,
	}
	local assignedAgain, assignResult = FarmDomain.apply(unassigned, assignCommand, 151, generateId, fixedWeight)
	expect(assignedAgain ~= nil and assignResult.ok and assignResult.hotbarSlot == 1, "stored inventory item should use the first free hotbar slot")
	expect(assignedAgain.hotbar["1"] == itemId, "assigned inventory item must reference the exact item")
	expect(assignedAgain.itemsById[itemId].revision == 2 and assignedAgain.itemsById[itemId].location.kind == "Backpack", "hotbar assignment must not mutate item revision or location")
	table.insert(passed, "assign-stored-item-first-free-slot")

	local replayedAssign, replayedAssignResult = FarmDomain.apply(assignedAgain, assignCommand, 152, generateId, fixedWeight)
	expect(replayedAssign == nil and replayedAssignResult.replay == true and replayedAssignResult.hotbarSlot == 1, "assign replay should return the same slot without a second mutation")
	table.insert(passed, "assign-hotbar-replay")

	local alreadyAssignedCommand = {
		requestId = "assign-existing-0001",
		expectedProfileRevision = 5,
		action = "AssignHotbarItem",
		itemId = itemId,
		expectedItemRevision = 2,
	}
	local alreadyAssignedCandidate, alreadyAssignedResult = FarmDomain.apply(assignedAgain, alreadyAssignedCommand, 153, generateId, fixedWeight)
	expect(alreadyAssignedCandidate == nil and alreadyAssignedResult.code == "NO_CHANGE" and assignedAgain.profileRevision == 5, "assigning an already-slotted item must not increment revision")
	table.insert(passed, "assign-existing-no-change")

	local middleGapProfile = ProfileSchema.clone(unassigned)
	middleGapProfile.itemsById["block-slot-1"] = backpackSunspud("block-slot-1")
	middleGapProfile.hotbar["1"] = "block-slot-1"
	local middleGapAssigned, middleGapResult = FarmDomain.apply(middleGapProfile, {
		requestId = "assign-middle-gap-0001",
		expectedProfileRevision = 4,
		action = "AssignHotbarItem",
		itemId = itemId,
		expectedItemRevision = 2,
	}, 154, generateId, fixedWeight)
	expect(middleGapAssigned ~= nil and middleGapResult.hotbarSlot == 2 and middleGapAssigned.hotbar["2"] == itemId, "assignment should select the lowest numeric middle gap")
	table.insert(passed, "assign-stored-item-middle-gap")

	local fullHotbarProfile = ProfileSchema.clone(unassigned)
	for slotIndex = 1, 10 do
		local blockerId = "block-slot-" .. slotIndex
		fullHotbarProfile.itemsById[blockerId] = backpackSunspud(blockerId)
		fullHotbarProfile.hotbar[tostring(slotIndex)] = blockerId
	end
	local fullHotbarCandidate, fullHotbarResult = FarmDomain.apply(fullHotbarProfile, {
		requestId = "assign-full-hotbar-0001",
		expectedProfileRevision = 4,
		action = "AssignHotbarItem",
		itemId = itemId,
		expectedItemRevision = 2,
	}, 155, generateId, fixedWeight)
	expect(fullHotbarCandidate == nil and fullHotbarResult.code == "HOTBAR_FULL" and fullHotbarProfile.profileRevision == 4, "full item hotbar should fail without mutation")
	expect(fullHotbarProfile.itemsById[itemId].location.kind == "Backpack", "full hotbar must preserve the exact stored item")
	table.insert(passed, "assign-stored-item-hotbar-full")

	local offlineHarvest = {
		requestId = "harvest-offline-0001",
		expectedProfileRevision = 2,
		action = "HarvestPlant",
		itemId = itemId,
		expectedItemRevision = 1,
	}
	local offlineCandidate, offlineResult = FarmDomain.apply(ProfileSchema.clone(planted), offlineHarvest, 10_000, generateId, fixedWeight)
	expect(offlineCandidate ~= nil and offlineResult.ok, "a saved plant should be mature after a long offline interval")
	expect(offlineCandidate.itemsById[itemId].weightMilli == 1000 and offlineCandidate.hotbar["1"] == itemId, "offline growth must preserve identity and weight and restore the saved hotbar")
	table.insert(passed, "offline-growth-long-absence")

	local sell = {
		requestId = "sell-0001",
		expectedProfileRevision = 3,
		action = "SellItem",
		itemId = itemId,
		expectedItemRevision = 2,
	}
	local sold, sellResult = FarmDomain.apply(harvested, sell, 148, generateId, fixedWeight)
	expect(sold ~= nil and sellResult.ok and sold.itemsById[itemId] == nil, "sale should remove one exact item")
	expect(sold.leafnotes == 13 and sold.tutorial.step == "Complete", "sale should fund a replacement seed plus margin")
	expect(sold.hotbar["1"] == nil, "sale should clear the saved hotbar reference")
	table.insert(passed, "sell")

	local favoriteCandidate, favoriteResult = FarmDomain.apply(ProfileSchema.clone(harvested), {
		requestId = "favorite-toggle-0001",
		expectedProfileRevision = 3,
		action = "ToggleFavoriteItem",
		itemId = itemId,
		expectedItemRevision = 2,
	}, 149, generateId, fixedWeight)
	expect(favoriteCandidate ~= nil and favoriteResult.favorite == true, "favorite toggle should mark the exact Backpack item")
	expect(favoriteCandidate.itemsById[itemId].revision == 3, "favorite toggle should advance the exact item revision")
	table.insert(passed, "toggle-favorite-item")

	local favoriteOnlyCandidate, favoriteOnlyResult = FarmDomain.apply(ProfileSchema.clone(favoriteCandidate), {
		requestId = "sell-all-favorite-only-0001",
		expectedProfileRevision = 4,
		action = "SellAllUnfavorited",
	}, 150, generateId, fixedWeight)
	expect(favoriteOnlyCandidate == nil and favoriteOnlyResult.code == "NO_SELLABLE_ITEMS", "bulk sale should reject when every Backpack item is favorited")
	expect(favoriteCandidate.itemsById[itemId] ~= nil, "favorite-only bulk rejection must preserve the exact item")
	table.insert(passed, "sell-all-favorite-only-no-op")

	local bulkProfile = ProfileSchema.clone(favoriteCandidate)
	local bulkItemId = "bulk-unfavorited"
	bulkProfile.itemsById[bulkItemId] = backpackSunspud(bulkItemId)
	bulkProfile.hotbar["4"] = bulkItemId
	local bulkCandidate, bulkResult = FarmDomain.apply(bulkProfile, {
		requestId = "sell-all-unfavorited-0001",
		expectedProfileRevision = 4,
		action = "SellAllUnfavorited",
	}, 151, generateId, fixedWeight)
	expect(bulkCandidate ~= nil and bulkResult.soldCount == 1 and bulkResult.leafnoteDelta == 8, "bulk sale should sell every and only unfavorited Backpack item")
	expect(bulkCandidate.itemsById[itemId] ~= nil and bulkCandidate.itemsById[itemId].favorite == true, "bulk sale must preserve favorited items")
	expect(bulkCandidate.itemsById[bulkItemId] == nil and bulkCandidate.hotbar["4"] == nil, "bulk sale should remove the sold exact item and its hotbar reference")
	local replayedBulk, replayedBulkResult = FarmDomain.apply(bulkCandidate, {
		requestId = "sell-all-unfavorited-0001",
		expectedProfileRevision = 4,
		action = "SellAllUnfavorited",
	}, 152, generateId, fixedWeight)
	expect(replayedBulk == nil and replayedBulkResult.replay == true and replayedBulkResult.soldCount == 1, "bulk sale replay should return the recorded result without selling again")
	table.insert(passed, "sell-all-unfavorited-favorite-safe")

	local full = ProfileSchema.new(200)
	for index = 1, PlantDefinitions.baseBackpackCapacity do
		local fullId = string.format("full-%03d", index)
		full.itemsById[fullId] = {
			id = fullId,
			revision = 1,
			location = { kind = "Backpack" },
		}
	end
	full.itemsById["mature-plant"] = {
		id = "mature-plant",
		revision = 1,
		weightMilli = 1000,
		location = { kind = "Plot", maturesAtUnix = 200 },
	}
	local fullHarvest = {
		requestId = "harvest-full-0001",
		expectedProfileRevision = 0,
		action = "HarvestPlant",
		itemId = "mature-plant",
		expectedItemRevision = 1,
	}
	local fullCandidate, fullResult = FarmDomain.apply(full, fullHarvest, 200, generateId, fixedWeight)
	expect(fullCandidate == nil and fullResult.code == "BACKPACK_FULL", "full Backpack must leave the mature plant unchanged")
	expect(full.itemsById["mature-plant"].location.kind == "Plot", "full harvest must preserve the exact plant")
	table.insert(passed, "full-backpack-no-loss")

	return {
		ok = true,
		passed = #passed,
		cases = passed,
	}
end

return table.freeze(FarmDomainTests)
