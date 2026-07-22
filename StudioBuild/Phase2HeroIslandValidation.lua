--!strict

-- Read-only edit-mode acceptance for the Memory Tree hero-center revision.

local HttpService = game:GetService("HttpService")
local SURFACE_Y = 44
local root = workspace:FindFirstChild("CatchACreature_Graybox_v1")
assert(root and root:IsA("Model"), "graybox root missing")

local checks = 0
local function expect(condition: boolean, message: string)
	checks += 1
	assert(condition, string.format("CHECK_%03d_FAILED: %s", checks, message))
end

local function near(a: number, b: number, epsilon: number?): boolean
	return math.abs(a - b) <= (epsilon or 0.05)
end

local function vectorNear(a: Vector3, b: Vector3, epsilon: number?): boolean
	return (a - b).Magnitude <= (epsilon or 0.05)
end

local function endpointDistance(part: BasePart, point: Vector3): number
	local endpointA = part.CFrame:PointToWorldSpace(Vector3.new(0, 0, part.Size.Z * 0.5))
	local endpointB = part.CFrame:PointToWorldSpace(Vector3.new(0, 0, -part.Size.Z * 0.5))
	return math.min((endpointA - point).Magnitude, (endpointB - point).Magnitude)
end

local function overlapsXZ(a: BasePart, b: BasePart): boolean
	local axes = { a.CFrame.RightVector, a.CFrame.LookVector, b.CFrame.RightVector, b.CFrame.LookVector }
	local delta = b.Position - a.Position
	for _, rawAxis in axes do
		local axis = Vector3.new(rawAxis.X, 0, rawAxis.Z)
		if axis.Magnitude > 0.001 then
			axis = axis.Unit
			local aRadius = a.Size.X * 0.5 * math.abs(a.CFrame.RightVector:Dot(axis))
				+ a.Size.Z * 0.5 * math.abs(a.CFrame.LookVector:Dot(axis))
			local bRadius = b.Size.X * 0.5 * math.abs(b.CFrame.RightVector:Dot(axis))
				+ b.Size.Z * 0.5 * math.abs(b.CFrame.LookVector:Dot(axis))
			if math.abs(delta:Dot(axis)) > aRadius + bRadius + 0.05 then return false end
		end
	end
	return true
end

expect(root:GetAttribute("HeroIslandRevision") == "MemoryTreeHeroCenter_v2", "revision marker")
expect(root:GetAttribute("IslandWidth") == 1040 and root:GetAttribute("IslandDepth") == 1080, "island dimensions")
expect(root:GetAttribute("MemoryTreeHeroFocus") == true, "hero-focus marker")
expect(root:GetAttribute("MemoryTreeEventIslandDiameter") == 184, "event-island contract")

local descendantCount = #root:GetDescendants()
local basePartCount = 0
local scriptCount = 0
local unanchoredCount = 0
for _, descendant in root:GetDescendants() do
	if descendant:IsA("BasePart") then
		basePartCount += 1
		if not descendant.Anchored then unanchoredCount += 1 end
	elseif descendant:IsA("LuaSourceContainer") then
		scriptCount += 1
	end
end
expect(descendantCount == 802, "exact descendant count")
expect(basePartCount == 720, "exact BasePart count")
expect(scriptCount == 0, "graybox contains no scripts")
expect(unanchoredCount == 0, "all graybox parts anchored")

local eventIsland = root.Landmarks.MemoryTreeEventIsland
local treeRoot = root.Landmarks.MemoryTreeRootCollision
local trunk = root.Landmarks.MemoryTreeTrunk
expect(vectorNear(eventIsland.Position, Vector3.new(0, 36, 0)), "event island centered")
expect(near(eventIsland.Size.Y, 184) and near(eventIsland.Size.Z, 184), "event island is 184 studs across")
expect(near(treeRoot.Size.Y, 58) and near(treeRoot.Size.Z, 58), "tree root footprint")
	expect(near(trunk.Size.X, 150) and near(trunk.Size.Y, 28), "tree trunk hero scale")
