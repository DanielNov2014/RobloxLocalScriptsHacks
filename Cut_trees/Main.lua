--for i,v in workspace.TreesFolder:GetChildren() do
--	local args = {
--		"damage",
--		v.Name
--	}
--	game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Tree"):FireServer(unpack(args))
--end
--for i,v in workspace.ChestFolder:GetChildren() do
--	if v:FindFirstChild("Hitpart") then
--		v:PivotTo(game.Players.LocalPlayer.Character.Head.CFrame)
--		--game.Players.LocalPlayer.Character:PivotTo(v.root.CFrame)
--		task.wait(0.15)
--		fireproximityprompt(v.Hitpart.ProximityPrompt)
--	end
--end
--script: loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/refs/heads/main/Cut_trees/Main.lua",true))()
debugX = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Cut trees farm",
	Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "cut trees farm [BETA] v 1.2",
	LoadingSubtitle = "by DaniBoyNov2014",
	Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "Auto tress"
	},

	Discord = {
		Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
		Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
		RememberJoins = true -- Set this to false to make them join the discord every time they load it up
	},

	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Untitled",
		Subtitle = "Key System",
		Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
		FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})
local autochestime = 60
local Tab = Window:CreateTab("Auto chest", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Auto chest")

local Slider = Tab:CreateSlider({
	Name = "Auto chest time",
	Range = {10, 100},
	Increment = 5,
	Suffix = "Seconds",
	CurrentValue = 10,
	Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		autochestime = Value
	end,
})
local Slider1 = Tab:CreateSlider({
	Name = "Collect amout of chests",
	Range = {10, 300},
	Increment = 5,
	Suffix = "Chests",
	CurrentValue = 50,
	Flag = "Slider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		print(Slider.CurrentValue)
	end,
})

local Button5 = Tab:CreateButton({
	Name = "Collect amout of chests",
	Callback = function()
		local stopped = false
		local UIS = game:GetService("UserInputService")
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local count = Slider1.CurrentValue
		Rayfield:Notify({
			Title = "Info",
			Content = "Press P to stop",
			Duration = 6.5,
			Image = 4483362458,
		})

		-- Stop listener
		local connection
		connection = UIS.InputBegan:Connect(function(input, gp)
			if gp then return end
			if input.KeyCode == Enum.KeyCode.P then
				stopped = true
			end
		end)

		-- Cache chests ONCE (prevents slow lookups)
		local chests = workspace.ChestFolder:GetChildren()

		-- Optional: sort chests by distance (makes TP shorter and faster)
		local rootPart = char:WaitForChild("HumanoidRootPart")
		table.sort(chests, function(a, b)
			local ra = a:FindFirstChild("root")
			local rb = b:FindFirstChild("root")
			if not (ra and rb) then return false end
			return (ra.Position - rootPart.Position).Magnitude < (rb.Position - rootPart.Position).Magnitude
		end)

		for _, chest in ipairs(chests) do
			if stopped then break end
			if count <= 0 then break end
			local hit = chest:FindFirstChild("Hitpart")
			local root = chest:FindFirstChild("root")

			if hit and root and hit:FindFirstChild("ProximityPrompt") then

				-- Only teleport when needed
				char:PivotTo(root.CFrame)

				-- Must stay 0.15 because the prompt won't fire faster
				task.wait(0.15)

				fireproximityprompt(hit.ProximityPrompt, true)
				count -= 1
			end
		end

		connection:Disconnect()

		Rayfield:Notify({
			Title = "Success ✅",
			Content = "Successfully collected all chests",
			Duration = 6.5,
			Image = 4483362458,
		})


	end,
})

local Toggle = Tab:CreateToggle({
	Name = "Enable auto chest",
	CurrentValue = false,
	Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		while task.wait(autochestime) do
			if Value == true then
				for i,v in workspace.ChestFolder:GetChildren() do
					if v:FindFirstChild("Hitpart") then
						game.Players.LocalPlayer.Character:PivotTo(v.root.CFrame)
						task.wait(0.1)
						fireproximityprompt(v.Hitpart.ProximityPrompt)
					end
				end
			end
		end
	end,
}) 

local Button = Tab:CreateButton({
	Name = "Get all Chests",
	Callback = function()
		local stopped = false
		local UIS = game:GetService("UserInputService")
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()

		Rayfield:Notify({
			Title = "Info",
			Content = "Press P to stop",
			Duration = 6.5,
			Image = 4483362458,
		})

		-- Stop listener
		local connection
		connection = UIS.InputBegan:Connect(function(input, gp)
			if gp then return end
			if input.KeyCode == Enum.KeyCode.P then
				stopped = true
			end
		end)

		-- Cache chests ONCE (prevents slow lookups)
		local chests = workspace.ChestFolder:GetChildren()

		-- Optional: sort chests by distance (makes TP shorter and faster)
		local rootPart = char:WaitForChild("HumanoidRootPart")
		table.sort(chests, function(a, b)
			local ra = a:FindFirstChild("root")
			local rb = b:FindFirstChild("root")
			if not (ra and rb) then return false end
			return (ra.Position - rootPart.Position).Magnitude < (rb.Position - rootPart.Position).Magnitude
		end)

		for _, chest in ipairs(chests) do
			if stopped then break end

			local hit = chest:FindFirstChild("Hitpart")
			local root = chest:FindFirstChild("root")

			if hit and root and hit:FindFirstChild("ProximityPrompt") then

				-- Only teleport when needed
				char:PivotTo(root.CFrame)

				-- Must stay 0.15 because the prompt won't fire faster
				task.wait(0.15)

				fireproximityprompt(hit.ProximityPrompt, true)
			end
		end

		connection:Disconnect()

		Rayfield:Notify({
			Title = "Success ✅",
			Content = "Successfully collected all chests",
			Duration = 6.5,
			Image = 4483362458,
		})


	end,
})

local Section1 = Tab:CreateSection("Tree farm")


local Button1 = Tab:CreateButton({
	Name = "Chop all trees",
	Callback = function()
		for i,v in workspace.TreesFolder:GetChildren() do
			local args = {
				"damage",
				v.Name
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Tree"):FireServer(unpack(args))
		end
		Rayfield:Notify({
			Title = "Succes ✅",
			Content = "Succesfully chopped down all trees!",
			Duration = 6.5,
			Image = 4483362458,
		})
	end,
})
local Button2 = Tab:CreateButton({
	Name = "End the run",
	Callback = function()
		local args = {
			"EndRun"
		}
		game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Game"):FireServer(unpack(args))
		Rayfield:Notify({
			Title = "Succes ✅",
			Content = "ended run Succesfully",
			Duration = 6.5,
			Image = 4483362458,
		})
	end,
})

local Button3 = Tab:CreateButton({
	Name = "Open all of the chests",
	Callback = function()
		local Players = game:GetService("Players")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local LocalPlayer = Players.LocalPlayer

		-- Networking
		local ChestEvent = ReplicatedStorage:WaitForChild("Signal"):WaitForChild("Chest")
		local ChestFunction = ReplicatedStorage:WaitForChild("Signal"):WaitForChild("ChestFunction")

		-- Optional definitions (safe)
		local ChestsDef, ToolsDef
		pcall(function() ChestsDef = require(ReplicatedStorage.Data.GameProperties.Chests) end)
		pcall(function() ToolsDef = require(ReplicatedStorage.Data.GameProperties.Tools) end)

		-- Optional current world read (safe)
		local CurrentWorld
		pcall(function()
			if shared and shared.PM and shared.PM.World and shared.PM.World.WorldData then
				CurrentWorld = shared.PM.World.WorldData.CurrentWorld
			end
		end)

		-- =========================
		-- CONFIGURATION (tune for speed)
		-- =========================
		local AUTO_DISCARD_HIGHER_LEVEL = true
		local DISCARD_DELAY = 0.01        -- delay between discard requests
		local OPEN_DELAY = 0.01           -- delay between opens per worker
		local MAX_CYCLES = 8              -- number of cycles to attempt
		local UI_IDLE_TIMEOUT = 7         -- seconds before UI fades/destroys (keeps UI visible 5s after last reward)
		local UI_FADE_TIME = 0.2
		local ITEM_LIFETIME = 6           -- seconds each item stays before disappearing
		local DATA_TIMEOUT = 2            -- wait for server data
		local CONCURRENCY = 6             -- parallel open workers

		-- Sound asset IDs (as requested)
		local SOUND_COMMON = "rbxassetid://89712494786053"
		local SOUND_EPIC = "rbxassetid://102938514514235"
		local SOUND_LEGENDARY = "rbxassetid://90254484101822"

		-- =========================
		-- STATE
		-- =========================
		local chestCounts = nil   -- [chestName] = amount
		local chestKeys = nil     -- [chestName] = keys
		local gotData = false
		local opening = false
		local playerLevel = 0

		local function isTable(t) return type(t) == "table" end

		-- =========================
		-- HELPERS
		-- =========================
		local function getMinLevel(chestName)
			if not isTable(ChestsDef) then return math.huge end
			local info = ChestsDef[chestName]
			if not isTable(info) then return math.huge end
			local min = info.MinLevel or 0
			if info.WorldLevel and CurrentWorld then
				local wl = info.WorldLevel[CurrentWorld]
				if type(wl) == "number" then min = wl end
			end
			return min
		end

		local function isChestEligible(chestName)
			local minLevel = getMinLevel(chestName)
			if playerLevel >= minLevel then return true end
			if isTable(chestKeys) then
				local k = chestKeys[chestName]
				return type(k) == "number" and k > 0
			end
			return false
		end

		-- Networking handlers
		ChestEvent.OnClientEvent:Connect(function(_, arg2, arg3)
			if isTable(arg2) then chestCounts = arg2 else chestCounts = nil end
			if isTable(arg3) then chestKeys = arg3 else chestKeys = nil end
			gotData = true
		end)

		local function requestChestData()
			gotData = false
			ChestEvent:FireServer("get")
		end

		local function waitForChestData(timeout)
			timeout = timeout or DATA_TIMEOUT
			local t0 = os.clock()
			while not gotData do
				if os.clock() - t0 > timeout then return false end
				task.wait(0.03)
			end
			return true
		end

		local function refreshPlayerLevel()
			local ok, lvl = pcall(function() return ChestFunction:InvokeServer("getLastLevel") end)
			if ok and type(lvl) == "number" then playerLevel = lvl else playerLevel = 0 end
		end

		local function totalChestCount()
			if not isTable(chestCounts) then return 0 end
			local sum = 0
			for _, amount in pairs(chestCounts) do
				if type(amount) == "number" and amount > 0 then sum = sum + amount end
			end
			return sum
		end

		local function getRemainingFor(name)
			if not isTable(chestCounts) then return 0 end
			local v = chestCounts[name]
			return type(v) == "number" and v or 0
		end

		local function buildOpenOrder()
			local order = {}
			if not isTable(chestCounts) then return order end
			for chestName, amount in pairs(chestCounts) do
				if type(amount) == "number" and amount > 0 and isChestEligible(chestName) then
					table.insert(order, { name = chestName, amount = amount })
				end
			end
			table.sort(order, function(a, b) return tostring(a.name) < tostring(b.name) end)
			return order
		end

		-- =========================
		-- FAST REMOTE WRAPPERS
		-- =========================
		local function fastFireDiscard(chestName)
			pcall(function()
				ChestEvent:FireServer("Discard", chestName)
			end)
		end

		local function fastInvokeOpen(chestName)
			local ok, rewards = pcall(function()
				return ChestFunction:InvokeServer("Open", chestName)
			end)
			if ok and isTable(rewards) then return rewards end
			return nil
		end

		-- =========================
		-- REWARD UI (centered grid, 75% screen) + sounds
		-- =========================
		local RewardUI = {}
		RewardUI.__index = RewardUI

		local function rarityColor(r)
			if not r then return Color3.fromRGB(245,245,250) end
			local rr = string.lower(tostring(r))
			if rr == "common" then return Color3.fromRGB(220,220,220)
			elseif rr == "uncommon" then return Color3.fromRGB(140,220,140)
			elseif rr == "rare" then return Color3.fromRGB(100,180,255)
			elseif rr == "epic" then return Color3.fromRGB(180,100,255)
			elseif rr == "legendary" then return Color3.fromRGB(255,190,70)
			end
			return Color3.fromRGB(245,245,250)
		end

		local function createTextLabel(parent, text, size, color, font, align)
			local lbl = Instance.new("TextLabel")
			lbl.BackgroundTransparency = 1
			lbl.Size = size or UDim2.new(1, 0, 0, 20)
			lbl.Font = font or Enum.Font.Gotham
			lbl.TextSize = 16
			lbl.TextColor3 = color or Color3.fromRGB(245,245,250)
			lbl.TextXAlignment = align or Enum.TextXAlignment.Center
			lbl.Text = text or ""
			lbl.Parent = parent
			return lbl
		end

		function RewardUI.new()
			local self = setmetatable({}, RewardUI)
			local playerGui = LocalPlayer:WaitForChild("PlayerGui")

			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "ChestRewardGrid"
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.Parent = playerGui

			local frame = Instance.new("Frame")
			frame.Name = "GridFrame"
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.Position = UDim2.new(0.5, 0, 0.5, 0)
			frame.Size = UDim2.new(0.75, 0, 0.75, 0)
			frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			frame.BackgroundTransparency = 0.06
			frame.BorderSizePixel = 0
			frame.Parent = screenGui

			local corner = Instance.new("UICorner", frame)
			corner.CornerRadius = UDim.new(0, 12)

			local title = createTextLabel(frame, "Rewards", UDim2.new(1, 0, 0, 28), Color3.fromRGB(230,230,240), Enum.Font.GothamBold, Enum.TextXAlignment.Left)
			title.Position = UDim2.new(0, 16, 0, 8)

			local gridContainer = Instance.new("Frame")
			gridContainer.Name = "GridContainer"
			gridContainer.BackgroundTransparency = 1
			gridContainer.Size = UDim2.new(1, -32, 1, -48)
			gridContainer.Position = UDim2.new(0, 16, 0, 44)
			gridContainer.Parent = frame

			local grid = Instance.new("UIGridLayout")
			grid.Parent = gridContainer
			grid.SortOrder = Enum.SortOrder.LayoutOrder
			grid.CellPadding = UDim2.new(0, 10, 0, 10)
			grid.CellSize = UDim2.new(0.18, 0, 0.18, 0)

			gridContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				local w = gridContainer.AbsoluteSize.X
				local cols = math.clamp(math.floor(w / 160), 1, 8)
				local cellW = math.max(0.12, math.min(0.25, 1 / cols))
				grid.CellSize = UDim2.new(cellW, 0, cellW * 0.9, 0)
			end)

			self._screenGui = screenGui
			self._frame = frame
			self._gridContainer = gridContainer
			self._grid = grid
			self._lastUpdate = os.clock()
			self._destroyTask = nil
			self._maxItems = 200
			self._fadeTime = UI_FADE_TIME

			return self
		end

		function RewardUI:_scheduleDestroy(timeout)
			if self._destroyTask then
				task.cancel(self._destroyTask)
				self._destroyTask = nil
			end
			self._destroyTask = task.delay(timeout or UI_IDLE_TIMEOUT, function()
				local idle = os.clock() - self._lastUpdate
				if idle >= (timeout or UI_IDLE_TIMEOUT) then
					local t0 = os.clock()
					while os.clock() - t0 < self._fadeTime do
						local alpha = (os.clock() - t0) / self._fadeTime
						self._frame.BackgroundTransparency = 0.06 + alpha * 0.94
						for _, child in ipairs(self._frame:GetDescendants()) do
							if child:IsA("TextLabel") then
								child.TextTransparency = math.clamp(alpha, 0, 1)
							elseif child:IsA("ImageLabel") then
								child.ImageTransparency = math.clamp(alpha, 0, 1)
							end
						end
						task.wait()
					end
					if self._screenGui and self._screenGui.Parent then
						self._screenGui:Destroy()
					end
				end
			end)
		end

		-- helper to choose which sound to play based on rarity
		local function chooseSoundForRarity(rarity)
			if not rarity then
				return SOUND_COMMON
			end
			local r = string.lower(tostring(rarity))
			if r == "epic" then
				return SOUND_EPIC
			elseif r == "legendary" or r == "mythic" or r == "legendary+" then
				return SOUND_LEGENDARY
			else
				-- common/uncommon/rare -> common sound as requested
				return SOUND_COMMON
			end
		end

		-- play a short local sound parented to the UI (auto-cleanup)
		local function playLocalSound(parent, soundId)
			if not parent or not parent.Parent then return end
			local s = Instance.new("Sound")
			s.SoundId = soundId
			s.Volume = 1
			s.Looped = false
			s.PlayOnRemove = false
			s.Parent = parent
			-- Play safely
			local ok, err = pcall(function() s:Play() end)
			if not ok then
				-- fallback: set SoundId and let it be destroyed later
			end
			-- cleanup after finished (or after 5s)
			s.Ended:Connect(function()
				if s and s.Parent then s:Destroy() end
			end)
			task.delay(5, function()
				if s and s.Parent then pcall(function() s:Destroy() end) end
			end)
		end

		-- opts = { rarity = "Rare", icon = "rbxassetid://...", color = Color3 }
		function RewardUI:AddEntry(name, opts)
			opts = opts or {}
			self._lastUpdate = os.clock()

			local item = Instance.new("Frame")
			item.Size = UDim2.new(1, 0, 1, 0)
			item.BackgroundColor3 = opts.color or rarityColor(opts.rarity)
			item.BorderSizePixel = 0
			item.LayoutOrder = math.floor(self._lastUpdate * 1000)
			item.Parent = self._gridContainer

			local itemCorner = Instance.new("UICorner", item)
			itemCorner.CornerRadius = UDim.new(0, 8)

			local inner = Instance.new("Frame")
			inner.BackgroundTransparency = 1
			inner.Size = UDim2.new(1, -8, 1, -8)
			inner.Position = UDim2.new(0, 4, 0, 4)
			inner.Parent = item

			local icon = Instance.new("ImageLabel")
			icon.Size = UDim2.new(0, 64, 0, 64)
			icon.AnchorPoint = Vector2.new(0.5, 0)
			icon.Position = UDim2.new(0.5, 0, 0, 8)
			icon.BackgroundTransparency = 1
			icon.Image = opts.icon or ""
			icon.ScaleType = Enum.ScaleType.Fit
			icon.Parent = inner

			local nameLbl = Instance.new("TextLabel")
			nameLbl.Size = UDim2.new(1, -8, 0, 28)
			nameLbl.Position = UDim2.new(0, 4, 1, -36)
			nameLbl.BackgroundTransparency = 1
			nameLbl.Font = Enum.Font.GothamBold
			nameLbl.TextSize = 14
			nameLbl.TextColor3 = Color3.fromRGB(20,20,20)
			nameLbl.Text = tostring(name)
			nameLbl.TextWrapped = true
			nameLbl.TextYAlignment = Enum.TextYAlignment.Center
			nameLbl.Parent = inner

			-- play sound for this item based on rarity
			local soundId = chooseSoundForRarity(opts.rarity)
			-- parent sound to the item frame so it is local and cleaned up with the item
			playLocalSound(item, soundId)

			-- schedule per-item fade & destroy after ITEM_LIFETIME seconds
			task.spawn(function()
				local t0 = os.clock()
				while os.clock() - t0 < ITEM_LIFETIME do
					task.wait(0.05)
					if not item or not item.Parent then return end
				end
				local fadeStart = os.clock()
				local fadeDur = 0.18
				while os.clock() - fadeStart < fadeDur do
					local a = (os.clock() - fadeStart) / fadeDur
					for _, child in ipairs(item:GetDescendants()) do
						if child:IsA("TextLabel") then
							child.TextTransparency = math.clamp(a, 0, 1)
						elseif child:IsA("ImageLabel") then
							child.ImageTransparency = math.clamp(a, 0, 1)
						elseif child:IsA("Frame") then
							child.BackgroundTransparency = math.clamp(a * 0.9, 0, 1)
						end
					end
					item.BackgroundTransparency = math.clamp(a * 0.9, 0, 1)
					task.wait()
					if not item or not item.Parent then return end
				end
				if item and item.Parent then item:Destroy() end
			end)

			-- Cap items
			local count = 0
			for _, c in ipairs(self._gridContainer:GetChildren()) do
				if c:IsA("Frame") then count = count + 1 end
			end
			if count > self._maxItems then
				local oldest, oldestObj = math.huge, nil
				for _, c in ipairs(self._gridContainer:GetChildren()) do
					if c:IsA("Frame") and c.LayoutOrder < oldest then
						oldest = c.LayoutOrder
						oldestObj = c
					end
				end
				if oldestObj then oldestObj:Destroy() end
			end

			self:_scheduleDestroy(UI_IDLE_TIMEOUT)
		end

		-- Create feed instance
		local feed = RewardUI.new()

		-- =========================
		-- FAST PROCESSING LOGIC (non-blocking discard)
		-- =========================
		local function decrementLocalCount(name)
			if not isTable(chestCounts) then return end
			local v = chestCounts[name]
			if type(v) == "number" then
				chestCounts[name] = math.max(0, v - 1)
			end
		end

		local function scheduleDiscard(chestName, count)
			for i = 1, count do
				task.spawn(function()
					pcall(function()
						ChestEvent:FireServer("Discard", chestName)
					end)
				end)
				if isTable(chestCounts) and type(chestCounts[chestName]) == "number" then
					chestCounts[chestName] = math.max(0, chestCounts[chestName] - 1)
				end
			end
		end

		local function discardHigherLevelChestsFastNonBlocking()
			if not AUTO_DISCARD_HIGHER_LEVEL or not isTable(chestCounts) then return end

			local toDiscardBatches = {}

			for chestName, amount in pairs(chestCounts) do
				if type(amount) == "number" and amount > 0 then
					local minLevel = getMinLevel(chestName)
					local keys = (isTable(chestKeys) and chestKeys[chestName]) or 0
					if playerLevel < minLevel and (type(keys) ~= "number" or keys <= 0) then
						toDiscardBatches[chestName] = amount
					end
				end
			end

			if next(toDiscardBatches) == nil then return end

			for chestName, amount in pairs(toDiscardBatches) do
				feed:AddEntry(("Discarding %s x%d"):format(chestName, amount), { color = Color3.fromRGB(200,120,120) })
				scheduleDiscard(chestName, amount)
				task.wait(DISCARD_DELAY)
			end

			requestChestData()
			waitForChestData(1)
		end

		-- Worker pool
		local function createWorkerPool(concurrency)
			local running = 0
			local queue = {}
			local function runNext()
				if running >= concurrency then return end
				local job = table.remove(queue, 1)
				if not job then return end
				running = running + 1
				task.spawn(function()
					pcall(job)
					running = running - 1
					runNext()
				end)
			end
			return {
				push = function(fn)
					table.insert(queue, fn)
					runNext()
				end,
				waitIdle = function()
					while running > 0 or #queue > 0 do task.wait(0.01) end
				end
			}
		end

		local pool = createWorkerPool(CONCURRENCY)

		local function openAllChestsFast(maxCycles)
			if opening then return end
			opening = true
			maxCycles = maxCycles or MAX_CYCLES

			for cycle = 1, maxCycles do
				refreshPlayerLevel()
				requestChestData()
				if not waitForChestData(DATA_TIMEOUT) then break end

				discardHigherLevelChestsFastNonBlocking()

				refreshPlayerLevel()
				requestChestData()
				waitForChestData(1)

				local order = buildOpenOrder()
				if #order == 0 then opening = false; return end

				for _, entry in ipairs(order) do
					local toOpen = math.max(0, math.min(entry.amount, getRemainingFor(entry.name)))
					for i = 1, toOpen do
						pool.push(function()
							decrementLocalCount(entry.name)
							local rewards = fastInvokeOpen(entry.name)
							if isTable(rewards) then
								for _, tool in ipairs(rewards) do
									local name = (type(tool) == "table" and tool.Name) or (typeof(tool) == "Instance" and tool.Name) or tostring(tool)
									local rarity = nil
									local icon = nil
									if ToolsDef and type(name) == "string" then
										local def = ToolsDef[name]
										if isTable(def) then
											rarity = def.Rarity
											icon = def.Image
										end
									end
									local color = rarityColor(rarity)
									feed:AddEntry(name, { rarity = rarity, icon = icon, color = color })
								end
							else
								feed:AddEntry(("Opened %s"):format(entry.name), { color = Color3.fromRGB(200,200,200) })
							end
							task.wait(OPEN_DELAY)
						end)
					end
				end

				pool.waitIdle()

				requestChestData()
				waitForChestData(1)

				if #buildOpenOrder() == 0 then opening = false; return end
			end

			opening = false
		end
		refreshPlayerLevel()
		requestChestData()
		if waitForChestData(DATA_TIMEOUT) then
			if totalChestCount() > 0 then
				openAllChestsFast(MAX_CYCLES)
			else
				print("No chests available to open at startup.")
			end
		else
			warn("Initial chest data did not arrive in time.")
		end

		Rayfield:Notify({
			Title = "Succes ✅",
			Content = "Succesfully opened all chests!",
			Duration = 6.5,
			Image = 4483362458,
		})
	end,
})

local Toggle1 = Tab:CreateToggle({
	Name = "Load script on rejoin?",
	CurrentValue = false,
	Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		while task.wait(autochestime) do
			if Value == true then
				for i,v in workspace.ChestFolder:GetChildren() do
					if v:FindFirstChild("Hitpart") then
						game.Players.LocalPlayer.Character:PivotTo(v.root.CFrame)
						task.wait(0.1)
						fireproximityprompt(v.Hitpart.ProximityPrompt)
					end
				end
			end
		end
	end,
}) 

local Button4 = Tab:CreateButton({
	Name = "Rejoin",
	Callback = function()
		if Toggle1.CurrentValue == true then
			queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/refs/heads/main/Cut_trees/Main.lua",true))()')
		end
		task.wait(1)
		game["Teleport Service"]:Teleport(game.PlaceId,game.Players.LocalPlayer)
		task.wait(1)
	end,
})

local Tab1 = Window:CreateTab("Auto farm", 4483362458)

local Toggle2 = Tab1:CreateToggle({
	Name = "Enable chest aura",
	CurrentValue = false,
	Flag = "Toggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		Rayfield:Notify({
			Title = "Info",
			Content = "Chest aura will open nearby chest while auto farming",
			Duration = 6.5,
			Image = 4483362458,
		})
	end,
}) 

