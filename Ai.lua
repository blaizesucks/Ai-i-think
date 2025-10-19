-- Destroy old UI if exists
local ui = game:GetService("CoreGui"):FindFirstChild("AI")
if ui then ui:Destroy() end

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Templates
local uiElements = {
    ["AI"] = Instance.new("ScreenGui"),
    ["Container"] = Instance.new("Frame"),
    ["UICorner"] = Instance.new("UICorner"),
    ["Chat"] = Instance.new("Frame"),
    ["Messages"] = Instance.new("ScrollingFrame"),
    ["UserTemplate"] = Instance.new("Frame"),
    ["Message"] = Instance.new("TextLabel"),
    ["SysTemplate"] = Instance.new("Frame"),
    ["SysMessage"] = Instance.new("TextLabel"),
    ["InputBar"] = Instance.new("Frame"),
    ["Bar"] = Instance.new("TextBox"),
}

-- Basic UI setup
local AI = uiElements.AI
AI.Name = "AI"
AI.Parent = game:GetService("CoreGui")

local Container = uiElements.Container
Container.Size = UDim2.new(0.6,0,0.65,0)
Container.Position = UDim2.new(0.5,0,0.5,0)
Container.AnchorPoint = Vector2.new(0.5,0.5)
Container.BackgroundColor3 = Color3.fromRGB(15,15,15)
uiElements.UICorner.Parent = Container
uiElements.UICorner.CornerRadius = UDim.new(0,14)
Container.Parent = AI

-- Chat scrolling
local Chat = uiElements.Chat
Chat.Size = UDim2.new(1,0,0.9,0)
Chat.BackgroundTransparency = 1
Chat.Parent = Container

local Messages = uiElements.Messages
Messages.Size = UDim2.new(1,0,1,0)
Messages.BackgroundTransparency = 1
Messages.BorderSizePixel = 0
Messages.CanvasSize = UDim2.new(0,0,0,0)
Messages.ScrollBarThickness = 8
Messages.Parent = Chat

-- Templates
local function createTemplate(name)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,100,0,30)
    frame.BackgroundTransparency = 1
    frame.Visible = false

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.GothamMedium
    text.TextColor3 = Color3.fromRGB(190,190,190)
    text.TextSize = 18
    text.TextWrapped = true
    text.RichText = true
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Name = name
    text.Parent = frame

    return frame
end

local userTemplate = createTemplate("Message")
local sysTemplate = createTemplate("SysMessage")

-- Input bar
local InputBar = uiElements.InputBar
InputBar.Size = UDim2.new(1,0,0,40)
InputBar.Position = UDim2.new(0,0,1,0)
InputBar.AnchorPoint = Vector2.new(0,1)
InputBar.BackgroundTransparency = 1
InputBar.Parent = Container

local Bar = uiElements.Bar
Bar.Size = UDim2.new(1,-16,1,0)
Bar.Position = UDim2.new(0.5,0,0,0)
Bar.AnchorPoint = Vector2.new(0.5,0)
Bar.BackgroundColor3 = Color3.fromRGB(23,23,23)
Bar.BorderSizePixel = 0
Bar.PlaceholderText = "Ask anything"
Bar.TextColor3 = Color3.fromRGB(220,220,220)
Bar.TextSize = 18
Bar.TextWrapped = true
Bar.TextXAlignment = Enum.TextXAlignment.Left
Bar.Parent = InputBar

-- Drag functionality
local dragging = false
local dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

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

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- RichText helper
local function richText(txt)
    txt = txt:gsub("%*%*([^\n%*]+)%*%*", "<b>%1</b>")
    txt = txt:gsub("~~([^\n~]+)~~", "<strike>%1</strike>")
    return txt
end

-- Message creation
local messages = {}

local function createMessage(isUser, msg)
    local clone = isUser and userTemplate:Clone() or sysTemplate:Clone()
    clone.Visible = true
    clone.Parent = Messages

    local labelName = isUser and "Message" or "SysMessage"
    local textLabel = clone:FindFirstChild(labelName)
    if not textLabel then
        textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1,0,1,0)
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.GothamMedium
        textLabel.TextColor3 = Color3.fromRGB(190,190,190)
        textLabel.TextSize = 18
        textLabel.TextWrapped = true
        textLabel.RichText = true
        textLabel.Name = labelName
        textLabel.Parent = clone
    end

    textLabel.Text = richText(msg)
    clone.Size = UDim2.new(clone.Size.X.Scale, clone.Size.X.Offset, 0, textLabel.TextBounds.Y + 4)

    -- Position messages
    local yOffset = 0
    for _, c in ipairs(Messages:GetChildren()) do
        if c:IsA("Frame") and c.Visible then
            yOffset += c.AbsoluteSize.Y
        end
    end
    clone.Position = UDim2.new(clone.AnchorPoint.X, 0, 0, yOffset + 5)
    Messages.CanvasSize = UDim2.new(0,0,0,yOffset + clone.AbsoluteSize.Y + 10)

    return clone
end

-- Sending messages
Bar.FocusLost:Connect(function(enterPressed)
    if enterPressed and Bar.Text ~= "" then
        local msg = Bar.Text
        Bar.Text = ""
        table.insert(messages, {role="user", content=msg})
        createMessage(true, msg)
        createMessage(false, "Thinking...") -- placeholder for AI response
    end
end)
