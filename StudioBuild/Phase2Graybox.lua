--!strict

-- Reproducible edit-mode constructor for the Phase 2 island graybox.
-- The script is intentionally additive and refuses to overwrite an existing graybox.

assert(not workspace:FindFirstChild("CatchACreature_Graybox_v1"), "Graybox already exists")

local SURFACE_Y = 44
local WATER_CENTER = Vector3.new(0, 28, 0)
local WATER_SIZE = Vector3.new(4096, 16, 4096)
local PLOT_SIZE = 96

local COLORS = {
	Land = Color3.fromRGB(166, 207, 143),
	LandAlt = Color3.fromRGB(184, 221, 159),
	Soil = Color3.fromRGB(150, 108, 78),
	Path = Color3.fromRGB(229, 207, 164),
	Fence = Color3.fromRGB(137, 97, 67),
	Bridge = Color3.fromRGB(184, 132, 82),
	Event = Color3.fromRGB(198, 226, 163),
	Hub = Color3.fromRGB(210, 191, 226),
	Gate = Color3.fromRGB(169, 193, 228),
	Marker = Color3.fromRGB(255, 235, 155),
	Tree = Color3.fromRGB(112, 78, 51),
	Canopy = Color3.fromRGB(114, 176, 101),
	Boundary = Color3.fromRGB(121, 170, 112),
}

local root = Instance.new("Model")
root.Name = "CatchACreature_Graybox_v1"
root:SetAttribute("Phase", "Phase 2 Graybox")
root:SetAttribute("TruthLabel", "Requires Roblox Studio testing")
root:SetAttribute("BuildDate", "2026-07-20")
root:SetAttribute("CoordinateConvention", "MemoryTree=(0,0); WelcomeGate=+Z")
root:SetAttribute("IslandWidth", 1040)
root:SetAttribute("IslandDepth", 1080)
root:SetAttribute("PlotSize", PLOT_SIZE)
root:SetAttribute("PlotCount", 8)
root:SetAttribute("MemoryTreeHeroFocus", true)
root:SetAttribute("MemoryTreeEventIslandDiameter", 184)
root:SetAttribute("MemoryTreeApproximateHeight", 255)
root:SetAttribute("HeroIslandRevision", "MemoryTreeHeroCenter_v2")
root:SetAttribute("HeroIslandRevisionDate", "2026-07-21")
root:SetAttribute("VisualAuthority", "Design/ConceptArt/Approved")
root:SetAttribute("DimensionAuthority", "Design/Map/Phase2GrayboxDimensions.md")
root:SetAttribute("WaterCenterX", WATER_CENTER.X)
root:SetAttribute("WaterCenterY", WATER_CENTER.Y)
root:SetAttribute("WaterCenterZ", WATER_CENTER.Z)
root:SetAttribute("WaterSizeX", WATER_SIZE.X)
root:SetAttribute("WaterSizeY", WATER_SIZE.Y)
root:SetAttribute("WaterSizeZ", WATER_SIZE.Z)

local folders = {}
for _, name in ipairs({
	"Geometry",
	"Plots",
	"Paths",
	"Bridges",
	"Landmarks",
	"Services",
	"Reserves",
	"Boundaries",
	"Markers",
	"References",
}) do
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = root
	folders[name] = folder
end

for index, fileName in ipairs({
	"whole-map-top-down-v2.png",
	"welcome-gate-centered-tree.png",
	"standard-player-plot-72x72.png",
	"crescent-pond-sanctuary-overview.png",
	"caretaker-hub-correct-orientation.png",
}) do
	local reference = Instance.new("StringValue")
	reference.Name = string.format("Reference_%02d", index)
	reference.Value = "Design/ConceptArt/Approved/" .. fileName
	reference.Parent = folders.References
end

local function makePart(
	parent: Instance,
	name: string,
	size: Vector3,
	cframe: CFrame,
	color: Color3,
	material: Enum.Material?,
	canCollide: boolean?
): Part
	local value = Instance.new("Part")
	value.Name = name
	value.Anchored = true
	value.Size = size
	value.CFrame = cframe
	value.Color = color
	value.Material = material or Enum.Material.SmoothPlastic
	value.CanCollide = if canCollide == nil then true else canCollide
	value.CanTouch = false
	value.CanQuery = true
	value.TopSurface = Enum.SurfaceType.Smooth
	value.BottomSurface = Enum.SurfaceType.Smooth
	value.Parent = parent
	return value
