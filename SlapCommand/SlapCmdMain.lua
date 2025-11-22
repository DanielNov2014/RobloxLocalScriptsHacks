--this script works in all games with a slap that has a remotevent called "Event"
--heres the loadstring! loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/refs/heads/main/SlapCommand/SlapCmdMain.lua"))()
--heres some games that this script works in
--1. https://www.roblox.com/games/96401319196513/FREE-ALL-Slap-Tower-3-MODDED
--2. https://www.roblox.com/games/96401319196513/FREE-ALL-Slap-Tower-3-MODDED (you cant use custom power so kill wont work)
--3. https://www.roblox.com/games/121347585984680/Green-Bean-SLAP-Tower
--4. https://www.roblox.com/games/113679072768135/Free-Admin-Slap-Tower-Obby-BRAINROT
--5. https://www.roblox.com/games/110876351628508/Wallhop-Slap-Tower
--6. https://www.roblox.com/games/91711653427804/Slap-Tower-7 (but theres like a 5 sceond cooldown for each player to get slap)
--7. https://www.roblox.com/games/104002488192102/Omega-Troll-Slap-Tower
--8. https://www.roblox.com/games/80975682515398/EZ-Troll-Tower (you need to wait 5 minutes befor getting slap)
print("version v 9.6.9")
local slap = nil
local selectingPlayer = false
local mouseConnection = nil
local flingSelectMode = false
local killSelectMode = false
local highlightInstance = nil
local infoBillboard = nil
local isreplitentactive = false
local SlapLogs = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local TextLabel = Instance.new("TextLabel")
local QuickCommands = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local flingplus = Instance.new("TextButton")
local nearby = Instance.new("TextButton")
local kill = Instance.new("TextButton")
local fling = Instance.new("TextButton")
local blacklist = {}

-- Camera orbit variables
local orbitConnection = nil
local orbiting = false
local orbitTarget = nil
local orbitAngle = 0
local orbitRadius = 15
local orbitSpeed = math.rad(60) -- degrees per second, in radians

function AddLog(text:string)
	local textlog = TextLabel:Clone()
	textlog.Visible = true
	textlog.Text = text
	textlog.Parent = Frame
	game.Debris:AddItem(textlog, 10)
end

local function Nofiction(text:string)
	local executor = nil
	task.spawn(function()
		executor = identifyexecutor():split(" ")[1]
		print(executor)
	end)
	if executor == nil then executor = "delta" end
	game.StarterGui:SetCore("SendNotification", {
		Title = "["..executor.."]",
		Text = text,
		Icon = "rbxassetid://105343441215108",
		Duration = 5
	})
end

local function checkBlackList(plrname:string)
	if table.find(blacklist,plrname) then
		return true
	else
		return false
	end
end

local function AddBlackListRemove(plrname:string)
	if not checkBlackList(plrname) then
		table.insert(blacklist,plrname)
	else
		table.remove(blacklist,table.find(blacklist,plrname))
	end
end

function findslap()
	for i,v in workspace[game.Players.LocalPlayer.Name]:GetDescendants() do
		if v.Name == "Event" then
			local slaptool = v.Parent
			print(slaptool.Name)
			return slaptool
		end
	end
	for i,v in game.Players.LocalPlayer.Backpack:GetDescendants() do
		if v.Name == "Event" then
			local slaptool = v.Parent
			print(slaptool.Name)
			return slaptool
		end
	end
end

function hit(plr)
	if not checkBlackList(plr.Name) then
		local args = {
			"slash",
			game:GetService("Players"):WaitForChild(plr.Name).Character,
			Vector3.new(math.random(1,20),10,math.random(1,20))
		}
		task.spawn(function()
			slap.Event:FireServer(unpack(args))
		end)
	end
end

function killslap(plr)
	if not checkBlackList(plr.Name) then
		local args = {
			"slash",
			game:GetService("Players"):WaitForChild(plr.Name).Character,
			Vector3.new(10000000,10000000,1000000)
		}
		task.spawn(function()
			slap.Event:FireServer(unpack(args))
		end)
	end
end

function highlightPlayer(plr)
	-- Remove previous highlight
	if highlightInstance then
		highlightInstance:Destroy()
		highlightInstance = nil
	end
	if plr and plr.Character then
		local Highlight = Instance.new("Highlight")
		Highlight.Adornee = plr.Character
		Highlight.FillColor = Color3.fromRGB(255, 255, 0)
		Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
		Highlight.Parent = plr.Character
		highlightInstance = Highlight
	end
