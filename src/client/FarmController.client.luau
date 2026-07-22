--!strict

local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local HeldItemPresentation = require(script.Parent:WaitForChild("HeldItemPresentation"))
local heldItemPresentation = HeldItemPresentation.new(player)
local shared = ReplicatedStorage:WaitForChild("CatchACreature")
local FarmContracts = require(shared:WaitForChild("FarmContracts"))
local remotes = shared:WaitForChild("Remotes")
local farmQuery = remotes:WaitForChild("FarmQuery") :: RemoteFunction
local farmCommand = remotes:WaitForChild("FarmCommand") :: RemoteFunction
local stateChanged = remotes:WaitForChild("StateChanged") :: RemoteEvent
local foragePresentation = remotes:WaitForChild("ForagePresentation") :: RemoteEvent

pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

local COLORS = {
	cream = Color3.fromRGB(255, 248, 222),
	creamDark = Color3.fromRGB(245, 230, 194),
	brown = Color3.fromRGB(103, 72, 48),
	green = Color3.fromRGB(111, 171, 101),
	greenDark = Color3.fromRGB(67, 119, 70),
	yellow = Color3.fromRGB(246, 190, 64),
	red = Color3.fromRGB(212, 98, 86),
	blue = Color3.fromRGB(119, 174, 211),
}

local screen = Instance.new("ScreenGui")
screen.Name = "CatchACreatureHUD"
screen.ResetOnSpawn = false
screen.DisplayOrder = 20
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent = playerGui

local placementOverlay = Instance.new("ScreenGui")
placementOverlay.Name = "CatchACreaturePlacementOverlay"
placementOverlay.ResetOnSpawn = false
placementOverlay.IgnoreGuiInset = true
placementOverlay.DisplayOrder = 21
placementOverlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
placementOverlay.Parent = playerGui

local function round(parent: Instance, radius: number)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	local stroke = Instance.new("UIStroke")
	stroke.Color = COLORS.brown
	stroke.Transparency = 0.55
	stroke.Thickness = 2
	stroke.Parent = parent
end

local function panel(name: string, size: UDim2, position: UDim2, anchor: Vector2?): Frame
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = size
	frame.Position = position
	frame.AnchorPoint = anchor or Vector2.zero
	frame.BackgroundColor3 = COLORS.cream
	frame.BackgroundTransparency = 0.04
	frame.Parent = screen
	round(frame, 14)
	return frame
end

local function constrainWidth(parent: GuiObject, minimum: number, maximum: number)
	local constraint = Instance.new("UISizeConstraint")
	constraint.MinSize = Vector2.new(minimum, 0)
	constraint.MaxSize = Vector2.new(maximum, math.huge)
	constraint.Parent = parent
end

local function label(parent: Instance, name: string, text: string, size: UDim2, position: UDim2, textSize: number, bold: boolean?): TextLabel
	local value = Instance.new("TextLabel")
	value.Name = name
	value.BackgroundTransparency = 1
	value.Size = size
	value.Position = position
	value.Font = if bold then Enum.Font.GothamBold else Enum.Font.GothamMedium
	value.Text = text
	value.TextColor3 = COLORS.brown
	value.TextSize = textSize
	value.TextWrapped = true
	value.Parent = parent
	return value
end

local function button(parent: Instance, name: string, text: string, size: UDim2, position: UDim2, color: Color3): TextButton
	local control = Instance.new("TextButton")
	control.Name = name
	control.Size = size
	control.Position = position
	control.BackgroundColor3 = color
	control.AutoButtonColor = true
	control.Font = Enum.Font.GothamBold
	control.Text = text
	control.TextColor3 = Color3.new(1, 1, 1)
	control.TextSize = 16
	control.TextWrapped = true
	control.Parent = parent
	round(control, 11)
	return control
end

local stats = panel("Stats", UDim2.fromOffset(270, 78), UDim2.fromOffset(16, 16))
local leafnotesLabel = label(stats, "Leafnotes", "🍃 Leafnotes: --", UDim2.new(1, -20, 0, 30), UDim2.fromOffset(10, 8), 19, true)
leafnotesLabel.TextXAlignment = Enum.TextXAlignment.Left
local truthLabel = label(stats, "Truth", "Loading source…", UDim2.new(1, -20, 0, 25), UDim2.fromOffset(10, 43), 13, false)
truthLabel.TextXAlignment = Enum.TextXAlignment.Left

local objective = panel("Objective", UDim2.new(1, -24, 0, 80), UDim2.new(0.5, 0, 0, 92), Vector2.new(0.5, 0))
constrainWidth(objective, 296, 450)
local objectiveTitle = label(objective, "Title", "FIRST SUNSPUD", UDim2.new(1, -20, 0, 24), UDim2.fromOffset(10, 8), 14, true)
objectiveTitle.TextColor3 = COLORS.greenDark
local objectiveText = label(objective, "Text", "Loading your sanctuary…", UDim2.new(1, -24, 0, 40), UDim2.fromOffset(12, 31), 18, true)

local travel = panel("Travel", UDim2.new(1, -24, 0, 64), UDim2.new(0.5, 0, 0, 16), Vector2.new(0.5, 0))
constrainWidth(travel, 296, 478)
local shopTravel = button(travel, "Shop", "SHOP", UDim2.new(1 / 3, -13, 0, 44), UDim2.fromOffset(10, 10), COLORS.blue)
local plotTravel = button(travel, "Plot", "YOUR PLOT", UDim2.new(1 / 3, -13, 0, 44), UDim2.new(1 / 3, 3, 0, 10), COLORS.green)
local sellTravel = button(travel, "Sell", "SELL", UDim2.new(1 / 3, -13, 0, 44), UDim2.new(2 / 3, -4, 0, 10), Color3.fromRGB(213, 157, 104))

local notice = panel("Notice", UDim2.new(1, -24, 0, 48), UDim2.new(0.5, 0, 1, -150), Vector2.new(0.5, 1))
constrainWidth(notice, 296, 460)
local noticeText = label(notice, "Text", "", UDim2.new(1, -20, 1, -8), UDim2.fromOffset(10, 4), 16, true)
notice.Visible = false

local hotbar = panel("Hotbar", UDim2.fromOffset(610, 80), UDim2.new(0.5, 0, 1, -18), Vector2.new(0.5, 1))
local hotbarLayout = Instance.new("UIListLayout")
hotbarLayout.FillDirection = Enum.FillDirection.Horizontal
hotbarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
hotbarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
hotbarLayout.Padding = UDim.new(0, 5)
hotbarLayout.Parent = hotbar
local hotbarButtons = {}
for index = 1, 10 do
	local slot = button(hotbar, "Slot" .. index, tostring(index) .. "\nEMPTY", UDim2.fromOffset(52, 58), UDim2.new(), COLORS.creamDark)
	slot.TextColor3 = Color3.fromRGB(150, 125, 92)
	slot.TextSize = 9
	slot.TextWrapped = true
	hotbarButtons[index] = slot
