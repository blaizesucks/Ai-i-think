-- Destroy old AI UI if exists
local oldUI = game:GetService("CoreGui"):FindFirstChild("AI")
if oldUI then oldUI:Destroy() end

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- UI Elements
local uiElements = {
	["AI"] = Instance.new("ScreenGui"),
	["Container"] = Instance.new("Frame"),
	["UICorner"] = Instance.new("UICorner"),
	["Chat"] = Instance.new("Frame"),
	["Messages"] = Instance.new("ScrollingFrame"),
	["UserTemplate"] = Instance.new("Frame"),
	["UICorner_1"] = Instance.new("UICorner"),
	["Message"] = Instance.new("TextLabel"),
	["UIPadding"] = Instance.new("UIPadding"),
	["UISizeConstraint"] = Instance.new("UISizeConstraint"),
	["UIPadding_1"] = Instance.new("UIPadding"),
	["SysTemplate"] = Instance.new("Frame"),
	["UICorner_2"] = Instance.new("UICorner"),
	["Message_1"] = Instance.new("TextLabel"),
	["UIPadding_2"] = Instance.new("UIPadding"),
	["UISizeConstraint_1"] = Instance.new("UISizeConstraint"),
	["Buttons"] = Instance.new("Frame"),
	["UIListLayout"] = Instance.new("UIListLayout"),
	["UIPadding_3"] = Instance.new("UIPadding"),
	["Copy"] = Instance.new("ImageButton"),
	["Header"] = Instance.new("Frame"),
	["Icon"] = Instance.new("ImageLabel"),
	["Icon1"] = Instance.new("ImageLabel"),
	["UICorner_3"] = Instance.new("UICorner"),
	["UIStroke"] = Instance.new("UIStroke"),
	["InputBar"] = Instance.new("Frame"),
	["Bar"] = Instance.new("TextBox"),
	["UIPadding_4"] = Instance.new("UIPadding"),
	["UICorner_4"] = Instance.new("UICorner"),
	["UIStroke_1"] = Instance.new("UIStroke"),
}

-- Parent GUI
uiElements["AI"].Parent = game:GetService("CoreGui")
uiElements["AI"].Name = "AI"

-- Container
local Container = uiElements["Container"]
Container.Parent = uiElements["AI"]
Container.Position = UDim2.new(0.5,0,0.5,0)
Container.Size = UDim2.new(0.584,0,0.656,0)
Container.AnchorPoint = Vector2.new(0.5,0.5)
Container.BackgroundColor3 = Color3.fromRGB(15,15,15)
uiElements["UICorner"].Parent = Container
uiElements["UIStroke"].Parent = Container
uiElements["UIStroke"].Color = Color3.fromRGB(40,40,40)

-- Chat
local Chat = uiElements["Chat"]
Chat.Parent = Container
Chat.Size = UDim2.new(1,0,0.978, -64)
Chat.BackgroundTransparency = 1

local Messages = uiElements["Messages"]
Messages.Parent = Chat
Messages.Position = UDim2.new(0,0,0.107,0)
Messages.Size = UDim2.new(1,0,0.993,0)
Messages.BackgroundTransparency = 1
Messages.BorderSizePixel = 0
Messages.AutomaticCanvasSize = Enum.AutomaticSize.Y
Messages.ScrollBarThickness = 8

-- User Template
local UserTemplate = uiElements["UserTemplate"]
UserTemplate.Parent = Messages
UserTemplate.Size = UDim2.new(0,100,0,30)
UserTemplate.Visible = false
UserTemplate.BackgroundColor3 = Color3.fromRGB(23,23,23)
UserTemplate.BorderSizePixel = 0
uiElements["UICorner_1"].Parent = UserTemplate
uiElements["UISizeConstraint"].Parent = UserTemplate

local UserMessage = uiElements["Message"]
UserMessage.Parent = UserTemplate
UserMessage.Size = UDim2.new(1,0,1,0)
UserMessage.BackgroundTransparency = 1
UserMessage.Font = Enum.Font.GothamMedium
UserMessage.TextSize = 18
UserMessage.RichText = true
UserMessage.TextColor3 = Color3.fromRGB(190,190,190)
UserMessage.TextWrapped = true

