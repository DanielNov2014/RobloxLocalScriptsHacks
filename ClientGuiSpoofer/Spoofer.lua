local player = game.Players.LocalPlayer

local function serializeUDim2(udim2)
	return string.format("UDim2.new(%s, %s, %s, %s)", udim2.X.Scale, udim2.X.Offset, udim2.Y.Scale, udim2.Y.Offset)
end

local function serializeColor3(color3)
	return string.format("Color3.fromRGB(%d, %d, %d)", color3.R * 255, color3.G * 255, color3.B * 255)
end

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
	return code
end

local outputGui = Instance.new("ScreenGui")
outputGui.Name = "GuiCodeOutput"
outputGui.Parent = player:WaitForChild("PlayerGui")

local outputBox = Instance.new("TextBox")
outputBox.Size = UDim2.new(0.85, 0, 0.7, 0)
outputBox.Position = UDim2.new(0.075, 0, 0.15, 0)
outputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
outputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
outputBox.Font = Enum.Font.Code
outputBox.TextSize = 14
outputBox.TextWrapped = false
outputBox.TextXAlignment = Enum.TextXAlignment.Left
outputBox.TextYAlignment = Enum.TextYAlignment.Top
outputBox.ClearTextOnFocus = false
outputBox.MultiLine = true
outputBox.TextEditable = true
outputBox.Text = "-- Enter the path to your UI below (e.g. StarterGui.Loading) and press the button to generate code.\n-- If no ScreenGui is found, a default one will be created."
outputBox.Parent = outputGui

local pathBox = Instance.new("TextBox")
pathBox.Size = UDim2.new(0.7, 0, 0, 36)
pathBox.Position = UDim2.new(0.15, 0, 0.07, 0)
pathBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
pathBox.TextColor3 = Color3.fromRGB(255, 255, 255)
pathBox.Font = Enum.Font.Code
pathBox.TextSize = 18
pathBox.TextWrapped = false
pathBox.TextXAlignment = Enum.TextXAlignment.Left
pathBox.TextYAlignment = Enum.TextYAlignment.Center
pathBox.ClearTextOnFocus = false
pathBox.MultiLine = false
pathBox.TextEditable = true
pathBox.PlaceholderText = "Type UI path here (e.g. StarterGui.Loading)"
pathBox.Parent = outputGui

local generateButton = Instance.new("TextButton")
generateButton.Size = UDim2.new(0, 200, 0, 40)
generateButton.Position = UDim2.new(0.5, -100, 0.93, 0)
generateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
generateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
generateButton.Font = Enum.Font.SourceSansBold
generateButton.TextSize = 22
generateButton.Text = "Generate UI Code"
generateButton.Parent = outputGui

local function findInstanceByPath(path)
	local segments = {}
	for segment in string.gmatch(path, "[^.]+") do
		table.insert(segments, segment)
	end
	if #segments == 0 then return nil end
	local root = game
	if root:FindFirstChild(segments[1]) then
		root = root:FindFirstChild(segments[1])
	else
		local ok, service = pcall(function() return game:GetService(segments[1]) end)
		if ok and service then
			root = service
		else
			return nil
		end
	end
	for i = 2, #segments do
		if root and root:FindFirstChild(segments[i]) then
			root = root:FindFirstChild(segments[i])
		else
			return nil
		end
	end
	return root
end

local function generateGuiCodeFromPath(path)
	local code = "local player = game.Players.LocalPlayer\n\n"
	local uiInstance = findInstanceByPath(path)
	if not uiInstance then
		-- If not found, create a default ScreenGui
		code = code .. "-- WARNING: Could not find UI at path '" .. path .. "'.\n"
		code = code .. "-- Creating a default ScreenGui named 'Default'.\n"
		code = code .. "local Default = Instance.new(\"ScreenGui\")\n"
		code = code .. "Default.Name = \"Default\"\n"
		code = code .. "Default.Parent = player:WaitForChild(\"PlayerGui\")\n"
		code = code .. "\n-- Add your UI elements to Default below\n"
		return code
	end
	if not uiInstance:IsA("ScreenGui") then
		return "-- ERROR: Instance at path is not a ScreenGui"
	end
	code = code .. string.format("local %s = Instance.new(\"ScreenGui\")\n", uiInstance.Name)
	code = code .. string.format("%s.Name = \"%s\"\n", uiInstance.Name, uiInstance.Name)
	code = code .. string.format("%s.Parent = player:WaitForChild(\"PlayerGui\")\n", uiInstance.Name)
	for _, descendant in uiInstance:GetDescendants() do
		code = code .. generateCodeForInstance(descendant)
		if descendant.Parent and descendant.Parent ~= uiInstance then
			code = code .. string.format("%s.Parent = %s\n", descendant.Name, descendant.Parent.Name)
		else
			code = code .. string.format("%s.Parent = %s\n", descendant.Name, uiInstance.Name)
		end
	end
	code = code .. "\n"
	return code
end

generateButton.MouseButton1Click:Connect(function()
	local path = pathBox.Text
	if path == "" then
		outputBox.Text = "-- ERROR: Please enter a path to your UI (e.g. StarterGui.Loading)"
		return
	end
	outputBox.Text = generateGuiCodeFromPath(path)
end)

