--!strict

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerRoot = script.Parent.Parent
local FarmContracts = require(ReplicatedStorage.CatchACreature.FarmContracts)
local ForageDefinitions = require(ServerRoot.Definitions.ForageDefinitions)
local PlantDefinitions = require(ServerRoot.Definitions.PlantDefinitions)
local ProfileSchema = require(ServerRoot.Data.ProfileSchema)
local FarmDomain = require(ServerRoot.Domain.FarmDomain)

local FarmService = {}
FarmService.__index = FarmService

function FarmService.new(profileRepository: any, plotService: any)
	local remotes = ReplicatedStorage.CatchACreature.Remotes
	return setmetatable({
		_repository = profileRepository,
		_plotService = plotService,
		_worldService = nil,
		_creatureWorldService = nil,
		_query = remotes.FarmQuery,
		_command = remotes.FarmCommand,
		_stateChanged = remotes.StateChanged,
		_busy = {},
		_loading = {},
		_loadErrors = {},
		_equippedItemId = {},
		_equippedHotbarSlot = {},
		_random = Random.new(),
		_forageGrantToken = {},
	}, FarmService)
end

function FarmService:setWorldService(worldService: any)
	self._worldService = worldService
end

function FarmService:setCreatureWorldService(worldService: any)
	self._creatureWorldService = worldService
end

function FarmService:_rebuildWorld(player: Player, profile: any)
	if self._worldService then
		self._worldService:rebuildPlayer(player, profile)
	end
	if self._creatureWorldService then
		self._creatureWorldService:rebuildPlayer(player, profile)
	end
end

function FarmService:_snapshot(player: Player)
	local nowUnix = os.time()
	local profile = self._repository:getProfile(player)
	local plotId = self._plotService:getPlotId(player)
	if profile == nil then
		return {
			ok = false,
			code = FarmContracts.Codes.ProfileUnavailable,
			serverNowUnix = nowUnix,
			assignedPlotId = plotId,
			status = self._loadErrors[player] or "LOADING",
			persistenceMode = self._repository:getMode(),
			truthLabel = "Blocked",
		}
	end

	local backpackItems = {}
	local plants = {}
	local hotbar = {}
	local seedStacks = {}
	local catalog = {}
	for _, definition in PlantDefinitions.ordered do
		local stack = profile.seedStacks[definition.id]
		seedStacks[definition.id] = {
			quantity = stack.quantity,
			revision = stack.revision,
		}
		catalog[definition.id] = {
			id = definition.id,
			displayName = definition.displayName,
			growthSeconds = definition.growthSeconds,
			seedPrice = definition.seedPrice,
			harvestMode = definition.harvestMode,
			attractsCreatureId = definition.attractsCreatureId,
			seedRarity = definition.seedRarity,
			forageEnabled = definition.forageEnabled == true,
			valuesStatus = PlantDefinitions.valuesStatus,
		}
	end
	for itemId, item in profile.itemsById do
		local location = item.location
		if location and location.kind == "Backpack" then
			table.insert(backpackItems, {
				id = itemId,
				definitionId = item.definitionId,
				revision = item.revision,
				weightMilli = item.weightMilli,
				favorite = item.favorite == true,
			})
		elseif location and location.kind == "Plot" then
			local duration = math.max(1, location.maturesAtUnix - location.plantedAtUnix)
			local progress = math.clamp((nowUnix - location.plantedAtUnix) / duration, 0, 1)
			table.insert(plants, {
				id = itemId,
				definitionId = item.definitionId,
				revision = item.revision,
				localXMilli = location.localXMilli,
				localZMilli = location.localZMilli,
				plantedAtUnix = location.plantedAtUnix,
				maturesAtUnix = location.maturesAtUnix,
				progress = progress,
			})
		end
	end
	table.sort(backpackItems, function(left, right)
		return left.id < right.id
	end)
	table.sort(plants, function(left, right)
		return left.id < right.id
	end)
	for slotKey, reference in profile.hotbar do
		hotbar[slotKey] = reference
	end
	local equippedItemId = self._equippedItemId[player]
	if equippedItemId ~= nil then
		local equippedItem = profile.itemsById[equippedItemId]
		if equippedItem == nil or equippedItem.location == nil or equippedItem.location.kind ~= "Backpack" then
			self._equippedItemId[player] = nil
			self._equippedHotbarSlot[player] = nil
			equippedItemId = nil
		end
	end

	return {
		ok = true,
		code = FarmContracts.Codes.Ok,
		serverNowUnix = nowUnix,
		profileRevision = profile.profileRevision,
		assignedPlotId = plotId,
		gateCrossed = self._plotService:hasCrossedGate(player),
		leafnotes = profile.leafnotes,
		seedCount = profile.seedStacks.sunspud.quantity,
		seedRevision = profile.seedStacks.sunspud.revision,
		seedStacks = seedStacks,
		usedSlots = ProfileSchema.occupiedSlots(profile),
		backpackCapacity = PlantDefinitions.baseBackpackCapacity,
		backpackItems = backpackItems,
		hotbar = hotbar,
		equippedItemId = equippedItemId,
		equippedHotbarSlot = self._equippedHotbarSlot[player],
		plants = plants,
		tutorialStep = profile.tutorial.step,
		persistenceMode = self._repository:getMode(),
		truthLabel = if string.find(self._repository:getMode(), "Simulated") then "Simulated" else "Requires production testing",
		catalog = catalog,
	}
