local SnowtUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SnowtUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(32, 30, 38)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(64, 61, 76)
UIStroke.Thickness = 1
UIStroke.Transparency = 0.5
UIStroke.Parent = MainFrame

-- Navigation Panel
local NavPanel = Instance.new("Frame")
NavPanel.Size = UDim2.new(0, 200, 1, 0)
NavPanel.BackgroundColor3 = Color3.fromRGB(28, 26, 34)
NavPanel.BackgroundTransparency = 0.2
NavPanel.BorderSizePixel = 0
NavPanel.Parent = MainFrame

local NavList = Instance.new("UIListLayout")
NavList.FillDirection = Enum.FillDirection.Vertical
NavList.Padding = UDim.new(0, 5)
NavList.Parent = NavPanel

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -200, 1, 0)
ContentFrame.Position = UDim2.new(0, 200, 0, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ContentCanvas = Instance.new("ScrollingFrame")
ContentCanvas.Size = UDim2.new(1, -10, 1, -10)
ContentCanvas.Position = UDim2.new(0, 5, 0, 5)
ContentCanvas.BackgroundTransparency = 1
ContentCanvas.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentCanvas.ScrollBarThickness = 4
ContentCanvas.Parent = ContentFrame

local ContentList = Instance.new("UIListLayout")
ContentList.FillDirection = Enum.FillDirection.Vertical
ContentList.Padding = UDim.new(0, 10)
ContentList.Parent = ContentCanvas

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 26, 34)
TopBar.BackgroundTransparency = 0.2
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "SnowtUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.TextSize = 16
CloseButton.Parent = TopBar

-- Notification Container
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Size = UDim2.new(0, 300, 1, 0)
NotificationContainer.Position = UDim2.new(1, -310, 0, 10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local NotificationList = Instance.new("UIListLayout")
NotificationList.FillDirection = Enum.FillDirection.Vertical
NotificationList.Padding = UDim.new(0, 10)
NotificationList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationList.Parent = NotificationContainer

-- Mobile Support Button
local MobileButton = Instance.new("TextButton")
MobileButton.Size = UDim2.new(0, 50, 0, 50)
MobileButton.Position = UDim2.new(0, 10, 1, -60)
MobileButton.BackgroundColor3 = Color3.fromRGB(32, 30, 38)
MobileButton.Text = "UI"
MobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileButton.Font = Enum.Font.SourceSans
MobileButton.TextSize = 16
MobileButton.Parent = ScreenGui
MobileButton.Visible = not UserInputService.KeyboardEnabled

local MobileCorner = Instance.new("UICorner")
MobileCorner.CornerRadius = UDim.new(0, 8)
MobileCorner.Parent = MobileButton

-- Theme
local Theme = {
    Gradient = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(117, 164, 206)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(123, 201, 201)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(224, 138, 175))
    },
    Options = {}
}

-- Config
local ConfigFolder = "SnowtUI"
local isStudio = RunService:IsStudio()

-- Tween Helper
local function Tween(obj, props, duration, style, direction)
    duration = duration or 0.4
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tween = TweenService:Create(obj, TweenInfo.new(duration, style, direction), props)
    tween:Play()
    return tween
end

-- Safe Callback
local function SafeCallback(callback, param)
    local success, response = pcall(callback, param)
    if not success then
        SnowtUI:Notify({
            Title = "Error",
            Content = "Callback error: " .. tostring(response),
            Icon = "error"
        })
    end
end

-- Create Window
function SnowtUI:CreateWindow(settings)
    local window = {
        Tabs = {},
        CurrentTab = nil,
        State = false,
        Bind = settings.Bind or Enum.KeyCode.RightShift,
        ConfigSettings = settings.ConfigSettings or { ConfigFolder = ConfigFolder }
    }

    Title.Text = settings.Name or "SnowtUI"
    MainFrame.Visible = false

    -- Toggle Window
    local function toggle()
        window.State = not window.State
        if window.State then
            Tween(MainFrame, { BackgroundTransparency = 0.1 })
            MainFrame.Visible = true
            MobileButton.Visible = false
        else
            Tween(MainFrame, { BackgroundTransparency = 1 })
            task.wait(0.4)
            MainFrame.Visible = false
            if not UserInputService.KeyboardEnabled then
                MobileButton.Visible = true
            end
        end
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == window.Bind then
            toggle()
        end
    end)

    CloseButton.MouseButton1Click:Connect(toggle)
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, { TextColor3 = Color3.fromRGB(255, 255, 255) })
    end)
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, { TextColor3 = Color3.fromRGB(200, 200, 200) })
    end)

    MobileButton.MouseButton1Click:Connect(toggle)

    -- Setup Config Folder
    if not isStudio then
        local folder = window.ConfigSettings.ConfigFolder
        if not isfolder(folder) then
            makefolder(folder)
        end
        if not isfolder(folder .. "/settings") then
            makefolder(folder .. "/settings")
        end
    end

    return window
