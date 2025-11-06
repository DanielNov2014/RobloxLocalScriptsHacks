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
print("version test v 9.1")
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
	local args = {
		"slash",
		game:GetService("Players"):WaitForChild(plr.Name).Character,
		Vector3.new(math.random(1,20),10,math.random(1,20))
	}
	task.spawn(function()
		slap.Event:FireServer(unpack(args))
	end)
end

function killslap(plr)
	local args = {
		"slash",
		game:GetService("Players"):WaitForChild(plr.Name).Character,
		Vector3.new(10000000,10000000,1000000)
	}
	task.spawn(function()
		slap.Event:FireServer(unpack(args))
	end)
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
								Vector3.new(0,150,0)
							}
							task.spawn(function()
								slap.Event:FireServer(unpack(args))
							end)
							AddLog(player.Name .. "is not high enough fling again...")
							task.wait(0.1)
						until player.Character:FindFirstChild("HumanoidRootPart").Position.Y >= 1610
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
						until player.Character:FindFirstChild("HumanoidRootPart").Position.X >= 300
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
						until player.Character:FindFirstChild("HumanoidRootPart").Position.Z >= 300
						repeat
							task.wait()
						until player.Character:FindFirstChild("HumanoidRootPart").Position.Y <= 150
						for i = 1,10 do
							repeat
								local args = {
									"slash",
									player.Character,
									Vector3.new(0,10,0)
								}
								task.spawn(function()
									slap.Event:FireServer(unpack(args))
								end)
								task.wait(0.1)
							until player.Character:FindFirstChild("HumanoidRootPart").Position.Y >= 300
							AddLog("Loop (" .. i .. "/10) comepleted!")
						end
						task.wait(0.05)
					end)
				end
			end
			task.wait(40)
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
	AddLog("[DEBUG] slap tool location: "..slap:GetFullName())
	game.Players.LocalPlayer.Chatted:Connect(function(msg)
		local args = string.split(msg, " ")
		print(args[1],args[2])
		if args[1] == "/fling" then
			AddLog("[DEBUG] fling command active")
			if args[2] == nil or args[2] == "" then
				enablePlayerSelection()
			elseif args[2] == "all" then
				for _, player in game.Players:GetPlayers() do
					if player ~= game.Players.LocalPlayer then
						if player.Character then
							AddLog("Flinging "..player.Name)
							hit(player)
							task.wait(0.05)
						end
					end
				end
			elseif args[2] == "random" then
				local players = game.Players:GetPlayers()
				if args[3] == nil then
					args[3] = 1
				end
				for i = 1,args[3] do
					local randomPlayer = players[math.random(1, #players)]
					if randomPlayer ~= game.Players.LocalPlayer then
						if randomPlayer.Character then
							AddLog("Flinging "..randomPlayer.Name)
							hit(randomPlayer)
							task.wait(0.05)
						end
					end
				end
			else
				for _, player in game.Players:GetPlayers() do
					if player.Name == args[2] then
						if player.Character then
							hit(player)
						end
					end
				end
			end
		elseif args[1] == "/kill" then
			AddLog("[DEBUG] kill command active")
			if args[2] == nil or args[2] == "" then
				enablePlayerSelectionKill()
			elseif args[2] == "all" then
				for _, player in game.Players:GetPlayers() do
					if player ~= game.Players.LocalPlayer then
						AddLog("Killing "..player.Name)
						killslap(player)
						task.wait(0.05)
					end
				end
			elseif args[2] == "random" then
				local players = game.Players:GetPlayers()
				if args[3] == nil then
					args[3] = 1
				end
				for i = 1,args[3] do
					local randomPlayer = players[math.random(1, #players)]
					if randomPlayer ~= game.Players.LocalPlayer then
						if randomPlayer.Character then
							AddLog("Killing "..randomPlayer.Name)
							killslap(randomPlayer)
							task.wait(0.05)
						end
					end
				end
			else
				for _, player in game.Players:GetPlayers() do
					if player.Name == args[2] then
						AddLog("Killing "..player.Name)
						killslap(player)
					end
				end
			end
		elseif args[1] == "/flingselect" then
			flingSelectMode = not flingSelectMode
			if flingSelectMode then
				killSelectMode = false
				enableFlingSelectMode()
				print("Fling select mode enabled")
			else
				disableFlingSelectMode()
				print("Fling select mode disabled")
			end
		elseif args[1] == "/killselect" then
			killSelectMode = not killSelectMode
			if killSelectMode then
				flingSelectMode = false
				enableKillSelectMode()
				print("Kill select mode enabled")
			else
				disableKillSelectMode()
				print("Kill select mode disabled")
			end
		elseif args[1] == "/orbit" then
			startOrbitCameraAroundRandomPlayer()
		elseif args[1] == "/stoporbit" then
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
		task.wait(0.5)
	end
end)