end

local function makeCylinder(
	parent: Instance,
	name: string,
	diameter: number,
	height: number,
	position: Vector3,
	color: Color3,
	material: Enum.Material?
): Part
	local value = makePart(
		parent,
		name,
		Vector3.new(height, diameter, diameter),
		CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90)),
		color,
		material,
		true
	)
	value.Shape = Enum.PartType.Cylinder
	return value
end

local function makeBall(parent: Instance, name: string, size: Vector3, position: Vector3, color: Color3): Part
	local value = makePart(parent, name, size, CFrame.new(position), color, Enum.Material.Grass, true)
	value.Shape = Enum.PartType.Ball
	return value
end

local function addLabel(adornee: BasePart, text: string, width: number?, height: number?, maxDistance: number?): BillboardGui
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "GrayboxLabel"
	billboard.Adornee = adornee
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.MaxDistance = maxDistance or 240
	billboard.Size = UDim2.fromOffset(width or 220, height or 54)
	billboard.StudsOffsetWorldSpace = Vector3.new(0, adornee.Size.Y * 0.5 + 3, 0)
	billboard.Parent = adornee

	local label = Instance.new("TextLabel")
	label.BackgroundColor3 = Color3.fromRGB(47, 57, 66)
	label.BackgroundTransparency = 0.15
	label.BorderSizePixel = 0
	label.Size = UDim2.fromScale(1, 1)
	label.Font = Enum.Font.GothamBold
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true
	label.TextWrapped = true
	label.Parent = billboard

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = label
	return billboard
end

local function pathBetween(parent: Instance, name: string, from: Vector3, to: Vector3, width: number): Part
	local flatFrom = Vector3.new(from.X, SURFACE_Y + 0.35, from.Z)
	local flatTo = Vector3.new(to.X, SURFACE_Y + 0.35, to.Z)
	local midpoint = (flatFrom + flatTo) * 0.5
	local length = (flatTo - flatFrom).Magnitude
	local value = makePart(
		parent,
		name,
		Vector3.new(width, 0.7, length),
		CFrame.lookAt(midpoint, flatTo),
		COLORS.Path,
		Enum.Material.Cobblestone,
		true
	)
	value:SetAttribute("ClearWidth", width)
	return value
end

-- Blocky, low-cost island foundation. The center ring remains open for Terrain water.
local tileIndex = 0
for x = -500, 500, 40 do
	for z = -520, 520, 40 do
		local ellipse = (x / 520) ^ 2 + (z / 540) ^ 2
		local dx = math.max(math.abs(x) - 20, 0)
		local dz = math.max(math.abs(z) - 20, 0)
		local minimumRadius = math.sqrt(dx * dx + dz * dz)
		if ellipse <= 1 and minimumRadius >= 170 then
			tileIndex += 1
			local tile = makePart(
				folders.Geometry,
				string.format("LandTile_%03d", tileIndex),
				Vector3.new(40, 16, 40),
				CFrame.new(x, 36, z),
				COLORS.Land,
				Enum.Material.Grass,
				true
			)
			tile:SetAttribute("GrayboxLand", true)
		end
	end
end

-- Central event island and Memory Tree.
local eventIsland = makeCylinder(
	folders.Landmarks,
	"MemoryTreeEventIsland",
	184,
	16,
	Vector3.new(0, 36, 0),
	COLORS.Event,
	Enum.Material.Grass
)
eventIsland:SetAttribute("PermanentEventVenue", true)
eventIsland:SetAttribute("Stealable", false)
root.PrimaryPart = eventIsland

local treeRoot = makeCylinder(
	folders.Landmarks,
	"MemoryTreeRootCollision",
	58,
	6,
	Vector3.new(0, 47, 0),
	COLORS.Tree,
	Enum.Material.Wood
)
treeRoot:SetAttribute("SimplifiedCollision", true)
treeRoot:SetAttribute("Stealable", false)

local trunk = makeCylinder(
	folders.Landmarks,
	"MemoryTreeTrunk",
	28,
	150,
	Vector3.new(0, 121, 0),
	COLORS.Tree,
	Enum.Material.Wood
)
trunk:SetAttribute("Stealable", false)

