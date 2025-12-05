--for i,v in workspace.TreesFolder:GetChildren() do
--	local args = {
--		"damage",
--		v.Name
--	}
--	game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Tree"):FireServer(unpack(args))
--end
--script: loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/refs/heads/main/Cut_trees/Main.lua",true))()
debugX = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Rayfield Example Window",
	Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "cut trees farm [BETA] v 1.2",
	LoadingSubtitle = "by DaniBoyNov2014",
	Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "Big Hub"
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

local Button = Tab:CreateButton({
	Name = "Get all Chests",
	Callback = function()
		local stopped = false
		Rayfield:Notify({
			Title = "Info",
			Content = "Prees P to stop",
			Duration = 6.5,
			Image = 4483362458,
		})
		local connection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.P then
				stopped = true
			end
		end)
		for i,v in workspace.ChestFolder:GetChildren() do
			if stopped == false then
				if v:FindFirstChild("Hitpart") then
					game.Players.LocalPlayer.Character:PivotTo(v.root.CFrame)
					task.wait(0.15)
					fireproximityprompt(v.Hitpart.ProximityPrompt)
				end
			end
		end
		connection:Disconnect()
		Rayfield:Notify({
			Title = "Succes ✅",
			Content = "Succesfully collected all chests",
			Duration = 6.5,
			Image = 4483362458,
		})
	end,
})
local Slider = Tab:CreateSlider({
	Name = "Auto cheast time",
	Range = {10, 100},
	Increment = 5,
	Suffix = "Seconds",
	CurrentValue = 10,
	Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		autochestime = Value
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
		-- LocalScript: Auto-open / Auto-discard chests + Reward UI
		-- Place in StarterPlayerScripts or StarterGui

		-- Fast Auto-open / Auto-discard LocalScript
		-- Paste into StarterPlayerScripts or StarterGui or run from your Rayfield button callback

		local Players = game:GetService("Players")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local LocalPlayer = Players.LocalPlayer

		-- Networking
		local ChestEvent = ReplicatedStorage:WaitForChild("Signal"):WaitForChild("Chest")
		local ChestFunction = ReplicatedStorage:WaitForChild("Signal"):WaitForChild("ChestFunction")

		-- Optional definitions
		local ChestsDef, ToolsDef
		pcall(function() ChestsDef = require(ReplicatedStorage.Data.GameProperties.Chests) end)
		pcall(function() ToolsDef = require(ReplicatedStorage.Data.GameProperties.Tools) end)

		-- Optional current world
		local CurrentWorld
		pcall(function()
			if shared and shared.PM and shared.PM.World and shared.PM.World.WorldData then
				CurrentWorld = shared.PM.World.WorldData.CurrentWorld
			end
		end)

		-- =========================
		-- SPEED CONFIGURATION
		-- =========================
		local AUTO_DISCARD_HIGHER_LEVEL = true
		local DISCARD_DELAY = 0.01        -- very small delay between discard requests
		local OPEN_DELAY = 0.01           -- very small delay between opens per worker
		local MAX_CYCLES = 8              -- more cycles to ensure everything processed
		local UI_IDLE_TIMEOUT = 3         -- UI fades faster
		local UI_FADE_TIME = 0.2
		local DATA_TIMEOUT = 2            -- shorter wait for server data
		local CONCURRENCY = 6             -- number of parallel open workers; tune if server rate-limits

		-- =========================
		-- STATE
		-- =========================
		local chestCounts = nil
		local chestKeys = nil
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
			-- Fire discard without waiting for server response
			pcall(function()
				ChestEvent:FireServer("Discard", chestName)
			end)
		end

		local function fastInvokeOpen(chestName)
			-- Use pcall to avoid errors; return rewards or nil
			local ok, rewards = pcall(function()
				return ChestFunction:InvokeServer("Open", chestName)
			end)
			if ok and isTable(rewards) then return rewards end
			return nil
		end

		-- =========================
		-- REWARD UI (compact)
		-- =========================
		local function createFeed()
			local playerGui = LocalPlayer:WaitForChild("PlayerGui")
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "FastChestFeed"
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.Parent = playerGui

			local frame = Instance.new("Frame")
			frame.Name = "Feed"
			frame.Size = UDim2.fromOffset(300, 180)
			frame.Position = UDim2.new(1, -320, 0, 80)
			frame.BackgroundColor3 = Color3.fromRGB(18,18,22)
			frame.BackgroundTransparency = 0.06
			frame.BorderSizePixel = 0
			frame.Parent = screenGui
			local corner = Instance.new("UICorner", frame)
			corner.CornerRadius = UDim.new(0, 8)

			local title = Instance.new("TextLabel", frame)
			title.Size = UDim2.new(1, -16, 0, 24)
			title.Position = UDim2.new(0, 8, 0, 6)
			title.BackgroundTransparency = 1
			title.Font = Enum.Font.GothamBold
			title.TextSize = 16
			title.TextColor3 = Color3.fromRGB(230,230,240)
			title.Text = "Rewards"
			title.TextXAlignment = Enum.TextXAlignment.Left

			local list = Instance.new("ScrollingFrame", frame)
			list.Name = "List"
			list.Size = UDim2.new(1, -16, 1, -36)
			list.Position = UDim2.new(0, 8, 0, 34)
			list.BackgroundTransparency = 1
			list.BorderSizePixel = 0
			list.CanvasSize = UDim2.new(0,0,0,0)
			list.ScrollBarThickness = 6

			local layout = Instance.new("UIListLayout", list)
			layout.Padding = UDim.new(0,4)
			layout.SortOrder = Enum.SortOrder.LayoutOrder
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
				list.CanvasPosition = Vector2.new(0, math.max(0, layout.AbsoluteContentSize.Y - list.AbsoluteSize.Y))
			end)

			return {
				screenGui = screenGui,
				frame = frame,
				list = list,
				last = os.clock(),
				destroyTask = nil,
				add = function(self, text, color)
					self.last = os.clock()
					local row = Instance.new("TextLabel")
					row.BackgroundTransparency = 1
					row.Size = UDim2.new(1, 0, 0, 20)
					row.Font = Enum.Font.Gotham
					row.TextSize = 14
					row.TextXAlignment = Enum.TextXAlignment.Left
					row.TextColor3 = color or Color3.fromRGB(245,245,250)
					row.Text = text
					row.Parent = self.list
					-- cap
					local count = 0
					for _,c in ipairs(self.list:GetChildren()) do if c:IsA("TextLabel") then count = count + 1 end end
					if count > 80 then
						for _,c in ipairs(self.list:GetChildren()) do
							if c:IsA("TextLabel") then c:Destroy(); break end
						end
					end
					-- schedule destroy
					if self.destroyTask then task.cancel(self.destroyTask); self.destroyTask = nil end
					self.destroyTask = task.delay(UI_IDLE_TIMEOUT, function()
						if os.clock() - self.last >= UI_IDLE_TIMEOUT then
							local t0 = os.clock()
							while os.clock() - t0 < UI_FADE_TIME do
								local a = (os.clock() - t0) / UI_FADE_TIME
								self.frame.BackgroundTransparency = 0.06 + a * 0.94
								for _,child in ipairs(self.frame:GetDescendants()) do
									if child:IsA("TextLabel") then child.TextTransparency = math.clamp(a,0,1) end
								end
								task.wait()
							end
							if self.screenGui and self.screenGui.Parent then self.screenGui:Destroy() end
						end
					end)
				end
			}
		end

		local feed = createFeed()

		-- =========================
		-- FAST PROCESSING LOGIC
		-- =========================

		-- Optimistic local decrement helper
		local function decrementLocalCount(name)
			if not isTable(chestCounts) then return end
			local v = chestCounts[name]
			if type(v) == "number" then
				chestCounts[name] = math.max(0, v - 1)
			end
		end

		-- Discard higher-level chests quickly
		local function discardHigherLevelChestsFast()
			if not AUTO_DISCARD_HIGHER_LEVEL or not isTable(chestCounts) then return end
			for chestName, amount in pairs(chestCounts) do
				if type(amount) == "number" and amount > 0 then
					local minLevel = getMinLevel(chestName)
					local keys = (isTable(chestKeys) and chestKeys[chestName]) or 0
					if playerLevel < minLevel and (type(keys) ~= "number" or keys <= 0) then
						-- discard all copies quickly without waiting for server each time
						for i = 1, amount do
							fastFireDiscard(chestName)
							decrementLocalCount(chestName)
							feed:add(("Discarded %s"):format(chestName), Color3.fromRGB(200,120,120))
							task.wait(DISCARD_DELAY)
						end
					end
				end
			end
		end

		-- Worker pool for concurrent opens
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

		-- Fast open loop using worker pool and optimistic updates
		local function openAllChestsFast(maxCycles)
			if opening then return end
			opening = true
			maxCycles = maxCycles or MAX_CYCLES

			for cycle = 1, maxCycles do
				refreshPlayerLevel()
				requestChestData()
				if not waitForChestData(DATA_TIMEOUT) then break end

				discardHigherLevelChestsFast()

				-- small refresh after discards
				refreshPlayerLevel()
				requestChestData()
				waitForChestData(1)

				local order = buildOpenOrder()
				if #order == 0 then opening = false; return end

				for _, entry in ipairs(order) do
					local toOpen = math.max(0, math.min(entry.amount, getRemainingFor(entry.name)))
					for i = 1, toOpen do
						-- schedule open on pool
						pool.push(function()
							-- optimistic decrement immediately to allow faster scheduling
							decrementLocalCount(entry.name)
							local rewards = fastInvokeOpen(entry.name)
							if isTable(rewards) then
								for _, tool in ipairs(rewards) do
									local name = (type(tool) == "table" and tool.Name) or (typeof(tool) == "Instance" and tool.Name) or tostring(tool)
									local rarity = nil
									if ToolsDef and type(name) == "string" then
										local def = ToolsDef[name]
										if isTable(def) then rarity = def.Rarity end
									end
									feed:add(name, (rarity and (rarity == "legendary" and Color3.fromRGB(255,190,70) or Color3.fromRGB(180,180,255)) or nil))
								end
							else
								feed:add(("Opened %s"):format(entry.name), Color3.fromRGB(200,200,200))
							end
							task.wait(OPEN_DELAY)
						end)
					end
				end

				-- wait for all scheduled opens to finish before next cycle
				pool.waitIdle()

				-- quick soft refresh to sync counts
				requestChestData()
				waitForChestData(1)

				if #buildOpenOrder() == 0 then opening = false; return end
			end

			opening = false
		end

		-- =========================
		-- BOOT
		-- =========================
		for i = 1,2 do
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
		end

		-- Expose a fast manual trigger for convenience
		--return {
		--	RunFast = function() if not opening then openAllChestsFast(MAX_CYCLES) end end
		--}


		Rayfield:Notify({
			Title = "Succes ✅",
			Content = "Succesfully opened all chests!",
			Duration = 6.5,
			Image = 4483362458,
		})
	end,
})

local Button4 = Tab:CreateButton({
	Name = "Rejoin",
	Callback = function()
		queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/refs/heads/main/Cut_trees/Main.lua",true))()')
		task.wait(1)
		game["Teleport Service"]:Teleport(game.PlaceId,game.Players.LocalPlayer)
		task.wait(1)
	end,
})

Rayfield:LoadConfiguration()
