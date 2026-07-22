--!strict

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local ServerRoot = script.Parent.Parent
local CreatureDefinitions = require(ServerRoot.Definitions.CreatureDefinitions)
local PlantDefinitions = require(ServerRoot.Definitions.PlantDefinitions)

local CreatureWorldService = {}
CreatureWorldService.__index = CreatureWorldService

local RUNTIME_ROOT_NAME = "CatchACreature_Runtime_v1"

local function selectAttractor(profile: any): (string?, any?)
	local candidates = {}
	for itemId, item in profile.itemsById do
		local location = item.location
		if item.definitionId == PlantDefinitions.Hearthpetal.id and location and location.kind == "Plot" then
			table.insert(candidates, {
				itemId = itemId,
				item = item,
			})
		end
	end
	table.sort(candidates, function(left, right)
		local leftMatures = left.item.location.maturesAtUnix
		local rightMatures = right.item.location.maturesAtUnix
		if leftMatures == rightMatures then
			return left.itemId < right.itemId
		end
		return leftMatures < rightMatures
	end)
	local selected = candidates[1]
	return if selected then selected.itemId else nil, if selected then selected.item else nil
end

local function makeVisualPart(
	model: Model,
	name: string,
	size: Vector3,
	color: Color3,
	finalCFrame: CFrame,
	material: Enum.Material?,
	finalTransparency: number?
): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Shape = Enum.PartType.Ball
	part.Size = size
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = true
	part.Transparency = 1
	part.CFrame = finalCFrame + Vector3.new(0, 5, 0)
	part:SetAttribute("ArrivalTarget", finalCFrame)
	part:SetAttribute("ArrivalTransparency", finalTransparency or 0)
	part.Parent = model
	return part
end

local function addCozzleVisual(model: Model, targetPosition: Vector3, lookAtPosition: Vector3): BasePart
	local flatLookAt = Vector3.new(lookAtPosition.X, targetPosition.Y, lookAtPosition.Z)
	if (flatLookAt - targetPosition).Magnitude < 0.01 then
		flatLookAt = targetPosition + Vector3.new(0, 0, -1)
	end
	local base = CFrame.lookAt(targetPosition, flatLookAt)
	local fur = Color3.fromRGB(215, 155, 105)
	local lightFur = Color3.fromRGB(255, 220, 172)
	local darkFur = Color3.fromRGB(133, 87, 63)
	local leaf = Color3.fromRGB(113, 174, 105)

	local body = makeVisualPart(model, "Body", Vector3.new(3.5, 2.8, 3.8), fur, base * CFrame.new(0, 1.65, 0))
	makeVisualPart(model, "Belly", Vector3.new(2.25, 1.75, 0.45), lightFur, base * CFrame.new(0, 1.45, -1.73))
	makeVisualPart(model, "Head", Vector3.new(2.75, 2.45, 2.65), fur, base * CFrame.new(0, 3.45, -0.72))
	makeVisualPart(model, "Muzzle", Vector3.new(1.35, 0.9, 0.55), lightFur, base * CFrame.new(0, 3.1, -2.02))
	makeVisualPart(model, "Nose", Vector3.new(0.38, 0.28, 0.25), darkFur, base * CFrame.new(0, 3.28, -2.34))
	makeVisualPart(model, "EyeLeft", Vector3.new(0.32, 0.46, 0.25), Color3.fromRGB(62, 48, 43), base * CFrame.new(-0.58, 3.68, -2.03))
	makeVisualPart(model, "EyeRight", Vector3.new(0.32, 0.46, 0.25), Color3.fromRGB(62, 48, 43), base * CFrame.new(0.58, 3.68, -2.03))
	makeVisualPart(model, "CheekLeft", Vector3.new(0.42, 0.24, 0.18), Color3.fromRGB(247, 154, 145), base * CFrame.new(-0.9, 3.18, -2.02), Enum.Material.SmoothPlastic, 0.1)
	makeVisualPart(model, "CheekRight", Vector3.new(0.42, 0.24, 0.18), Color3.fromRGB(247, 154, 145), base * CFrame.new(0.9, 3.18, -2.02), Enum.Material.SmoothPlastic, 0.1)
	makeVisualPart(model, "EarLeft", Vector3.new(0.8, 1.5, 0.65), darkFur, base * CFrame.new(-0.92, 4.65, -0.48) * CFrame.Angles(0, 0, math.rad(-22)))
	makeVisualPart(model, "EarRight", Vector3.new(0.8, 1.5, 0.65), darkFur, base * CFrame.new(0.92, 4.65, -0.48) * CFrame.Angles(0, 0, math.rad(22)))
	makeVisualPart(model, "LeafTuftLeft", Vector3.new(0.78, 0.22, 1.1), leaf, base * CFrame.new(-0.34, 4.85, -0.8) * CFrame.Angles(math.rad(-12), math.rad(-28), math.rad(-12)))
	makeVisualPart(model, "LeafTuftRight", Vector3.new(0.78, 0.22, 1.1), leaf, base * CFrame.new(0.34, 4.85, -0.8) * CFrame.Angles(math.rad(-12), math.rad(28), math.rad(12)))
	makeVisualPart(model, "FootLeft", Vector3.new(1.15, 0.7, 1.45), darkFur, base * CFrame.new(-0.82, 0.45, -0.82))
	makeVisualPart(model, "FootRight", Vector3.new(1.15, 0.7, 1.45), darkFur, base * CFrame.new(0.82, 0.45, -0.82))
	makeVisualPart(model, "Tail", Vector3.new(1.55, 1.55, 1.55), lightFur, base * CFrame.new(0, 1.85, 1.82))
	return body
