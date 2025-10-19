-- Destroy existing AI GUI
local CoreGui = game:GetService("CoreGui")
local existing = CoreGui:FindFirstChild("AI")
if existing then existing:Destroy() end

-- Services
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- HTTP function for executors
local http_func = request or http and http.request or http_request or syn and syn.request
if not http_func then
    error("No HTTP function found! Use an executor with HTTP request support.")
end

-- UI setup
local AI = Instance.new("ScreenGui")
AI.Name = "AI"
AI.Parent = CoreGui

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.AnchorPoint = Vector2.new(0.5, 0.5)
Container.Position = UDim2.new(0.5, 0, 0.5, 0)
Container.Size = UDim2.new(0.6, 0, 0.6, 0)
Container.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Container.Active = true
Container.Draggable = true
Container.Parent = AI

local UICorner = Instance.new("UICorner", Container)
UICorner.CornerRadius = UDim.new(0, 14)

-- Chat frame
local Chat = Instance.new("Frame", Container)
Chat.Size = UDim2.new(1, 0, 0.9, 0)
Chat.BackgroundTransparency = 1

local Messages = Instance.new("ScrollingFrame", Chat)
Messages.Size = UDim2.new(1, 0, 1, 0)
Messages.BackgroundTransparency = 1
Messages.BorderSizePixel = 0
Messages.CanvasSize = UDim2.new(0, 0, 0, 0)
Messages.AutomaticCanvasSize = Enum.AutomaticSize.Y
Messages.ScrollBarThickness = 8

-- User & system message templates
local function createTemplate(isUser)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 100, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.AutomaticSize = Enum.AutomaticSize.XY
    frame.ClipsDescendants = true

    local msg = Instance.new("TextLabel", frame)
    msg.Size = UDim2.new(1, 0, 1, 0)
    msg.BackgroundTransparency = 1
    msg.Font = Enum.Font.GothamMedium
    msg.TextColor3 = Color3.fromRGB(190, 190, 190)
    msg.TextSize = 18
    msg.RichText = true
    msg.TextWrapped = true
    msg.TextXAlignment = isUser and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(1,0)

    if not isUser then
        local btn = Instance.new("ImageButton", frame)
        btn.Size = UDim2.new(0, 15, 0, 15)
        btn.Position = UDim2.new(1, -18, 0, 2)
        btn.Image = "rbxassetid://93531807477279"
        btn.BackgroundTransparency = 1
        btn.MouseButton1Click:Connect(function() 
            if setclipboard then setclipboard(msg.Text) end
        end)
    end

    return frame
end

local userTemplate = createTemplate(true)
local sysTemplate = createTemplate(false)

-- Input bar
local InputBar = Instance.new("Frame", Container)
InputBar.Size = UDim2.new(1, 0, 0.1, 0)
InputBar.Position = UDim2.new(0,0,0.9,0)
InputBar.BackgroundTransparency = 1

local Box = Instance.new("TextBox", InputBar)
Box.Size = UDim2.new(1, -16, 1, -8)
Box.Position = UDim2.new(0, 8, 0, 4)
Box.AnchorPoint = Vector2.new(0,0)
Box.BackgroundColor3 = Color3.fromRGB(23,23,23)
Box.BorderSizePixel = 0
Box.TextColor3 = Color3.fromRGB(220,220,220)
Box.PlaceholderText = "Ask anything"
Box.TextWrapped = true
Box.ClearTextOnFocus = false
Box.TextXAlignment = Enum.TextXAlignment.Left
local BoxCorner = Instance.new("UICorner", Box)
BoxCorner.CornerRadius = UDim.new(1,0)

-- Message handling
local messages = {
    {role = "system", content = "You are a helpful AI assistant."}
}

local function richText(txt)
    txt = txt:gsub("%*%*([^\n%*]+)%*%*", "<b>%1</b>")
    txt = txt:gsub("~~([^\n~]+)~~", "<strike>%1</strike>")
    return txt
end

local function addMessage(isUser, text)
    local clone = isUser and userTemplate:Clone() or sysTemplate:Clone()
    clone.Message.Text = richText(text)
    clone.Visible = true
    clone.Parent = Messages
    clone.Size = UDim2.new(clone.Size.X.Scale, clone.Size.X.Offset, 0, clone.Message.TextBounds.Y + 8)

    local yOffset = 0
    for _, c in ipairs(Messages:GetChildren()) do
        if c:IsA("Frame") and c.Visible then
            yOffset = yOffset + c.AbsoluteSize.Y + 6
        end
    end
    clone.Position = UDim2.new(0,0,0,yOffset)
    Messages.CanvasSize = UDim2.new(0,0,0,yOffset + clone.AbsoluteSize.Y)
    Messages.CanvasPosition = Vector2.new(0, Messages.CanvasSize.Y.Offset)
    return clone
end

-- Sending requests
local isGenerating = false
local function askAI(prompt)
    if isGenerating then return end
    isGenerating = true

    addMessage(true, prompt)
    local responseMsg = addMessage(false, "Thinking...")

    task.spawn(function()
        local dots = 1
        while isGenerating do
            responseMsg.Message.Text = "Thinking"..string.rep(".", dots)
            dots = (dots % 3) + 1
            task.wait(0.33)
        end
    end)

    local data = HttpService:JSONEncode({messages = messages})
    local requestData = {
        Url = "https://text.pollinations.ai/openai",
        Method = "POST",
        Headers = {["Content-Type"]="application/json"},
        Body = data
    }

    task.spawn(function()
        local result = http_func(requestData)
        local decoded = HttpService:JSONDecode(result.Body)
        local content = (decoded.choices and decoded.choices[1] or {message={content="No response"}}).message.content
        table.insert(messages, {role="system", content=content})
        isGenerating = false
        responseMsg.Message.Text = richText(content)
    end)
end

-- Input handling
Box.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        askAI(Box.Text)
        Box.Text = ""
    end
end)