end

-- Create Tab
function SnowtUI:CreateTab(settings)
    local tab = {
        Name = settings.Name or "Tab",
        Icon = settings.Icon or "home",
        Content = Instance.new("Frame"),
        Button = Instance.new("TextButton")
    }

    -- Tab Button
    tab.Button.Size = UDim2.new(1, -10, 0, 40)
    tab.Button.Position = UDim2.new(0, 5, 0, 0)
    tab.Button.BackgroundColor3 = Color3.fromRGB(40, 38, 46)
    tab.Button.BackgroundTransparency = 0.8
    tab.Button.Text = "  " .. tab.Name
    tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    tab.Button.TextXAlignment = Enum.TextXAlignment.Left
    tab.Button.Font = Enum.Font.SourceSans
    tab.Button.TextSize = 16
    tab.Button.Parent = NavPanel

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tab.Button

    -- Tab Content
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.Visible = false
    tab.Content.Parent = ContentCanvas

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Vertical
    tabList.Padding = UDim.new(0, 10)
    tabList.Parent = tab.Content

    function tab:Activate()
        if SnowtUI.CurrentTab then
            SnowtUI.CurrentTab.Content.Visible = false
            Tween(SnowtUI.CurrentTab.Button, { BackgroundTransparency = 0.8 })
        end
        SnowtUI.CurrentTab = tab
        tab.Content.Visible = true
        Tween(tab.Button, { BackgroundTransparency = 0.2 })
    end

    tab.Button.MouseButton1Click:Connect(tab:Activate)
    table.insert(SnowtUI.Tabs, tab)

    if not SnowtUI.CurrentTab then
        tab:Activate()
    end

    -- Create Button
    function tab:CreateButton(settings)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 40)
        button.BackgroundColor3 = Color3.fromRGB(40, 38, 46)
        button.BackgroundTransparency = 0.5
        button.Text = settings.Name or "Button"
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.Font = Enum.Font.SourceSans
        button.TextSize = 16
        button.Parent = tab.Content

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button

        button.MouseEnter:Connect(function()
            Tween(button, { BackgroundTransparency = 0.2 })
        end)

        button.MouseLeave:Connect(function()
            Tween(button, { BackgroundTransparency = 0.5 })
        end)

        button.MouseButton1Click:Connect(function()
            if settings.Callback then
                SafeCallback(settings.Callback)
            end
        end)

        ContentCanvas.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y)
    end

    -- Create Toggle
    function tab:CreateToggle(settings, flag)
        local toggle = { Class = "Toggle", Settings = settings or {}, CurrentValue = settings.CurrentValue or false }
        Theme.Options[flag] = toggle

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 40)
        frame.BackgroundTransparency = 1
        frame.Parent = tab.Content

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.8, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = settings.Name or "Toggle"
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 30, 0, 20)
        toggleButton.Position = UDim2.new(1, -30, 0.5, -10)
        toggleButton.BackgroundColor3 = toggle.CurrentValue and Color3.fromRGB(117, 164, 206) or Color3.fromRGB(64, 61, 76)
        toggleButton.Text = ""
        toggleButton.Parent = frame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = toggleButton

        function toggle:Set(newSettings)
            toggle.CurrentValue = newSettings.CurrentValue or toggle.CurrentValue
            Tween(toggleButton, { BackgroundColor3 = toggle.CurrentValue and Color3.fromRGB(117, 164, 206) or Color3.fromRGB(64, 61, 76) })
            if settings.Callback then
                SafeCallback(settings.Callback, toggle.CurrentValue)
            end
        end

        toggleButton.MouseButton1Click:Connect(function()
            toggle.CurrentValue = not toggle.CurrentValue
            toggle:Set({ CurrentValue = toggle.CurrentValue })
        end)

        ContentCanvas.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y)
        return toggle
    end

    -- Create Slider
    function tab:CreateSlider(settings, flag)
        local slider = { Class = "Slider", Settings = settings or {}, CurrentValue = settings.CurrentValue or settings.Range[1] }
        Theme.Options[flag] = slider

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 60)
        frame.BackgroundTransparency = 1
        frame.Parent = tab.Content

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = settings.Name or "Slider"
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(1, 0, 0, 10)
        sliderBar.Position = UDim2.new(0, 0, 0, 30)
        sliderBar.BackgroundColor3 = Color3.fromRGB(64, 61, 76)
        sliderBar.Parent = frame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = sliderBar

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(117, 164, 206)
        fill.Parent = sliderBar

        local cornerFill = Instance.new("UICorner")
        cornerFill.CornerRadius = UDim.new(0, 5)
        cornerFill.Parent = fill

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Position = UDim2.new(1, -50, 0, 10)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(slider.CurrentValue)
        valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        valueLabel.Font = Enum.Font.SourceSans
        valueLabel.TextSize = 14
        valueLabel.Parent = frame

        local dragging = false

        function slider:Set(newSettings)
            slider.CurrentValue = math.clamp(newSettings.CurrentValue or slider.CurrentValue, settings.Range[1], settings.Range[2])
            local percent = (slider.CurrentValue - settings.Range[1]) / (settings.Range[2] - settings.Range[1])
            Tween(fill, { Size = UDim2.new(percent, 0, 1, 0) })
            valueLabel.Text = string.format("%.1f", slider.CurrentValue)
            if settings.Callback then
                SafeCallback(settings.Callback, slider.CurrentValue)
            end
        end

        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        sliderBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        RunService.RenderStepped:Connect(function()
            if dragging then
                local mouse = UserInputService:GetMouseLocation()
                local relativeX = math.clamp(mouse.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
                local percent = relativeX / sliderBar.AbsoluteSize.X
                local value = settings.Range[1] + (percent * (settings.Range[2] - settings.Range[1]))
                value = math.floor(value / settings.Increment + 0.5) * settings.Increment
                slider:Set({ CurrentValue = value })
            end
        end)

        slider:Set({ CurrentValue = slider.CurrentValue })
        ContentCanvas.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y)
        return slider
    end

    -- Create Color Picker
    function tab:CreateColorPicker(settings, flag)
        local colorPicker = { Class = "Colorpicker", Settings = settings or {}, Color = settings.Color or Color3.fromRGB(255, 255, 255) }
        Theme.Options[flag] = colorPicker

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 150)
        frame.BackgroundColor3 = Color3.fromRGB(40, 38, 46)
        frame.BackgroundTransparency = 0.5
        frame.Parent = tab.Content

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 20)
        label.Position = UDim2.new(0, 5, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = settings.Name or "Color Picker"
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local preview = Instance.new("Frame")
        preview.Size = UDim2.new(0, 30, 0, 30)
        preview.Position = UDim2.new(1, -40, 0, 30)
        preview.BackgroundColor3 = colorPicker.Color
        preview.Parent = frame

        local cornerPreview = Instance.new("UICorner")
        cornerPreview.CornerRadius = UDim.new(0, 6)
        cornerPreview.Parent = preview

        local colorArea = Instance.new("ImageLabel")
        colorArea.Size = UDim2.new(0, 100, 0, 100)
        colorArea.Position = UDim2.new(0, 10, 0, 40)
        colorArea.Image = "http://www.roblox.com/asset/?id=11415645739"
        colorArea.Parent = frame

        local hueSlider = Instance.new("Frame")
        hueSlider.Size = UDim2.new(0, 100, 0, 10)
        hueSlider.Position = UDim2.new(0, 120, 0, 40)
        hueSlider.BackgroundColor3 = Color3.fromRGB(64, 61, 76)
        hueSlider.Parent = frame

        local hueFill = Instance.new("Frame")
        hueFill.Size = UDim2.new(0, 0, 1, 0)
        hueFill.BackgroundColor3 = Color3.fromRGB(117, 164, 206)
        hueFill.Parent = hueSlider

        local cornerHue = Instance.new("UICorner")
        cornerHue.CornerRadius = UDim.new(0, 5)
        cornerHue.Parent = hueSlider

        local cornerHueFill = Instance.new("UICorner")
        cornerHueFill.CornerRadius = UDim.new(0, 5)
        cornerHueFill.Parent = hueFill

        local h, s, v = colorPicker.Color:ToHSV()

        function colorPicker:Set(newSettings)
            colorPicker.Color = newSettings.Color or colorPicker.Color
            h, s, v = colorPicker.Color:ToHSV()
            local percentS = s
            local percentV = 1 - v
            Tween(preview, { BackgroundColor3 = colorPicker.Color })
            Tween(colorArea, { ImageColor3 = Color3.fromHSV(h, 1, 1) })
            Tween(hueFill, { Size = UDim2.new(h, 0, 1, 0) })
            if settings.Callback then
                SafeCallback(settings.Callback, colorPicker.Color)
            end
        end

        local colorDragging = false
        local hueDragging = false

        colorArea.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                colorDragging = true
            end
        end)

        colorArea.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                colorDragging = false
            end
        end)

        hueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                hueDragging = true
            end
        end)

        hueSlider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                hueDragging = false
            end
        end)

        RunService.RenderStepped:Connect(function()
            if colorDragging then
                local mouse = UserInputService:GetMouseLocation()
                local relativeX = math.clamp(mouse.X - colorArea.AbsolutePosition.X, 0, colorArea.AbsoluteSize.X)
                local relativeY = math.clamp(mouse.Y - colorArea.AbsolutePosition.Y, 0, colorArea.AbsoluteSize.Y)
                s = relativeX / colorArea.AbsoluteSize.X
                v = 1 - (relativeY / colorArea.AbsoluteSize.Y)
                colorPicker:Set({ Color = Color3.fromHSV(h, s, v) })
            end
            if hueDragging then
                local mouse = UserInputService:GetMouseLocation()
                local relativeX = math.clamp(mouse.X - hueSlider.AbsolutePosition.X, 0, hueSlider.AbsoluteSize.X)
                h = relativeX / hueSlider.AbsoluteSize.X
                colorPicker:Set({ Color = Color3.fromHSV(h, s, v) })
            end
        end)

        colorPicker:Set({ Color = colorPicker.Color })
        ContentCanvas.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y)
        return colorPicker
    end

    -- Create Dropdown
    function tab:CreateDropdown(settings, flag)
        local dropdown = { Class = "Dropdown", Settings = settings or {}, CurrentValue = settings.CurrentValue or settings.Options[1], Open = false }
        Theme.Options[flag] = dropdown

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 40)
        frame.BackgroundTransparency = 1
        frame.Parent = tab.Content

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = Color3.fromRGB(40, 38, 46)
        button.BackgroundTransparency = 0.5
        button.Text = settings.Name .. ": " .. tostring(dropdown.CurrentValue)
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.Font = Enum.Font.SourceSans
        button.TextSize = 16
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.Parent = frame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button

        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
        dropdownFrame.Position = UDim2.new(0, 0, 0, 45)
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 38, 46)
        dropdownFrame.BackgroundTransparency = 0.5
        dropdownFrame.Visible = false
        dropdownFrame.ClipsDescendants = true
        dropdownFrame.Parent = frame

        local dropdownCorner = Instance.new("UICorner")
        dropdownCorner.CornerRadius = UDim.new(0, 6)
        dropdownCorner.Parent = dropdownFrame

        local dropdownList = Instance.new("UIListLayout")
        dropdownList.FillDirection = Enum.FillDirection.Vertical
        dropdownList.Padding = UDim.new(0, 5)
        dropdownList.Parent = dropdownFrame

        local options = {}

        function dropdown:Set(newSettings)
            dropdown.CurrentValue = newSettings.CurrentValue or dropdown.CurrentValue
            button.Text = settings.Name .. ": " .. tostring(dropdown.CurrentValue)
            if settings.Callback then
                SafeCallback(settings.Callback, dropdown.CurrentValue)
            end
        end

        function dropdown:Toggle()
            dropdown.Open = not dropdown.Open
            dropdownFrame.Visible = dropdown.Open
            Tween(dropdownFrame, { Size = dropdown.Open and UDim2.new(1, 0, 0, #settings.Options * 30 + (#settings.Options - 1) * 5) or UDim2.new(1, 0, 0, 0) })
        end

        for _, option in ipairs(settings.Options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, -10, 0, 30)
            optionButton.Position = UDim2.new(0, 5, 0, 0)
            optionButton.BackgroundColor3 = Color3.fromRGB(50, 48, 56)
            optionButton.BackgroundTransparency = 0.5
            optionButton.Text = tostring(option)
            optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            optionButton.Font = Enum.Font.SourceSans
            optionButton.TextSize = 14
            optionButton.Parent = dropdownFrame

            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 4)
            optionCorner.Parent = optionButton

            optionButton.MouseEnter:Connect(function()
                Tween(optionButton, { BackgroundTransparency = 0.2 })
            end)

            optionButton.MouseLeave:Connect(function()
                Tween(optionButton, { BackgroundTransparency = 0.5 })
            end)

            optionButton.MouseButton1Click:Connect(function()
                dropdown:Set({ CurrentValue = option })
                dropdown:Toggle()
            end)

            table.insert(options, optionButton)
        end

        button.MouseButton1Click:Connect(function()
            dropdown:Toggle()
        end)

        dropdown:Set({ CurrentValue = dropdown.CurrentValue })
        ContentCanvas.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y)
        return dropdown
    end

    return tab
end

-- Notify
function SnowtUI:Notify(settings)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(1, 0, 0, 80)
    notification.BackgroundColor3 = Color3.fromRGB(32, 30, 38)
    notification.BackgroundTransparency = 1
    notification.Parent = NotificationContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = notification

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 0, 20)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = settings.Title or "Notification"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notification

    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -10, 0, 50)
    content.Position = UDim2.new(0, 5, 0, 25)
    content.BackgroundTransparency = 1
    content.Text = settings.Content or ""
    content.TextColor3 = Color3.fromRGB(200, 200, 200)
    content.Font = Enum.Font.SourceSans
    content.TextSize = 14
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextWrapped = true
    content.Parent = notification

    Tween(notification, { BackgroundTransparency = 0.1 }, 0.4)
    task.wait(settings.Duration or 5)
    Tween(notification, { BackgroundTransparency = 1 }, 0.4)
    task.wait(0.4)
    notification:Destroy()
