--!strict

local RunService = game:GetService("RunService")

local HeldItemPresentation = {}
HeldItemPresentation.__index = HeldItemPresentation

local MODEL_NAME = "CatchACreatureHeldItem"
local IK_NAME = "CatchACreatureHeldItemIK"
local TARGET_NAME = "CatchACreatureHeldItemTarget"
local POLE_NAME = "CatchACreatureHeldItemPole"
local R6_HOLD_TRANSFORM = CFrame.Angles(0, 0, math.rad(90))

local function makePart(
	parent: Instance,
	name: string,
	color: Color3,
	size: Vector3,
	localCFrame: CFrame,
	shape: Enum.PartType?,
	material: Enum.Material?
): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.Massless = true
	part.Size = size
	part.CFrame = localCFrame
	part.Shape = shape or Enum.PartType.Block
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function createSunspud(model: Model, scale: number): BasePart
	local tuber = makePart(
		model,
		"Sunspud",
		Color3.fromRGB(245, 183, 56),
		Vector3.new(0.9, 0.72, 0.9) * scale,
		CFrame.new(0, 0.4 * scale, 0),
		Enum.PartType.Ball
	)
	makePart(model, "Stem", Color3.fromRGB(95, 155, 83), Vector3.new(0.16, 0.72, 0.16) * scale, CFrame.new(0, 0.93 * scale, 0))
	local leafSize = Vector3.new(0.62, 0.12, 0.28) * scale
	makePart(model, "LeafA", Color3.fromRGB(115, 181, 96), leafSize, CFrame.new(0.25 * scale, 1.08 * scale, 0) * CFrame.Angles(0, math.rad(24), math.rad(18)))
	makePart(model, "LeafB", Color3.fromRGB(129, 194, 105), leafSize, CFrame.new(-0.25 * scale, 0.98 * scale, 0) * CFrame.Angles(0, math.rad(204), math.rad(-18)))
	return tuber
end

