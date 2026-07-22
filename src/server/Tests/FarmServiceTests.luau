--!strict

local Players = game:GetService("Players")

local ServerRoot = script.Parent.Parent
local FarmService = require(ServerRoot.Services.FarmService)

local FarmServiceTests = {}

local function expect(condition: boolean, message: string)
	if not condition then
		error(message, 2)
	end
end

local function makePlotService()
	local service = {
		assignCount = 0,
		releaseCount = 0,
	}
	function service:assign(_player: any)
		self.assignCount += 1
		return {} :: any
	end
	function service:release(_player: any)
		self.releaseCount += 1
	end
	return service
end

local function makeRepository(loadBehavior: (any, any) -> (boolean, string?))
	local repository = {
		profiles = {},
		loadCount = 0,
		releaseCount = 0,
	}
	function repository:getProfile(player: any)
		return self.profiles[player]
	end
	function repository:load(player: any)
		self.loadCount += 1
		return loadBehavior(self, player)
	end
	function repository:release(player: any)
		self.releaseCount += 1
		self.profiles[player] = nil
	end
	return repository
end

local function makeService(repository: any, plotService: any)
	local service = FarmService.new(repository, plotService)
	local sent = 0
	service._sendState = function(_self: any, _player: any, _result: any)
		sent += 1
	end
	return service, function()
		return sent
	end
end

function FarmServiceTests.run()
	local passed = {}

	local sequentialRepository = makeRepository(function(self, player)
		self.profiles[player] = { profileRevision = 0 }
		return true, nil
	end)
	local sequentialPlot = makePlotService()
	local sequentialService, sequentialSent = makeService(sequentialRepository, sequentialPlot)
	local sequentialPlayer = { Parent = Players }
	sequentialService:_loadPlayer(sequentialPlayer :: any)
	sequentialService:_loadPlayer(sequentialPlayer :: any)
	expect(sequentialRepository.loadCount == 1, "sequential duplicate load must not create a second repository session")
	expect(sequentialPlot.assignCount == 1 and sequentialSent() == 1, "sequential duplicate load must not repeat plot/UI setup")
	table.insert(passed, "sequential-duplicate-load-guard")

	local enteredLoad = false
	local releaseLoad = false
	local overlappingRepository = makeRepository(function(self, player)
		enteredLoad = true
		while not releaseLoad do
			task.wait()
		end
		self.profiles[player] = { profileRevision = 0 }
		return true, nil
	end)
	local overlappingPlot = makePlotService()
	local overlappingService = makeService(overlappingRepository, overlappingPlot)
	local overlappingPlayer = { Parent = Players }
	local firstFinished = false
	task.spawn(function()
		overlappingService:_loadPlayer(overlappingPlayer :: any)
		firstFinished = true
	end)
	local deadline = os.clock() + 2
	while not enteredLoad and os.clock() < deadline do
		task.wait()
	end
	expect(enteredLoad, "first overlapping load did not enter repository")
	overlappingService:_loadPlayer(overlappingPlayer :: any)
	expect(overlappingRepository.loadCount == 1, "overlapping duplicate load must be rejected while the first is in flight")
	releaseLoad = true
	deadline = os.clock() + 2
	while not firstFinished and os.clock() < deadline do
		task.wait()
	end
	expect(firstFinished and overlappingPlot.assignCount == 1, "first overlapping load should finish once")
	table.insert(passed, "overlapping-duplicate-load-guard")

	local departedSuccessRepository = makeRepository(function(self, player)
		self.profiles[player] = { profileRevision = 0 }
		return true, nil
	end)
	local departedSuccessPlot = makePlotService()
	local departedSuccessService, departedSuccessSent = makeService(departedSuccessRepository, departedSuccessPlot)
	local departedSuccessPlayer = { Parent = nil }
	departedSuccessService:_loadPlayer(departedSuccessPlayer :: any)
	expect(departedSuccessRepository.releaseCount == 1, "successful load for departed player must release immediately")
	expect(departedSuccessPlot.assignCount == 0 and departedSuccessSent() == 0, "departed successful load must not assign a plot or send UI")
	table.insert(passed, "departed-successful-load-cleanup")

	local departedFailureRepository = makeRepository(function(_self, _player)
		return false, "LOAD_FAILED"
	end)
	local departedFailurePlot = makePlotService()
	local departedFailureService, departedFailureSent = makeService(departedFailureRepository, departedFailurePlot)
	local departedFailurePlayer = { Parent = nil }
	departedFailureService:_loadPlayer(departedFailurePlayer :: any)
	expect(departedFailureRepository.releaseCount == 1, "failed load for departed player must remove its non-writable session entry")
	expect(departedFailurePlot.assignCount == 0 and departedFailureSent() == 0, "departed failed load must not assign a plot or send UI")
	table.insert(passed, "departed-failed-load-cleanup")

	local forageRepository = makeRepository(function()
		return false, "UNUSED"
	end)
	local forageService = FarmService.new(forageRepository, makePlotService())
	local clientForage, clientForageError = forageService:_prepareCommand({} :: any, {
		action = "ForageSeed",
		requestId = "client-forage-0001",
		expectedProfileRevision = 0,
		nodeId = "wild-sprout-1",
		definitionId = "sunspud",
	})
	expect(clientForage == nil and clientForageError == "INVALID_REQUEST", "client-authored forage rewards must fail without the server grant token")
	local serverForage, serverForageError = forageService:_prepareCommand({} :: any, {
		action = "ForageSeed",
		requestId = "server-forage-0001",
		expectedProfileRevision = 0,
		nodeId = "wild-sprout-1",
		definitionId = "sunspud",
		_forageGrantToken = forageService._forageGrantToken,
	})
	expect(serverForage ~= nil and serverForageError == nil and serverForage.nodeId == "wild-sprout-1", "server forage callback should prepare one allowlisted reward")
	table.insert(passed, "forage-server-grant-token")

	local sellPlayer = {} :: any
	local unequippedSell, unequippedSellError = forageService:_prepareCommand(sellPlayer, {
		action = "SellItem",
		requestId = "sell-not-equipped-0001",
		expectedProfileRevision = 0,
		itemId = "held-item",
		expectedItemRevision = 2,
	})
	expect(unequippedSell == nil and unequippedSellError == "ITEM_NOT_EQUIPPED", "single sale must reject an owned but unequipped item")
	forageService._equippedItemId[sellPlayer] = "held-item"
	local equippedSell, equippedSellError = forageService:_prepareCommand(sellPlayer, {
		action = "SellItem",
		requestId = "sell-equipped-0001",
		expectedProfileRevision = 0,
		itemId = "held-item",
		expectedItemRevision = 2,
	})
	expect(equippedSell ~= nil and equippedSellError == nil and equippedSell.itemId == "held-item", "single sale should prepare only the server-tracked equipped item")
	table.insert(passed, "single-sale-requires-equipped-item")

	return {
		ok = true,
		passed = #passed,
		cases = passed,
	}
end

return table.freeze(FarmServiceTests)
