local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if ThemeManager.BuiltInThemes and ThemeManager.BuiltInThemes.Default then
    ThemeManager.BuiltInThemes.Default[2] = {
        FontColor = Color3.fromRGB(0, 0, 0),
        MainColor = Color3.fromRGB(71, 53, 22),
        BackgroundColor = Color3.fromRGB(141, 123, 63),
        AccentColor = Color3.fromRGB(207, 116, 27),
        OutlineColor = Color3.fromRGB(186, 155, 129),
    }
end
Library.Font = Enum.Font.Fantasy

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "OS Universal",
    Footer = "universal configuration",
    Icon = "rbxthumb://type=Asset&id=16603250881&w=150&h=150",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Home", "house"),
    PlayerMain = Window:AddTab("Main", "user"),
    Settings = Window:AddTab("UI Settings", "settings"),
}

local GreetingsGroup = Tabs.Main:AddLeftGroupbox("OS Greetings", "message-square")
GreetingsGroup:AddLabel(string.format("Welcome to OS Universal, @%s.\nYou are here, because you are in a game that OS does not support.\nThank you for using this script!", LocalPlayer.Name), true)

local GeneralGroup = Tabs.Main:AddLeftGroupbox("General", "layout-dashboard")

GeneralGroup:AddToggle("EnableFeatures", {
    Text = "Enable Features",
    Default = false,
    Callback = function(Value)
        if Value then
            Library:Notify("Features Enabled", 3)
        else
            Library:Notify("Features Disabled", 3)
        end
    end,
})

local ModsGroup = Tabs.PlayerMain:AddLeftGroupbox("Modifications", "swords")

ModsGroup:AddToggle("EnableWalkspeed", {
    Text = "Enable Walkspeed",
    Default = false,
})
ModsGroup:AddSlider("WalkspeedAmount", {
    Text = "Walkspeed Amount",
    Default = 16,
    Min = 1,
    Max = 100,
    Rounding = 0,
})

ModsGroup:AddToggle("EnableJumppower", {
    Text = "Enable Jumppower",
    Default = false,
})
ModsGroup:AddSlider("JumppowerAmount", {
    Text = "Jumppower Amount",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
})

ModsGroup:AddDivider()

ModsGroup:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false,
}):AddKeyPicker("NoclipKey", {
    Default = "None",
    Text = "Noclip",
    Mode = "Toggle",
    SyncToggleState = true
})

ModsGroup:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
}):AddKeyPicker("FlyKey", {
    Default = "None",
    Text = "Fly",
    Mode = "Toggle",
    SyncToggleState = true
})
ModsGroup:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 1,
    Max = 100,
    Rounding = 0,
})

local VisualsGroup = Tabs.PlayerMain:AddRightGroupbox("Visuals", "eye")

VisualsGroup:AddToggle("GeneralESPToggle", {
    Text = "General ESP Toggle",
    Default = false,
}):AddKeyPicker("GeneralESPKey", {
    Default = "None",
    Text = "General ESP",
    Mode = "Toggle",
    SyncToggleState = true
})

VisualsGroup:AddDivider()

VisualsGroup:AddToggle("BoxESPToggle", {
    Text = "Box ESP",
    Default = false,
}):AddColorPicker("BoxESPColor", {
    Default = Color3.fromRGB(255, 255, 255),
}):AddKeyPicker("BoxESPKey", {
    Default = "None",
    Text = "Box ESP",
    Mode = "Toggle",
    SyncToggleState = true
})

VisualsGroup:AddDropdown("BoxDimensions", {
    Values = { "2D", "3D" },
    Default = "2D",
    Text = "Dimensions",
})

VisualsGroup:AddToggle("ChamsToggle", {
    Text = "Chams",
    Default = false,
}):AddColorPicker("ChamsColor", {
    Default = Color3.fromRGB(255, 255, 255),
}):AddKeyPicker("ChamsKey", {
    Default = "None",
    Text = "Chams",
    Mode = "Toggle",
    SyncToggleState = true
})

VisualsGroup:AddToggle("SkeletonESPToggle", {
    Text = "Skeleton ESP",
    Default = false,
})

local function GetCharacter(player)
    return player.Character
end

RunService.Heartbeat:Connect(function()
    if Toggles.EnableWalkspeed.Value then
        local char = GetCharacter(LocalPlayer)
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = Options.WalkspeedAmount.Value
            end
        end
    end
    if Toggles.EnableJumppower.Value then
        local char = GetCharacter(LocalPlayer)
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.JumpPower = Options.JumppowerAmount.Value
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if Toggles.NoclipToggle.Value then
        local char = GetCharacter(LocalPlayer)
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end
end)

