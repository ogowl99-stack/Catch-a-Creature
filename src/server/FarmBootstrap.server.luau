--!strict

local ServerRoot = script.Parent
local ProfileRepository = require(ServerRoot.Data.ProfileRepository)
local PlotService = require(ServerRoot.Services.PlotService)
local PlantWorldService = require(ServerRoot.Services.PlantWorldService)
local CreatureWorldService = require(ServerRoot.Services.CreatureWorldService)
local FarmService = require(ServerRoot.Services.FarmService)
local ForageWorldService = require(ServerRoot.Services.ForageWorldService)

local profileRepository = ProfileRepository.new()
local plotService = PlotService.new()
local farmService = FarmService.new(profileRepository, plotService)
local worldService = PlantWorldService.new(plotService, function(player, itemId, itemRevision)
	farmService:promptHarvest(player, itemId, itemRevision)
end)
local creatureWorldService = CreatureWorldService.new(plotService)
local forageWorldService = ForageWorldService.new(function(player, nodeId)
	return farmService:forageSeed(player, nodeId)
end)

farmService:setWorldService(worldService)
farmService:setCreatureWorldService(creatureWorldService)
forageWorldService:start()
farmService:start()

print("[CatchACreature] Hearthpetal/Cozzle and seed-foraging slices started (" .. profileRepository:getMode() .. ")")