uiElements["UIPadding"].Parent = UserMessage
uiElements["UIPadding"].PaddingTop = UDim.new(0,3)
uiElements["UIPadding"].PaddingBottom = UDim.new(0,3)
uiElements["UIPadding"].PaddingLeft = UDim.new(0,8)
uiElements["UIPadding"].PaddingRight = UDim.new(0,8)

-- System Template
local SysTemplate = uiElements["SysTemplate"]
SysTemplate.Parent = Messages
SysTemplate.Size = UDim2.new(0,100,0,30)
SysTemplate.BackgroundColor3 = Color3.fromRGB(23,23,23)
SysTemplate.Visible = false
SysTemplate.BackgroundTransparency = 1
SysTemplate.BorderSizePixel = 0
uiElements["UICorner_2"].Parent = SysTemplate
uiElements["UISizeConstraint_1"].Parent = SysTemplate

local SysMessage = uiElements["Message_1"]
SysMessage.Parent = SysTemplate
SysMessage.Size = UDim2.new(1,0,1,0)
SysMessage.BackgroundTransparency = 1
SysMessage.Font = Enum.Font.GothamMedium
SysMessage.TextSize = 18
SysMessage.RichText = true
SysMessage.TextColor3 = Color3.fromRGB(190,190,190)
SysMessage.TextWrapped = true
SysMessage.TextXAlignment = Enum.TextXAlignment.Left

uiElements["UIPadding_2"].Parent = SysMessage
uiElements["UIPadding_2"].PaddingTop = UDim.new(0,3)
uiElements["UIPadding_2"].PaddingBottom = UDim.new(0,3)
uiElements["UIPadding_2"].PaddingLeft = UDim.new(0,8)
uiElements["UIPadding_2"].PaddingRight = UDim.new(0,8)

-- Buttons for copy
local Buttons = uiElements["Buttons"]
Buttons.Parent = SysTemplate
Buttons.Position = UDim2.new(0,0,1,0)
Buttons.Size = UDim2.new(1,0,0,15)
Buttons.BackgroundTransparency = 1
Buttons.BorderSizePixel = 0
uiElements["UIListLayout"].Parent = Buttons
uiElements["UIListLayout"].FillDirection = Enum.FillDirection.Horizontal
uiElements["UIListLayout"].Padding = UDim.new(0,4)
uiElements["UIPadding_3"].Parent = Buttons
uiElements["UIPadding_3"].PaddingLeft = UDim.new(0,4)

local CopyButton = uiElements["Copy"]
CopyButton.Parent = Buttons
CopyButton.Size = UDim2.new(0,15,1,0)
CopyButton.BackgroundTransparency = 1
CopyButton.Image = "rbxassetid://93531807477279"

-- Header
local Header = uiElements["Header"]
Header.Parent = Chat
Header.Size = UDim2.new(1,0,-0.017,50)
Header.BackgroundColor3 = Color3.fromRGB(20,20,20)
Header.BorderSizePixel = 0
uiElements["Icon"].Parent = Header
uiElements["Icon"].Position = UDim2.new(0,8,0,8)
uiElements["Icon"].Size = UDim2.new(0,30,0,30)
uiElements["Icon"].BackgroundTransparency = 1
uiElements["Icon"].Image = "rbxassetid://125966901198850"
uiElements["Icon1"].Parent = Header
uiElements["Icon1"].Position = UDim2.new(1,-8,0,8)
uiElements["Icon1"].Size = UDim2.new(0,30,0,30)
uiElements["Icon1"].AnchorPoint = Vector2.new(1,0)
uiElements["Icon1"].BackgroundTransparency = 1
uiElements["Icon1"].Image = "rbxassetid://73985599900390"
uiElements["UICorner_3"].Parent = Header
uiElements["UICorner_3"].CornerRadius = UDim.new(1,0)

