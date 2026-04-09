local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

print("[OS] VERSION 1.5 LOADED - ALL METHODS PRESENT")

local Library = {}
Library.Version = 1.5

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

    local function toggleGui()
        guiVisible = not guiVisible
        local targetTransparency = guiVisible and 0 or 1
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = targetTransparency}):Play()
        MainFrame.Visible = guiVisible
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

                Toggle.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(20, 25, 45)}):Play()
                    callback(enabled)
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

                local function update(input)
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    callback(value)
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
                ColorFrame.Size = UDim2.new(0, 150, 0, 150)
                ColorFrame.Position = UDim2.new(1, 10, 0, 0)
                ColorFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 45)
                ColorFrame.Visible = false
                ColorFrame.ZIndex = 500
                ColorFrame.Parent = OSGui

                local HueSlider = Instance.new("TextButton")
                HueSlider.Size = UDim2.new(1, -10, 0, 20)
                HueSlider.Position = UDim2.new(0, 5, 0.8, 0)
                HueSlider.Text = ""
                HueSlider.Parent = ColorFrame

                local HueGrad = Instance.new("UIGradient")
                HueGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
                    ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16, 1, 1)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
                    ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 1, 1)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
                })
                HueGrad.Parent = HueSlider

                Picker.MouseButton1Click:Connect(function()
                    ColorFrame.Visible = not ColorFrame.Visible
                    if ColorFrame.Visible then
                        local absPos = Picker.AbsolutePosition
                        local absSize = Picker.AbsoluteSize
                        ColorFrame.Position = UDim2.new(0, absPos.X + absSize.X + 10, 0, absPos.Y)
                    end
                end)

                local function update()
                    local newColor = Color3.fromHSV(h, s, v)
                    ColorDisplay.BackgroundColor3 = newColor
                    callback(newColor)
                end

                HueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local sliding = true
                        local function move()
                            local pos = math.clamp((UserInputService:GetMouseLocation().X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
                            h = pos
                            update()
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

            return Section
        end

        return Tab
    end

    return Window
end

return Library
