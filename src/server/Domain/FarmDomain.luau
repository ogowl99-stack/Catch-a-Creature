--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerRoot = script.Parent.Parent
local FarmContracts = require(ReplicatedStorage.CatchACreature.FarmContracts)
local ForageDefinitions = require(ServerRoot.Definitions.ForageDefinitions)
local PlantDefinitions = require(ServerRoot.Definitions.PlantDefinitions)
local ProfileSchema = require(ServerRoot.Data.ProfileSchema)

local FarmDomain = {}
local SEED_REFERENCE_PREFIX = "seed:"

local function failure(code: string, requestId: string?)
	return {
		ok = false,
		code = code,
		requestId = requestId,
	}
end

local function validRequestId(requestId: any): boolean
	return type(requestId) == "string"
		and #requestId >= FarmContracts.RequestIdMinLength
		and #requestId <= FarmContracts.RequestIdMaxLength
		and string.match(requestId, FarmContracts.RequestIdPattern) ~= nil
end

local function validInteger(value: any): boolean
	return type(value) == "number" and value == value and math.abs(value) < math.huge and value % 1 == 0
end

local function definitionForCommand(command: any): any?
	local definitionId = if type(command.definitionId) == "string" then command.definitionId else PlantDefinitions.Sunspud.id
	return PlantDefinitions.byId[definitionId]
end

local function fingerprint(command: any): string?
	if command.action == FarmContracts.Actions.BuySeed then
		local definition = definitionForCommand(command)
		return if definition then "BuySeed:" .. definition.id else nil
	elseif command.action == FarmContracts.Actions.PlaceSeed then
		local definition = definitionForCommand(command)
		if definition == nil or not validInteger(command.localXMilli) or not validInteger(command.localZMilli) then
			return nil
		end
		return string.format("PlaceSeed:%s:%d:%d", definition.id, command.localXMilli, command.localZMilli)
	elseif command.action == FarmContracts.Actions.HarvestPlant
		or command.action == FarmContracts.Actions.SellItem
		or command.action == FarmContracts.Actions.AssignHotbarItem
		or command.action == FarmContracts.Actions.ToggleFavoriteItem
	then
		if type(command.itemId) ~= "string" or not validInteger(command.expectedItemRevision) then
			return nil
		end
		return string.format("%s:%s:%d", command.action, command.itemId, command.expectedItemRevision)
	elseif command.action == FarmContracts.Actions.SellAllUnfavorited then
		return FarmContracts.Actions.SellAllUnfavorited
	elseif command.action == FarmContracts.Actions.UnassignHotbarSlot then
		if not validInteger(command.slotIndex) or command.slotIndex < 1 or command.slotIndex > 10 then
			return nil
		end
		return string.format("UnassignHotbarSlot:%d", command.slotIndex)
	elseif command.action == FarmContracts.Actions.ForageSeed then
		if type(command.definitionId) ~= "string" then
			return nil
		end
		local definition = definitionForCommand(command)
		if definition == nil or type(command.nodeId) ~= "string" or ForageDefinitions.byNodeId[command.nodeId] == nil then
			return nil
		end
		return string.format("ForageSeed:%s:%s", command.nodeId, definition.id)
	end
	return nil
end

local function countDeployed(profile: any): number
	local count = 0
	for _, item in profile.itemsById do
		if item.location and item.location.kind == "Plot" then
			count += 1
		end
	end
	return count
end

local function firstFreeHotbarSlot(profile: any): number?
	for slotIndex = 1, 10 do
		if profile.hotbar[tostring(slotIndex)] == nil then
			return slotIndex
		end
	end
	return nil
end

local function hotbarSlotForReference(profile: any, wantedReference: string): number?
	for slotIndex = 1, 10 do
		if profile.hotbar[tostring(slotIndex)] == wantedReference then
			return slotIndex
		end
	end
	return nil
end

local function seedReference(definitionId: string): string
	return SEED_REFERENCE_PREFIX .. definitionId
end

