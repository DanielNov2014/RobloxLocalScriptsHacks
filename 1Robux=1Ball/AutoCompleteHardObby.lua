-- Gui to Lua
-- Version: 3.2

-- Instances:
local Scriptforgame_1_Robux__1_ball = Instance.new("ScreenGui")
Scriptforgame_1_Robux__1_ball.Name = "Scriptforgame_1_Robux_=_1_ball"
Scriptforgame_1_Robux__1_ball.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Scriptforgame_1_Robux__1_ball.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Scriptforgame_1_Robux__1_ball.ResetOnSpawn = false
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Scriptforgame_1_Robux_=_1_ball") then
	game.Players.LocalPlayer.PlayerGui["Scriptforgame_1_Robux_=_1_ball"]:Destroy()
end
local Scriptforgame_1_Robux__1_ball = Instance.new("ScreenGui")
local Draggble = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local ScrollingFrame = Instance.new("ScrollingFrame")
local ToogleAUTOcomplete = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")

--Properties:

Scriptforgame_1_Robux__1_ball.Name = "Scriptforgame_1_Robux_=_1_ball"
Scriptforgame_1_Robux__1_ball.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Scriptforgame_1_Robux__1_ball.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Scriptforgame_1_Robux__1_ball.ResetOnSpawn = false

Draggble.Name = "Draggble"
Draggble.Parent = Scriptforgame_1_Robux__1_ball
Draggble.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
Draggble.BorderColor3 = Color3.fromRGB(0, 0, 0)
Draggble.BorderSizePixel = 0
Draggble.Position = UDim2.new(0.615900397, 0, 0.270664513, 0)
Draggble.Size = UDim2.new(0.33141762, 0, 0.0972447321, 0)

UICorner.CornerRadius = UDim.new(1, 8)
UICorner.Parent = Draggble

ScrollingFrame.Parent = Draggble
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0, 0, 0.5, 0)
ScrollingFrame.Size = UDim2.new(1, 0, 5, 0)
ScrollingFrame.ScrollBarThickness = 30

ToogleAUTOcomplete.Name = "Toogle AUTO complete"
ToogleAUTOcomplete.Parent = ScrollingFrame
ToogleAUTOcomplete.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
ToogleAUTOcomplete.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToogleAUTOcomplete.BorderSizePixel = 0
ToogleAUTOcomplete.Position = UDim2.new(0, 0, 0.0969171673, 0)
ToogleAUTOcomplete.Size = UDim2.new(1, 0, 0.150000006, 0)
ToogleAUTOcomplete.Font = Enum.Font.SourceSans
ToogleAUTOcomplete.Text = "Toogle AUTO complete: OFF"
ToogleAUTOcomplete.TextColor3 = Color3.fromRGB(0, 0, 0)
ToogleAUTOcomplete.TextSize = 14.000

UICorner_2.CornerRadius = UDim.new(1, 0)
UICorner_2.Parent = ToogleAUTOcomplete


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


local Toggle = false
local CodeRanned = true
task.spawn(function()
	while task.wait(8) do
		if Toggle == false then
			print("not toggled!")
		else
			if CodeRanned == true then
				CodeRanned = false
				--------------------------Best robust working code
				
				game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position = Vector3.new(-924,1274,1195)
				task.wait(1)
				game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position = Vector3.new(-924,1272,1195)
				task.wait(1)
				game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position = Vector3.new(-924,1276,1195)
				task.wait(4)
				local found = false
				for i,v in workspace:GetDescendants() do
					if v.Name == "SafePart121jn2ofgh1kefas" then
						found = true
					end
				end
				task.wait(1)
				if found == false then
					local part = Instance.new("Part", workspace)
					part.Name = "SafePart121jn2ofgh1kefas"
					part.Position = Vector3.new(-924,1270,1195)
					part.Size = Vector3.new(10,1,10)
					part.Anchored = true
				end
				if game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z >= 1070 and game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z <= 1111 and game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X >= -670 and game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X <= -600 then
					print("Succes")
					CodeRanned = true
				else
					print("Failed")
					print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X)
					print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y)
					print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)
					game.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Linear), {Position = Vector3.new(-924,1274,1195)}):Play()
					task.wait(7)
					if game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z >= 1070 and game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z <= 1111 and game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X >= -670 and game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X <= -600 then
						print("Succes")
						CodeRanned = true
					else
						print("Failed")
						print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X)
						print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y)
						print(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)
						game.TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Linear), {Position = Vector3.new(-924,1274,1195)}):Play()
						task.wait(6)
						CodeRanned = true
					end
				end
			end
		end
	end
end)

ToogleAUTOcomplete.MouseButton1Click:Connect(function()
	if Toggle == false then
		Toggle = true
		ToogleAUTOcomplete.Text = "Auto complete: ON"
	else
		Toggle = false
		ToogleAUTOcomplete.Text = "Auto complete: OFF"         
	end
end)
--loadstring(game:HttpGet("https://raw.githubusercontent.com/DanielNov2014/RobloxLocalScriptsHacks/main/1Robux=1Ball/AutoCompleteHardObby.lua"))()
