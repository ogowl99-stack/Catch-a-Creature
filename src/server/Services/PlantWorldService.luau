--!strict

local ServerRoot = script.Parent.Parent
local PlantDefinitions = require(ServerRoot.Definitions.PlantDefinitions)

local PlantWorldService = {}
PlantWorldService.__index = PlantWorldService

local RUNTIME_ROOT_NAME = "CatchACreature_Runtime_v1"

local function makePart(parent: Instance, name: string, color: Color3): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = false
	part.Material = Enum.Material.SmoothPlastic
	part.Color = color
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function updateSunspud(model: Model, basePosition: Vector3, progress: number)
	local scale = 0.2 + progress * 0.8
	local tuber = model:FindFirstChild("Tuber") :: Part?
	local stem = model:FindFirstChild("Stem") :: Part?
	local leafA = model:FindFirstChild("LeafA") :: Part?
	local leafB = model:FindFirstChild("LeafB") :: Part?
	if tuber == nil or stem == nil or leafA == nil or leafB == nil then
		return
	end

	tuber.Shape = Enum.PartType.Ball
	tuber.Size = Vector3.new(3, 2.6, 3) * scale
	tuber.CFrame = CFrame.new(basePosition + Vector3.new(0, tuber.Size.Y * 0.42, 0))

	local stemHeight = 0.4 + progress * 2.8
	stem.Size = Vector3.new(0.35 + progress * 0.2, stemHeight, 0.35 + progress * 0.2)
	stem.CFrame = CFrame.new(basePosition + Vector3.new(0, tuber.Size.Y * 0.65 + stemHeight / 2, 0))

	local leafSize = Vector3.new(1.8, 0.22, 0.7) * scale
	leafA.Size = leafSize
	leafB.Size = leafSize
	local leafHeight = basePosition.Y + tuber.Size.Y * 0.65 + stemHeight * 0.72
	leafA.CFrame = CFrame.new(basePosition.X, leafHeight, basePosition.Z) * CFrame.Angles(0, math.rad(25), math.rad(18)) * CFrame.new(leafSize.X * 0.42, 0, 0)
	leafB.CFrame = CFrame.new(basePosition.X, leafHeight - 0.15, basePosition.Z) * CFrame.Angles(0, math.rad(205), math.rad(18)) * CFrame.new(leafSize.X * 0.42, 0, 0)
end

local function updateHearthpetal(model: Model, basePosition: Vector3, progress: number)
	local scale = 0.18 + progress * 0.82
	local root = model:FindFirstChild("Root") :: Part?
	local stem = model:FindFirstChild("Stem") :: Part?
	local bloom = model:FindFirstChild("Bloom") :: Part?
	local leafA = model:FindFirstChild("LeafA") :: Part?
	local leafB = model:FindFirstChild("LeafB") :: Part?
	if root == nil or stem == nil or bloom == nil or leafA == nil or leafB == nil then
		return
	end

	root.Shape = Enum.PartType.Ball
	root.Size = Vector3.new(2.2, 1.1, 2.2) * scale
	root.CFrame = CFrame.new(basePosition + Vector3.new(0, root.Size.Y * 0.36, 0))

	local stemHeight = 0.5 + progress * 4.2
	stem.Shape = Enum.PartType.Cylinder
	stem.Size = Vector3.new(stemHeight, 0.42 + progress * 0.18, 0.42 + progress * 0.18)
	stem.CFrame = CFrame.new(basePosition + Vector3.new(0, root.Size.Y * 0.35 + stemHeight / 2, 0)) * CFrame.Angles(0, 0, math.rad(90))

	local bloomPosition = basePosition + Vector3.new(0, root.Size.Y * 0.35 + stemHeight + 0.25, 0)
	bloom.Shape = Enum.PartType.Ball
	bloom.Material = Enum.Material.Neon
	bloom.Size = Vector3.new(1.45, 1.45, 1.45) * scale
	bloom.CFrame = CFrame.new(bloomPosition)

	local leafSize = Vector3.new(1.9, 0.25, 0.75) * scale
	leafA.Size = leafSize
	leafB.Size = leafSize
	local leafHeight = basePosition.Y + root.Size.Y * 0.35 + stemHeight * 0.55
	leafA.CFrame = CFrame.new(basePosition.X, leafHeight, basePosition.Z) * CFrame.Angles(0, math.rad(28), math.rad(20)) * CFrame.new(leafSize.X * 0.42, 0, 0)
	leafB.CFrame = CFrame.new(basePosition.X, leafHeight - 0.2, basePosition.Z) * CFrame.Angles(0, math.rad(208), math.rad(20)) * CFrame.new(leafSize.X * 0.42, 0, 0)

	for petalIndex = 1, 6 do
		local petal = model:FindFirstChild("Petal" .. petalIndex) :: Part?
		if petal then
			local angle = (petalIndex - 1) * math.pi / 3
			local radius = 0.75 * scale
			petal.Shape = Enum.PartType.Ball
			petal.Size = Vector3.new(1.55, 0.42, 0.9) * scale
			petal.CFrame = CFrame.new(bloomPosition + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)) * CFrame.Angles(0, -angle, math.rad(12))
		end
	end
