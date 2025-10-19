-- Destroy previous UI if exists
local ui = game:GetService("CoreGui"):FindFirstChild("AI")
if ui then ui:Destroy() end

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

-- Parent ScreenGui
uiElements["AI"].Parent = game:GetService("CoreGui")
uiElements["AI"].Name = "AI"

-- Container
local Container = uiElements["Container"]
Container.Parent = uiElements["AI"]
Container.Position = UDim2.new(0.5,0,0.5,0)
Container.Size = UDim2.new(0.584,0,0.657,0)
Container.BackgroundColor3 = Color3.fromRGB(15,15,15)
Container.AnchorPoint = Vector2.new(0.5,0.5)
uiElements["UICorner"].Parent = Container
uiElements["UICorner"].CornerRadius = UDim.new(0,14)
uiElements["UIStroke"].Parent = Container
uiElements["UIStroke"].Color = Color3.fromRGB(40,40,40)

-- Chat
local Chat = uiElements["Chat"]
Chat.Parent = Container
Chat.Size = UDim2.new(1,0,0.979,-64)
Chat.BackgroundTransparency = 1

-- Messages
local Messages = uiElements["Messages"]
Messages.Parent = Chat
Messages.Position = UDim2.new(0,0,0.108,0)
Messages.Size = UDim2.new(1,0,0.993,0)
Messages.BackgroundTransparency = 1
Messages.BorderSizePixel = 0
Messages.AutomaticCanvasSize = Enum.AutomaticSize.Y
Messages.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
Messages.ScrollBarThickness = 8

-- User template
local UserTemplate = uiElements["UserTemplate"]
UserTemplate.Parent = Messages
UserTemplate.Size = UDim2.new(0,100,0,30)
UserTemplate.BackgroundColor3 = Color3.fromRGB(23,23,23)
UserTemplate.AnchorPoint = Vector2.new(1,0)
UserTemplate.Visible = false
uiElements["UICorner_1"].Parent = UserTemplate
uiElements["UISizeConstraint"].Parent = UserTemplate

local Message = uiElements["Message"]
Message.Parent = UserTemplate
Message.Size = UDim2.new(1,0,1,0)
Message.BackgroundTransparency = 1
Message.Font = Enum.Font.GothamMedium
Message.TextColor3 = Color3.fromRGB(190,190,190)
Message.TextSize = 18
Message.RichText = true
Message.TextWrapped = true

uiElements["UIPadding"].Parent = Message
uiElements["UIPadding"].PaddingTop = UDim.new(0,3)
uiElements["UIPadding"].PaddingBottom = UDim.new(0,3)
uiElements["UIPadding"].PaddingLeft = UDim.new(0,8)
uiElements["UIPadding"].PaddingRight = UDim.new(0,8)

-- System template
local SysTemplate = uiElements["SysTemplate"]
SysTemplate.Parent = Messages
SysTemplate.Size = UDim2.new(0,100,0,30)
SysTemplate.BackgroundTransparency = 1
SysTemplate.Visible = false
uiElements["UICorner_2"].Parent = SysTemplate
uiElements["UISizeConstraint_1"].Parent = SysTemplate

local Message_1 = uiElements["Message_1"]
Message_1.Parent = SysTemplate
Message_1.Size = UDim2.new(1,0,1,0)
Message_1.BackgroundTransparency = 1
Message_1.Font = Enum.Font.GothamMedium
Message_1.TextColor3 = Color3.fromRGB(190,190,190)
Message_1.TextSize = 18
Message_1.RichText = true
Message_1.TextWrapped = true
Message_1.TextXAlignment = Enum.TextXAlignment.Left

uiElements["UIPadding_2"].Parent = Message_1
uiElements["UIPadding_2"].PaddingTop = UDim.new(0,3)
uiElements["UIPadding_2"].PaddingBottom = UDim.new(0,3)
uiElements["UIPadding_2"].PaddingLeft = UDim.new(0,8)
uiElements["UIPadding_2"].PaddingRight = UDim.new(0,8)