end

function FarmService:_response(player: Player, result: any)
	result.serverNowUnix = os.time()
	result.snapshot = self:_snapshot(player)
	return result
end

function FarmService:_sendState(player: Player, result: any?)
	self._stateChanged:FireClient(player, {
		result = result,
		snapshot = self:_snapshot(player),
	})
end

function FarmService:_loadPlayer(player: Player)
	if self._loading[player] or self._repository:getProfile(player) ~= nil then
		return
	end
	self._loading[player] = true
	local loaded, loadError = self._repository:load(player)
	if not loaded then
		self._loadErrors[player] = loadError or "LOAD_FAILED"
		self._loading[player] = nil
		if player.Parent == Players then
			self:_sendState(player, nil)
		else
			self._repository:release(player)
		end
		return
	end
	if player.Parent ~= Players then
		self._loading[player] = nil
		self._repository:release(player)
		return
	end
	self._loadErrors[player] = nil
	local plot = self._plotService:assign(player)
	if plot == nil then
		self._loadErrors[player] = FarmContracts.Codes.PlotUnavailable
		self._loading[player] = nil
		self:_sendState(player, nil)
		return
	end
	if player.Parent ~= Players then
		self._loading[player] = nil
		self._plotService:release(player)
		self._repository:release(player)
		return
	end
	local profile = self._repository:getProfile(player)
	if profile then
		self:_rebuildWorld(player, profile)
	end
	self._loading[player] = nil
	self:_sendState(player, nil)
end

function FarmService:_prepareCommand(player: Player, request: any): (any?, string?)
	if type(request) ~= "table" or type(request.action) ~= "string" then
		return nil, FarmContracts.Codes.InvalidRequest
	end
	local internal = {
		requestId = request.requestId,
		expectedProfileRevision = request.expectedProfileRevision,
		action = request.action,
	}
	if request.action == FarmContracts.Actions.BuySeed then
		local definitionId = if type(request.definitionId) == "string" then request.definitionId else PlantDefinitions.Sunspud.id
		if PlantDefinitions.byId[definitionId] == nil then
			return nil, FarmContracts.Codes.InvalidRequest
		end
		internal.definitionId = definitionId
		return internal, nil
	elseif request.action == FarmContracts.Actions.PlaceSeed then
		local definitionId = if type(request.definitionId) == "string" then request.definitionId else PlantDefinitions.Sunspud.id
		if PlantDefinitions.byId[definitionId] == nil then
			return nil, FarmContracts.Codes.InvalidRequest
		end
		local localX, localZ = self._plotService:canonicalPlacement(player, request.worldPosition, request.snapToGrid == true, definitionId)
		if localX == nil or localZ == nil then
			return nil, FarmContracts.Codes.InvalidPlacement
		end
		internal.localXMilli = localX
		internal.localZMilli = localZ
		internal.definitionId = definitionId
		return internal, nil
	elseif request.action == FarmContracts.Actions.HarvestPlant
		or request.action == FarmContracts.Actions.SellItem
		or request.action == FarmContracts.Actions.AssignHotbarItem
		or request.action == FarmContracts.Actions.ToggleFavoriteItem
	then
		if type(request.itemId) ~= "string" or type(request.expectedItemRevision) ~= "number" then
			return nil, FarmContracts.Codes.InvalidRequest
		end
		internal.itemId = request.itemId
		internal.expectedItemRevision = request.expectedItemRevision
		if request.action == FarmContracts.Actions.SellItem and self._equippedItemId[player] ~= request.itemId then
			return nil, FarmContracts.Codes.ItemNotEquipped
		end
		return internal, nil
	elseif request.action == FarmContracts.Actions.SellAllUnfavorited then
		return internal, nil
	elseif request.action == FarmContracts.Actions.UnassignHotbarSlot then
		internal.slotIndex = request.slotIndex
		return internal, nil
	elseif request.action == FarmContracts.Actions.ForageSeed then
		if request._forageGrantToken ~= self._forageGrantToken
			or type(request.nodeId) ~= "string"
			or ForageDefinitions.byNodeId[request.nodeId] == nil
			or type(request.definitionId) ~= "string"
			or PlantDefinitions.byId[request.definitionId] == nil
		then
			return nil, FarmContracts.Codes.InvalidRequest
		end
		internal.nodeId = request.nodeId
		internal.definitionId = request.definitionId
		return internal, nil
	end
	return nil, FarmContracts.Codes.InvalidAction