end

local function updatePlant(model: Model, nowUnix: number)
	local plantedAt = model:GetAttribute("PlantedAtUnix")
	local maturesAt = model:GetAttribute("MaturesAtUnix")
	local basePosition = model:GetAttribute("BasePosition")
	local definitionId = model:GetAttribute("PlantDefinitionId")
	local definition = if type(definitionId) == "string" then PlantDefinitions.byId[definitionId] else nil
	if type(plantedAt) ~= "number" or type(maturesAt) ~= "number" or typeof(basePosition) ~= "Vector3" or definition == nil then
		return
	end
	local duration = math.max(1, maturesAt - plantedAt)
	local progress = math.clamp((nowUnix - plantedAt) / duration, 0, 1)
	if definition.id == PlantDefinitions.Hearthpetal.id then
		updateHearthpetal(model, basePosition, progress)
	else
		updateSunspud(model, basePosition, progress)
	end

	local ready = progress >= 1
	local highlight = model:FindFirstChildOfClass("Highlight")
	if highlight then
		highlight.Enabled = ready
	end
	local primary = model.PrimaryPart
	local prompt = if primary then primary:FindFirstChildOfClass("ProximityPrompt") else nil
	if prompt then
		prompt.Enabled = ready
	end
	local billboard = if primary then primary:FindFirstChildOfClass("BillboardGui") else nil
	local label = if billboard then billboard:FindFirstChildOfClass("TextLabel") else nil
	if label then
		label.Text = if ready then "READY TO HARVEST" else string.format("%s  %d%%", string.upper(definition.displayName), math.floor(progress * 100 + 0.5))
	end
end

local function createSunspudParts(model: Model): BasePart
	local tuber = makePart(model, "Tuber", Color3.fromRGB(245, 183, 56))
	makePart(model, "Stem", Color3.fromRGB(95, 155, 83))
	makePart(model, "LeafA", Color3.fromRGB(115, 181, 96))
	makePart(model, "LeafB", Color3.fromRGB(129, 194, 105))
	return tuber
end