-- Input bar
local InputBar = uiElements["InputBar"]
InputBar.Parent = Container
InputBar.Position = UDim2.new(0,0,1,0)
InputBar.Size = UDim2.new(1,0,0,0)
InputBar.AnchorPoint = Vector2.new(0,1)
InputBar.BackgroundTransparency = 1

local Bar = uiElements["Bar"]
Bar.Parent = InputBar
Bar.Size = UDim2.new(1,-16,1,0)
Bar.Position = UDim2.new(0.5,0,1,-4)
Bar.AnchorPoint = Vector2.new(0.5,1)
Bar.BackgroundColor3 = Color3.fromRGB(23,23,23)
Bar.BorderSizePixel = 0
Bar.Font = Enum.Font.GothamMedium
Bar.TextColor3 = Color3.fromRGB(220,220,220)
Bar.TextSize = 18
Bar.Text = ""
Bar.PlaceholderText = "Ask anything"
uiElements["UICorner_4"].Parent = Bar
uiElements["UIStroke_1"].Parent = Bar
uiElements["UIStroke_1"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements["UIStroke_1"].Color = Color3.fromRGB(40,40,40)
uiElements["UIStroke_1"].Thickness = 0.6

-- AI logic
local lastBox, lastFocusReleased, isGenerating
local messages = {
	{role="system", content="You are a helpful AI assistant."}
}

local function richText(txt)
	txt = txt:gsub("%*%*([^\n%*]+)%*%*", "<b>%1</b>")
	txt = txt:gsub("~~([^\n~]+)~~", "<strike>%1</strike>")
	return txt
end

local function copy(b)
	if setclipboard then
		setclipboard(b.Text)
	else
		print("Copy not available in this environment")
	end
end

local function createMessage(IsUser, Message)
	local Clone = IsUser and UserTemplate:Clone() or SysTemplate:Clone()
	Clone.Message.Text = richText(Message)
	Clone.Visible = true
	Clone.Parent = Messages
	Clone.Size = UDim2.new(Clone.Size.X.Scale, Clone.Size.X.Offset, 0, Clone.Message.TextBounds.Y + 2)
	if not IsUser then
		Clone.Buttons.Copy.MouseButton1Click:Connect(function() copy(Clone.Message) end)
	end
	local yOffset = 0
	for _, child in ipairs(Messages:GetChildren()) do
		if child:IsA("Frame") and child.Visible then
			yOffset += child.AbsoluteSize.Y
		end
	end
	Clone.Position = UDim2.new(Clone.AnchorPoint.X,0,0,yOffset + 10)
	Messages.CanvasSize = UDim2.new(0,0,yOffset + Clone.AbsoluteSize.Y)
	return Clone
end

UserInputService.InputBegan:Connect(function(Input, GPE)
	if Input.KeyCode == Enum.KeyCode.Return and lastBox == Bar then
		if isGenerating then return end
		local Prompt = Bar.Text
		Bar.Text = ""
		currentOffset += createMessage(true,Prompt).AbsoluteSize.Y
		table.insert(messages,{role="user", content=Prompt})
		isGenerating = true
		local Response = createMessage(false,"Thinking...")
		task.spawn(function()
			local dots = 0
			while isGenerating do
				dots = (dots % 3) + 1
				Response.Message.Text = "Thinking"..string.rep(".",dots)
				task.wait(.3)
			end
		end)
		task.spawn(function()
			local http_func = request or http and http.request or http_request or syn and syn.request
			local Result
			if http_func then
				local Data = {
					Url = "https://text.pollinations.ai/openai",
					Method = "POST",
					Headers = {["Content-Type"]="application/json"},
					Body = HttpService:JSONEncode({messages=messages})
				}
				Result = HttpService:JSONDecode(http_func(Data).Body)
			else
				Result = {choices={{message={content="HTTP unavailable"}}}}
			end
			isGenerating = false
			local reply = (Result.choices and Result.choices[1].message.content) or "No reply"
			table.insert(messages,{role="system", content=reply})
			Response.Message.Text = richText(reply)
		end)
	end
end)