end

function FarmService:_mutate(player: Player, request: any)
	if self._busy[player] then
		return self:_response(player, {
			ok = false,
			code = FarmContracts.Codes.Busy,
			requestId = if type(request) == "table" then request.requestId else nil,
		})
	end
	if not self._repository:isWritable(player) then
		return self:_response(player, {
			ok = false,
			code = FarmContracts.Codes.ProfileUnavailable,
		})
	end

	self._busy[player] = true
	local ok, response = xpcall(function()
		local profile = self._repository:getProfile(player)
		if profile == nil then
			return self:_response(player, { ok = false, code = FarmContracts.Codes.ProfileUnavailable })
		end
		local internal, prepareError = self:_prepareCommand(player, request)
		if internal == nil then
			return self:_response(player, {
				ok = false,
				code = prepareError or FarmContracts.Codes.InvalidRequest,
				requestId = if type(request) == "table" then request.requestId else nil,
			})
		end

		local candidate, result = FarmDomain.apply(profile, internal, os.time(), function()
			return HttpService:GenerateGUID(false)
		end, function(definition)
			return self._random:NextInteger(definition.weightMinMilli, definition.weightMaxMilli)
		end)
		if candidate == nil then
			local rejected = self:_response(player, result)
			self:_sendState(player, result)
			return rejected
		end

		if not self._repository:commit(player, profile.profileRevision, candidate) then
			local persistenceFailure = {
				ok = false,
				code = FarmContracts.Codes.PersistenceUnavailable,
				requestId = internal.requestId,
			}
			self:_sendState(player, persistenceFailure)
			return self:_response(player, persistenceFailure)
		end

		local committed = self._repository:getProfile(player)
		if committed then
			if result.action == FarmContracts.Actions.HarvestPlant and type(result.itemId) == "string" then
				self._equippedItemId[player] = result.itemId
				self._equippedHotbarSlot[player] = nil
				for slotIndex = 1, 10 do
					if committed.hotbar[tostring(slotIndex)] == result.itemId then
						self._equippedHotbarSlot[player] = slotIndex
						break
					end
				end
			elseif result.action == FarmContracts.Actions.PlaceSeed then
				local equippedSlot = self._equippedHotbarSlot[player]
				if equippedSlot ~= nil and committed.hotbar[tostring(equippedSlot)] == nil then
					self._equippedItemId[player] = nil
					self._equippedHotbarSlot[player] = nil
				end
			elseif result.action == FarmContracts.Actions.AssignHotbarItem and type(result.itemId) == "string" then
				self._equippedItemId[player] = result.itemId
				self._equippedHotbarSlot[player] = result.hotbarSlot
			elseif (result.action == FarmContracts.Actions.SellItem or result.action == FarmContracts.Actions.UnassignHotbarSlot)
				and result.itemId == self._equippedItemId[player]
			then
				self._equippedItemId[player] = nil
				self._equippedHotbarSlot[player] = nil
			elseif result.action == FarmContracts.Actions.SellAllUnfavorited then
				local equippedId = self._equippedItemId[player]
				if equippedId ~= nil and committed.itemsById[equippedId] == nil then
					self._equippedItemId[player] = nil
					self._equippedHotbarSlot[player] = nil
				end
			end
			self:_rebuildWorld(player, committed)
		end
		self:_sendState(player, result)
		return self:_response(player, result)
	end, debug.traceback)
	self._busy[player] = nil

	if not ok then
		warn("[CatchACreature] Farm command failed:", response)
		return self:_response(player, {
			ok = false,
			code = FarmContracts.Codes.InternalError,
		})
	end
	return response