-- Header
local Header = uiElements["Header"]
Header.Parent = Chat
Header.Size = UDim2.new(1,0,-0.018,50)
Header.BackgroundColor3 = Color3.fromRGB(20,20,20)
Header.BorderSizePixel = 0
uiElements["UICorner_3"].Parent = Header

local Icon = uiElements["Icon"]
Icon.Parent = Header
Icon.Position = UDim2.new(0,8,0,8)
Icon.Size = UDim2.new(0,30,0,30)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://125966901198850"

local Icon1 = uiElements["Icon1"]
Icon1.Parent = Header
Icon1.Position = UDim2.new(1,-8,0,8)
Icon1.Size = UDim2.new(0,30,0,30)
Icon1.AnchorPoint = Vector2.new(1,0)
Icon1.BackgroundTransparency = 1
Icon1.Image = "rbxassetid://73985599900390"

-- Input bar
local InputBar = uiElements["InputBar"]
InputBar.Parent = Container
InputBar.Position = UDim2.new(0,0,1,0)
InputBar.Size = UDim2.new(1,0,0,0)
InputBar.AnchorPoint = Vector2.new(0,1)
InputBar.BackgroundTransparency = 1

local Bar = uiElements["Bar"]
Bar.Parent = InputBar
Bar.Position = UDim2.new(0.5,0,1,-4)
Bar.Size = UDim2.new(1,-16,1,0)
Bar.BackgroundColor3 = Color3.fromRGB(23,23,23)
Bar.AnchorPoint = Vector2.new(0.5,1)
Bar.ClearTextOnFocus = false
Bar.TextEditable = true
Bar.Font = Enum.Font.GothamMedium
Bar.TextColor3 = Color3.fromRGB(220,220,220)
Bar.TextSize = 18
Bar.PlaceholderText = "Ask anything"
Bar.TextWrapped = true
Bar.TextXAlignment = Enum.TextXAlignment.Left
uiElements["UICorner_4"].Parent = Bar
uiElements["UIStroke_1"].Parent = Bar
uiElements["UIStroke_1"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements["UIStroke_1"].Color = Color3.fromRGB(40,40,40)
uiElements["UIStroke_1"].Thickness = 0.6

-- Helper functions
local function richText(txt)
    txt = txt:gsub("%*%*([^\n%*]+)%*%*","<b>%1</b>")
    txt = txt:gsub("~~([^\n~]+)~~","<strike>%1</strike>")
    return txt
end

local function createMessage(IsUser, MessageText)
    local Clone = IsUser and UserTemplate:Clone() or SysTemplate:Clone()
    Clone.Message.Text = richText(MessageText)
    Clone.Visible = true
    Clone.Parent = Messages
    local yOffset = 0
    for _, child in ipairs(Messages:GetChildren()) do
        if child:IsA("Frame") and child.Visible then
            yOffset += child.AbsoluteSize.Y
        end
    end
    Clone.Position = UDim2.new(Clone.AnchorPoint.X, 0, 0, yOffset + 10)
    Messages.CanvasSize = UDim2.new(0,0,0,yOffset + Clone.AbsoluteSize.Y)
    Messages.CanvasPosition = Vector2.new(0, yOffset + Clone.AbsoluteSize.Y)
    return Clone
end

-- Draggable GUI
local dragging, dragInput, dragStart, startPos
Container.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Container.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Container.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Messages list
local messages = {}

-- Input handling
Bar.FocusLost:Connect(function(enterPressed)
    if enterPressed and Bar.Text ~= "" then
        local userMsg = Bar.Text
        Bar.Text = ""
        table.insert(messages, {role="user", content=userMsg})
        local responseMsg = createMessage(false,"Thinking...")
        createMessage(true,userMsg)
        
        -- Here you can integrate your Pollinations AI API logic:
        -- send 'messages' to API and update responseMsg.Message.Text with AI reply
    end
end)