for index, spec in ipairs({
	{ position = Vector3.new(0, 220, 0), size = Vector3.new(110, 70, 110) },
	{ position = Vector3.new(45, 207, 8), size = Vector3.new(94, 62, 94) },
	{ position = Vector3.new(-45, 207, 8), size = Vector3.new(94, 62, 94) },
	{ position = Vector3.new(8, 207, 45), size = Vector3.new(94, 62, 94) },
	{ position = Vector3.new(-8, 207, -45), size = Vector3.new(94, 62, 94) },
}) do
	local canopy = makeBall(
		folders.Landmarks,
		"MemoryTreeCanopy_" .. index,
		spec.size,
		spec.position,
		COLORS.Canopy
	)
	canopy:SetAttribute("DecorativeCanopy", true)
	canopy:SetAttribute("Stealable", false)
end
addLabel(trunk, "MEMORY TREE\nPERMANENT EVENT VENUE", 300, 70, 600)

for index = 1, 8 do
	local angle = (index - 1) * math.pi * 2 / 8
	local pad = makePart(
		folders.Markers,
		"EventPad_" .. index,
		Vector3.new(10, 0.5, 10),
		CFrame.new(math.cos(angle) * 58, SURFACE_Y + 0.25, math.sin(angle) * 58),
		COLORS.Marker,
		Enum.Material.Neon,
		true
	)
	pad.Transparency = 0.25
	pad:SetAttribute("EventSpawnPad", true)
	pad:SetAttribute("NonPlantable", true)
end

-- Four bridges with 12-stud clear decks and simple rails.
local bridgeSpecs = {
	{ name = "NorthBridge", position = Vector3.new(0, 44.75, -140), size = Vector3.new(18, 1.5, 100), axis = "Z" },
	{ name = "SouthBridge", position = Vector3.new(0, 44.75, 140), size = Vector3.new(18, 1.5, 100), axis = "Z" },
	{ name = "EastBridge", position = Vector3.new(140, 44.75, 0), size = Vector3.new(100, 1.5, 18), axis = "X" },
	{ name = "WestBridge", position = Vector3.new(-140, 44.75, 0), size = Vector3.new(100, 1.5, 18), axis = "X" },
}
for _, spec in ipairs(bridgeSpecs) do
	local bridge = makePart(
		folders.Bridges,
		spec.name,
		spec.size,
		CFrame.new(spec.position),
		COLORS.Bridge,
		Enum.Material.WoodPlanks,
		true
	)
	bridge:SetAttribute("ClearWalkingWidth", 16)
	bridge:SetAttribute("WaterSurfaceY", 36)
	if spec.axis == "Z" then
		for _, side in ipairs({ -8.75, 8.75 }) do
			makePart(
				folders.Bridges,
				spec.name .. "Rail" .. tostring(side),
				Vector3.new(0.5, 3, spec.size.Z),
				CFrame.new(spec.position + Vector3.new(side, 2.2, 0)),
				COLORS.Fence,
				Enum.Material.Wood,
				true
			)
		end
	else
		for _, side in ipairs({ -8.75, 8.75 }) do
			makePart(
				folders.Bridges,
				spec.name .. "Rail" .. tostring(side),
				Vector3.new(spec.size.X, 3, 0.5),
				CFrame.new(spec.position + Vector3.new(0, 2.2, side)),
				COLORS.Fence,
				Enum.Material.Wood,
				true
			)
		end
	end
end

-- Four diagonal stepped shoreline exits, one per pond quadrant.
for quadrant, angle in ipairs({ math.rad(45), math.rad(135), math.rad(225), math.rad(315) }) do
	local outward = Vector3.new(math.cos(angle), 0, math.sin(angle))
	local tangent = Vector3.new(-outward.Z, 0, outward.X)
	for step = 1, 3 do
		local radius = 158 + step * 5
		local top = 38 + (step - 1) * 3
		local height = top - 28
		local center = outward * radius + Vector3.new(0, 28 + height * 0.5, 0)
		local exit = makePart(
			folders.Bridges,
			string.format("SwimExit_Q%d_S%d", quadrant, step),
			Vector3.new(16, height, 5),
			CFrame.lookAt(center, center + outward) * CFrame.Angles(0, math.rad(90), 0),
			COLORS.Path,
			Enum.Material.Rock,
			true
		)
		exit.CFrame = CFrame.fromMatrix(center, tangent, Vector3.yAxis, outward)
		exit:SetAttribute("SwimExit", true)
	end
end

