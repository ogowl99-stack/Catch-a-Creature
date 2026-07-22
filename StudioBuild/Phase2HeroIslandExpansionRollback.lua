--!strict

-- Fail-closed rollback for Phase2HeroIslandExpansion.lua. It does not touch
-- Terrain and refuses to restore if an affected existing part no longer
-- matches the migration's recorded expected state.

local ROOT_NAME = "CatchACreature_Graybox_v1"
local REVISION = "MemoryTreeHeroCenter_v2"
local EPSILON = 0.001

local root = workspace:FindFirstChild(ROOT_NAME)
assert(root and root:IsA("Model"), ROOT_NAME .. " does not exist")
assert(root:GetAttribute("HeroIslandRevision") == REVISION, "Refusing rollback: unexpected revision")

local function vectorClose(a: Vector3, b: Vector3): boolean
	return (a - b).Magnitude <= EPSILON
end

local function cframeClose(a: CFrame, b: CFrame): boolean
	local aValues = { a:GetComponents() }
	local bValues = { b:GetComponents() }
	for index = 1, #aValues do
		if math.abs(aValues[index] - bValues[index]) > EPSILON then return false end
	end
	return true
end

local affected = {} :: { BasePart }
local added = {} :: { BasePart }
for _, descendant in root:GetDescendants() do
	if descendant:IsA("BasePart") then
		if descendant:GetAttribute("HeroIslandAdded") == true then
			assert(descendant:GetAttribute("HeroIslandRevision") == REVISION, "Refusing rollback: unexpected added-part revision")
			table.insert(added, descendant)
		else
			local originalCFrame = descendant:GetAttribute("HeroIslandOriginalCFrame")
			if originalCFrame ~= nil then
				local expectedCFrame = descendant:GetAttribute("HeroIslandExpectedCFrame")
				local expectedSize = descendant:GetAttribute("HeroIslandExpectedSize")
				local expectedName = descendant:GetAttribute("HeroIslandExpectedName")
				assert(typeof(originalCFrame) == "CFrame", "Refusing rollback: invalid original CFrame")
				assert(typeof(expectedCFrame) == "CFrame" and cframeClose(descendant.CFrame, expectedCFrame), "Refusing rollback: affected CFrame changed")
				assert(typeof(expectedSize) == "Vector3" and vectorClose(descendant.Size, expectedSize), "Refusing rollback: affected Size changed")
				assert(type(expectedName) == "string" and descendant.Name == expectedName, "Refusing rollback: affected Name changed")
				table.insert(affected, descendant)
			end
		end
	end
end

local spawn = workspace:FindFirstChild("SpawnLocation")
assert(spawn and spawn:IsA("SpawnLocation"), "Refusing rollback: SpawnLocation missing")
local spawnOriginal = spawn:GetAttribute("HeroIslandOriginalCFrame")
local spawnExpected = spawn:GetAttribute("HeroIslandExpectedCFrame")
assert(typeof(spawnOriginal) == "CFrame" and typeof(spawnExpected) == "CFrame", "Refusing rollback: spawn snapshot missing")
assert(cframeClose(spawn.CFrame, spawnExpected), "Refusing rollback: SpawnLocation changed")

for _, part in affected do
	local originalCFrame = part:GetAttribute("HeroIslandOriginalCFrame")
	local originalSize = part:GetAttribute("HeroIslandOriginalSize")
	local originalName = part:GetAttribute("HeroIslandOriginalName")
	part.CFrame = originalCFrame
	part.Size = originalSize
	part.Name = originalName
	for attributeName, value in part:GetAttributes() do
		local originalAttribute = attributeName:match("^HeroIslandOriginalAttribute_(.+)$")
		if originalAttribute then part:SetAttribute(originalAttribute, value) end
	end
	for attributeName in part:GetAttributes() do
		if attributeName:match("^HeroIsland") then part:SetAttribute(attributeName, nil) end
	end
end

for _, descendant in root:GetDescendants() do
	if descendant:IsA("Model") then
		for attributeName, value in descendant:GetAttributes() do
			local originalAttribute = attributeName:match("^HeroIslandOriginalAttribute_(.+)$")
			if originalAttribute then descendant:SetAttribute(originalAttribute, value) end
		end
		for attributeName in descendant:GetAttributes() do
			if attributeName:match("^HeroIsland") then descendant:SetAttribute(attributeName, nil) end
		end
	end
end

for _, part in added do part:Destroy() end

spawn.CFrame = spawnOriginal
spawn:SetAttribute("HeroIslandOriginalCFrame", nil)
spawn:SetAttribute("HeroIslandExpectedCFrame", nil)

for attributeName, value in root:GetAttributes() do
	local originalAttribute = attributeName:match("^HeroIslandOriginalRootAttribute_(.+)$")
	if originalAttribute then root:SetAttribute(originalAttribute, value) end
end
for _, attributeName in { "MemoryTreeHeroFocus", "MemoryTreeEventIslandDiameter", "MemoryTreeApproximateHeight" } do
	root:SetAttribute(attributeName, nil)
end
for attributeName in root:GetAttributes() do
	if attributeName:match("^HeroIsland") then root:SetAttribute(attributeName, nil) end
end

return {
	status = "Hero-center revision rolled back",
	restoredParts = #affected,
	removedAddedParts = #added,
}
