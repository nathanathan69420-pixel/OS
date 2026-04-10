local function fetch(url: string)
    local cacheBreaker = "?v=" .. tostring(math.random(1, 1000000))
    return game:HttpGet(url .. cacheBreaker)
end

local Library = loadstring(fetch("https://raw.githubusercontent.com/nathanathan69420-pixel/OS/main/gui/main.lua"))()
Library:Notify("OS", "Library Loaded!", 5)

local Window = Library:CreateWindow("OS")

Window:CreateTab("🏠 Home")
local SettingsTab = Window:CreateTab("⚙️ Settings")
local ConfigTab = Window:CreateTab("📁 Config")

local KeybindsSection = SettingsTab:CreateSection("Keybinds")
KeybindsSection:CreateKeybind("GUI Bind", Enum.KeyCode.RightShift, function(key)
    Library:Notify("OS Keybind", "New GUI Bind: " .. key.Name, 3)
end)

local VisualsSection = SettingsTab:CreateSection("New Features Demo")
VisualsSection:CreateLabel("Pick your ESP Options:")
VisualsSection:CreateMultiSelect("ESP Features", {["Boxes"] = true, ["Names"] = false, ["Health"] = true}, function(selected)
end)
VisualsSection:CreateDropdown("ESP Box Type", {"2D", "3D", "Corner"}, "2D", function(val)
end)
VisualsSection:CreateDivider()
VisualsSection:CreateLabel("Other toggles:")
VisualsSection:CreateToggle("Chams", false, function(t)
end)

local ThemeSection = SettingsTab:CreateSection("Theme")
ThemeSection:CreateColorPicker("Tab List Color", Color3.fromRGB(10, 15, 35), function(color)
    Library:Notify("OS Theme", "Tab List Color changed", 3)
end)
ThemeSection:CreateColorPicker("Secondary Color", Color3.fromRGB(30, 40, 80), function(color)
    Library:Notify("OS Theme", "Secondary Color changed", 3)
end)
ThemeSection:CreateColorPicker("Main Color", Color3.fromRGB(15, 20, 45), function(color)
    Library:Notify("OS Theme", "Main Color changed", 3)
end)

local MiscSection = SettingsTab:CreateSection("Misc")
MiscSection:CreateSlider("WalkSpeed", 16, 100, 16, function(v)
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = v end
end)
MiscSection:CreateTextbox("Custom Title", "Enter text...", function(t)
    Library:Notify("OS Input", "Textbox value: " .. t, 3)
end)

local ConfigSection = ConfigTab:CreateSection("Saved Settings")
local currentConfigName = "default"
ConfigSection:CreateTextbox("Config Name", "default", function(t)
    currentConfigName = t ~= "" and t or "default"
end)
ConfigSection:CreateButton("Save Config", function()
    Library:SaveConfig(currentConfigName)
end)
ConfigSection:CreateButton("Load Config", function()
    Library:LoadConfig(currentConfigName)
end)