local function createHearthpetal(model: Model, scale: number): BasePart
	local root = makePart(model, "HearthpetalRoot", Color3.fromRGB(97, 132, 83), Vector3.new(0.68, 0.4, 0.68) * scale, CFrame.new(0, 0.22 * scale, 0), Enum.PartType.Ball)
	makePart(model, "Stem", Color3.fromRGB(91, 158, 92), Vector3.new(0.15, 1.08, 0.15) * scale, CFrame.new(0, 0.82 * scale, 0))
	makePart(model, "Bloom", Color3.fromRGB(255, 218, 111), Vector3.new(0.48, 0.48, 0.48) * scale, CFrame.new(0, 1.38 * scale, 0), Enum.PartType.Ball, Enum.Material.Neon)
	local petalColors = {
		Color3.fromRGB(255, 160, 143),
		Color3.fromRGB(255, 184, 151),
	}
	for petalIndex = 1, 6 do
		local angle = (petalIndex - 1) * math.pi / 3
		makePart(
			model,
			"Petal" .. petalIndex,
			petalColors[(petalIndex - 1) % #petalColors + 1],
			Vector3.new(0.52, 0.18, 0.32) * scale,
			CFrame.new(math.cos(angle) * 0.3 * scale, 1.38 * scale, math.sin(angle) * 0.3 * scale) * CFrame.Angles(0, -angle, math.rad(10)),
			Enum.PartType.Ball
		)
	end
	local leafSize = Vector3.new(0.58, 0.12, 0.25) * scale
	makePart(model, "LeafA", Color3.fromRGB(112, 184, 110), leafSize, CFrame.new(0.22 * scale, 0.88 * scale, 0) * CFrame.Angles(0, math.rad(28), math.rad(20)))
	makePart(model, "LeafB", Color3.fromRGB(126, 198, 121), leafSize, CFrame.new(-0.22 * scale, 0.72 * scale, 0) * CFrame.Angles(0, math.rad(208), math.rad(-20)))
	return root
end

local function createHeldModel(character: Model, definitionId: string, kind: string): Model
	local model = Instance.new("Model")
	model.Name = MODEL_NAME
	model:SetAttribute("PlantDefinitionId", definitionId)
	model:SetAttribute("HeldKind", kind)
	local scale = if kind == "Seed" then 0.78 else 1
	local primary = if definitionId == "hearthpetal" then createHearthpetal(model, scale) else createSunspud(model, scale)
	model.PrimaryPart = primary
	local highlight = Instance.new("Highlight")
	highlight.Name = "HeldItemHighlight"
	highlight.FillColor = if definitionId == "hearthpetal" then Color3.fromRGB(255, 174, 150) else Color3.fromRGB(255, 220, 104)
	highlight.FillTransparency = 0.72
	highlight.OutlineColor = Color3.fromRGB(255, 248, 206)
	highlight.OutlineTransparency = 0.15
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Parent = model
	model.Parent = character
	return model
end

function HeldItemPresentation.new(player: Player)
	local self = setmetatable({
		_player = player,
		_definitionId = nil,
		_kind = nil,
		_character = nil,
		_model = nil,
		_ik = nil,
		_target = nil,
		_pole = nil,
		_poseConnection = nil,
		_rightShoulder = nil,
		_renderConnection = nil,
		_characterConnection = nil,
	}, HeldItemPresentation)
	self._characterConnection = player.CharacterAdded:Connect(function()
		task.defer(function()
			self:_refresh()
		end)
	end)
	return self
end

function HeldItemPresentation:_clearCharacter()
	if self._poseConnection then
		self._poseConnection:Disconnect()
		self._poseConnection = nil
	end
	if self._renderConnection then
		self._renderConnection:Disconnect()
		self._renderConnection = nil
	end
	if self._rightShoulder and self._rightShoulder.Parent then
		self._rightShoulder.Transform = CFrame.identity
	end
	for _, instance in { self._model, self._ik, self._target, self._pole } do
		if instance and instance.Parent then
			instance:Destroy()
		end
	end
	self._model = nil
	self._ik = nil
	self._target = nil
	self._pole = nil
	self._rightShoulder = nil
	self._character = nil
end

function HeldItemPresentation:_refresh()
	self:_clearCharacter()
	if self._definitionId == nil or self._kind == nil then
		return
	end
	local character = self._player.Character
	if character == nil then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if humanoid == nil or root == nil or not root:IsA("BasePart") then
		return
	end

	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		local torso = character:FindFirstChild("Torso")
		local rightArm = character:FindFirstChild("Right Arm")
		local rightShoulder = if torso then torso:FindFirstChild("Right Shoulder") else nil
		if torso == nil
			or not torso:IsA("BasePart")
			or rightArm == nil
			or not rightArm:IsA("BasePart")
			or rightShoulder == nil
			or not rightShoulder:IsA("Motor6D")
		then
			return
		end

		local model = createHeldModel(character, self._definitionId, self._kind)
		self._character = character
		self._model = model
		self._rightShoulder = rightShoulder
		-- Apply after Roblox's Animator so only the R6 shoulder is held forward.
		-- This leaves the torso and root free for normal walk animations.
		self._poseConnection = RunService.PreSimulation:Connect(function()
			if rightShoulder.Parent ~= nil then
				rightShoulder.Transform = R6_HOLD_TRANSFORM
			end
		end)
		self._renderConnection = RunService.RenderStepped:Connect(function()
			if model.Parent == nil or rightArm.Parent == nil or root.Parent == nil then
				return
			end
			local handPosition = (rightArm.CFrame * CFrame.new(0, -1.05, 0)).Position
			local rootRotation = root.CFrame - root.Position
			model:PivotTo(CFrame.new(handPosition) * rootRotation)
		end)
		return
	end

	local rightUpperArm = character:FindFirstChild("RightUpperArm")
	local rightHand = character:FindFirstChild("RightHand")
	if rightUpperArm == nil
		or not rightUpperArm:IsA("BasePart")
		or rightHand == nil
		or not rightHand:IsA("BasePart")
	then
		return
	end

	local model = createHeldModel(character, self._definitionId, self._kind)
	local target = Instance.new("Attachment")
	target.Name = TARGET_NAME
	target.CFrame = CFrame.new(1.05, 1.05, -1.5)
	target.Parent = root
	local pole = Instance.new("Attachment")
	pole.Name = POLE_NAME
	pole.CFrame = CFrame.new(2.6, 1.2, -0.2)
	pole.Parent = root
	local ik = Instance.new("IKControl")
	ik.Name = IK_NAME
	ik.Type = Enum.IKControlType.Position
	-- Restrict the solver to the right arm. Including UpperTorso in this chain
	-- makes the IK fight locomotion and can twist/jitter the whole character.
	ik.ChainRoot = rightUpperArm
	ik.EndEffector = rightHand
	ik.Target = target
	ik.Pole = pole
	ik.Weight = 0.85
	ik.SmoothTime = 0.12
	ik.Priority = 1
	ik.Enabled = true
	ik.Parent = humanoid

	self._character = character
	self._model = model
	self._target = target
	self._pole = pole
	self._ik = ik
	self._renderConnection = RunService.RenderStepped:Connect(function()
		if model.Parent == nil or rightHand.Parent == nil or root.Parent == nil then
			return
		end
		local rootRotation = root.CFrame - root.Position
		model:PivotTo(CFrame.new(rightHand.Position + Vector3.new(0, 0.08, 0)) * rootRotation)
	end)
end

function HeldItemPresentation:setEquipped(definitionId: string?, kind: string?)
	if definitionId ~= nil and definitionId ~= "sunspud" and definitionId ~= "hearthpetal" then
		definitionId = nil
	end
	if kind ~= nil and kind ~= "Seed" and kind ~= "Item" then
		kind = nil
	end
	if definitionId == nil or kind == nil then
		definitionId = nil
		kind = nil
	end
	if self._definitionId == definitionId and self._kind == kind then
		if definitionId ~= nil and self._model == nil then
			self:_refresh()
		end
		return
	end
	self._definitionId = definitionId
	self._kind = kind
	self:_refresh()
end

function HeldItemPresentation:destroy()
	self._definitionId = nil
	self._kind = nil
	self:_clearCharacter()
	if self._characterConnection then
		self._characterConnection:Disconnect()
		self._characterConnection = nil
	end
end

return HeldItemPresentation
