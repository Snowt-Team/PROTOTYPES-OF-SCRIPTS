-- SnowtUI: A Modern Roblox UI Library
-- Version: 1.2
-- Features: Modern design, mobile support, key system, theme switching, enhanced loading screen, window system, and new UI elements

local SnowtUI = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Core UI Setup
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SnowtUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Improved Loading Screen
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Size = UDim2.new(0, 150, 0, 90)
    LoadingFrame.Position = UDim2.new(0.5, -75, 0.5, -45)
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LoadingFrame.Parent = ScreenGui
    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 10)
    LoadingCorner.Parent = LoadingFrame
    local LoadingGradient = Instance.new("UIGradient")
    LoadingGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
    })
    LoadingGradient.Parent = LoadingFrame

    local LoadingText = Instance.new("TextLabel")
    LoadingText.Size = UDim2.new(0.8, 0, 0.3, 0)
    LoadingText.Position = UDim2.new(0.1, 0, 0.1, 0)
    LoadingText.Text = "Loading Script..."
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.TextScaled = true
    LoadingText.BackgroundTransparency = 1
    LoadingText.Font = Enum.Font.SourceSansBold
    LoadingText.Parent = LoadingFrame

    local ProgressBarFrame = Instance.new("Frame")
    ProgressBarFrame.Size = UDim2.new(0.8, 0, 0.15, 0)
    ProgressBarFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
    ProgressBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ProgressBarFrame.Parent = LoadingFrame
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 5)
    ProgressCorner.Parent = ProgressBarFrame

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    ProgressBar.Parent = ProgressBarFrame
    local ProgressGradient = Instance.new("UIGradient")
    ProgressGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 150, 255))
    })
    ProgressGradient.Parent = ProgressBar
    local ProgressBarCorner = Instance.new("UICorner")
    ProgressBarCorner.CornerRadius = UDim.new(0, 5)
    ProgressBarCorner.Parent = ProgressBar

    local PercentageText = Instance.new("TextLabel")
    PercentageText.Size = UDim2.new(0.8, 0, 0.2, 0)
    PercentageText.Position = UDim2.new(0.1, 0, 0.7, 0)
    PercentageText.Text = "0%"
    PercentageText.TextColor3 = Color3.fromRGB(255, 255, 255)
    PercentageText.TextScaled = true
    PercentageText.BackgroundTransparency = 1
    PercentageText.Font = Enum.Font.SourceSans
    PercentageText.Parent = LoadingFrame

    -- Pulse Animation for Loading Text
    local pulseTween = TweenService:Create(LoadingText, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {TextTransparency = 0.3})
    pulseTween:Play()

    -- Animate Loading
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(ProgressBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    local startTime = tick()
    tween:Play()
    RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.clamp(elapsed / 2, 0, 1)
        PercentageText.Text = math.floor(progress * 100) .. "%"
        if progress >= 1 then
            pulseTween:Cancel()
        end
    end)
    tween.Completed:Wait()
    LoadingFrame:Destroy()

    -- Main UI Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.6, 0, 0.7, 0)
    MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame
    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
    })
    MainGradient.Parent = MainFrame

    -- Shadow Effect
    local Shadow = Instance.new("Frame")
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.7
    Shadow.Parent = MainFrame
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 15)
    ShadowCorner.Parent = Shadow
    Shadow.ZIndex = MainFrame.ZIndex - 1

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0.2, 0, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.Parent = MainFrame
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 15)
    SidebarCorner.Parent = Sidebar

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.Parent = Sidebar

    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Size = UDim2.new(1, 0, 0.8, 0)
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 2, 0)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.Parent = Sidebar

    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(0.8, 0, 1, 0)
    ContentFrame.Position = UDim2.new(0.2, 0, 0, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0.1, 0)
    Header.BackgroundTransparency = 1
    Header.Parent = ContentFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.5, 0, 0.5, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Text = "SnowtUI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Font = Enum.Font.SourceSansBold
    Title.BackgroundTransparency = 1
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0.5, 0, 0.3, 0)
    Subtitle.Position = UDim2.new(0, 10, 0.5, 0)
    Subtitle.Text = "Modern Roblox UI Library"
    Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    Subtitle.TextScaled = true
    Subtitle.Font = Enum.Font.SourceSans
    Subtitle.BackgroundTransparency = 1
    Subtitle.Parent = Header

    -- Control Buttons
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0.05, 0, 0.05, 0)
    MinimizeButton.Position = UDim2.new(0.85, 0, 0.025, 0)
    MinimizeButton.Text = "-"
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Parent = Header
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.Parent = MinimizeButton

    local MaximizeButton = Instance.new("TextButton")
    MaximizeButton.Size = UDim2.new(0.05, 0, 0.05, 0)
    MaximizeButton.Position = UDim2.new(0.9, 0, 0.025, 0)
    MaximizeButton.Text = "□"
    MaximizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
    MaximizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MaximizeButton.Parent = Header
    local MaximizeCorner = Instance.new("UICorner")
    MaximizeCorner.Parent = MaximizeButton

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0.05, 0, 0.05, 0)
    CloseButton.Position = UDim2.new(0.95, 0, 0.025, 0)
    CloseButton.Text = "X"
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Parent = Header
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.Parent = CloseButton

    -- Search Bar
    local SearchBar = Instance.new("TextBox")
    SearchBar.Size = UDim2.new(0.3, 0, 0.05, 0)
    SearchBar.Position = UDim2.new(0.65, 0, 0.55, 0)
    SearchBar.PlaceholderText = "Search functions..."
    SearchBar.Text = ""
    SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBar.Parent = Header
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.Parent = SearchBar

    -- Bottom Info
    local BottomFrame = Instance.new("Frame")
    BottomFrame.Size = UDim2.new(0.2, 0, 0.1, 0)
    BottomFrame.Position = UDim2.new(0, 0, 0.9, 0)
    BottomFrame.BackgroundTransparency = 1
    BottomFrame.Parent = Sidebar

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Size = UDim2.new(1, 0, 0.5, 0)
    TimerLabel.Text = "Time: 0s"
    TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TimerLabel.TextScaled = true
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Parent = BottomFrame

    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Size = UDim2.new(1, 0, 0.5, 0)
    PlayerLabel.Position = UDim2.new(0, 0, 0.5, 0)
    PlayerLabel.Text = "Player: " .. Players.LocalPlayer.Name
    PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerLabel.TextScaled = true
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Parent = BottomFrame

    -- Key System Frame
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0.3, 0, 0.3, 0)
    KeyFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    KeyFrame.Parent = ScreenGui
    KeyFrame.Visible = true
    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 15)
    KeyCorner.Parent = KeyFrame
    local KeyGradient = Instance.new("UIGradient")
    KeyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
    })
    KeyGradient.Parent = KeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.8, 0, 0.2, 0)
    KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    KeyInput.PlaceholderText = "Enter Key..."
    KeyInput.Text = ""
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Parent = KeyFrame
    local KeyInputCorner = Instance.new("UICorner")
    KeyInputCorner.Parent = KeyInput

    local KeyButton = Instance.new("TextButton")
    KeyButton.Size = UDim2.new(0.3, 0, 0.1, 0)
    KeyButton.Position = UDim2.new(0.35, 0, 0.7, 0)
    KeyButton.Text = "Submit"
    KeyButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyButton.Parent = KeyFrame
    local KeyButtonCorner = Instance.new("UICorner")
    KeyButtonCorner.Parent = KeyButton

    -- Theme Toggle
    local ThemeButton = Instance.new("TextButton")
    ThemeButton.Size = UDim2.new(0.1, 0, 0.05, 0)
    ThemeButton.Position = UDim2.new(0.65, 0, 0.025, 0)
    ThemeButton.Text = "Toggle Theme"
    ThemeButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    ThemeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ThemeButton.Parent = Header
    local ThemeButtonCorner = Instance.new("UICorner")
    ThemeButtonCorner.Parent = ThemeButton

    -- Variables
    local startTime = os.time()
    local isMinimized = false
    local isMaximized = false
    local currentTheme = "Dark"
    local tabs = {}
    local contentFrames = {}
    local windows = {}

    -- Theme Switching
    local function applyTheme(theme)
        if theme == "Light" then
            MainFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            MainGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
            })
            Sidebar.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            Title.TextColor3 = Color3.fromRGB(0, 0, 0)
            Subtitle.TextColor3 = Color3.fromRGB(50, 50, 50)
            KeyFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            KeyGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
            })
            for _, window in pairs(windows) do
                window.Frame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                window.Gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
                })
            end
        else
            MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            MainGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
            })
            Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
            KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            KeyGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
            })
            for _, window in pairs(windows) do
                window.Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                window.Gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                })
            end
        end
    end

    ThemeButton.MouseButton1Click:Connect(function()
        currentTheme = currentTheme == "Dark" and "Light" or "Dark"
        applyTheme(currentTheme)
    end)

    -- Timer Update
    RunService.Heartbeat:Connect(function()
        TimerLabel.Text = "Time: " .. (os.time() - startTime) .. "s"
    end)

    -- Key System Logic
    local correctKey = "SnowtUI123" -- Replace with actual key system logic
    KeyButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == correctKey then
            KeyFrame.Visible = false
            MainFrame.Visible = true
            local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 0})
            tween:Play()
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Invalid Key!"
        end
    end)

    -- Window Controls
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        MainFrame.Size = isMinimized and UDim2.new(0.3, 0, 0.1, 0) or (isMaximized and UDim2.new(0.8, 0, 0.9, 0) or UDim2.new(0.6, 0, 0.7, 0))
        ContentFrame.Visible = not isMinimized
        Sidebar.Visible = not isMinimized
    end)

    MaximizeButton.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        if not isMinimized then
            MainFrame.Size = isMaximized and UDim2.new(0.8, 0, 0.9, 0) or UDim2.new(0.6, 0, 0.7, 0)
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Wait()
        ScreenGui:Destroy()
    end)

    -- Dragging and Resizing for MainFrame
    local dragging, dragStart, startPos, resizing, resizeStart
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    local function updateResize(input)
        local delta = input.Position - resizeStart
        MainFrame.Size = UDim2.new(0, math.max(200, startPos.X.Offset + delta.X), 0, math.max(150, startPos.Y.Offset + delta.Y))
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local size = MainFrame.AbsoluteSize
            local pos2 = MainFrame.AbsolutePosition
            if pos.X > pos2.X + size.X - 20 and pos.Y > pos2.Y + size.Y - 20 then
                resizing = true
                resizeStart = input.Position
                startPos = MainFrame.Size
            end
        end
    end)

    MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        elseif resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateResize(input)
        end
    end)

    -- Window System
    function SnowtUI:CreateWindow(name, size, position)
        local WindowFrame = Instance.new("Frame")
        WindowFrame.Size = size or UDim2.new(0.3, 0, 0.4, 0)
        WindowFrame.Position = position or UDim2.new(0.3, 0, 0.3, 0)
        WindowFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        WindowFrame.BackgroundTransparency = 1
        WindowFrame.Parent = ScreenGui
        local WindowCorner = Instance.new("UICorner")
        WindowCorner.CornerRadius = UDim.new(0, 10)
        WindowCorner.Parent = WindowFrame
        local WindowGradient = Instance.new("UIGradient")
        WindowGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
        })
        WindowGradient.Parent = WindowFrame

        local WindowShadow = Instance.new("Frame")
        WindowShadow.Size = UDim2.new(1, 10, 1, 10)
        WindowShadow.Position = UDim2.new(0, -5, 0, -5)
        WindowShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        WindowShadow.BackgroundTransparency = 0.7
        WindowShadow.Parent = WindowFrame
        local WindowShadowCorner = Instance.new("UICorner")
        WindowShadowCorner.CornerRadius = UDim.new(0, 10)
        WindowShadowCorner.Parent = WindowShadow
        WindowShadow.ZIndex = WindowFrame.ZIndex - 1

        local WindowHeader = Instance.new("Frame")
        WindowHeader.Size = UDim2.new(1, 0, 0.15, 0)
        WindowHeader.BackgroundTransparency = 1
        WindowHeader.Parent = WindowFrame

        local WindowTitle = Instance.new("TextLabel")
        WindowTitle.Size = UDim2.new(0.6, 0, 0.8, 0)
        WindowTitle.Position = UDim2.new(0, 10, 0.1, 0)
        WindowTitle.Text = name
        WindowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        WindowTitle.TextScaled = true
        WindowTitle.Font = Enum.Font.SourceSansBold
        WindowTitle.BackgroundTransparency = 1
        WindowTitle.Parent = WindowHeader

        local WindowMinimize = Instance.new("TextButton")
        WindowMinimize.Size = UDim2.new(0.08, 0, 0.5, 0)
        WindowMinimize.Position = UDim2.new(0.76, 0, 0.25, 0)
        WindowMinimize.Text = "-"
        WindowMinimize.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        WindowMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
        WindowMinimize.Parent = WindowHeader
        local WindowMinimizeCorner = Instance.new("UICorner")
        WindowMinimizeCorner.Parent = WindowMinimize

        local WindowMaximize = Instance.new("TextButton")
        WindowMaximize.Size = UDim2.new(0.08, 0, 0.5, 0)
        WindowMaximize.Position = UDim2.new(0.84, 0, 0.25, 0)
        WindowMaximize.Text = "□"
        WindowMaximize.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
        WindowMaximize.TextColor3 = Color3.fromRGB(255, 255, 255)
        WindowMaximize.Parent = WindowHeader
        local WindowMaximizeCorner = Instance.new("UICorner")
        WindowMaximizeCorner.Parent = WindowMaximize

        local WindowClose = Instance.new("TextButton")
        WindowClose.Size = UDim2.new(0.08, 0, 0.5, 0)
        WindowClose.Position = UDim2.new(0.92, 0, 0.25, 0)
        WindowClose.Text = "X"
        WindowClose.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        WindowClose.TextColor3 = Color3.fromRGB(255, 255, 255)
        WindowClose.Parent = WindowHeader
        local WindowCloseCorner = Instance.new("UICorner")
        WindowCloseCorner.Parent = WindowClose

        local WindowContent = Instance.new("Frame")
        WindowContent.Size = UDim2.new(1, 0, 0.85, 0)
        WindowContent.Position = UDim2.new(0, 0, 0.15, 0)
        WindowContent.BackgroundTransparency = 1
        WindowContent.Parent = WindowFrame

        local WindowList = Instance.new("UIListLayout")
        WindowList.Padding = UDim.new(0, 5)
        WindowList.Parent = WindowContent

        local isWindowMinimized = false
        local isWindowMaximized = false
        local defaultSize = WindowFrame.Size

        WindowMinimize.MouseButton1Click:Connect(function()
            isWindowMinimized = not isWindowMinimized
            WindowContent.Visible = not isWindowMinimized
            WindowFrame.Size = isWindowMinimized and UDim2.new(WindowFrame.Size.X.Scale, WindowFrame.Size.X.Offset, 0, 40) or (isWindowMaximized and UDim2.new(0.5, 0, 0.6, 0) or defaultSize)
        end)

        WindowMaximize.MouseButton1Click:Connect(function()
            isWindowMaximized = not isWindowMaximized
            if not isWindowMinimized then
                WindowFrame.Size = isWindowMaximized and UDim2.new(0.5, 0, 0.6, 0) or defaultSize
            end
        end)

        WindowClose.MouseButton1Click:Connect(function()
            local tween = TweenService:Create(WindowFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 1})
            tween:Play()
            tween.Completed:Wait()
            WindowFrame:Destroy()
            windows[name] = nil
        end)

        local windowDragging, windowDragStart, windowStartPos, windowResizing, windowResizeStart
        local function updateWindowDrag(input)
            local delta = input.Position - windowDragStart
            WindowFrame.Position = UDim2.new(windowStartPos.X.Scale, windowStartPos.X.Offset + delta.X, windowStartPos.Y.Scale, windowStartPos.Y.Offset + delta.Y)
        end

        local function updateWindowResize(input)
            local delta = input.Position - windowResizeStart
            WindowFrame.Size = UDim2.new(0, math.max(150, windowStartPos.X.Offset + delta.X), 0, math.max(100, windowStartPos.Y.Offset + delta.Y))
        end

        WindowHeader.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                windowDragging = true
                windowDragStart = input.Position
                windowStartPos = WindowFrame.Position
            end
        end)

        WindowHeader.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                windowDragging = false
            end
        end)

        WindowFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local pos = input.Position
                local size = WindowFrame.AbsoluteSize
                local pos2 = WindowFrame.AbsolutePosition
                if pos.X > pos2.X + size.X - 20 and pos.Y > pos2.Y + size.Y - 20 then
                    windowResizing = true
                    windowResizeStart = input.Position
                    windowStartPos = WindowFrame.Size
                end
            end
        end)

        WindowFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                windowResizing = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if windowDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateWindowDrag(input)
            elseif windowResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateWindowResize(input)
            end
        end)

        -- Animate Window Appearance
        WindowFrame.BackgroundTransparency = 1
        local tween = TweenService:Create(WindowFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 0})
        tween:Play()

        windows[name] = {Frame = WindowFrame, Gradient = WindowGradient}
        return WindowContent
    end

    -- Library API
    function SnowtUI:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 50)
        TabButton.Text = name
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Parent = SidebarScroll
        local TabCorner = Instance.new("UICorner")
        TabCorner.Parent = TabButton

        local TabFrame = Instance.new("Frame")
        TabFrame.Size = UDim2.new(1, 0, 0.9, 0)
        TabFrame.Position = UDim2.new(0, 0, 0.1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.Parent = ContentFrame

        tabs[name] = TabFrame
        contentFrames[name] = TabFrame

        TabButton.MouseButton1Click:Connect(function()
            for _, frame in pairs(contentFrames) do
                frame.Visible = false
            end
            TabFrame.Visible = true
        end)

        return TabFrame
    end

    function SnowtUI:CreateButton(parent, name, callback, options)
        options = options or {}
        local Button = Instance.new("TextButton")
        Button.Size = options.Size or UDim2.new(0.2, 0, 0, 30)
        Button.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 35)
        Button.Text = name
        Button.BackgroundColor3 = options.Color or Color3.fromRGB(50, 150, 255)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Parent = parent
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 5)
        ButtonCorner.Parent = Button

        -- Hover Effect
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 180, 255)}):Play()
        end)
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = options.Color or Color3.fromRGB(50, 150, 255)}):Play()
        end)

        Button.MouseButton1Click:Connect(callback)
    end

    function SnowtUI:CreateToggle(parent, name, default, callback, options)
        options = options or {}
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = options.Size or UDim2.new(0.2, 0, 0, 30)
        ToggleFrame.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 35)
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Parent = parent

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.TextScaled = true
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0.3, 0, 0.6, 0)
        ToggleButton.Position = UDim2.new(0.7, 0, 0.2, 0)
        ToggleButton.Text = ""
        ToggleButton.BackgroundColor3 = default and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(100, 100, 100)
        ToggleButton.Parent = ToggleFrame
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 15)
        ToggleCorner.Parent = ToggleButton

        local state = default
        ToggleButton.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(100, 100, 100)}):Play()
            callback(state)
        end)
    end

    function SnowtUI:CreateDropdown(parent, name, optionsList, default, callback, options)
        options = options or {}
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = options.Size or UDim2.new(0.2, 0, 0, 30)
        DropdownFrame.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 35)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        DropdownFrame.Parent = parent
        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 5)
        DropdownCorner.Parent = DropdownFrame

        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Size = UDim2.new(0.8, 0, 1, 0)
        DropdownLabel.Text = name .. ": " .. default
        DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownLabel.TextScaled = true
        DropdownLabel.BackgroundTransparency = 1
        DropdownLabel.Parent = DropdownFrame

        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Size = UDim2.new(0.2, 0, 1, 0)
        DropdownButton.Position = UDim2.new(0.8, 0, 0, 0)
        DropdownButton.Text = "▼"
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownButton.Parent = DropdownFrame

        local DropdownList = Instance.new("Frame")
        DropdownList.Size = UDim2.new(1, 0, 0, #optionsList * 30)
        DropdownList.Position = UDim2.new(0, 0, 1, 5)
        DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        DropdownList.Visible = false
        DropdownList.Parent = DropdownFrame
        local ListCorner = Instance.new("UICorner")
        ListCorner.CornerRadius = UDim.new(0, 5)
        ListCorner.Parent = DropdownList

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Parent = DropdownList

        for i, option in ipairs(optionsList) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Text = option
            OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.Parent = DropdownList
            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 5)
            OptionCorner.Parent = OptionButton

            OptionButton.MouseButton1Click:Connect(function()
                DropdownLabel.Text = name .. ": " .. option
                DropdownList.Visible = false
                callback(option)
            end)
        end

        DropdownButton.MouseButton1Click:Connect(function()
            DropdownList.Visible = not DropdownList.Visible
        end)
    end

    function SnowtUI:CreateTextInput(parent, name, placeholder, callback, options)
        options = options or {}
        local TextInputFrame = Instance.new("Frame")
        TextInputFrame.Size = options.Size or UDim2.new(0.2, 0, 0, 30)
        TextInputFrame.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 35)
        TextInputFrame.BackgroundTransparency = 1
        TextInputFrame.Parent = parent

        local TextInputLabel = Instance.new("TextLabel")
        TextInputLabel.Size = UDim2.new(0.5, 0, 1, 0)
        TextInputLabel.Text = name
        TextInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextInputLabel.TextScaled = true
        TextInputLabel.BackgroundTransparency = 1
        TextInputLabel.Parent = TextInputFrame

        local TextInput = Instance.new("TextBox")
        TextInput.Size = UDim2.new(0.5, 0, 0.8, 0)
        TextInput.Position = UDim2.new(0.5, 0, 0.1, 0)
        TextInput.PlaceholderText = placeholder
        TextInput.Text = ""
        TextInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TextInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextInput.Parent = TextInputFrame
        local TextInputCorner = Instance.new("UICorner")
        TextInputCorner.CornerRadius = UDim.new(0, 5)
        TextInputCorner.Parent = TextInput

        TextInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(TextInput.Text)
                TextInput.Text = ""
            end
        end)
    end

    function SnowtUI:CreateNotification(message, duration)
        local Notification = Instance.new("Frame")
        Notification.Size = UDim2.new(0.3, 0, 0.1, 0)
        Notification.Position = UDim2.new(0.35, 0, 0.8, 0)
        Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Notification.Parent = ScreenGui
        local NotificationCorner = Instance.new("UICorner")
        NotificationCorner.CornerRadius = UDim.new(0, 10)
        NotificationCorner.Parent = Notification

        local NotificationText = Instance.new("TextLabel")
        NotificationText.Size = UDim2.new(1, 0, 1, 0)
        NotificationText.Text = message
        NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotificationText.TextScaled = true
        NotificationText.BackgroundTransparency = 1
        NotificationText.Parent = Notification

        local tween = TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 0})
        tween:Play()
        wait(duration or 3)
        local fadeOut = TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Wait()
        Notification:Destroy()
    end

    -- Search Functionality
    SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBar.Text:lower()
        for name, frame in pairs(contentFrames) do
            frame.Visible = name:lower():find(query) and true or frame.Visible
        end
    end)

    return SnowtUI
end

-- Initialize UI
local ui = createUI()

return SnowtUI