local maximumCanopyTop = -math.huge
for index = 1, 5 do
	local canopy = root.Landmarks["MemoryTreeCanopy_" .. index]
	maximumCanopyTop = math.max(maximumCanopyTop, canopy.Position.Y + canopy.Size.Y * 0.5)
end
expect(near(maximumCanopyTop, 255), "tree silhouette reaches approximately 255 studs")

local eventPads = 0
for index = 1, 8 do
	local pad = root.Markers["EventPad_" .. index]
	expect(near(Vector3.new(pad.Position.X, 0, pad.Position.Z).Magnitude, 58), "event pad radius " .. index)
	expect(near(pad.Size.X, 10) and near(pad.Size.Z, 10), "event pad size " .. index)
	eventPads += 1
end
expect(eventPads == 8, "eight event pads")

local landPositions = {}
local landCount = 0
for _, part in root.Geometry:GetChildren() do
	if part:IsA("BasePart") and part:GetAttribute("GrayboxLand") == true then
		landCount += 1
		local key = string.format("%d,%d", math.round(part.Position.X), math.round(part.Position.Z))
		expect(landPositions[key] == nil, "unique land position " .. key)
		landPositions[key] = true
		expect(vectorNear(part.Size, Vector3.new(40, 16, 40)), "land tile size " .. key)
		local dx = math.max(math.abs(part.Position.X) - 20, 0)
		local dz = math.max(math.abs(part.Position.Z) - 20, 0)
		expect(math.sqrt(dx * dx + dz * dz) >= 170 - 0.05, "land preserves enlarged pond " .. key)
	end
end
expect(landCount == 484, "exact land tile count")
local expectedLandCount = 0
for x = -500, 500, 40 do
	for z = -520, 520, 40 do
		local ellipse = (x / 520) ^ 2 + (z / 540) ^ 2
		local dx = math.max(math.abs(x) - 20, 0)
		local dz = math.max(math.abs(z) - 20, 0)
		if ellipse <= 1 and math.sqrt(dx * dx + dz * dz) >= 170 then
			expectedLandCount += 1
			expect(landPositions[string.format("%d,%d", x, z)] == true, "expected land position")
		end
	end
end
expect(expectedLandCount == landCount, "complete land-position set")

local bridgeSpecs = {
	NorthBridge = Vector3.new(0, 44.75, -140),
	SouthBridge = Vector3.new(0, 44.75, 140),
	EastBridge = Vector3.new(140, 44.75, 0),
	WestBridge = Vector3.new(-140, 44.75, 0),
}
for name, position in bridgeSpecs do
	local bridge = root.Bridges[name]
	expect(vectorNear(bridge.Position, position), name .. " position")
	expect(bridge:GetAttribute("ClearWalkingWidth") == 16, name .. " clear width")
	local longLength = math.max(bridge.Size.X, bridge.Size.Z)
	local crossWidth = math.min(bridge.Size.X, bridge.Size.Z)
	expect(near(longLength, 100) and near(crossWidth, 18), name .. " footprint")
	local centerRadius = Vector3.new(position.X, 0, position.Z).Magnitude
	expect(near(centerRadius - longLength * 0.5, 90), name .. " overlaps event island")
	expect(near(centerRadius + longLength * 0.5, 190), name .. " overlaps public ring")
end

local ringCount = 0
for _, part in root.Paths:GetChildren() do
	if part:IsA("BasePart") and part.Name:match("^MainRing_") then
		ringCount += 1
		expect(near(Vector3.new(part.Position.X, 0, part.Position.Z).Magnitude, 196), "main ring radius")
		expect(near(part.Size.X, 18) and part:GetAttribute("ClearWidth") == 18, "main ring width")
	end
end
expect(ringCount == 30, "thirty public-ring segments")