local bg = Instance.new("BodyGyro")
bg.P = 9e4
bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

local flyRender = nil

Toggles.FlyToggle:OnChanged(function()
    local char = GetCharacter(LocalPlayer)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if Toggles.FlyToggle.Value then
        bg.Parent = hrp
        bv.Parent = hrp
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = true end

        flyRender = RunService.RenderStepped:Connect(function()
            local speed = Options.FlySpeed.Value
            local cframe = Camera.CFrame
            local moveVector = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + cframe.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - cframe.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - cframe.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + cframe.RightVector
            end

            bg.CFrame = cframe
            if moveVector.Magnitude > 0 then
                bv.Velocity = moveVector.Unit * speed
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        bg.Parent = nil
        bv.Parent = nil
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
        if flyRender then
            flyRender:Disconnect()
            flyRender = nil
        end
    end
end)


local ESP_Objects = {}

local function createChams(player)
    if not ESP_Objects[player] then
        ESP_Objects[player] = {}
    end
    
    local char = GetCharacter(player)
    if not char then return end

    local hl = char:FindFirstChild("OSHightlight") or Instance.new("Highlight")
    hl.Name = "OSHightlight"
    hl.Parent = char
    hl.FillTransparency = 0.55
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = false
    
    ESP_Objects[player].Highlight = hl
end

local lines2D = {
    "Top", "Bottom", "Left", "Right"
}
local lines3D = {
    "Top1", "Top2", "Top3", "Top4",
    "Bot1", "Bot2", "Bot3", "Bot4",
    "Side1", "Side2", "Side3", "Side4"
}
local skeletonLines = {
    "HeadSpine", "SpinePelvis",
    "LeftArm", "RightArm",
    "LeftLeg", "RightLeg"
}

local function createDrawings(player)
    if not ESP_Objects[player] then
        ESP_Objects[player] = {}
    end
    local objs = ESP_Objects[player]
    
    if not objs.Box2D then
        local box = Drawing.new("Square")
        box.Thickness = 1
        box.Filled = false
        box.Visible = false
        objs.Box2D = box
    end
    
    if not objs.Box3D then
        objs.Box3D = {}
        for _, v in ipairs(lines3D) do
            local line = Drawing.new("Line")
            line.Thickness = 1
            line.Visible = false
            objs.Box3D[v] = line
        end
    end

    if not objs.Skeleton then
        objs.Skeleton = {}
        for _, v in ipairs(skeletonLines) do
            local line = Drawing.new("Line")
            line.Thickness = 1
            line.Visible = false
            objs.Skeleton[v] = line
        end
    end
end

for _, v in ipairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        createChams(v)
        createDrawings(v)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createChams(player)
    end)
    createDrawings(player)
end)

Players.PlayerRemoving:Connect(function(player)
    local objs = ESP_Objects[player]
    if objs then
        if objs.Box2D then objs.Box2D:Remove() end
        if objs.Box3D then
            for _, l in pairs(objs.Box3D) do l:Remove() end
        end
        if objs.Skeleton then
            for _, l in pairs(objs.Skeleton) do l:Remove() end
        end
        ESP_Objects[player] = nil
    end
end)

local function updateChams()
    for player, objs in pairs(ESP_Objects) do
        local hl = objs.Highlight
        if hl then
            if Toggles.GeneralESPToggle.Value and Toggles.ChamsToggle.Value and GetCharacter(player) then
                hl.FillColor = Options.ChamsColor.Value
                hl.OutlineColor = Options.ChamsColor.Value
                hl.Enabled = true
            else
                hl.Enabled = false
            end
        end
    end
end

local function drawLine(line, p1, p2, color)
    local screenPos1, vis1 = Camera:WorldToViewportPoint(p1)
    local screenPos2, vis2 = Camera:WorldToViewportPoint(p2)
    if vis1 or vis2 then
        line.From = Vector2.new(screenPos1.X, screenPos1.Y)
        line.To = Vector2.new(screenPos2.X, screenPos2.Y)
        line.Color = color
        line.Visible = true
    else
        line.Visible = false
    end
end

local function hideBox3D(objs)
    if objs and objs.Box3D then
        for _, l in pairs(objs.Box3D) do l.Visible = false end
    end
end

local function hideSkeleton(objs)
    if objs and objs.Skeleton then
        for _, l in pairs(objs.Skeleton) do l.Visible = false end
    end
end