end

function removeHighlight()
	if highlightInstance then
		highlightInstance:Destroy()
		highlightInstance = nil
	end
end

function showInfoBillboard(plr)
	-- Remove previous info
	if infoBillboard then
		infoBillboard:Destroy()
		infoBillboard = nil
	end
	if plr and plr.Character and plr.Character:FindFirstChild("Head") then
		local bb = Instance.new("BillboardGui")
		bb.Name = "PlayerInfoBillboard"
		bb.Adornee = plr.Character.Head
		bb.Size = UDim2.new(0, 200, 0, 50)
		bb.StudsOffset = Vector3.new(0, 2.5, 0)
		bb.AlwaysOnTop = true

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.fromRGB(255,255,0)
		nameLabel.TextStrokeTransparency = 0.5
		nameLabel.Font = Enum.Font.SourceSansBold
		nameLabel.TextScaled = true
		nameLabel.Text = plr.DisplayName

		local userLabel = Instance.new("TextLabel")
		userLabel.Position = UDim2.new(0, 0, 0.5, 0)
		userLabel.Size = UDim2.new(1, 0, 0.5, 0)
		userLabel.BackgroundTransparency = 1
		userLabel.TextColor3 = Color3.fromRGB(255,255,255)
		userLabel.TextStrokeTransparency = 0.5
		userLabel.Font = Enum.Font.SourceSans
		userLabel.TextScaled = true
		userLabel.Text = "(@" .. plr.Name .. ")"

		nameLabel.Parent = bb
		userLabel.Parent = bb
		bb.Parent = plr.Character.Head
		infoBillboard = bb
	end
end

function removeInfoBillboard()
	if infoBillboard then
		infoBillboard:Destroy()
		infoBillboard = nil
	end
end

function enablePlayerSelection()
	print("active")
	selectingPlayer = true
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	mouse.Icon = "rbxassetid://6035047400" -- Optional: change mouse icon for selection mode

	mouseConnection = mouse.Button1Down:Connect(function()
		if not selectingPlayer then return end
		local target = mouse.Target
		if target then
			local targetParent = target.Parent
			for _, plr in game.Players:GetPlayers() do
				if plr ~= player and plr.Character and (plr.Character == targetParent or target:IsDescendantOf(plr.Character)) then
					AddLog("flinging "..plr.Name)
					hit(plr)
					selectingPlayer = false
					mouse.Icon = "" -- Reset mouse icon
					if mouseConnection then
						mouseConnection:Disconnect()
						mouseConnection = nil
					end
					break
				end
			end
		end
	end)
end

function enablePlayerSelectionKill()
	print("active")
	selectingPlayer = true
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	mouse.Icon = "rbxassetid://6035047400" -- Optional: change mouse icon for selection mode

	mouseConnection = mouse.Button1Down:Connect(function()
		if not selectingPlayer then return end
		local target = mouse.Target
		if target then
			local targetParent = target.Parent
			for _, plr in game.Players:GetPlayers() do
				if plr ~= player and plr.Character and (plr.Character == targetParent or target:IsDescendantOf(plr.Character)) then
					AddLog("killing "..plr.Name)
					killslap(plr)
					selectingPlayer = false
					mouse.Icon = "" -- Reset mouse icon
					if mouseConnection then
						mouseConnection:Disconnect()
						mouseConnection = nil
					end
					break
				end
			end
		end
	end)
end

function enableFlingSelectMode()
	if mouseConnection then
		mouseConnection:Disconnect()
		mouseConnection = nil
	end
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	mouse.Icon = "rbxassetid://6035047400"
	mouseConnection = mouse.Button1Down:Connect(function()
		if not flingSelectMode then return end
		local target = mouse.Target
		if target then
			local targetParent = target.Parent
			for _, plr in game.Players:GetPlayers() do
				if plr ~= player and plr.Character and (plr.Character == targetParent or target:IsDescendantOf(plr.Character)) then
					AddLog("flinging "..plr.Name)
					hit(plr)
					highlightPlayer(plr)
					showInfoBillboard(plr)
					-- Remove highlight and info after fling
					task.delay(0.5, function()
						removeHighlight()
						removeInfoBillboard()
					end)
					break
				end
			end
		end
	end)
end

