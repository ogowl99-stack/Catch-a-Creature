--!strict

local Cozzle = table.freeze({
	id = "cozzle",
	displayName = "Cozzle",
	version = 1,
	rarity = "Common",
	preferredPlantId = "hearthpetal",
	arrivalOffsetStuds = 7,
	arrivalDurationSeconds = 1.4,
	maxProjectedPerPlayer = 1,
})

return table.freeze({
	Cozzle = Cozzle,
	byId = table.freeze({
		cozzle = Cozzle,
	}),
	valuesStatus = "Experimental",
})