local function updateDrawings()
    local generalEnabled = Toggles.GeneralESPToggle.Value
    local boxEnabled = Toggles.BoxESPToggle.Value
    local is3D = Options.BoxDimensions.Value == "3D"
    local skeletonEnabled = Toggles.SkeletonESPToggle.Value
    local boxColor = Options.BoxESPColor.Value

    for player, objs in pairs(ESP_Objects) do
        local char = GetCharacter(player)
        if generalEnabled and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local hrp = char.HumanoidRootPart
            local rootPos, rootVis = Camera:WorldToViewportPoint(hrp.Position)

            if boxEnabled then
                if is3D then
                    objs.Box2D.Visible = false
                    local size = char:GetExtentsSize()
                    local c = hrp.CFrame
                    local x, y, z = size.X/2, size.Y/2, size.Z/2

                    local t1 = c * CFrame.new(-x, y, -z)
                    local t2 = c * CFrame.new(x, y, -z)
                    local t3 = c * CFrame.new(x, y, z)
                    local t4 = c * CFrame.new(-x, y, z)

                    local b1 = c * CFrame.new(-x, -y, -z)
                    local b2 = c * CFrame.new(x, -y, -z)
                    local b3 = c * CFrame.new(x, -y, z)
                    local b4 = c * CFrame.new(-x, -y, z)

                    drawLine(objs.Box3D.Top1, t1.Position, t2.Position, boxColor)
                    drawLine(objs.Box3D.Top2, t2.Position, t3.Position, boxColor)
                    drawLine(objs.Box3D.Top3, t3.Position, t4.Position, boxColor)
                    drawLine(objs.Box3D.Top4, t4.Position, t1.Position, boxColor)

                    drawLine(objs.Box3D.Bot1, b1.Position, b2.Position, boxColor)
                    drawLine(objs.Box3D.Bot2, b2.Position, b3.Position, boxColor)
                    drawLine(objs.Box3D.Bot3, b3.Position, b4.Position, boxColor)
                    drawLine(objs.Box3D.Bot4, b4.Position, b1.Position, boxColor)

                    drawLine(objs.Box3D.Side1, t1.Position, b1.Position, boxColor)
                    drawLine(objs.Box3D.Side2, t2.Position, b2.Position, boxColor)
                    drawLine(objs.Box3D.Side3, t3.Position, b3.Position, boxColor)
                    drawLine(objs.Box3D.Side4, t4.Position, b4.Position, boxColor)
                else
                    hideBox3D(objs)
                    if rootVis then
                        local head = char:FindFirstChild("Head")
                        if head then
                            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                            local height = math.abs(headPos.Y - legPos.Y)
                            local width = height / 2

                            objs.Box2D.Size = Vector2.new(width, height)
                            objs.Box2D.Position = Vector2.new(rootPos.X - width/2, headPos.Y)
                            objs.Box2D.Color = boxColor
                            objs.Box2D.Visible = true
                        end
                    else
                        objs.Box2D.Visible = false
                    end
                end
            else
                objs.Box2D.Visible = false
                hideBox3D(objs)
            end

            if skeletonEnabled then
                local head = char:FindFirstChild("Head")
                local uppertorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                local lowertorso = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso")
                local larm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                local rarm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                local lleg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                local rleg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                
                if head and uppertorso and lowertorso and larm and rarm and lleg and rleg then
                    drawLine(objs.Skeleton.HeadSpine, head.Position, uppertorso.Position, Options.BoxESPColor.Value)
                    drawLine(objs.Skeleton.SpinePelvis, uppertorso.Position, lowertorso.Position, Options.BoxESPColor.Value)
                    drawLine(objs.Skeleton.LeftArm, uppertorso.Position, larm.Position, Options.BoxESPColor.Value)
                    drawLine(objs.Skeleton.RightArm, uppertorso.Position, rarm.Position, Options.BoxESPColor.Value)
                    drawLine(objs.Skeleton.LeftLeg, lowertorso.Position, lleg.Position, Options.BoxESPColor.Value)
                    drawLine(objs.Skeleton.RightLeg, lowertorso.Position, rleg.Position, Options.BoxESPColor.Value)
                else
                    hideSkeleton(objs)
                end
            else
                hideSkeleton(objs)
            end
        else
            if objs.Box2D then objs.Box2D.Visible = false end
            hideBox3D(objs)
            hideSkeleton(objs)
        end
    end
end

RunService.RenderStepped:Connect(function()
    updateChams()
    updateDrawings()
end)

local MenuGroup = Tabs.Settings:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddSlider("UICornerSlider", {
    Text = "Corner Radius",
    Default = Library.CornerRadius,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        Window:SetCornerRadius(Value)
    end
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("OS_Configs")
SaveManager:SetFolder("OS_Configs/universal")

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

Library:Notify("Universal Loaded Successfully!", 5)
