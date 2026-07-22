--!strict

local Players = game:GetService("Players")

local ServerRoot = script.Parent.Parent
local PlantDefinitions = require(ServerRoot.Definitions.PlantDefinitions)

local PlotService = {}
PlotService.__index = PlotService

local function finiteVector3(value: any): boolean
	return typeof(value) == "Vector3"
		and value.X == value.X
		and value.Y == value.Y
		and value.Z == value.Z
		and math.abs(value.X) < 1_000_000
		and math.abs(value.Y) < 1_000_000
		and math.abs(value.Z) < 1_000_000
end

function PlotService.new()
	local graybox = workspace:WaitForChild("CatchACreature_Graybox_v1")
	local plotsFolder = graybox:WaitForChild("Plots")
	local plots = {}
	for _, child in plotsFolder:GetChildren() do
		if child:IsA("Model") and type(child:GetAttribute("PlotId")) == "number" then
			table.insert(plots, child)
		end
	end
	table.sort(plots, function(left, right)
		return left:GetAttribute("PlotId") < right:GetAttribute("PlotId")
	end)

	return setmetatable({
		_graybox = graybox,
		_plots = plots,
		_assignments = {},
		_ownersByPlot = {},
		_gateCrossed = {},
		_gateConnection = nil,
		_serviceConnections = {},
	}, PlotService)
end

function PlotService:assign(player: Player): Model?
	if self._assignments[player] then
		return self._assignments[player]
	end
	for _, plot in self._plots do
		if self._ownersByPlot[plot] == nil then
			self._ownersByPlot[plot] = player
			self._assignments[player] = plot
			plot:SetAttribute("OwnerUserId", player.UserId)
			return plot
		end
	end
	return nil
end

function PlotService:release(player: Player)
	local plot = self._assignments[player]
	self._assignments[player] = nil
	self._gateCrossed[player] = nil
	if plot then
		self._ownersByPlot[plot] = nil
		if plot:GetAttribute("OwnerUserId") == player.UserId then
			plot:SetAttribute("OwnerUserId", 0)
		end
	end
end

function PlotService:getPlot(player: Player): Model?
	return self._assignments[player]
end

function PlotService:getPlotId(player: Player): number?
	local plot = self._assignments[player]
	return if plot then plot:GetAttribute("PlotId") else nil
end

function PlotService:hasCrossedGate(player: Player): boolean
	return self._gateCrossed[player] == true
end

local function moveCharacterToPosition(player: Player, position: Vector3, lookAt: Vector3?)
	local character = player.Character
	if character == nil then
		return false
	end
	local root = character:FindFirstChild("HumanoidRootPart")
	if root == nil or not root:IsA("BasePart") then
		return false
	end
	local target = lookAt or (position + Vector3.new(0, 0, -1))
	root.CFrame = CFrame.lookAt(position, Vector3.new(target.X, position.Y, target.Z))
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	return true
end

local function moveCharacter(player: Player, destination: BasePart, lookAt: Vector3?)
	return moveCharacterToPosition(player, destination.Position + Vector3.new(0, 4, 0), lookAt)
end

local function serviceApproachPosition(hub: Model, kiosk: BasePart, lookAt: Vector3): Vector3?
	local courtyard = hub:FindFirstChild("Courtyard")
	if courtyard == nil or not courtyard:IsA("BasePart") then
		return nil
	end
	local horizontal = Vector3.new(lookAt.X - kiosk.Position.X, 0, lookAt.Z - kiosk.Position.Z)
	if horizontal.Magnitude < 0.001 then
		return nil
	end
	local distance = math.max(kiosk.Size.X, kiosk.Size.Z) * 0.5 + 6
	local courtyardThickness = math.min(courtyard.Size.X, courtyard.Size.Y, courtyard.Size.Z)
	local groundY = courtyard.Position.Y + courtyardThickness * 0.5 + 3
	local position = kiosk.Position + horizontal.Unit * distance
	return Vector3.new(position.X, groundY, position.Z)
end

function PlotService:travel(player: Player, target: string): boolean
	local plot = self._assignments[player]
	if plot == nil then
		return false
	end
	if target == "Plot" then
		local arrival = plot:FindFirstChild("ArrivalPad")
		local soil = plot:FindFirstChild("SoilBase")
		return arrival ~= nil and soil ~= nil and moveCharacter(player, arrival :: BasePart, (soil :: BasePart).Position)
	end
	local hub = self._graybox.Services:FindFirstChild("CaretakerHubGraybox")
	if hub == nil then
		return false
	end
	if target == "Shop" then
		local shop = hub:FindFirstChild("ShopKiosk")
		local lookAt = self._graybox.Landmarks.MemoryTreeTrunk.Position
		local approach = if shop and shop:IsA("BasePart") then serviceApproachPosition(hub, shop, lookAt) else nil
		return approach ~= nil and moveCharacterToPosition(player, approach, (shop :: BasePart).Position)
	elseif target == "Sell" then
		local sell = hub:FindFirstChild("SellKiosk")
		local lookAt = self._graybox.Landmarks.MemoryTreeTrunk.Position
		local approach = if sell and sell:IsA("BasePart") then serviceApproachPosition(hub, sell, lookAt) else nil
		return approach ~= nil and moveCharacterToPosition(player, approach, (sell :: BasePart).Position)
	end
	return false