-- Sixteen-stud public ring path.
local ringRadius = 196
local ringSegments = 30
local chord = 2 * ringRadius * math.sin(math.pi / ringSegments) + 2
for index = 1, ringSegments do
	local angle = (index - 1) * math.pi * 2 / ringSegments
	local position = Vector3.new(math.cos(angle) * ringRadius, SURFACE_Y + 0.35, math.sin(angle) * ringRadius)
	local tangent = Vector3.new(-math.sin(angle), 0, math.cos(angle))
	local segment = makePart(
		folders.Paths,
		string.format("MainRing_%02d", index),
		Vector3.new(18, 0.7, chord),
		CFrame.lookAt(position, position + tangent),
		COLORS.Path,
		Enum.Material.Cobblestone,
		true
	)
	segment:SetAttribute("ClearWidth", 18)
end

-- Broad perimeter trail supports walking now and reserves readable circulation for future creature mounts.
local mountTrailSegments = 36
for index = 1, mountTrailSegments do
	local angleA = (index - 1) * math.pi * 2 / mountTrailSegments
	local angleB = index * math.pi * 2 / mountTrailSegments
	local pointA = Vector3.new(math.cos(angleA) * 450, SURFACE_Y + 0.35, math.sin(angleA) * 480)
	local pointB = Vector3.new(math.cos(angleB) * 450, SURFACE_Y + 0.35, math.sin(angleB) * 480)
	local segment = makePart(
		folders.Paths,
		string.format("FutureMountTrail_%02d", index),
		Vector3.new(20, 0.7, (pointB - pointA).Magnitude + 2),
		CFrame.lookAt((pointA + pointB) * 0.5, pointB),
		COLORS.Path,
		Enum.Material.Cobblestone,
		true
	)
	segment:SetAttribute("ClearWidth", 20)
	segment:SetAttribute("WalkableNow", true)
	segment:SetAttribute("FutureMountRoute", true)
	segment:SetAttribute("MountSystemImplemented", false)
end

local plotCenters = {
	Vector3.new(-150, 0, -340),
	Vector3.new(150, 0, -340),
	Vector3.new(340, 0, -150),
	Vector3.new(340, 0, 150),
	Vector3.new(150, 0, 340),
	Vector3.new(-150, 0, 340),
	Vector3.new(-340, 0, 150),
	Vector3.new(-340, 0, -150),
}

local function fenceSegment(parent: Instance, name: string, size: Vector3, position: Vector3): Part
	return makePart(parent, name, size, CFrame.new(position), COLORS.Fence, Enum.Material.Wood, true)
end

for index, centerXZ in ipairs(plotCenters) do
	local model = Instance.new("Model")
	model.Name = "Plot_" .. index
	model:SetAttribute("PlotId", index)
	model:SetAttribute("OwnerUserId", 0)
	model:SetAttribute("BoundsCenter", centerXZ)
	model:SetAttribute("BoundsSize", Vector3.new(PLOT_SIZE, 0, PLOT_SIZE))
	model:SetAttribute("PublicVisitAllowed", true)
	model:SetAttribute("OrdinaryVisitorMutationAllowed", false)
	model:SetAttribute("ExplicitStealSystemOnly", true)
	model.Parent = folders.Plots

	local base = makePart(
		model,
		"SoilBase",
		Vector3.new(PLOT_SIZE, 2, PLOT_SIZE),
		CFrame.new(centerXZ.X, SURFACE_Y, centerXZ.Z),
		COLORS.Soil,
		Enum.Material.Ground,
		true
	)
	base:SetAttribute("PlantableGraybox", true)
	model.PrimaryPart = base

	local outward = Vector3.new(centerXZ.X, 0, centerXZ.Z).Unit
	local dominantX = math.abs(outward.X) > math.abs(outward.Z)
	local inwardDirection = if dominantX
		then Vector3.new(-math.sign(outward.X), 0, 0)
		else Vector3.new(0, 0, -math.sign(outward.Z))
	local half = PLOT_SIZE * 0.5
	local entrance = centerXZ + inwardDirection * half
	local padCenter = centerXZ + inwardDirection * (half - 13)
	local pad = makePart(
		model,
		"ArrivalPad",
		Vector3.new(12, 0.5, 12),
		CFrame.new(padCenter.X, SURFACE_Y + 1.25, padCenter.Z),
		COLORS.Gate,
		Enum.Material.Neon,
		true
	)
	pad.Transparency = 0.2
	pad:SetAttribute("NonPlantable", true)
	pad:SetAttribute("FutureAssignedPlotArrival", true)
	addLabel(pad, "PLOT " .. index .. "\nARRIVAL", 150, 48, 180)

	local fenceY = SURFACE_Y + 3
	local gap = 18
	local splitLength = (PLOT_SIZE - gap) * 0.5
	local splitOffset = gap * 0.5 + splitLength * 0.5
	local inwardSideX = if dominantX then -math.sign(outward.X) else 0
	local inwardSideZ = if not dominantX then -math.sign(outward.Z) else 0

	for _, side in ipairs({ -1, 1 }) do
		local xPosition = centerXZ.X + side * half
		if dominantX and side == inwardSideX then
			for _, split in ipairs({ -1, 1 }) do
				fenceSegment(model, "EntranceFenceX", Vector3.new(1.5, 4, splitLength), Vector3.new(xPosition, fenceY, centerXZ.Z + split * splitOffset))
			end
		else
			fenceSegment(model, "FenceX", Vector3.new(1.5, 4, PLOT_SIZE), Vector3.new(xPosition, fenceY, centerXZ.Z))
		end
	end
	for _, side in ipairs({ -1, 1 }) do
		local zPosition = centerXZ.Z + side * half
		if (not dominantX) and side == inwardSideZ then
			for _, split in ipairs({ -1, 1 }) do
				fenceSegment(model, "EntranceFenceZ", Vector3.new(splitLength, 4, 1.5), Vector3.new(centerXZ.X + split * splitOffset, fenceY, zPosition))
			end
		else
			fenceSegment(model, "FenceZ", Vector3.new(PLOT_SIZE, 4, 1.5), Vector3.new(centerXZ.X, fenceY, zPosition))
		end
	end

	local ringPoint = Vector3.new(entrance.X, 0, entrance.Z).Unit * 206
	pathBetween(folders.Paths, "PlotPath_" .. index, ringPoint, entrance, 12)
