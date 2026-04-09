local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/nathanathan69420-pixel/OS/main/gui/main.lua"))()

local Window = Library:CreateWindow("OS")

local HomeTab = Window:CreateTab("🏠 Home")
local SettingsTab = Window:CreateTab("⚙️ Settings")

local KeybindsSection = SettingsTab:CreateSection("Keybinds")
KeybindsSection:CreateButton("GUI Bind: RightShift", function()
    print("Keybind clicked")
end)

local ThemeSection = SettingsTab:CreateSection("Theme")
ThemeSection:CreateColorPicker("Tab List Color", Color3.fromRGB(10, 15, 35), function(color)
    print("Tab List Color changed:", color)
end)
ThemeSection:CreateColorPicker("Secondary Color", Color3.fromRGB(30, 40, 80), function(color)
    print("Secondary Color changed:", color)
end)
ThemeSection:CreateColorPicker("Main Color", Color3.fromRGB(15, 20, 45), function(color)
    print("Main Color changed:", color)
end)

local MiscSection = SettingsTab:CreateSection("Misc")
MiscSection:CreateSlider("WalkSpeed", 16, 100, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)
MiscSection:CreateTextbox("Custom Title", "Enter text...", function(t)
    print("Textbox value:", t)
end)
