local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local toolConnection = nil
local currentTool = nil

-- Variable to store saved position
local savedCFrame = nil

-- Helper function to get the tool the local player is currently holding
local function getHeldTool()
	if LocalPlayer.Character then
		for _, child in LocalPlayer.Character:GetChildren() do
			if child:IsA("Tool") then
				return child
			end
		end
	end
	return nil
end

-- Helper function to check if the ray to a target is blocked
local function isRayBlocked(origin, targetPos, targetCharacter)
	local direction = (targetPos - origin).Unit
	local ray = Ray.new(origin, direction * (targetPos - origin).Magnitude)
	local hitPart, hitPos = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
	if hitPart then
		-- Check if the hit part belongs to the target character
		if hitPart:IsDescendantOf(targetCharacter) then
			return false -- Not blocked
		else
			return true -- Blocked by something else
		end
	end
	return false -- Nothing hit, not blocked
end

-- Shoots a Ray at the closest player to the local player using RemoteBridge, only if not blocked
local function shootAtClosestUnblockedPlayer()
	local tool = getHeldTool()
	if not tool then
		print("No tool equipped")
		return
	end

	local RemoteBridge = tool:FindFirstChild("RemoteBridge")
	if not RemoteBridge then
		print("No RemoteBridge found in tool")
		return
	end

	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

	local origin = LocalPlayer.Character.HumanoidRootPart.Position
	local candidates = {}

	local projectileSpeed = 500 -- studs per second, matches ray length

	for _, player in Players:GetPlayers() do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
			local hrp = player.Character.HumanoidRootPart
			local humanoid = player.Character.Humanoid
			local charPos = hrp.Position
			local velocity = hrp.Velocity
			local dist = (charPos - origin).Magnitude

			local predictedPos = charPos
			if velocity.Magnitude > 0 then
				local timeToHit = dist / projectileSpeed
				predictedPos = charPos + velocity * timeToHit
			end

			local predictedDist = (predictedPos - origin).Magnitude
			table.insert(candidates, {player = player, character = player.Character, pos = predictedPos, dist = predictedDist, hrp = hrp})
		end
	end

	-- Sort candidates by distance
	table.sort(candidates, function(a, b)
		return a.dist < b.dist
	end)

	local targetPlayer = nil
	local targetPos = nil
	local targetDist = nil
	local targetHRP = nil

	for _, candidate in candidates do
		if not isRayBlocked(origin, candidate.pos, candidate.character) then
			targetPlayer = candidate.player
			targetPos = candidate.pos
			targetDist = candidate.dist
			targetHRP = candidate.hrp
			break
		end
	end

	if targetPlayer and targetPos and targetHRP then
		local direction = (targetPos - origin).Unit
		local ray = Ray.new(origin, direction * 500) -- 500 studs long, adjust as needed
		local args = { ray }
		if targetDist > 100 then
			-- Do NOT teleport or shoot if target is more than 100 studs away
			print("Target is more than 100 studs away, no teleport or shot.")
			return
		else
			RemoteBridge:FireServer(unpack(args))
			print("Shot at", targetPlayer.Name, "Distance:", targetDist)
		end
	else
		print("No unblocked target found")
	end
end

-- Teleport to the nearest player when "E" is pressed
local function teleportToNearestPlayer()
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

	local origin = LocalPlayer.Character.HumanoidRootPart.Position
	local nearestPlayer = nil
	local nearestDist = math.huge
	local nearestHRP = nil

	for _, player in Players:GetPlayers() do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local dist = (hrp.Position - origin).Magnitude
			if dist < nearestDist then
				nearestDist = dist
				nearestPlayer = player
				nearestHRP = hrp
			end
		end
	end

	if nearestPlayer and nearestHRP then
		local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			-- Calculate "behind" position based on target's lookVector
			local targetLook = nearestHRP.CFrame.LookVector
			local behindOffset = -targetLook * 3 -- 3 studs behind target
			local teleportPos = nearestHRP.Position + behindOffset

			-- Teleport local player behind the target
			hrp.CFrame = CFrame.new(teleportPos, nearestHRP.Position)
			print("Teleported behind", nearestPlayer.Name, "Distance:", nearestDist)
		end
	else
		print("No other players to teleport to.")
	end
end

-- Save current position when "P" is pressed
local function saveCurrentPosition()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
		print("Saved position:", savedCFrame.Position)
	else
		print("Cannot save position, HumanoidRootPart not found.")
	end
end

-- Teleport to saved position when "G" is pressed
local function teleportToSavedPosition()
	if savedCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = savedCFrame
		print("Teleported to saved position:", savedCFrame.Position)
	else
		print("No saved position to teleport to or HumanoidRootPart not found.")
	end
end

-- Listen for key presses
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	--if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.E then
		teleportToNearestPlayer()
	elseif input.KeyCode == Enum.KeyCode.P then
		saveCurrentPosition()
	elseif input.KeyCode == Enum.KeyCode.F then
		teleportToSavedPosition()
	end
end)

-- Disconnect previous tool Activated connection
local function disconnectToolListener()
	if toolConnection then
		toolConnection:Disconnect()
		toolConnection = nil
	end
	currentTool = nil
end

-- Connect to the tool's Activated event
local function setupToolListener()
	disconnectToolListener()
	local tool = getHeldTool()
	if tool then
		currentTool = tool
		toolConnection = tool.Activated:Connect(function()
			shootAtClosestUnblockedPlayer()
		end)
	end
end

-- Listen for tool equipped/unequipped
local function listenForToolChanges(character)
	-- Listen for new tools being equipped
	character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			setupToolListener()
		end
	end)
	character.ChildRemoved:Connect(function(child)
		if child:IsA("Tool") then
			setupToolListener()
		end
	end)
	-- Initial setup
	setupToolListener()
end

-- Listen for character respawn
LocalPlayer.CharacterAdded:Connect(function(character)
	disconnectToolListener()
	listenForToolChanges(character)
end)

-- If already spawned, set up listeners
if LocalPlayer.Character then
	listenForToolChanges(LocalPlayer.Character)
end