end

local function animateArrival(model: Model, primary: BasePart, duration: number)
	local info = TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			local target = descendant:GetAttribute("ArrivalTarget")
			local finalTransparency = descendant:GetAttribute("ArrivalTransparency")
			if typeof(target) == "CFrame" and type(finalTransparency) == "number" then
				TweenService:Create(descendant, info, {
					CFrame = target,
					Transparency = finalTransparency,
				}):Play()
			end
		end
	end

	local glow = Instance.new("Part")
	glow.Name = "ArrivalGlow"
	glow.Shape = Enum.PartType.Ball
	glow.Size = Vector3.new(1, 1, 1)
	glow.CFrame = primary:GetAttribute("ArrivalTarget")
	glow.Color = Color3.fromRGB(255, 214, 132)
	glow.Material = Enum.Material.Neon
	glow.Anchored = true
	glow.CanCollide = false
	glow.CanQuery = false
	glow.CanTouch = false
	glow.Transparency = 0.25
	glow.Parent = model
	TweenService:Create(glow, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = Vector3.new(7, 7, 7),
		Transparency = 1,
	}):Play()
	task.delay(duration + 0.1, function()
		if glow.Parent then
			glow:Destroy()
		end
	end)
end

function CreatureWorldService.new(plotService: any)
	local runtimeRoot = workspace:FindFirstChild(RUNTIME_ROOT_NAME)
	if runtimeRoot == nil then
		runtimeRoot = Instance.new("Folder")
		runtimeRoot.Name = RUNTIME_ROOT_NAME
		runtimeRoot.Parent = workspace
	end
	local existing = runtimeRoot:FindFirstChild("Creatures")
	if existing then
		existing:Destroy()
	end
	local root = Instance.new("Folder")
	root.Name = "Creatures"
	root:SetAttribute("TruthLabel", "Simulated")
	root:SetAttribute("OwnershipStatus", "WildUnownedOnly")
	root.Parent = runtimeRoot

	local self = setmetatable({
		_root = root,
		_plotService = plotService,
		_pending = {},
		_running = true,
	}, CreatureWorldService)

	task.spawn(function()
		while self._running and self._root.Parent ~= nil do
			local nowUnix = os.time()
			for player, record in self._pending do
				if player.Parent ~= Players then
					self._pending[player] = nil
				elseif nowUnix >= record.spawnAtUnix then
					self._pending[player] = nil
					self:_spawnCozzle(player, record)
				end
			end
			task.wait(0.25)
		end
	end)

	return self
end

function CreatureWorldService:_playerFolder(player: Player): Folder?
	return self._root:FindFirstChild(tostring(player.UserId)) :: Folder?
end

