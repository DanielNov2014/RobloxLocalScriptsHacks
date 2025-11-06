--this script works in all games with a slap that has a remotevent called "Event"
--heres the loadstring! loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/refs/heads/main/SlapCommand/SlapCmdMain.lua"))()
--heres some games that this script works in
--1. https://www.roblox.com/games/96401319196513/FREE-ALL-Slap-Tower-3-MODDED
--2. https://www.roblox.com/games/96401319196513/FREE-ALL-Slap-Tower-3-MODDED (you cant use custom power so kill wont work)
local slap = nil
local selectingPlayer = false
local mouseConnection = nil
local flingSelectMode = false
local killSelectMode = false
local highlightInstance = nil
local infoBillboard = nil

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

slap = findslap()
if slap ~= nil then
	game.Players.LocalPlayer.Chatted:Connect(function(msg)
		local args = string.split(msg, " ")
		print(args[1],args[2])
		if args[1] == "/fling" then
			if args[2] == nil or args[2] == "" then
				enablePlayerSelection()
			elseif args[2] == "all" then
				for _, player in game.Players:GetPlayers() do
					if player ~= game.Players.LocalPlayer then
						if player.Character then
							hit(player)
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
			if args[2] == "all" then
				for _, player in game.Players:GetPlayers() do
					if player ~= game.Players.LocalPlayer then
						killslap(player)
					end
				end
			else
				for _, player in game.Players:GetPlayers() do
					if player.Name == args[2] then
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
		end
	end)
end
