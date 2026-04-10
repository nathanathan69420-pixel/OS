local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local HttpService = game:GetService("HttpService")

local Library = {}
Library.Flags = {}
Library.FlagsCallbacks = {}

local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "OS_NotifySys"
NotifyGui.Parent = (gethui and gethui()) or CoreGui
NotifyGui.ResetOnSpawn = false
NotifyGui.DisplayOrder = 1000

local NotifyContainer = Instance.new("Frame")
NotifyContainer.Size = UDim2.new(0, 250, 1, -20)
NotifyContainer.Position = UDim2.new(1, -270, 0, 20)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.Parent = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding = UDim.new(0, 10)
NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Parent = NotifyContainer

function Library:Notify(title: string, text: string, duration: number)
    duration = duration or 5
    local NWrapper = Instance.new("Frame")
    NWrapper.Size = UDim2.new(0, 250, 0, 70)
    NWrapper.BackgroundTransparency = 1
    NWrapper.Parent = NotifyContainer

    local NFrame = Instance.new("Frame")
    NFrame.Size = UDim2.new(1, 0, 1, 0)
    NFrame.Position = UDim2.new(1, 260, 0, 0)
    NFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 45)
    NFrame.Parent = NWrapper

    local NCorner = Instance.new("UICorner")
    NCorner.CornerRadius = UDim.new(0, 8)
    NCorner.Parent = NFrame

    local NTitle = Instance.new("TextLabel")
    NTitle.Size = UDim2.new(1, -10, 0, 20)
    NTitle.Position = UDim2.new(0, 10, 0, 5)
    NTitle.BackgroundTransparency = 1
    NTitle.Text = title
    NTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NTitle.Font = Enum.Font.GothamBold
    NTitle.TextSize = 14
    NTitle.TextXAlignment = Enum.TextXAlignment.Left
    NTitle.Parent = NFrame

    local NText = Instance.new("TextLabel")
    NText.Size = UDim2.new(1, -20, 1, -30)
    NText.Position = UDim2.new(0, 10, 0, 25)
    NText.BackgroundTransparency = 1
    NText.Text = text
    NText.TextColor3 = Color3.fromRGB(200, 200, 200)
    NText.Font = Enum.Font.Gotham
    NText.TextSize = 12
    NText.TextWrapped = true
    NText.TextXAlignment = Enum.TextXAlignment.Left
    NText.TextYAlignment = Enum.TextYAlignment.Top
    NText.Parent = NFrame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, 0, 0, 3)
    Bar.Position = UDim2.new(0, 0, 1, -3)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    Bar.BorderSizePixel = 0
    Bar.Parent = NFrame

    TweenService:Create(Bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)}):Play()
    TweenService:Create(NFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.delay(duration, function()
        pcall(function()
            local tw = TweenService:Create(NFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 260, 0, 0)})
            tw:Play()
            tw.Completed:Connect(function()
                NWrapper:Destroy()
            end)
        end)
    end)
end