end

function FarmService:_equipHotbarSlot(player: Player, request: any)
	if self._busy[player] then
		return self:_response(player, { ok = false, code = FarmContracts.Codes.Busy, action = FarmContracts.Actions.EquipHotbarSlot })
	end
	local profile = self._repository:getProfile(player)
	local slotIndex = if type(request) == "table" then request.slotIndex else nil
	if profile == nil then
		return self:_response(player, { ok = false, code = FarmContracts.Codes.ProfileUnavailable, action = FarmContracts.Actions.EquipHotbarSlot })
	end
	if type(slotIndex) ~= "number" or slotIndex % 1 ~= 0 or slotIndex < 1 or slotIndex > 10 then
		return self:_response(player, { ok = false, code = FarmContracts.Codes.InvalidRequest, action = FarmContracts.Actions.EquipHotbarSlot })
	end
	local result = {
		ok = true,
		code = FarmContracts.Codes.Ok,
		action = FarmContracts.Actions.EquipHotbarSlot,
		hotbarSlot = slotIndex,
	}
	local reference = profile.hotbar[tostring(slotIndex)]
	local seedDefinitionId = if type(reference) == "string" then string.match(reference, "^seed:(.+)$") else nil
	if seedDefinitionId ~= nil then
		local definitionId = seedDefinitionId
		local stack = profile.seedStacks[definitionId]
		if PlantDefinitions.byId[definitionId] == nil or stack == nil or stack.quantity <= 0 then
			return self:_response(player, { ok = false, code = FarmContracts.Codes.NoSeed, action = FarmContracts.Actions.EquipHotbarSlot })
		end
		self._equippedItemId[player] = nil
		self._equippedHotbarSlot[player] = slotIndex
		result.definitionId = definitionId
		result.equippedKind = "Seed"
	else
		local itemId = reference
		local item = if itemId then profile.itemsById[itemId] else nil
		if item == nil or item.location == nil or item.location.kind ~= "Backpack" then
			return self:_response(player, { ok = false, code = FarmContracts.Codes.ItemStateInvalid, action = FarmContracts.Actions.EquipHotbarSlot })
		end
		self._equippedItemId[player] = itemId
		self._equippedHotbarSlot[player] = slotIndex
		result.itemId = itemId
		result.definitionId = item.definitionId
		result.equippedKind = "Item"
	end
	return self:_response(player, result)
end

function FarmService:_travel(player: Player, request: any)
	if type(request) ~= "table" or type(request.target) ~= "string" then
		return self:_response(player, { ok = false, code = FarmContracts.Codes.InvalidRequest })
	end
	local target = request.target
	if target ~= FarmContracts.TravelTargets.Shop and target ~= FarmContracts.TravelTargets.Plot and target ~= FarmContracts.TravelTargets.Sell then
		return self:_response(player, { ok = false, code = FarmContracts.Codes.InvalidTravelTarget })
	end
	if not self._plotService:travel(player, target) then
		return self:_response(player, { ok = false, code = FarmContracts.Codes.PlotUnavailable })
	end
	local result = {
		ok = true,
		code = FarmContracts.Codes.Ok,
		action = FarmContracts.Actions.Travel,
		panel = target,
	}
	self:_sendState(player, result)
	return self:_response(player, result)
end

function FarmService:_openService(player: Player, target: string)
	if target ~= FarmContracts.TravelTargets.Shop and target ~= FarmContracts.TravelTargets.Sell then
		return
	end
	if self._repository:getProfile(player) == nil then
		return
	end
	self:_sendState(player, {
		ok = true,
		code = FarmContracts.Codes.Ok,
		action = "OpenService",
		panel = target,
	})
end

function FarmService:promptHarvest(player: Player, itemId: string, itemRevision: number)
	local profile = self._repository:getProfile(player)
	if profile == nil then
		return
	end
	self:_mutate(player, {
		requestId = "prompt-" .. HttpService:GenerateGUID(false),
		expectedProfileRevision = profile.profileRevision,
		action = FarmContracts.Actions.HarvestPlant,
		itemId = itemId,
		expectedItemRevision = itemRevision,
	})
