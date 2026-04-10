local function fetch(url: string)
    local cacheBreaker = "?v=" .. tostring(math.random(1, 1000000))
    return game:HttpGet(url .. cacheBreaker)
end

local HttpService = game:GetService("HttpService")
local Library = loadstring(fetch("https://raw.githubusercontent.com/nathanathan69420-pixel/OS/main/gui/main.luau"))()
Library:Notify("OS", "Library Loaded!", 5)

local Window = Library:CreateWindow("OS")

Window:CreateTab("🏠 Home")
local SettingsTab = Window:CreateTab("⚙️ Settings")

local KeybindsSection = SettingsTab:CreateSection("Keybinds")
KeybindsSection:CreateKeybind("GUI Bind", Enum.KeyCode.RightShift, function(key)
    Library:Notify("OS Keybind", "New GUI Bind: " .. key.Name, 3)
end)

local ThemeSection = SettingsTab:CreateSection("Theme")
ThemeSection:CreateColorPicker("Tab List Color", Color3.fromRGB(10, 15, 35), function(color)
    if Library.ChangeTheme then Library:ChangeTheme("Tab List Color", color) end
end)
ThemeSection:CreateColorPicker("Secondary Color", Color3.fromRGB(30, 40, 80), function(color)
    if Library.ChangeTheme then Library:ChangeTheme("Secondary Color", color) end
end)
ThemeSection:CreateColorPicker("Main Color", Color3.fromRGB(15, 20, 45), function(color)
    if Library.ChangeTheme then Library:ChangeTheme("Main Color", color) end
end)

local MiscSection = SettingsTab:CreateSection("Misc")
MiscSection:CreateDropdown("UI Size", {"200%", "175%", "150%", "125%", "100%", "75%", "50%", "25%"}, "100%", function(val)
    local scaleMap = {
        ["200%"] = 2.0, ["175%"] = 1.75, ["150%"] = 1.5, ["125%"] = 1.25,
        ["100%"] = 1.0, ["75%"] = 0.75, ["50%"] = 0.5, ["25%"] = 0.25
    }
    if scaleMap[val] then
        Window:SetScale(scaleMap[val])
    end
end)

MiscSection:CreateDivider()

local currentConfigName = ""
local selectedConfig = ""

local function getConfigs()
    local list = {}
    local success = pcall(function()
        if isfolder and isfolder("OS_Configs") and listfiles then
            for _, f in ipairs(listfiles("OS_Configs")) do
                local name = f:match("([^/\\]+)%.json$")
                if name then table.insert(list, name) end
            end
        end
    end)
    if #list == 0 then table.insert(list, "None") end
    return list
end

local ConfigDrop

MiscSection:CreateTextbox("Config Name", "Enter name...", function(t)
    currentConfigName = t
end)

MiscSection:CreateButton("Create Config", function()
    if currentConfigName == "" or currentConfigName == "Enter name..." then
        Library:Notify("Config Alert", "You need to have a config name!", 3)
        return
    end
    Library:SaveConfig(currentConfigName)
    Library:Notify("Config", "Successfully created config: " .. currentConfigName, 3)
    if ConfigDrop then
        ConfigDrop.UpdateList(getConfigs())
    end
end)

MiscSection:CreateDivider()

ConfigDrop = MiscSection:CreateDropdown("Configuration", getConfigs(), "None", function(val)
    if val ~= "None" then
        selectedConfig = val
    else
        selectedConfig = ""
    end
end)

MiscSection:CreateButton("Load Config", function()
    if selectedConfig == "" or selectedConfig == "None" then
        Library:Notify("Config Alert", "No config selected. Please pick a config to load.", 3)
        return
    end
    Library:LoadConfig(selectedConfig)
    Library:Notify("Config", "Loaded " .. selectedConfig, 3)
end)

MiscSection:CreateButton("Save Config", function()
    if selectedConfig == "" or selectedConfig == "None" then
        Library:Notify("Config Alert", "No config selected to save to!", 3)
        return
    end
    
    local hasChanges = false
    pcall(function()
        local path = "OS_Configs/" .. selectedConfig .. ".json"
        if isfile and isfile(path) then
            local oldData = readfile(path)
            local newData = HttpService:JSONEncode(Library.Flags)
            if oldData ~= newData then
                hasChanges = true
            end
        else
            hasChanges = true
        end
    end)

    if not hasChanges then
        Library:Notify("Config Alert", "No changes added. Did you misclick?", 3)
    else
        Library:SaveConfig(selectedConfig)
        Library:Notify("Config", "Changes made.", 3)
    end
end)

MiscSection:CreateButton("Delete Config", function()
    if selectedConfig == "" or selectedConfig == "None" then
        Library:Notify("Config Alert", "You need to select a config to delete!", 3)
        return
    end
    pcall(function()
        if delfile then delfile("OS_Configs/" .. selectedConfig .. ".json") end
    end)
    Library:Notify("Config", "Deleted config " .. selectedConfig, 3)
    selectedConfig = ""
    if ConfigDrop then
        ConfigDrop.UpdateList(getConfigs())
    end
end)
