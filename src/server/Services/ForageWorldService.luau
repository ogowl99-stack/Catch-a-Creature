--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerRoot = script.Parent.Parent
local ForageDefinitions = require(ServerRoot.Definitions.ForageDefinitions)

local ForageWorldService = {}
ForageWorldService.__index = ForageWorldService

local RUNTIME_ROOT_NAME = "CatchACreature_Runtime_v1"

local function makePart(parent: Instance, name: string, color: Color3, size: Vector3, cframe: CFrame): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = true
	part.CanTouch = false
	part.Color = color
	part.Material = Enum.Material.SmoothPlastic
	part.Size = size
	part.CFrame = cframe
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function groundPosition(graybox: Instance, worldX: number, worldZ: number): Vector3?
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = { graybox }
	local result = workspace:Raycast(Vector3.new(worldX, 200, worldZ), Vector3.new(0, -400, 0), params)
	return if result then result.Position else nil
end

local function createNodeModel(parent: Instance, node: any, position: Vector3): (Model, BasePart)
	local model = Instance.new("Model")
	model.Name = "Forage_" .. node.id
	model:SetAttribute("ForageNodeId", node.id)
	model:SetAttribute("CooldownSeconds", ForageDefinitions.cooldownSeconds)
	model:SetAttribute("ValuesStatus", ForageDefinitions.valuesStatus)
	model.Parent = parent

	local patch = makePart(
		model,
		"Patch",
		Color3.fromRGB(96, 147, 76),
		Vector3.new(0.34, 5.8, 5.8),
		CFrame.new(position + Vector3.new(0, 0.16, 0)) * CFrame.Angles(0, 0, math.rad(90))
	)
	patch.Shape = Enum.PartType.Cylinder
	patch.Material = Enum.Material.Grass

	for stemIndex, offset in {
		Vector3.new(-0.8, 0, 0.35),
		Vector3.new(0.7, 0, -0.35),
	} do
		local stemHeight = if stemIndex == 1 then 2.5 else 2.05
		local stem = makePart(
			model,
			"Stem" .. stemIndex,
			Color3.fromRGB(78, 134, 70),
			Vector3.new(stemHeight, 0.28, 0.28),
			CFrame.new(position + offset + Vector3.new(0, stemHeight / 2, 0)) * CFrame.Angles(0, 0, math.rad(90))
		)
		stem.Shape = Enum.PartType.Cylinder

		local leaf = makePart(
			model,
			"Leaf" .. stemIndex,
			Color3.fromRGB(132, 187, 101),
			Vector3.new(1.65, 0.22, 0.75),
			CFrame.new(position + offset + Vector3.new(if stemIndex == 1 then -0.55 else 0.55, stemHeight * 0.58, 0))
				* CFrame.Angles(0, math.rad(if stemIndex == 1 then -20 else 200), math.rad(18))
		)
		leaf.Shape = Enum.PartType.Ball
	end

	local budPosition = position + Vector3.new(-0.8, 2.85, 0.35)
	local bud = makePart(model, "SeedBud", Color3.fromRGB(255, 220, 111), Vector3.new(1.35, 1.6, 1.35), CFrame.new(budPosition))
	bud.Shape = Enum.PartType.Ball
	bud.Material = Enum.Material.Neon

	for moteIndex = 1, 3 do
		local angle = (moteIndex - 1) * math.pi * 2 / 3
		local mote = makePart(
			model,
			"Mote" .. moteIndex,
			Color3.fromRGB(255, 238, 166),
			Vector3.new(0.24, 0.24, 0.24),
			CFrame.new(budPosition + Vector3.new(math.cos(angle) * 1.15, 0.35 + moteIndex * 0.28, math.sin(angle) * 1.15))
		)
		mote.Shape = Enum.PartType.Ball
		mote.Material = Enum.Material.Neon
		mote.Transparency = 0.18
		mote.CanQuery = false
	end

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "CatchACreatureForage"
	prompt.ActionText = "Forage Seeds"
	prompt.ObjectText = "Wild Seed Sprout"
	prompt.HoldDuration = 0.65
	prompt.MaxActivationDistance = ForageDefinitions.maxActivationDistance
	prompt.RequiresLineOfSight = false
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
	prompt.Parent = bud

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ForageLabel"
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 70
	billboard.Size = UDim2.fromOffset(150, 34)
	billboard.StudsOffset = Vector3.new(0, 1.75, 0)
	billboard.Parent = bud
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.Font = Enum.Font.GothamBold
	label.Text = "WILD SEED SPROUT"
	label.TextColor3 = Color3.fromRGB(255, 246, 206)
	label.TextStrokeColor3 = Color3.fromRGB(64, 85, 50)
	label.TextStrokeTransparency = 0.15
	label.TextScaled = true
	label.Parent = billboard

	local highlight = Instance.new("Highlight")
	highlight.Name = "ForageGlow"
	highlight.Adornee = model
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.FillColor = Color3.fromRGB(252, 224, 126)
	highlight.FillTransparency = 0.72
	highlight.OutlineColor = Color3.fromRGB(255, 244, 196)
	highlight.OutlineTransparency = 0.2
	highlight.Parent = model

	model.PrimaryPart = patch
	return model, bud
end