end

-- Welcome Gate, arrival apron, board footprints, and a nonfunctional future trigger marker.
local apron = makePart(
	folders.Landmarks,
	"WelcomeArrivalApron",
	Vector3.new(70, 1, 32),
	CFrame.new(0, SURFACE_Y + 0.5, 525),
	COLORS.Gate,
	Enum.Material.SmoothPlastic,
	true
)
apron:SetAttribute("FreshJoinArea", true)
apron:SetAttribute("NonPlantable", true)

for _, x in ipairs({ -15, 15 }) do
	makePart(folders.Landmarks, "WelcomeGatePillar", Vector3.new(6, 20, 6), CFrame.new(x, 54, 490), COLORS.Gate, Enum.Material.Brick, true)
end
local gateArch = makePart(folders.Landmarks, "WelcomeGateArch", Vector3.new(36, 5, 6), CFrame.new(0, 65, 490), COLORS.Gate, Enum.Material.Brick, true)
addLabel(gateArch, "WELCOME TO\nCATCH A CREATURE", 300, 70, 340)

local gateTrigger = makePart(
	folders.Markers,
	"FutureGateToPlotTrigger",
	Vector3.new(24, 8, 6),
	CFrame.new(0, 48, 482),
	Color3.fromRGB(116, 221, 205),
	Enum.Material.ForceField,
	false
)
gateTrigger.Transparency = 0.55
gateTrigger.CanQuery = true
gateTrigger:SetAttribute("FutureAssignedPlotMoveTrigger", true)
gateTrigger:SetAttribute("Implemented", false)

pathBetween(folders.Paths, "WelcomeAxisPath", Vector3.new(0, 0, 490), Vector3.new(0, 0, 190), 18)

local function makeBoard(name: string, x: number, title: string): Model
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = folders.Services
	local bay = makePart(model, "StandingBay", Vector3.new(28, 0.7, 12), CFrame.new(x, SURFACE_Y + 0.35, 506), COLORS.Path, Enum.Material.Cobblestone, true)
	bay:SetAttribute("NonPlantable", true)
	local board = makePart(model, "Board", Vector3.new(28, 13, 1.5), CFrame.new(x, 51, 498), COLORS.Gate, Enum.Material.SmoothPlastic, true)
	addLabel(board, title, 250, 70, 220)
	model:SetAttribute("MechanismImplemented", false)
	return model
end
makeBoard("WealthLeaderboardFootprint", -48, "WEALTH LEADERBOARD\nRANKING METRIC TBD")
makeBoard("DonationBoardFootprint", 48, "DONATION BOARD\nMECHANISM TBD")

