-- WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

-- Gradient Function
function gradient(text, startColor, endColor)
    local result = ""
    local length = #text
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        local char = text:sub(i, i)
        result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
    end
    return result
end

-- Popup
local Confirmed = false
WindUI:Popup({
    Title = gradient("SNT HUB", Color3.fromHex("#eb1010"), Color3.fromHex("#1023eb")),
    Icon = "info",
    Content = gradient("This script made by", Color3.fromHex("#10eb3c"), Color3.fromHex("#67c97a")) .. gradient(" SnowT", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Buttons = {
        {
            Title = gradient("Cancel", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
            Callback = function() end,
            Variant = "Tertiary",
        },
        {
            Title = gradient("Load", Color3.fromHex("#90f09e"), Color3.fromHex("#13ed34")),
            Callback = function() Confirmed = true end,
            Variant = "Secondary",
        }
    }
})

repeat task.wait() until Confirmed

-- Window
local Window = WindUI:CreateWindow({
    Title = gradient("SNT&MIRROZZ HUB", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Icon = "infinity",
    Author = gradient("Grow a Garden", Color3.fromHex("#1bf2b2"), Color3.fromHex("#1bcbf2")),
    Folder = "WindUI",
    Size = UDim2.fromOffset(300, 270),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    UserEnabled = true,
    HasOutline = true,
})

-- Open Button
Window:EditOpenButton({
    Title = "Open UI",
    Icon = "monitor",
    CornerRadius = UDim.new(2, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("1E213D"),
        Color3.fromHex("1F75FE")
    ),
    Draggable = true,
})

-- Tabs
local Tabs = {
    MainTab = Window:Tab({ Title = gradient("MAIN", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "terminal" }),
    CharacterTab = Window:Tab({ Title = gradient("CHARACTER", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "file-cog" }),
    TeleportTab = Window:Tab({ Title = gradient("TELEPORT", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "user" }),
    AutofarmTab = Window:Tab({ Title = gradient("AUTOFARM", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "apple" }),
    ShopTab = Window:Tab({ Title = gradient("SHOP", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "shovel" }),
    PetTab = Window:Tab({ Title = gradient("PETS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "cat" }),
    EventTab = Window:Tab({ Title = gradient("EVENT", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "circle" }),
    CosmTab = Window:Tab({ Title = gradient("COSMETICS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "star" }),
}

-- Character Settings (unchanged)
local CharacterSettings = {
    WalkSpeed = {Value = 16, Default = 16, Locked = false},
    JumpPower = {Value = 50, Default = 50, Locked = false}
}

local function updateCharacter()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if not CharacterSettings.WalkSpeed.Locked then
            humanoid.WalkSpeed = CharacterSettings.WalkSpeed.Value
        end
        if not CharacterSettings.JumpPower.Locked then
            humanoid.JumpPower = CharacterSettings.JumpPower.Value
        end
    end
end

Tabs.CharacterTab:Section({Title = gradient("Walkspeed", Color3.fromHex("#ff0000"), Color3.fromHex("#300000"))})

Tabs.CharacterTab:Slider({
    Title = "Walkspeed",
    Value = {Min = 0, Max = 200, Default = 16},
    Callback = function(value)
        CharacterSettings.WalkSpeed.Value = value
        updateCharacter()
    end
})

Tabs.CharacterTab:Button({
    Title = "Reset walkspeed",
    Callback = function()
        CharacterSettings.WalkSpeed.Value = CharacterSettings.WalkSpeed.Default
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Block walkspeed",
    Default = false,
    Callback = function(state)
        CharacterSettings.WalkSpeed.Locked = state
        updateCharacter()
    end
})

Tabs.CharacterTab:Section({Title = gradient("JumpPower", Color3.fromHex("#001aff"), Color3.fromHex("#020524"))})

Tabs.CharacterTab:Slider({
    Title = "Jumppower",
    Value = {Min = 0, Max = 200, Default = 50},
    Callback = function(value)
        CharacterSettings.JumpPower.Value = value
        updateCharacter()
    end
})

Tabs.CharacterTab:Button({
    Title = "Reset jumppower",
    Callback = function()
        CharacterSettings.JumpPower.Value = CharacterSettings.JumpPower.Default
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Block jumppower",
    Default = false,
    Callback = function(state)
        CharacterSettings.JumpPower.Locked = state
        updateCharacter()
    end
})

-- Teleport (unchanged)
Tabs.TeleportTab:Section({Title = gradient("Teleport to players", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))})

local teleportTarget = nil
local teleportDropdown = nil

local function updateTeleportPlayers()
    local playersList = {"Select Player"}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playersList, player.Name)
        end
    end
    return playersList
end

local function initializeTeleportDropdown()
    teleportDropdown = Tabs.TeleportTab:Dropdown({
        Title = "Players",
        Values = updateTeleportPlayers(),
        Value = "Select Player",
        Callback = function(selected)
            if selected ~= "Select Player" then
                teleportTarget = Players:FindFirstChild(selected)
            else
                teleportTarget = nil
            end
        end
    })
end

initializeTeleportDropdown()

Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    if teleportDropdown then
        teleportDropdown:Refresh(updateTeleportPlayers())
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if teleportDropdown then
        teleportDropdown:Refresh(updateTeleportPlayers())
    end
end)

local function teleportToPlayer()
    if teleportTarget and teleportTarget.Character then
        local targetRoot = teleportTarget.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame
            WindUI:Notify({
                Title = "Teleport System",
                Content = "Teleported to " .. teleportTarget.Name,
                Icon = "check-circle",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Target not found",
                Icon = "x-circle",
                Duration = 3
            })
        end
    else
        WindUI:Notify({
            Title = "Error",
            Content = "Target not found",
            Icon = "x-circle",
            Duration = 3
        })
    end
end

Tabs.TeleportTab:Button({
    Title = "Teleport to Player",
    Callback = teleportToPlayer
})

Tabs.TeleportTab:Button({
    Title = "Update Players List",
    Callback = function()
        teleportDropdown:Refresh(updateTeleportPlayers())
    end
})

-- Required Arrays (unchanged)
local AllSeedNames = {
    "Carrot Seed", "Strawberry Seed", "Blueberry Seed", "Orange Tulip", "Tomato Seed",
    "Corn Seed", "Daffodil Seed", "Watermelon Seed", "Pumpkin Seed", "Apple Seed",
    "Bamboo Seed", "Coconut Seed", "Cactus Seed", "Dragon Fruit Seed", "Mango Seed",
    "Grape Seed", "Mushroom Seed", "Pepper Seed", "Cacao Seed", "Beanstalk Seed",
    "Pineapple Seed", "Raspberry Seed", "Peach Seed", "Papaya Seed", "Banana Seed",
    "Passionfruit Seed", "Soul Fruit Seed", "Cursed Fruit Seed", "Succulent Seed",
    "Cranberry Seed", "Durian Seed", "Eggplant Seed", "Lotus Seed", "Venus Fly Trap Seed",
    "Pear Seed", "Lemon Seed", "Cherry Blossom Seed", "Avocado Seed", "Nightshade Seed",
    "Glowshroom Seed", "Mint Seed", "Moonflower Seed", "Starfruit Seed", "Moonglow Seed",
    "Moon Blossom Seed", "Chocolate Carrot Seed", "Red Lollipop Seed", "Candy Sunflower Seed",
    "Easter Egg Seed", "Candy Blossom Seed", "Crimson Vine Seed", "Moon Melon Seed",
    "Blood Banana Seed", "Moon Mango Seed", "Celestiberry Seed"
}

local AllFruits = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", 
    "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", 
    "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", 
    "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", 
    "Chocolate Carrot", "Red Lollipop", "Blue Lollipop", "Candy Sunflower", 
    "Easter Egg", "Candy Blossom", "Peach", "Raspberry", "Pineapple", 
    "Papaya", "Banana", "Passionfruit", "Soul Fruit", "Cursed Fruit", 
    "Mega Mushroom", "Cherry Blossom", "Purple Cabbage", "Lemon", "Pear", 
    "Crocus", "Pink Tulip", "Succulent", "Avocado", "Cranberry", 
    "Durian", "Eggplant", "Lotus", "Venus Fly Trap", "Nightshade", 
    "Glowshroom", "Mint", "Moonflower", "Starfruit", "Moonglow", 
    "Moon Blossom", "Crimson Vine", "Moon Melon", "Blood Banana", 
    "Celestiberry", "Moon Mango"
}

-- Integrated Functions from autofarm.lua.txt
local MyFarm = nil -- Will store the player's farm

local function GetFarm(PlayerName)
    local Farms = Workspace.Farm:GetChildren()
    for _, Farm in ipairs(Farms) do
        local Important = Farm:FindFirstChild("Important")
        local Data = Important and Important:FindFirstChild("Data")
        local Owner = Data and Data:FindFirstChild("Owner")
        if Owner and Owner.Value == PlayerName then
            return Farm
        end
    end
    WindUI:Notify({
        Title = "Error",
        Content = "Player farm not found",
        Icon = "x-circle",
        Duration = 3
    })
    return nil
end

local IsSelling = false
local function SellInventory()
    if IsSelling then return false end
    IsSelling = true

    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        WindUI:Notify({
            Title = "Error",
            Content = "No character found",
            Icon = "x-circle",
            Duration = 3
        })
        IsSelling = false
        return false
    end

    local Previous = Character:GetPivot()
    local PreviousSheckles = LocalPlayer.leaderstats.Sheckles.Value

    Character:PivotTo(CFrame.new(62, 4, -26)) -- Sell stand position
    task.wait(0.5)
    local success, err = pcall(function()
        ReplicatedStorage.GameEvents.Sell_Inventory:FireServer()
    end)
    if success then
        while task.wait() do
            if LocalPlayer.leaderstats.Sheckles.Value ~= PreviousSheckles then break end
            ReplicatedStorage.GameEvents.Sell_Inventory:FireServer()
        end
    end
    Character:PivotTo(Previous)
    task.wait(0.2)
    IsSelling = false
    return true
end

local SeedStock = {}
local function GetSeedStock(IgnoreNoStock)
    local SeedShop = PlayerGui:FindFirstChild("Seed_Shop")
    if not SeedShop then return {} end
    local Items = SeedShop:FindFirstChild("Blueberry", true)
    Items = Items and Items.Parent
    if not Items then return {} end

    local NewList = {}
    for _, Item in ipairs(Items:GetChildren()) do
        local MainFrame = Item:FindFirstChild("Main_Frame")
        if not MainFrame then continue end
        local StockText = MainFrame:FindFirstChild("Stock_Text")
        if not StockText then continue end
        local StockCount = tonumber(StockText.Text:match("%d+"))
        if not StockCount then continue end
        if IgnoreNoStock and StockCount <= 0 then continue end
        NewList[Item.Name .. " Seed"] = StockCount -- Append " Seed" to match AllSeedNames
        SeedStock[Item.Name .. " Seed"] = StockCount
    end
    return IgnoreNoStock and NewList or SeedStock
end

local function GetHarvestablePlants(IgnoreDistance)
    local Plants = {}
    if not MyFarm or not MyFarm:FindFirstChild("Important") or not MyFarm.Important:FindFirstChild("Plants_Physical") then
        return Plants
    end
    local Character = LocalPlayer.Character
    local PlayerPosition = Character and Character:GetPivot().Position
    local PlantsPhysical = MyFarm.Important.Plants_Physical

    local function CollectHarvestable(Parent)
        for _, Plant in ipairs(Parent:GetChildren()) do
            local Fruits = Plant:FindFirstChild("Fruits")
            if Fruits then
                CollectHarvestable(Fruits)
            end
            local Prompt = Plant:FindFirstChild("ProximityPrompt", true)
            if not Prompt or not Prompt.Enabled then continue end
            if not IgnoreDistance then
                local PlantPosition = Plant:GetPivot().Position
                local Distance = (PlayerPosition - PlantPosition).Magnitude
                if Distance > 15 then continue end
            end
            table.insert(Plants, Plant)
        end
    end
    CollectHarvestable(PlantsPhysical)
    return Plants
end

-- Initialize Farm
MyFarm = GetFarm(LocalPlayer.Name)

-- Plant Function (notifications removed)
local function PlantSeed(seedName, isAuto)
    if not MyFarm then
        if not isAuto then
            WindUI:Notify({
                Title = "Error",
                Content = "Player farm not found",
                Icon = "x-circle",
                Duration = 3
            })
        end
        return false
    end

    local plantLocations = MyFarm:FindFirstChild("Important") and MyFarm.Important:FindFirstChild("Plant_Locations")
    if not plantLocations then
        if not isAuto then
            WindUI:Notify({
                Title = "Error",
                Content = "Plant_Locations not found",
                Icon = "x-circle",
                Duration = 3
            })
        end
        return false
    end

    local locations = plantLocations:GetChildren()
    for _, location in ipairs(locations) do
        if location:FindFirstChild("Can_Plant") and location.Can_Plant.Value then
            local args = {
                [1] = location.Position,
                [2] = seedName:gsub(" Seed", "")
            }
            local success, err = pcall(function()
                ReplicatedStorage.GameEvents.Plant_RE:FireServer(unpack(args))
            end)
            if success then
                return true
            end
        end
    end
    return false
end

-- Modified Collect Function (uses HoldToCollect button)
local function CollectFruit()
    if not MyFarm or not MyFarm:FindFirstChild("Important") or not MyFarm.Important:FindFirstChild("Plants_Physical") then
        WindUI:Notify({
            Title = "Error",
            Content = "Player farm or Plants_Physical not found",
            Icon = "x-circle",
            Duration = 3
        })
        return
    end

    local HoldToCollect = PlayerGui:FindFirstChild("HoldToCollect")
    local CollectButton = HoldToCollect and HoldToCollect:FindFirstChild("Collect")
    if not CollectButton then
        WindUI:Notify({
            Title = "Error",
            Content = "HoldToCollect button not found",
            Icon = "x-circle",
            Duration = 3
        })
        return
    end

    local collected = 0
    for _, plant in ipairs(MyFarm.Important.Plants_Physical:GetChildren()) do
        if plant:FindFirstChild("Fruits") then
            for _, fruit in ipairs(plant.Fruits:GetChildren()) do
                if fruit:FindFirstChild("ProximityPrompt") then
                    local success, err = pcall(function()
                        fireclickdetector(CollectButton:FindFirstChildOfClass("ClickDetector") or CollectButton)
                    end)
                    if success then
                        collected = collected + 1
                    end
                    task.wait(0.1)
                    if collected >= 5 then return end
                end
            end
        end
    end
end

-- Teleport to Farm (notifications removed)
local function teleportToFarm()
    if not MyFarm or not MyFarm:FindFirstChild("Center_Point") then
        WindUI:Notify({
            Title = "Error",
            Content = "Farm Center_Point not found",
            Icon = "x-circle",
            Duration = 3
        })
        return false
    end
    local farmPos = MyFarm.Center_Point.Position
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidPoint.CFrame = CFrame.new(farmPos + Vector3.new(0, 3, 0))
        task.wait(0.5)
        return true
    end
    return false
end

-- Autofarm Variables
local AutoPlantEnabled = false
local AutoPlantSelectedEnabled = false
local PlantDelay = 0.2
local SelectedSeed = "None"
local LastPlantTime = 0

local AutoCollectEnabled = false
local CollectDelay = 0.2
local LastCollectTime = 0

local BuyDelay = 0.2
local AutoBuyEnabled = false
local AutoBuyAllEnabled = false
local SellInterval = 5
local AutoSellInventoryEnabled = false
local LastSellTime = 0
local CurrentBuyIndex = 1

-- Auto-Walk and NoClip Variables
local AutoWalkEnabled = false
local AutoWalkAllowRandom = true
local AutoWalkMaxWait = 10
local NoClipEnabled = false
local AutoWalkStatus = "None"

-- Auto-Walk and NoClip Functions
local function GetRandomFarmPoint()
    if not MyFarm or not MyFarm:FindFirstChild("Important") or not MyFarm.Important:FindFirstChild("Plant_Locations") then
        return nil
    end
    local FarmLands = MyFarm.Important.Plant_Locations:GetChildren()
    local FarmLand = FarmLands[math.random(1, #FarmLands)]
    local Center = FarmLand:GetPivot()
    local Size = FarmLand.Size
    local X1 = math.ceil(Center.X - (Size.X/2))
    local Z1 = math.ceil(Center.Z - (Size.Z/2))
    local X2 = math.floor(Center.X + (Size.X/2))
    local Z2 = math.floor(Center.Z + (Size.Z/2))
    local X = math.random(X1, X2)
    local Z = math.random(Z1, Z2)
    return Vector3.new(X, 4, Z)
end

local AutoWalkLoop
local function StartAutoWalk()
    if AutoWalkEnabled and not IsSelling then
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid then return end

        local Plants = GetHarvestablePlants(true)
        local DoRandom = AutoWalkAllowRandom and (#Plants == 0 or math.random(1, 3) == 2)

        if DoRandom then
            local Position = GetRandomFarmPoint()
            if Position then
                Humanoid:MoveTo(Position)
                AutoWalkStatus = "Random point"
            end
        else
            for _, Plant in ipairs(Plants) do
                local Position = Plant:GetPivot().Position
                Humanoid:MoveTo(Position)
                AutoWalkStatus = Plant.Name
                break -- Move to one plant per cycle
            end
        end
    end
end

local function NoclipLoop()
    if not NoClipEnabled then return end
    local Character = LocalPlayer.Character
    if not Character then return end
    for _, Part in ipairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") then
            Part.CanCollide = false
        end
    end
end

-- Autofarm Tab
Tabs.AutofarmTab:Section({
    Title = gradient("Farm Info", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

Tabs.AutofarmTab:Button({
    Title = "Show Farm Number",
    Callback = function()
        if MyFarm then
            local farmIndex = table.find(Workspace.Farm:GetChildren(), MyFarm)
            WindUI:Notify({
                Title = "Farm Info",
                Content = "Your farm number is " .. (farmIndex or "Unknown"),
                Icon = "info",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Player farm not found",
                Icon = "x-circle",
                Duration = 3
            })
        end
    end
})

Tabs.AutofarmTab:Section({
    Title = gradient("Plant", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

local PlantLoop
Tabs.AutofarmTab:Toggle({
    Title = "Auto Plant Seeds",
    Default = false,
    Callback = function(state)
        AutoPlantEnabled = state
        if state then
            PlantLoop = RunService.Heartbeat:Connect(function()
                if tick() - LastPlantTime >= PlantDelay then
                    local planted = 0
                    for _, seedName in ipairs(AllSeedNames) do
                        if PlantSeed(seedName, true) then
                            planted = planted + 1
                        end
                        task.wait(0.1)
                        if planted >= 5 then break end
                    end
                    LastPlantTime = tick()
                end
            end)
        elseif PlantLoop then
            PlantLoop:Disconnect()
        end
    end
})

Tabs.AutofarmTab:Slider({
    Title = "Plant Delay",
    Step = 0.1,
    Value = {Min = 0.1, Max = 2.5, Default = 0.2},
    Callback = function(value)
        PlantDelay = value
    end
})

Tabs.AutofarmTab:Dropdown({
    Title = "Select Seed",
    Values = AllSeedNames,
    Value = "None",
    Callback = function(selected)
        SelectedSeed = selected
    end
})

local SelectedPlantLoop
Tabs.AutofarmTab:Toggle({
    Title = "Auto Plant Selected",
    Default = false,
    Callback = function(state)
        AutoPlantSelectedEnabled = state
        if state and SelectedSeed ~= "None" then
            SelectedPlantLoop = RunService.Heartbeat:Connect(function()
                if tick() - LastPlantTime >= PlantDelay then
                    PlantSeed(SelectedSeed, true)
                    LastPlantTime = tick()
                end
            end)
        elseif SelectedPlantLoop then
            SelectedPlantLoop:Disconnect()
        end
    end
})

Tabs.AutofarmTab:Slider({
    Title = "Plant Selected Delay",
    Step = 0.1,
    Value = {Min = 0.1, Max = 2.5, Default = 0.2},
    Callback = function(value)
        PlantDelay = value
    end
})

Tabs.AutofarmTab:Section({
    Title = gradient("Collect", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

local CollectLoop
Tabs.AutofarmTab:Toggle({
    Title = "Auto Collect Plants",
    Default = false,
    Callback = function(state)
        AutoCollectEnabled = state
        if state then
            CollectLoop = RunService.Heartbeat:Connect(function()
                if tick() - LastCollectTime >= CollectDelay then
                    CollectFruit()
                    LastCollectTime = tick()
                end
            end)
        elseif CollectLoop then
            CollectLoop:Disconnect()
        end
    end
})

Tabs.AutofarmTab:Slider({
    Title = "Collect Delay",
    Step = 0.1,
    Value = {Min = 0.1, Max = 2.5, Default = 0.2},
    Callback = function(value)
        CollectDelay = value
    end
})

-- Auto-Walk Section
Tabs.AutofarmTab:Section({
    Title = gradient("Auto-Walk", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

Tabs.AutofarmTab:Label({
    Title = "Walk Status: " .. AutoWalkStatus
})

local AutoWalkConnection
Tabs.AutofarmTab:Toggle({
    Title = "Auto Walk",
    Default = false,
    Callback = function(state)
        AutoWalkEnabled = state
        if state then
            AutoWalkConnection = RunService.Heartbeat:Connect(function()
                StartAutoWalk()
                task.wait(math.random(1, AutoWalkMaxWait))
            end)
        elseif AutoWalkConnection then
            AutoWalkConnection:Disconnect()
            AutoWalkStatus = "None"
        end
    end
})

Tabs.AutofarmTab:Toggle({
    Title = "Allow Random Points",
    Default = true,
    Callback = function(state)
        AutoWalkAllowRandom = state
    end
})

Tabs.AutofarmTab:Slider({
    Title = "Max Walk Delay",
    Step = 1,
    Value = {Min = 1, Max = 120, Default = 10},
    Callback = function(value)
        AutoWalkMaxWait = value
    end
})

Tabs.AutofarmTab:Toggle({
    Title = "NoClip",
    Default = false,
    Callback = function(state)
        NoClipEnabled = state
        if not state then
            local Character = LocalPlayer.Character
            if Character then
                for _, Part in ipairs(Character:GetDescendants()) do
                    if Part:IsA("BasePart") then
                        Part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- Shop Tab
Tabs.ShopTab:Section({
    Title = gradient("Buy Seeds", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

local buyDropdown
buyDropdown = Tabs.ShopTab:Dropdown({
    Title = "Select Seed to Buy",
    Values = { "None" }, -- Initialize with "None"
    Value = "None",
    Callback = function(selected)
        SelectedSeed = selected
    end
})

-- Initialize and refresh dropdown with seed names
local function refreshBuyDropdown()
    local seeds = GetSeedStock(true)
    local seedNames = { "None" }
    for seed, _ in pairs(seeds) do
        table.insert(seedNames, seed)
    end
    table.sort(seedNames) -- Sort for consistency
    buyDropdown:Refresh(seedNames)
end
refreshBuyDropdown()

Tabs.ShopTab:Button({
    Title = "Refresh Seed List",
    Callback = function()
        refreshBuyDropdown()
    end
})

Tabs.ShopTab:Button({
    Title = "Buy Selected Seed",
    Callback = function()
        if SelectedSeed ~= "None" then
            local args = {[1] = SelectedSeed:gsub(" Seed", "")}
            local success, err = pcall(function()
                ReplicatedStorage.GameEvents.BuySeedStock:FireServer(unpack(args))
            end)
            refreshBuyDropdown() -- Refresh after buying
        end
    end
})

local AutoBuyLoop
Tabs.ShopTab:Toggle({
    Title = "Auto Buy Selected Seed",
    Default = false,
    Callback = function(state)
        AutoBuyEnabled = state
        if state and SelectedSeed ~= "None" then
            AutoBuyLoop = RunService.Heartbeat:Connect(function()
                if tick() - LastPlantTime >= BuyDelay then
                    local args = {[1] = SelectedSeed:gsub(" Seed", "")}
                    local success, err = pcall(function()
                        ReplicatedStorage.GameEvents.BuySeedStock:FireServer(unpack(args))
                    end)
                    refreshBuyDropdown()
                    LastPlantTime = tick()
                end
            end)
        elseif AutoBuyLoop then
            AutoBuyLoop:Disconnect()
        end
    end
})

local AutoBuyAllLoop
Tabs.ShopTab:Toggle({
    Title = "Auto Buy All Seeds",
    Default = false,
    Callback = function(state)
        AutoBuyAllEnabled = state
        if state then
            AutoBuyAllLoop = RunService.Heartbeat:Connect(function()
                if tick() - LastPlantTime >= BuyDelay then
                    local availableSeeds = GetSeedStock(true)
                    local seedNames = {}
                    for seed, _ in pairs(availableSeeds) do
                        table.insert(seedNames, seed)
                    end
                    if #seedNames > 0 then
                        local seed = seedNames[CurrentBuyIndex] or seedNames[1]
                        local args = {[1] = seed:gsub(" Seed", "")}
                        local success, err = pcall(function()
                            ReplicatedStorage.GameEvents.BuySeedStock:FireServer(unpack(args))
                        end)
                        if SeedStock[seed] and SeedStock[seed] <= 0 then
                            CurrentBuyIndex = CurrentBuyIndex + 1
                        end
                        if CurrentBuyIndex > #seedNames then
                            CurrentBuyIndex = 1
                        end
                        refreshBuyDropdown()
                    end
                    LastPlantTime = tick()
                end
            end)
        elseif AutoBuyAllLoop then
            AutoBuyAllLoop:Disconnect()
            CurrentBuyIndex = 1
        end
    end
})

Tabs.ShopTab:Slider({
    Title = "Buy Delay",
    Step = 0.1,
    Value = {Min = 0.1, Max = 2.5, Default = 0.2},
    Callback = function(value)
        BuyDelay = value
    end
})

Tabs.ShopTab:Section({
    Title = gradient("Sell", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

local AutoSellInventoryLoop
Tabs.ShopTab:Toggle({
    Title = "Auto Sell Inventory",
    Default = false,
    Callback = function(state)
        AutoSellInventoryEnabled = state
        if state then
            AutoSellInventoryLoop = RunService.Heartbeat:Connect(function()
                if tick() - LastSellTime >= SellInterval then
                    SellInventory()
                    LastSellTime = tick()
                end
            end)
        elseif AutoSellInventoryLoop then
            AutoSellInventoryLoop:Disconnect()
        end
    end
})

Tabs.ShopTab:Slider({
    Title = "Sell Interval (Seconds)",
    Step = 1,
    Value = {Min = 1, Max = 60, Default = 5},
    Callback = function(value)
        SellInterval = value
    end
})

-- Connections
RunService.Stepped:Connect(NoclipLoop)