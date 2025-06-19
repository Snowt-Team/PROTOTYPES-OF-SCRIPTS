-- WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Global Configuration
local Config = {
    DebounceTime = 0.1, -- Time between actions to prevent spam
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
    Background = "", -- rbxassetid only
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
    
})

-- Open Button
Window:EditOpenButton({
    Title = "Open UI",
    Icon = "monitor",
    CornerRadius = UDim.new(2, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("1E213D"), Color3.fromHex("1F75FE")),
    OnlyMobile = false,
    Enabled = true,
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

-- Main Tab (Updated to Remove Game Info Except Server Player Count)
local MainTab = Tabs.MainTab
local StatsService = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local folderPath = "WindUI/Login"
makefolder(folderPath)

-- Player Info
local PlayerInfo = {
    FPS = 0,
    Ping = 0,
    InjectTime = tick(),
    CurrentPlayers = 0,
    MaxPlayers = Players.MaxPlayers,
}

-- Helper: Get Local Time of Day
local function GetLocalTimeOfDay()
    local time = os.date("*t")
    local hour = time.hour
    local period = hour >= 12 and "PM" or "AM"
    hour = hour % 12
    if hour == 0 then hour = 12 end
    local timeOfDay
    if hour >= 6 and hour < 12 and period == "AM" then
        timeOfDay = "Morning"
    elseif hour >= 12 and hour < 6 and period == "PM" then
        timeOfDay = "Afternoon"
    elseif hour >= 6 and hour < 10 and period == "PM" then
        timeOfDay = "Evening"
    else
        timeOfDay = "Night"
    end
    return string.format("%02d:%02d:%02d %s (%s)", hour, time.min, time.sec, period, timeOfDay)
end

-- Helper: Format Time Since Inject
local function FormatTimeSinceInject()
    local elapsed = tick() - PlayerInfo.InjectTime
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = math.floor(elapsed % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

-- Helper: Save Telegram Username
local function SaveTelegramUsername(username)
    if username == "" then
        Notify("Login", "Please enter a Telegram username", "x-circle")
        return
    end
    local filePath = folderPath .. "/" .. username .. ".json"
    local data = { Username = username }
    local success, err = pcall(function()
        writefile(filePath, HttpService:JSONEncode(data))
    end)
    if success then
        Notify("Login", "Username '" .. username .. "' saved successfully!", "check-circle")
    else
        Notify("Login", "Failed to save username: " .. tostring(err), "x-circle")
    end
end

-- Helper: List Saved Usernames
local function ListSavedUsernames()
    local usernames = {}
    for _, file in ipairs(listfiles(folderPath)) do
        local username = file:match("([^/]+)%.json$")
        if username then
            table.insert(usernames, username)
        end
    end
    return usernames
end

-- Helper: Verify Username (Placeholder for future use)
local function VerifyUsername(username)
    Notify("Login", "Verification for '" .. username .. "' is not yet implemented", "alert-circle")
    -- Placeholder for future verification logic
end

-- Player Information Section
Tabs.MainTab:Section({Title = gradient("Player Information", Color3.fromHex("#ffffff"), Color3.fromHex("#636363"))})

-- FPS Paragraph
local fpsParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("FPS", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = "FPS: Calculating...",
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Ping Paragraph
local pingParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("Ping", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = "Ping: Calculating...",
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Time Since Inject Paragraph
local injectTimeParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("Time Since Inject", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = "Time: 00:00:00",
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Local Time Paragraph
local localTimeParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("Local Time", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = "Time: Calculating...",
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Current Players Paragraph
local currentPlayersParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("Current Players", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = "Players: Calculating...",
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Max Players Paragraph
local maxPlayersParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("Max Players", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = string.format("Max Players: %d", PlayerInfo.MaxPlayers),
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Update Loop for Player Info
local lastUpdate = 0
RunService.Heartbeat:Connect(function()
    if tick() - lastUpdate < 0.5 then return end -- Throttle updates to reduce lag
    lastUpdate = tick()

    -- Update Player Info
    PlayerInfo.FPS = 1 / RunService.RenderStepped:Wait()
    PlayerInfo.Ping = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
    PlayerInfo.CurrentPlayers = #Players:GetPlayers()

    fpsParagraph:SetDesc(string.format("FPS: %.1f", PlayerInfo.FPS))
    pingParagraph:SetDesc(string.format("Ping: %.1f ms", PlayerInfo.Ping))
    injectTimeParagraph:SetDesc(string.format("Time: %s", FormatTimeSinceInject()))
    localTimeParagraph:SetDesc(string.format("Time: %s", GetLocalTimeOfDay()))
    currentPlayersParagraph:SetDesc(string.format("Players: %d", PlayerInfo.CurrentPlayers))
end)

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

-- ESP Manager (Optimized with Tracers Ignoring Obstacles)
local ESPManager = {
    Config = {
        Highlight = {Murderer = false, Sheriff = false, Innocent = false, GunDrop = false, Transparency = 0.5},
        Name = {Murderer = false, Sheriff = false, Innocent = false, GunDrop = false},
        Distance = {Murderer = false, Sheriff = false, Innocent = false, GunDrop = false},
        Tracers = {Murderer = false, Sheriff = false, Innocent = false, GunDrop = false, Thickness = 2, Transparency = 0.3},
        TextSize = 18,
    },
    Cache = {
        Players = {},
        GunDrop = nil,
        Highlights = {},
        NameTags = {},
        DistanceTags = {},
        Tracers = {}, -- Stores Drawing.Line objects
    },
    Colors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 0, 255),
        Innocent = Color3.fromRGB(0, 255, 0),
        GunDrop = Color3.fromRGB(255, 255, 0),
    },
    Connections = {},
    Roles = {},
}

-- Helper: Check if player is alive
local function IsAlive(player)
    return player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

-- Helper: Get HumanoidRootPart
local function GetHumanoidRootPart(player)
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- Create Highlight
local function CreateHighlight(target, color, transparency)
    if not target then return nil end
    local highlight = target:FindFirstChild("Highlight") or Instance.new("Highlight")
    highlight.Name = "Highlight"
    highlight.FillColor = color
    highlight.FillTransparency = transparency
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Adornee = target
    highlight.Parent = target
    return highlight
end

-- Create Billboard (Name/Distance)
local function CreateBillboard(target, type, text, color, offsetY)
    if not target then return nil end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = type .. "Tag"
    billboard.Adornee = target
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, offsetY, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100
    billboard.Parent = CoreGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = color
    textLabel.TextSize = ESPManager.Config.TextSize
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Parent = billboard

    return billboard
end

-- Create Tracer (Using Drawing API)
local function CreateTracer(playerOrGun, color)
    if not playerOrGun then return nil end
    local line = Drawing.new("Line")
    line.Color = color
    line.Thickness = ESPManager.Config.Tracers.Thickness
    line.Transparency = 1 - ESPManager.Config.Tracers.Transparency
    line.Visible = false
    print("Created tracer for:", playerOrGun.Name or "GunDrop")
    return line
end

-- Remove ESP for target
local function RemoveEsp(target)
    if ESPManager.Cache.Highlights[target] then
        ESPManager.Cache.Highlights[target]:Destroy()
        ESPManager.Cache.Highlights[target] = nil
    end
    if ESPManager.Cache.NameTags[target] then
        ESPManager.Cache.NameTags[target]:Destroy()
        ESPManager.Cache.NameTags[target] = nil
    end
    if ESPManager.Cache.DistanceTags[target] then
        ESPManager.Cache.DistanceTags[target]:Destroy()
        ESPManager.Cache.DistanceTags[target] = nil
    end
    if ESPManager.Cache.Tracers[target] then
        ESPManager.Cache.Tracers[target]:Remove()
        ESPManager.Cache.Tracers[target] = nil
    end
end

-- Find GunDrop
local function FindGunDrop()
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

-- Update Roles
local function UpdateRoles()
    local success, result = pcall(function()
        local getPlayerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
        if getPlayerData and getPlayerData:IsA("RemoteFunction") then
            return getPlayerData:InvokeServer()
        end
        return nil
    end)
    if success and result then
        ESPManager.Roles = result
    else
        Notify("ESP Error", "Failed to fetch role data", "alert-circle", 5)
        ESPManager.Roles = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsAlive(player) then
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:lower():match("knife") or tool.Name:lower():match("blade")) then
                    ESPManager.Roles[player.Name] = {Role = "Murderer"}
                elseif tool and (tool.Name:lower():match("gun") or tool.Name:lower():match("revolver") or tool.Name:lower():match("pistol")) then
                    ESPManager.Roles[player.Name] = {Role = "Sheriff"}
                else
                    ESPManager.Roles[player.Name] = {Role = "Innocent"}
                end
            end
        end
    end
end

-- Update ESP
local function UpdateEsp()
    local localRoot = GetHumanoidRootPart(LocalPlayer)
    ESPManager.Cache.GunDrop = FindGunDrop()

    -- Update Players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            local role = ESPManager.Roles[player.Name] and ESPManager.Roles[player.Name].Role or "Innocent"
            local isSheriffOrHero = role == "Sheriff" or (role == "Hero" and not ESPManager.Roles[Sheriff])
            local espRole = role == "Murderer" and "Murderer" or isSheriffOrHero and "Sheriff" or "Innocent"
            local color = ESPManager.Colors[espRole]

            -- Highlight
            if ESPManager.Config.Highlight[espRole] then
                ESPManager.Cache.Highlights[player] = ESPManager.Cache.Highlights[player] or CreateHighlight(player.Character, color, ESPManager.Config.Highlight.Transparency)
            else
                if ESPManager.Cache.Highlights[player] then
                    ESPManager.Cache.Highlights[player]:Destroy()
                    ESPManager.Cache.Highlights[player] = nil
                end
            end

            -- Name
            if ESPManager.Config.Name[espRole] then
                ESPManager.Cache.NameTags[player] = ESPManager.Cache.NameTags[player] or CreateBillboard(player.Character:FindFirstChild("Head"), "Name", player.Name, color, 2)
            else
                if ESPManager.Cache.NameTags[player] then
                    ESPManager.Cache.NameTags[player]:Destroy()
                    ESPManager.Cache.NameTags[player] = nil
                end
            end

            -- Distance
            if ESPManager.Config.Distance[espRole] and localRoot then
                ESPManager.Cache.DistanceTags[player] = ESPManager.Cache.DistanceTags[player] or CreateBillboard(player.Character:FindFirstChild("Head"), "Distance", "0 studs", color, 1)
                if ESPManager.Cache.DistanceTags[player] then
                    local distance = (player.Character.HumanoidRootPart.Position - localRoot.Position).Magnitude
                    ESPManager.Cache.DistanceTags[player].TextLabel.Text = string.format("%.1f studs", distance)
                end
            else
                if ESPManager.Cache.DistanceTags[player] then
                    ESPManager.Cache.DistanceTags[player]:Destroy()
                    ESPManager.Cache.DistanceTags[player] = nil
                end
            end

            -- Tracers
            if ESPManager.Config.Tracers[espRole] then
                ESPManager.Cache.Tracers[player] = ESPManager.Cache.Tracers[player] or CreateTracer(player, color)
                if ESPManager.Cache.Tracers[player] then
                    local root = GetHumanoidRootPart(player)
                    if root then
                        local screenPos, onScreen = CurrentCamera:WorldToViewportPoint(root.Position)
                        if onScreen then
                            ESPManager.Cache.Tracers[player].From = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y)
                            ESPManager.Cache.Tracers[player].To = Vector2.new(screenPos.X, screenPos.Y)
                            ESPManager.Cache.Tracers[player].Visible = true
                        else
                            ESPManager.Cache.Tracers[player].Visible = false
                        end
                    else
                        ESPManager.Cache.Tracers[player].Visible = false
                    end
                end
            else
                if ESPManager.Cache.Tracers[player] then
                    ESPManager.Cache.Tracers[player]:Remove()
                    ESPManager.Cache.Tracers[player] = nil
                end
            end
        else
            RemoveEsp(player)
        end
    end

    -- Update GunDrop
    if ESPManager.Cache.GunDrop then
        local color = ESPManager.Colors.GunDrop
        if ESPManager.Config.Highlight.GunDrop then
            ESPManager.Cache.Highlights[ESPManager.Cache.GunDrop] = ESPManager.Cache.Highlights[ESPManager.Cache.GunDrop] or CreateHighlight(ESPManager.Cache.GunDrop, color, ESPManager.Config.Highlight.Transparency)
        else
            if ESPManager.Cache.Highlights[ESPManager.Cache.GunDrop] then
                ESPManager.Cache.Highlights[ESPManager.Cache.GunDrop]:Destroy()
                ESPManager.Cache.Highlights[ESPManager.Cache.GunDrop] = nil
            end
        end

        if ESPManager.Config.Name.GunDrop then
            ESPManager.Cache.NameTags[ESPManager.Cache.GunDrop] = ESPManager.Cache.NameTags[ESPManager.Cache.GunDrop] or CreateBillboard(ESPManager.Cache.GunDrop, "Name", "GunDrop", color, 2)
        else
            if ESPManager.Cache.NameTags[ESPManager.Cache.GunDrop] then
                ESPManager.Cache.NameTags[ESPManager.Cache.GunDrop]:Destroy()
                ESPManager.Cache.NameTags[ESPManager.Cache.GunDrop] = nil
            end
        end

        if ESPManager.Config.Distance.GunDrop and localRoot then
            ESPManager.Cache.DistanceTags[ESPManager.Cache.GunDrop] = ESPManager.Cache.DistanceTags[ESPManager.Cache.GunDrop] or CreateBillboard(ESPManager.Cache.GunDrop, "Distance", "0 studs", color, 1)
            if ESPManager.Cache.DistanceTags[ESPManager.Cache.GunDrop] then
                local distance = (ESPManager.Cache.GunDrop.Position - localRoot.Position).Magnitude
                ESPManager.Cache.DistanceTags[ESPManager.Cache.GunDrop].TextLabel.Text = string.format("%.1f studs", distance)
            end
        else
            if ESPManager.Cache.DistanceTags[ESPManager.Cache.GunDrop] then
                ESPManager.Cache.DistanceTags[ESPManager.Cache.GunDrop]:Destroy()
                ESPManager.Cache.DistanceTags[ESPManager.Cache.GunDrop] = nil
            end
        end

        if ESPManager.Config.Tracers.GunDrop then
            ESPManager.Cache.Tracers[ESPManager.Cache.GunDrop] = ESPManager.Cache.Tracers[ESPManager.Cache.GunDrop] or CreateTracer(ESPManager.Cache.GunDrop, color)
            if ESPManager.Cache.Tracers[ESPManager.Cache.GunDrop] then
                local screenPos, onScreen = CurrentCamera:WorldToViewportPoint(ESPManager.Cache.GunDrop.Position)
                if onScreen then
                    ESPManager.Cache.Tracers[ESPManager.Cache.GunDrop].From = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y)
                    ESPManager.Cache.Tracers[ESPManager.Cache.GunDrop].To = Vector2.new(screenPos.X, screenPos.Y)
                    ESPManager.Cache.Tracers[ESPManager.Cache.GunDrop].Visible = true
                else
                    ESPManager.Cache.Tracers[ESPManager.Cache.GunDrop].Visible = false
                end
            end
        else
            if ESPManager.Cache.Tracers[ESPManager.Cache.GunDrop] then
                ESPManager.Cache.Tracers[ESPManager.Cache.GunDrop]:Remove()
                ESPManager.Cache.Tracers[ESPManager.Cache.GunDrop] = nil
            end
        end
    else
        RemoveEsp(ESPManager.Cache.GunDrop)
    end
end

-- Initialize ESP
local function InitializeEsp()
    -- Role Update Loop
    task.spawn(function()
        while true do
            UpdateRoles()
            task.wait(2)
        end
    end)

    -- ESP Update Loop
    ESPManager.Connections.Update = RunService.Heartbeat:Connect(function()
        if ESPManager.Config.Highlight.Murderer or ESPManager.Config.Highlight.Sheriff or ESPManager.Config.Highlight.Innocent or ESPManager.Config.Highlight.GunDrop or
           ESPManager.Config.Name.Murderer or ESPManager.Config.Name.Sheriff or ESPManager.Config.Name.Innocent or ESPManager.Config.Name.GunDrop or
           ESPManager.Config.Distance.Murderer or ESPManager.Config.Distance.Sheriff or ESPManager.Config.Distance.Innocent or ESPManager.Config.Distance.GunDrop or
           ESPManager.Config.Tracers.Murderer or ESPManager.Config.Tracers.Sheriff or ESPManager.Config.Tracers.Innocent or ESPManager.Config.Tracers.GunDrop then
            UpdateEsp()
        end
    end)

    -- Cleanup on Player Leave
    Players.PlayerRemoving:Connect(function(player)
        RemoveEsp(player)
        if player == LocalPlayer then
            for _, p in pairs(Players:GetPlayers()) do RemoveEsp(p) end
            RemoveEsp(ESPManager.Cache.GunDrop)
        end
    end)

    -- Cleanup on Character Respawn
    LocalPlayer.CharacterAdded:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do RemoveEsp(player) end
        RemoveEsp(ESPManager.Cache.GunDrop)
    end)
end

InitializeEsp()

-- ESP UI
Tabs.EspTab:Section({Title = gradient("Murderer ESP", Color3.fromHex("#e80909"), Color3.fromHex("#630404"))})
Tabs.EspTab:Toggle({
    Title = gradient("Highlight Murderer", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Highlight.Murderer = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Name Murderer", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Name.Murderer = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Distance Murderer", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Distance.Murderer = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Tracers Murderer", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Tracers.Murderer = state
        if not state then UpdateEsp() end
    end
})

Tabs.EspTab:Section({Title = gradient("Sheriff ESP", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9"))})
Tabs.EspTab:Toggle({
    Title = gradient("Highlight Sheriff", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Highlight.Sheriff = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Name Sheriff", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Name.Sheriff = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Distance Sheriff", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Distance.Sheriff = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Tracers Sheriff", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Tracers.Sheriff = state
        if not state then UpdateEsp() end
    end
})

Tabs.EspTab:Section({Title = gradient("Innocent ESP", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c"))})
Tabs.EspTab:Toggle({
    Title = gradient("Highlight Innocent", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Highlight.Innocent = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Name Innocent", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Name.Innocent = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Distance Innocent", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Distance.Innocent = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Tracers Innocent", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Tracers.Innocent = state
        if not state then UpdateEsp() end
    end
})

Tabs.EspTab:Section({Title = gradient("GunDrop ESP", Color3.fromHex("#ffff00"), Color3.fromHex("#ccaa00"))})
Tabs.EspTab:Toggle({
    Title = gradient("Highlight GunDrop", Color3.fromHex("#ffff00"), Color3.fromHex("#ccaa00")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Highlight.GunDrop = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Name GunDrop", Color3.fromHex("#ffff00"), Color3.fromHex("#ccaa00")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Name.GunDrop = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Distance GunDrop", Color3.fromHex("#ffff00"), Color3.fromHex("#ccaa00")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Distance.GunDrop = state
        if not state then UpdateEsp() end
    end
})
Tabs.EspTab:Toggle({
    Title = gradient("Tracers GunDrop", Color3.fromHex("#ffff00"), Color3.fromHex("#ccaa00")),
    Default = false,
    Callback = function(state)
        ESPManager.Config.Tracers.GunDrop = state
        if not state then UpdateEsp() end
    end
})

Tabs.EspTab:Section({Title = gradient("ESP Settings", Color3.fromHex("#ffffff"), Color3.fromHex("#636363"))})
Tabs.EspTab:Slider({
    Title = gradient("Text Size", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")),
    Value = {Min = 12, Max = 24, Default = 18},
    Callback = function(value)
        ESPManager.Config.TextSize = value
        for _, tag in pairs(ESPManager.Cache.NameTags) do
            if tag.TextLabel then tag.TextLabel.TextSize = value end
        end
        for _, tag in pairs(ESPManager.Cache.DistanceTags) do
            if tag.TextLabel then tag.TextLabel.TextSize = value end
        end
    end
})
Tabs.EspTab:Slider({
    Title = gradient("Highlight Transparency", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")),
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPManager.Config.Highlight.Transparency = value
        for _, highlight in pairs(ESPManager.Cache.Highlights) do
            if highlight then highlight.FillTransparency = value end
        end
    end
})
Tabs.EspTab:Slider({
    Title = gradient("Tracer Thickness", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")),
    Value = {Min = 1, Max = 5, Default = 2},
    Callback = function(value)
        ESPManager.Config.Tracers.Thickness = value
        for _, tracer in pairs(ESPManager.Cache.Tracers) do
            if tracer then tracer.Thickness = value end
        end
    end
})
Tabs.EspTab:Slider({
    Title = gradient("Tracer Transparency", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")),
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.3},
    Callback = function(value)
        ESPManager.Config.Tracers.Transparency = value
        for _, tracer in pairs(ESPManager.Cache.Tracers) do
            if tracer then tracer.Transparency = 1 - value end
        end
    end
})

-- Teleport Tab (Updated with fixed Lobby coordinates)
local TeleportTab = Tabs.TeleportTab
local HttpService = game:GetService("HttpService")
local folderPath = "WindUI/Coordinates"
makefolder(folderPath)

-- Coordinate Management
local Coordinates = {
    Saved = {},
    Current = {X = 0, Y = 0, Z = 0},
    FileName = ""
}

-- Helper: Save Coordinates to File
local function SaveCoordinates()
    if Coordinates.FileName == "" then
        Notify("Coordinates", "Please enter a file name", "x-circle")
        return
    end
    local filePath = folderPath .. "/" .. Coordinates.FileName .. ".json"
    local data = {
        X = Coordinates.Current.X,
        Y = Coordinates.Current.Y,
        Z = Coordinates.Current.Z
    }
    local success, err = pcall(function()
        writefile(filePath, HttpService:JSONEncode(data))
    end)
    if success then
        Notify("Coordinates", "Coordinates saved as " .. Coordinates.FileName, "check-circle")
        Coordinates.Saved[Coordinates.FileName] = data
    else
        Notify("Coordinates", "Failed to save coordinates: " .. tostring(err), "x-circle")
    end
end

-- Helper: Load Coordinates from File
local function LoadCoordinates(fileName)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    if isfile(filePath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(filePath))
        end)
        if success and data.X and data.Y and data.Z then
            Coordinates.Current = data
            Notify("Coordinates", "Loaded coordinates from " .. fileName, "check-circle")
            return true
        else
            Notify("Coordinates", "Failed to load coordinates: Invalid file", "x-circle")
        end
    else
        Notify("Coordinates", "File not found: " .. fileName, "x-circle")
    end
    return false
end

-- Helper: List Saved Coordinate Files
local function ListCoordinateFiles()
    local files = {}
    for _, file in ipairs(listfiles(folderPath)) do
        local fileName = file:match("([^/]+)%.json$")
        if fileName then
            table.insert(files, fileName)
        end
    end
    return files
end

-- Helper: Copy Coordinates to Clipboard
local function CopyCoordinates()
    local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
    if humanoidRootPart then
        local pos = humanoidRootPart.Position
        local coordString = string.format("X: %.2f, Y: %.2f, Z: %.2f", pos.X, pos.Y, pos.Z)
        if pcall(setclipboard, coordString) then
            Notify("Coordinates", "Coordinates copied to clipboard!", "check-circle")
        else
            Notify("Coordinates", "Failed to copy coordinates", "x-circle")
        end
    else
        Notify("Coordinates", "Player character not found", "x-circle")
    end
end

-- Helper: Teleport to Coordinates
local function TeleportToCoordinates()
    if not SetDebounce("TeleportToCoordinates", Config.DebounceTime) then return end
    local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(Coordinates.Current.X, Coordinates.Current.Y, Coordinates.Current.Z)
        Notify("Teleport", "Teleported to coordinates!", "check-circle")
    else
        Notify("Teleport", "Player character not found", "x-circle")
    end
end

-- Helper: Teleport to Player (Updated for reliability)
local function TeleportToPlayer(target)
    if not SetDebounce("TeleportToPlayer", Config.DebounceTime) then return end
    if target and target.Character then
        local targetRoot = GetHumanoidRootPart(target)
        local localRoot = GetHumanoidRootPart(LocalPlayer)
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, Config.TeleportOffset, 0)
            Notify("Teleport", "Teleported to " .. target.Name, "check-circle")
        else
            Notify("Teleport", "Target not found or unavailable", "x-circle")
        end
    else
        Notify("Teleport", "No target selected", "x-circle")
    end
end

-- Helper: Teleport to Lobby (Updated with fixed coordinates)
local function TeleportToLobby()
    if not SetDebounce("TeleportToLobby", Config.DebounceTime) then return end
    local localRoot = GetHumanoidRootPart(LocalPlayer)
    if localRoot then
        localRoot.CFrame = CFrame.new(-109.37, 138.35, 10.42)
        Notify("Teleport", "Teleported to Lobby!", "check-circle")
    else
        Notify("Teleport", "Player character not found", "x-circle")
    end
end

-- Helper: Teleport to Sheriff (Optimized)
local function TeleportToSheriff()
    if not SetDebounce("TeleportToSheriff", Config.DebounceTime) then return end
    UpdateRoles()
    local sheriff
    for playerName, data in pairs(ESPManager.Roles) do
        if data.Role == "Sheriff" or data.Role == "Hero" then
            sheriff = Players:FindFirstChild(playerName)
            break
        end
    end
    if sheriff and sheriff.Character then
        TeleportToPlayer(sheriff)
    else
        Notify("Teleport", "No Sheriff or Hero in the current match", "x-circle")
    end
end

-- Helper: Teleport to Murderer (Optimized)
local function TeleportToMurderer()
    if not SetDebounce("TeleportToMurderer", Config.DebounceTime) then return end
    UpdateRoles()
    local murderer
    for playerName, data in pairs(ESPManager.Roles) do
        if data.Role == "Murderer" then
            murderer = Players:FindFirstChild(playerName)
            break
        end
    end
    if murderer and murderer.Character then
        TeleportToPlayer(murderer)
    else
        Notify("Teleport", "No Murderer in the current match", "x-circle")
    end
end

-- Teleport Tab UI
TeleportTab:Section({Title = gradient("Player Teleport", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))})

local teleportDropdown
local function updateTeleportPlayers()
    local playersList = {"Select Player"}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then table.insert(playersList, player.Name) end
    end
    return playersList
end

teleportDropdown = TeleportTab:Dropdown({
    Title = "Players",
    Values = updateTeleportPlayers(),
    Value = "Select Player",
    Callback = function(selected)
        teleportTarget = selected ~= "Select Player" and Players:FindFirstChild(selected) or nil
    end
})

TeleportTab:Button({
    Title = "Teleport to Player",
    Callback = function() TeleportToPlayer(teleportTarget) end
})

TeleportTab:Button({
    Title = "Update Players List",
    Callback = function() teleportDropdown:Refresh(updateTeleportPlayers()) end
})

-- Coordinate Management Section
TeleportTab:Section({Title = gradient("Coordinate Management", Color3.fromHex("#b914fa"), Color3.fromHex("#7023c2"))})

TeleportTab:Input({
    Title = "Coordinate File Name",
    PlaceholderText = "Enter file name",
    Callback = function(text)
        Coordinates.FileName = text
    end
})

TeleportTab:Button({
    Title = "Save Current Coordinates",
    Callback = function()
        local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
        if humanoidRootPart then
            Coordinates.Current = {
                X = humanoidRootPart.Position.X,
                Y = humanoidRootPart.Position.Y,
                Z = humanoidRootPart.Position.Z
            }
            SaveCoordinates()
        else
            Notify("Coordinates", "Player character not found", "x-circle")
        end
    end
})

TeleportTab:Button({
    Title = "Copy Current Coordinates",
    Callback = CopyCoordinates
})

local coordFilesDropdown
coordFilesDropdown = TeleportTab:Dropdown({
    Title = "Saved Coordinates",
    Multi = false,
    AllowNone = true,
    Values = ListCoordinateFiles(),
    Callback = function(selected)
        if selected then
            Coordinates.FileName = selected
            LoadCoordinates(selected)
        end
    end
})

TeleportTab:Button({
    Title = "Refresh Coordinates List",
    Callback = function() coordFilesDropdown:Refresh(ListCoordinateFiles()) end
})

TeleportTab:Slider({
    Title = "X Coordinate",
    Value = {Min = -10000, Max = 10000, Default = 0, Step = 0.1},
    Callback = function(value) Coordinates.Current.X = value end
})

TeleportTab:Slider({
    Title = "Y Coordinate",
    Value = {Min = -10000, Max = 10000, Default = 0, Step = 0.1},
    Callback = function(value) Coordinates.Current.Y = value end
})

TeleportTab:Slider({
    Title = "Z Coordinate",
    Value = {Min = -10000, Max = 10000, Default = 0, Step = 0.1},
    Callback = function(value) Coordinates.Current.Z = value end
})

TeleportTab:Button({
    Title = "Teleport to Coordinates",
    Callback = TeleportToCoordinates
})

-- Special Teleports Section
TeleportTab:Section({Title = gradient("Special Teleports", Color3.fromHex("#b914fa"), Color3.fromHex("#7023c2"))})

TeleportTab:Button({
    Title = "Teleport to Lobby",
    Callback = TeleportToLobby
})

TeleportTab:Button({
    Title = "Teleport to Sheriff",
    Callback = TeleportToSheriff
})

TeleportTab:Button({
    Title = "Teleport to Murderer",
    Callback = TeleportToMurderer
})

-- Player Join/Leave Handlers
Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    if teleportDropdown then teleportDropdown:Refresh(updateTeleportPlayers()) end
end)

Players.PlayerRemoving:Connect(function(player)
    if teleportDropdown then teleportDropdown:Refresh(updateTeleportPlayers()) end
    if player == teleportTarget then teleportTarget = nil end
end)
-- Aimbot Manager (Reworked with Lock Camera, Show/Lock FOV, and Spectating Mode)
local AimbotManager = {
    Config = {
        LockCamera = false,
        TargetRole = "None",
        Smoothness = 0.2, -- 0 = instant, 1 = very smooth
        WallCheck = false,
        FOV = {
            ShowFOV = true,
            LockInFOV = true,
            Radius = 150,
            Color = Color3.fromRGB(255, 255, 255),
        },
    },
    Cache = {
        FOVCircle = nil,
        Connection = nil,
        OriginalCameraType = Enum.CameraType.Custom,
        OriginalCameraSubject = nil,
    },
}

-- Helper: Get nearest target within FOV
local function GetNearestTarget()
    local localRoot = GetHumanoidRootPart(LocalPlayer)
    if not localRoot then return nil end

    local closestPlayer, closestDistance = nil, math.huge
    local centerScreen = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            local role = ESPManager.Roles[player.Name] and ESPManager.Roles[player.Name].Role or "Innocent"
            local isSheriffOrHero = role == "Sheriff" or (role == "Hero" and not ESPManager.Roles[Sheriff])
            local aimRole = role == "Murderer" and "Murderer" or isSheriffOrHero and "Sheriff" or "Innocent"

            if AimbotManager.Config.TargetRole == aimRole or AimbotManager.Config.TargetRole == "All" then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local screenPos, onScreen = CurrentCamera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                        if not AimbotManager.Config.FOV.LockInFOV or screenDistance <= AimbotManager.Config.FOV.Radius then
                            if AimbotManager.Config.WallCheck then
                                local rayParams = RaycastParams.new()
                                rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                                local rayResult = Workspace:Raycast(CurrentCamera.CFrame.Position, (head.Position - CurrentCamera.CFrame.Position).Unit * 1000, rayParams)
                                if rayResult and rayResult.Instance:IsDescendantOf(player.Character) then
                                    if screenDistance < closestDistance then
                                        closestPlayer = player
                                        closestDistance = screenDistance
                                    end
                                end
                            else
                                if screenDistance < closestDistance then
                                    closestPlayer = player
                                    closestDistance = screenDistance
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Create FOV Circle
local function CreateFOVCircle()
    if not AimbotManager.Config.FOV.ShowFOV then return end
    local circle = Drawing.new("Circle")
    circle.Radius = AimbotManager.Config.FOV.Radius
    circle.Position = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
    circle.Color = AimbotManager.Config.FOV.Color
    circle.Thickness = 2
    circle.Transparency = 0.7
    circle.Visible = AimbotManager.Config.LockCamera
    circle.Filled = false
    AimbotManager.Cache.FOVCircle = circle
end

-- Update FOV Circle
local function UpdateFOVCircle()
    if AimbotManager.Cache.FOVCircle then
        AimbotManager.Cache.FOVCircle.Radius = AimbotManager.Config.FOV.Radius
        AimbotManager.Cache.FOVCircle.Color = AimbotManager.Config.FOV.Color
        AimbotManager.Cache.FOVCircle.Position = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
        AimbotManager.Cache.FOVCircle.Visible = AimbotManager.Config.FOV.ShowFOV and AimbotManager.Config.LockCamera
    elseif AimbotManager.Config.FOV.ShowFOV and AimbotManager.Config.LockCamera then
        CreateFOVCircle()
    end
end

-- Cleanup Aimbot
local function CleanupAimbot()
    AimbotManager.Config.LockCamera = false
    AimbotManager.Config.Spectate.Enabled = false
    if AimbotManager.Cache.Connection then
        AimbotManager.Cache.Connection:Disconnect()
        AimbotManager.Cache.Connection = nil
    end
    if AimbotManager.Cache.FOVCircle then
        AimbotManager.Cache.FOVCircle:Remove()
        AimbotManager.Cache.FOVCircle = nil
    end
    CurrentCamera.CameraType = AimbotManager.Cache.OriginalCameraType
    CurrentCamera.CameraSubject = AimbotManager.Cache.OriginalCameraSubject
end

-- Aimbot and Spectate Logic
local function InitializeAimbot()
    -- Save original camera settings
    AimbotManager.Cache.OriginalCameraType = CurrentCamera.CameraType
    AimbotManager.Cache.OriginalCameraSubject = CurrentCamera.CameraSubject

    -- Aimbot and Spectate Loop
    AimbotManager.Cache.Connection = RunService.RenderStepped:Connect(function(deltaTime)
        UpdateFOVCircle()

        if not AimbotManager.Config.LockCamera and not AimbotManager.Config.Spectate.Enabled then
            CurrentCamera.CameraType = AimbotManager.Cache.OriginalCameraType
            CurrentCamera.CameraSubject = AimbotManager.Cache.OriginalCameraSubject
            return
        end

        local target = GetNearestTarget()
        if AimbotManager.Config.Spectate.Enabled and target then
            local targetRoot = GetHumanoidRootPart(target)
            if targetRoot then
                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                CurrentCamera.CFrame = targetRoot.CFrame * AimbotManager.Config.Spectate.Offset
            end
        elseif AimbotManager.Config.Spectate.Enabled then
            CurrentCamera.CameraType = AimbotManager.Cache.OriginalCameraType
            CurrentCamera.CameraSubject = AimbotManager.Cache.OriginalCameraSubject
        elseif AimbotManager.Config.LockCamera and target then
            local head = target.Character:FindFirstChild("Head")
            if head then
                local targetPos = head.Position
                local currentCFrame = CurrentCamera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
                CurrentCamera.CFrame = currentCFrame:Lerp(targetCFrame, math.clamp(1 - AimbotManager.Config.Smoothness, 0, 1))
            end
        end
    end)

    -- Cleanup on Player Leave or Respawn
    Players.PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            CleanupAimbot()
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        CleanupAimbot()
        InitializeAimbot()
    end)
end

InitializeAimbot()

-- Aimbot UI
Tabs.AimbotTab:Section({Title = gradient("Aimbot Settings", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))})
Tabs.AimbotTab:Toggle({
    Title = gradient("Lock Camera", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6")),
    Default = false,
    Callback = function(state)
        AimbotManager.Config.LockCamera = state
        if not state then
            AimbotManager.Config.Spectate.Enabled = false
            if AimbotManager.Cache.FOVCircle then
                AimbotManager.Cache.FOVCircle.Visible = false
            end
            CurrentCamera.CameraType = AimbotManager.Cache.OriginalCameraType
            CurrentCamera.CameraSubject = AimbotManager.Cache.OriginalCameraSubject
        end
        Notify("Aimbot", state and "Camera lock enabled!" or "Camera lock disabled", state and "check-circle" or "x-circle", 2)
    end
})
Tabs.AimbotTab:Dropdown({
    Title = gradient("Target Role", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6")),
    Values = {"None", "Murderer", "Sheriff", "Innocent", "All"},
    Value = "None",
    Callback = function(selected)
        AimbotManager.Config.TargetRole = selected
        Notify("Aimbot", "Target role set to: " .. selected, "check-circle", 2)
    end
})
Tabs.AimbotTab:Slider({
    Title = gradient("Smoothness", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6")),
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.2},
    Callback = function(value)
        AimbotManager.Config.Smoothness = value
        Notify("Aimbot", "Smoothness set to: " .. value, "check-circle", 2)
    end
})
Tabs.AimbotTab:Toggle({
    Title = gradient("WallCheck", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6")),
    Default = false,
    Callback = function(state)
        AimbotManager.Config.WallCheck = state
        Notify("Aimbot", state and "WallCheck enabled!" or "WallCheck disabled", state and "check-circle" or "x-circle", 2)
    end
})

Tabs.AimbotTab:Section({Title = gradient("FOV Settings", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))})
Tabs.AimbotTab:Toggle({
    Title = gradient("Show FOV Circle", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6")),
    Default = true,
    Callback = function(state)
        AimbotManager.Config.FOV.ShowFOV = state
        if AimbotManager.Cache.FOVCircle then
            AimbotManager.Cache.FOVCircle.Visible = state and AimbotManager.Config.LockCamera
        end
        Notify("Aimbot", state and "FOV Circle shown!" or "FOV Circle hidden", state and "check-circle" or "x-circle", 2)
    end
})
Tabs.AimbotTab:Toggle({
    Title = gradient("Lock in FOV", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6")),
    Default = true,
    Callback = function(state)
        AimbotManager.Config.FOV.LockInFOV = state
        Notify("Aimbot", state and "Lock in FOV enabled!" or "Lock in FOV disabled", state and "check-circle" or "x-circle", 2)
    end
})
Tabs.AimbotTab:Slider({
    Title = gradient("FOV Radius", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6")),
    Value = {Min = 50, Max = 500, Default = 150},
    Callback = function(value)
        AimbotManager.Config.FOV.Radius = value
        UpdateFOVCircle()
        Notify("Aimbot", "FOV Radius set to: " .. value, "check-circle", 2)
    end
})
Tabs.AimbotTab:Colorpicker({
    Title = gradient("FOV Color", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6")),
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        AimbotManager.Config.FOV.Color = color
        UpdateFOVCircle()
        Notify("Aimbot", "FOV Color updated!", "check-circle", 2)
    end
})

-- AutoFarm (Optimized for Speed and Coin_Server in CoinContainer)
-- AutoFarm Manager
local AutoFarmManager = {
    Config = {
        Enabled = false,
        Mode = "Teleport", -- Options: "Teleport", "Tween", "Walk"
        TeleportSpeed = 0.1, -- Delay between teleports
        TweenSpeed = 80, -- Studs per second for tweening
        WalkSpeed = 80, -- Walkspeed for walking mode
    },
    Cache = {
        Connection = nil,
        Coins = {},
    },
}

local Maps = {"ResearchFacility", "Hospital3", "MilBase", "House2", "Workplace", "Mansion2", "BioLab", "Hotel", "Factory", "Bank2", "PoliceStation"}

-- Helper: Find Current Map
local function GetCurrentMap()
    for _, mapName in ipairs(Maps) do
        if Workspace:FindFirstChild(mapName) then
            return Workspace[mapName]
        end
    end
    return nil
end

-- Helper: Scan for Coins
local function ScanForCoins()
    AutoFarmManager.Cache.Coins = {}
    local map = GetCurrentMap()
    if map and map:FindFirstChild("CoinContainer") then
        for _, coin in ipairs(map.CoinContainer:GetChildren()) do
            if coin:IsA("BasePart") and coin.Name:match("Coin_Server") then
                table.insert(AutoFarmManager.Cache.Coins, coin)
            end
        end
    end
    return #AutoFarmManager.Cache.Coins > 0
end

-- Helper: Move to Coin
local function MoveToCoin(coin)
    if not SetDebounce("MoveToCoin", Config.DebounceTime) then return false end
    local humanoidRootPart = GetHumanoidRootPart(LocalPlayer)
    if not humanoidRootPart or not coin then
        Notify("AutoFarm", "Player character or coin not found", "x-circle")
        return false
    end

    local targetPos = coin.Position
    local success = false

    if AutoFarmManager.Config.Mode == "Teleport" then
        humanoidRootPart.CFrame = CFrame.new(targetPos)
        success = true
        task.wait(AutoFarmManager.Config.TeleportSpeed)
    elseif AutoFarmManager.Config.Mode == "Tween" then
        local tweenService = game:GetService("TweenService")
        local distance = (humanoidRootPart.Position - targetPos).Magnitude
        local tweenTime = distance / AutoFarmManager.Config.TweenSpeed
        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
        local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
        tween.Completed:Wait()
        success = true
    elseif AutoFarmManager.Config.Mode == "Walk" then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = AutoFarmManager.Config.WalkSpeed
            humanoid:MoveTo(targetPos)
            local startTime = tick()
            while (humanoidRootPart.Position - targetPos).Magnitude > 2 and tick() - startTime < 5 do
                task.wait()
            end
            success = (humanoidRootPart.Position - targetPos).Magnitude <= 2
        end
    end

    if success then
        Notify("AutoFarm", "Collected coin!", "check-circle", 1)
    else
        Notify("AutoFarm", "Failed to move to coin", "x-circle", 1)
    end
    return success
end

-- Helper: AutoFarm Loop
local function AutoFarmLoop()
    while AutoFarmManager.Config.Enabled do
        if not ScanForCoins() then
            Notify("AutoFarm", "No coins found in CoinContainer", "x-circle", 2)
            task.wait(1)
            continue
        end

        for _, coin in ipairs(AutoFarmManager.Cache.Coins) do
            if not AutoFarmManager.Config.Enabled then break end
            if coin and coin.Parent then
                MoveToCoin(coin)
            end
        end
        task.wait(0.1) -- Small delay to prevent lag
    end
end

-- AutoFarm UI (Replace the existing AutoFarm section in the script)
Tabs.AutoFarm:Section({Title = gradient("Coin Farming", Color3.fromHex("#FFD700"), Color3.fromHex("#FFA500"))})

Tabs.AutoFarm:Dropdown({
    Title = gradient("Farm Mode", Color3.fromHex("#FFD700"), Color3.fromHex("#FFA500")),
    Values = {"Teleport", "Tween", "Walk"},
    Value = AutoFarmManager.Config.Mode,
    Callback = function(mode)
        AutoFarmManager.Config.Mode = mode
        Notify("AutoFarm", "Farm mode set to: " .. mode, "check-circle", 1)
    end
})

Tabs.AutoFarm:Slider({
    Title = gradient("Teleport Speed", Color3.fromHex("#FFD700"), Color3.fromHex("#FFA500")),
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = AutoFarmManager.Config.TeleportSpeed},
    Callback = function(value)
        AutoFarmManager.Config.TeleportSpeed = value
        Notify("AutoFarm", "Teleport speed set to: " .. value, "check-circle", 1)
    end
})

Tabs.AutoFarm:Slider({
    Title = gradient("Tween Speed", Color3.fromHex("#FFD700"), Color3.fromHex("#FFA500")),
    Value = {Min = 20, Max = 200, Default = AutoFarmManager.Config.TweenSpeed},
    Callback = function(value)
        AutoFarmManager.Config.TweenSpeed = value
        Notify("AutoFarm", "Tween speed set to: " .. value, "check-circle", 1)
    end
})

Tabs.AutoFarm:Slider({
    Title = gradient("Walk Speed", Color3.fromHex("#FFD700"), Color3.fromHex("#FFA500")),
    Value = {Min = 16, Max = 100, Default = AutoFarmManager.Config.WalkSpeed},
    Callback = function(value)
        AutoFarmManager.Config.WalkSpeed = value
        Notify("AutoFarm", "Walk speed set to: " .. value, "check-circle", 1)
    end
})

Tabs.AutoFarm:Toggle({
    Title = gradient("Enable AutoFarm", Color3.fromHex("#FFD700"), Color3.fromHex("#FFA500")),
    Default = AutoFarmManager.Config.Enabled,
    Callback = function(state)
        AutoFarmManager.Config.Enabled = state
        if state then
            Notify("AutoFarm", "AutoFarm enabled! Collecting coins...", "check-circle", 2)
            task.spawn(AutoFarmLoop)
        else
            Notify("AutoFarm", "AutoFarm disabled", "x-circle", 2)
            -- Reset walkspeed to default when disabling
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = CharacterSettings.WalkSpeed.Default
            end
        end
    end
})

-- Monitor Map Changes
Workspace.ChildAdded:Connect(function(child)
    if table.find(Maps, child.Name) then
        task.wait(1) -- Wait for map to load
        if AutoFarmManager.Config.Enabled then
            ScanForCoins()
            Notify("AutoFarm", "New map detected: " .. child.Name, "info", 2)
        end
    end
end)

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

-- Murder Tab (Reworked with Enhanced Kill All, Kill Aura Removed)
local MurderTab = Tabs.MurderTab
local killAllActive = false
local attackDelay = 0.1 -- Fast attack delay for efficiency
local maxDistance = 500 -- Maximum distance for Kill All targets (500 studs)
local teleportTarget = nil
local cachedRoles = {}
local lastRoleUpdate = 0
local roleUpdateInterval = 2 -- Update roles every 2 seconds

-- Helper: Cache Roles Efficiently
local function updateCachedRoles()
    if tick() - lastRoleUpdate < roleUpdateInterval then return end
    lastRoleUpdate = tick()
    local success, roles = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    if success and roles then
        cachedRoles = roles
    else
        Notify("Roles", "Failed to fetch roles, using fallback", "alert-circle", 3)
        cachedRoles = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsAlive(player) then
                local tool = player.Character:FindFirstChildOfClass("Tool")
                cachedRoles[player.Name] = {
                    Role = tool and (tool.Name:lower():match("knife") and "Murderer" or
                                     tool.Name:lower():match("gun") and "Sheriff" or "Innocent")
                }
            end
        end
    end
end

-- Helper: Equip Knife (Optimized)
local function equipKnife(character)
    if not character then return false end
    if character:FindFirstChild("Knife") then return true end
    local knife = LocalPlayer.Backpack:FindFirstChild("Knife")
    if knife then
        knife.Parent = character
        task.wait(0.05) -- Minimal wait for equip
        return character:FindFirstChild("Knife") ~= nil
    end
    return false
end

-- Helper: Attack Player (Optimized)
local function attackPlayer(target, silent)
    if not SetDebounce("AttackPlayer", Config.DebounceTime) then return false end
    local character = LocalPlayer.Character
    local targetCharacter = target and target.Character
    if not character or not targetCharacter then return false end
    local humanoid = targetCharacter:FindFirstChild("Humanoid")
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    local localRoot = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or humanoid.Health <= 0 or not targetRoot or not localRoot then return false end
    if not equipKnife(character) then return false end
    localRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 0, 2), targetRoot.Position)
    local knife = character:FindFirstChild("Knife")
    if knife and knife:FindFirstChild("Stab") then
        knife.Stab:FireServer("Down") -- Single call for speed
        if not silent then
            Notify("Kill", "Attacked " .. target.Name, "check-circle", 1)
        end
        return true
    end
    return false
end

-- Helper: Get Sheriff or Hero (Optimized)
local function getSheriffOrHero()
    updateCachedRoles()
    for playerName, data in pairs(cachedRoles) do
        if data.Role == "Sheriff" or data.Role == "Hero" then
            local player = Players:FindFirstChild(playerName)
            if player and IsAlive(player) then
                return player
            end
        end
    end
    return nil
end

-- Helper: Get Nearest Player within Max Distance
local function getNearestPlayer(maxDist)
    local localRoot = GetHumanoidRootPart(LocalPlayer)
    if not localRoot then return nil end
    local nearestPlayer, minDistance = nil, maxDist
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            local targetRoot = GetHumanoidRootPart(player)
            if targetRoot then
                local distance = (localRoot.Position - targetRoot.Position).Magnitude
                if distance <= minDistance then
                    nearestPlayer = player
                    minDistance = distance
                end
            end
        end
    end
    return nearestPlayer
end

-- Helper: Kill All Loop (Enhanced)
local function killAllLoop()
    local lastNotify = 0
    while killAllActive do
        local character = LocalPlayer.Character
        local localRoot = character and character:FindFirstChild("HumanoidRootPart")
        if not localRoot or not equipKnife(character) then
            task.wait(0.1)
            continue
        end
        local nearestPlayer = getNearestPlayer(maxDistance)
        if not nearestPlayer then
            if tick() - lastNotify >= 3 then
                Notify("Kill All", "No players within " .. maxDistance .. " studs", "x-circle", 2)
                lastNotify = tick()
            end
            task.wait(0.5)
            continue
        end
        attackPlayer(nearestPlayer, true)
        if tick() - lastNotify >= 3 then
            Notify("Kill All", "Attacking nearest players", "check-circle", 2)
            lastNotify = tick()
        end
        task.wait(attackDelay)
    end
end

-- Helper: Update Player Dropdown (Optimized)
local function updatePlayerList()
    local playersList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            table.insert(playersList, player.Name)
        end
    end
    return playersList
end

-- Murder Tab UI
Tabs.MurderTab:Section({Title = gradient("Kill Functions", Color3.fromHex("#e80909"), Color3.fromHex("#630404"))})

-- Kill Sheriff Button
Tabs.MurderTab:Button({
    Title = gradient("Kill Sheriff/Hero", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Callback = function()
        local sheriff = getSheriffOrHero()
        if sheriff then
            attackPlayer(sheriff, false)
        else
            Notify("Kill Sheriff", "No Sheriff or Hero found", "x-circle", 2)
        end
    end
})

-- Kill Specific Player
Tabs.MurderTab:Section({Title = gradient("Kill Player", Color3.fromHex("#e80909"), Color3.fromHex("#630404"))})

local playerDropdown
playerDropdown = Tabs.MurderTab:Dropdown({
    Title = gradient("Select Player", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Values = updatePlayerList(),
    Multi = false,
    AllowNone = true,
    Callback = function(selected)
        teleportTarget = selected and Players:FindFirstChild(selected) or nil
        if teleportTarget then
            Notify("Kill Player", "Selected " .. selected .. " as target", "check-circle", 1)
        end
    end
})

Tabs.MurderTab:Button({
    Title = gradient("Kill Selected Player", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Callback = function()
        if teleportTarget and IsAlive(teleportTarget) then
            attackPlayer(teleportTarget, false)
        else
            Notify("Kill Player", "No valid player selected or target is dead", "x-circle", 2)
        end
    end
})

Tabs.MurderTab:Button({
    Title = gradient("Refresh Player List", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Callback = function()
        playerDropdown:Refresh(updatePlayerList())
        Notify("Kill Player", "Player list refreshed", "check-circle", 1)
    end
})

-- Kill All
Tabs.MurderTab:Section({Title = gradient("Kill All", Color3.fromHex("#e80909"), Color3.fromHex("#630404"))})

Tabs.MurderTab:Toggle({
    Title = gradient("Enable Kill All", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Default = false,
    Callback = function(state)
        killAllActive = state
        if state then
            Notify("Kill All", "Kill All enabled! Targeting nearest players within " .. maxDistance .. " studs", "check-circle", 2)
            task.spawn(killAllLoop)
        else
            Notify("Kill All", "Kill All disabled", "x-circle", 2)
        end
    end
})

-- Utility
Tabs.MurderTab:Section({Title = gradient("Utility", Color3.fromHex("#e80909"), Color3.fromHex("#630404"))})

Tabs.MurderTab:Button({
    Title = gradient("Equip Knife", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Callback = function()
        if equipKnife(LocalPlayer.Character) then
            Notify("Knife", "Knife equipped!", "check-circle", 1)
        else
            Notify("Knife", "Failed to equip knife", "x-circle", 1)
        end
    end
})

-- Player Join/Leave Handlers for Dropdown
Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    if playerDropdown then
        playerDropdown:Refresh(updatePlayerList())
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if playerDropdown then
        playerDropdown:Refresh(updatePlayerList())
    end
    if player == teleportTarget then
        teleportTarget = nil
        Notify("Kill Player", player.Name .. " left, target reset", "x-circle", 1)
    end
end)

-- Sheriff Tab (Fixed Shot Button Dragging Issue, Preserving ShootMurderer)
local SheriffTab = Tabs.SheriffTab
local shotButton = nil
local shotButtonFrame = nil
local shotButtonActive = false
local shotType = "Default"
local buttonSize = 65

-- Helper: Equip Gun (Optimized)
local function EquipGun()
    local character = LocalPlayer.Character
    local gun = LocalPlayer.Backpack:FindFirstChild("Gun")
        gun.Parent = character
        task.wait(0.05) -- Minimal wait for equip
end

-- Helper: Shoot Murderer (Unchanged from your provided code)
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

-- Helper: Create Shot Button (Fixed Dragging)
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

    -- Animation (runs concurrently with shot)
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

    -- Dragging Logic (Fixed)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    shotButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = shotButtonFrame.Position -- Store initial position
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
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            -- Clamp position to keep button within screen bounds
            shotButtonFrame.Position = UDim2.new(
                0, math.clamp(newX, 0, guiSize.X - buttonSize),
                0, math.clamp(newY, 0, guiSize.Y - buttonSize)
            )
        end
    end)

    -- Immediate Shot on Activation
    shotButton.Activated:Connect(function()
        task.spawn(animatePress) -- Run animation concurrently
        ShootMurderer() -- Execute shot immediately
    end)

    shotButtonActive = true
end

-- Helper: Remove Shot Button
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

-- Sheriff Tab UI
Tabs.SheriffTab:Section({Title = gradient("Shot Functions", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9"))})

Tabs.SheriffTab:Dropdown({
    Title = gradient("Shot Type", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Values = {"Default", "Teleport"},
    Value = "Default",
    Callback = function(selectedType)
        shotType = selectedType
        Notify("Sheriff", "Shot type set to: " .. selectedType, "check-circle", 1)
    end
})

Tabs.SheriffTab:Button({
    Title = gradient("Shoot Murderer", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Callback = function()
        ShootMurderer()
    end
})

Tabs.SheriffTab:Section({Title = gradient("Shot Button", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9"))})

Tabs.SheriffTab:Slider({
    Title = gradient("Button Size", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
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
    Title = gradient("Enable Shot Button", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Default = false,
    Callback = function(state)
        if state then
            CreateShotButton()
            Notify("Sheriff", "Shot Button enabled!", "check-circle", 1)
        else
            RemoveShotButton()
            Notify("Sheriff", "Shot Button disabled", "x-circle", 1)
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
    ScriptURL = "https://raw.githubusercontent.com/Snowt-Team/SNT-HUB/refs/heads/main/MM2.lua"
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

-- Settings Tab (Updated with Configuration System)
local SettingsTab = Tabs.SettingsTab
local HttpService = game:GetService("HttpService")
local folderPath = "WindUI/Configs"
makefolder(folderPath)

-- Config Management
local ConfigManager = {
    CurrentConfigName = "File 1",
    SelectedConfig = "File 1",
    AutoLoad = false,
    Settings = {
        -- Example settings to save/load (extend as needed)
        TeleportOffset = Config.TeleportOffset or 3,
        DebounceTime = Config.DebounceTime or 0.5,
        -- Add other script settings here
    }
}

-- Helper: List Config Files
local function ListConfigFiles()
    local files = {}
    for _, file in ipairs(listfiles(folderPath)) do
        local fileName = file:match("([^/]+)%.json$")
        if fileName then
            table.insert(files, fileName)
        end
    end
    return files
end

-- Helper: Save Config
local function SaveConfig()
    if ConfigManager.CurrentConfigName == "" then
        Notify("Config", "Please enter a config name", "x-circle")
        return
    end
    local filePath = folderPath .. "/" .. ConfigManager.CurrentConfigName .. ".json"
    local success, err = pcall(function()
        writefile(filePath, HttpService:JSONEncode(ConfigManager.Settings))
    end)
    if success then
        Notify("Config", "Config '" .. ConfigManager.CurrentConfigName .. "' saved successfully!", "check-circle")
    else
        Notify("Config", "Failed to save config: " .. tostring(err), "x-circle")
    end
end

-- Helper: Load Config
local function LoadConfig(configName)
    local filePath = folderPath .. "/" .. configName .. ".json"
    if isfile(filePath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(filePath))
        end)
        if success then
            ConfigManager.Settings = data
            -- Apply loaded settings to script
            Config.TeleportOffset = ConfigManager.Settings.TeleportOffset
            Config.DebounceTime = ConfigManager.Settings.DebounceTime
            -- Apply other settings as needed
            Notify("Config", "Config '" .. configName .. "' loaded successfully!", "check-circle")
            return true
        else
            Notify("Config", "Failed to load config: Invalid file", "x-circle")
        end
    else
        Notify("Config", "Config file not found: " .. configName, "x-circle")
    end
    return false
end

-- Configuration Section
Tabs.SettingsTab:Section({
    Title = gradient("Script Configs", Color3.fromHex("#ffffff"), Color3.fromHex("#636363"))
})

local configDropdown
configDropdown = Tabs.SettingsTab:Dropdown({
    Title = gradient("Configs", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Values = ListConfigFiles(),
    Value = ConfigManager.SelectedConfig,
    Callback = function(option)
        ConfigManager.SelectedConfig = option
        Notify("Config", "Selected config: " .. option, "check-circle")
        if ConfigManager.AutoLoad then
            LoadConfig(option)
        end
    end
})

Tabs.SettingsTab:Input({
    Title = gradient("Config Name", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Value = ConfigManager.CurrentConfigName,
    InputIcon = "file-cog",
    Type = "Textarea",
    Placeholder = "Enter file name...",
    Callback = function(inp)
        ConfigManager.CurrentConfigName = inp
    end
})

Tabs.SettingsTab:Button({
    Title = gradient("Save File", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Callback = function()
        SaveConfig()
        configDropdown:Refresh(ListConfigFiles())
    end
})

Tabs.SettingsTab:Button({
    Title = gradient("Load Selected File", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Callback = function()
        if ConfigManager.SelectedConfig ~= "" then
            LoadConfig(ConfigManager.SelectedConfig)
        else
            Notify("Config", "No config selected", "x-circle")
        end
    end
})

Tabs.SettingsTab:Toggle({
    Title = gradient("Auto load selected config", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Default = ConfigManager.AutoLoad,
    Callback = function(state)
        ConfigManager.AutoLoad = state
        Notify("Config", "Auto load " .. (state and "enabled" or "disabled"), "check-circle")
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