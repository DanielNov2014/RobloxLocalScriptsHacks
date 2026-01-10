--// ============================
--//  WEBSOCKET SETUP
--// ============================

local HttpService = game:GetService("HttpService")
local socket = WebSocket.connect("ws://127.0.0.1:8080")

local clientId = nil
local currentHost = nil
local isHost = false
local identified = false

local clientList = {}
local filteredList = {}

local includeHost = false
local allClients = false
local selectedClient = nil

-- Forward declarations (UI created later)
local UpdateHeader
local UpdateClientDropdown

local function send(tbl)
    socket:Send(HttpService:JSONEncode(tbl))
end

local function tryBecomeHost()
    if not identified then
        print("❌ Cannot request host — not identified yet")
        return
    end
    print("🔄 Requesting host role...")
    send({ type = "requestHost" })
end

--// ============================
--//  WEBSOCKET MESSAGE HANDLER
--// ============================

socket.OnMessage:Connect(function(raw)
    local msg = HttpService:JSONDecode(raw)
    -- CLIENT RECEIVES A COMMAND
if msg.type == "hostDirect" or msg.type == "hostMessage" then
    local cmd = msg.payload.command

    if cmd == "script1" then
        print("Running Script 1")
        local plr=game:GetService("Players").LocalPlayer
local char=plr.Character
local root=char.HumanoidRootPart
for i,v in workspace.Main.PointGivers:GetChildren() do
	-- Place this LocalScript in StarterPlayerScripts or StarterGui

	-- Target position to teleport to (Vector3)
	local targetPosition = v.Position

	-- Function to teleport the local player
	local function teleportPlayer(position)
		local player = game.Players.LocalPlayer
		if not player then
			warn("Local player not found.")
			return
		end

		local character = player.Character or player.CharacterAdded:Wait()
		local rootPart = character:FindFirstChild("HumanoidRootPart")

		if rootPart then
			-- Teleport instantly
			rootPart.CFrame = CFrame.new(position)
			print("Teleported to:", position)
		else
			warn("HumanoidRootPart not found. Cannot teleport.")
		end
	end

	-- Example: teleport after 3 seconds
	task.wait(0.5)
	teleportPlayer(targetPosition)

end
local function teleportPlayer(position)
	local player = game.Players.LocalPlayer
	if not player then
		warn("Local player not found.")
		return
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if rootPart then
		-- Teleport instantly
		rootPart.CFrame = CFrame.new(position)
		print("Teleported to:", position)
	else
		warn("HumanoidRootPart not found. Cannot teleport.")
	end
end
teleportPlayer(workspace.Main.AFK.Position)

    elseif cmd == "script2" then
        print("Running Script 2")
        task.wait(math.random(1,30))
local args = {
	"we at Team evon have upgradded our scripts to work 24/7 join today",
	true
}
game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Bridge"):WaitForChild("Remotes"):WaitForChild("NotifServiceBridge"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

    elseif cmd == "script3" then
        print("Running Script 3")
        -- LocalScript
-- Place this in StarterPlayerScripts or StarterCharacterScripts

-- Path to the folder containing the orb parts
local orbFolder = workspace:WaitForChild("Main"):WaitForChild("Orb"):WaitForChild("Orbs")

-- Get the local player's character
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wait until the character is loaded
local function getCharacter()
    local char = player.Character or player.CharacterAdded:Wait()
    return char
end

-- Function to fire touch on a part
local function fireTouch(part)
    local char = getCharacter()
    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and part:IsA("BasePart") then
        -- Simulate touch start
        firetouchinterest(humanoidRootPart, part, 0)
        -- Simulate touch end
        firetouchinterest(humanoidRootPart, part, 1)
    end
end

-- Loop through all descendants in the folder
for _, obj in ipairs(orbFolder:GetDescendants()) do
    if obj:IsA("BasePart") and obj:FindFirstChildOfClass("TouchTransmitter") then
        fireTouch(obj)
    end
end

print("All TouchInterests in Orbs folder have been fired.")

    end
end

    -- IDENTIFY
    if msg.type == "identify" then
        clientId = msg.id
        currentHost = msg.hostId
        identified = true

        if UpdateHeader then UpdateHeader() end
        return
    end

    -- HOST CHANGED
    if msg.type == "hostChanged" then
        currentHost = msg.hostId
        isHost = (clientId == currentHost)

        if UpdateHeader then UpdateHeader() end
        if UpdateClientDropdown then UpdateClientDropdown() end
        return
    end

    -- CLIENT LIST
    if msg.type == "clientList" then
        clientList = msg.list or {}
        if UpdateClientDropdown then UpdateClientDropdown() end
        return
    end

    -- CLIENT DISCONNECTED
    if msg.type == "clientDisconnected" then
        for i, id in ipairs(clientList) do
            if id == msg.id then
                table.remove(clientList, i)
                break
            end
        end
        if UpdateClientDropdown then UpdateClientDropdown() end
        return
    end

    -- HOST DENIED
    if msg.type == "hostDenied" then
        print("❌ Host request denied. Current host is:", msg.currentHost)
        return
    end
end)

--// ============================
--//  RAYFIELD UI
--// ============================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Client Control Panel",
    LoadingTitle = "WebSocket Control",
    LoadingSubtitle = "By Marina",
})

local Tab = Window:CreateTab("Control", 4483362458)

-- HEADER
local HeaderLabel = Tab:CreateParagraph({
    Title = "Client Info",
    Content = "Waiting for ID...",
})

UpdateHeader = function()
    if not clientId then return end
    local role = (clientId == currentHost) and "Host" or "Client"

    HeaderLabel:Set({
        Title = "Client Info",
        Content = "ID: " .. clientId .. "\nRole: " .. role
    })
end

-- DROPDOWN
local ClientDropdown = Tab:CreateDropdown({
    Name = "Select Client",
    Options = filteredList,
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(option)
        selectedClient = option
    end,
})

UpdateClientDropdown = function()
    filteredList = {}

    for _, id in ipairs(clientList) do
        if id ~= currentHost or includeHost then
            table.insert(filteredList, id)
        end
    end

    ClientDropdown:Refresh(filteredList, true)

    if selectedClient and not table.find(filteredList, selectedClient) then
        selectedClient = nil
    end
end

-- INCLUDE HOST TOGGLE
Tab:CreateToggle({
    Name = "Include Host In Dropdown",
    CurrentValue = false,
    Callback = function(value)
        includeHost = value
        UpdateClientDropdown()
    end,
})

-- ALL CLIENTS TOGGLE
Tab:CreateToggle({
    Name = "All Clients (Excludes Host)",
    CurrentValue = false,
    Callback = function(value)
        allClients = value
    end,
})

-- SEND COMMAND
local function sendCommand(cmd)
    if allClients then
        send({
            type = "hostBroadcast",
            payload = { command = cmd }
        })
        return
    end

    if not selectedClient then
        print("❌ No client selected")
        return
    end

    send({
        type = "hostDirect",
        toId = selectedClient,
        payload = { command = cmd }
    })
end

-- BUTTONS
Tab:CreateButton({
    Name = "Run Script 1",
    Callback = function()
        sendCommand("script1")
    end,
})

Tab:CreateButton({
    Name = "Run Script 2",
    Callback = function()
        sendCommand("script2")
    end,
})

Tab:CreateButton({
    Name = "Run Script 3",
    Callback = function()
        sendCommand("script3")
    end,
})

-- BECOME HOST
Tab:CreateButton({
    Name = "Become Host",
    Callback = function()
        tryBecomeHost()
    end,
})

print("UI + WebSocket ready.")
