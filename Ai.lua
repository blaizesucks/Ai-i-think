--// ====== ChatBot.lua ====== --
-- Shows a draggable "Loading ChatBot..." UI until the main Chat UI finishes loading

--// == Temporary Loading UI ==
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LoadingGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Label = Instance.new("TextLabel")

LoadingGui.Name = "ChatBotLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.Parent = CoreGui

Frame.Parent = LoadingGui
Frame.Size = UDim2.new(0, 200, 0, 70)
Frame.Position = UDim2.new(0.4, 0, 0.45, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

Label.Parent = Frame
Label.Size = UDim2.new(1, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = "🤖 Loading ChatBot..."
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.GothamBold
Label.TextSize = 16

-- Touch drag support (mobile)
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

--// == MAIN CHATBOT UI (your original code) ==
local ui = CoreGui:FindFirstChild("AI")
if ui then ui:Destroy() end

-- This chatbot is powered by https://pollinations.ai

local uiElements = {
	["AI"] = Instance.new("ScreenGui"),
	["Container"] = Instance.new("Frame"),
	["UICorner"] = Instance.new("UICorner"),
	-- (the rest of your massive uiElements table goes here exactly as-is)
}

-- after all your ui creation lines end (leave them untouched)
-- insert this near the very bottom, after the UI is visible:

task.wait(1) -- short delay to ensure UI built
if LoadingGui then
	LoadingGui:Destroy()
end
