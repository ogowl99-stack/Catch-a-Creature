--!strict

local root = workspace:FindFirstChild("CatchACreature_Graybox_v1")
assert(root and root:IsA("Model"), "CatchACreature_Graybox_v1 does not exist")
assert(root:GetAttribute("Phase") == "Phase 2 Graybox", "Refusing rollback: unexpected root identity")

local waterCenterX = root:GetAttribute("WaterCenterX")
local waterCenterY = root:GetAttribute("WaterCenterY")
local waterCenterZ = root:GetAttribute("WaterCenterZ")
local waterSizeX = root:GetAttribute("WaterSizeX")
local waterSizeY = root:GetAttribute("WaterSizeY")
local waterSizeZ = root:GetAttribute("WaterSizeZ")
assert(typeof(waterCenterX) == "number" and typeof(waterCenterY) == "number" and typeof(waterCenterZ) == "number", "Refusing rollback: recorded water center is missing")
assert(typeof(waterSizeX) == "number" and typeof(waterSizeY) == "number" and typeof(waterSizeZ) == "number", "Refusing rollback: recorded water size is missing")
assert(waterSizeX > 0 and waterSizeY > 0 and waterSizeZ > 0, "Refusing rollback: recorded water size is invalid")

local center = Vector3.new(waterCenterX, waterCenterY, waterCenterZ)
local size = Vector3.new(waterSizeX, waterSizeY, waterSizeZ)
local waterVoxelResolution = root:GetAttribute("WaterVoxelResolution")
assert(typeof(waterVoxelResolution) == "number" and waterVoxelResolution == 4, "Refusing rollback: unexpected voxel resolution")

local waterRegion = Region3.new(center - size * 0.5, center + size * 0.5):ExpandToGrid(waterVoxelResolution)
local waterMaterials, waterOccupancy = workspace.Terrain:ReadVoxels(waterRegion, waterVoxelResolution)
local changedVoxels = 0
for x = 1, #waterMaterials do
	for y = 1, #waterMaterials[x] do
		for z = 1, #waterMaterials[x][y] do
			if waterMaterials[x][y][z] ~= Enum.Material.Water or waterOccupancy[x][y][z] < 0.999 then
				changedVoxels += 1
			end
		end
	end
end
assert(changedVoxels == 0, "Refusing rollback: Terrain changed after the graybox build")

local spawn = workspace:FindFirstChild("SpawnLocation")
if spawn and spawn:IsA("SpawnLocation") then
	local oldCFrame = root:GetAttribute("OriginalSpawnCFrame")
	local oldSize = root:GetAttribute("OriginalSpawnSize")
	local oldTransparency = root:GetAttribute("OriginalSpawnTransparency")
	local oldColor = root:GetAttribute("OriginalSpawnColor")
	local oldNeutral = root:GetAttribute("OriginalSpawnNeutral")
	local oldDuration = root:GetAttribute("OriginalSpawnDuration")
	if typeof(oldCFrame) == "CFrame" then
		spawn.CFrame = oldCFrame
	end
	if typeof(oldSize) == "Vector3" then
		spawn.Size = oldSize
	end
	if typeof(oldTransparency) == "number" then
		spawn.Transparency = oldTransparency
	end
	if typeof(oldColor) == "Color3" then
		spawn.Color = oldColor
	end
	if typeof(oldNeutral) == "boolean" then
		spawn.Neutral = oldNeutral
	end
	if typeof(oldDuration) == "number" then
		spawn.Duration = oldDuration
	end
	spawn:SetAttribute("Phase2Moved", nil)
	spawn:SetAttribute("FreshJoinSpawn", nil)
end

workspace.Terrain:FillBlock(CFrame.new(center), size, Enum.Material.Air)
root:Destroy()
return "Phase 2 graybox model removed and recorded water region cleared"
