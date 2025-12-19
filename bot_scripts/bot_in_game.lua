

local function reset()
	local HttpService = game:GetService("HttpService")

	local url = "https://DanielNov2014alt.pythonanywhere.com/reset/value2"

	local success, response = pcall(function()
		return game:HttpGet(url)
	end)

	if success then
		local decoded = HttpService:JSONDecode(response)
		print("After reset, value2 is:", decoded.value2)

	else
		warn("Error resetting value2:", response)
	end
end
local function Chat(string:string)
	local isLegacyChat = game.TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService
	if not isLegacyChat then
		game.TextChatService.TextChannels.RBXGeneral:SendAsync(string)
	else
		game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(string, "All")
	end
end
local function MoveRandom()
	game.Players.LocalPlayer.Character.Humanoid:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-50,50),0,math.random(-50,50)))
end
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
task.delay(120,function()
	Chat("gotta go")
	queue_on_teleport([[
		while task.wait(20) do
	if _G.Loaded == true then
		task.wait(math.huge)
	end
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
	else
		warn("Error fetching value2:", response)
	end
	local decoded = HttpService:JSONDecode(response)
	if decoded.value2 ~= 0 then
		game["Teleport Service"]:Teleport(decoded.value2)
		queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/refs/heads/main/bot_scripts/bot_in_game.lua))()')
	end
	end
end
	]])
	game["Teleport Service"]:Teleport(95551312148536)
	task.wait(5)
	game:Shutdown()
end)
while task.wait(3) do
	if game.Players.LocalPlayer.Character.Humanoid.Health <= 0 then
		Chat("AAAAAAAAAAAAA")
	end
end
