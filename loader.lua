local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

type GameConfig = {
    name: string,
    script_url: string,
}

local GAMES: { [number]: GameConfig } = {
    [123456789] = {
        name = "Example Game",
        script_url = "https://raw.githubusercontent.com/nathanathan69420-pixel/OS/main/scripts/example.lua"
    },
}

local UNIVERSAL_URL = "https://raw.githubusercontent.com/nathanathan69420-pixel/OS/main/universal.lua"

local function notify(title: string, text: string)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end)
end

local function loadScript(config: GameConfig)
    notify("OS", `Loading {config.name}...`)
    
    local success, result = pcall(function()
        local scriptContent: string
        if (game :: any).HttpGet then
            scriptContent = (game :: any):HttpGet(config.script_url)
        else
            error("Executor does not support HttpGet")
        end

        local func = loadstring(scriptContent)
        if func then
            task.spawn(func)
        else
            error("Failed to compile script")
        end
    end)

    if success then
        notify("OS", `Successfully loaded {config.name}!`)
    else
        notify("OS Error", `Failed to load {config.name}: {result}`)
    end
end

local function init()
    local placeId = game.PlaceId
    local config = GAMES[placeId]

    if config then
        loadScript(config)
    else
        notify("OS", "Game not supported, loading universal...")
        loadScript({
            name = "Universal",
            script_url = UNIVERSAL_URL
        })
    end
end

init()