function Library:CreateWindow(hubName: string)
    local OSGui = Instance.new("ScreenGui")
    OSGui.Name = "OS_Interface"
    OSGui.Parent = (gethui and gethui()) or CoreGui
    OSGui.ResetOnSpawn = false
    OSGui.DisplayOrder = 100
    OSGui.IgnoreGuiInset = true

    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 45)
    MainFrame.BorderSizePixel = 0
    MainFrame.GroupTransparency = 0

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainScale = Instance.new("UIScale")
    MainScale.Parent = MainFrame

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
    Sidebar.Size = UDim2.new(0, 160, 1, -40)
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
    ContentContainer.Size = UDim2.new(1, -170, 1, -50)
    ContentContainer.Position = UDim2.new(0, 165, 0, 45)
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

    local guiVisible = true
    local toggleKey = Enum.KeyCode.RightShift
    local colorFrames = {}
    local toggleTween
    local toggleTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    local function toggleGui()
        guiVisible = not guiVisible
        
        if guiVisible then
            MainFrame.Visible = true
            if toggleTween then
                toggleTween:Cancel()
            end
            toggleTween = TweenService:Create(MainFrame, toggleTweenInfo, {GroupTransparency = 0})
            toggleTween:Play()
        else
            if toggleTween then
                toggleTween:Cancel()
            end
            toggleTween = TweenService:Create(MainFrame, toggleTweenInfo, {GroupTransparency = 1})
            toggleTween:Play()
            toggleTween.Completed:Once(function()
                if not guiVisible then
                    MainFrame.Visible = false
                end
            end)
            for _, cf in pairs(colorFrames) do
                cf.Visible = false
            end
        end
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == toggleKey then
            toggleGui()
        end
    end)

    ExitButton.MouseButton1Click:Connect(function()
        OSGui:Destroy()
    end)

    local sidebarOpen = true
    BurgerButton.MouseButton1Click:Connect(function()
        sidebarOpen = not sidebarOpen
        local targetSize = sidebarOpen and UDim2.new(0, 160, 1, -40) or UDim2.new(0, 0, 1, -40)
        local targetContentPos = sidebarOpen and UDim2.new(0, 165, 0, 45) or UDim2.new(0, 5, 0, 45)
        local targetContentSize = sidebarOpen and UDim2.new(1, -170, 1, -50) or UDim2.new(1, -10, 1, -50)
        
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
        TabListLayout.Padding = UDim.new(0, 10)
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

        TabButton.MouseEnter:Connect(function()
            if not TabContent.Visible then
                TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 80, 200)}):Play()
            end
        end)

        TabButton.MouseLeave:Connect(function()
            if not TabContent.Visible then
                TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 40, 80)}):Play()
            end
        end)

        TabButton.MouseButton1Click:Connect(show)

        local tabData = {Button = TabButton, Content = TabContent}
        table.insert(tabs, tabData)

        if #tabs == 1 then
            show()
        end

        local Tab = {}

        function Tab:CreateSection(sectionName: string)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName .. "Section"
            SectionFrame.Size = UDim2.new(0.95, 0, 0, 40)
            SectionFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 55)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent

            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, -20, 0, 25)
            SectionTitle.Position = UDim2.new(0, 10, 0, 5)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame

            local SectionList = Instance.new("UIListLayout")
            SectionList.Padding = UDim.new(0, 5)
            SectionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Parent = SectionFrame

            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(0.95, 0, 0, SectionList.AbsoluteContentSize.Y + 10)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 20)
            end)

            local Section = {}

            function Section:CreateButton(btnName: string, callback: () -> ())
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(0.95, 0, 0, 30)
                Button.BackgroundColor3 = Color3.fromRGB(35, 45, 90)
                Button.Text = btnName
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.Font = Enum.Font.Gotham
                Button.TextSize = 12
                Button.Parent = SectionFrame

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = Button

                Button.MouseButton1Click:Connect(callback)
            end

            function Section:CreateToggle(toggleName: string, default: boolean, callback: (boolean) -> ())
                local enabled = default
                Library.Flags[toggleName] = default
                Library.FlagsCallbacks[toggleName] = function(v)
                    enabled = v
                    Library.Flags[toggleName] = enabled
                    callback(enabled)
                end
                
                local Toggle = Instance.new("TextButton")
                Toggle.Size = UDim2.new(0.95, 0, 0, 30)
                Toggle.BackgroundColor3 = Color3.fromRGB(35, 45, 90)
                Toggle.Text = "  " .. toggleName
                Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.Font = Enum.Font.Gotham
                Toggle.TextSize = 12
                Toggle.TextXAlignment = Enum.TextXAlignment.Left
                Toggle.Parent = SectionFrame

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = Toggle

                local Indicator = Instance.new("Frame")
                Indicator.Size = UDim2.new(0, 40, 0, 20)
                Indicator.Position = UDim2.new(1, -50, 0.5, -10)
                Indicator.BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(20, 25, 45)
                Indicator.Parent = Toggle

                local IndCorner = Instance.new("UICorner")
                IndCorner.CornerRadius = UDim.new(1, 0)
                IndCorner.Parent = Indicator

                Indicator.Name = "Indicator"
                
                local oldCb = Library.FlagsCallbacks[toggleName]
                Library.FlagsCallbacks[toggleName] = function(v)
                    oldCb(v)
                    TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = v and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(20, 25, 45)}):Play()
                end

                Toggle.MouseButton1Click:Connect(function()
                    Library.FlagsCallbacks[toggleName](not enabled)
                end)
            end

            function Section:CreateSlider(sliderName: string, min: number, max: number, default: number, callback: (number) -> ())
                local Slider = Instance.new("Frame")
                Slider.Size = UDim2.new(0.95, 0, 0, 45)
                Slider.BackgroundColor3 = Color3.fromRGB(35, 45, 90)
                Slider.Parent = SectionFrame

                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 6)
                SliderCorner.Parent = Slider

                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(1, -20, 0, 20)
                Title.Position = UDim2.new(0, 10, 0, 5)
                Title.BackgroundTransparency = 1
                Title.Text = sliderName
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.Font = Enum.Font.Gotham
                Title.TextSize = 11
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Parent = Slider

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 40, 0, 20)
                ValueLabel.Position = UDim2.new(1, -50, 0, 5)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.TextSize = 11
                ValueLabel.Parent = Slider

                local Bar = Instance.new("Frame")
                Bar.Size = UDim2.new(0.9, 0, 0, 4)
                Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
                Bar.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
                Bar.BorderSizePixel = 0
                Bar.Parent = Slider

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                Fill.BorderSizePixel = 0
                Fill.Parent = Bar
                
                Library.Flags[sliderName] = default
                Library.FlagsCallbacks[sliderName] = function(v)
                    local pos = (v - min) / (max - min)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    ValueLabel.Text = tostring(v)
                    Library.Flags[sliderName] = v
                    callback(v)
                end

                local function update(input)
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    Library.FlagsCallbacks[sliderName](value)
                end

                local sliding = false
                Slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        update(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        update(input)
                    end
                end)
            end

            function Section:CreateTextbox(boxName: string, placeholder: string, callback: (string) -> ())
                local TextboxFrame = Instance.new("Frame")
                TextboxFrame.Size = UDim2.new(0.95, 0, 0, 40)
                TextboxFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 90)
                TextboxFrame.Parent = SectionFrame

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 6)
                BoxCorner.Parent = TextboxFrame

                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(0, 100, 1, 0)
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = boxName
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.Font = Enum.Font.Gotham
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Parent = TextboxFrame

                local Box = Instance.new("TextBox")
                Box.Size = UDim2.new(1, -120, 0.7, 0)
                Box.Position = UDim2.new(0, 110, 0.15, 0)
                Box.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
                Box.Text = ""
                Box.PlaceholderText = placeholder
                Box.TextColor3 = Color3.fromRGB(255, 255, 255)
                Box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 12
                Box.Parent = TextboxFrame

                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(0, 4)
                InnerCorner.Parent = Box

                Box.FocusLost:Connect(function(enter)
                    if enter then
                        callback(Box.Text)
                    end
                end)
            end

            function Section:CreateKeybind(bindName: string, default: Enum.KeyCode, callback: (Enum.KeyCode) -> ())
                local currentKey = default
                local binding = false
                
                local BindButton = Instance.new("TextButton")
                BindButton.Size = UDim2.new(0.95, 0, 0, 30)
                BindButton.BackgroundColor3 = Color3.fromRGB(35, 45, 90)
                BindButton.Text = "  " .. bindName
                BindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                BindButton.Font = Enum.Font.Gotham
                BindButton.TextSize = 12
                BindButton.TextXAlignment = Enum.TextXAlignment.Left
                BindButton.Parent = SectionFrame

                local BindCorner = Instance.new("UICorner")
                BindCorner.CornerRadius = UDim.new(0, 6)
                BindCorner.Parent = BindButton

                local KeyLabel = Instance.new("TextLabel")
                KeyLabel.Size = UDim2.new(0, 80, 0, 20)
                KeyLabel.Position = UDim2.new(1, -90, 0.5, -10)
                KeyLabel.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
                KeyLabel.Text = currentKey.Name
                KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeyLabel.Font = Enum.Font.Gotham
                KeyLabel.TextSize = 11
                KeyLabel.Parent = BindButton

                local KeyCorner = Instance.new("UICorner")
                KeyCorner.CornerRadius = UDim.new(0, 4)
                KeyCorner.Parent = KeyLabel

                BindButton.MouseButton1Click:Connect(function()
                    binding = true
                    KeyLabel.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        binding = false
                        currentKey = input.KeyCode
                        KeyLabel.Text = currentKey.Name
                        callback(currentKey)
                    end
                end)
                
                if bindName == "GUI Bind" then
                    toggleKey = default
                    callback = function(key) toggleKey = key end
                end
            end

            function Section:CreateColorPicker(pickerName: string, default: Color3, callback: (Color3) -> ())
                local h, s, v = default:ToHSV()
                local Picker = Instance.new("TextButton")
                Picker.Size = UDim2.new(0.95, 0, 0, 30)
                Picker.BackgroundColor3 = Color3.fromRGB(35, 45, 90)
                Picker.Text = "  " .. pickerName
                Picker.TextColor3 = Color3.fromRGB(255, 255, 255)
                Picker.Font = Enum.Font.Gotham
                Picker.TextSize = 12
                Picker.TextXAlignment = Enum.TextXAlignment.Left
                Picker.Parent = SectionFrame

                local ColorDisplay = Instance.new("Frame")
                ColorDisplay.Size = UDim2.new(0, 20, 0, 20)
                ColorDisplay.Position = UDim2.new(1, -30, 0.5, -10)
                ColorDisplay.BackgroundColor3 = default
                ColorDisplay.Parent = Picker

                local ColorFrame = Instance.new("Frame")
                ColorFrame.Size = UDim2.new(0, 150, 0, 180)
                ColorFrame.Position = UDim2.new(1, 10, 0, 0)
                ColorFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 45)
                ColorFrame.Visible = false
                ColorFrame.ZIndex = 500
                ColorFrame.Parent = OSGui
                table.insert(colorFrames, ColorFrame)

                local function updateColor()
                    local newColor = Color3.fromHSV(h, s, v)
                    ColorDisplay.BackgroundColor3 = newColor
                    Library.Flags[pickerName] = {h = h, s = s, v = v}
                    callback(newColor)
                end

                Library.Flags[pickerName] = {h = h, s = s, v = v}
                Library.FlagsCallbacks[pickerName] = function(val)
                    h, s, v = val.h, val.s, val.v
                    updateColor()
                end

                local function createColorSlider(name, pos, defaultVal, updateFn)
                    local Slider = Instance.new("Frame")
                    Slider.Size = UDim2.new(1, -10, 0, 35)
                    Slider.Position = pos
                    Slider.BackgroundTransparency = 1
                    Slider.Parent = ColorFrame

                    local Lbl = Instance.new("TextLabel")
                    Lbl.Size = UDim2.new(1, 0, 0, 15)
                    Lbl.BackgroundTransparency = 1
                    Lbl.Text = name
                    Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
                    Lbl.Font = Enum.Font.Gotham
                    Lbl.TextSize = 10
                    Lbl.Parent = Slider

                    local Bar = Instance.new("TextButton")
                    Bar.Size = UDim2.new(1, 0, 0, 10)
                    Bar.Position = UDim2.new(0, 0, 0.6, 0)
                    Bar.Text = ""
                    Bar.BackgroundColor3 = Color3.fromRGB(30, 35, 65)
                    Bar.Parent = Slider

                    local Fill = Instance.new("Frame")
                    Fill.Size = UDim2.new(defaultVal, 0, 1, 0)
                    Fill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                    Fill.BorderSizePixel = 0
                    Fill.Parent = Bar

                    Bar.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local sliding = true
                            local function move()
                                local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                                Fill.Size = UDim2.new(p, 0, 1, 0)
                                updateFn(p)
                            end
                            move()
                            local con
                            con = UserInputService.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    sliding = false
                                    con:Disconnect()
                                end
                            end)
                            task.spawn(function()
                                while sliding do
                                    move()
                                    task.wait()
                                end
                            end)
                        end
                    end)
                end

                createColorSlider("Hue", UDim2.new(0, 5, 0, 10), h, function(p) h = p updateColor() end)
                createColorSlider("Saturation", UDim2.new(0, 5, 0, 50), s, function(p) s = p updateColor() end)
                createColorSlider("Value", UDim2.new(0, 5, 0, 90), v, function(p) v = p updateColor() end)

                Picker.MouseButton1Click:Connect(function()
                    ColorFrame.Visible = not ColorFrame.Visible
                    if ColorFrame.Visible then
                        local absPos = Picker.AbsolutePosition
                        local absSize = Picker.AbsoluteSize
                        ColorFrame.Position = UDim2.new(0, absPos.X + absSize.X + 10, 0, absPos.Y)
                    end
                end)

            end

            function Section:CreateLabel(text: string)
                local LabelFrame = Instance.new("Frame")
                LabelFrame.Size = UDim2.new(0.95, 0, 0, 25)
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Parent = SectionFrame

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -20, 1, 0)
                Lbl.Position = UDim2.new(0, 10, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextSize = 12
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = LabelFrame
                
                local function SetText(newText)
                    Lbl.Text = newText
                end
                return {SetText = SetText}
            end

            function Section:CreateDivider()
                local DivFrame = Instance.new("Frame")
                DivFrame.Size = UDim2.new(0.95, 0, 0, 20)
                DivFrame.BackgroundTransparency = 1
                DivFrame.Parent = SectionFrame

                local Line = Instance.new("Frame")
                Line.Size = UDim2.new(1, -20, 0, 2)
                Line.Position = UDim2.new(0, 10, 0.5, -1)
                Line.BackgroundColor3 = Color3.fromRGB(35, 45, 90)
                Line.BorderSizePixel = 0
                Line.Parent = DivFrame
            end

            function Section:CreateDropdown(dropName: string, list: {string}, default: string, callback: (string) -> ())
                local selected = default
                Library.Flags[dropName] = default

                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Size = UDim2.new(0.95, 0, 0, 40)
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 90)
                DropdownFrame.Parent = SectionFrame
                DropdownFrame.ClipsDescendants = true

                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 6)
                DropCorner.Parent = DropdownFrame

                local TopBtn = Instance.new("TextButton")
                TopBtn.Size = UDim2.new(1, 0, 0, 40)
                TopBtn.BackgroundTransparency = 1
                TopBtn.Text = ""
                TopBtn.Parent = DropdownFrame

                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(1, -120, 1, 0)
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = dropName
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.Font = Enum.Font.Gotham
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Parent = TopBtn

                local CurrentFrame = Instance.new("Frame")
                CurrentFrame.Size = UDim2.new(0, 100, 0, 25)
                CurrentFrame.Position = UDim2.new(1, -110, 0.5, -12.5)
                CurrentFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
                CurrentFrame.Parent = TopBtn

                local CurrCorner = Instance.new("UICorner")
                CurrCorner.CornerRadius = UDim.new(0, 4)
                CurrCorner.Parent = CurrentFrame

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Size = UDim2.new(1, 0, 1, 0)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = selected
                ValLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                ValLabel.Font = Enum.Font.Gotham
                ValLabel.TextSize = 11
                ValLabel.Parent = CurrentFrame

                local ListFrame = Instance.new("ScrollingFrame")
                ListFrame.Size = UDim2.new(1, 0, 1, -40)
                ListFrame.Position = UDim2.new(0, 0, 0, 40)
                ListFrame.BackgroundTransparency = 1
                ListFrame.BorderSizePixel = 0
                ListFrame.ScrollBarThickness = 2
                ListFrame.Parent = DropdownFrame

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Padding = UDim.new(0, 2)
                ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                ListLayout.Parent = ListFrame

                local open = false

                Library.FlagsCallbacks[dropName] = function(v)
                    selected = v
                    Library.Flags[dropName] = v
                    ValLabel.Text = v
                    callback(v)
                end

                local function rebuild()
                    for _, c in ipairs(ListFrame:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    local h = 0
                    for _, item in ipairs(list) do
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(0.95, 0, 0, 30)
                        btn.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
                        btn.Text = item
                        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        btn.Font = Enum.Font.Gotham
                        btn.TextSize = 11
                        btn.Parent = ListFrame

                        local c = Instance.new("UICorner")
                        c.CornerRadius = UDim.new(0, 4)
                        c.Parent = btn

                        btn.MouseButton1Click:Connect(function()
                            Library.FlagsCallbacks[dropName](item)
                            open = false
                            TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, 40)}):Play()
                        end)
                        h = h + 32
                    end
                    ListFrame.CanvasSize = UDim2.new(0, 0, 0, h + 5)
                end
                
                rebuild()

                TopBtn.MouseButton1Click:Connect(function()
                    open = not open
                    local ht = open and math.min(150, 40 + ListFrame.CanvasSize.Y.Offset) or 40
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, ht)}):Play()
                end)

                local function UpdateList(newList)
                    list = newList
                    rebuild()
                end
                return {UpdateList = UpdateList}
            end

            function Section:CreateMultiSelect(multiName: string, options: {[string]: boolean}, callback: ({[string]: boolean}) -> ())
                local selectedMap = {}
                for k, v in pairs(options) do selectedMap[k] = v end

                Library.Flags[multiName] = selectedMap
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Size = UDim2.new(0.95, 0, 0, 40)
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 45, 90)
                DropdownFrame.Parent = SectionFrame
                DropdownFrame.ClipsDescendants = true

                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 6)
                DropCorner.Parent = DropdownFrame

                local TopBtn = Instance.new("TextButton")
                TopBtn.Size = UDim2.new(1, 0, 0, 40)
                TopBtn.BackgroundTransparency = 1
                TopBtn.Text = ""
                TopBtn.Parent = DropdownFrame

                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(1, -120, 1, 0)
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = multiName
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.Font = Enum.Font.Gotham
                Title.TextSize = 12
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Parent = TopBtn

                local CurrentFrame = Instance.new("Frame")
                CurrentFrame.Size = UDim2.new(0, 100, 0, 25)
                CurrentFrame.Position = UDim2.new(1, -110, 0.5, -12.5)
                CurrentFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
                CurrentFrame.Parent = TopBtn

                local CurrCorner = Instance.new("UICorner")
                CurrCorner.CornerRadius = UDim.new(0, 4)
                CurrCorner.Parent = CurrentFrame

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Size = UDim2.new(1, 0, 1, 0)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = "..."
                ValLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                ValLabel.Font = Enum.Font.Gotham
                ValLabel.TextSize = 11
                ValLabel.Parent = CurrentFrame

                local ListFrame = Instance.new("ScrollingFrame")
                ListFrame.Size = UDim2.new(1, 0, 1, -40)
                ListFrame.Position = UDim2.new(0, 0, 0, 40)
                ListFrame.BackgroundTransparency = 1
                ListFrame.BorderSizePixel = 0
                ListFrame.ScrollBarThickness = 2
                ListFrame.Parent = DropdownFrame

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Padding = UDim.new(0, 2)
                ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                ListLayout.Parent = ListFrame

                local open = false

                local function updateLabel()
                    local active = {}
                    for k, v in pairs(selectedMap) do if v then table.insert(active, k) end end
                    local txt = table.concat(active, ", ")
                    ValLabel.Text = txt == "" and "None" or txt
                end
                updateLabel()

                Library.FlagsCallbacks[multiName] = function(vMap)
                    for k, v in pairs(vMap) do
                        selectedMap[k] = v
                    end
                    Library.Flags[multiName] = selectedMap
                    updateLabel()
                    for _, c in ipairs(ListFrame:GetChildren()) do
                        if c:IsA("TextButton") then
                            local k = c.Name
                            local mark = c:FindFirstChild("Indicator")
                            if mark then
                                mark.BackgroundColor3 = selectedMap[k] and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(20, 25, 45)
                            end
                        end
                    end
                    callback(selectedMap)
                end

                local h = 0
                for k, _ in pairs(selectedMap) do
                    local btn = Instance.new("TextButton")
                    btn.Name = k
                    btn.Size = UDim2.new(0.95, 0, 0, 30)
                    btn.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
                    btn.Text = "  " .. k
                    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    btn.Font = Enum.Font.Gotham
                    btn.TextSize = 11
                    btn.TextXAlignment = Enum.TextXAlignment.Left
                    btn.Parent = ListFrame

                    local c = Instance.new("UICorner")
                    c.CornerRadius = UDim.new(0, 4)
                    c.Parent = btn

                    local ind = Instance.new("Frame")
                    ind.Name = "Indicator"
                    ind.Size = UDim2.new(0, 15, 0, 15)
                    ind.Position = UDim2.new(1, -25, 0.5, -7.5)
                    ind.BackgroundColor3 = selectedMap[k] and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(20, 25, 45)
                    ind.Parent = btn

                    local indC = Instance.new("UICorner")
                    indC.CornerRadius = UDim.new(0, 3)
                    indC.Parent = ind

                    btn.MouseButton1Click:Connect(function()
                        local newState = not selectedMap[k]
                        local tMap = {}
                        for tk, tv in pairs(selectedMap) do tMap[tk] = tv end
                        tMap[k] = newState
                        Library.FlagsCallbacks[multiName](tMap)
                    end)
                    h = h + 32
                end
                ListFrame.CanvasSize = UDim2.new(0, 0, 0, h + 5)

                TopBtn.MouseButton1Click:Connect(function()
                    open = not open
                    local ht = open and math.min(180, 40 + ListFrame.CanvasSize.Y.Offset) or 40
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, ht)}):Play()
                end)
            end

            return Section
        end

        return Tab
    end

    function Window:SetScale(scale: number)
        MainScale.Scale = scale
    end

    MainFrame.Parent = OSGui
    return Window
end

function Library:SaveConfig(filename: string)
    pcall(function()
        if isfolder and not isfolder("OS_Configs") then
            makefolder("OS_Configs")
        end
        if writefile then
            writefile("OS_Configs/" .. filename .. ".json", HttpService:JSONEncode(Library.Flags))
        end
    end)
end

function Library:LoadConfig(filename: string)
    pcall(function()
        if isfile and isfile("OS_Configs/" .. filename .. ".json") then
            local data = HttpService:JSONDecode(readfile("OS_Configs/" .. filename .. ".json"))
            for k, v in pairs(data) do
                if Library.FlagsCallbacks[k] then
                    Library.FlagsCallbacks[k](v)
                end
            end
        end
    end)
end

return Library
