-- Secondary script (robust, guarded)
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local function safeHttpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok then return res end
    return nil, res
end

local function reset()
    local url = "https://DanielNov2014alt.pythonanywhere.com/reset/value2"
    local response, err = safeHttpGet(url)
    if response then
        local success, decoded = pcall(function() return HttpService:JSONDecode(response) end)
        if success and decoded then
            print("After reset, value2 is:", decoded.value2)
        else
            warn("Failed to decode reset response:", decoded or err)
        end
    else
        warn("Error resetting value2:", err)
    end
end

local function Chat(message)
    local ok, isLegacy = pcall(function()
        return game.TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService
    end)
    if ok and not isLegacy then
        local suc, e = pcall(function() game.TextChatService.TextChannels.RBXGeneral:SendAsync(message) end)
        if not suc then warn("Chat SendAsync failed:", e) end
    else
        local suc, e = pcall(function()
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        end)
        if not suc then warn("Legacy chat failed:", e) end
    end
end

local function MoveRandom()
    local player = Players.LocalPlayer
    local char = player and player.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local target = char.HumanoidRootPart.Position + Vector3.new(math.random(-50,50), 0, math.random(-50,50))
        local suc, e = pcall(function() char.Humanoid:MoveTo(target) end)
        if not suc then warn("MoveTo failed:", e) end
    end
end

-- Helper: safe wrapper for queue_on_teleport if available
local function safe_queue_on_teleport(codeString)
    if type(queue_on_teleport) == "function" then
        local ok, err = pcall(function() queue_on_teleport(codeString) end)
        if not ok then warn("queue_on_teleport call failed:", err) end
        return true
    end
    return false
end

-- Fallback: use TeleportService:SetTeleportData to pass a script URL
local function set_teleport_data(dataTable)
    local ok, err = pcall(function() TeleportService:SetTeleportData(dataTable) end)
    if not ok then warn("SetTeleportData failed:", err) end
end

-- When arriving in a place, try to run any script URL passed via TeleportData
local function run_teleport_data_if_present()
    local ok, data = pcall(function() return TeleportService:GetLocalPlayerTeleportData() end)
    if ok and data and data.scriptUrl then
        if type(loadstring) == "function" then
            local code, err = safeHttpGet(data.scriptUrl)
            if code then
                local suc, e = pcall(function() loadstring(code)() end)
                if not suc then warn("loadstring execution failed:", e) end
            else
                warn("Failed to download script from teleport data:", err)
            end
        else
            warn("loadstring is not available in this environment; cannot run remote script.")
        end
    end
end

-- Run reset and initial actions
reset()
Chat("hello!!!")
MoveRandom()
task.wait(3)
Chat("what do i do here?")
MoveRandom()
task.wait(5)
Chat("my mom said i only have 2 minutes")

task.spawn(function()
    while task.wait(math.random(1,20)) do
        MoveRandom()
    end
end)

-- Ensure teleport persistence is queued safely
task.delay(120, function()
    Chat("gotta go")

    -- Build the code we want to queue (as a string). Keep it minimal and guarded.
   local queuedCode = [[
    if type(queue_on_teleport) ~= "function" then return end
    if _G.Loaded == true then task.wait(math.huge) end
    while task.wait(20) do
        _G.Loaded = true
        if game.PlaceId == 92175551837230 then
            local HttpService = game:GetService("HttpService")
            local url = "https://DanielNov2014alt.pythonanywhere.com/get"
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            if success then
                local decoded = HttpService:JSONDecode(response)
                print("Current value2 is:", decoded.value2)
                if decoded.value2 ~= 0 then
                    queue_on_teleport('print("hi") task.wait(3) loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/refs/heads/main/bot_scripts/bot_in_game.lua"))()')
                    game:GetService("TeleportService"):Teleport(decoded.value2)
                end
            else
                warn("Error fetching value2:", response)
            end
        end
    end
]]


    -- Try to use queue_on_teleport if present
    local queued_ok = safe_queue_on_teleport(queuedCode)

    -- If queue_on_teleport not available, pass the script URL via TeleportData as fallback
    if not queued_ok then
        set_teleport_data({ scriptUrl = "https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/refs/heads/main/bot_scripts/bot_in_game.lua" })
    end

    -- Teleport to hub/place (guarded)
    local suc, err = pcall(function() TeleportService:Teleport(92175551837230) end)
    if not suc then warn("Teleport failed:", err) end

    task.wait(15)
    pcall(function() game:Shutdown() end)
end)

-- If we arrived via TeleportService:SetTeleportData, try to run it
task.spawn(function()
    task.wait(1) -- small delay to allow TeleportData to be available
    run_teleport_data_if_present()
end)

-- Keep monitoring health
while task.wait(3) do
    local player = Players.LocalPlayer
    local char = player and player.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0 then
        Chat("AAAAAAAAAAAAA")
    end
end
