-- Gui to Lua
-- Version: 3.2

-- Instances:

local Slap = Instance.new("ScreenGui")
local Draggble = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local ScrollingFrame = Instance.new("ScrollingFrame")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local ScrollingFrame_2 = Instance.new("ScrollingFrame")
local Selectplayer = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local ImageLabel = Instance.new("ImageLabel")
local UICorner_3 = Instance.new("UICorner")
local UIListLayout = Instance.new("UIListLayout")
local _100xslap = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local _10xslap = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local slap = Instance.new("TextButton")
local UICorner_6 = Instance.new("UICorner")

--Properties:

Slap.Name = "Slap"
Slap.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Slap.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Slap.ResetOnSpawn = false

Draggble.Name = "Draggble"
Draggble.Parent = Slap
Draggble.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
Draggble.BorderColor3 = Color3.fromRGB(0, 0, 0)
Draggble.BorderSizePixel = 0
Draggble.Position = UDim2.new(0.215187952, 0, 0.229067177, 0)
Draggble.Size = UDim2.new(0.732129991, 0, 0.138842076, 0)

UICorner.CornerRadius = UDim.new(1, 8)
UICorner.Parent = Draggble

ScrollingFrame.Parent = Draggble
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0, 0, 0.547936499, 0)
ScrollingFrame.Size = UDim2.new(1, 0, 5, 0)
ScrollingFrame.ScrollBarThickness = 30

Frame.Parent = ScrollingFrame
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.504754424, 0, 0.0929931924, 0)
Frame.Size = UDim2.new(0, 372, 0, 207)

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0, 0, -0.299194843, 0)
TextLabel.Size = UDim2.new(1, 0, 0.370370358, 0)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "select player to slap (v 3.0)"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

ScrollingFrame_2.Parent = Frame
ScrollingFrame_2.Active = true
ScrollingFrame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame_2.BackgroundTransparency = 1.000
ScrollingFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame_2.BorderSizePixel = 0
ScrollingFrame_2.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame_2.CanvasSize = UDim2.new(0, 0, 5, 0)

Selectplayer.Name = "Selectplayer"
Selectplayer.Parent = ScrollingFrame_2
Selectplayer.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
Selectplayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
Selectplayer.BorderSizePixel = 0
Selectplayer.Position = UDim2.new(0, 0, -7.37139558e-08, 0)
Selectplayer.Size = UDim2.new(1, 0, 0.03827722, 0)
Selectplayer.Font = Enum.Font.SourceSans
Selectplayer.Text = "Player1"
Selectplayer.TextColor3 = Color3.fromRGB(0, 0, 0)
Selectplayer.TextSize = 14.000

UICorner_2.CornerRadius = UDim.new(1, 0)
UICorner_2.Parent = Selectplayer

ImageLabel.Parent = Selectplayer
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.104838707, 0, 2.10466055e-06, 0)
ImageLabel.Size = UDim2.new(0.0860215053, 0, 0.99999851, 0)
ImageLabel.ZIndex = 2
ImageLabel.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

UICorner_3.CornerRadius = UDim.new(1, 0)
UICorner_3.Parent = ImageLabel

UIListLayout.Parent = ScrollingFrame_2
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

_100xslap.Name = "100x slap"
_100xslap.Parent = ScrollingFrame
_100xslap.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
_100xslap.BorderColor3 = Color3.fromRGB(0, 0, 0)
_100xslap.BorderSizePixel = 0
_100xslap.Position = UDim2.new(-0.00268685771, 0, 0.864761472, 0)
_100xslap.Size = UDim2.new(1, 0, 0.134784013, 0)
_100xslap.Font = Enum.Font.SourceSans
_100xslap.Text = "slap <player> 100 times"
_100xslap.TextColor3 = Color3.fromRGB(0, 0, 0)
_100xslap.TextSize = 14.000

UICorner_4.CornerRadius = UDim.new(1, 0)
UICorner_4.Parent = _100xslap

_10xslap.Name = "10x slap"
_10xslap.Parent = ScrollingFrame
_10xslap.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
_10xslap.BorderColor3 = Color3.fromRGB(0, 0, 0)
_10xslap.BorderSizePixel = 0
_10xslap.Position = UDim2.new(-0.00268685771, 0, 0.727878511, 0)
_10xslap.Size = UDim2.new(1, 0, 0.134784013, 0)
_10xslap.Font = Enum.Font.SourceSans
_10xslap.Text = "slap <player> 10 times"
_10xslap.TextColor3 = Color3.fromRGB(0, 0, 0)
_10xslap.TextSize = 14.000

UICorner_5.CornerRadius = UDim.new(1, 0)
UICorner_5.Parent = _10xslap

slap.Name = "slap"
slap.Parent = ScrollingFrame
slap.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
slap.BorderColor3 = Color3.fromRGB(0, 0, 0)
slap.BorderSizePixel = 0
slap.Position = UDim2.new(-0.00268685771, 0, 0.59099555, 0)
slap.Size = UDim2.new(1, 0, 0.134784013, 0)
slap.Font = Enum.Font.SourceSans
slap.Text = "slap <player>"
slap.TextColor3 = Color3.fromRGB(0, 0, 0)
slap.TextSize = 14.000

