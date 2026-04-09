local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(hubName: string)
    local OSGui = Instance.new("ScreenGui")
    OSGui.Name = "OS_Interface"
    OSGui.Parent = (gethui and gethui()) or CoreGui
    OSGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 45)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = OSGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(10, 15, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar

    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0.5, 0)
    TopBarCover.Position = UDim2.new(0, 0, 0.5, 0)
    TopBarCover.BackgroundColor3 = Color3.fromRGB(10, 15, 35)
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 40, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = hubName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local ExitButton = Instance.new("TextButton")
    ExitButton.Name = "ExitButton"
    ExitButton.Size = UDim2.new(0, 30, 0, 30)
    ExitButton.Position = UDim2.new(1, -35, 0.5, -15)
    ExitButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ExitButton.Text = "X"
    ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExitButton.Font = Enum.Font.GothamBold
    ExitButton.TextSize = 14
    ExitButton.Parent = TopBar

    local ExitCorner = Instance.new("UICorner")
    ExitCorner.CornerRadius = UDim.new(0, 6)
    ExitCorner.Parent = ExitButton

    local BurgerButton = Instance.new("TextButton")
    BurgerButton.Name = "BurgerButton"
    BurgerButton.Size = UDim2.new(0, 30, 0, 30)
    BurgerButton.Position = UDim2.new(0, 5, 0.5, -15)
    BurgerButton.BackgroundTransparency = 1
    BurgerButton.Text = "≡"
    BurgerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    BurgerButton.TextSize = 24
    BurgerButton.Font = Enum.Font.GothamBold
    BurgerButton.Parent = TopBar

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 15, 35)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    Sidebar.ClipsDescendants = true

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    local SidebarCover = Instance.new("Frame")
    SidebarCover.Size = UDim2.new(0.5, 0, 1, 0)
    SidebarCover.Position = UDim2.new(0.5, 0, 0, 0)
    SidebarCover.BackgroundColor3 = Color3.fromRGB(10, 15, 35)
    SidebarCover.BorderSizePixel = 0
    SidebarCover.Parent = Sidebar

    local SidebarList = Instance.new("ScrollingFrame")
    SidebarList.Size = UDim2.new(1, 0, 1, -10)
    SidebarList.Position = UDim2.new(0, 0, 0, 5)
    SidebarList.BackgroundTransparency = 1
    SidebarList.BorderSizePixel = 0
    SidebarList.ScrollBarThickness = 2
    SidebarList.Parent = Sidebar

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = SidebarList

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -160, 1, -50)
    ContentContainer.Position = UDim2.new(0, 155, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local dragging = false
    local dragInput, dragStart, startPos

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    ExitButton.MouseButton1Click:Connect(function()
        OSGui:Destroy()
    end)

    local sidebarOpen = true
    BurgerButton.MouseButton1Click:Connect(function()
        sidebarOpen = not sidebarOpen
        local targetSize = sidebarOpen and UDim2.new(0, 150, 1, -40) or UDim2.new(0, 0, 1, -40)
        local targetContentPos = sidebarOpen and UDim2.new(0, 155, 0, 45) or UDim2.new(0, 5, 0, 45)
        local targetContentSize = sidebarOpen and UDim2.new(1, -160, 1, -50) or UDim2.new(1, -10, 1, -50)
        
        TweenService:Create(Sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
        TweenService:Create(ContentContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetContentPos, Size = targetContentSize}):Play()
    end)

    local Window = {}
    local tabs = {}

    function Window:CreateTab(name: string)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(0.9, 0, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 14
        TabButton.Parent = SidebarList

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 2
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        local TabListLayout = Instance.new("UIListLayout")
        TabListLayout.Padding = UDim.new(0, 5)
        TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabListLayout.Parent = TabContent

        local function show()
            for _, t in pairs(tabs) do
                t.Button.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
                t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                t.Content.Visible = false
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
        end

        TabButton.MouseButton1Click:Connect(show)

        local tabData = {Button = TabButton, Content = TabContent}
        table.insert(tabs, tabData)

        if #tabs == 1 then
            show()
        end

        local Tab = {}
        return Tab
    end

    return Window
end

return Library
