local function fetch(url: string)
    local cacheBreaker = "?v=" .. tostring(math.random(1, 1000000))
    return game:HttpGet(url .. cacheBreaker)
end

local Library = loadstring(fetch("https://raw.githubusercontent.com/nathanathan69420-pixel/OS/main/gui/main.lua"))()

print("[OS] Library Loaded:", Library.Version)

local Window = Library:CreateWindow("OS")

Window:CreateTab("🏠 Home")
local SettingsTab = Window:CreateTab("⚙️ Settings")

local KeybindsSection = SettingsTab:CreateSection("Keybinds")
KeybindsSection:CreateKeybind("GUI Bind", Enum.KeyCode.RightShift, function(key)
    print("New GUI Bind:", key.Name)
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
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = v end
end)
MiscSection:CreateTextbox("Custom Title", "Enter text...", function(t)
    print("Textbox value:", t)
end)