-- Caretaker Hub courtyard and grouped services.
local hub = Instance.new("Model")
hub.Name = "CaretakerHubGraybox"
hub:SetAttribute("EnvelopeSize", Vector3.new(80, 0, 80))
hub:SetAttribute("FacesSanctuaryCenter", true)
hub.Parent = folders.Services
local hubCourtyard = makeCylinder(hub, "Courtyard", 78, 1, Vector3.new(-220, SURFACE_Y + 0.5, 220), COLORS.Hub, Enum.Material.Brick)
addLabel(hubCourtyard, "CARETAKER HUB", 220, 52, 220)
local kiosks = {
	{ "ShopKiosk", Vector3.new(-245, 50, 227), Color3.fromRGB(185, 216, 235), "SHOP" },
	{ "SellKiosk", Vector3.new(-232, 50, 250), Color3.fromRGB(238, 202, 163), "SELL" },
	{ "AppraiseKiosk", Vector3.new(-201, 50, 245), Color3.fromRGB(205, 189, 230), "APPRAISE" },
}
for _, spec in ipairs(kiosks) do
	local kiosk = makePart(hub, spec[1], Vector3.new(14, 12, 12), CFrame.new(spec[2]), spec[3], Enum.Material.SmoothPlastic, true)
	kiosk:SetAttribute("ServiceImplemented", false)
	addLabel(kiosk, spec[4], 130, 40, 150)
end
pathBetween(folders.Paths, "HubApproach", Vector3.new(-220, 0, 220), Vector3.new(-139, 0, 139), 18)

-- Natural meadow reserves; signs intentionally contain no dates.
for index, center in ipairs({ Vector3.new(-390, 0, 0), Vector3.new(0, 0, -420) }) do
	local model = Instance.new("Model")
	model.Name = "FutureMeadow_" .. index
	model:SetAttribute("FutureReserve", true)
	model:SetAttribute("Implemented", false)
	if index == 2 then
		model:SetAttribute("ReservedSystem", "CreatureMounts")
		model:SetAttribute("RideOwnedCreatures", true)
		model:SetAttribute("MountedSpeedAboveWalkSpeed", true)
		model:SetAttribute("MountSystemImplemented", false)
	end
	model.Parent = folders.Reserves
	local meadow = makePart(model, "Meadow", Vector3.new(80, 1, 64), CFrame.new(center.X, SURFACE_Y + 0.5, center.Z), COLORS.LandAlt, Enum.Material.Grass, true)
	meadow:SetAttribute("NonPlantable", true)
	local sign = makePart(model, "ComingSoonSign", Vector3.new(16, 8, 1.5), CFrame.new(center.X, 50, center.Z + 29), COLORS.Gate, Enum.Material.WoodPlanks, true)
	addLabel(sign, if index == 2 then "MOUNTS\nFUTURE UPDATE" else "SOMETHING IS\nCOMING...", 190, 58, 180)
	local inward = -center.Unit
	local entry = center + inward * (if math.abs(center.X) > math.abs(center.Z) then 40 else 32)
	pathBetween(folders.Paths, "MeadowApproach_" .. index, entry, center.Unit * 208, 12)
end

-- Global creature-arrival markers are intentionally generic, not species or region locked.
for index, position in ipairs({
	Vector3.new(-255, SURFACE_Y + 0.25, -45),
	Vector3.new(255, SURFACE_Y + 0.25, -45),
	Vector3.new(-255, SURFACE_Y + 0.25, 45),
	Vector3.new(255, SURFACE_Y + 0.25, 45),
}) do
	local marker = makePart(folders.Markers, "GlobalCreatureArrival_" .. index, Vector3.new(8, 0.5, 8), CFrame.new(position), COLORS.Marker, Enum.Material.Neon, true)
	marker.Transparency = 0.4
	marker:SetAttribute("GlobalArrivalPool", true)
	marker:SetAttribute("SpeciesLocked", false)
end

-- Gentle scenery band. The southern arrival opening remains clear.
for index = 1, 40 do
	local angle = (index - 1) * math.pi * 2 / 40
	local x = math.cos(angle) * 490
	local z = math.sin(angle) * 510
	if not (math.abs(x) < 80 and z > 430) then
		local hill = makeBall(
			folders.Boundaries,
			"OuterHill_" .. index,
			Vector3.new(30, 18, 30),
			Vector3.new(x, 48, z),
			COLORS.Boundary
		)
		hill:SetAttribute("SceneryBoundary", true)
	end