end

function FarmService:forageSeed(player: Player, nodeId: string)
	if self._busy[player] then
		local result = { ok = false, code = FarmContracts.Codes.Busy, action = FarmContracts.Actions.ForageSeed }
		self:_sendState(player, result)
		return self:_response(player, result)
	end
	if not self._repository:isWritable(player) then
		local result = { ok = false, code = FarmContracts.Codes.ProfileUnavailable, action = FarmContracts.Actions.ForageSeed }
		self:_sendState(player, result)
		return self:_response(player, result)
	end
	local profile = self._repository:getProfile(player)
	local node = ForageDefinitions.byNodeId[nodeId]
	if profile == nil or node == nil then
		local result = { ok = false, code = FarmContracts.Codes.InvalidRequest, action = FarmContracts.Actions.ForageSeed }
		self:_sendState(player, result)
		return self:_response(player, result)
	end
	local nowUnix = os.time()
	local nextAvailableAtUnix = profile.foraging.nextAvailableAtByNodeId[nodeId]
	if type(nextAvailableAtUnix) == "number" and nowUnix < nextAvailableAtUnix then
		local result = {
			ok = false,
			code = FarmContracts.Codes.ForageCooldown,
			action = FarmContracts.Actions.ForageSeed,
			retryAfterSeconds = nextAvailableAtUnix - nowUnix,
		}
		self:_sendState(player, result)
		return self:_response(player, result)
	end

	local occupiedSlots = ProfileSchema.occupiedSlots(profile)
	local definition = ForageDefinitions.selectDefinition(self._random, PlantDefinitions.ordered, function(candidate)
		local stack = profile.seedStacks[candidate.id]
		return stack ~= nil
			and stack.quantity < candidate.maxSeedStack
			and (stack.quantity > 0 or occupiedSlots < PlantDefinitions.baseBackpackCapacity)
	end)
	if definition == nil then
		local result = { ok = false, code = FarmContracts.Codes.NoForageReward, action = FarmContracts.Actions.ForageSeed }
		self:_sendState(player, result)
		return self:_response(player, result)
	end

	return self:_mutate(player, {
		requestId = "forage-" .. HttpService:GenerateGUID(false),
		expectedProfileRevision = profile.profileRevision,
		action = FarmContracts.Actions.ForageSeed,
		nodeId = node.id,
		definitionId = definition.id,
		_forageGrantToken = self._forageGrantToken,
	})
end

function FarmService:start()
	self._query.OnServerInvoke = function(player)
		return self:_snapshot(player)
	end
	self._command.OnServerInvoke = function(player, request)
		if type(request) == "table" and request.action == FarmContracts.Actions.Travel then
			return self:_travel(player, request)
		elseif type(request) == "table" and request.action == FarmContracts.Actions.EquipHotbarSlot then
			return self:_equipHotbarSlot(player, request)
		end
		return self:_mutate(player, request)
	end

	self._plotService:startGate(function(player)
		self:_sendState(player, {
			ok = true,
			code = FarmContracts.Codes.Ok,
			action = "CrossGate",
		})
	end)
	self._plotService:startServicePrompts(function(player, target)
		self:_openService(player, target)
	end)

	Players.PlayerAdded:Connect(function(player)
		task.spawn(function()
			self:_loadPlayer(player)
		end)
	end)
	Players.PlayerRemoving:Connect(function(player)
		if self._worldService then
			self._worldService:destroyPlayer(player)
		end
		if self._creatureWorldService then
			self._creatureWorldService:destroyPlayer(player)
		end
		self._plotService:release(player)
		self._repository:release(player)
		self._busy[player] = nil
		self._loading[player] = nil
		self._loadErrors[player] = nil
		self._equippedItemId[player] = nil
		self._equippedHotbarSlot[player] = nil
	end)
	for _, player in Players:GetPlayers() do
		task.spawn(function()
			self:_loadPlayer(player)
		end)
	end

	task.spawn(function()
		while true do
			task.wait(60)
			for _, player in Players:GetPlayers() do
				self._repository:refresh(player)
			end
		end
	end)

	game:BindToClose(function()
		for _, player in Players:GetPlayers() do
			self._repository:release(player)
		end
	end)
end

return FarmService