function ForageWorldService.isWithinDistance(playerPosition: any, nodePosition: any, maximumDistance: number): boolean
	return typeof(playerPosition) == "Vector3"
		and typeof(nodePosition) == "Vector3"
		and type(maximumDistance) == "number"
		and maximumDistance >= 0
		and (playerPosition - nodePosition).Magnitude <= maximumDistance
end

function ForageWorldService.new(onForage: (Player, string) -> any)
	local runtimeRoot = workspace:FindFirstChild(RUNTIME_ROOT_NAME)
	if runtimeRoot == nil then
		runtimeRoot = Instance.new("Folder")
		runtimeRoot.Name = RUNTIME_ROOT_NAME
		runtimeRoot.Parent = workspace
	end
	local existing = runtimeRoot:FindFirstChild("ForageNodes")
	if existing then
		existing:Destroy()
	end
	local root = Instance.new("Folder")
	root.Name = "ForageNodes"
	root:SetAttribute("TruthLabel", "Experimental")
	root:SetAttribute("RarityRange", "CommonToMythic")
	root.Parent = runtimeRoot

	return setmetatable({
		_root = root,
		_onForage = onForage,
		_presentation = ReplicatedStorage.CatchACreature.Remotes.ForagePresentation,
		_random = Random.new(),
		_graybox = nil,
		_states = {},
		_occupiedBySpawnIndex = {},
		_busyByNodeId = {},
	}, ForageWorldService)
end

function ForageWorldService:_spawnNode(node: any, spawnIndex: number): boolean
	local spawnPoint = ForageDefinitions.spawnPoints[spawnIndex]
	if spawnPoint == nil or self._graybox == nil then
		return false
	end
	local position = groundPosition(self._graybox, spawnPoint.worldX, spawnPoint.worldZ)
	if position == nil then
		return false
	end

	local previous = self._states[node.id]
	if previous then
		if previous.connection then
			previous.connection:Disconnect()
		end
		if previous.model and previous.model.Parent then
			previous.model:Destroy()
		end
		self._occupiedBySpawnIndex[previous.spawnIndex] = nil
	end

	local model, promptPart = createNodeModel(self._root, node, position)
	model:SetAttribute("SpawnPointId", spawnPoint.id)
	model:SetAttribute("SpawnIndex", spawnIndex)
	self._occupiedBySpawnIndex[spawnIndex] = true
	local prompt = promptPart:FindFirstChild("CatchACreatureForage") :: ProximityPrompt?
	local connection = nil
	if prompt then
		connection = prompt.Triggered:Connect(function(player)
			if self._busyByNodeId[node.id] then
				return
			end
			local character = player.Character
			local humanoid = if character then character:FindFirstChildOfClass("Humanoid") else nil
			local playerRoot = if character then character:FindFirstChild("HumanoidRootPart") else nil
			if humanoid == nil
				or humanoid.Health <= 0
				or playerRoot == nil
				or not playerRoot:IsA("BasePart")
				or model.Parent == nil
				or not ForageWorldService.isWithinDistance(playerRoot.Position, promptPart.Position, ForageDefinitions.maxActivationDistance + 2)
			then
				return
			end

			self._busyByNodeId[node.id] = true
			local ok, response = pcall(self._onForage, player, node.id)
			self._busyByNodeId[node.id] = nil
			if not ok then
				warn("[CatchACreature] Forage callback failed:", response)
				return
			end
			if type(response) ~= "table" or response.ok ~= true then
				return
			end

			local originalPosition = promptPart.Position
			if response.rarity == "Mythic" then
				self._presentation:FireClient(player, {
					kind = "MythicSeedPull",
					eventId = response.requestId,
					definitionId = response.definitionId,
					rarity = response.rarity,
					worldPosition = originalPosition,
				})
			end
			self:_relocateNode(node.id)
		end)
	end
	self._states[node.id] = {
		node = node,
		spawnIndex = spawnIndex,
		model = model,
		promptPart = promptPart,
		connection = connection,
	}
	return true
end

function ForageWorldService:_relocateNode(nodeId: string): boolean
	local state = self._states[nodeId]
	if state == nil then
		return false
	end
	local excluded = {}
	for spawnIndex, occupied in self._occupiedBySpawnIndex do
		excluded[spawnIndex] = occupied
	end
	for _ = 1, #ForageDefinitions.spawnPoints do
		local nextIndex = ForageDefinitions.selectRelocationIndex(self._random, state.spawnIndex, excluded)
		if nextIndex == nil then
			return false
		end
		if self:_spawnNode(state.node, nextIndex) then
			return true
		end
		excluded[nextIndex] = true
	end
	return false
end

function ForageWorldService:start()
	self._graybox = workspace:FindFirstChild("CatchACreature_Graybox_v1")
	if self._graybox == nil then
		warn("[CatchACreature] Forage nodes skipped: graybox missing")
		return
	end
	for _, node in ForageDefinitions.nodes do
		if not self:_spawnNode(node, node.initialSpawnIndex) then
			warn("[CatchACreature] Forage node skipped: no ground for", node.id)
		end
	end
end

function ForageWorldService:destroy()
	for _, state in self._states do
		if state.connection then
			state.connection:Disconnect()
		end
	end
	table.clear(self._states)
	table.clear(self._occupiedBySpawnIndex)
	table.clear(self._busyByNodeId)
	if self._root.Parent then
		self._root:Destroy()
	end
end

return ForageWorldService