-- Gui to Lua
-- Version: 3.2

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local TextBox = Instance.new("TextBox")
local TextButton1 = Instance.new("TextButton")

--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling


UICorner_6.CornerRadius = UDim.new(1, 0)
UICorner_6.Parent = slap

local UIS = game:GetService("UserInputService")
local frame = Draggble

local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

local player = nil
local function UpdatePlayerlist()
	local templet = Selectplayer:Clone()
	for i,v in ScrollingFrame_2:GetChildren() do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	for i,v in game.Players:GetPlayers() do
		local new = templet:Clone()
		new.Text = v.Name
		new.Name = v.Name
		new.Parent = ScrollingFrame_2
		local PLACEHOLDER_IMAGE = "rbxassetid://0" -- replace with placeholder image

		-- fetch the thumbnail
		local userId = v.UserId
		local thumbType = Enum.ThumbnailType.HeadShot
		local thumbSize = Enum.ThumbnailSize.Size420x420
		local content, isReady = game.Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
		-- Set the image for the correct ImageLabel under this button
		local img = new:FindFirstChild("ImageLabel")
		if img then
			img.Image = content
		end
		new.MouseButton1Click:Connect(function()
			player = v.Name
			print(player)
			print(v.Name)
			slap.Text = "Slap "..player
			_10xslap.Text = "Slap "..player .. " 10 times"
			_100xslap.Text = "Slap "..player .. " 100 times"
		end)
	end
end

UpdatePlayerlist()
--local args = {
--	"Blue Hanger"
--}
--game:GetService("ReplicatedStorage"):WaitForChild("GiftCollect"):FireServer(unpack(args))

slap.MouseButton1Click:Connect(function()
	if player then
		local targetPlayer = game:GetService("Players"):FindFirstChild(player)
		if targetPlayer then
			print("Target player found: "..targetPlayer.Name)
			if targetPlayer.Character then
				print("founded")
				local args = {
					"slash",
					game:GetService("Players"):WaitForChild(player).Character,
					vector.create(4.270020008087158, -math.huge, 9.04250717163086)
				}
				task.spawn(function()
					for i,v in game:GetService("Players").LocalPlayer.Character:GetChildren() do
						if v:IsA("Tool") then
							v:WaitForChild("Event"):FireServer(unpack(args))
						end
					end
				end)
				--game:GetService("Players").LocalPlayer.Character:WaitForChild("Blue Hanger"):WaitForChild("Event"):FireServer(unpack(args))
			else
				warn("Player found but character missing: "..targetPlayer.Name)
			end
		else
			warn("Player not found: "..tostring(player))
		end
	else
		warn("No player selected")
	end
end)

_10xslap.MouseButton1Click:Connect(function()
	if player then
		local targetPlayer = game:GetService("Players"):FindFirstChild(player)
		if targetPlayer then
			print("Target player found: "..targetPlayer.Name)
			if targetPlayer.Character then
				local args = {
					"slash",
					game:GetService("Players"):WaitForChild(player).Character,
					vector.create(4.270020008087158, -math.huge, 9.04250717163086)
				}
				for i = 1,10 do
					for i,v in game:GetService("Players").LocalPlayer.Character:GetChildren() do
						if v:IsA("Tool") then
							v:WaitForChild("Event"):FireServer(unpack(args))
						end
					end
					task.wait(0.2)
				end
			else
				warn("Player found but character missing: "..targetPlayer.Name)
			end
		else
			warn("Player not found: "..tostring(player))
		end
	else
		warn("No player selected")
	end
end)

_100xslap.MouseButton1Click:Connect(function()
	if player then
		local targetPlayer = game:GetService("Players"):FindFirstChild(player)
		if targetPlayer then
			print("Target player found: "..targetPlayer.Name)
			if targetPlayer.Character then
				local args = {
					"slash",
					game:GetService("Players"):WaitForChild(player).Character,
					vector.create(4.270020008087158, -math.huge, 9.04250717163086)
				}

				for i = 1,100 do
					for i,v in game:GetService("Players").LocalPlayer.Character:GetChildren() do
						if v:IsA("Tool") then
							v:WaitForChild("Event"):FireServer(unpack(args))
						end
					end
					--game:GetService("Players").LocalPlayer.Character:WaitForChild("Blue Hanger"):WaitForChild("Event"):FireServer(unpack(args))
					task.wait(0.1)
				end
			else
				warn("Player found but character missing: "..targetPlayer.Name)
			end
		else
			warn("Player not found: "..tostring(player))
		end
	else
		warn("No player selected")
	end
end)

game.Players.PlayerAdded:Connect(function(plr)
	UpdatePlayerlist()
end)

game.Players.PlayerRemoving:Connect(function(plr)
	UpdatePlayerlist()
end)

--loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/refs/heads/main/Slap_Tower_3_MODDED/autoslap.lua"))()