function CreatureWorldService:_spawnCozzle(player: Player, record: any)
	local existingFolder = self:_playerFolder(player)
	if existingFolder then
		existingFolder:Destroy()
	end
	local playerFolder = Instance.new("Folder")
	playerFolder.Name = tostring(player.UserId)
	playerFolder:SetAttribute("OwnerUserId", player.UserId)
	playerFolder.Parent = self._root

	local definition = CreatureDefinitions.Cozzle
	local model = Instance.new("Model")
	model.Name = definition.displayName .. "_Wild"
	model:SetAttribute("CreatureDefinitionId", definition.id)
	model:SetAttribute("CreatureDefinitionVersion", definition.version)
	model:SetAttribute("AttractorItemId", record.attractorItemId)
	model:SetAttribute("Wild", true)
	model:SetAttribute("Owned", false)
	model:SetAttribute("CaptureEnabled", false)
	model:SetAttribute("TruthLabel", "Simulated")
	model.Parent = playerFolder

	local primary = addCozzleVisual(model, record.targetPosition, record.attractorPosition)
	model.PrimaryPart = primary

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "VisitorLabel"
	billboard.Size = UDim2.fromOffset(190, 48)
	billboard.StudsOffset = Vector3.new(0, 5.7, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 90
	billboard.Parent = primary
	local label = Instance.new("TextLabel")
	label.BackgroundColor3 = Color3.fromRGB(255, 244, 219)
	label.BackgroundTransparency = 0.08
	label.Size = UDim2.fromScale(1, 1)
	label.Font = Enum.Font.GothamBold
	label.Text = "COZZLE  |  WILD VISITOR\nAttracted by Hearthpetal"
	label.TextColor3 = Color3.fromRGB(94, 64, 52)
	label.TextScaled = true
	label.Parent = billboard
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = label

	animateArrival(model, primary, definition.arrivalDurationSeconds)
end

function CreatureWorldService:destroyPlayer(player: Player)
	self._pending[player] = nil
	local folder = self:_playerFolder(player)
	if folder then
		folder:Destroy()
	end
end

function CreatureWorldService:rebuildPlayer(player: Player, profile: any)
	local attractorItemId, attractor = selectAttractor(profile)
	if attractorItemId == nil or attractor == nil then
		self:destroyPlayer(player)
		return
	end

	local existingFolder = self:_playerFolder(player)
	local existingModel = if existingFolder then existingFolder:FindFirstChildOfClass("Model") else nil
	if existingModel and existingModel:GetAttribute("AttractorItemId") == attractorItemId then
		self._pending[player] = nil
		return
	end
	local pending = self._pending[player]
	if pending and pending.attractorItemId == attractorItemId then
		return
	end
	self:destroyPlayer(player)

	local location = attractor.location
	local attractorPosition = self._plotService:worldPosition(player, location.localXMilli, location.localZMilli)
	if attractorPosition == nil then
		return
	end
	local attractorLocal = Vector2.new(location.localXMilli / 1000, location.localZMilli / 1000)
	local towardCenter = -attractorLocal
	if towardCenter.Magnitude < 0.01 then
		towardCenter = Vector2.new(1, 0)
	end
	local inward = towardCenter.Unit
	local tangent = Vector2.new(-inward.Y, inward.X)
	local definition = CreatureDefinitions.Cozzle
	local offsetComponent = definition.arrivalOffsetStuds / math.sqrt(2)
	local targetLocal = attractorLocal + inward * offsetComponent + tangent * offsetComponent
	local targetPosition = self._plotService:worldPosition(player, math.round(targetLocal.X * 1000), math.round(targetLocal.Y * 1000))
	if targetPosition == nil then
		return
	end
	self._pending[player] = {
		attractorItemId = attractorItemId,
		attractorPosition = attractorPosition,
		targetPosition = targetPosition,
		spawnAtUnix = location.maturesAtUnix + PlantDefinitions.Hearthpetal.visitorDelaySeconds,
	}
end

function CreatureWorldService:destroy()
	self._running = false
	table.clear(self._pending)
	if self._root.Parent then
		self._root:Destroy()
	end
end

CreatureWorldService.selectAttractor = selectAttractor

return CreatureWorldService