end

function PlotService:startServicePrompts(onOpen: (Player, string) -> ())
	local hub = self._graybox.Services:FindFirstChild("CaretakerHubGraybox")
	if hub == nil or not hub:IsA("Model") then
		return
	end
	for _, specification in {
		{ target = "Shop", partName = "ShopKiosk", actionText = "Open Shop", objectText = "Habitat Seeds" },
		{ target = "Sell", partName = "SellKiosk", actionText = "Open Sell", objectText = "Caretaker Hub" },
	} do
		local kiosk = hub:FindFirstChild(specification.partName)
		if kiosk and kiosk:IsA("BasePart") then
			local existing = kiosk:FindFirstChild("CatchACreatureOpenService")
			if existing then
				existing:Destroy()
			end
			local prompt = Instance.new("ProximityPrompt")
			prompt.Name = "CatchACreatureOpenService"
			prompt.ActionText = specification.actionText
			prompt.ObjectText = specification.objectText
			prompt.HoldDuration = 0
			prompt.MaxActivationDistance = 14
			prompt.RequiresLineOfSight = false
			prompt.KeyboardKeyCode = Enum.KeyCode.E
			prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
			prompt.Parent = kiosk
			table.insert(self._serviceConnections, prompt.Triggered:Connect(function(player)
				onOpen(player, specification.target)
			end))
		end
	end
end

function PlotService:startGate(onCrossed: (Player) -> ())
	local marker = self._graybox.Markers:WaitForChild("FutureGateToPlotTrigger") :: BasePart
	marker.CanTouch = true
	self._gateConnection = marker.Touched:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		local player = if character then Players:GetPlayerFromCharacter(character) else nil
		if player == nil or self._gateCrossed[player] then
			return
		end
		local plot = self._assignments[player]
		if plot == nil then
			return
		end
		self._gateCrossed[player] = true
		self:travel(player, "Plot")
		onCrossed(player)
	end)
end

function PlotService:canonicalPlacement(player: Player, worldPosition: any, snapToGrid: boolean, definitionId: string?): (number?, number?, string?)
	if not finiteVector3(worldPosition) then
		return nil, nil, "NONFINITE"
	end
	local plot = self._assignments[player]
	if plot == nil then
		return nil, nil, "NO_PLOT"
	end
	local soil = plot:FindFirstChild("SoilBase") :: BasePart?
	local arrival = plot:FindFirstChild("ArrivalPad") :: BasePart?
	if soil == nil or arrival == nil then
		return nil, nil, "INVALID_PLOT"
	end

	local character = player.Character
	local root = if character then character:FindFirstChild("HumanoidRootPart") else nil
	if root == nil or not root:IsA("BasePart") or (root.Position - worldPosition).Magnitude > 90 then
		return nil, nil, "TOO_FAR"
	end

	local localPosition = soil.CFrame:PointToObjectSpace(worldPosition)
	local definition = PlantDefinitions.byId[definitionId or PlantDefinitions.Sunspud.id]
	if definition == nil then
		return nil, nil, "INVALID_DEFINITION"
	end
	local step = if snapToGrid then definition.gridStepMilli else definition.positionStepMilli
	local localXMilli = math.round(localPosition.X * 1000 / step) * step
	local localZMilli = math.round(localPosition.Z * 1000 / step) * step
	local halfX = math.floor(soil.Size.X * 500) - definition.footprintRadiusMilli
	local halfZ = math.floor(soil.Size.Z * 500) - definition.footprintRadiusMilli
	if math.abs(localXMilli) > halfX or math.abs(localZMilli) > halfZ then
		return nil, nil, "OUT_OF_BOUNDS"
	end

	local arrivalLocal = soil.CFrame:PointToObjectSpace(arrival.Position)
	local arrivalXMilli = math.round(arrivalLocal.X * 1000)
	local arrivalZMilli = math.round(arrivalLocal.Z * 1000)
	local exclusionX = math.floor(arrival.Size.X * 500) + definition.footprintRadiusMilli
	local exclusionZ = math.floor(arrival.Size.Z * 500) + definition.footprintRadiusMilli
	if math.abs(localXMilli - arrivalXMilli) <= exclusionX and math.abs(localZMilli - arrivalZMilli) <= exclusionZ then
		return nil, nil, "ARRIVAL_PAD"
	end
	return localXMilli, localZMilli, nil
end

function PlotService:worldPosition(player: Player, localXMilli: number, localZMilli: number): Vector3?
	local plot = self._assignments[player]
	local soil = if plot then plot:FindFirstChild("SoilBase") else nil
	if soil == nil or not soil:IsA("BasePart") then
		return nil
	end
	return soil.CFrame:PointToWorldSpace(Vector3.new(localXMilli / 1000, soil.Size.Y / 2, localZMilli / 1000))
end

return PlotService