end

local pageButton = button(screen, "HotbarPage", "1–5", UDim2.fromOffset(56, 44), UDim2.new(0.5, -333, 1, -36), COLORS.green)
pageButton.AnchorPoint = Vector2.new(0.5, 1)
pageButton.Visible = false

local inventoryButton = button(screen, "InventoryButton", "🎒", UDim2.fromOffset(64, 64), UDim2.new(0, 16, 1, -18), COLORS.green)
inventoryButton.AnchorPoint = Vector2.new(0, 1)
inventoryButton.TextSize = 32
inventoryButton.ZIndex = 10

local inventoryPanel = panel("InventoryPanel", UDim2.fromOffset(360, 400), UDim2.new(0, 16, 1, -94), Vector2.new(0, 1))
constrainWidth(inventoryPanel, 296, 380)
inventoryPanel.Visible = false
inventoryPanel.ZIndex = 20
local inventoryHeading = label(inventoryPanel, "Heading", "BACKPACK", UDim2.new(1, -130, 0, 38), UDim2.fromOffset(16, 12), 24, true)
inventoryHeading.TextXAlignment = Enum.TextXAlignment.Left
inventoryHeading.ZIndex = 21
local inventoryCount = label(inventoryPanel, "Count", "0 items", UDim2.new(1, -32, 0, 24), UDim2.fromOffset(16, 52), 14, false)
inventoryCount.TextXAlignment = Enum.TextXAlignment.Left
inventoryCount.TextColor3 = COLORS.greenDark
inventoryCount.ZIndex = 21
local closeInventory = button(inventoryPanel, "Close", "CLOSE", UDim2.fromOffset(92, 34), UDim2.new(1, -108, 0, 12), COLORS.red)
closeInventory.ZIndex = 21
local inventoryList = Instance.new("ScrollingFrame")
inventoryList.Name = "Items"
inventoryList.Size = UDim2.new(1, -24, 1, -92)
inventoryList.Position = UDim2.fromOffset(12, 82)
inventoryList.BackgroundTransparency = 1
inventoryList.BorderSizePixel = 0
inventoryList.ScrollBarThickness = 6
inventoryList.ScrollBarImageColor3 = COLORS.greenDark
inventoryList.CanvasSize = UDim2.new()
inventoryList.AutomaticCanvasSize = Enum.AutomaticSize.Y
inventoryList.ZIndex = 21
inventoryList.Parent = inventoryPanel
local inventoryLayout = Instance.new("UIListLayout")
inventoryLayout.Padding = UDim.new(0, 8)
inventoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
inventoryLayout.Parent = inventoryList
local inventoryPadding = Instance.new("UIPadding")
inventoryPadding.PaddingBottom = UDim.new(0, 8)
inventoryPadding.PaddingLeft = UDim.new(0, 2)
inventoryPadding.PaddingRight = UDim.new(0, 8)
inventoryPadding.Parent = inventoryList
local inventoryEmpty = label(inventoryList, "Empty", "Harvest a mature plant and it will appear here.", UDim2.new(1, -10, 0, 76), UDim2.new(), 16, false)
inventoryEmpty.LayoutOrder = 1
inventoryEmpty.ZIndex = 22

local shopPanel = panel("ShopPanel", UDim2.fromOffset(430, 410), UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5))
constrainWidth(shopPanel, 296, 430)
shopPanel.Visible = false
label(shopPanel, "Heading", "HABITAT SEEDS", UDim2.new(1, -130, 0, 44), UDim2.fromOffset(15, 14), 25, true)
local closeShop = button(shopPanel, "Close", "CLOSE", UDim2.fromOffset(100, 34), UDim2.new(1, -116, 0, 14), COLORS.red)
local sunspudHeading = label(shopPanel, "SunspudHeading", "SUNSPUD", UDim2.new(1, -40, 0, 28), UDim2.fromOffset(20, 64), 20, true)
sunspudHeading.TextXAlignment = Enum.TextXAlignment.Left
local sunspudDescription = label(shopPanel, "SunspudDescription", "Always in stock • single harvest", UDim2.new(1, -40, 0, 34), UDim2.fromOffset(20, 92), 14, false)
sunspudDescription.TextXAlignment = Enum.TextXAlignment.Left
local sunspudPrice = label(shopPanel, "SunspudPrice", "5 Leafnotes", UDim2.new(0.46, -24, 0, 42), UDim2.fromOffset(20, 126), 17, true)
local buySunspudButton = button(shopPanel, "BuySunspud", "BUY SUNSPUD", UDim2.new(0.54, -24, 0, 44), UDim2.new(0.46, 4, 0, 125), COLORS.green)

local hearthpetalHeading = label(shopPanel, "HearthpetalHeading", "HEARTHPETAL", UDim2.new(1, -40, 0, 28), UDim2.fromOffset(20, 202), 20, true)
hearthpetalHeading.TextXAlignment = Enum.TextXAlignment.Left
hearthpetalHeading.TextColor3 = Color3.fromRGB(190, 91, 80)
local hearthpetalDescription = label(shopPanel, "HearthpetalDescription", "Warm Habitat Flora • attracts Cozzle", UDim2.new(1, -40, 0, 48), UDim2.fromOffset(20, 232), 14, false)
hearthpetalDescription.TextXAlignment = Enum.TextXAlignment.Left
local hearthpetalPrice = label(shopPanel, "HearthpetalPrice", "8 Leafnotes", UDim2.new(0.46, -24, 0, 42), UDim2.fromOffset(20, 286), 17, true)
local buyHearthpetalButton = button(shopPanel, "BuyHearthpetal", "BUY HEARTHPETAL", UDim2.new(0.54, -24, 0, 44), UDim2.new(0.46, 4, 0, 285), Color3.fromRGB(220, 127, 111))
label(shopPanel, "Experimental", "Experimental values • Cozzle remains wild and unowned", UDim2.new(1, -40, 0, 44), UDim2.fromOffset(20, 346), 13, false)

