-- WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Locals
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local CoreGui = game:GetService("CoreGui")

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

local Confirmed = false

WindUI:Popup({
    Title = gradient("SNT HUB", Color3.fromHex("#eb1010"), Color3.fromHex("#1023eb")),
    Icon = "info",
    Content = gradient("This script made by", Color3.fromHex("#10eb3c"), Color3.fromHex("#67c97a")) .. gradient(" SnowT", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Buttons = {
        {
            Title = gradient("Cancel", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
            Callback = function() end,
            Variant = "Tertiary", -- Primary, Secondary, Tertiary
        },
        {
            Title = gradient("Load", Color3.fromHex("#90f09e"), Color3.fromHex("#13ed34")),
            Callback = function() Confirmed = true end,
            Variant = "Secondary", -- Primary, Secondary, Tertiary
        }
    }
})

repeat task.wait() until Confirmed

WindUI:Notify({
    Title = gradient("SNT HUB", Color3.fromHex("#eb1010"), Color3.fromHex("#1023eb")),
    Content = "Скрипт успешно загружен!",
    Icon = "check-circle",
    Duration = 3,
})

-- Window
local Window = WindUI:CreateWindow({
    Title = gradient("SNT&MirrozzScript", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Icon = "infinity",
    Author = gradient("GaG Dupe", Color3.fromHex("#1bf2b2"), Color3.fromHex("#1bcbf2")),
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
    bee = Window:Divider(),
    DupeTab = Window:Tab({ Title = gradient("DUPE", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "cat" }),
    be = Window:Divider(),
    ServerTab = Window:Tab({ Title = gradient("SERVER", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "atom" }),
    SettingsTab = Window:Tab({ Title = gradient("SETTINGS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "code" }),
    ChangelogsTab = Window:Tab({ Title = gradient("CHANGELOGS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "info"}),
    SocialsTab = Window:Tab({ Title = gradient("SOCIALS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "star"}),
    b = Window:Divider(),
    WindowTab = Window:Tab({ Title = gradient("CONFIGURATION", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "settings", Desc = "Manage window settings and file configurations." }),
    CreateThemeTab = Window:Tab({ Title = gradient("THEMES", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "palette", Desc = "Design and apply custom themes." }),
}

-- Character
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local CharacterSettings = {
    WalkSpeed = {Value = 16, Default = 16, Locked = false},
    JumpPower = {Value = 50, Default = 50, Locked = false}
}

local function updateCharacter()
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
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

-- Teleport
Tabs.TeleportTab:Section({Title = gradient("Default TP", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))})

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

-- Вместо старого кода инициализации телепорта вызываем:
initializeTeleportDropdown()

-- Обновляем обработчики событий игроков:
Players.PlayerAdded:Connect(function(player)
    task.wait(1) -- Даем время на инициализацию игрока
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
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame
            WindUI:Notify({
                Title = "Телепортация",
                Content = "Успешно телепортирован к "..teleportTarget.Name,
                Icon = "check-circle",
                Duration = 3
            })
        end
    else
        WindUI:Notify({
            Title = "Ошибка",
            Content = "Цель не найдена или недоступна",
            Icon = "x-circle",
            Duration = 3
        })
    end
end

Tabs.TeleportTab:Button({
    Title = "Teleport to player",
    Callback = teleportToPlayer
})

Tabs.TeleportTab:Button({
    Title = "Update players list",
    Callback = function()
        teleportDropdown:Refresh(updateTeleportPlayers())
    end
})

Players.PlayerAdded:Connect(function()
    teleportDropdown:Refresh({updateTeleportPlayers()})
end)

Players.PlayerRemoving:Connect(function()
    teleportDropdown:Refresh({updateTeleportPlayers()})
end)

-- Dupe
local player = game:GetService("Players").LocalPlayer
local backpack = player:WaitForChild("Backpack") -- Ждем загрузки инвентаря
-- Dupe Tab
local selectedItem = "None"
local dupeAmount = 1

local function UpdateItemList()
    local items = {}
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") or item:IsA("HopperBin") then
            table.insert(items, item.Name)
        end
    end
    return items
end

-- Инициализация Dropdown
local dupeDropdown = Tabs.DupeTab:Dropdown({
    Title = "Select Item",
    Values = UpdateItemList(),
    Value = "None",
    Callback = function(option)
        selectedItem = option
    end
})

-- Input для количества
Tabs.DupeTab:Input({
    Title = "Item Amount",
    InputIcon = "mouse",
    Type = "Input",
    Placeholder = "1",
    Callback = function(input)
        dupeAmount = tonumber(input) or 1
    end
})

-- Кнопка обновления списка
Tabs.DupeTab:Button({
    Title = "Refresh Items",
    Callback = function()
        dupeDropdown:Refresh(UpdateItemList(), "None") -- Обновляем + сбрасываем выбор
    end
})

-- Кнопка дюпа
Tabs.DupeTab:Button({
    Title = "Dupe Item",
    Callback = function()
        if selectedItem == "None" then
            WindUI:Notify({
                Title = "Ошибка",
                Content = "Предмет не выбран!",
                Icon = "x-circle",
                Duration = 3
            })
            return
        end

        local original = backpack:FindFirstChild(selectedItem)
        if not original then
            WindUI:Notify({
                Title = "Ошибка",
                Content = "Предмет не найден!",
                Icon = "x-circle",
                Duration = 3
            })
            return
        end

        for i = 1, dupeAmount do
            local clone = original:Clone()
            clone.Parent = backpack
            task.wait(0.05) -- Задержка для стабильности
        end

        WindUI:Notify({
            Title = "Успех",
            Content = string.format("Создано копий: %d", dupeAmount),
            Icon = "check-circle",
            Duration = 3
        })
    end
})
