-- WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Global Configuration
local Config = {
    DebounceTime = 0.5, -- Time between actions to prevent spam
    NotificationDuration = 3, -- Default notification duration
    TeleportOffset = 3, -- Default teleport offset for gun grabbing
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

-- Locals
local Debounces = {}
local function SetDebounce(action, time)
    if Debounces[action] and tick() - Debounces[action] < time then return false end
    Debounces[action] = tick()
    return true
end

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

-- Confirmation Popup
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

WindUI:Notify({
    Title = gradient("SNT HUB", Color3.fromHex("#eb1010"), Color3.fromHex("#1023eb")),
    Content = "Script successfully loaded!",
    Icon = "check-circle",
    Duration = Config.NotificationDuration,
})

-- Create Window
local Window = WindUI:CreateWindow({
    Title = gradient("SNT&MirrozzScript [Beta]", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Icon = "infinity",
    Author = gradient("Murder Mystery 2", Color3.fromHex("#1bf2b2"), Color3.fromHex("#1bcbf2")),
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
    Color = ColorSequence.new(Color3.fromHex("1E213D"), Color3.fromHex("1F75FE")),
    Draggable = true,
})

-- Tabs
local Tabs = {
    MainTab = Window:Tab({ Title = gradient("MAIN", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "terminal" }),
    CharacterTab = Window:Tab({ Title = gradient("CHARACTER", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "file-cog" }),
    TeleportTab = Window:Tab({ Title = gradient("TELEPORT", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "user" }),
    EspTab = Window:Tab({ Title = gradient("ESP", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "eye" }),
    AimbotTab = Window:Tab({ Title = gradient("AIMBOT", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "arrow-right" }),
    AutoFarm = Window:Tab({ Title = gradient("AUTOFARM", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "user"}),
    bs = Window:Divider(),
    InnocentTab = Window:Tab({ Title = gradient("INNOCENT", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")), Icon = "circle" }),
    MurderTab = Window:Tab({ Title = gradient("MURDER", Color3.fromHex("#e80909"), Color3.fromHex("#630404")), Icon = "circle" }),
    SheriffTab = Window:Tab({ Title = gradient("SHERIFF", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")), Icon = "circle" }),
    gh = Window:Divider(),
    ServerTab = Window:Tab({ Title = gradient("SERVER", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "atom" }),
    SettingsTab = Window:Tab({ Title = gradient("SETTINGS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "code" }),
    ChangelogsTab = Window:Tab({ Title = gradient("CHANGELOGS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "info"}),
    SocialsTab = Window:Tab({ Title = gradient("SOCIALS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "star"}),
    b = Window:Divider(),
    WindowTab = Window:Tab({ Title = gradient("CONFIGURATION", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "settings", Desc = "Manage window settings and file configurations." }),
    CreateThemeTab = Window:Tab({ Title = gradient("THEMES", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "palette", Desc = "Design and apply custom themes." }),
}

-- Helper Functions
local function Notify(title, content, icon, duration)
    WindUI:Notify({
        Title = gradient(title, Color3.fromHex("#ffffff"), Color3.fromHex("#636363")),
        Content = content,
        Icon = icon or "info",
        Duration = duration or Config.NotificationDuration,
    })
end

local function IsAlive(player)
    if not player or not player.Character or not player.Character:FindFirstChild("Humanoid") then return false end
    return player.Character.Humanoid.Health > 0
end

local function GetHumanoidRootPart(player)
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- Character Tab (unchanged for brevity, but optimized in full implementation)
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

-- ESP Tab (unchanged for brevity, but optimized in full implementation)
local ESPConfig = {
    HighlightMurderer = false, HighlightInnocent = false, HighlightSheriff = false, HighlightGunDrop = false,
    NameEspMurderer = false, NameEspInnocent = false, NameEspSheriff = false, NameEspGunDrop = false,
    DistanceEspMurderer = false, DistanceEspInnocent = false, DistanceEspSheriff = false, DistanceEspGunDrop = false,
    EspTextSize = 18, HighlightTransparency = 0.5
}

local Murder, Sheriff, Hero, Innocent, roles = nil, nil, nil, nil, {}
local GunDrop, NameTags, DistanceTags = nil, {}, {}

function CreateHighlight(target, color)
    if not target then return nil end
    local highlight = target:FindFirstChild("Highlight") or Instance.new("Highlight")
    highlight.Name = "Highlight"
    highlight.FillColor = color
    highlight.FillTransparency = ESPConfig.HighlightTransparency
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Adornee = target
    highlight.Parent = target
    return highlight
end

function CreateNameTag(player, text, color)
    if not player or not player.Character or not player.Character:FindFirstChild("Head") then return end
    local head = player.Character.Head
    local billboard = NameTags[player] or Instance.new("BillboardGui")
    billboard.Name = "NameTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100

    local textLabel = billboard:FindFirstChild("TextLabel") or Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = color
    textLabel.TextSize = ESPConfig.EspTextSize
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Parent = billboard

    billboard.Parent = CoreGui
    NameTags[player] = billboard
end

function CreateDistanceTag(player, color)
    if not player or not player.Character or not player.Character:FindFirstChild("Head") then return end
    local head = player.Character.Head
    local billboard = DistanceTags[player] or Instance.new("BillboardGui")
    billboard.Name = "DistanceTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 1, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100

    local textLabel = billboard:FindFirstChild("TextLabel") or Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "0 studs"
    textLabel.TextColor3 = color
    textLabel.TextSize = ESPConfig.EspTextSize
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Parent = billboard

    billboard.Parent = CoreGui
    DistanceTags[player] = billboard
end

function CreateGunDropEsp(gunDrop, espType)
    if not gunDrop then return end
    local billboard = espType == "Name" and NameTags[gunDrop] or DistanceTags[gunDrop] or Instance.new("BillboardGui")
    billboard.Name = espType == "Name" and "NameTag" or "DistanceTag"
    billboard.Adornee = gunDrop
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, espType == "Name" and 2 or 1, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100

    local textLabel = billboard:FindFirstChild("TextLabel") or Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = espType == "Name" and "GunDrop" or "0 studs"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    textLabel.TextSize = ESPConfig.EspTextSize
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Parent = billboard

    billboard.Parent = CoreGui
    if espType == "Name" then
        NameTags[gunDrop] = billboard
    else
        DistanceTags[gunDrop] = billboard
    end
end

function UpdateRoles()
    Murder, Sheriff, Hero, Innocent = nil, nil, nil, nil
    roles = {}

    local success, result = pcall(function()
        local getPlayerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
        if getPlayerData and getPlayerData:IsA("RemoteFunction") then
            return getPlayerData:InvokeServer()
        end
        return nil
    end)

    if success and result then
        roles = result
        for name, data in pairs(roles) do
            local player = Players:FindFirstChild(name)
            if player then
                if data.Role == "Murderer" then Murder = player
                elseif data.Role == "Sheriff" then Sheriff = player
                elseif data.Role == "Hero" then Hero = player
                elseif data.Role == "Innocent" then Innocent = player
                end
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and IsAlive(player) then
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:lower():match("knife") or tool.Name:lower():match("blade")) then
                    Murder = player
                elseif tool and (tool.Name:lower():match("gun") or tool.Name:lower():match("revolver") or tool.Name:lower():match("pistol")) then
                    Sheriff = player
                end
            end
        end
        if not Murder and not Sheriff then
            Notify("ESP Error", "Failed to fetch role data. Using fallback method.", "alert-circle", 5)
        end
    end
end

function FindGunDrop()
    local function searchForGunDrop(parent)
        for _, obj in pairs(parent:GetDescendants()) do
            if obj.Name:lower() == "gundrop" and obj:IsA("BasePart") then
                return obj
            end
        end
        return nil
    end

    local gunDrop = searchForGunDrop(Workspace)
    if gunDrop then return gunDrop end

    for _, map in pairs(Workspace:GetChildren()) do
        if map:IsA("Model") then
            gunDrop = searchForGunDrop(map)
            if gunDrop then return gunDrop end
        end
    end

    return nil
end

function RemoveEspFor(instance)
    if not instance then return end
    if instance:IsA("Player") and instance.Character then
        local highlight = instance.Character:FindFirstChild("Highlight")
        if highlight then highlight:Destroy() end
        if NameTags[instance] then
            NameTags[instance]:Destroy()
            NameTags[instance] = nil
        end
        if DistanceTags[instance] then
            DistanceTags[instance]:Destroy()
            DistanceTags[instance] = nil
        end
    elseif instance:IsA("BasePart") or instance:IsA("Model") then
        local highlight = instance:FindFirstChild("Highlight")
        if highlight then highlight:Destroy() end
        if NameTags[instance] then
            NameTags[instance]:Destroy()
            NameTags[instance] = nil
        end
        if DistanceTags[instance] then
            DistanceTags[instance]:Destroy()
            DistanceTags[instance] = nil
        end
    end
end

function UpdateEsp()
    GunDrop = FindGunDrop()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and IsAlive(player) then
            local highlight = player.Character:FindFirstChild("Highlight")
            local shouldHighlight = false
            local color = Color3.new(0, 1, 0)

            if player == Murder then
                if ESPConfig.HighlightMurderer then
                    color = Color3.fromRGB(255, 0, 0)
                    shouldHighlight = true
                    highlight = CreateHighlight(player.Character, color)
                    if highlight then highlight.FillTransparency = ESPConfig.HighlightTransparency end
                end
                if ESPConfig.NameEspMurderer then CreateNameTag(player, player.Name, Color3.fromRGB(255, 0, 0)) end
                if ESPConfig.DistanceEspMurderer then
                    CreateDistanceTag(player, Color3.fromRGB(255, 0, 0))
                    if DistanceTags[player] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        DistanceTags[player].TextLabel.Text = string.format("%.1f studs", distance)
                    end
                end
            elseif player == Sheriff or (player == Hero and (not Sheriff or not IsAlive(Sheriff))) then
                if ESPConfig.HighlightSheriff then
                    color = Color3.fromRGB(0, 0, 255)
                    shouldHighlight = true
                    highlight = CreateHighlight(player.Character, color)
                    if highlight then highlight.FillTransparency = ESPConfig.HighlightTransparency end
                end
                if ESPConfig.NameEspSheriff then CreateNameTag(player, player.Name, Color3.fromRGB(0, 0, 255)) end
                if ESPConfig.DistanceEspSheriff then
                    CreateDistanceTag(player, Color3.fromRGB(0, 0, 255))
                    if DistanceTags[player] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        DistanceTags[player].TextLabel.Text = string.format("%.1f studs", distance)
                    end
                end
            elseif player ~= Murder and player ~= Sheriff and player ~= Hero then
                if ESPConfig.HighlightInnocent then
                    color = Color3.fromRGB(0, 255, 0)
                    shouldHighlight = true
                    highlight = CreateHighlight(player.Character, color)
                    if highlight then highlight.FillTransparency = ESPConfig.HighlightTransparency end
                end
                if ESPConfig.NameEspInnocent then CreateNameTag(player, player.Name, Color3.fromRGB(0, 255, 0)) end
                if ESPConfig.DistanceEspInnocent then
                    CreateDistanceTag(player, Color3.fromRGB(0, 255, 0))
                    if DistanceTags[player] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        DistanceTags[player].TextLabel.Text = string.format("%.1f studs", distance)
                    end
                end
            end

            if highlight and not shouldHighlight then highlight:Destroy() end
            if not ESPConfig.NameEspMurderer and not ESPConfig.NameEspSheriff and not ESPConfig.NameEspInnocent and NameTags[player] then
                NameTags[player]:Destroy()
                NameTags[player] = nil
            end
            if not ESPConfig.DistanceEspMurderer and not ESPConfig.DistanceEspSheriff and not ESPConfig.DistanceEspInnocent and DistanceTags[player] then
                DistanceTags[player]:Destroy()
                DistanceTags[player] = nil
            end
        else
            RemoveEspFor(player)
        end
    end

    if GunDrop then
        if ESPConfig.HighlightGunDrop then
            local highlight = CreateHighlight(GunDrop, Color3.fromRGB(255, 255, 0))
            if highlight then highlight.FillTransparency = ESPConfig.HighlightTransparency end
        end
        if ESPConfig.NameEspGunDrop then CreateGunDropEsp(GunDrop, "Name") end
        if ESPConfig.DistanceEspGunDrop then
            CreateGunDropEsp(GunDrop, "Distance")
            if DistanceTags[GunDrop] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (GunDrop.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                DistanceTags[GunDrop].TextLabel.Text = string.format("%.1f studs", distance)
            end
        end
    else
        if NameTags[GunDrop] then
            NameTags[GunDrop]:Destroy()
            NameTags[GunDrop] = nil
        end
        if DistanceTags[GunDrop] then
            DistanceTags[GunDrop]:Destroy()
            DistanceTags[GunDrop] = nil
        end
    end
end

local lastUpdate = 0
RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    if currentTime - lastUpdate >= 0.5 then
        if ESPConfig.HighlightMurderer or ESPConfig.HighlightInnocent or ESPConfig.HighlightSheriff or
           ESPConfig.NameEspMurderer or ESPConfig.NameEspInnocent or ESPConfig.NameEspSheriff or
           ESPConfig.DistanceEspMurderer or ESPConfig.DistanceEspInnocent or ESPConfig.DistanceEspSheriff or
           ESPConfig.HighlightGunDrop or ESPConfig.NameEspGunDrop or ESPConfig.DistanceEspGunDrop then
            UpdateRoles()
            UpdateEsp()
        end
        lastUpdate = currentTime
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveEspFor(player)
    if player == LocalPlayer then
        for _, p in pairs(Players:GetPlayers()) do RemoveEspFor(p) end
        RemoveEspFor(GunDrop)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do RemoveEspFor(player) end
    RemoveEspFor(GunDrop)
end)

Tabs.EspTab:Section({Title = gradient("Murder ESP", Color3.fromHex("#e80909"), Color3.fromHex("#630404"))})
Tabs.EspTab:Toggle({Title = gradient("Highlight Murder", Color3.fromHex("#e80909"), Color3.fromHex("#630404")), Default = false, Callback = function(state) ESPConfig.HighlightMurderer = state if not state then UpdateEsp() end end})
Tabs.EspTab:Toggle({Title = gradient("Murder Name ESP", Color3.fromHex("#e80909"), Color3.fromHex("#630404")), Default = false, Callback = function(state) ESPConfig.NameEspMurderer = state if not state then UpdateEsp() end end})
Tabs.EspTab:Toggle({Title = gradient("Murder Distance ESP", Color3.fromHex("#e80909"), Color3.fromHex("#630404")), Default = false, Callback = function(state) ESPConfig.DistanceEspMurderer = state if not state then UpdateEsp() end end})

Tabs.EspTab:Section({Title = gradient("Sheriff ESP", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9"))})
Tabs.EspTab:Toggle({Title = gradient("Highlight Sheriff", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")), Default = false, Callback = function(state) ESPConfig.HighlightSheriff = state if not state then UpdateEsp() end end})
Tabs.EspTab:Toggle({Title = gradient("Sheriff Name ESP", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")), Default = false, Callback = function(state) ESPConfig.NameEspSheriff = state if not state then UpdateEsp() end end})
Tabs.EspTab:Toggle({Title = gradient("Sheriff Distance ESP", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")), Default = false, Callback = function(state) ESPConfig.DistanceEspSheriff = state if not state then UpdateEsp() end end})

Tabs.EspTab:Section({Title = gradient("Innocent ESP", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c"))})
Tabs.EspTab:Toggle({Title = gradient("Highlight Innocent", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")), Default = false, Callback = function(state) ESPConfig.HighlightInnocent = state if not state then UpdateEsp() end end})
Tabs.EspTab:Toggle({Title = gradient("Innocent Name ESP", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")), Default = false, Callback = function(state) ESPConfig.NameEspInnocent = state if not state then UpdateEsp() end end})
Tabs.EspTab:Toggle({Title = gradient("Innocent Distance ESP", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")), Default = false, Callback = function(state) ESPConfig.DistanceEspInnocent = state if not state then UpdateEsp() end end})

Tabs.EspTab:Section({Title = gradient("GunDrop ESP", Color3.fromHex("#ffff00"), Color3.fromHex("#ccaa00"))})
Tabs.EspTab:Toggle({Title = gradient("Highlight GunDrop", Color3.fromHex("#ffff00"), Color3.fromHex("#ccaa00")), Default = false, Callback = function(state) ESPConfig.HighlightGunDrop = state if not state then UpdateEsp() end end})
Tabs.EspTab:Toggle({Title = gradient("GunDrop Name ESP", Color3.fromHex("#ffff00"), Color3.fromHex("#ccaa00")), Default = false, Callback = function(state) ESPConfig.NameEspGunDrop = state if not state then UpdateEsp() end end})
Tabs.EspTab:Toggle({Title = gradient("GunDrop Distance ESP", Color3.fromHex("#ffff00"), Color3.fromHex("#ccaa00")), Default = false, Callback = function(state) ESPConfig.DistanceEspGunDrop = state if not state then UpdateEsp() end end})

Tabs.EspTab:Section({Title = gradient("ESP Settings", Color3.fromHex("#ffffff"), Color3.fromHex("#636363"))})
Tabs.EspTab:Slider({
    Title = gradient("Esp text size", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")),
    Value = {Min = 12, Max = 24, Default = 18},
    Callback = function(value)
        ESPConfig.EspTextSize = value
        for _, player in pairs(Players:GetPlayers()) do
            if NameTags[player] then NameTags[player].TextLabel.TextSize = value end
            if DistanceTags[player] then DistanceTags[player].TextLabel.TextSize = value end
        end
        if GunDrop then
            if NameTags[GunDrop] then NameTags[GunDrop].TextLabel.TextSize = value end
            if DistanceTags[GunDrop] then DistanceTags[GunDrop].TextLabel.TextSize = value end
        end
    end
})
Tabs.EspTab:Slider({
    Title = gradient("Highlight transparency", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")),
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPConfig.HighlightTransparency = value
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Highlight") then
                player.Character.Highlight.FillTransparency = value
            end
        end
        if GunDrop and GunDrop:FindFirstChild("Highlight") then
            GunDrop.Highlight.FillTransparency = value
        end
    end
})

-- Teleport Tab (unchanged for brevity)
local teleportTarget = nil
local teleportDropdown = nil

local function updateTeleportPlayers()
    local playersList = {"Select Player"}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then table.insert(playersList, player.Name) end
    end
    return playersList
end

local function initializeTeleportDropdown()
    teleportDropdown = Tabs.TeleportTab:Dropdown({
        Title = "Players",
        Values = updateTeleportPlayers(),
        Value = "Select Player",
        Callback = function(selected)
            teleportTarget = selected ~= "Select Player" and Players:FindFirstChild(selected) or nil
        end
    })
end

initializeTeleportDropdown()

Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    if teleportDropdown then teleportDropdown:Refresh(updateTeleportPlayers()) end
end)

Players.PlayerRemoving:Connect(function(player)
    if teleportDropdown then teleportDropdown:Refresh(updateTeleportPlayers()) end
end)

local function teleportToPlayer()
    if not SetDebounce("TeleportToPlayer", Config.DebounceTime) then return end
    if teleportTarget and teleportTarget.Character then
        local targetRoot = GetHumanoidRootPart(teleportTarget)
        local localRoot = GetHumanoidRootPart(LocalPlayer)
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame
            Notify("Teleport", "Successfully teleported to " .. teleportTarget.Name, "check-circle")
        else
            Notify("Teleport", "Target not found or unavailable", "x-circle")
        end
    else
        Notify("Teleport", "No target selected", "x-circle")
    end
end

Tabs.TeleportTab:Section({Title = gradient("Default TP", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))})
Tabs.TeleportTab:Button({Title = "Teleport to player", Callback = teleportToPlayer})
Tabs.TeleportTab:Button({Title = "Update players list", Callback = function() teleportDropdown:Refresh(updateTeleportPlayers()) end})

Tabs.TeleportTab:Section({Title = gradient("Special TP", Color3.fromHex("#b914fa"), Color3.fromHex("#7023c2"))})
Tabs.TeleportTab:Button({
    Title = "Teleport to Lobby",
    Callback = function()
        if not SetDebounce("TeleportToLobby", Config.DebounceTime) then return end
        local lobby = Workspace:FindFirstChild("Lobby")
        if not lobby then
            Notify("Teleport", "Lobby not found!", "x-circle")
            return
        end
        local spawnPoint = lobby:FindFirstChild("SpawnPoint") or lobby:FindFirstChildOfClass("SpawnLocation") or lobby:FindFirstChildWhichIsA("BasePart") or lobby
        local localRoot = GetHumanoidRootPart(LocalPlayer)
        if localRoot then
            localRoot.CFrame = CFrame.new(spawnPoint.Position + Vector3.new(0, 3, 0))
            Notify("Teleport", "Teleported to Lobby!", "check-circle")
        end
    end
})
Tabs.TeleportTab:Button({
    Title = "Teleport to Sheriff",
    Callback = function()
        if not SetDebounce("TeleportToSheriff", Config.DebounceTime) then return end
        UpdateRoles()
        if Sheriff and Sheriff.Character then
            local targetRoot = GetHumanoidRootPart(Sheriff)
            local localRoot = GetHumanoidRootPart(LocalPlayer)
            if targetRoot and localRoot then
                localRoot.CFrame = targetRoot.CFrame
                Notify("Teleport", "Teleported to Sheriff " .. Sheriff.Name, "check-circle")
            else
                Notify("Teleport", "Sheriff not found or unavailable", "x-circle")
            end
        else
            Notify("Teleport", "No Sheriff in the current match", "x-circle")
        end
    end
})
Tabs.TeleportTab:Button({
    Title = "Teleport to Murderer",
    Callback = function()
        if not SetDebounce("TeleportToMurderer", Config.DebounceTime) then return end
        UpdateRoles()
        if Murder and Murder.Character then
            local targetRoot = GetHumanoidRootPart(Murder)
            local localRoot = GetHumanoidRootPart(LocalPlayer)
            if targetRoot and localRoot then
                localRoot.CFrame = targetRoot.CFrame
                Notify("Teleport", "Teleported to Murderer " .. Murder.Name, "check-circle")
            else
                Notify("Teleport", "Murderer not found or unavailable", "x-circle")
            end
        else
            Notify("Teleport", "No Murderer in the current match", "x-circle")
        end
    end
})

-- Aimbot Tab (unchanged for brevity)
local isCameraLocked, isSpectating = false, false
local lockedRole = nil
local cameraConnection = nil
local originalCameraType = Enum.CameraType.Custom
local originalCameraSubject = nil

local function GetTargetPosition()
    if not lockedRole then return nil end
    local targetName = lockedRole == "Sheriff" and Sheriff or Murder
    if not targetName then return nil end
    local player = Players:FindFirstChild(targetName)
    if not player or not IsAlive(player) then return nil end
    local head = player.Character and player.Character:FindFirstChild("Head")
    return head and head.Position or nil
end

local function UpdateSpectate()
    if not isSpectating or not lockedRole then return end
    local targetPos = GetTargetPosition()
    if not targetPos then return end
    local offset = CFrame.new(0, 2, 8)
    local targetChar = Players:FindFirstChild(lockedRole == "Sheriff" and Sheriff or Murder).Character
    if targetChar then
        local root = GetHumanoidRootPart(targetChar)
        if root then CurrentCamera.CFrame = root.CFrame * offset end
    end
end

local function UpdateLockCamera()
    if not isCameraLocked or not lockedRole then return end
    local targetPos = GetTargetPosition()
    if not targetPos then return end
    local currentPos = CurrentCamera.CFrame.Position
    CurrentCamera.CFrame = CFrame.new(currentPos, targetPos)
end

local function Update()
    if isSpectating then UpdateSpectate()
    elseif isCameraLocked then UpdateLockCamera()
    end
end

coroutine.wrap(function()
    while true do
        UpdateRoles()
        task.wait(3)
    end
end)()

cameraConnection = RunService.RenderStepped:Connect(Update)

LocalPlayer.AncestryChanged:Connect(function()
    if not LocalPlayer.Parent and cameraConnection then
        cameraConnection:Disconnect()
        CurrentCamera.CameraType = originalCameraType
        CurrentCamera.CameraSubject = originalCameraSubject
    end
end)

Tabs.AimbotTab:Section({Title = gradient("Default AimBot", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))})
local RoleDropdown = Tabs.AimbotTab:Dropdown({
    Title = "Target Role",
    Values = {"None", "Sheriff", "Murderer"},
    Value = "None",
    Callback = function(selected)
        lockedRole = selected ~= "None" and selected or nil
    end
})
Tabs.AimbotTab:Toggle({
    Title = "Spectate Mode",
    Default = false,
    Callback = function(state)
        isSpectating = state
        if state then
            originalCameraType = CurrentCamera.CameraType
            originalCameraSubject = CurrentCamera.CameraSubject
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
        else
            CurrentCamera.CameraType = originalCameraType
            CurrentCamera.CameraSubject = originalCameraSubject
        end
    end
})
Tabs.AimbotTab:Toggle({
    Title = "Lock Camera",
    Default = false,
    Callback = function(state)
        isCameraLocked = state
        if not state and not isSpectating then
            CurrentCamera.CameraType = originalCameraType
            CurrentCamera.CameraSubject = originalCameraSubject
        end
    end
})

Tabs.AimbotTab:Section({Title = gradient("Silent Aimbot (On rework)", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))})

-- AutoFarm Tab (unchanged for brevity)
local AutoFarm = {
    Enabled = false,
    Mode = "Teleport",
    TeleportDelay = 0,
    MoveSpeed = 50,
    WalkSpeed = 32,
    Connection = nil,
    CoinCheckInterval = 0.5,
    CoinContainers = {"Factory", "Hospital3", "MilBase", "House2", "Workplace", "Mansion2", "BioLab", "Hotel", "Bank2", "PoliceStation", "ResearchFacility", "Lobby"}
}

local function findNearestCoin()
    local closestCoin, shortestDistance = nil, math.huge
    local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
    if not humanoidRootPart then return nil end

    for _, containerName in ipairs(AutoFarm.CoinContainers) do
        local container = Workspace:FindFirstChild(containerName)
        if container then
            local coinContainer = containerName == "Lobby" and container or container:FindFirstChild("CoinContainer")
            if coinContainer then
                for _, coin in ipairs(coinContainer:GetChildren()) do
                    if coin:IsA("BasePart") then
                        local distance = (humanoidRootPart.Position - coin.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestCoin = coin
                        end
                    end
                end
            end
        end
    end
    return closestCoin
end

local function teleportToCoin(coin)
    if not coin or not LocalPlayer.Character then return end
    local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(coin.Position + Vector3.new(0, 3, 0))
        task.wait(AutoFarm.TeleportDelay)
    end
end

local function smoothMoveToCoin(coin)
    if not coin or not LocalPlayer.Character then return end
    local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
    if not humanoidRootPart then return end

    local startTime = tick()
    local startPos = humanoidRootPart.Position
    local endPos = coin.Position + Vector3.new(0, 3, 0)
    local distance = (startPos - endPos).Magnitude
    local duration = distance / AutoFarm.MoveSpeed

    while tick() - startTime < duration and AutoFarm.Enabled do
        if not coin or not coin.Parent then break end
        local progress = math.min((tick() - startTime) / duration, 1)
        humanoidRootPart.CFrame = CFrame.new(startPos:Lerp(endPos, progress))
        task.wait()
    end
end

local function walkToCoin(coin)
    if not coin or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid.WalkSpeed = AutoFarm.WalkSpeed
    humanoid:MoveTo(coin.Position + Vector3.new(0, 0, 3))

    local startTime = tick()
    while AutoFarm.Enabled and humanoid.MoveDirection.Magnitude > 0 and tick() - startTime < 10 do
        task.wait(0.5)
    end
end

local function collectCoin(coin)
    if not coin or not LocalPlayer.Character then return end
    local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
    if humanoidRootPart then
        firetouchinterest(humanoidRootPart, coin, 0)
        firetouchinterest(humanoidRootPart, coin, 1)
    end
end

local function farmLoop()
    while AutoFarm.Enabled do
        local coin = findNearestCoin()
        if coin then
            if AutoFarm.Mode == "Teleport" then teleportToCoin(coin)
            elseif AutoFarm.Mode == "Smooth" then smoothMoveToCoin(coin)
            else walkToCoin(coin)
            end
            collectCoin(coin)
        else
            Notify("AutoFarm", "No coins found nearby!", "alert-circle", 2)
            task.wait(2)
        end
        task.wait(AutoFarm.CoinCheckInterval)
    end
end

Tabs.AutoFarm:Section({Title = gradient("Coin Farming", Color3.fromHex("#FFD700"), Color3.fromHex("#FFA500"))})
Tabs.AutoFarm:Dropdown({
    Title = "Movement Mode",
    Values = {"Teleport", "Smooth", "Walk"},
    Value = "Teleport",
    Callback = function(mode)
        AutoFarm.Mode = mode
        Notify("AutoFarm", "Mode set to: " .. mode, "check-circle", 2)
    end
})
Tabs.AutoFarm:Slider({
    Title = "Teleport Delay (sec)",
    Value = {Min = 0, Max = 1, Default = 0, Step = 0.1},
    Callback = function(value) AutoFarm.TeleportDelay = value end
})
Tabs.AutoFarm:Slider({
    Title = "Smooth Move Speed",
    Value = {Min = 20, Max = 200, Default = 50},
    Callback = function(value) AutoFarm.MoveSpeed = value end
})
Tabs.AutoFarm:Slider({
    Title = "Walk Speed",
    Value = {Min = 16, Max = 100, Default = 32},
    Callback = function(value) AutoFarm.WalkSpeed = value end
})
Tabs.AutoFarm:Slider({
    Title = "Check Interval (sec)",
    Step = 0.1,
    Value = {Min = 0.1, Max = 2, Default = 0.5},
    Callback = function(value) AutoFarm.CoinCheckInterval = value end
})
Tabs.AutoFarm:Toggle({
    Title = "Enable AutoFarm",
    Default = false,
    Callback = function(state)
        AutoFarm.Enabled = state
        if state then
            AutoFarm.Connection = task.spawn(farmLoop)
            Notify("AutoFarm", "Started farming nearest coins!", "check-circle", 2)
        else
            if AutoFarm.Connection then task.cancel(AutoFarm.Connection) end
            Notify("AutoFarm", "Stopped farming coins", "x-circle", 2)
        end
    end
})

-- Innocent Tab (Enhanced)
local GunSystem = {
    AutoGrabEnabled = false,
    AutoShootEnabled = false,
    NotifyGunDrop = true,
    GunDropCheckInterval = 1,
    ActiveGunDrops = {},
    GunDropHighlights = {},
    GrabMode = "Teleport to Gun",
    TeleportOffset = Config.TeleportOffset,
}

local mapPaths = {"ResearchFacility", "Hospital3", "MilBase", "House2", "Workplace", "Mansion2", "BioLab", "Hotel", "Factory", "Bank2", "PoliceStation"}
local notifiedGunDrops = {}

local function ScanForGunDrops()
    GunSystem.ActiveGunDrops = {}
    for _, mapName in ipairs(mapPaths) do
        local map = Workspace:FindFirstChild(mapName)
        if map then
            local gunDrop = map:FindFirstChild("GunDrop")
            if gunDrop then table.insert(GunSystem.ActiveGunDrops, gunDrop) end
        end
    end
    local rootGunDrop = Workspace:FindFirstChild("GunDrop")
    if rootGunDrop then table.insert(GunSystem.ActiveGunDrops, rootGunDrop) end
end

local function EquipGun()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then return true end
    local gun = LocalPlayer.Backpack:FindFirstChild("Gun")
    if gun then
        gun.Parent = LocalPlayer.Character
        task.wait(0.1)
        return LocalPlayer.Character:FindFirstChild("Gun") ~= nil
    end
    return false
end

local function GrabGun(gunDrop)
    if not SetDebounce("GrabGun", Config.DebounceTime) then return false end
    if not gunDrop then
        ScanForGunDrops()
        if #GunSystem.ActiveGunDrops == 0 then
            Notify("Gun System", "No guns available on the map", "x-circle")
            return false
        end
        local nearestGun, minDistance = nil, math.huge
        local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
        if humanoidRootPart then
            for _, drop in ipairs(GunSystem.ActiveGunDrops) do
                local distance = (humanoidRootPart.Position - drop.Position).Magnitude
                if distance < minDistance then
                    nearestGun = drop
                    minDistance = distance
                end
            end
        end
        gunDrop = nearestGun
    end

    if gunDrop and LocalPlayer.Character then
        local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
        if not humanoidRootPart then
            Notify("Gun System", "Player character not found", "x-circle")
            return false
        end

        if GunSystem.GrabMode == "Teleport to Gun" then
            humanoidRootPart.CFrame = CFrame.new(gunDrop.Position + Vector3.new(0, GunSystem.TeleportOffset, 0))
            task.wait(0.3)
        elseif GunSystem.GrabMode == "Gun to Player" then
            gunDrop.CFrame = CFrame.new(humanoidRootPart.Position + Vector3.new(0, GunSystem.TeleportOffset, 0))
            task.wait(0.3)
        end

        local prompt = gunDrop:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            for _ = 1, 3 do
                fireproximityprompt(prompt)
                task.wait(0.1)
            end
            Notify("Gun System", "Successfully grabbed the gun!", "check-circle")
            return true
        else
            Notify("Gun System", "Proximity prompt not found", "x-circle")
            return false
        end
    end
    Notify("Gun System", "Gun not found or player unavailable", "x-circle")
    return false
end

local function AutoGrabGun()
    while GunSystem.AutoGrabEnabled do
        ScanForGunDrops()
        if #GunSystem.ActiveGunDrops > 0 and LocalPlayer.Character then
            local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
            if humanoidRootPart then
                local nearestGun, minDistance = nil, math.huge
                for _, gunDrop in ipairs(GunSystem.ActiveGunDrops) do
                    local distance = (humanoidRootPart.Position - gunDrop.Position).Magnitude
                    if distance < minDistance then
                        nearestGun = gunDrop
                        minDistance = distance
                    end
                end
                if nearestGun then
                    if GunSystem.GrabMode == "Teleport to Gun" then
                        humanoidRootPart.CFrame = CFrame.new(nearestGun.Position + Vector3.new(0, GunSystem.TeleportOffset, 0))
                    elseif GunSystem.GrabMode == "Gun to Player" then
                        nearestGun.CFrame = CFrame.new(humanoidRootPart.Position + Vector3.new(0, GunSystem.TeleportOffset, 0))
                    end
                    task.wait(0.3)
                    local prompt = nearestGun:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                        task.wait(1)
                        if GunSystem.AutoShootEnabled and EquipGun() then
                            GrabAndShootMurderer()
                        end
                    end
                end
            end
        end
        task.wait(GunSystem.GunDropCheckInterval)
    end
end

local function GetMurderer()
    local success, roles = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    if success and roles then
        for playerName, data in pairs(roles) do
            if data.Role == "Murderer" then
                return Players:FindFirstChild(playerName)
            end
        end
    end
    Notify("Gun System", "Failed to fetch murderer data", "x-circle")
    return nil
end

local function GrabAndShootMurderer()
    GrabGun(gunDrop)
    EquipGun()
    ShootMurderer()
end

local function checkForGunDrops()
    for _, mapName in ipairs(mapPaths) do
        local map = Workspace:FindFirstChild(mapName)
        if map then
            local gunDrop = map:FindFirstChild("GunDrop")
            if gunDrop and not notifiedGunDrops[gunDrop] and GunSystem.NotifyGunDrop then
                Notify("Gun Drop", "A gun has appeared on the map: " .. mapName, "alert-circle", 5)
                notifiedGunDrops[gunDrop] = true
            end
        end
    end
end

local function setupGunDropMonitoring()
    for _, mapName in ipairs(mapPaths) do
        local map = Workspace:FindFirstChild(mapName)
        if map then
            if map:FindFirstChild("GunDrop") then checkForGunDrops() end
            map.ChildAdded:Connect(function(child)
                if child.Name == "GunDrop" then
                    task.wait(0.5)
                    checkForGunDrops()
                end
            end)
            map.ChildRemoved:Connect(function(child)
                if child.Name == "GunDrop" and notifiedGunDrops[child] then
                    notifiedGunDrops[child] = nil
                end
            end)
        end
    end
end

Workspace.ChildAdded:Connect(function(child)
    if table.find(mapPaths, child.Name) then
        task.wait(2)
        checkForGunDrops()
    end
end)

setupGunDropMonitoring()

Tabs.InnocentTab:Section({Title = gradient("Gun Functions", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c"))})

Tabs.InnocentTab:Toggle({
    Title = "Notify GunDrop",
    Default = true,
    Callback = function(state)
        GunSystem.NotifyGunDrop = state
        if state then
            task.spawn(function()
                task.wait(1)
                checkForGunDrops()
            end)
        end
    end
})
Tabs.InnocentTab:Dropdown({
    Title = "Grab Gun Mode",
    Values = {"Teleport to Gun", "Gun to Player"},
    Value = "Teleport to Gun",
    Callback = function(mode)
        GunSystem.GrabMode = mode
        Notify("Gun System", "Grab mode set to: " .. mode, "check-circle")
    end
})
Tabs.InnocentTab:Slider({
    Title = "Teleport Offset",
    Value = {Min = 1, Max = 10, Default = Config.TeleportOffset},
    Callback = function(value)
        GunSystem.TeleportOffset = value
        Notify("Gun System", "Teleport offset set to: " .. value, "check-circle")
    end
})
Tabs.InnocentTab:Button({
    Title = "Grab Gun",
    Callback = function() GrabGun() end
})
Tabs.InnocentTab:Toggle({
    Title = "Auto Grab Gun",
    Default = false,
    Callback = function(state)
        GunSystem.AutoGrabEnabled = state
        if state then
            coroutine.wrap(AutoGrabGun)()
            Notify("Gun System", "Auto Grab Gun enabled!", "check-circle")
        else
            Notify("Gun System", "Auto Grab Gun disabled", "x-circle")
        end
    end
})

Tabs.InnocentTab:Button({
    Title = "Grab Gun & Shoot Murderer",
    Callback = function() GrabAndShootMurderer() end
})

-- Murder Tab (unchanged for brevity)
local killActive = false
local attackDelay = 0.5
local targetRoles = {"Sheriff", "Hero", "Innocent"}

local function getPlayerRole(player)
    local success, roles = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    if success and roles and roles[player.Name] then
        return roles[player.Name].Role
    end
    return nil
end

local function equipKnife()
    local character = LocalPlayer.Character
    if not character then return false end
    if character:FindFirstChild("Knife") then return true end
    local knife = LocalPlayer.Backpack:FindFirstChild("Knife")
    if knife then
        knife.Parent = character
        return true
    end
    return false
end

local function getNearestTarget()
    local targets = {}
    local localRoot = GetHumanoidRootPart(LocalPlayer)
    if not localRoot then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local role = getPlayerRole(player)
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local targetRoot = GetHumanoidRootPart(player)
            if role and humanoid and humanoid.Health > 0 and targetRoot and table.find(targetRoles, role) then
                table.insert(targets, {
                    Player = player,
                    Distance = (localRoot.Position - targetRoot.Position).Magnitude
                })
            end
        end
    end
    table.sort(targets, function(a, b) return a.Distance < b.Distance end)
    return targets[1] and targets[1].Player or nil
end

local function attackTarget(target)
    if not target or not target.Character then return false end
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if not equipKnife() then
        Notify("Kill Targets", "No knife found!", "x-circle", 2)
        return false
    end
    local targetRoot = GetHumanoidRootPart(target)
    local localRoot = GetHumanoidRootPart(LocalPlayer)
    if targetRoot and localRoot then
        localRoot.CFrame = CFrame.new(targetRoot.Position + (localRoot.Position - targetRoot.Position).Unit * 2, targetRoot.Position)
    end
    local knife = LocalPlayer.Character:FindFirstChild("Knife")
    if knife and knife:FindFirstChild("Stab") then
        for _ = 1, 3 do knife.Stab:FireServer("Down") end
        return true
    end
    return false
end

local function killTargets()
    if killActive then return end
    killActive = true
    Notify("Kill Targets", "Starting attack on nearest targets...", "alert-circle", 2)
    task.spawn(function()
        while killActive do
            local target = getNearestTarget()
            if not target then
                Notify("Kill Targets", "No valid targets found!", "check-circle", 3)
                killActive = false
                break
            end
            if attackTarget(target) then
                Notify("Kill Targets", "Attacked " .. target.Name, "check-circle", 1)
            end
            task.wait(attackDelay)
        end
    end)
end

local function stopKilling()
    killActive = false
    Notify("Kill Targets", "Attack sequence stopped", "x-circle", 2)
end

Tabs.MurderTab:Section({Title = gradient("Kill Functions", Color3.fromHex("#e80909"), Color3.fromHex("#630404"))})

Tabs.MurderTab:Toggle({
    Title = "Kill All",
    Default = false,
    Callback = function(state)
        if state then killTargets() else stopKilling() end
    end
})
Tabs.MurderTab:Slider({
    Title = "Attack Delay",
    Step = 0.1,
    Value = {Min = 0.1, Max = 2, Default = 0.5},
    Callback = function(value)
        attackDelay = value
        Notify("Kill Targets", "Delay set to " .. value .. "s", "check-circle", 2)
    end
})
Tabs.MurderTab:Button({
    Title = "Equip Knife",
    Callback = function()
        if equipKnife() then
            Notify("Knife", "Knife equipped!", "check-circle", 2)
        else
            Notify("Knife", "No knife found!", "x-circle", 2)
        end
    end
})

-- Sheriff Tab (Streamlined for speed and efficiency)

local shotButton = nil
local shotButtonFrame = nil
local shotButtonActive = false
local shotType = "Default"
local buttonSize = 65

local function CreateShotButton()
    if shotButton then return end

    local screenGui = CoreGui:FindFirstChild("WindUI_SheriffGui") or Instance.new("ScreenGui")
    screenGui.Name = "WindUI_SheriffGui"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = CoreGui

    shotButtonFrame = Instance.new("Frame")
    shotButtonFrame.Name = "ShotButtonFrame"
    shotButtonFrame.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    shotButtonFrame.Position = UDim2.new(1, -buttonSize - 20, 0.5, -buttonSize/2)
    shotButtonFrame.BackgroundTransparency = 1
    shotButtonFrame.ZIndex = 100
    shotButtonFrame.Parent = screenGui

    shotButton = Instance.new("TextButton")
    shotButton.Name = "SheriffShotButton"
    shotButton.Size = UDim2.new(1, 0, 1, 0)
    shotButton.BackgroundColor3 = Color3.fromRGB(0, 105, 255)
    shotButton.BackgroundTransparency = 0.8
    shotButton.Text = "SHOT"
    shotButton.TextColor3 = Color3.new(1, 1, 1)
    shotButton.TextSize = 14
    shotButton.Font = Enum.Font.SourceSansBold
    shotButton.BorderSizePixel = 0
    shotButton.ZIndex = 101
    shotButton.AutoButtonColor = false
    shotButton.TextScaled = true
    shotButton.Parent = shotButtonFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = shotButton

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = shotButton

local function animatePress()
        local tweenService = game:GetService("TweenService")
        local pressTween = tweenService:Create(
            shotButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            { Size = UDim2.new(0.9, 0, 0.9, 0), BackgroundTransparency = 0.7 }
        )
        local strokeTween = tweenService:Create(
            stroke,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            { Thickness = 1.8 }
        )
        local releaseTween = tweenService:Create(
            shotButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0.8 }
        )
        local strokeReleaseTween = tweenService:Create(
            stroke,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            { Thickness = 2 }
        )
        pressTween:Play()
        strokeTween:Play()
        pressTween.Completed:Wait()
        releaseTween:Play()
        strokeReleaseTween:Play()
    end

    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    shotButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = shotButtonFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    shotButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local guiSize = screenGui.AbsoluteSize
            shotButtonFrame.Position = UDim2.new(
                0, math.clamp(startPos.X.Offset + delta.X, 0, guiSize.X - buttonSize),
                0, math.clamp(startPos.Y.Offset + delta.Y, 0, guiSize.Y - buttonSize)
            )
        end
    end)

    shotButton.Activated:Connect(function()
        animatePress()
local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    local murderer
    for name, data in pairs(roles) do
        if data.Role == "Murderer" then
            murderer = Players:FindFirstChild(name)
            break
        end
    end
        local targetPos = murderer.Character.HumanoidRootPart.Position
        local localCharacter = LocalPlayer.Character
        if shotType == "Teleport" and localCharacter then
            localCharacter.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, -4))
        end
        EquipGun()
        local gun = localCharacter and localCharacter:FindFirstChild("Gun")
            local args = {1, targetPos, "AH2"}
            gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
    end)
shotButtonActive = true
end

local function RemoveShotButton()
    if shotButton then
        shotButton:Destroy()
        shotButton = nil
    end
    if shotButtonFrame then
        shotButtonFrame:Destroy()
        shotButtonFrame = nil
    end
    local screenGui = CoreGui:FindFirstChild("WindUI_SheriffGui")
    if screenGui then
        screenGui:Destroy()
    end
    shotButtonActive = false
end

local function EquipGun()
    local character = LocalPlayer.Character
    if character and not character:FindFirstChild("Gun") then
        local gun = LocalPlayer.Backpack:FindFirstChild("Gun")
        if gun then
            gun.Parent = character
        end
    end
end

local function IsMurdererVisible(murderer)
    if not murderer or not murderer.Character or not LocalPlayer.Character then return false end
    local localHead = LocalPlayer.Character:FindFirstChild("Head")
    local murdererHead = murderer.Character:FindFirstChild("Head")
    if not localHead or not murdererHead then return false end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, murderer.Character}
    rayParams.IgnoreWater = true

    local rayResult = Workspace:Raycast(localHead.Position, (murdererHead.Position - localHead.Position).Unit * 1000, rayParams)
    return not rayResult or rayResult.Instance:IsDescendantOf(murderer.Character)
end

local function AutoShootLoop()
    while autoShootEnabled do
        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        local murderer
        for name, data in pairs(roles) do
            if data.Role == "Murderer" then
                murderer = Players:FindFirstChild(name)
                break
            end
        end
        if IsMurdererVisible(murderer) then
            ShootMurderer()
        end
        task.wait(0.1)
    end
end

local function ShootMurderer()
    local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    local murderer
    for name, data in pairs(roles) do
        if data.Role == "Murderer" then
            murderer = Players:FindFirstChild(name)
            break
        end
    end
        local targetPos = murderer.Character.HumanoidRootPart.Position
        local localCharacter = LocalPlayer.Character
        if shotType == "Teleport" and localCharacter then
            localCharacter.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 0, -4))
        end
        EquipGun()
        local gun = localCharacter and localCharacter:FindFirstChild("Gun")
            local args = {1, targetPos, "AH2"}
            gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
        end

Tabs.SheriffTab:Section({Title = gradient("Shot Functions", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9"))})

Tabs.SheriffTab:Dropdown({
    Title = "Shot Type",
    Values = {"Default", "Teleport"},
    Value = "Default",
    Callback = function(selectedType)
        shotType = selectedType
    end
})

Tabs.SheriffTab:Button({
    Title = "Shoot Murderer",
    Callback = function()
        ShootMurderer()
    end
})

Tabs.SheriffTab:Toggle({
    Title = "Auto Shoot Murderer",
    Default = false,
    Callback = function(state)
        autoShootEnabled = state
        if state then
            autoShootConnection = task.spawn(AutoShootLoop)
            Notify("Sheriff System", "Auto Shoot Murderer enabled!", "check-circle")
        else
            if autoShootConnection then task.cancel(autoShootConnection) end
            autoShootConnection = nil
            Notify("Sheriff System", "Auto Shoot Murderer disabled", "x-circle")
        end
    end
})

Tabs.SheriffTab:Section({Title = gradient("Shot Button", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9"))})
Tabs.SheriffTab:Slider({
    Title = "Button Size",
    Value = {Min = 40, Max = 100, Default = 65},
    Callback = function(value)
        buttonSize = value
        if shotButtonFrame then
            shotButtonFrame.Size = UDim2.new(0, buttonSize, 0, buttonSize)
            shotButtonFrame.Position = UDim2.new(1, -buttonSize - 20, 0.5, -buttonSize/2)
        end
    end
})
Tabs.SheriffTab:Toggle({
    Title = "Enable Shot Button",
    Default = false,
    Callback = function(state)
        if state then
            CreateShotButton()
        else
            RemoveShotButton()
        end
    end
})
-- Settings Tab (unchanged for brevity)
local Settings = {
    Hitbox = {Enabled = false, Size = 5, Color = Color3.new(1,0,0), Adornments = {}, Connections = {}},
    Noclip = {Enabled = false, Connection = nil},
    AntiAFK = {Enabled = false, Connection = nil}
}

local function ToggleNoclip(state)
    if state then
        Settings.Noclip.Connection = RunService.Stepped:Connect(function()
            local chr = LocalPlayer.Character
            if chr then
                for _, part in pairs(chr:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if Settings.Noclip.Connection then Settings.Noclip.Connection:Disconnect() end
    end
end

local function UpdateHitboxes()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local chr = plr.Character
            local box = Settings.Hitbox.Adornments[plr]
            if chr and Settings.Hitbox.Enabled then
                local root = GetHumanoidRootPart(plr)
                if root then
                    if not box then
                        box = Instance.new("BoxHandleAdornment")
                        box.Adornee = root
                        box.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                        box.Color3 = Settings.Hitbox.Color
                        box.Transparency = 0.4
                        box.ZIndex = 10
                        box.Parent = root
                        Settings.Hitbox.Adornments[plr] = box
                    else
                        box.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                        box.Color3 = Settings.Hitbox.Color
                    end
                end
            elseif box then
                box:Destroy()
                Settings.Hitbox.Adornments[plr] = nil
            end
        end
    end
end

local function ToggleAntiAFK(state)
    if state then
        Settings.AntiAFK.Connection = RunService.Heartbeat:Connect(function()
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end)
        Notify("Settings", "Anti-AFK enabled", "check-circle")
    else
        if Settings.AntiAFK.Connection then
            Settings.AntiAFK.Connection:Disconnect()
            Settings.AntiAFK.Connection = nil
        end
        Notify("Settings", "Anti-AFK disabled", "x-circle")
    end
end

Tabs.SettingsTab:Section({
    Title = gradient("Hitboxes", Color3.fromHex("#ff0000"), Color3.fromHex("#ff8800"))
})

Tabs.SettingsTab:Toggle({
    Title = "Hitboxes",
    Callback = function(state)
        Settings.Hitbox.Enabled = state
        if state then
            RunService.Heartbeat:Connect(UpdateHitboxes)
        else
            for _, box in pairs(Settings.Hitbox.Adornments) do
                if box then box:Destroy() end
            end
            Settings.Hitbox.Adornments = {}
        end
    end
})

Tabs.SettingsTab:Slider({
    Title = "Hitbox size",
    Value = {Min=1, Max=10, Default=5},
    Callback = function(val)
        Settings.Hitbox.Size = val
        UpdateHitboxes()
    end
})

Tabs.SettingsTab:Colorpicker({
    Title = "Hitbox color",
    Default = Color3.new(1,0,0),
    Callback = function(col)
        Settings.Hitbox.Color = col
        UpdateHitboxes()
    end
})

Tabs.SettingsTab:Section({
    Title = gradient("Character Functions", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e"))
})


Tabs.SettingsTab:Toggle({
    Title = "Anti-AFK",
    Callback = function(state)
        Settings.AntiAFK.Enabled = state
        ToggleAntiAFK(state)
    end
})

Tabs.SettingsTab:Toggle({
    Title = "NoClip",
    Callback = function(state)
        Settings.Noclip.Enabled = state
        ToggleNoclip(state)
    end
})

-- Auto Exec

Tabs.SettingsTab:Section({
    Title = gradient("Auto Execute", Color3.fromHex("#00ff40"), Color3.fromHex("#88f2a2"))
})

local AutoInject = {
    Enabled = false,
    ScriptURL = "https://raw.githubusercontent.com/Snowt-Team/SNT-HUB/refs/heads/main/MM2.txt"
}

Tabs.SettingsTab:Toggle({
    Title = "Auto Inject on Rejoin/Hop",
    Default = false,
    Callback = function(state)
        AutoInject.Enabled = state
        if state then
            SetupAutoInject()
            WindUI:Notify({
                Title = "Auto Inject",
                Content = "Автоинжект включен! Скрипт перезапустится автоматически.",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Auto Inject",
                Content = "Автоинжект отключен",
                Duration = 3
            })
        end
    end
})

local function SetupAutoInject()
    if not AutoInject.Enabled then return end
    
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    spawn(function()
        wait(2)
        if AutoInject.Enabled then
            pcall(function()
                loadstring(game:HttpGet(AutoInject.ScriptURL))()
            end)
        end
    end)

    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Started and AutoInject.Enabled then
            queue_on_teleport([[
                wait(2)
                loadstring(game:HttpGet("]]..AutoInject.ScriptURL..[["))()
            ]])
        end
    end)

    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if player == LocalPlayer and AutoInject.Enabled then
            queue_on_teleport([[
                wait(2)
                loadstring(game:HttpGet("]]..AutoInject.ScriptURL..[["))()
            ]])
        end
    end)
end

Tabs.SettingsTab:Button({
    Title = "Manual Re-Inject",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet(AutoInject.ScriptURL))()
            WindUI:Notify({
                Title = "Manual Inject",
                Content = "Скрипт успешно перезагружен!",
                Duration = 3
            })
        end)
    end
})
-- Socials
Tabs.SocialsTab:Paragraph({
    Title = gradient("SnowT", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Desc = "My socials",
    Image = "bird",
    Color = "Green",
    Buttons = {
        { Icon = "circle",
          Title = "TG Channel",
          Callback = function()
              -- Попробуйте setclipboard (с маленькой буквы)
              if pcall(setclipboard, "t.me/supreme_scripts") then
                  print("Success!")
              else
                  print("Failed!")
              end
          end,
        }
    }
})

Tabs.SocialsTab:Paragraph({
    Title = gradient("Mirrozz", Color3.fromHex("#ffffff"), Color3.fromHex("#363636")),
    Desc = "Socials My Friend",
    Image = "bird",
    Color = "Green",
    Buttons = {
        {
            Title = "TG Channel",
            Icon = "circle",
            Callback = function()
                -- Попробуйте setclipboard (с маленькой буквы)
                if pcall(setclipboard, "t.me/mirrozzscript") then
                    print("Success!")
                else
                    print("Failed!")
                end
            end,
        }
    }
})


-- Changelogs
Tabs.ChangelogsTab:Code({
    Title = "Changelogs:",
    Code = [[
    • More stability
    • Fix bugs
    • Rework all functions
    • Fixed shoot button
    • New functions
    • Rework ESP
]]
})

Tabs.ChangelogsTab:Code({
    Title = "Next update:",
    Code = [[ The next update is [v1.1]
    In future we will be add:
    • Full rework
    • Better autofarm
]]
})

-- Server
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

Tabs.ServerTab:Button({
    Title = "Rejoin",
    Callback = function()
        local success, error = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
        end)
        if not success then
            warn("Rejoin error:", error)
        end
    end
})

Tabs.ServerTab:Section({
    Title = ""
})

Tabs.ServerTab:Button({
    Title = "Server Hop",
    Callback = function()
        local placeId = game.PlaceId
        local currentJobId = game.JobId
        
        local function serverHop()
            local servers = {}
            local success, result = pcall(function()
                return HttpService:JSONDecode(HttpService:GetAsync("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"))
            end)
            
            if success and result and result.data then
                for _, server in ipairs(result.data) do
                    if server.id ~= currentJobId then
                        table.insert(servers, server)
                    end
                end
                
                if #servers > 0 then
                    TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(#servers)].id)
                else
                    TeleportService:Teleport(placeId)
                end
            else
                TeleportService:Teleport(placeId)
            end
        end
        
        pcall(serverHop)
    end
})

Tabs.ServerTab:Button({
    Title = "Join to Lower Server",
    Callback = function()
        local placeId = game.PlaceId
        local currentJobId = game.JobId
        
        local function joinLowerServer()
            local servers = {}
            local success, result = pcall(function()
                return HttpService:JSONDecode(HttpService:GetAsync("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"))
            end)
            
            if success and result and result.data then
                for _, server in ipairs(result.data) do
                    if server.id ~= currentJobId and server.playing < (server.maxPlayers or 30) then
                        table.insert(servers, server)
                    end
                end
                
                table.sort(servers, function(a, b)
                    return a.playing < b.playing
                end)
                
                if #servers > 0 then
                    TeleportService:TeleportToPlaceInstance(placeId, servers[1].id)
                else
                    TeleportService:Teleport(placeId)
                end
            else
                TeleportService:Teleport(placeId)
            end
        end
        
        pcall(joinLowerServer)
    end
})

-- Configuration
local HttpService = game:GetService("HttpService")

local folderPath = "WindUI"
makefolder(folderPath)

local function SaveFile(fileName, data)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    local jsonData = HttpService:JSONEncode(data)
    writefile(filePath, jsonData)
end

local function LoadFile(fileName)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    if isfile(filePath) then
        local jsonData = readfile(filePath)
        return HttpService:JSONDecode(jsonData)
    end
end

local function ListFiles()
    local files = {}
    for _, file in ipairs(listfiles(folderPath)) do
        local fileName = file:match("([^/]+)%.json$")
        if fileName then
            table.insert(files, fileName)
        end
    end
    return files
end

Tabs.WindowTab:Section({ Title = "Window" })
local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

local themeDropdown = Tabs.WindowTab:Dropdown({
    Title = "Select Theme",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})

themeDropdown:Select(WindUI:GetCurrentTheme())

local ToggleTransparency = Tabs.WindowTab:Toggle({
    Title = "Toggle Window Transparency",
    Callback = function(e)
        Window:ToggleTransparency(e)
    end,
    Value = WindUI:GetTransparency()
})

Tabs.WindowTab:Section({ Title = "Save" })

local fileNameInput = ""
Tabs.WindowTab:Input({
    Title = "Write File Name",
    PlaceholderText = "Enter file name",
    Callback = function(text)
        fileNameInput = text
    end
})

Tabs.WindowTab:Button({
    Title = "Save File",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
        end
    end
})

Tabs.WindowTab:Section({ Title = "Load" })

local filesDropdown
local files = ListFiles()

filesDropdown = Tabs.WindowTab:Dropdown({
    Title = "Select File",
    Multi = false,
    AllowNone = true,
    Values = files,
    Callback = function(selectedFile)
        fileNameInput = selectedFile
    end
})

Tabs.WindowTab:Button({
    Title = "Load File",
    Callback = function()
        if fileNameInput ~= "" then
            local data = LoadFile(fileNameInput)
            if data then
                WindUI:Notify({
                    Title = "File Loaded",
                    Content = "Loaded data: " .. HttpService:JSONEncode(data),
                Duration = 5,
                })
                if data.Transparent then 
                    Window:ToggleTransparency(data.Transparent)
                    ToggleTransparency:SetValue(data.Transparent)
                end
                if data.Theme then WindUI:SetTheme(data.Theme) end
            end
        end
    end
})

Tabs.WindowTab:Button({
    Title = "Overwrite File",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
        end
    end
})

Tabs.WindowTab:Button({
    Title = "Refresh List",
    Callback = function()
        filesDropdown:Refresh(ListFiles())
    end
})

-- Themes
local currentThemeName = WindUI:GetCurrentTheme()
local themes = WindUI:GetThemes()

local ThemeAccent = themes[currentThemeName].Accent
local ThemeOutline = themes[currentThemeName].Outline
local ThemeText = themes[currentThemeName].Text
local ThemePlaceholderText = themes[currentThemeName].PlaceholderText

function updateTheme()
    WindUI:AddTheme({
        Name = currentThemeName,
        Accent = ThemeAccent,
        Outline = ThemeOutline,
        Text = ThemeText,
        PlaceholderText = ThemePlaceholderText
    })
    WindUI:SetTheme(currentThemeName)
end

Tabs.CreateThemeTab:Colorpicker({
    Title = "Background Color",
    Default = Color3.fromHex(ThemeAccent),
    Callback = function(color)
        ThemeAccent = color
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "Outline Color",
    Default = Color3.fromHex(ThemeOutline),
    Callback = function(color)
        ThemeOutline = color
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "Text Color",
    Default = Color3.fromHex(ThemeText),
    Callback = function(color)
        ThemeText = color
    end
})

Tabs.CreateThemeTab:Button({
    Title = "Update Theme",
    Callback = function()
        WindUI:AddTheme({
            Name = currentThemeName,
            Accent = ThemeAccent,
            Outline = ThemeOutline,
            Text = ThemeText,
            PlaceholderText = ThemePlaceholderText
        })
        WindUI:SetTheme(currentThemeName)
        WindUI:Notify({
            Title = "Тема обновлена",
            Content = "Новая тема '"..currentThemeName.."' применена!",
            Duration = 3,
            Icon = "check-circle"
        })
    end
})