local sellPanel = panel("SellPanel", UDim2.fromOffset(390, 350), UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5))
constrainWidth(sellPanel, 296, 390)
sellPanel.Visible = false
label(sellPanel, "Heading", "SELL ITEMS", UDim2.new(1, -30, 0, 44), UDim2.fromOffset(15, 14), 25, true)
local heldDescription = label(sellPanel, "Description", "Equip a harvested plant first.", UDim2.new(1, -40, 0, 96), UDim2.fromOffset(20, 65), 17, false)
local sellHeld = button(sellPanel, "SellHeld", "SELL EQUIPPED", UDim2.new(1, -40, 0, 50), UDim2.fromOffset(20, 178), Color3.fromRGB(213, 157, 104))
local sellAllUnfavorited = button(sellPanel, "SellAllUnfavorited", "SELL ALL UNFAVORITED", UDim2.new(1, -40, 0, 50), UDim2.fromOffset(20, 242), Color3.fromRGB(190, 132, 91))
label(sellPanel, "SellAllHint", "Favorites are always protected.", UDim2.new(1, -40, 0, 30), UDim2.fromOffset(20, 298), 13, false)
local closeSell = button(sellPanel, "Close", "CLOSE", UDim2.fromOffset(100, 34), UDim2.new(1, -116, 0, 14), COLORS.red)

local placementPanel = panel("Placement", UDim2.new(1, -24, 0, 112), UDim2.new(0.5, 0, 1, -160), Vector2.new(0.5, 1))
constrainWidth(placementPanel, 296, 390)
placementPanel.Visible = false
local placementStatus = label(placementPanel, "Status", "Click or tap Your Plot soil", UDim2.new(1, -20, 0, 34), UDim2.fromOffset(10, 8), 15, true)
local snapButton = button(placementPanel, "Snap", "SNAP: OFF", UDim2.fromOffset(178, 48), UDim2.fromOffset(10, 52), COLORS.blue)
local cancelPlacement = button(placementPanel, "Cancel", "CANCEL", UDim2.fromOffset(178, 48), UDim2.fromOffset(202, 52), COLORS.red)

local placementReticle = Instance.new("Frame")
placementReticle.Name = "PlacementReticle"
placementReticle.Size = UDim2.fromOffset(24, 24)
placementReticle.AnchorPoint = Vector2.new(0.5, 0.5)
placementReticle.BackgroundTransparency = 1
placementReticle.Visible = false
placementReticle.Parent = placementOverlay
local placementRing = Instance.new("Frame")
placementRing.Name = "Ring"
placementRing.Size = UDim2.fromOffset(18, 18)
placementRing.Position = UDim2.fromScale(0.5, 0.5)
placementRing.AnchorPoint = Vector2.new(0.5, 0.5)
placementRing.BackgroundTransparency = 1
placementRing.Parent = placementReticle
local placementRingCorner = Instance.new("UICorner")
placementRingCorner.CornerRadius = UDim.new(1, 0)
placementRingCorner.Parent = placementRing
local placementRingStroke = Instance.new("UIStroke")
placementRingStroke.Color = COLORS.red
placementRingStroke.Thickness = 3
placementRingStroke.Parent = placementRing
local placementDot = Instance.new("Frame")
placementDot.Name = "Dot"
placementDot.Size = UDim2.fromOffset(5, 5)
placementDot.Position = UDim2.fromScale(0.5, 0.5)
placementDot.AnchorPoint = Vector2.new(0.5, 0.5)
placementDot.BackgroundColor3 = COLORS.red
placementDot.BorderSizePixel = 0
placementDot.Parent = placementReticle
local placementDotCorner = Instance.new("UICorner")
placementDotCorner.CornerRadius = UDim.new(1, 0)
placementDotCorner.Parent = placementDot

local snapshot: any = nil
local pending = false
local placementActive = false
local placementValid = false
local snapEnabled = false
local previewPosition: Vector3? = nil
local placementDefinitionId: string? = nil
local placementStartedAt = 0
local hotbarPage = 1
local noticeToken = 0
local heldItemId: string? = nil
local heldVisualDefinitionId: string? = nil
local heldVisualKind: string? = nil
local heldVisualItemId: string? = nil
local selectedHotbarSlot: number? = nil
local hotbarAssignments: { [number]: any } = {}
local updateUI: () -> ()
local invoke: (any) -> ()

local SEED_REFERENCE_PREFIX = "seed:"

local FRIENDLY_CODES = {
	BUSY = "One action is already being checked.",
	STALE_REVISION = "Your state changed—please try again.",
	INSUFFICIENT_FUNDS = "You need more Leafnotes.",
	NO_SEED = "Buy that seed first.",
	INVALID_PLACEMENT = "Place inside Your Plot and away from the arrival pad.",
	DUPLICATE_PLACEMENT = "A plant already uses that exact spot.",
	PLANT_LIMIT = "This experimental plot limit has been reached.",
	NOT_MATURE = "That plant is still growing.",
	BACKPACK_FULL = "Backpack full—the exact plant stays safely in place.",
	PERSISTENCE_UNAVAILABLE = "Saving is unavailable; nothing was changed.",
	PROFILE_UNAVAILABLE = "Your profile is not ready yet.",
	NO_CHANGE = "That item is already stored in your Backpack.",
	HOTBAR_FULL = "All 10 hotbar slots are full. Store an item in your Backpack first.",
	ITEM_NOT_EQUIPPED = "Equip that harvested plant from the hotbar before selling it.",
	NO_SELLABLE_ITEMS = "There are no unfavorited harvested plants to sell.",
	FORAGE_COOLDOWN = "That wild seed sprout needs time to recover.",
	NO_FORAGE_REWARD = "No eligible seed can fit in your Backpack right now.",
}

local function showNotice(message: string, good: boolean?)
	noticeToken += 1
	local token = noticeToken
	notice.BackgroundColor3 = if good then Color3.fromRGB(224, 244, 205) else COLORS.cream
	noticeText.Text = message
	notice.Visible = true
	task.delay(3, function()
		if noticeToken == token then
			notice.Visible = false
		end
	end)
end

local function catalogEntry(definitionId: string): any?
	return if snapshot and snapshot.catalog then snapshot.catalog[definitionId] else nil
end

local function displayName(definitionId: string): string
	local entry = catalogEntry(definitionId)
	return if entry and type(entry.displayName) == "string" then entry.displayName else definitionId
end

local function hotbarName(definitionId: string): string
	if definitionId == "hearthpetal" then
		return "HEARTH\nPETAL"
	end
	return string.upper(displayName(definitionId))
end

local function setHeldVisual(definitionId: string?, kind: string?, itemId: string?, slotIndex: number?)
	heldVisualDefinitionId = definitionId
	heldVisualKind = kind
	heldVisualItemId = itemId
	selectedHotbarSlot = slotIndex
	heldItemPresentation:setEquipped(definitionId, kind)
end

local function clearHeldVisual()
	setHeldVisual(nil, nil, nil, nil)
end

local seenMythicEvents: { [string]: boolean } = {}
local mythicEventOrder: { string } = {}