function enableKillSelectMode()
	if mouseConnection then
		mouseConnection:Disconnect()
		mouseConnection = nil
	end
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	mouse.Icon = "rbxassetid://6035047400"
	mouseConnection = mouse.Button1Down:Connect(function()
		if not killSelectMode then return end
		local target = mouse.Target
		if target then
			local targetParent = target.Parent
			for _, plr in game.Players:GetPlayers() do
				if plr ~= player and plr.Character and (plr.Character == targetParent or target:IsDescendantOf(plr.Character)) then
					AddLog("killing "..plr.Name)
					killslap(plr)
					highlightPlayer(plr)
					showInfoBillboard(plr)
					-- Remove highlight and info after kill fling
					task.delay(0.5, function()
						removeHighlight()
						removeInfoBillboard()
					end)
					break
				end
			end
		end
	end)
end

function disableFlingSelectMode()
	if mouseConnection then
		mouseConnection:Disconnect()
		mouseConnection = nil
	end
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	mouse.Icon = ""
	removeHighlight()
	removeInfoBillboard()
end

function disableKillSelectMode()
	if mouseConnection then
		mouseConnection:Disconnect()
		mouseConnection = nil
	end
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	mouse.Icon = ""
	removeHighlight()
	removeInfoBillboard()
end

-- Camera Orbit Functions

function startOrbitCameraAroundRandomPlayer()
	if orbiting then
		AddLog("Already orbiting a player.")
		return
	end
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local others = {}
	for i, plr in Players:GetPlayers() do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(others, plr)
		end
	end
	if #others == 0 then
		AddLog("No other players to orbit.")
		return
	end
	local randomIndex = math.random(1, #others)
	local targetPlayer = others[randomIndex]
	local targetChar = targetPlayer.Character
	local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetRoot then
		AddLog("Target player has no HumanoidRootPart.")
		return
	end
	orbitTarget = targetRoot
	orbiting = true
	orbitAngle = 0
	AddLog("Orbiting camera around "..targetPlayer.Name)
	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable
	orbitConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
		if not orbiting or not orbitTarget or not orbitTarget.Parent then
			stopOrbitCamera()
			startOrbitCameraAroundRandomPlayer()
			return
		end
		orbitAngle = orbitAngle + orbitSpeed * dt
		local targetPos = orbitTarget.Position
		local camPos = targetPos + Vector3.new(math.cos(orbitAngle) * orbitRadius, 5, math.sin(orbitAngle) * orbitRadius)
		camera.CFrame = CFrame.new(camPos, targetPos)
	end)
end

function stopOrbitCamera()
	if orbitConnection then
		orbitConnection:Disconnect()
		orbitConnection = nil
	end
	orbiting = false
	orbitTarget = nil
	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Custom
	AddLog("Stopped orbiting camera.")
end

-- Expose to _G for easy access
_G.startOrbitCameraAroundRandomPlayer = startOrbitCameraAroundRandomPlayer
_G.stopOrbitCamera = stopOrbitCamera

--[[ PARSING FUNCTION ]]--
function parseCommand(raw)
	-- Example: /fling random 5
	-- Returns: {command="fling", type="random", amount=5}
	local result = {}
	local args = string.split(raw, " ")
	result.command = args[1] and args[1]:gsub("/", "") or ""
	result.type = args[2] or ""
	result.amount = tonumber(args[3]) or 1
	-- Special handling for friends/nonfriends
	if result.type:lower() == "friends" or result.type:lower() == "freinds" then
		result.type = "friends"
	elseif result.type:lower() == "nonfriends" or result.type:lower() == "nonfreinds" then
		result.type = "nonfriends"
	end
	return result
end