end

-- Save Config
function SnowtUI:SaveConfig(path)
    if isStudio then return false, "Config system unavailable in Studio" end
    if not path then return false, "Please select a config file" end

    local fullPath = ConfigFolder .. "/settings/" .. path .. ".json"
    local data = { objects = {} }

    for flag, option in pairs(Theme.Options) do
        if option.Class == "Toggle" then
            table.insert(data.objects, { type = "Toggle", flag = flag, state = option.CurrentValue })
        elseif option.Class == "Slider" then
            table.insert(data.objects, { type = "Slider", flag = flag, value = option.CurrentValue })
        elseif option.Class == "Colorpicker" then
            local function Color3ToHex(color)
                return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
            end
            table.insert(data.objects, { type = "Colorpicker", flag = flag, color = Color3ToHex(option.Color) })
        elseif option.Class == "Dropdown" then
            table.insert(data.objects, { type = "Dropdown", flag = flag, value = option.CurrentValue })
        end
    end

    local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
    if not success then return false, "Unable to encode JSON" end

    writefile(fullPath, encoded)
    return true
end

-- Load Config
function SnowtUI:LoadConfig(path)
    if isStudio then return false, "Config system unavailable in Studio" end
    if not path then return false, "Please select a config file" end

    local file = ConfigFolder .. "/settings/" .. path .. ".json"
    if not isfile(file) then return false, "Invalid file" end

    local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
    if not success then return false, "Unable to decode JSON" end

    for _, option in ipairs(decoded.objects) do
        if option.type == "Toggle" and Theme.Options[option.flag] then
            Theme.Options[option.flag]:Set({ CurrentValue = option.state })
        elseif option.type == "Slider" and Theme.Options[option.flag] then
            Theme.Options[option.flag]:Set({ CurrentValue = option.value })
        elseif option.type == "Colorpicker" and Theme.Options[option.flag] then
            local function HexToColor3(hex)
                local r = tonumber(hex:sub(2, 3), 16) / 255
                local g = tonumber(hex:sub(4, 5), 16) / 255
                local b = tonumber(hex:sub(6, 7), 16) / 255
                return Color3.new(r, g, b)
            end
            Theme.Options[option.flag]:Set({ Color = HexToColor3(option.color) })
        elseif option.type == "Dropdown" and Theme.Options[option.flag] then
            Theme.Options[option.flag]:Set({ CurrentValue = option.value })
        end
    end

    return true
end

return SnowtUI