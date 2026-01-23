-- LocalScript - Place in StarterPlayer > StarterPlayerScripts
-- MOBILE VERSION - Optimized for Delta/Mobile

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- State Variables
local isSpectating = false
local steppedConnection = nil
local originalWalkSpeed = 16
local spectatorSpeed = 50

-- ========== CREATE MOBILE UI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpectatorGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Mini Open Button
local miniButton = Instance.new("TextButton")
miniButton.Name = "MiniButton"
miniButton.Size = UDim2.new(0, 70, 0, 70)
miniButton.Position = UDim2.new(1, -80, 0, 10)
miniButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
miniButton.BorderSizePixel = 0
miniButton.Text = "👻"
miniButton.TextSize = 32
miniButton.Font = Enum.Font.GothamBold
miniButton.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(1, 0)
miniCorner.Parent = miniButton

-- Main Menu Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 450)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Header Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BorderSizePixel = 0
title.Text = "👻 GHOST MODE"
title.TextColor3 = Color3.white
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = title

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 45, 0, 45)
closeButton.Position = UDim2.new(1, -52, 0, 7)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.white
closeButton.TextSize = 24
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- Main TOGGLE Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 300, 0, 80)
toggleButton.Position = UDim2.new(0.5, -150, 0, 80)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
toggleButton.Text = "🚀 ENABLE GHOST"
toggleButton.TextColor3 = Color3.white
toggleButton.TextSize = 22
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleButton

-- Status Indicator
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 50)
statusLabel.Position = UDim2.new(0, 20, 0, 175)
statusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
statusLabel.BorderSizePixel = 0
statusLabel.Text = "⚪ Status: NORMAL"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 18
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusLabel

-- Speed Info Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -40, 0, 40)
speedLabel.Position = UDim2.new(0, 20, 0, 245)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Flight Speed: 50"
speedLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
speedLabel.TextSize = 20
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

-- Speed Preset Buttons
local speedButtons = Instance.new("Frame")
speedButtons.Size = UDim2.new(1, -40, 0, 120)
speedButtons.Position = UDim2.new(0, 20, 0, 295)
speedButtons.BackgroundTransparency = 1
speedButtons.Parent = mainFrame

local speedPresets = {
    {text = "🐌 SLOW\n25", value = 25, color = Color3.fromRGB(100, 150, 255)},
    {text = "🚶 NORMAL\n50", value = 50, color = Color3.fromRGB(100, 200, 255)},
    {text = "🏃 FAST\n80", value = 80, color = Color3.fromRGB(255, 180, 100)},
    {text = "🚀 INSANE\n120", value = 120, color = Color3.fromRGB(255, 100, 100)}
}

for i, preset in ipairs(speedPresets) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.48, 0, 0.45, 0)
    btn.Position = UDim2.new(
        (i-1) % 2 * 0.52, 
        0, 
        math.floor((i-1) / 2) * 0.52, 
        0
    )
    btn.BackgroundColor3 = preset.color
    btn.Text = preset.text
    btn.TextColor3 = Color3.white
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = speedButtons
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        spectatorSpeed = preset.value
        speedLabel.Text = "⚡ Flight Speed: " .. preset.value
        if isSpectating then
            humanoid.WalkSpeed = spectatorSpeed
        end
    end)
end

-- ========== CORE FUNCTIONS ==========

local function setNoclip(enabled)
    if not character then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end

local function setTransparency(transparency)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = transparency
        elseif part:IsA("Decal") or part:IsA("Face") then
            part.Transparency = transparency
        end
    end
end

local function enableSpectator()
    if isSpectating then return end
    isSpectating = true
    
    originalWalkSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = spectatorSpeed
    
    steppedConnection = RunService.Stepped:Connect(function()
        setNoclip(true)
    end)
    
    setTransparency(0.7)
    
    -- Update UI
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggleButton.Text = "🛑 DISABLE GHOST"
    statusLabel.Text = "🟢 Status: ACTIVE"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    statusLabel.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
    miniButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end

local function disableSpectator()
    if not isSpectating then return end
    isSpectating = false
    
    if steppedConnection then
        steppedConnection:Disconnect()
        steppedConnection = nil
    end
    
    setNoclip(false)
    setTransparency(0)
    humanoid.WalkSpeed = originalWalkSpeed
    
    -- Update UI
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    toggleButton.Text = "🚀 ENABLE GHOST"
    statusLabel.Text = "⚪ Status: NORMAL"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    miniButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end

-- ========== EVENTS ==========

miniButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

toggleButton.MouseButton1Click:Connect(function()
    if isSpectating then
        disableSpectator()
    else
        enableSpectator()
    end
end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    if isSpectating then
        disableSpectator()
    end
end)
