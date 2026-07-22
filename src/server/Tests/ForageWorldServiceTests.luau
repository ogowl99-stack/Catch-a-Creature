--!strict

local ServerRoot = script.Parent.Parent
local ForageDefinitions = require(ServerRoot.Definitions.ForageDefinitions)
local PlantDefinitions = require(ServerRoot.Definitions.PlantDefinitions)
local ForageWorldService = require(ServerRoot.Services.ForageWorldService)

local ForageWorldServiceTests = {}

local function expect(condition: boolean, message: string)
	if not condition then
		error(message, 2)
	end
end

local function sequenceRandom(values: { number })
	local index = 0
	return {
		NextInteger = function(_self: any, minimum: number, maximum: number)
			index += 1
			local value = values[index]
			expect(type(value) == "number" and value >= minimum and value <= maximum, string.format("fake roll %s outside %d-%d", tostring(value), minimum, maximum))
			return value
		end,
	}
end

function ForageWorldServiceTests.run()
	local passed = {}

	local nodeIds = {}
	for _, node in ForageDefinitions.nodes do
		expect(nodeIds[node.id] == nil, "forage node IDs must be unique")
		nodeIds[node.id] = true
	end
	expect(#ForageDefinitions.nodes == 6, "first forage slice should create exactly six bounded nodes")
	expect(#ForageDefinitions.spawnPoints == 18, "active sprouts need a larger relocation pool")
	table.insert(passed, "six-unique-nodes")

	local occupied = { [1] = true, [4] = true, [7] = true, [10] = true, [13] = true, [16] = true }
	local relocatedIndex = ForageDefinitions.selectRelocationIndex(sequenceRandom({ 1 }), 1, occupied)
	expect(relocatedIndex == 2, "relocation should choose the first free point in the deterministic fixture")
	expect(relocatedIndex ~= 1 and occupied[relocatedIndex] ~= true, "relocation must never use the same or an occupied point")
	local allOccupied = {}
	for spawnIndex = 1, #ForageDefinitions.spawnPoints do
		allOccupied[spawnIndex] = true
	end
	expect(ForageDefinitions.selectRelocationIndex(sequenceRandom({}), 1, allOccupied) == nil, "relocation should fail safely when no point is free")
	table.insert(passed, "relocation-never-same-location")

	local syntheticDefinitions = {
		{ id = "common", seedRarity = "Common", forageEnabled = true },
		{ id = "uncommon", seedRarity = "Uncommon", forageEnabled = true },
		{ id = "rare", seedRarity = "Rare", forageEnabled = true },
		{ id = "epic", seedRarity = "Epic", forageEnabled = true },
		{ id = "legendary", seedRarity = "Legendary", forageEnabled = true },
		{ id = "mythic", seedRarity = "Mythic", forageEnabled = true },
	}
	local common = ForageDefinitions.selectDefinition(sequenceRandom({ 7000, 1 }), syntheticDefinitions, function()
		return true
	end)
	expect(common and common.id == "common", "common upper boundary should select Common")
	local uncommon = ForageDefinitions.selectDefinition(sequenceRandom({ 7001, 1 }), syntheticDefinitions, function()
		return true
	end)
	expect(uncommon and uncommon.id == "uncommon", "next roll should select Uncommon")
	local mythic = ForageDefinitions.selectDefinition(sequenceRandom({ 10000, 1 }), syntheticDefinitions, function()
		return true
	end)
	expect(mythic and mythic.id == "mythic", "highest roll should select Mythic")
	table.insert(passed, "rarity-golden-boundaries")

	local currentCommon = ForageDefinitions.selectDefinition(sequenceRandom({ 7000, 1 }), PlantDefinitions.ordered, function()
		return true
	end)
	local currentUncommon = ForageDefinitions.selectDefinition(sequenceRandom({ 7001, 1 }), PlantDefinitions.ordered, function()
		return true
	end)
	expect(currentCommon and currentCommon.id == "sunspud", "current Common pool should select Sunspud")
	expect(currentUncommon and currentUncommon.id == "hearthpetal", "current Uncommon pool should select Hearthpetal")
	table.insert(passed, "current-seed-pools")

	local onlyHearthpetal = ForageDefinitions.selectDefinition(sequenceRandom({ 1, 1 }), PlantDefinitions.ordered, function(definition)
		return definition.id == "hearthpetal"
	end)
	expect(onlyHearthpetal and onlyHearthpetal.id == "hearthpetal", "ineligible seed stacks must be excluded before rarity selection")
	table.insert(passed, "eligible-pool-only")

	local noReward = ForageDefinitions.selectDefinition(sequenceRandom({}), PlantDefinitions.ordered, function()
		return false
	end)
	expect(noReward == nil, "empty eligible pools must return no reward without RNG")
	table.insert(passed, "empty-pool-no-roll")

	expect(ForageWorldService.isWithinDistance(Vector3.zero, Vector3.new(12, 0, 0), 12), "distance boundary should be inclusive")
	expect(not ForageWorldService.isWithinDistance(Vector3.zero, Vector3.new(12.01, 0, 0), 12), "distance beyond boundary should fail")
	expect(not ForageWorldService.isWithinDistance("forged", Vector3.zero, 12), "non-Vector3 positions should fail closed")
	table.insert(passed, "server-distance-boundary")

	return {
		ok = true,
		passed = #passed,
		cases = passed,
	}
end

return table.freeze(ForageWorldServiceTests)
