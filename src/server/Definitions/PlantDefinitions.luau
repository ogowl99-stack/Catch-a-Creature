--!strict

local Sunspud = table.freeze({
	id = "sunspud",
	displayName = "Sunspud",
	version = 1,
	harvestMode = "SingleHarvest",
	growthSeconds = 45,
	seedPrice = 5,
	baseSaleValue = 8,
	weightMinMilli = 800,
	weightMaxMilli = 1200,
	maxSeedStack = 999,
	maxDeployedPerPlayer = 24,
	positionStepMilli = 250,
	gridStepMilli = 1000,
	footprintRadiusMilli = 2000,
	seedRarity = "Common",
	forageEnabled = true,
})

local Hearthpetal = table.freeze({
	id = "hearthpetal",
	displayName = "Hearthpetal",
	version = 1,
	harvestMode = "SingleHarvest",
	growthSeconds = 60,
	seedPrice = 8,
	baseSaleValue = 14,
	weightMinMilli = 650,
	weightMaxMilli = 1050,
	maxSeedStack = 999,
	maxDeployedPerPlayer = 24,
	positionStepMilli = 250,
	gridStepMilli = 1000,
	footprintRadiusMilli = 2200,
	attractsCreatureId = "cozzle",
	visitorDelaySeconds = 3,
	seedRarity = "Uncommon",
	forageEnabled = true,
})

local byId = table.freeze({
	sunspud = Sunspud,
	hearthpetal = Hearthpetal,
})

return table.freeze({
	Sunspud = Sunspud,
	Hearthpetal = Hearthpetal,
	byId = byId,
	ordered = table.freeze({ Sunspud, Hearthpetal }),
	seedSlotsByDefinitionId = table.freeze({
		sunspud = 1,
		hearthpetal = 2,
	}),
	startingLeafnotes = 10,
	baseBackpackCapacity = 200,
	maxDeployedPlantsPerPlayer = 24,
	maxRecentCommands = 64,
	valuesStatus = "Experimental",
})