end

-- Invisible collidable walls prevent players from leaving the island through the ocean sides.
local returnSpecs = {
	{ "NorthReturnMarker", Vector3.new(0, 70, -550), Vector3.new(1080, 120, 8) },
	{ "SouthReturnMarker", Vector3.new(0, 70, 550), Vector3.new(1080, 120, 8) },
	{ "EastReturnMarker", Vector3.new(530, 70, 0), Vector3.new(8, 120, 1108) },
	{ "WestReturnMarker", Vector3.new(-530, 70, 0), Vector3.new(8, 120, 1108) },
}
for _, spec in ipairs(returnSpecs) do
	local marker = makePart(folders.Boundaries, spec[1], spec[3], CFrame.new(spec[2]), Color3.fromRGB(235, 125, 125), Enum.Material.ForceField, true)
	marker.Transparency = 1
	marker.CanQuery = true
	marker.CanTouch = false
	marker:SetAttribute("FutureOceanReturnBoundary", false)
	marker:SetAttribute("InvisibleIslandBorder", true)
	marker:SetAttribute("Implemented", true)
	marker:SetAttribute("BoundaryBehavior", "Invisible collision wall")
end

local terrain = workspace.Terrain
local waterVoxelResolution = 4
local waterRegion = Region3.new(WATER_CENTER - WATER_SIZE * 0.5, WATER_CENTER + WATER_SIZE * 0.5):ExpandToGrid(waterVoxelResolution)
local waterMaterials, waterOccupancy = terrain:ReadVoxels(waterRegion, waterVoxelResolution)
local terrainPreflightNonAirVoxels = 0
for x = 1, #waterMaterials do
	for y = 1, #waterMaterials[x] do
		for z = 1, #waterMaterials[x][y] do
			if waterMaterials[x][y][z] ~= Enum.Material.Air or waterOccupancy[x][y][z] > 0 then
				terrainPreflightNonAirVoxels += 1
			end
		end
	end
end
assert(terrainPreflightNonAirVoxels == 0, "Refusing build: the graybox water region contains existing Terrain")

root:SetAttribute("GeneratedPartCount", #root:GetDescendants())
root:SetAttribute("TerrainPreflightNonAirVoxels", terrainPreflightNonAirVoxels)
root:SetAttribute("WaterVoxelResolution", waterVoxelResolution)
root:SetAttribute("TerrainRollbackPolicy", "Refuse unless the recorded region is still exact generated water")

local spawn = workspace:FindFirstChild("SpawnLocation")
if spawn and spawn:IsA("SpawnLocation") then
	root:SetAttribute("OriginalSpawnCFrame", spawn.CFrame)
	root:SetAttribute("OriginalSpawnSize", spawn.Size)
	root:SetAttribute("OriginalSpawnTransparency", spawn.Transparency)
	root:SetAttribute("OriginalSpawnColor", spawn.Color)
	root:SetAttribute("OriginalSpawnNeutral", spawn.Neutral)
	root:SetAttribute("OriginalSpawnDuration", spawn.Duration)
end

local committed = false
local ok, failure = pcall(function()
	terrain:FillBlock(CFrame.new(WATER_CENTER), WATER_SIZE, Enum.Material.Water)
	root.Parent = workspace
	if spawn and spawn:IsA("SpawnLocation") then
		spawn.CFrame = CFrame.new(0, 46.5, 525)
		spawn.Size = Vector3.new(8, 1, 8)
		spawn.Transparency = 0.25
		spawn.Color = COLORS.Gate
		spawn.Neutral = true
		spawn.Duration = 0
		spawn:SetAttribute("Phase2Moved", true)
		spawn:SetAttribute("FreshJoinSpawn", true)
	end
	committed = true
end)

if not ok then
	if root.Parent then
		root:Destroy()
	end
	terrain:FillBlock(CFrame.new(WATER_CENTER), WATER_SIZE, Enum.Material.Air)
	error(failure)
end

return {
	committed = committed,
	root = root:GetFullName(),
	descendants = #root:GetDescendants(),
	landTiles = tileIndex,
	plots = #plotCenters,
	waterCenter = WATER_CENTER,
	waterSize = WATER_SIZE,
	spawnMoved = spawn ~= nil,
}