slap = findslap()
if slap ~= nil then

	SlapLogs.Name = "SlapLogs"
	SlapLogs.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	SlapLogs.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SlapLogs.DisplayOrder = 999999999

	Frame.Parent = SlapLogs
	Frame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.0194444451, 0, 0.692889571, 0)
	Frame.Size = UDim2.new(0.3, 0, 0.290468991, 0)
	Frame.ZIndex = 999999

	UIListLayout.Parent = Frame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	TextLabel.Name = "Example_text"
	TextLabel.Parent = Frame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, 0, 0.0885416642, 0)
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.Text = "Loaded Succesfully"
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14.000
	TextLabel.TextWrapped = true
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Visible = false

	QuickCommands.Name = "QuickCommands"
	QuickCommands.Parent = SlapLogs
	QuickCommands.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
	QuickCommands.BorderColor3 = Color3.fromRGB(0, 0, 0)
	QuickCommands.BorderSizePixel = 0
	QuickCommands.Position = UDim2.new(0.330555558, 0, 0.691376686, 0)
	QuickCommands.Size = UDim2.new(0.144444451, 0, 0.291981846, 0)
	QuickCommands.ZIndex = 999999

	Title.Name = "Title"
	Title.Parent = QuickCommands
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title.BorderSizePixel = 0
	Title.Size = UDim2.new(1, 0, 0.119629756, 0)
	Title.Font = Enum.Font.SourceSans
	Title.Text = "Quick commands"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextScaled = true
	Title.TextSize = 14.000
	Title.TextWrapped = true

	flingplus.Name = "flingplus"
	flingplus.Parent = QuickCommands
	flingplus.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
	flingplus.BorderColor3 = Color3.fromRGB(0, 0, 0)
	flingplus.BorderSizePixel = 0
	flingplus.Position = UDim2.new(0, 0, 0.417098433, 0)
	flingplus.Size = UDim2.new(1, 0, 0.0906735733, 0)
	flingplus.Font = Enum.Font.SourceSans
	flingplus.Text = "fling all out of the obby"
	flingplus.TextColor3 = Color3.fromRGB(0, 0, 0)
	flingplus.TextScaled = true
	flingplus.TextSize = 14.000
	flingplus.TextWrapped = true

	nearby.Name = "nearby"
	nearby.Parent = QuickCommands
	nearby.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
	nearby.BorderColor3 = Color3.fromRGB(0, 0, 0)
	nearby.BorderSizePixel = 0
	nearby.Position = UDim2.new(0, 0, 0.326424867, 0)
	nearby.Size = UDim2.new(1, 0, 0.0906735733, 0)
	nearby.Font = Enum.Font.SourceSans
	nearby.Text = "fling nearby players (ON)"
	nearby.TextColor3 = Color3.fromRGB(0, 0, 0)
	nearby.TextScaled = true
	nearby.TextSize = 14.000
	nearby.TextWrapped = true

	kill.Name = "kill"
	kill.Parent = QuickCommands
	kill.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
	kill.BorderColor3 = Color3.fromRGB(0, 0, 0)
	kill.BorderSizePixel = 0
	kill.Position = UDim2.new(0, 0, 0.235751301, 0)
	kill.Size = UDim2.new(1, 0, 0.0906735733, 0)
	kill.Font = Enum.Font.SourceSans
	kill.Text = "kill all"
	kill.TextColor3 = Color3.fromRGB(0, 0, 0)
	kill.TextScaled = true
	kill.TextSize = 14.000
	kill.TextWrapped = true

	fling.Name = "fling"
	fling.Parent = QuickCommands
	fling.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
	fling.BorderColor3 = Color3.fromRGB(0, 0, 0)
	fling.BorderSizePixel = 0
	fling.Position = UDim2.new(0, 0, 0.14507772, 0)
	fling.Size = UDim2.new(1, 0, 0.0906735733, 0)
	fling.Font = Enum.Font.SourceSans
	fling.Text = "fling all"
	fling.TextColor3 = Color3.fromRGB(0, 0, 0)
	fling.TextScaled = true
	fling.TextSize = 14.000
	fling.TextWrapped = true

	flingplus.MouseButton1Click:Connect(function()
		task.spawn(function()
			AddLog("[DEBUG] flingplus command active")
			startOrbitCameraAroundRandomPlayer()
			for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					AddLog("Flinging "..player.Name .. " out of the obby")
					task.spawn(function()
						repeat
							local args = {
								"slash",
								player.Character,
								Vector3.new(math.random(-30,30),30,math.random(-30,30))
							}
							task.spawn(function()
								slap.Event:FireServer(unpack(args))
							end)
							task.wait(0.1)
						until player.Character:WaitForChild("HumanoidRootPart").Position.Y >= 1610
						task.wait(2)
						repeat
							local args = {
								"slash",
								player.Character,
								Vector3.new(100,10,0)
							}
							task.spawn(function()
								slap.Event:FireServer(unpack(args))
							end)
							task.wait(0.1)
						until player.Character:WaitForChild("HumanoidRootPart").Position.X >= 300
						repeat
							local args = {
								"slash",
								player.Character,
								Vector3.new(0,10,100)
							}
							task.spawn(function()
								slap.Event:FireServer(unpack(args))
							end)
							task.wait(0.1)
						until player.Character:WaitForChild("HumanoidRootPart").Position.Z >= 300
						repeat
							task.wait()
						until player.Character:WaitForChild("HumanoidRootPart").Position.Y <= 150
						for i = 1,30 do
							repeat
								local args = {
									"slash",
									player.Character,
									Vector3.new(0,50,0)
								}
								task.spawn(function()
									slap.Event:FireServer(unpack(args))
								end)
								task.wait(0.1)
							until player.Character:WaitForChild("HumanoidRootPart").Position.Y >= 300
							AddLog("Loop (" .. i .. "/30) comepleted! on " .. player.Name)
						end
						task.wait(0.05)
					end)
				end
			end
			task.wait(40)
			print("done")
			stopOrbitCamera()
		end)
	end)

	nearby.MouseButton1Click:Connect(function()
		if nearby.Text == "fling nearby players (OFF)" then
			nearby.Text = "fling nearby players (ON)"
			isreplitentactive = true
		else
			nearby.Text = "fling nearby players (OFF)"
			isreplitentactive = false
		end
	end)

	kill.MouseButton1Click:Connect(function()
		task.spawn(function()
			AddLog("[DEBUG] kill command active")
			for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					AddLog("Killing "..player.Name)
					killslap(player)
					task.wait(0.05)
				end
			end
		end)
	end)
	fling.MouseButton1Click:Connect(function()
		task.spawn(function()
			AddLog("[DEBUG] fling command active")
			for _, player in game.Players:GetPlayers() do
				if player ~= game.Players.LocalPlayer then
					AddLog("Flinging "..player.Name)
					hit(player)
					task.wait(0.05)
				end
			end
		end)
	end)

	AddLog("Loaded Succesfully.")
	AddLog("[DEBUG] slap tool location: game"..slap:GetFullName())
	game.Players.LocalPlayer.Chatted:Connect(function(msg)
		local parsed = parseCommand(msg)
		local command = parsed.command
		local type = parsed.type
		local amount = parsed.amount

		if command == "fling" then
			AddLog("[DEBUG] fling command active")
			local localPlayer = game.Players.LocalPlayer
			if type == "" then
				enablePlayerSelection()
			elseif type == "all" then
				for i = 1, amount do
				for _, player in game.Players:GetPlayers() do
					if player ~= localPlayer then
						if player.Character then
							AddLog("Flinging "..player.Name)
							hit(player)
							task.wait(0.05)
						end
					end
				end
				end
			elseif type == "random" then
				local players = game.Players:GetPlayers()
				for i = 1, amount do
					local randomPlayer = players[math.random(1, #players)]
					if randomPlayer ~= localPlayer then
						if randomPlayer.Character then
							AddLog("Flinging "..randomPlayer.Name)
							hit(randomPlayer)
							task.wait(0.05)
						end
					end
				end
			elseif type == "friends" then
				for _, player in game.Players:GetPlayers() do
					for i = 1, amount do
					if player ~= localPlayer and localPlayer:IsFriendsWith(player.UserId) then
						if player.Character then
							AddLog("Flinging friend "..player.Name)
							hit(player)
							task.wait(0.05)
						end
					end
					end
				end
			elseif type == "nonfriends" then
				for i = 1, amount do
				for _, player in game.Players:GetPlayers() do
					if player ~= localPlayer and not localPlayer:IsFriendsWith(player.UserId) then
						if player.Character then
							AddLog("Flinging non-friend "..player.Name)
							hit(player)
							task.wait(0.05)
						end
					end
				end
				end
			else
				for _, player in game.Players:GetPlayers() do
					if player.Name == type then
						if player.Character then
							for i = 1, amount do
							hit(player)
							end
						end
					end
				end
			end
		elseif command == "kill" then
			AddLog("[DEBUG] kill command active")
			local localPlayer = game.Players.LocalPlayer
			if type == "" then
				enablePlayerSelectionKill()
			elseif type == "all" then
				for _, player in game.Players:GetPlayers() do
					if player ~= localPlayer then
						AddLog("Killing "..player.Name)
						killslap(player)
						task.wait(0.05)
					end
				end
			elseif type == "random" then
				local players = game.Players:GetPlayers()
				for i = 1, amount do
					local randomPlayer = players[math.random(1, #players)]
					if randomPlayer ~= localPlayer then
						if randomPlayer.Character then
							AddLog("Killing "..randomPlayer.Name)
							killslap(randomPlayer)
							task.wait(0.05)
						end
					end
				end
			elseif type == "friends" then
				for _, player in game.Players:GetPlayers() do
					if player ~= localPlayer and localPlayer:IsFriendsWith(player.UserId) then
						if player.Character then
							AddLog("Killing friend "..player.Name)
							killslap(player)
							task.wait(0.05)
						end
					end
				end
			elseif type == "nonfriends" then
				for _, player in game.Players:GetPlayers() do
					if player ~= localPlayer and not localPlayer:IsFriendsWith(player.UserId) then
						if player.Character then
							AddLog("Killing non-friend "..player.Name)
							killslap(player)
							task.wait(0.05)
						end
					end
				end
			else
				for _, player in game.Players:GetPlayers() do
					if player.Name == type then
						AddLog("Killing "..player.Name)
						killslap(player)
					end
				end
			end
		elseif command == "blacklist" then
			AddLog("[DEBUG] blacklist command active")
			local localPlayer = game.Players.LocalPlayer
			if type == "" then
				Nofiction("Blacklist players")
				task.wait(0.2)
				for i,v in blacklist do
					Nofiction("black list info: "..v)
					task.wait(0.2)
				end
			elseif type == "all" then
				for _, player in game.Players:GetPlayers() do
					if player ~= localPlayer then
						AddLog("Blacklisting "..player.Name)
						AddBlackListRemove(player.Name)
						task.wait(0.05)
					end
				end
			elseif type == "random" then
				local players = game.Players:GetPlayers()
				for i = 1, amount do
					local randomPlayer = players[math.random(1, #players)]
					if randomPlayer ~= localPlayer then
						if randomPlayer.Character then
							AddLog("Blacklisting "..randomPlayer.Name)
							AddBlackListRemove(randomPlayer.Name)
							task.wait(0.05)
						end
					end
				end
			elseif type == "friends" then
				for _, player in game.Players:GetPlayers() do
					for i = 1, amount do
					if player ~= localPlayer and localPlayer:IsFriendsWith(player.UserId) then
						if player.Character then
							AddLog("Blacklisting friend "..player.Name)
							AddBlackListRemove(player.Name)
							task.wait(0.05)
						end
					end
					end
				end
			elseif type == "nonfriends" then
				for _, player in game.Players:GetPlayers() do
					for i = 1, amount do
					if player ~= localPlayer and not localPlayer:IsFriendsWith(player.UserId) then
						if player.Character then
							AddLog("Blacklisting non-friend "..player.Name)
							AddBlackListRemove(player.Name)
							task.wait(0.05)
						end
					end
					end
				end
			else
				for _, player in game.Players:GetPlayers() do
					if player.Name == type then
						AddLog("Blacklisting "..player.Name)
						AddBlackListRemove(player.Name)
					end
				end
			end
		elseif command == "flingselect" then
			flingSelectMode = not flingSelectMode
			if flingSelectMode then
				killSelectMode = false
				enableFlingSelectMode()
				print("Fling select mode enabled")
			else
				disableFlingSelectMode()
				print("Fling select mode disabled")
			end
		elseif command == "killselect" then
			killSelectMode = not killSelectMode
			if killSelectMode then
				flingSelectMode = false
				enableKillSelectMode()
				print("Kill select mode enabled")
			else
				disableKillSelectMode()
				print("Kill select mode disabled")
			end
		elseif command == "orbit" then
			startOrbitCameraAroundRandomPlayer()
		elseif command == "stoporbit" then
			stopOrbitCamera()
		end
	end)
end

function getCharacterRootPart(character)
	if character then
		return character:FindFirstChild("HumanoidRootPart")
	end
	return nil
end

task.spawn(function()
	while true do
		if isreplitentactive then
			local localCharacter = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.Character.CharacterAdded:Wait()
			local localRoot = getCharacterRootPart(localCharacter)
			if localRoot then
				for i, player in game.Players:GetPlayers() do
					-- This will check ALL players, including the local player
					local character = player.Character
					local root = getCharacterRootPart(character)
					if root then
						local distance = (localRoot.Position - root.Position).Magnitude
						if distance <= 20 then
							if player.Name ~= game.Players.LocalPlayer.Name then
								print(player.Name .. " is within 20 studs!")
								hit(player)
							end
						end
					end
				end
			end
		end
		task.wait(0.1)
	end
end)



