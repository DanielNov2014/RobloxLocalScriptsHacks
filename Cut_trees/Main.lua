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
	LoadingTitle = "cut trees farm [BETA] v 1.1",
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
		for i,v in workspace.ChestFolder:GetChildren() do
			if v:FindFirstChild("Hitpart") then
				game.Players.LocalPlayer.Character:PivotTo(v.root.CFrame)
				task.wait(0.15)
				fireproximityprompt(v.Hitpart.ProximityPrompt)
			end
		end
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
local function Getchesttype()
	local name = game:GetService("Players").LocalPlayer.PlayerGui.ChestOpening.Header.ChestName.Text
	if name == "Old Chest" then
		return 1
	elseif name == "Deep Dark Chest" then
		return 12
	elseif name == "Deep Chest" then
		return 10
	elseif name == "Dark Chest" then
		return 11
	elseif name == "Basic Chest" then
		return 2
	elseif name == "Frozen Chest" then
		return 3
	elseif name == "Golden Chest" then
		return 5
	elseif name == "Bone Chest" then
		return 7
	elseif name == "Lava Chest" then
		return 8
	elseif name == "Horns Chest" then
		return 9
	end
end

local function IsLocked()
	if game:GetService("Players").LocalPlayer.PlayerGui.ChestOpening.Lock.Visible == true then
		return true
	else
		return false
	end
end

local function GetChestsLeft()
	local count = 0
	for i,v in game:GetService("Players").LocalPlayer.PlayerGui.ChestOpening.Chests.ScrollingFrame:GetChildren() do
		if v.Name == "Template" then
			count += 1
		end
	end
	return count
end
local Button3 = Tab:CreateButton({
	Name = "Open all of the chests",
	Callback = function()
		repeat 
			if Getchesttype() == 1 then
				local args = {
					"Open",
					"Chest1"
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("ChestFunction"):InvokeServer(unpack(args))
			elseif Getchesttype() == 3 then
				local args = {
					"Open",
					"Chest3_Huge"
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("ChestFunction"):InvokeServer(unpack(args))
			elseif Getchesttype() == 7 then
				if IsLocked() == false then
					local args = {
						"Open",
						"Chest7_Huge"
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("ChestFunction"):InvokeServer(unpack(args))
				else
					local args = {
						"Discard",
						"Chest7_Huge"
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Chest"):FireServer(unpack(args))

				end
			elseif Getchesttype() == 8 then
				if IsLocked() == false then
					local args = {
						"Open",
						"Chest8_Huge"
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("ChestFunction"):InvokeServer(unpack(args))
				else
					local args = {
						"Discard",
						"Chest8_Huge"
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Signal"):WaitForChild("Chest"):FireServer(unpack(args))

				end
			end
			task.wait(0.1)
		until GetChestsLeft() == 0
		Rayfield:Notify({
			Title = "Succes ✅",
			Content = "Succesfully opened all chests!",
			Duration = 6.5,
			Image = 4483362458,
		})
	end,
})

Rayfield:LoadConfiguration()
