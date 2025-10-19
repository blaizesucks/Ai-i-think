-- Destroy existing AI GUI if present
local ui = game:GetService("CoreGui"):FindFirstChild("AI")
if ui then ui:Destroy() end

-- Core services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Templates
local uiElements = {}

-- ScreenGui
uiElements.AI = Instance.new("ScreenGui")
uiElements.AI.Name = "AI"
uiElements.AI.ResetOnSpawn = false
uiElements.AI.IgnoreGuiInset = true
uiElements.AI.Parent = game:GetService("CoreGui")

-- Container
uiElements.Container = Instance.new("Frame")
uiElements.Container.Size = UDim2.new(0.6,0,0.65,0)
uiElements.Container.Position = UDim2.new(0.5,0,0.5,0)
uiElements.Container.AnchorPoint = Vector2.new(0.5,0.5)
uiElements.Container.BackgroundColor3 = Color3.fromRGB(15,15,15)
uiElements.Container.ZIndex = 1
uiElements.Container.Active = true
uiElements.Container.Parent = uiElements.AI

-- Make container draggable
local dragging, dragInput, dragStart, startPos
uiElements.Container.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = uiElements.Container.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
uiElements.Container.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		local delta = dragInput.Position - dragStart
		uiElements.Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- UI styling
local function addUICorner(frame, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0,radius)
	c.Parent = frame
end
addUICorner(uiElements.Container,14)

-- Chat frame
uiElements.Chat = Instance.new("Frame")
uiElements.Chat.Size = UDim2.new(1,0,0.92, -50)
uiElements.Chat.BackgroundTransparency = 1
uiElements.Chat.Position = UDim2.new(0,0,0,0)
uiElements.Chat.Parent = uiElements.Container
uiElements.Chat.ZIndex = 1

-- Messages scrolling frame
uiElements.Messages = Instance.new("ScrollingFrame")
uiElements.Messages.Size = UDim2.new(1,0,1,0)
uiElements.Messages.Position = UDim2.new(0,0,0,0)
uiElements.Messages.BackgroundTransparency = 1
uiElements.Messages.BorderSizePixel = 0
uiElements.Messages.ScrollBarThickness = 8
uiElements.Messages.AutomaticCanvasSize = Enum.AutomaticSize.Y
uiElements.Messages.CanvasSize = UDim2.new(0,0,0,0)
uiElements.Messages.ZIndex = 1
uiElements.Messages.Parent = uiElements.Chat

-- User template
uiElements.UserTemplate = Instance.new("Frame")
uiElements.UserTemplate.Size = UDim2.new(0,100,0,30)
uiElements.UserTemplate.BackgroundColor3 = Color3.fromRGB(23,23,23)
uiElements.UserTemplate.Visible = false
uiElements.UserTemplate.AnchorPoint = Vector2.new(1,0)
addUICorner(uiElements.UserTemplate,15)
uiElements.UserTemplate.Parent = uiElements.Messages

local userMsg = Instance.new("TextLabel")
userMsg.Size = UDim2.new(1,0,1,0)
userMsg.BackgroundTransparency = 1
userMsg.Font = Enum.Font.GothamMedium
userMsg.TextColor3 = Color3.fromRGB(190,190,190)
userMsg.TextSize = 18
userMsg.TextWrapped = true
userMsg.RichText = true
userMsg.TextXAlignment = Enum.TextXAlignment.Right
userMsg.Parent = uiElements.UserTemplate
uiElements.UserTemplate.Message = userMsg

-- System template
uiElements.SysTemplate = uiElements.UserTemplate:Clone()
uiElements.SysTemplate.AnchorPoint = Vector2.new(0,0)
uiElements.SysTemplate.Message.TextXAlignment = Enum.TextXAlignment.Left
uiElements.SysTemplate.Parent = uiElements.Messages
uiElements.SysTemplate.Visible = false

-- InputBar
uiElements.InputBar = Instance.new("Frame")
uiElements.InputBar.Size = UDim2.new(1,0,0,50)
uiElements.InputBar.Position = UDim2.new(0,0,1,0)
uiElements.InputBar.AnchorPoint = Vector2.new(0,1)
uiElements.InputBar.BackgroundTransparency = 1
uiElements.InputBar.ZIndex = 10
uiElements.InputBar.Parent = uiElements.Container

local bar = Instance.new("TextBox")
bar.Size = UDim2.new(1,-16,1,0)
bar.Position = UDim2.new(0.5,0,0.5,0)
bar.AnchorPoint = Vector2.new(0.5,0.5)
bar.BackgroundColor3 = Color3.fromRGB(23,23,23)
bar.TextColor3 = Color3.fromRGB(220,220,220)
bar.TextSize = 18
bar.PlaceholderText = "Ask anything"
bar.ClearTextOnFocus = false
bar.TextWrapped = true
bar.ZIndex = 20
bar.Parent = uiElements.InputBar
uiElements.Bar = bar

-- Helper functions
local messagesList = uiElements.Messages
local userTemplate, sysTemplate = uiElements.UserTemplate, uiElements.SysTemplate
local isGenerating = false
local messages = {
	{ role = "system", content = "You are a helpful AI assistant.\n" }
}

local function richText(txt)
	txt = txt:gsub("%*%*([^\n%*]+)%*%*", "<b>%1</b>")
	txt = txt:gsub("~~([^\n~]+)~~", "<strike>%1</strike>")
	return txt
end

local function createMessage(isUser,msg)
	local clone = isUser and userTemplate:Clone() or sysTemplate:Clone()
	clone.Visible = true
	clone.Message.Text = richText(msg)
	clone.Parent = messagesList
	clone.Size = UDim2.new(clone.Size.X.Scale, clone.Size.X.Offset, 0, clone.Message.TextBounds.Y + 2)
	local yOffset = 0
	for _, c in ipairs(messagesList:GetChildren()) do
		if c:IsA("Frame") and c.Visible then
			yOffset += c.AbsoluteSize.Y
		end
	end
	clone.Position = UDim2.new(clone.AnchorPoint.X,0,0,yOffset + 10)
	messagesList.CanvasSize = UDim2.new(0,0,0,yOffset + clone.AbsoluteSize.Y)
	messagesList.CanvasPosition = Vector2.new(0,yOffset + clone.AbsoluteSize.Y)
	return clone
end

-- Send message
bar.FocusLost:Connect(function(enterPressed)
	if not enterPressed or isGenerating then return end
	local prompt = bar.Text
	if prompt == "" then return end
	bar.Text = ""
	table.insert(messages, {role="user",content=prompt})
	isGenerating = true
	local responseClone = createMessage(false,"Thinking...")
	task.spawn(function()
		local dots = 0
		while isGenerating do
			dots = (dots % 3) + 1
			responseClone.Message.Text = "Thinking"..string.rep(".",dots)
			task.wait(0.33)
		end
	end)

	local http_func = request or http and http.request or http_request or syn and syn.request
	if not http_func then
		responseClone.Message.Text = "HTTP request not available!"
		isGenerating = false
		return
	end

	local data = {
		Url = "https://text.pollinations.ai/openai",
		Method = "POST",
		Headers = {["Content-Type"]="application/json"},
		Body = HttpService:JSONEncode({messages = messages})
	}
	local result = HttpService:JSONDecode(http_func(data).Body)
	isGenerating = false
	local msg = (result.choices and result.choices[1] or {message={content="Unable to fetch reply :("}}).message.content
	table.insert(messages,{role="system",content=msg})
	responseClone.Message.Text = richText(msg)
end)