local function createHearthpetalParts(model: Model): BasePart
	local root = makePart(model, "Root", Color3.fromRGB(97, 132, 83))
	makePart(model, "Stem", Color3.fromRGB(91, 158, 92))
	makePart(model, "LeafA", Color3.fromRGB(112, 184, 110))
	makePart(model, "LeafB", Color3.fromRGB(126, 198, 121))
	makePart(model, "Bloom", Color3.fromRGB(255, 218, 111))
	local petalColors = {
		Color3.fromRGB(255, 160, 143),
		Color3.fromRGB(255, 184, 151),
	}
	for petalIndex = 1, 6 do
		makePart(model, "Petal" .. petalIndex, petalColors[(petalIndex - 1) % #petalColors + 1])
	end
	return root
end

local function addPresentation(model: Model, primary: BasePart, definition: any, onHarvest: (Player) -> ())
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "HarvestPrompt"
	prompt.ActionText = "Harvest"
	prompt.ObjectText = definition.displayName
	prompt.HoldDuration = 0.35
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Enabled = false
	prompt.Parent = primary
	prompt.Triggered:Connect(onHarvest)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "GrowthLabel"
	billboard.Size = UDim2.fromOffset(190, 38)
	billboard.StudsOffset = Vector3.new(0, 5.2, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 80
	billboard.Parent = primary
	local textLabel = Instance.new("TextLabel")
	textLabel.BackgroundColor3 = Color3.fromRGB(255, 249, 223)
	textLabel.BackgroundTransparency = 0.08
	textLabel.Size = UDim2.fromScale(1, 1)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextColor3 = Color3.fromRGB(92, 65, 43)
	textLabel.TextScaled = true
	textLabel.Parent = billboard
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = textLabel

	local highlight = Instance.new("Highlight")
	highlight.Name = "MatureHighlight"
	highlight.FillColor = if definition.id == PlantDefinitions.Hearthpetal.id then Color3.fromRGB(255, 166, 145) else Color3.fromRGB(255, 218, 93)
	highlight.FillTransparency = 0.55
	highlight.OutlineColor = Color3.fromRGB(255, 247, 182)
	highlight.Enabled = false
	highlight.Parent = model
end

function PlantWorldService.new(plotService: any, onHarvest: (Player, string, number) -> ())
	local existing = workspace:FindFirstChild(RUNTIME_ROOT_NAME)
	if existing then
		existing:Destroy()
	end
	local root = Instance.new("Folder")
	root.Name = RUNTIME_ROOT_NAME
	root:SetAttribute("TruthLabel", "Simulated")
	root:SetAttribute("Purpose", "Phase 3 runtime projections")
	root.Parent = workspace

	local self = setmetatable({
		_root = root,
		_plotService = plotService,
		_onHarvest = onHarvest,
		_running = true,
	}, PlantWorldService)

	task.spawn(function()
		while self._running and self._root.Parent ~= nil do
			local nowUnix = os.time()
			for _, descendant in self._root:GetDescendants() do
				if descendant:IsA("Model") and descendant:GetAttribute("PlantItemId") ~= nil then
					updatePlant(descendant, nowUnix)
				end
			end
			task.wait(0.5)
		end
	end)

	return self
end

function PlantWorldService:destroyPlayer(player: Player)
	local folder = self._root:FindFirstChild("Plants_" .. tostring(player.UserId))
	if folder then
		folder:Destroy()
	end
end

function PlantWorldService:rebuildPlayer(player: Player, profile: any)
	self:destroyPlayer(player)
	local playerFolder = Instance.new("Folder")
	playerFolder.Name = "Plants_" .. tostring(player.UserId)
	playerFolder:SetAttribute("OwnerUserId", player.UserId)
	playerFolder.Parent = self._root

	for itemId, item in profile.itemsById do
		local location = item.location
		local definition = PlantDefinitions.byId[item.definitionId]
		if location and location.kind == "Plot" and definition then
			local basePosition = self._plotService:worldPosition(player, location.localXMilli, location.localZMilli)
			if basePosition then
				local model = Instance.new("Model")
				model.Name = definition.displayName .. "_" .. string.sub(itemId, 1, math.min(8, #itemId))
				model:SetAttribute("PlantItemId", itemId)
				model:SetAttribute("PlantDefinitionId", definition.id)
				model:SetAttribute("OwnerUserId", player.UserId)
				model:SetAttribute("ItemRevision", item.revision)
				model:SetAttribute("PlantedAtUnix", location.plantedAtUnix)
				model:SetAttribute("MaturesAtUnix", location.maturesAtUnix)
				model:SetAttribute("BasePosition", basePosition)
				model.Parent = playerFolder

				local primary = if definition.id == PlantDefinitions.Hearthpetal.id then createHearthpetalParts(model) else createSunspudParts(model)
				model.PrimaryPart = primary
				addPresentation(model, primary, definition, function(triggeringPlayer)
					self._onHarvest(triggeringPlayer, itemId, item.revision)
				end)
				updatePlant(model, os.time())
			end
		end
	end
end

function PlantWorldService:destroy()
	self._running = false
	if self._root.Parent then
		self._root:Destroy()
	end
end

return PlantWorldService
