--!strict

local FarmContracts = {}

FarmContracts.Actions = table.freeze({
	BuySeed = "BuySeed",
	PlaceSeed = "PlaceSeed",
	HarvestPlant = "HarvestPlant",
	EquipHotbarSlot = "EquipHotbarSlot",
	SellItem = "SellItem",
	SellAllUnfavorited = "SellAllUnfavorited",
	ToggleFavoriteItem = "ToggleFavoriteItem",
	UnassignHotbarSlot = "UnassignHotbarSlot",
	AssignHotbarItem = "AssignHotbarItem",
	ForageSeed = "ForageSeed",
	Travel = "Travel",
})

FarmContracts.Codes = table.freeze({
	Ok = "OK",
	Busy = "BUSY",
	InvalidRequest = "INVALID_REQUEST",
	InvalidAction = "INVALID_ACTION",
	RequestIdConflict = "REQUEST_ID_CONFLICT",
	StaleRevision = "STALE_REVISION",
	ProfileUnavailable = "PROFILE_UNAVAILABLE",
	PersistenceUnavailable = "PERSISTENCE_UNAVAILABLE",
	PlotUnavailable = "PLOT_UNAVAILABLE",
	InvalidPlacement = "INVALID_PLACEMENT",
	DuplicatePlacement = "DUPLICATE_PLACEMENT",
	PlantLimit = "PLANT_LIMIT",
	InsufficientFunds = "INSUFFICIENT_FUNDS",
	SeedStackFull = "SEED_STACK_FULL",
	NoSeed = "NO_SEED",
	ItemNotFound = "ITEM_NOT_FOUND",
	ItemStateInvalid = "ITEM_STATE_INVALID",
	ItemFavorite = "ITEM_FAVORITE",
	ItemNotEquipped = "ITEM_NOT_EQUIPPED",
	NoSellableItems = "NO_SELLABLE_ITEMS",
	NoChange = "NO_CHANGE",
	HotbarFull = "HOTBAR_FULL",
	NotMature = "NOT_MATURE",
	BackpackFull = "BACKPACK_FULL",
	InvalidTravelTarget = "INVALID_TRAVEL_TARGET",
	ForageCooldown = "FORAGE_COOLDOWN",
	NoForageReward = "NO_FORAGE_REWARD",
	InternalError = "INTERNAL_ERROR",
})

FarmContracts.TravelTargets = table.freeze({
	Shop = "Shop",
	Plot = "Plot",
	Sell = "Sell",
})

FarmContracts.RequestIdPattern = "^[%w%-_]+$"
FarmContracts.RequestIdMinLength = 8
FarmContracts.RequestIdMaxLength = 64

return table.freeze(FarmContracts)
