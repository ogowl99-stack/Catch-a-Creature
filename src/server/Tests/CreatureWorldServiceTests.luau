--!strict

local ServerRoot = script.Parent.Parent
local CreatureWorldService = require(ServerRoot.Services.CreatureWorldService)
local ProfileSchema = require(ServerRoot.Data.ProfileSchema)

local CreatureWorldServiceTests = {}

local function expect(condition: boolean, message: string)
	if not condition then
		error(message, 2)
	end
end

local function plottedItem(itemId: string, definitionId: string, maturesAtUnix: number)
	return {
		id = itemId,
		kind = "Plant",
		definitionId = definitionId,
		definitionVersion = 1,
		revision = 1,
		weightMilli = if definitionId == "hearthpetal" then 800 else 1000,
		favorite = false,
		origin = {
			kind = "PlacedFromSeed",
			createdAtUnix = 10,
		},
		location = {
			kind = "Plot",
			localXMilli = 0,
			localZMilli = 0,
			plantedAtUnix = 10,
			maturesAtUnix = maturesAtUnix,
		},
	}
end

function CreatureWorldServiceTests.run()
	local passed = {}

	local empty = ProfileSchema.new(10)
	local emptyId = CreatureWorldService.selectAttractor(empty)
	expect(emptyId == nil, "a profile without Hearthpetal must not project Cozzle")
	table.insert(passed, "no-hearthpetal-no-attractor")

	local sunspudOnly = ProfileSchema.new(10)
	sunspudOnly.itemsById.sun = plottedItem("sun", "sunspud", 70)
	local sunspudId = CreatureWorldService.selectAttractor(sunspudOnly)
	expect(sunspudId == nil, "Sunspud must not attract Cozzle")
	table.insert(passed, "sunspud-does-not-attract-cozzle")

	local mixed = ProfileSchema.new(10)
	mixed.itemsById.later = plottedItem("later", "hearthpetal", 90)
	mixed.itemsById.earlier = plottedItem("earlier", "hearthpetal", 80)
	mixed.itemsById.sun = plottedItem("sun", "sunspud", 70)
	local selectedId, selectedItem = CreatureWorldService.selectAttractor(mixed)
	expect(selectedId == "earlier" and selectedItem == mixed.itemsById.earlier, "earliest Hearthpetal maturity should deterministically attract the one projected Cozzle")
	table.insert(passed, "earliest-hearthpetal-attractor")

	local tied = ProfileSchema.new(10)
	tied.itemsById.zeta = plottedItem("zeta", "hearthpetal", 80)
	tied.itemsById.alpha = plottedItem("alpha", "hearthpetal", 80)
	local tiedId = CreatureWorldService.selectAttractor(tied)
	expect(tiedId == "alpha", "equal maturity must use item ID as a stable tie-break")
	table.insert(passed, "stable-attractor-tie-break")

	local harvested = ProfileSchema.clone(mixed)
	harvested.itemsById.earlier.location = {
		kind = "Backpack",
		harvestedAtUnix = 81,
	}
	local fallbackId = CreatureWorldService.selectAttractor(harvested)
	expect(fallbackId == "later", "harvesting the active attractor should select the next plotted Hearthpetal")
	table.insert(passed, "harvested-attractor-is-not-projected")

	return {
		ok = true,
		passed = #passed,
		cases = passed,
	}
end

return table.freeze(CreatureWorldServiceTests)
