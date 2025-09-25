local player = game.Players.LocalPlayer

-- Function to serialize UDim2 to string
local function serializeUDim2(udim2)
	return string.format("UDim2.new(%s, %s, %s, %s)", udim2.X.Scale, udim2.X.Offset, udim2.Y.Scale, udim2.Y.Offset)
end

-- Function to serialize Color3 to string
local function serializeColor3(color3)
	return string.format("Color3.fromRGB(%d, %d, %d)", color3.R * 255, color3.G * 255, color3.B * 255)
end

-- Function to generate Lua code for a UI element
local function generateCodeForInstance(instance)
	local code = ""
	local className = instance.ClassName
	code = code .. string.format("local %s = Instance.new(\"%s\")\n", instance.Name, className)
	code = code .. string.format("%s.Name = \"%s\"\n", instance.Name, instance.Name)
	if instance:IsA("GuiObject") then
		code = code .. string.format("%s.Size = %s\n", instance.Name, serializeUDim2(instance.Size))
		code = code .. string.format("%s.Position = %s\n", instance.Name, serializeUDim2(instance.Position))
		if instance.BackgroundColor3 then
			code = code .. string.format("%s.BackgroundColor3 = %s\n", instance.Name, serializeColor3(instance.BackgroundColor3))
		end
	end
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
		code = code .. string.format("%s.Text = \"%s\"\n", instance.Name, instance.Text)
		code = code .. string.format("%s.TextColor3 = %s\n", instance.Name, serializeColor3(instance.TextColor3))
		code = code .. string.format("%s.Font = Enum.Font.%s\n", instance.Name, tostring(instance.Font):gsub("Enum.Font.", ""))
		code = code .. string.format("%s.TextSize = %d\n", instance.Name, instance.TextSize)
	end
	-- Parent assignment will be handled later
	return code
end
-- Function to generate code for all UI in PlayerGui
local function generateGuiCode()
	local playerGui = player:WaitForChild("PlayerGui")
	local code = "local player = game.Players.LocalPlayer\n\n"
	for _, screenGui in playerGui:GetChildren() do
		if screenGui:IsA("ScreenGui") then
			code = code .. string.format("local %s = Instance.new(\"ScreenGui\")\n", screenGui.Name)
			code = code .. string.format("%s.Name = \"%s\"\n", screenGui.Name, screenGui.Name)
			code = code .. string.format("%s.Parent = player:WaitForChild(\"PlayerGui\")\n", screenGui.Name)
			for _, descendant in screenGui:GetDescendants() do
				code = code .. generateCodeForInstance(descendant)
				-- Set parent
				if descendant.Parent and descendant.Parent ~= screenGui then
					code = code .. string.format("%s.Parent = %s\n", descendant.Name, descendant.Parent.Name)
				else
					code = code .. string.format("%s.Parent = %s\n", descendant.Name, screenGui.Name)
				end
			end
			code = code .. "\n"
		end
	end
	return code
end
-- Create a GUI to display the generated code
local outputGui = Instance.new("ScreenGui")
outputGui.Name = "GuiCodeOutput"
outputGui.Parent = player:WaitForChild("PlayerGui")
local outputBox = Instance.new("TextBox")
outputBox.Size = UDim2.new(0.7, 0, 0.7, 0)
outputBox.Position = UDim2.new(0.15, 0, 0.15, 0)
outputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
outputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
outputBox.Font = Enum.Font.Code
outputBox.TextSize = 18
outputBox.TextWrapped = true
outputBox.TextXAlignment = Enum.TextXAlignment.Left
outputBox.TextYAlignment = Enum.TextYAlignment.Top
outputBox.ClearTextOnFocus = false
outputBox.MultiLine = true
outputBox.Text = "-- Press the button below to generate code from your UI"
outputBox.Parent = outputGui
local generateButton = Instance.new("TextButton")
generateButton.Size = UDim2.new(0, 200, 0, 40)
generateButton.Position = UDim2.new(0.5, -100, 0.88, 0)
generateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
generateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
generateButton.Font = Enum.Font.SourceSansBold
generateButton.TextSize = 22
generateButton.Text = "Generate UI Code"
generateButton.Parent = outputGui
generateButton.MouseButton1Click:Connect(function()
	outputBox.Text = generateGuiCode()
end)
