--!strict

local ServerRoot = script.Parent.Parent
local ForageDefinitions = require(ServerRoot.Definitions.ForageDefinitions)
local PlantDefinitions = require(ServerRoot.Definitions.PlantDefinitions)

local ProfileSchema = {}

local CURRENT_SCHEMA_VERSION = 5
local FORAGING_SCHEMA_VERSION = 4
local HEARTHPETAL_SCHEMA_VERSION = 3
local MAX_LEAFNOTES = 2_000_000_000
local MAX_LOCAL_MILLI = 1_000_000
local MAX_TIMESTAMP = 1_000_000_000_000
local SEED_REFERENCE_PREFIX = "seed:"

local TUTORIAL_STEPS = {
	Buy = true,
	Place = true,
	Grow = true,
	Sell = true,
	Complete = true,
}

local function integerInRange(value: any, minimum: number, maximum: number): boolean
	return type(value) == "number"
		and value == value
		and math.abs(value) < math.huge
		and value % 1 == 0
		and value >= minimum
		and value <= maximum
end

local function optionalIntegerInRange(value: any, minimum: number, maximum: number): boolean
	return value == nil or integerInRange(value, minimum, maximum)
end

local function boundedString(value: any, maximumLength: number): boolean
	return type(value) == "string" and #value > 0 and #value <= maximumLength
end

local function deepCopy(value: any): any
	if type(value) ~= "table" then
		return value
	end

	local result = {}
	for key, child in value do
		result[deepCopy(key)] = deepCopy(child)
	end
	return result
end

