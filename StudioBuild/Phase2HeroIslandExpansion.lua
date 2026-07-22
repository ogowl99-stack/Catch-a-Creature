--!strict

-- Guarded edit-mode migration from the verified Phase 2 graybox baseline to the
-- Memory Tree hero-center revision. No Terrain is changed and no existing part
-- is deleted. Existing transforms are stored as attributes for exact rollback.

local ROOT_NAME = "CatchACreature_Graybox_v1"
local REVISION = "MemoryTreeHeroCenter_v2"
local SURFACE_Y = 44

local root = workspace:FindFirstChild(ROOT_NAME)
assert(root and root:IsA("Model"), ROOT_NAME .. " does not exist")
assert(root:GetAttribute("Phase") == "Phase 2 Graybox", "Refusing migration: unexpected root identity")
assert(root:GetAttribute("HeroIslandRevision") == nil, "Refusing migration: hero-center revision already applied")
assert(#root:GetDescendants() == 684, "Refusing migration: descendant baseline changed")

local baselineParts = 0
for _, descendant in root:GetDescendants() do
	if descendant:IsA("BasePart") then
		baselineParts += 1
		assert(descendant:GetAttribute("HeroIslandOriginalCFrame") == nil, "Refusing migration: stale part snapshot")
	end
end
assert(baselineParts == 602, "Refusing migration: BasePart baseline changed")

local function snapshotPart(part: BasePart)
	part:SetAttribute("HeroIslandOriginalCFrame", part.CFrame)
	part:SetAttribute("HeroIslandOriginalSize", part.Size)
	part:SetAttribute("HeroIslandOriginalName", part.Name)
end

local function applyPart(part: BasePart, size: Vector3, cframe: CFrame, name: string?)
	snapshotPart(part)
	part.Size = size
	part.CFrame = cframe
	if name then
		part.Name = name
	end
	part:SetAttribute("HeroIslandExpectedCFrame", part.CFrame)
	part:SetAttribute("HeroIslandExpectedSize", part.Size)
	part:SetAttribute("HeroIslandExpectedName", part.Name)
end

local function addedClone(template: BasePart, parent: Instance, name: string, size: Vector3, cframe: CFrame): BasePart
	local clone = template:Clone()
	clone.Name = name
	clone.Size = size
	clone.CFrame = cframe
	clone:SetAttribute("HeroIslandAdded", true)
	clone:SetAttribute("HeroIslandRevision", REVISION)
	clone.Parent = parent
	return clone
end

local function snapshotAttribute(instance: Instance, attributeName: string, expected: any)
	local original = instance:GetAttribute(attributeName)
	assert(original ~= nil, "Refusing migration: missing attribute " .. attributeName .. " on " .. instance:GetFullName())
	instance:SetAttribute("HeroIslandOriginalAttribute_" .. attributeName, original)
	instance:SetAttribute(attributeName, expected)
	instance:SetAttribute("HeroIslandExpectedAttribute_" .. attributeName, expected)
end

local function moveModel(model: Model, delta: Vector3)
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			applyPart(descendant, descendant.Size, descendant.CFrame + delta)
		end
	end
end

local function cylinderCFrame(position: Vector3): CFrame
	return CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
end

local function pathCFrame(from: Vector3, to: Vector3): (Vector3, CFrame)
	local flatFrom = Vector3.new(from.X, SURFACE_Y + 0.35, from.Z)
	local flatTo = Vector3.new(to.X, SURFACE_Y + 0.35, to.Z)
	local midpoint = (flatFrom + flatTo) * 0.5
	local length = (flatTo - flatFrom).Magnitude
	return Vector3.new(0, 0.7, length), CFrame.lookAt(midpoint, flatTo)
end

local originalRootAttributes = {
	IslandWidth = root:GetAttribute("IslandWidth"),
	IslandDepth = root:GetAttribute("IslandDepth"),
	TruthLabel = root:GetAttribute("TruthLabel"),
	VerificationScope = root:GetAttribute("VerificationScope"),
	RemainingValidation = root:GetAttribute("RemainingValidation"),
	PlotRingDescription = root:GetAttribute("PlotRingDescription"),
	GeneratedPartCount = root:GetAttribute("GeneratedPartCount"),
	GeneratedDescendantCount = root:GetAttribute("GeneratedDescendantCount"),
	CurrentBasePartCount = root:GetAttribute("CurrentBasePartCount"),
}
for attributeName, value in originalRootAttributes do
	if value ~= nil then
		root:SetAttribute("HeroIslandOriginalRootAttribute_" .. attributeName, value)
	end
end

local addedParts = {} :: { BasePart }
local ok, failure = pcall(function()
	local geometry = root:FindFirstChild("Geometry")
	local landmarks = root:FindFirstChild("Landmarks")
	local plots = root:FindFirstChild("Plots")
	local paths = root:FindFirstChild("Paths")
	local bridges = root:FindFirstChild("Bridges")
	local services = root:FindFirstChild("Services")
	local reserves = root:FindFirstChild("Reserves")
	local boundaries = root:FindFirstChild("Boundaries")
	local markers = root:FindFirstChild("Markers")
	assert(geometry and landmarks and plots and paths and bridges and services and reserves and boundaries and markers, "Graybox folders missing")

	-- Reuse every existing land tile, then add only the extra tiles required by
	-- the wider island and larger central pond opening.
	local landTiles = {} :: { BasePart }
	for _, child in geometry:GetChildren() do
		if child:IsA("BasePart") and child:GetAttribute("GrayboxLand") == true then
			table.insert(landTiles, child)
		end
	end
	table.sort(landTiles, function(a, b) return a.Name < b.Name end)
	assert(#landTiles == 372, "Refusing migration: land-tile baseline changed")
	local landTemplate = landTiles[1]:Clone()
	local finalLandPositions = {} :: { Vector3 }
	for x = -500, 500, 40 do
		for z = -520, 520, 40 do
			local ellipse = (x / 520) ^ 2 + (z / 540) ^ 2
			local dx = math.max(math.abs(x) - 20, 0)
			local dz = math.max(math.abs(z) - 20, 0)
			if ellipse <= 1 and math.sqrt(dx * dx + dz * dz) >= 170 then
				table.insert(finalLandPositions, Vector3.new(x, 36, z))
			end
		end
	end
	assert(#finalLandPositions >= #landTiles, "Refusing migration: final land unexpectedly shrank")
	for index, position in finalLandPositions do
		local name = string.format("LandTile_%03d", index)
		if landTiles[index] then
			applyPart(landTiles[index], Vector3.new(40, 16, 40), CFrame.new(position), name)
		else
			local added = addedClone(landTemplate, geometry, name, Vector3.new(40, 16, 40), CFrame.new(position))
			table.insert(addedParts, added)
		end
	end
	landTemplate:Destroy()

	-- Hero event island and tree silhouette.
	applyPart(landmarks.MemoryTreeEventIsland, Vector3.new(16, 184, 184), cylinderCFrame(Vector3.new(0, 36, 0)))
	applyPart(landmarks.MemoryTreeRootCollision, Vector3.new(6, 58, 58), cylinderCFrame(Vector3.new(0, 47, 0)))
	applyPart(landmarks.MemoryTreeTrunk, Vector3.new(150, 28, 28), cylinderCFrame(Vector3.new(0, 121, 0)))
	local canopySpecs = {
		{ Vector3.new(110, 70, 110), Vector3.new(0, 220, 0) },
		{ Vector3.new(94, 62, 94), Vector3.new(45, 207, 8) },
		{ Vector3.new(94, 62, 94), Vector3.new(-45, 207, 8) },
		{ Vector3.new(94, 62, 94), Vector3.new(8, 207, 45) },
		{ Vector3.new(94, 62, 94), Vector3.new(-8, 207, -45) },
	}
	for index, spec in canopySpecs do
		applyPart(landmarks["MemoryTreeCanopy_" .. index], spec[1], CFrame.new(spec[2]))
	end

	for index = 1, 8 do
		local angle = (index - 1) * math.pi * 2 / 8
		local pad = markers["EventPad_" .. index]
		applyPart(pad, Vector3.new(10, 0.5, 10), CFrame.new(math.cos(angle) * 58, SURFACE_Y + 0.25, math.sin(angle) * 58))
	end

	-- Wider bridges connect the 92-stud island radius to the 196-stud ring.
	local bridgeSpecs = {
		{ name = "NorthBridge", position = Vector3.new(0, 44.75, -140), size = Vector3.new(18, 1.5, 100), axis = "Z" },
		{ name = "SouthBridge", position = Vector3.new(0, 44.75, 140), size = Vector3.new(18, 1.5, 100), axis = "Z" },
		{ name = "EastBridge", position = Vector3.new(140, 44.75, 0), size = Vector3.new(100, 1.5, 18), axis = "X" },
		{ name = "WestBridge", position = Vector3.new(-140, 44.75, 0), size = Vector3.new(100, 1.5, 18), axis = "X" },
	}
	for _, spec in bridgeSpecs do
		local deck = bridges[spec.name]
		applyPart(deck, spec.size, CFrame.new(spec.position))
		snapshotAttribute(deck, "ClearWalkingWidth", 16)
		for _, child in bridges:GetChildren() do
			if child:IsA("BasePart") and child.Name:sub(1, #spec.name + 4) == spec.name .. "Rail" then
				if spec.axis == "Z" then
					local side = if child.Position.X < 0 then -8.75 else 8.75
					applyPart(child, Vector3.new(0.5, 3, spec.size.Z), CFrame.new(spec.position + Vector3.new(side, 2.2, 0)))
				else
					local side = if child.Position.Z < 0 then -8.75 else 8.75
					applyPart(child, Vector3.new(spec.size.X, 3, 0.5), CFrame.new(spec.position + Vector3.new(0, 2.2, side)))
				end
			end
		end
	end

	local swimAngles = { math.rad(45), math.rad(135), math.rad(225), math.rad(315) }
	for quadrant, angle in swimAngles do
		local outward = Vector3.new(math.cos(angle), 0, math.sin(angle))
		local tangent = Vector3.new(-outward.Z, 0, outward.X)
		for step = 1, 3 do
			local radius = 158 + step * 5
			local top = 38 + (step - 1) * 3
			local height = top - 28
			local center = outward * radius + Vector3.new(0, 28 + height * 0.5, 0)
			local exit = bridges[string.format("SwimExit_Q%d_S%d", quadrant, step)]
			applyPart(exit, Vector3.new(16, height, 5), CFrame.fromMatrix(center, tangent, Vector3.yAxis, outward))
		end
	end

	-- Rebuild the public ring from 24 existing parts plus six tagged additions.
	local ringParts = {} :: { BasePart }
	for _, child in paths:GetChildren() do
		if child:IsA("BasePart") and child.Name:match("^MainRing_") then table.insert(ringParts, child) end
	end
	table.sort(ringParts, function(a, b) return a.Name < b.Name end)
	assert(#ringParts == 24, "Refusing migration: main-ring baseline changed")
	local ringTemplate = ringParts[1]:Clone()
	local ringRadius = 196
	local ringSegments = 30
	local chord = 2 * ringRadius * math.sin(math.pi / ringSegments) + 2
	for index = 1, ringSegments do
		local angle = (index - 1) * math.pi * 2 / ringSegments
		local position = Vector3.new(math.cos(angle) * ringRadius, SURFACE_Y + 0.35, math.sin(angle) * ringRadius)
		local tangent = Vector3.new(-math.sin(angle), 0, math.cos(angle))
		local name = string.format("MainRing_%02d", index)
		if ringParts[index] then
			applyPart(ringParts[index], Vector3.new(18, 0.7, chord), CFrame.lookAt(position, position + tangent), name)
			snapshotAttribute(ringParts[index], "ClearWidth", 18)
		else
			local added = addedClone(ringTemplate, paths, name, Vector3.new(18, 0.7, chord), CFrame.lookAt(position, position + tangent))
			added:SetAttribute("ClearWidth", 18)
			table.insert(addedParts, added)
		end
	end
	ringTemplate:Destroy()

	for index = 1, 36 do
		local angleA = (index - 1) * math.pi * 2 / 36
		local angleB = index * math.pi * 2 / 36
		local pointA = Vector3.new(math.cos(angleA) * 450, SURFACE_Y + 0.35, math.sin(angleA) * 480)
		local pointB = Vector3.new(math.cos(angleB) * 450, SURFACE_Y + 0.35, math.sin(angleB) * 480)
		local segment = paths[string.format("FutureMountTrail_%02d", index)]
		applyPart(segment, Vector3.new(20, 0.7, (pointB - pointA).Magnitude + 2), CFrame.lookAt((pointA + pointB) * 0.5, pointB))
	end

	local newPlotCenters = {
		Vector3.new(-150, 0, -340), Vector3.new(150, 0, -340),
		Vector3.new(340, 0, -150), Vector3.new(340, 0, 150),
		Vector3.new(150, 0, 340), Vector3.new(-150, 0, 340),
		Vector3.new(-340, 0, 150), Vector3.new(-340, 0, -150),
	}
	for index, center in newPlotCenters do
		local model = plots["Plot_" .. index]
		local oldCenter = model:GetAttribute("BoundsCenter")
		assert(typeof(oldCenter) == "Vector3", "Plot bounds missing")
		model:SetAttribute("HeroIslandOriginalAttribute_BoundsCenter", oldCenter)
		model:SetAttribute("BoundsCenter", center)
		model:SetAttribute("HeroIslandExpectedAttribute_BoundsCenter", center)
		moveModel(model, center - oldCenter)
		local outward = center.Unit
		local dominantX = math.abs(outward.X) > math.abs(outward.Z)
		local inwardDirection = if dominantX then Vector3.new(-math.sign(outward.X), 0, 0) else Vector3.new(0, 0, -math.sign(outward.Z))
		local entrance = center + inwardDirection * 48
		local ringPoint = entrance.Unit * 206
		local size, cframe = pathCFrame(ringPoint, entrance)
		applyPart(paths["PlotPath_" .. index], Vector3.new(12, size.Y, size.Z), cframe)
	end

	local welcomeSize, welcomeCFrame = pathCFrame(Vector3.new(0, 0, 490), Vector3.new(0, 0, 190))
	applyPart(paths.WelcomeAxisPath, Vector3.new(18, welcomeSize.Y, welcomeSize.Z), welcomeCFrame)
	snapshotAttribute(paths.WelcomeAxisPath, "ClearWidth", 18)
	local hubSize, hubCFrame = pathCFrame(Vector3.new(-220, 0, 220), Vector3.new(-139, 0, 139))
	applyPart(paths.HubApproach, Vector3.new(18, hubSize.Y, hubSize.Z), hubCFrame)
	snapshotAttribute(paths.HubApproach, "ClearWidth", 18)
	local meadowRoutes = {
		{ Vector3.new(-350, 0, 0), Vector3.new(-208, 0, 0) },
		{ Vector3.new(0, 0, -388), Vector3.new(0, 0, -208) },
	}
	for index, route in meadowRoutes do
		local size, cframe = pathCFrame(route[1], route[2])
		applyPart(paths["MeadowApproach_" .. index], Vector3.new(12, size.Y, size.Z), cframe)
	end

	moveModel(services.WealthLeaderboardFootprint, Vector3.new(0, 0, 100))
	moveModel(services.DonationBoardFootprint, Vector3.new(0, 0, 100))
	moveModel(services.CaretakerHubGraybox, Vector3.new(-100, 0, 100))
	moveModel(reserves.FutureMeadow_1, Vector3.new(-100, 0, 0))
	moveModel(reserves.FutureMeadow_2, Vector3.new(0, 0, -90))

	applyPart(landmarks.WelcomeArrivalApron, landmarks.WelcomeArrivalApron.Size, landmarks.WelcomeArrivalApron.CFrame + Vector3.new(0, 0, 105))
	for _, child in landmarks:GetChildren() do
		if child:IsA("BasePart") and (child.Name == "WelcomeGatePillar" or child.Name == "WelcomeGateArch") then
			applyPart(child, child.Size, child.CFrame + Vector3.new(0, 0, 100))
		end
	end
	applyPart(markers.FutureGateToPlotTrigger, markers.FutureGateToPlotTrigger.Size, markers.FutureGateToPlotTrigger.CFrame + Vector3.new(0, 0, 100))

	local arrivalPositions = {
		Vector3.new(-255, SURFACE_Y + 0.25, -45), Vector3.new(255, SURFACE_Y + 0.25, -45),
		Vector3.new(-255, SURFACE_Y + 0.25, 45), Vector3.new(255, SURFACE_Y + 0.25, 45),
	}
	for index, position in arrivalPositions do
		local marker = markers["GlobalCreatureArrival_" .. index]
		applyPart(marker, marker.Size, CFrame.new(position))
	end

	for _, child in boundaries:GetChildren() do
		if child:IsA("BasePart") and child.Name:match("^OuterHill_") then
			local index = tonumber(child.Name:match("(%d+)$"))
			assert(index, "Hill index missing")
			local angle = (index - 1) * math.pi * 2 / 40
			applyPart(child, child.Size, CFrame.new(math.cos(angle) * 490, 48, math.sin(angle) * 510))
		end
	end
	local wallSpecs = {
		NorthReturnMarker = { Vector3.new(1080, 120, 8), Vector3.new(0, 70, -550) },
		SouthReturnMarker = { Vector3.new(1080, 120, 8), Vector3.new(0, 70, 550) },
		EastReturnMarker = { Vector3.new(8, 120, 1108), Vector3.new(530, 70, 0) },
		WestReturnMarker = { Vector3.new(8, 120, 1108), Vector3.new(-530, 70, 0) },
	}
	for name, spec in wallSpecs do
		applyPart(boundaries[name], spec[1], CFrame.new(spec[2]))
	end

	local spawn = workspace:FindFirstChild("SpawnLocation")
	assert(spawn and spawn:IsA("SpawnLocation"), "SpawnLocation missing")
	spawn:SetAttribute("HeroIslandOriginalCFrame", spawn.CFrame)
	spawn.CFrame = CFrame.new(0, 46.5, 525)
	spawn:SetAttribute("HeroIslandExpectedCFrame", spawn.CFrame)

	root:SetAttribute("IslandWidth", 1040)
	root:SetAttribute("IslandDepth", 1080)
	root:SetAttribute("MemoryTreeHeroFocus", true)
	root:SetAttribute("MemoryTreeEventIslandDiameter", 184)
	root:SetAttribute("MemoryTreeApproximateHeight", 255)
	root:SetAttribute("HeroIslandRevision", REVISION)
	root:SetAttribute("HeroIslandRevisionDate", "2026-07-21")
	root:SetAttribute("TruthLabel", "Requires Roblox Studio testing")
	root:SetAttribute("VerificationScope", "Hero-center source applied; fresh edit/play validation pending")
	root:SetAttribute("RemainingValidation", "Edit geometry; one-client traversal; multi-client; real devices; final art/performance")
	root:SetAttribute("PlotRingDescription", "96x96 plots centered at 150/340 cardinal offsets")
	root:SetAttribute("GeneratedPartCount", #root:GetDescendants())
	root:SetAttribute("GeneratedDescendantCount", #root:GetDescendants())
	local finalParts = 0
	for _, descendant in root:GetDescendants() do if descendant:IsA("BasePart") then finalParts += 1 end end
	root:SetAttribute("CurrentBasePartCount", finalParts)
end)

if not ok then
	for _, descendant in root:GetDescendants() do
		if descendant:IsA("BasePart") then
			local originalCFrame = descendant:GetAttribute("HeroIslandOriginalCFrame")
			local originalSize = descendant:GetAttribute("HeroIslandOriginalSize")
			local originalName = descendant:GetAttribute("HeroIslandOriginalName")
			if typeof(originalCFrame) == "CFrame" and typeof(originalSize) == "Vector3" and type(originalName) == "string" then
				descendant.CFrame = originalCFrame
				descendant.Size = originalSize
				descendant.Name = originalName
			end
		end
	end
	for _, added in addedParts do if added.Parent then added:Destroy() end end
	for attributeName, value in originalRootAttributes do
		if value ~= nil then root:SetAttribute(attributeName, value) end
		root:SetAttribute("HeroIslandOriginalRootAttribute_" .. attributeName, nil)
	end
	error(failure)
end

return {
	revision = REVISION,
	descendants = #root:GetDescendants(),
	addedParts = #addedParts,
	status = root:GetAttribute("TruthLabel"),
}