local expectedPlotCenters = {
	Vector3.new(-150, 0, -340), Vector3.new(150, 0, -340),
	Vector3.new(340, 0, -150), Vector3.new(340, 0, 150),
	Vector3.new(150, 0, 340), Vector3.new(-150, 0, 340),
	Vector3.new(-340, 0, 150), Vector3.new(-340, 0, -150),
}
local plotSoils = {} :: { BasePart }
for index, center in expectedPlotCenters do
	local model = root.Plots["Plot_" .. index]
	local boundsCenter = model:GetAttribute("BoundsCenter")
	expect(typeof(boundsCenter) == "Vector3" and vectorNear(boundsCenter, center), "plot center " .. index)
	expect(model:GetAttribute("BoundsSize") == Vector3.new(96, 0, 96), "plot size metadata " .. index)
	local soil = model.SoilBase
	expect(vectorNear(soil.Position, Vector3.new(center.X, SURFACE_Y, center.Z)), "plot soil position " .. index)
	table.insert(plotSoils, soil)
	local outward = center.Unit
	local dominantX = math.abs(outward.X) > math.abs(outward.Z)
	local inward = if dominantX then Vector3.new(-math.sign(outward.X), 0, 0) else Vector3.new(0, 0, -math.sign(outward.Z))
	local entrance = center + inward * 48 + Vector3.new(0, SURFACE_Y + 0.35, 0)
	expect(endpointDistance(root.Paths["PlotPath_" .. index], entrance) <= 0.1, "plot path meets entrance " .. index)
end

local hubCourtyard = root.Services.CaretakerHubGraybox.Courtyard
expect(vectorNear(hubCourtyard.Position, Vector3.new(-220, 44.5, 220)), "Hub moved outward")
expect(vectorNear(root.Reserves.FutureMeadow_1.Meadow.Position, Vector3.new(-390, 44.5, 0)), "west meadow moved outward")
expect(vectorNear(root.Reserves.FutureMeadow_2.Meadow.Position, Vector3.new(0, 44.5, -420)), "north meadow moved outward")
expect(vectorNear(root.Landmarks.WelcomeArrivalApron.Position, Vector3.new(0, 44.5, 525)), "arrival apron moved outward")
expect(vectorNear(root.Markers.FutureGateToPlotTrigger.Position, Vector3.new(0, 48, 482)), "gate trigger moved outward")

for _, trail in root.Paths:GetChildren() do
	if trail:IsA("BasePart") and trail.Name:match("^FutureMountTrail_") then
		for index, soil in plotSoils do expect(not overlapsXZ(trail, soil), "trail clears Plot " .. index) end
		expect(not overlapsXZ(trail, root.Reserves.FutureMeadow_1.Meadow), "trail clears west meadow")
		expect(not overlapsXZ(trail, root.Reserves.FutureMeadow_2.Meadow), "trail clears north meadow")
	end
end

local wallSpecs = {
	NorthReturnMarker = { Vector3.new(0, 70, -550), Vector3.new(1080, 120, 8) },
	SouthReturnMarker = { Vector3.new(0, 70, 550), Vector3.new(1080, 120, 8) },
	EastReturnMarker = { Vector3.new(530, 70, 0), Vector3.new(8, 120, 1108) },
	WestReturnMarker = { Vector3.new(-530, 70, 0), Vector3.new(8, 120, 1108) },
}
for name, spec in wallSpecs do
	local wall = root.Boundaries[name]
	expect(vectorNear(wall.Position, spec[1]) and vectorNear(wall.Size, spec[2]), name .. " transform")
	expect(wall.Transparency == 1 and wall.CanCollide, name .. " invisible collision")
end

local spawn = workspace:FindFirstChild("SpawnLocation")
expect(spawn ~= nil and spawn:IsA("SpawnLocation") and vectorNear(spawn.Position, Vector3.new(0, 46.5, 525)), "fresh join spawn")

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Include
rayParams.FilterDescendantsInstances = { root }
local sightlineOrigin = Vector3.new(0, 56, 450)
local sightlineTarget = Vector3.new(0, 105, 0)
local sightline = workspace:Raycast(sightlineOrigin, sightlineTarget - sightlineOrigin, rayParams)
expect(sightline ~= nil and sightline.Instance.Name:match("^MemoryTree") ~= nil, "inside-gate hero sightline reaches Memory Tree first")

return HttpService:JSONEncode({
	status = "PASS",
	checks = checks,
	descendants = descendantCount,
	baseParts = basePartCount,
	landTiles = landCount,
	mainRingSegments = ringCount,
	canopyTop = maximumCanopyTop,
})