local function mythicPart(parent: Instance, name: string, color: Color3, size: Vector3, cframe: CFrame): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Material = Enum.Material.Neon
	part.Color = color
	part.Size = size
	part.CFrame = cframe
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function playMythicSeedPull(message: any)
	if type(message) ~= "table"
		or message.kind ~= "MythicSeedPull"
		or type(message.eventId) ~= "string"
		or type(message.definitionId) ~= "string"
		or message.rarity ~= "Mythic"
		or typeof(message.worldPosition) ~= "Vector3"
		or seenMythicEvents[message.eventId]
	then
		return
	end
	seenMythicEvents[message.eventId] = true
	table.insert(mythicEventOrder, message.eventId)
	while #mythicEventOrder > 32 do
		seenMythicEvents[table.remove(mythicEventOrder, 1)] = nil
	end

	local origin = message.worldPosition
	local folder = Instance.new("Folder")
	folder.Name = "MythicSeedPull_" .. message.eventId
	folder.Parent = workspace

	local ring = mythicPart(folder, "GroundBloom", Color3.fromRGB(191, 112, 255), Vector3.new(0.16, 1.4, 1.4), CFrame.new(origin + Vector3.new(0, 0.12, 0)) * CFrame.Angles(0, 0, math.rad(90)))
	ring.Shape = Enum.PartType.Cylinder
	TweenService:Create(ring, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = Vector3.new(0.12, 12, 12),
		Transparency = 1,
	}):Play()

	local innerRing = mythicPart(folder, "InnerBloom", Color3.fromRGB(255, 225, 113), Vector3.new(0.18, 0.8, 0.8), CFrame.new(origin + Vector3.new(0, 0.16, 0)) * CFrame.Angles(0, 0, math.rad(90)))
	innerRing.Shape = Enum.PartType.Cylinder
	TweenService:Create(innerRing, TweenInfo.new(0.85, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = Vector3.new(0.1, 7, 7),
		Transparency = 1,
	}):Play()

	local seed = mythicPart(folder, "RisingMythicSeed", Color3.fromRGB(255, 219, 86), Vector3.new(0.65, 0.95, 0.65), CFrame.new(origin + Vector3.new(0, 0.35, 0)) * CFrame.Angles(0, 0, math.rad(18)))
	seed.Shape = Enum.PartType.Ball
	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(210, 145, 255)
	light.Brightness = 5
	light.Range = 12
	light.Parent = seed
	TweenService:Create(seed, TweenInfo.new(1.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		CFrame = CFrame.new(origin + Vector3.new(0, 7.5, 0)) * CFrame.Angles(0, math.rad(540), math.rad(-12)),
		Size = Vector3.new(1.7, 2.35, 1.7),
	}):Play()
	TweenService:Create(light, TweenInfo.new(2.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Brightness = 0,
		Range = 18,
	}):Play()

	local seedBillboard = Instance.new("BillboardGui")
	seedBillboard.AlwaysOnTop = true
	seedBillboard.Size = UDim2.fromOffset(230, 55)
	seedBillboard.StudsOffset = Vector3.new(0, 1.7, 0)
	seedBillboard.Parent = seed
	local seedLabel = Instance.new("TextLabel")
	seedLabel.BackgroundTransparency = 1
	seedLabel.Size = UDim2.fromScale(1, 1)
	seedLabel.Font = Enum.Font.GothamBlack
	seedLabel.Text = "MYTHIC SEED!"
	seedLabel.TextColor3 = Color3.fromRGB(255, 229, 120)
	seedLabel.TextStrokeColor3 = Color3.fromRGB(91, 45, 122)
	seedLabel.TextStrokeTransparency = 0
	seedLabel.TextScaled = true
	seedLabel.Parent = seedBillboard

	local random = Random.new()
	for moteIndex = 1, 18 do
		local angle = (moteIndex - 1) * math.pi * 2 / 18
		local startRadius = random:NextNumber(0.4, 1.5)
		local endRadius = random:NextNumber(4.5, 8.5)
		local mote = mythicPart(
			folder,
			"MythicMote" .. moteIndex,
			if moteIndex % 2 == 0 then Color3.fromRGB(203, 130, 255) else Color3.fromRGB(255, 232, 126),
			Vector3.new(0.22, 0.22, 0.22) * random:NextNumber(0.8, 1.8),
			CFrame.new(origin + Vector3.new(math.cos(angle) * startRadius, random:NextNumber(0.2, 1.5), math.sin(angle) * startRadius))
		)
		mote.Shape = Enum.PartType.Ball
		TweenService:Create(mote, TweenInfo.new(random:NextNumber(0.85, 1.45), Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = origin + Vector3.new(math.cos(angle) * endRadius, random:NextNumber(3.5, 8), math.sin(angle) * endRadius),
			Transparency = 1,
		}):Play()
	end

	local banner = Instance.new("Frame")
	banner.Name = "MythicSeedBanner"
	banner.AnchorPoint = Vector2.new(0.5, 0)
	banner.Position = UDim2.new(0.5, 0, 0, -90)
	banner.Size = UDim2.fromOffset(430, 76)
	banner.BackgroundColor3 = Color3.fromRGB(98, 55, 130)
	banner.BackgroundTransparency = 0.08
	banner.ZIndex = 50
	banner.Parent = screen
	round(banner, 18)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new(Color3.fromRGB(99, 57, 139), Color3.fromRGB(211, 139, 88))
	gradient.Parent = banner
	local bannerText = Instance.new("TextLabel")
	bannerText.BackgroundTransparency = 1
	bannerText.Size = UDim2.fromScale(1, 1)
	bannerText.Font = Enum.Font.GothamBlack
	bannerText.Text = "MYTHIC SEED FOUND\n" .. string.upper(displayName(message.definitionId))
	bannerText.TextColor3 = Color3.fromRGB(255, 239, 158)
	bannerText.TextScaled = true
	bannerText.ZIndex = 51
	bannerText.Parent = banner
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.Parent = bannerText
	TweenService:Create(banner, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0, 26),
	}):Play()
	task.delay(2.35, function()
		if banner.Parent then
			local tween = TweenService:Create(banner, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, 0, 0, -95),
			BackgroundTransparency = 1,
			})
			tween:Play()
			tween.Completed:Once(function()
				banner:Destroy()
			end)
		end
	end)
	Debris:AddItem(folder, 3.5)
end

local function currentHeldItem(): any?
	if snapshot and snapshot.backpackItems and #snapshot.backpackItems > 0 then
		for _, item in snapshot.backpackItems do
			if item.id == heldItemId then
				return item
			end
		end
		heldItemId = snapshot.backpackItems[1].id
		return snapshot.backpackItems[1]
	end
	heldItemId = nil
	return nil