local Toggle3 = Tab1:CreateToggle({
	Name = "Enable Human walking",
	CurrentValue = false,
	Flag = "Toggle4", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		Rayfield:Notify({
			Title = "Info",
			Content = "if on it will make your player walk around randomly",
			Duration = 6.5,
			Image = 4483362458,
		})
	end,
}) 

local Toggle4 = Tab1:CreateToggle({
	Name = "Enable auto farm",
	CurrentValue = false,
	Flag = "Toggle5", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		if Value == true then
			local args = {
				"set",
				1
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("World"):FireServer(unpack(args))
			local args = {
				"play"
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Game"):FireServer(unpack(args))
			task.spawn(function()
				while task.wait(20) do
					if Value == true then
						if Toggle3.CurrentValue == false then
							for i,v in workspace.TreesFolder:GetChildren() do
								local args = {
									"damage",
									v.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Tree"):FireServer(unpack(args))
							end
						else

						end
					else
						break
					end
				end
			end)
			task.spawn(function()
				if Toggle3.CurrentValue == true then
					local args = {
						"setAutoAttack",
						true
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Cutting"):FireServer(unpack(args))

					while task.wait(3) do
						if Value == true then
							local args = {
								"setAutoAttack",
								true
							}
							game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Cutting"):FireServer(unpack(args))
							local succes, err = pcall(function()
								game.Players.LocalPlayer.Character.Humanoid:MoveTo(workspace.TreesFolder:GetChildren()[math.random(1,#workspace.TreesFolder:GetChildren())].Tree.Part.Position)
							end)
							if not succes then
								Rayfield:Notify({
									Title = "Error",
									Content = "Failed to walk to tree error: "..err,
									Duration = 6.5,
									Image = 4483362458,
								})
							end
						else
							break
						end
					end
				end
			end)
			task.spawn(function()
				while task.wait(1) do
					if Value == true then
						if Toggle2.CurrentValue == true then
							for i,v in workspace.ChestFolder:GetChildren() do
								if v:FindFirstChild("root") then
									print((v.root.Position.Magnitude - game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Magnitude))
									if (v.root.Position.Magnitude - game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Magnitude) < 20 then
										game.Players.LocalPlayer.Character:PivotTo(v.root.CFrame)
										task.wait(0.15)
										fireproximityprompt(v.Hitpart.ProximityPrompt)
									end
								end
							end
						end
					else
						break
					end
				end
			end)
		end
	end,
}) 


Rayfield:LoadConfiguration()

