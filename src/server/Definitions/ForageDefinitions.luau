--!strict

local ForageDefinitions = {}

local rarityOrder = table.freeze({
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Mythic",
})

local rarityWeights = table.freeze({
	Common = 7000,
	Uncommon = 2000,
	Rare = 700,
	Epic = 250,
	Legendary = 45,
	Mythic = 5,
})

local raritySet = {}
for _, rarity in rarityOrder do
	raritySet[rarity] = true
end

local spawnPoints = table.freeze({
	table.freeze({ id = "west-01", worldX = -416, worldZ = -20 }),
	table.freeze({ id = "west-02", worldX = -405, worldZ = 0 }),
	table.freeze({ id = "west-03", worldX = -406, worldZ = 20 }),
	table.freeze({ id = "west-04", worldX = -382, worldZ = -20 }),
	table.freeze({ id = "west-05", worldX = -376, worldZ = 0 }),
	table.freeze({ id = "west-06", worldX = -378, worldZ = 20 }),
	table.freeze({ id = "south-01", worldX = -28, worldZ = -440 }),
	table.freeze({ id = "south-02", worldX = 0, worldZ = -440 }),
	table.freeze({ id = "south-03", worldX = 28, worldZ = -440 }),
	table.freeze({ id = "south-04", worldX = -28, worldZ = -416 }),
	table.freeze({ id = "south-05", worldX = 0, worldZ = -416 }),
	table.freeze({ id = "south-06", worldX = 28, worldZ = -416 }),
	table.freeze({ id = "east-01", worldX = 395, worldZ = -40 }),
	table.freeze({ id = "east-02", worldX = 410, worldZ = -18 }),
	table.freeze({ id = "east-03", worldX = 395, worldZ = 0 }),
	table.freeze({ id = "east-04", worldX = 410, worldZ = 18 }),
	table.freeze({ id = "east-05", worldX = 395, worldZ = 40 }),
	table.freeze({ id = "east-06", worldX = 420, worldZ = 0 }),
})

local nodes = table.freeze({
	table.freeze({ id = "wild-sprout-1", initialSpawnIndex = 1 }),
	table.freeze({ id = "wild-sprout-2", initialSpawnIndex = 4 }),
	table.freeze({ id = "wild-sprout-3", initialSpawnIndex = 7 }),
	table.freeze({ id = "wild-sprout-4", initialSpawnIndex = 10 }),
	table.freeze({ id = "wild-sprout-5", initialSpawnIndex = 13 }),
	table.freeze({ id = "wild-sprout-6", initialSpawnIndex = 16 }),
})

local byNodeId = {}
for _, node in nodes do
	byNodeId[node.id] = node
end

function ForageDefinitions.isKnownRarity(value: any): boolean
	return type(value) == "string" and raritySet[value] == true
end

function ForageDefinitions.selectDefinition(random: any, orderedDefinitions: { any }, isEligible: (any) -> boolean): any?
	local pools = {}
	for _, rarity in rarityOrder do
		pools[rarity] = {}
	end
	for _, definition in orderedDefinitions do
		if definition.forageEnabled == true and raritySet[definition.seedRarity] and isEligible(definition) then
			table.insert(pools[definition.seedRarity], definition)
		end
	end

	local totalWeight = 0
	for _, rarity in rarityOrder do
		if #pools[rarity] > 0 then
			totalWeight += rarityWeights[rarity]
		end
	end
	if totalWeight <= 0 then
		return nil
	end

	local tierRoll = random:NextInteger(1, totalWeight)
	local selectedPool = nil
	for _, rarity in rarityOrder do
		local pool = pools[rarity]
		if #pool > 0 then
			tierRoll -= rarityWeights[rarity]
			if tierRoll <= 0 then
				selectedPool = pool
				break
			end
		end
	end
	if selectedPool == nil then
		return nil
	end
	return selectedPool[random:NextInteger(1, #selectedPool)]
end

function ForageDefinitions.selectRelocationIndex(random: any, currentIndex: number, occupiedByIndex: { [number]: boolean }): number?
	local eligible = {}
	for spawnIndex = 1, #spawnPoints do
		if spawnIndex ~= currentIndex and occupiedByIndex[spawnIndex] ~= true then
			table.insert(eligible, spawnIndex)
		end
	end
	if #eligible == 0 then
		return nil
	end
	return eligible[random:NextInteger(1, #eligible)]
end

ForageDefinitions.rarityOrder = rarityOrder
ForageDefinitions.rarityWeights = rarityWeights
ForageDefinitions.nodes = nodes
ForageDefinitions.spawnPoints = spawnPoints
ForageDefinitions.byNodeId = table.freeze(byNodeId)
ForageDefinitions.cooldownSeconds = 120
ForageDefinitions.maxActivationDistance = 12
ForageDefinitions.valuesStatus = "Experimental"

return table.freeze(ForageDefinitions)