local function seedDefinitionIdFromReference(reference: string): string?
	if string.sub(reference, 1, #SEED_REFERENCE_PREFIX) ~= SEED_REFERENCE_PREFIX then
		return nil
	end
	local definitionId = string.sub(reference, #SEED_REFERENCE_PREFIX + 1)
	return if definitionId ~= "" then definitionId else nil
end

function ProfileSchema.new(nowUnix: number)
	return {
		schemaVersion = CURRENT_SCHEMA_VERSION,
		profileRevision = 0,
		leafnotes = PlantDefinitions.startingLeafnotes,
		seedStacks = {
			sunspud = {
				quantity = 0,
				revision = 0,
			},
			hearthpetal = {
				quantity = 0,
				revision = 0,
			},
		},
		itemsById = {},
		hotbar = {},
		foraging = {
			version = 1,
			nextAvailableAtByNodeId = {},
		},
		tutorial = {
			version = 1,
			step = "Buy",
			cycleItemId = nil,
			completedAtUnix = nil,
		},
		recentCommands = {
			order = {},
			byId = {},
		},
		meta = {
			createdAtUnix = nowUnix,
			updatedAtUnix = nowUnix,
			activeSessionId = nil,
			leaseExpiresAtUnix = nil,
		},
	}
end

function ProfileSchema.clone(profile: any)
	return deepCopy(profile)
end

function ProfileSchema.validate(profile: any): (boolean, string?)
	if type(profile) ~= "table" then
		return false, "profile must be a table"
	end
	if profile.schemaVersion ~= CURRENT_SCHEMA_VERSION then
		return false, "unsupported schema version"
	end
	if not integerInRange(profile.profileRevision, 0, 2_000_000_000) then
		return false, "invalid profile revision"
	end
	if not integerInRange(profile.leafnotes, 0, MAX_LEAFNOTES) then
		return false, "invalid leafnotes"
	end
	if type(profile.seedStacks) ~= "table" then
		return false, "missing seed stacks"
	end
	local seedStackCount = 0
	for definitionId, seedStack in profile.seedStacks do
		seedStackCount += 1
		local definition = PlantDefinitions.byId[definitionId]
		if definition == nil or type(seedStack) ~= "table" then
			return false, "invalid seed stack definition"
		end
		if not integerInRange(seedStack.quantity, 0, definition.maxSeedStack) then
			return false, "invalid seed quantity"
		end
		if not integerInRange(seedStack.revision, 0, 2_000_000_000) then
			return false, "invalid seed revision"
		end
	end
	if seedStackCount ~= #PlantDefinitions.ordered then
		return false, "missing seed stack"
	end
	if type(profile.itemsById) ~= "table" then
		return false, "invalid items table"
	end
	local itemCount = 0
	local backpackCount = 0
	local plotCount = 0
	for itemId, item in profile.itemsById do
		itemCount += 1
		if itemCount > PlantDefinitions.baseBackpackCapacity + PlantDefinitions.maxDeployedPlantsPerPlayer then
			return false, "too many item records"
		end
		if not boundedString(itemId, 128) or type(item) ~= "table" or item.id ~= itemId then
			return false, "invalid item identity"
		end
		local definition = PlantDefinitions.byId[item.definitionId]
		if item.kind ~= "Plant" or definition == nil or item.definitionVersion ~= definition.version then
			return false, "invalid item definition"
		end
		if not integerInRange(item.revision, 1, 2_000_000_000) then
			return false, "invalid item revision"
		end
		if not integerInRange(item.weightMilli, definition.weightMinMilli, definition.weightMaxMilli) then
			return false, "invalid item weight"
		end
		if type(item.favorite) ~= "boolean" then
			return false, "invalid favorite state"
		end
		if type(item.origin) ~= "table" or item.origin.kind ~= "PlacedFromSeed" or not integerInRange(item.origin.createdAtUnix, 0, MAX_TIMESTAMP) then
			return false, "invalid item origin"
		end
		local location = item.location
		if type(location) ~= "table" then
			return false, "missing item location"
		elseif location.kind == "Plot" then
			plotCount += 1
			if plotCount > PlantDefinitions.maxDeployedPlantsPerPlayer then
				return false, "too many deployed plants"
			end
			if not integerInRange(location.localXMilli, -MAX_LOCAL_MILLI, MAX_LOCAL_MILLI)
				or not integerInRange(location.localZMilli, -MAX_LOCAL_MILLI, MAX_LOCAL_MILLI)
				or not integerInRange(location.plantedAtUnix, 0, MAX_TIMESTAMP)
				or not integerInRange(location.maturesAtUnix, location.plantedAtUnix, MAX_TIMESTAMP)
			then
				return false, "invalid plotted plant state"
			end
		elseif location.kind == "Backpack" then
			backpackCount += 1
			if backpackCount > PlantDefinitions.baseBackpackCapacity or not integerInRange(location.harvestedAtUnix, 0, MAX_TIMESTAMP) then
				return false, "invalid backpack item state"
			end
		else
			return false, "invalid item location kind"
		end
	end
	if type(profile.hotbar) ~= "table" then
		return false, "invalid hotbar"
	end
	local seenHotbarReferences = {}
	local seenHotbarSeeds = {}
	for slotKey, reference in profile.hotbar do
		local slot = if type(slotKey) == "string" then tonumber(slotKey) else nil
		if slot == nil or tostring(slot) ~= slotKey or not integerInRange(slot, 1, 10) or not boundedString(reference, 160) then
			return false, "invalid hotbar reference"
		end
		if seenHotbarReferences[reference] then
			return false, "duplicate hotbar reference"
		end
		seenHotbarReferences[reference] = true
		local seedDefinitionId = seedDefinitionIdFromReference(reference)
		if seedDefinitionId ~= nil then
			local definition = PlantDefinitions.byId[seedDefinitionId]
			local stack = profile.seedStacks[seedDefinitionId]
			if definition == nil or stack == nil or stack.quantity <= 0 then
				return false, "invalid seed hotbar reference"
			end
			seenHotbarSeeds[seedDefinitionId] = true
		else
			local hotbarItem = profile.itemsById[reference]
			if hotbarItem == nil
				or type(hotbarItem.location) ~= "table"
				or hotbarItem.location.kind ~= "Backpack"
			then
				return false, "invalid item hotbar reference"
			end
		end
	end
	for definitionId, seedStack in profile.seedStacks do
		if seedStack.quantity > 0 and seenHotbarSeeds[definitionId] ~= true then
			return false, "missing seed hotbar reference"
		end
	end
	if type(profile.foraging) ~= "table"
		or profile.foraging.version ~= 1
		or type(profile.foraging.nextAvailableAtByNodeId) ~= "table"
	then
		return false, "invalid foraging state"
	end
	local forageNodeCount = 0
	for nodeId, nextAvailableAtUnix in profile.foraging.nextAvailableAtByNodeId do
		forageNodeCount += 1
		if forageNodeCount > #ForageDefinitions.nodes
			or type(nodeId) ~= "string"
			or ForageDefinitions.byNodeId[nodeId] == nil
			or not integerInRange(nextAvailableAtUnix, 0, MAX_TIMESTAMP)
		then
			return false, "invalid forage node cooldown"
		end
	end
	if type(profile.tutorial) ~= "table" or type(profile.recentCommands) ~= "table" or type(profile.meta) ~= "table" then
		return false, "missing profile sections"
	end
	if profile.tutorial.version ~= 1 or TUTORIAL_STEPS[profile.tutorial.step] ~= true then
		return false, "invalid tutorial state"
	end
	if profile.tutorial.cycleItemId ~= nil and not boundedString(profile.tutorial.cycleItemId, 128) then
		return false, "invalid tutorial item"
	end
	if not optionalIntegerInRange(profile.tutorial.completedAtUnix, 0, MAX_TIMESTAMP) then
		return false, "invalid tutorial completion time"
	end
	local recent = profile.recentCommands
	if type(recent.order) ~= "table" or type(recent.byId) ~= "table" or #recent.order > PlantDefinitions.maxRecentCommands then
		return false, "invalid recent command ledger"
	end
	local seenRequestIds = {}
	for _, requestId in recent.order do
		if not boundedString(requestId, 128) or seenRequestIds[requestId] or type(recent.byId[requestId]) ~= "table" then
			return false, "invalid recent command order"
		end
		seenRequestIds[requestId] = true
	end
	local recordCount = 0
	for requestId, record in recent.byId do
		recordCount += 1
		if not seenRequestIds[requestId]
			or record.requestId ~= requestId
			or type(record.ok) ~= "boolean"
			or not boundedString(record.code, 64)
			or not boundedString(record.action, 64)
			or not boundedString(record.fingerprint, 256)
			or not integerInRange(record.profileRevision, 0, profile.profileRevision)
			or (record.itemId ~= nil and not boundedString(record.itemId, 128))
			or (record.definitionId ~= nil and PlantDefinitions.byId[record.definitionId] == nil)
			or (record.nodeId ~= nil and ForageDefinitions.byNodeId[record.nodeId] == nil)
			or (record.rarity ~= nil and not ForageDefinitions.isKnownRarity(record.rarity))
			or not optionalIntegerInRange(record.leafnoteDelta, -MAX_LEAFNOTES, MAX_LEAFNOTES)
			or not optionalIntegerInRange(record.weightMilli, 0, 1_000_000_000)
			or not optionalIntegerInRange(record.hotbarSlot, 1, 10)
			or not optionalIntegerInRange(record.nextAvailableAtUnix, 0, MAX_TIMESTAMP)
			or not optionalIntegerInRange(record.soldCount, 0, 100_000)
			or (record.favorite ~= nil and type(record.favorite) ~= "boolean")
		then
			return false, "invalid recent command record"
		end
	end
	if recordCount ~= #recent.order then
		return false, "recent command ledger mismatch"
	end
	local meta = profile.meta
	if not integerInRange(meta.createdAtUnix, 0, MAX_TIMESTAMP)
		or not integerInRange(meta.updatedAtUnix, meta.createdAtUnix, MAX_TIMESTAMP)
		or (meta.activeSessionId ~= nil and not boundedString(meta.activeSessionId, 256))
		or not optionalIntegerInRange(meta.leaseExpiresAtUnix, 0, MAX_TIMESTAMP)
	then
		return false, "invalid profile metadata"
	end
	if (meta.activeSessionId == nil) ~= (meta.leaseExpiresAtUnix == nil) then
		return false, "incomplete profile lease"
	end
	return true, nil
end

local function migrateVersion1(rawProfile: any): (any?, string?)
	local candidate = ProfileSchema.clone(rawProfile)
	candidate.schemaVersion = 2
	local migratedHotbar = {}
	if type(candidate.hotbar) ~= "table" then
		return nil, "invalid legacy hotbar"
	end
	local seenReferences = {}
	for rawSlot, reference in candidate.hotbar do
		local rawSlotType = type(rawSlot)
		local slot = if rawSlotType == "number" or rawSlotType == "string" then tonumber(rawSlot) else nil
		local canonicalInput = rawSlotType == "number" or (rawSlotType == "string" and slot ~= nil and tostring(slot) == rawSlot)
		if not canonicalInput or slot == nil or not integerInRange(slot, 1, 10) or not boundedString(reference, 160) then
			return nil, "invalid legacy hotbar entry"
		end
		local slotKey = tostring(slot)
		if migratedHotbar[slotKey] ~= nil then
			return nil, "duplicate legacy hotbar slot"
		end
		if slot == 1 then
			if reference ~= "seed:sunspud" then
				return nil, "invalid legacy seed hotbar reference"
			end
		else
			local item = if type(candidate.itemsById) == "table" then candidate.itemsById[reference] else nil
			if seenReferences[reference]
				or type(item) ~= "table"
				or type(item.location) ~= "table"
				or item.location.kind ~= "Backpack"
			then
				return nil, "invalid legacy item hotbar reference"
			end
			seenReferences[reference] = true
		end
		migratedHotbar[slotKey] = reference
	end
	if migratedHotbar["1"] ~= "seed:sunspud" then
		return nil, "missing legacy seed hotbar reference"
	end

	local assignedItems = {}
	for slotKey, reference in migratedHotbar do
		if slotKey ~= "1" then
			assignedItems[reference] = true
		end
	end
	local backpackIds = {}
	if type(candidate.itemsById) == "table" then
		for itemId, item in candidate.itemsById do
			if type(itemId) == "string" and type(item) == "table" and type(item.location) == "table" and item.location.kind == "Backpack" then
				table.insert(backpackIds, itemId)
			end
		end
	end
	table.sort(backpackIds)
	for _, itemId in backpackIds do
		if not assignedItems[itemId] then
			for slot = 2, 10 do
				local slotKey = tostring(slot)
				if migratedHotbar[slotKey] == nil then
					migratedHotbar[slotKey] = itemId
					assignedItems[itemId] = true
					break
				end
			end
		end
	end
	candidate.hotbar = migratedHotbar
	return candidate, nil
end

local function migrateVersion2(rawProfile: any): (any?, string?)
	local candidate = ProfileSchema.clone(rawProfile)
	if type(candidate.seedStacks) ~= "table" or type(candidate.seedStacks.sunspud) ~= "table" then
		return nil, "invalid version 2 seed stacks"
	end
	if candidate.seedStacks.hearthpetal ~= nil then
		return nil, "unexpected version 2 Hearthpetal stack"
	end
	if type(candidate.hotbar) ~= "table" or candidate.hotbar["1"] ~= "seed:sunspud" then
		return nil, "invalid version 2 hotbar"
	end

	candidate.schemaVersion = HEARTHPETAL_SCHEMA_VERSION
	candidate.seedStacks.hearthpetal = {
		quantity = 0,
		revision = 0,
	}
	local displacedItemId = candidate.hotbar["2"]
	candidate.hotbar["2"] = "seed:hearthpetal"
	if displacedItemId ~= nil then
		local displacedItem = if type(candidate.itemsById) == "table" then candidate.itemsById[displacedItemId] else nil
		if type(displacedItem) ~= "table" or type(displacedItem.location) ~= "table" or displacedItem.location.kind ~= "Backpack" then
			return nil, "invalid displaced version 2 hotbar item"
		end
		local alreadyAssigned = false
		for slot = 3, 10 do
			if candidate.hotbar[tostring(slot)] == displacedItemId then
				alreadyAssigned = true
				break
			end
		end
		if not alreadyAssigned then
			for slot = 3, 10 do
				local slotKey = tostring(slot)
				if candidate.hotbar[slotKey] == nil then
					candidate.hotbar[slotKey] = displacedItemId
					break
				end
			end
		end
	end
	return candidate, nil
end

local function migrateVersion3(rawProfile: any): (any?, string?)
	local candidate = ProfileSchema.clone(rawProfile)
	if candidate.foraging ~= nil then
		return nil, "unexpected version 3 foraging state"
	end
	candidate.schemaVersion = FORAGING_SCHEMA_VERSION
	candidate.foraging = {
		version = 1,
		nextAvailableAtByNodeId = {},
	}
	return candidate, nil
end

local function migrateVersion4(rawProfile: any): (any?, string?)
	local candidate = ProfileSchema.clone(rawProfile)
	if type(candidate.hotbar) ~= "table" or type(candidate.seedStacks) ~= "table" then
		return nil, "invalid version 4 hotbar"
	end
	for slotKey, reference in candidate.hotbar do
		if type(reference) == "string" then
			local definitionId = seedDefinitionIdFromReference(reference)
			local stack = if definitionId then candidate.seedStacks[definitionId] else nil
			if definitionId ~= nil and (type(stack) ~= "table" or stack.quantity == 0) then
				candidate.hotbar[slotKey] = nil
			end
		end
	end
	candidate.schemaVersion = CURRENT_SCHEMA_VERSION
	return candidate, nil
end

function ProfileSchema.decodeAndMigrate(rawProfile: any, _nowUnix: number): (any?, string?)
	if type(rawProfile) ~= "table" then
		return nil, "profile must be a table"
	end
	local candidate = nil
	if rawProfile.schemaVersion == 1 then
		local migrationReason = nil
		candidate, migrationReason = migrateVersion1(rawProfile)
		if candidate == nil then
			return nil, migrationReason
		end
		candidate, migrationReason = migrateVersion2(candidate)
		if candidate == nil then
			return nil, migrationReason
		end
		candidate, migrationReason = migrateVersion3(candidate)
		if candidate == nil then
			return nil, migrationReason
		end
		candidate, migrationReason = migrateVersion4(candidate)
		if candidate == nil then
			return nil, migrationReason
		end
	elseif rawProfile.schemaVersion == 2 then
		local migrationReason = nil
		candidate, migrationReason = migrateVersion2(rawProfile)
		if candidate == nil then
			return nil, migrationReason
		end
		candidate, migrationReason = migrateVersion3(candidate)
		if candidate == nil then
			return nil, migrationReason
		end
		candidate, migrationReason = migrateVersion4(candidate)
		if candidate == nil then
			return nil, migrationReason
		end
	elseif rawProfile.schemaVersion == HEARTHPETAL_SCHEMA_VERSION then
		local migrationReason = nil
		candidate, migrationReason = migrateVersion3(rawProfile)
		if candidate == nil then
			return nil, migrationReason
		end
		candidate, migrationReason = migrateVersion4(candidate)
		if candidate == nil then
			return nil, migrationReason
		end
	elseif rawProfile.schemaVersion == FORAGING_SCHEMA_VERSION then
		local migrationReason = nil
		candidate, migrationReason = migrateVersion4(rawProfile)
		if candidate == nil then
			return nil, migrationReason
		end
	elseif rawProfile.schemaVersion == CURRENT_SCHEMA_VERSION then
		candidate = ProfileSchema.clone(rawProfile)
	else
		return nil, "unsupported schema version"
	end
	local valid, reason = ProfileSchema.validate(candidate)
	if not valid then
		return nil, reason
	end
	return candidate, nil
end

function ProfileSchema.occupiedSlots(profile: any): number
	local occupied = 0
	for _, seedStack in profile.seedStacks do
		if seedStack.quantity > 0 then
			occupied += 1
		end
	end
	for _, item in profile.itemsById do
		if item.location and item.location.kind == "Backpack" then
			occupied += 1
		end
	end
	return occupied
end

return table.freeze(ProfileSchema)