end

local function equippedItem(): any?
	local equippedItemId = if snapshot then snapshot.equippedItemId else nil
	if type(equippedItemId) ~= "string" then
		return nil
	end
	for _, item in snapshot.backpackItems or {} do
		if item.id == equippedItemId then
			return item
		end
	end
	return nil
end

local function savedSlotForItem(itemId: string): number?
	if snapshot == nil or type(snapshot.hotbar) ~= "table" then
		return nil
	end
	for slotIndex = 1, 10 do
		if snapshot.hotbar[tostring(slotIndex)] == itemId then
			return slotIndex
		end
	end
	return nil
end

local function renderInventory()
	for _, child in inventoryList:GetChildren() do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	local entries = {}
	for _, item in if snapshot and snapshot.backpackItems then snapshot.backpackItems else {} do
		table.insert(entries, {
			item = item,
			slot = savedSlotForItem(item.id),
		})
	end
	table.sort(entries, function(left, right)
		local leftSlot = left.slot or 100
		local rightSlot = right.slot or 100
		if leftSlot == rightSlot then
			return left.item.id < right.item.id
		end
		return leftSlot < rightSlot
	end)
	inventoryCount.Text = string.format("%d/%d items", #entries, if snapshot then snapshot.backpackCapacity or 0 else 0)
	inventoryEmpty.Visible = #entries == 0
	for index, entry in entries do
		local item = entry.item
		local itemName = displayName(item.definitionId)
		local locationText = if entry.slot then string.format("Hotbar %d", entry.slot) else "Stored"
		local favoriteMark = if item.favorite == true then "★" else "☆"
		local card = button(inventoryList, "Item_" .. item.id, string.format("%s   %.2f wt\n%s", string.upper(itemName), item.weightMilli / 1000, locationText), UDim2.new(1, -10, 0, 64), UDim2.new(), if heldItemId == item.id then COLORS.green else Color3.fromRGB(230, 190, 118))
		card.LayoutOrder = index + 1
		card.TextColor3 = COLORS.brown
		card.TextSize = 16
		card.TextXAlignment = Enum.TextXAlignment.Left
		card.ZIndex = 22
		local cardPadding = Instance.new("UIPadding")
		cardPadding.PaddingLeft = UDim.new(0, 14)
		cardPadding.PaddingRight = UDim.new(0, 56)
		cardPadding.Parent = card
		local favoriteButton = button(card, "Favorite", favoriteMark, UDim2.fromOffset(42, 42), UDim2.new(1, -49, 0.5, -21), if item.favorite == true then COLORS.yellow else COLORS.creamDark)
		favoriteButton.TextColor3 = COLORS.brown
		favoriteButton.TextSize = 24
		favoriteButton.ZIndex = 23
		favoriteButton.Activated:Connect(function()
			invoke({
				action = FarmContracts.Actions.ToggleFavoriteItem,
				itemId = item.id,
				expectedItemRevision = item.revision,
			})
		end)
		card.Activated:Connect(function()
			if entry.slot == nil then
				showNotice("Add that item to the hotbar before equipping it.")
				return
			end
			heldItemId = item.id
			setHeldVisual(item.definitionId, "Item", item.id, entry.slot)
			inventoryPanel.Visible = false
			updateUI()
			invoke({ action = FarmContracts.Actions.EquipHotbarSlot, slotIndex = entry.slot })
			showNotice(string.format("Equipped %s • %.2f weight", itemName, item.weightMilli / 1000), true)
		end)
		card.MouseButton2Click:Connect(function()
			if entry.slot then
				showNotice(string.format("That %s is already in hotbar slot %d.", itemName, entry.slot))
				return
			end
			invoke({
				action = FarmContracts.Actions.AssignHotbarItem,
				itemId = item.id,
				expectedItemRevision = item.revision,
			})
		end)
	end
end

local function updateHotbarLayout()
	local camera = workspace.CurrentCamera
	local narrow = camera ~= nil and camera.ViewportSize.X < 700
	local compactTop = camera ~= nil and camera.ViewportSize.X < 1100
	pageButton.Visible = narrow
	hotbar.Size = if narrow then UDim2.new(1, -12, 0, 80) else UDim2.fromOffset(610, 80)
	stats.Position = if compactTop then UDim2.fromOffset(16, 184) else UDim2.fromOffset(16, 16)
	pageButton.Position = if narrow then UDim2.new(0.5, -125, 1, -102) else UDim2.new(0.5, -333, 1, -36)
	inventoryButton.Position = if narrow then UDim2.new(0, 12, 1, -102) else UDim2.new(0, 16, 1, -18)
	inventoryPanel.Size = if narrow then UDim2.new(1, -24, 0, 330) else UDim2.fromOffset(360, 400)
	inventoryPanel.Position = if narrow then UDim2.new(0, 12, 1, -174) else UDim2.new(0, 16, 1, -94)
	for index, slot in hotbarButtons do
		if narrow then
			slot.Visible = (hotbarPage == 1 and index <= 5) or (hotbarPage == 2 and index >= 6)
		else
			slot.Visible = true
		end
	end
	pageButton.Text = if hotbarPage == 1 then "1–5" else "6–10"
end

updateUI = function()
	updateHotbarLayout()
	if snapshot == nil or snapshot.ok ~= true then
		inventoryButton.Active = false
		renderInventory()
		objectiveText.Text = "Waiting for the server…"
		truthLabel.Text = if snapshot then tostring(snapshot.truthLabel or snapshot.status) else "Loading source…"
		return
	end

	leafnotesLabel.Text = string.format("🍃 Leafnotes: %d", snapshot.leafnotes)
	truthLabel.Text = string.format("%s • %s", snapshot.truthLabel, snapshot.persistenceMode)
	truthLabel.TextColor3 = if snapshot.truthLabel == "Simulated" then Color3.fromRGB(151, 105, 52) else COLORS.brown

	inventoryButton.Active = true
	local step = snapshot.tutorialStep
	if not snapshot.gateCrossed then
		objectiveText.Text = "Walk through the Welcome Gate"
	elseif step == "Buy" then
		objectiveText.Text = "Travel to Shop and buy one Sunspud seed"
	elseif step == "Place" then
		objectiveText.Text = "Select hotbar slot 1 and plant on Your Plot"
	elseif step == "Grow" then
		local mature = false
		local best = 0
		for _, plant in snapshot.plants do
			if plant.definitionId == "sunspud" then
				best = math.max(best, plant.progress or 0)
				mature = mature or (plant.progress or 0) >= 1
			end
		end
		objectiveText.Text = if mature then "Harvest your mature Sunspud" else string.format("Sunspud growing… %d%%", math.floor(best * 100 + 0.5))
	elseif step == "Sell" then
		objectiveText.Text = "Travel to Sell and sell your held Sunspud"
	elseif step == "Complete" then
		objectiveText.Text = "First Sunspud sold — grow another!"
	else
		objectiveText.Text = "Grow your first Sunspud"
	end

	table.clear(hotbarAssignments)
	local itemsById = {}
	for _, item in snapshot.backpackItems or {} do
		itemsById[item.id] = item
	end
	for slotIndex = 1, 10 do
		local reference = snapshot.hotbar and snapshot.hotbar[tostring(slotIndex)]
		local definitionId = if type(reference) == "string" and string.sub(reference, 1, #SEED_REFERENCE_PREFIX) == SEED_REFERENCE_PREFIX
			then string.sub(reference, #SEED_REFERENCE_PREFIX + 1)
			else nil
		if definitionId ~= nil then
			local stack = snapshot.seedStacks and snapshot.seedStacks[definitionId]
			local quantity = if stack then stack.quantity or 0 else 0
			if quantity > 0 then
				hotbarAssignments[slotIndex] = {
					kind = "Seed",
					definitionId = definitionId,
					count = quantity,
				}
			end
		else
			local item = if reference then itemsById[reference] else nil
			if item then
				hotbarAssignments[slotIndex] = { kind = "Item", item = item }
			end
		end
	end

	local held = currentHeldItem()
	if heldVisualKind == "Seed" then
		local stack = if heldVisualDefinitionId and snapshot.seedStacks then snapshot.seedStacks[heldVisualDefinitionId] else nil
		if stack == nil or (stack.quantity or 0) <= 0 then
			clearHeldVisual()
		end
	elseif heldVisualKind == "Item" then
		local visualItem = if heldVisualItemId then itemsById[heldVisualItemId] else nil
		if visualItem == nil then
			clearHeldVisual()
		else
			heldItemPresentation:setEquipped(visualItem.definitionId, "Item")
		end
	end
	for index, slot in hotbarButtons do
		local assignment = hotbarAssignments[index]
		if assignment == nil then
			slot.Text = tostring(index) .. "\nEMPTY"
			slot.BackgroundColor3 = COLORS.creamDark
			slot.TextColor3 = Color3.fromRGB(150, 125, 92)
		elseif assignment.kind == "Seed" then
			slot.Text = string.format("%d\n%s\nSEED ×%d", index, hotbarName(assignment.definitionId), assignment.count)
			local activeColor = if assignment.definitionId == "hearthpetal" then Color3.fromRGB(235, 145, 126) else COLORS.yellow
			slot.BackgroundColor3 = if selectedHotbarSlot == index then COLORS.green elseif assignment.count > 0 then activeColor else COLORS.creamDark
			slot.TextColor3 = COLORS.brown
		else
			local item = assignment.item
			slot.Text = string.format("%d\n%s\n%.2f wt", index, hotbarName(item.definitionId), item.weightMilli / 1000)
			slot.BackgroundColor3 = if selectedHotbarSlot == index or (selectedHotbarSlot == nil and held and held.id == item.id) then COLORS.green else Color3.fromRGB(230, 190, 118)
			slot.TextColor3 = COLORS.brown
		end
	end

	renderInventory()
	local sunspudCatalog = catalogEntry("sunspud")
	if sunspudCatalog then
		sunspudPrice.Text = string.format("%d Leafnotes", sunspudCatalog.seedPrice)
		sunspudDescription.Text = string.format("Always in stock • grows in %d seconds", sunspudCatalog.growthSeconds)
	end
	local hearthpetalCatalog = catalogEntry("hearthpetal")
	if hearthpetalCatalog then
		hearthpetalPrice.Text = string.format("%d Leafnotes", hearthpetalCatalog.seedPrice)
		hearthpetalDescription.Text = string.format("Warm Habitat Flora • grows in %d seconds • attracts Cozzle", hearthpetalCatalog.growthSeconds)
	end
	local equipped = equippedItem()
	if equipped then
		heldDescription.Text = string.format("EQUIPPED: %s\nWeight: %.2f\nSell one uses only this visible item", displayName(equipped.definitionId), equipped.weightMilli / 1000)
		sellHeld.BackgroundColor3 = Color3.fromRGB(213, 157, 104)
		sellHeld.Active = true
	else
		heldDescription.Text = "Equip one harvested plant from the hotbar to sell it individually."
		sellHeld.BackgroundColor3 = Color3.fromRGB(174, 162, 145)
		sellHeld.Active = false
	end
	local unfavoritedCount = 0
	for _, item in snapshot.backpackItems or {} do
		if item.favorite ~= true then
			unfavoritedCount += 1
		end
	end
	sellAllUnfavorited.Text = string.format("SELL ALL UNFAVORITED (%d)", unfavoritedCount)
	sellAllUnfavorited.Active = unfavoritedCount > 0
	sellAllUnfavorited.BackgroundColor3 = if unfavoritedCount > 0 then Color3.fromRGB(190, 132, 91) else Color3.fromRGB(174, 162, 145)

	shopTravel.Active = snapshot.assignedPlotId ~= nil
	plotTravel.Active = snapshot.assignedPlotId ~= nil
	sellTravel.Active = snapshot.assignedPlotId ~= nil
end

local function applyResponse(response: any)
	if type(response) ~= "table" then
		showNotice("The server returned an invalid response.")
		return
	end
	local result = response.result or response
	if result.ok == false and result.action == FarmContracts.Actions.EquipHotbarSlot then
		clearHeldVisual()
	end
	if result.ok == true and result.action == FarmContracts.Actions.HarvestPlant and type(result.itemId) == "string" then
		heldItemId = result.itemId
		setHeldVisual(result.definitionId, "Item", result.itemId, nil)
	elseif result.ok == true and result.action == FarmContracts.Actions.SellItem then
		heldItemId = nil
		if result.itemId == heldVisualItemId then
			clearHeldVisual()
		end
	elseif result.ok == true and result.action == FarmContracts.Actions.UnassignHotbarSlot and result.itemId == heldItemId then
		heldItemId = nil
		if result.itemId == heldVisualItemId then
			clearHeldVisual()
		end
	elseif result.ok == true and result.action == FarmContracts.Actions.AssignHotbarItem and type(result.itemId) == "string" then
		heldItemId = result.itemId
	end
	if type(response.snapshot) == "table" then
		snapshot = response.snapshot
	elseif response.profileRevision ~= nil or response.status ~= nil then
		snapshot = response
	end
	if result.ok == true and result.action == FarmContracts.Actions.HarvestPlant and type(result.itemId) == "string" then
		selectedHotbarSlot = savedSlotForItem(result.itemId)
	elseif result.ok == true and result.action == FarmContracts.Actions.AssignHotbarItem then
		local assigned = equippedItem()
		if assigned then
			setHeldVisual(assigned.definitionId, "Item", assigned.id, result.hotbarSlot)
		end
	elseif result.ok == true and result.action == FarmContracts.Actions.EquipHotbarSlot then
		if result.equippedKind == "Seed" then
			setHeldVisual(result.definitionId, "Seed", nil, result.hotbarSlot)
		elseif result.equippedKind == "Item" then
			setHeldVisual(result.definitionId, "Item", result.itemId, result.hotbarSlot)
		end
	end
	updateUI()
	if result.ok == false and result.code == "FORAGE_COOLDOWN" and type(result.retryAfterSeconds) == "number" then
		showNotice(string.format("This sprout recovers in %d seconds.", math.max(1, math.ceil(result.retryAfterSeconds))))
	elseif response.result and response.result.ok == false then
		showNotice(FRIENDLY_CODES[response.result.code] or tostring(response.result.code))
	elseif response.ok == false and response.code ~= "PROFILE_UNAVAILABLE" then
		showNotice(FRIENDLY_CODES[response.code] or tostring(response.code))
	end
	if result.ok == true then
		if result.action == "BuySeed" then
			local definitionId = result.definitionId or "sunspud"
			showNotice(string.format("%s seed added to hotbar slot %d!", displayName(definitionId), result.hotbarSlot or 1), true)
		elseif result.action == "PlaceSeed" then
			local definitionId = result.definitionId or "sunspud"
			local entry = catalogEntry(definitionId)
			showNotice(string.format("%s planted — %d seconds to grow.", displayName(definitionId), if entry then entry.growthSeconds else 0), true)
		elseif result.action == "HarvestPlant" and result.weightMilli then
			local definitionId = result.definitionId or "sunspud"
			if result.hotbarSlot then
				showNotice(string.format("%s added to hotbar slot %d • %.2f weight", displayName(definitionId), result.hotbarSlot, result.weightMilli / 1000), true)
			else
				showNotice(string.format("Hotbar full — %s stored safely in Backpack.", displayName(definitionId)), true)
			end
		elseif result.action == "SellItem" and result.leafnoteDelta then
			showNotice(string.format("Sold for %d Leafnotes!", result.leafnoteDelta), true)
		elseif result.action == FarmContracts.Actions.SellAllUnfavorited and result.leafnoteDelta then
			showNotice(string.format("Sold %d unfavorited items for %d Leafnotes!", result.soldCount or 0, result.leafnoteDelta), true)
		elseif result.action == FarmContracts.Actions.ToggleFavoriteItem then
			showNotice(if result.favorite == true then "Item favorited — Sell All will protect it." else "Favorite removed.", true)
		elseif result.action == "UnassignHotbarSlot" then
			showNotice("Removed from hotbar — item remains in Backpack.", true)
		elseif result.action == "AssignHotbarItem" and result.hotbarSlot then
			showNotice(string.format("Added item to hotbar slot %d.", result.hotbarSlot), true)
		elseif result.action == "ForageSeed" and type(result.definitionId) == "string" then
			showNotice(string.format("Found a %s %s seed!", tostring(result.rarity or "Wild"), displayName(result.definitionId)), true)
		end
		if result.panel == "Shop" then
			shopPanel.Visible = true
			sellPanel.Visible = false
		elseif result.panel == "Sell" then
			sellPanel.Visible = true
			shopPanel.Visible = false
		elseif result.panel == "Plot" then
			shopPanel.Visible = false
			sellPanel.Visible = false
		end
	end
end

invoke = function(payload: any)
	if pending or snapshot == nil or snapshot.ok ~= true then
		return
	end
	pending = true
	payload.requestId = HttpService:GenerateGUID(false)
	payload.expectedProfileRevision = snapshot.profileRevision
	local ok, response = pcall(function()
		return farmCommand:InvokeServer(payload)
	end)
	pending = false
	if not ok then
		if payload.action == FarmContracts.Actions.EquipHotbarSlot then
			clearHeldVisual()
			updateUI()
		end
		showNotice("The request could not reach the server.")
		return
	end
	applyResponse(response)
end

local function stopPlacement()
	placementActive = false
	placementValid = false
	previewPosition = nil
	placementDefinitionId = nil
	placementPanel.Visible = false
	placementReticle.Visible = false
end

local function startPlacement(definitionId: string): boolean
	local stack = if snapshot and snapshot.seedStacks then snapshot.seedStacks[definitionId] else nil
	if stack == nil or (stack.quantity or 0) <= 0 then
		showNotice(string.format("Buy a %s seed first.", displayName(definitionId)))
		return false
	end
	if placementActive then
		return false
	end
	shopPanel.Visible = false
	sellPanel.Visible = false
	inventoryPanel.Visible = false
	placementActive = true
	placementDefinitionId = definitionId
	placementStartedAt = os.clock()
	placementPanel.Visible = true
	placementReticle.Visible = true
	placementStatus.Text = string.format("Place %s at the reticle center", displayName(definitionId))
	return true
end

local function updatePlacementTarget(pointer: Vector2)
	if not placementActive then
		return
	end
	local camera = workspace.CurrentCamera
	if camera == nil then
		return
	end
	placementReticle.Position = UDim2.fromOffset(pointer.X, pointer.Y)
	-- Pointer APIs return screen coordinates, so keep the ray in the same coordinate space.
	local ray = camera:ScreenPointToRay(pointer.X, pointer.Y)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = if player.Character then { player.Character } else {}
	local result = workspace:Raycast(ray.Origin, ray.Direction * 500, params)
	placementValid = false
	previewPosition = nil
	if result then
		local hit = result.Instance
		local plot = hit.Parent
		placementValid = hit.Name == "SoilBase" and plot ~= nil and plot:GetAttribute("PlotId") == snapshot.assignedPlotId
		previewPosition = result.Position
	end
	local reticleColor = if placementValid then COLORS.green else COLORS.red
	placementRingStroke.Color = reticleColor
	placementDot.BackgroundColor3 = reticleColor
	placementStatus.Text = if placementValid then "Click or tap: plant at reticle center" else "Move the reticle onto Your Plot soil"
end

local function attemptPlacement(pointer: Vector2?)
	if os.clock() - placementStartedAt < 0.15 then
		return
	end
	if pointer then
		updatePlacementTarget(pointer)
	end
	if not placementActive then
		return
	end
	if not placementValid or previewPosition == nil then
		showNotice("Move the placement reticle onto Your Plot soil.")
		return
	end
	local worldPosition = previewPosition
	local shouldSnap = snapEnabled
	local definitionId = placementDefinitionId
	stopPlacement()
	if definitionId then
		invoke({ action = FarmContracts.Actions.PlaceSeed, definitionId = definitionId, worldPosition = worldPosition, snapToGrid = shouldSnap })
	end
end

local function activateHotbarSlot(index: number)
	local assignment = hotbarAssignments[index]
	if assignment == nil then
		showNotice("That hotbar slot is empty.")
	elseif assignment.kind == "Seed" then
		if startPlacement(assignment.definitionId) then
			setHeldVisual(assignment.definitionId, "Seed", nil, index)
			updateUI()
			invoke({ action = FarmContracts.Actions.EquipHotbarSlot, slotIndex = index })
		end
	elseif assignment.kind == "Item" then
		if placementActive then
			stopPlacement()
		end
		heldItemId = assignment.item.id
		setHeldVisual(assignment.item.definitionId, "Item", assignment.item.id, index)
		updateUI()
		invoke({ action = FarmContracts.Actions.EquipHotbarSlot, slotIndex = index })
		showNotice(string.format("Equipped %s • %.2f weight", displayName(assignment.item.definitionId), assignment.item.weightMilli / 1000), true)
	end
end

local HOTBAR_KEYS = {
	[Enum.KeyCode.One] = 1,
	[Enum.KeyCode.Two] = 2,
	[Enum.KeyCode.Three] = 3,
	[Enum.KeyCode.Four] = 4,
	[Enum.KeyCode.Five] = 5,
	[Enum.KeyCode.Six] = 6,
	[Enum.KeyCode.Seven] = 7,
	[Enum.KeyCode.Eight] = 8,
	[Enum.KeyCode.Nine] = 9,
	[Enum.KeyCode.Zero] = 10,
	[Enum.KeyCode.KeypadOne] = 1,
	[Enum.KeyCode.KeypadTwo] = 2,
	[Enum.KeyCode.KeypadThree] = 3,
	[Enum.KeyCode.KeypadFour] = 4,
	[Enum.KeyCode.KeypadFive] = 5,
	[Enum.KeyCode.KeypadSix] = 6,
	[Enum.KeyCode.KeypadSeven] = 7,
	[Enum.KeyCode.KeypadEight] = 8,
	[Enum.KeyCode.KeypadNine] = 9,
	[Enum.KeyCode.KeypadZero] = 10,
}

RunService.RenderStepped:Connect(function()
	if not placementActive then
		return
	end
	local camera = workspace.CurrentCamera
	if camera == nil then
		return
	end
	local pointer = UserInputService:GetMouseLocation()
	if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 then
		pointer = camera.ViewportSize / 2
	end
	updatePlacementTarget(pointer)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	local hotbarSlot = HOTBAR_KEYS[input.KeyCode]
	if hotbarSlot then
		activateHotbarSlot(hotbarSlot)
		return
	end
	if inventoryPanel.Visible and (input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB) then
		inventoryPanel.Visible = false
		return
	end
	if not placementActive then
		return
	end
	if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB then
		stopPlacement()
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		attemptPlacement(UserInputService:GetMouseLocation())
	elseif input.UserInputType == Enum.UserInputType.Touch then
		attemptPlacement(Vector2.new(input.Position.X, input.Position.Y))
	elseif input.KeyCode == Enum.KeyCode.ButtonA then
		local camera = workspace.CurrentCamera
		if camera then
			attemptPlacement(camera.ViewportSize / 2)
		end
	end
end)

stateChanged.OnClientEvent:Connect(function(message)
	applyResponse(message)
end)

foragePresentation.OnClientEvent:Connect(playMythicSeedPull)

shopTravel.Activated:Connect(function()
	invoke({ action = FarmContracts.Actions.Travel, target = FarmContracts.TravelTargets.Shop })
end)
plotTravel.Activated:Connect(function()
	invoke({ action = FarmContracts.Actions.Travel, target = FarmContracts.TravelTargets.Plot })
end)
sellTravel.Activated:Connect(function()
	invoke({ action = FarmContracts.Actions.Travel, target = FarmContracts.TravelTargets.Sell })
end)
closeShop.Activated:Connect(function()
	shopPanel.Visible = false
end)
closeSell.Activated:Connect(function()
	sellPanel.Visible = false
end)
inventoryButton.Activated:Connect(function()
	local opening = not inventoryPanel.Visible
	if opening then
		stopPlacement()
		shopPanel.Visible = false
		sellPanel.Visible = false
		renderInventory()
	end
	inventoryPanel.Visible = opening
end)
closeInventory.Activated:Connect(function()
	inventoryPanel.Visible = false
end)
buySunspudButton.Activated:Connect(function()
	invoke({ action = FarmContracts.Actions.BuySeed, definitionId = "sunspud" })
end)
buyHearthpetalButton.Activated:Connect(function()
	invoke({ action = FarmContracts.Actions.BuySeed, definitionId = "hearthpetal" })
end)
sellHeld.Activated:Connect(function()
	local equipped = equippedItem()
	if equipped then
		invoke({ action = FarmContracts.Actions.SellItem, itemId = equipped.id, expectedItemRevision = equipped.revision })
	else
		showNotice("Equip one harvested plant from the hotbar before selling it.")
	end
end)
sellAllUnfavorited.Activated:Connect(function()
	invoke({ action = FarmContracts.Actions.SellAllUnfavorited })
end)
for index = 1, 10 do
	hotbarButtons[index].Activated:Connect(function()
		activateHotbarSlot(index)
	end)
	hotbarButtons[index].MouseButton2Click:Connect(function()
		local assignment = hotbarAssignments[index]
		if assignment and assignment.kind == "Item" then
			invoke({ action = FarmContracts.Actions.UnassignHotbarSlot, slotIndex = index })
		elseif assignment and assignment.kind == "Seed" then
			showNotice("Use the seed stack or select another item; seed moving comes with the full drag/reorder pass.")
		else
			showNotice("That hotbar slot is already empty.")
		end
	end)
end
cancelPlacement.Activated:Connect(stopPlacement)
snapButton.Activated:Connect(function()
	snapEnabled = not snapEnabled
	snapButton.Text = if snapEnabled then "SNAP: ON" else "SNAP: OFF"
end)
pageButton.Activated:Connect(function()
	hotbarPage = if hotbarPage == 1 then 2 else 1
	updateHotbarLayout()
end)

task.spawn(function()
	while screen.Parent do
		local ok, response = pcall(function()
			return farmQuery:InvokeServer()
		end)
		if ok and type(response) == "table" then
			snapshot = response
			updateUI()
		end
		task.wait(if snapshot and snapshot.ok then 2 else 1)
	end
end)

print("[CatchACreature] Phase 3A farm client started")