local function remember(candidate: any, command: any, commandFingerprint: string, result: any)
	local recent = candidate.recentCommands
	local record = {
		ok = result.ok,
		code = result.code,
		requestId = command.requestId,
		action = command.action,
		fingerprint = commandFingerprint,
		profileRevision = candidate.profileRevision,
		itemId = result.itemId,
		leafnoteDelta = result.leafnoteDelta,
		weightMilli = result.weightMilli,
		hotbarSlot = result.hotbarSlot,
		definitionId = result.definitionId,
		nodeId = result.nodeId,
		rarity = result.rarity,
		nextAvailableAtUnix = result.nextAvailableAtUnix,
		soldCount = result.soldCount,
		favorite = result.favorite,
	}

	recent.byId[command.requestId] = record
	table.insert(recent.order, command.requestId)
	while #recent.order > PlantDefinitions.maxRecentCommands do
		local removedId = table.remove(recent.order, 1)
		recent.byId[removedId] = nil
	end
end

function FarmDomain.apply(
	profile: any,
	command: any,
	nowUnix: number,
	generateId: () -> string,
	generateWeightMilli: (any) -> number
): (any?, any)
	if type(command) ~= "table" or not validRequestId(command.requestId) then
		return nil, failure(FarmContracts.Codes.InvalidRequest, if type(command) == "table" then command.requestId else nil)
	end

	local commandFingerprint = fingerprint(command)
	if commandFingerprint == nil then
		return nil, failure(FarmContracts.Codes.InvalidRequest, command.requestId)
	end

	local existing = profile.recentCommands.byId[command.requestId]
	if existing ~= nil then
		if existing.fingerprint ~= commandFingerprint or existing.action ~= command.action then
			return nil, failure(FarmContracts.Codes.RequestIdConflict, command.requestId)
		end
		local replay = ProfileSchema.clone(existing)
		replay.replay = true
		return nil, replay
	end

	if not validInteger(command.expectedProfileRevision) or command.expectedProfileRevision ~= profile.profileRevision then
		return nil, failure(FarmContracts.Codes.StaleRevision, command.requestId)
	end

	local definition = definitionForCommand(command)
	if (command.action == FarmContracts.Actions.BuySeed
		or command.action == FarmContracts.Actions.PlaceSeed
		or command.action == FarmContracts.Actions.ForageSeed)
		and definition == nil
	then
		return nil, failure(FarmContracts.Codes.InvalidRequest, command.requestId)
	end
	local candidate = ProfileSchema.clone(profile)
	local result = {
		ok = true,
		code = FarmContracts.Codes.Ok,
		requestId = command.requestId,
		action = command.action,
	}

	if command.action == FarmContracts.Actions.BuySeed then
		local stack = candidate.seedStacks[definition.id]
		if stack.quantity >= definition.maxSeedStack then
			return nil, failure(FarmContracts.Codes.SeedStackFull, command.requestId)
		end
		if stack.quantity == 0 and ProfileSchema.occupiedSlots(candidate) >= PlantDefinitions.baseBackpackCapacity then
			return nil, failure(FarmContracts.Codes.BackpackFull, command.requestId)
		end
		if candidate.leafnotes < definition.seedPrice then
			return nil, failure(FarmContracts.Codes.InsufficientFunds, command.requestId)
		end
		local seedSlot = hotbarSlotForReference(candidate, seedReference(definition.id))
		if stack.quantity == 0 then
			seedSlot = firstFreeHotbarSlot(candidate)
			if seedSlot == nil then
				return nil, failure(FarmContracts.Codes.HotbarFull, command.requestId)
			end
		end

		candidate.leafnotes -= definition.seedPrice
		stack.quantity += 1
		stack.revision += 1
		if seedSlot ~= nil then
			candidate.hotbar[tostring(seedSlot)] = seedReference(definition.id)
			result.hotbarSlot = seedSlot
		end
		if definition.id == PlantDefinitions.Sunspud.id and candidate.tutorial.step == "Buy" then
			candidate.tutorial.step = "Place"
		end
		result.leafnoteDelta = -definition.seedPrice
		result.definitionId = definition.id
	elseif command.action == FarmContracts.Actions.PlaceSeed then
		local stack = candidate.seedStacks[definition.id]
		if stack.quantity <= 0 then
			return nil, failure(FarmContracts.Codes.NoSeed, command.requestId)
		end
		if countDeployed(candidate) >= PlantDefinitions.maxDeployedPlantsPerPlayer then
			return nil, failure(FarmContracts.Codes.PlantLimit, command.requestId)
		end
		for _, item in candidate.itemsById do
			local location = item.location
			if location and location.kind == "Plot" and location.localXMilli == command.localXMilli and location.localZMilli == command.localZMilli then
				return nil, failure(FarmContracts.Codes.DuplicatePlacement, command.requestId)
			end
		end

		local itemId = generateId()
		local weightMilli = generateWeightMilli(definition)
		if type(itemId) ~= "string" or itemId == "" or not validInteger(weightMilli) or weightMilli < definition.weightMinMilli or weightMilli > definition.weightMaxMilli then
			return nil, failure(FarmContracts.Codes.InternalError, command.requestId)
		end
		if candidate.itemsById[itemId] ~= nil then
			return nil, failure(FarmContracts.Codes.InternalError, command.requestId)
		end

		stack.quantity -= 1
		stack.revision += 1
		if stack.quantity == 0 then
			local seedSlot = hotbarSlotForReference(candidate, seedReference(definition.id))
			if seedSlot ~= nil then
				candidate.hotbar[tostring(seedSlot)] = nil
			end
		end
		candidate.itemsById[itemId] = {
			id = itemId,
			kind = "Plant",
			definitionId = definition.id,
			definitionVersion = definition.version,
			revision = 1,
			weightMilli = weightMilli,
			favorite = false,
			origin = {
				kind = "PlacedFromSeed",
				createdAtUnix = nowUnix,
			},
			location = {
				kind = "Plot",
				localXMilli = command.localXMilli,
				localZMilli = command.localZMilli,
				plantedAtUnix = nowUnix,
				maturesAtUnix = nowUnix + definition.growthSeconds,
			},
		}
		if definition.id == PlantDefinitions.Sunspud.id then
			candidate.tutorial.step = "Grow"
			candidate.tutorial.cycleItemId = itemId
		end
		result.itemId = itemId
		result.definitionId = definition.id
	elseif command.action == FarmContracts.Actions.HarvestPlant then
		local item = candidate.itemsById[command.itemId]
		if item == nil then
			return nil, failure(FarmContracts.Codes.ItemNotFound, command.requestId)
		end
		if item.revision ~= command.expectedItemRevision then
			return nil, failure(FarmContracts.Codes.StaleRevision, command.requestId)
		end
		if item.location == nil or item.location.kind ~= "Plot" then
			return nil, failure(FarmContracts.Codes.ItemStateInvalid, command.requestId)
		end
		if nowUnix < item.location.maturesAtUnix then
			return nil, failure(FarmContracts.Codes.NotMature, command.requestId)
		end
		if ProfileSchema.occupiedSlots(candidate) >= PlantDefinitions.baseBackpackCapacity then
			return nil, failure(FarmContracts.Codes.BackpackFull, command.requestId)
		end

		item.revision += 1
		item.location = {
			kind = "Backpack",
			harvestedAtUnix = nowUnix,
		}
		local freeSlot = firstFreeHotbarSlot(candidate)
		if freeSlot then
			candidate.hotbar[tostring(freeSlot)] = item.id
			result.hotbarSlot = freeSlot
		end
		if item.definitionId == PlantDefinitions.Sunspud.id and candidate.tutorial.cycleItemId == item.id then
			candidate.tutorial.step = "Sell"
		end
		result.itemId = item.id
		result.weightMilli = item.weightMilli
		result.definitionId = item.definitionId
	elseif command.action == FarmContracts.Actions.SellItem then
		local item = candidate.itemsById[command.itemId]
		if item == nil then
			return nil, failure(FarmContracts.Codes.ItemNotFound, command.requestId)
		end
		if item.revision ~= command.expectedItemRevision then
			return nil, failure(FarmContracts.Codes.StaleRevision, command.requestId)
		end
		if item.location == nil or item.location.kind ~= "Backpack" then
			return nil, failure(FarmContracts.Codes.ItemStateInvalid, command.requestId)
		end
		if item.favorite == true then
			return nil, failure(FarmContracts.Codes.ItemFavorite, command.requestId)
		end

		local itemDefinition = PlantDefinitions.byId[item.definitionId]
		if itemDefinition == nil then
			return nil, failure(FarmContracts.Codes.ItemStateInvalid, command.requestId)
		end
		local payout = math.max(1, math.floor(itemDefinition.baseSaleValue * item.weightMilli / 1000))
		if candidate.leafnotes + payout > 2_000_000_000 then
			return nil, failure(FarmContracts.Codes.InternalError, command.requestId)
		end
		candidate.itemsById[command.itemId] = nil
		for slotIndex = 1, 10 do
			local slotKey = tostring(slotIndex)
			if candidate.hotbar[slotKey] == command.itemId then
				candidate.hotbar[slotKey] = nil
			end
		end
		candidate.leafnotes += payout
		if candidate.tutorial.cycleItemId == command.itemId then
			candidate.tutorial.step = "Complete"
			candidate.tutorial.completedAtUnix = nowUnix
		end
		result.itemId = command.itemId
		result.leafnoteDelta = payout
		result.definitionId = item.definitionId
	elseif command.action == FarmContracts.Actions.SellAllUnfavorited then
		local soldCount = 0
		local payout = 0
		local soldTutorialItem = false
		local soldById = {}
		for itemId, item in candidate.itemsById do
			if item.location and item.location.kind == "Backpack" and item.favorite ~= true then
				local itemDefinition = PlantDefinitions.byId[item.definitionId]
				if itemDefinition == nil then
					return nil, failure(FarmContracts.Codes.ItemStateInvalid, command.requestId)
				end
				local itemPayout = math.max(1, math.floor(itemDefinition.baseSaleValue * item.weightMilli / 1000))
				if candidate.leafnotes + payout + itemPayout > 2_000_000_000 then
					return nil, failure(FarmContracts.Codes.InternalError, command.requestId)
				end
				payout += itemPayout
				soldCount += 1
				soldById[itemId] = true
				if candidate.tutorial.cycleItemId == itemId then
					soldTutorialItem = true
				end
			end
		end
		if soldCount == 0 then
			return nil, failure(FarmContracts.Codes.NoSellableItems, command.requestId)
		end
		for itemId in soldById do
			candidate.itemsById[itemId] = nil
		end
		for slotIndex = 1, 10 do
			local slotKey = tostring(slotIndex)
			if soldById[candidate.hotbar[slotKey]] then
				candidate.hotbar[slotKey] = nil
			end
		end
		candidate.leafnotes += payout
		if soldTutorialItem then
			candidate.tutorial.step = "Complete"
			candidate.tutorial.completedAtUnix = nowUnix
		end
		result.soldCount = soldCount
		result.leafnoteDelta = payout
	elseif command.action == FarmContracts.Actions.ToggleFavoriteItem then
		local item = candidate.itemsById[command.itemId]
		if item == nil then
			return nil, failure(FarmContracts.Codes.ItemNotFound, command.requestId)
		end
		if item.revision ~= command.expectedItemRevision then
			return nil, failure(FarmContracts.Codes.StaleRevision, command.requestId)
		end
		if item.location == nil or item.location.kind ~= "Backpack" then
			return nil, failure(FarmContracts.Codes.ItemStateInvalid, command.requestId)
		end
		item.favorite = item.favorite ~= true
		item.revision += 1
		result.itemId = item.id
		result.definitionId = item.definitionId
		result.favorite = item.favorite
	elseif command.action == FarmContracts.Actions.UnassignHotbarSlot then
		local slotKey = tostring(command.slotIndex)
		local itemId = candidate.hotbar[slotKey]
		if itemId == nil then
			return nil, failure(FarmContracts.Codes.NoChange, command.requestId)
		end
		local item = candidate.itemsById[itemId]
		if item == nil or item.location == nil or item.location.kind ~= "Backpack" then
			return nil, failure(FarmContracts.Codes.ItemStateInvalid, command.requestId)
		end
		candidate.hotbar[slotKey] = nil
		result.itemId = itemId
		result.hotbarSlot = command.slotIndex
	elseif command.action == FarmContracts.Actions.AssignHotbarItem then
		local item = candidate.itemsById[command.itemId]
		if item == nil then
			return nil, failure(FarmContracts.Codes.ItemNotFound, command.requestId)
		end
		if item.revision ~= command.expectedItemRevision then
			return nil, failure(FarmContracts.Codes.StaleRevision, command.requestId)
		end
		if item.location == nil or item.location.kind ~= "Backpack" then
			return nil, failure(FarmContracts.Codes.ItemStateInvalid, command.requestId)
		end
		for slotIndex = 1, 10 do
			if candidate.hotbar[tostring(slotIndex)] == item.id then
				return nil, failure(FarmContracts.Codes.NoChange, command.requestId)
			end
		end
		local freeSlot = firstFreeHotbarSlot(candidate)
		if freeSlot == nil then
			return nil, failure(FarmContracts.Codes.HotbarFull, command.requestId)
		end
		candidate.hotbar[tostring(freeSlot)] = item.id
		result.itemId = item.id
		result.hotbarSlot = freeSlot
	elseif command.action == FarmContracts.Actions.ForageSeed then
		local node = ForageDefinitions.byNodeId[command.nodeId]
		if node == nil or definition.forageEnabled ~= true or not ForageDefinitions.isKnownRarity(definition.seedRarity) then
			return nil, failure(FarmContracts.Codes.InvalidRequest, command.requestId)
		end
		local nextAvailableAtUnix = candidate.foraging.nextAvailableAtByNodeId[node.id]
		if type(nextAvailableAtUnix) == "number" and nowUnix < nextAvailableAtUnix then
			local rejected = failure(FarmContracts.Codes.ForageCooldown, command.requestId)
			rejected.retryAfterSeconds = nextAvailableAtUnix - nowUnix
			return nil, rejected
		end
		local stack = candidate.seedStacks[definition.id]
		if stack.quantity >= definition.maxSeedStack then
			return nil, failure(FarmContracts.Codes.SeedStackFull, command.requestId)
		end
		if stack.quantity == 0 and ProfileSchema.occupiedSlots(candidate) >= PlantDefinitions.baseBackpackCapacity then
			return nil, failure(FarmContracts.Codes.BackpackFull, command.requestId)
		end
		local seedSlot = hotbarSlotForReference(candidate, seedReference(definition.id))
		if stack.quantity == 0 then
			seedSlot = firstFreeHotbarSlot(candidate)
			if seedSlot == nil then
				return nil, failure(FarmContracts.Codes.HotbarFull, command.requestId)
			end
		end

		stack.quantity += 1
		stack.revision += 1
		if seedSlot ~= nil then
			candidate.hotbar[tostring(seedSlot)] = seedReference(definition.id)
			result.hotbarSlot = seedSlot
		end
		nextAvailableAtUnix = nowUnix + ForageDefinitions.cooldownSeconds
		candidate.foraging.nextAvailableAtByNodeId[node.id] = nextAvailableAtUnix
		result.definitionId = definition.id
		result.nodeId = node.id
		result.rarity = definition.seedRarity
		result.nextAvailableAtUnix = nextAvailableAtUnix
	else
		return nil, failure(FarmContracts.Codes.InvalidAction, command.requestId)
	end

	candidate.profileRevision += 1
	candidate.meta.updatedAtUnix = nowUnix
	result.profileRevision = candidate.profileRevision
	remember(candidate, command, commandFingerprint, result)
	return candidate, result
end

return table.freeze(FarmDomain)
