-- Fly Control GUI (Xeno-Compatible)
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 210)
frame.Position = UDim2.new(0.5, -100, 0.5, -105)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "made by i_want_tobe_famouse on discord"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

local flyButton = Instance.new("TextButton")
flyButton.Text = "Fly"
flyButton.Size = UDim2.new(0.8, 0, 0, 30)
flyButton.Position = UDim2.new(0.1, 0, 0.25, 0)
flyButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.8)
flyButton.Parent = frame

local unflyButton = Instance.new("TextButton")
unflyButton.Text = "Unfly"
unflyButton.Size = UDim2.new(0.8, 0, 0, 30)
unflyButton.Position = UDim2.new(0.1, 0, 0.45, 0)
unflyButton.BackgroundColor3 = Color3.new(0.8, 0.4, 0.4)
unflyButton.Parent = frame

local speedButton = Instance.new("TextButton")
speedButton.Text = "Change Fly Speed (50)"
speedButton.Size = UDim2.new(0.8, 0, 0, 30)
speedButton.Position = UDim2.new(0.1, 0, 0.65, 0)
speedButton.BackgroundColor3 = Color3.new(0.4, 0.8, 0.4)
speedButton.Parent = frame

local unloadButton = Instance.new("TextButton")
unloadButton.Text = "Unload GUI"
unloadButton.Size = UDim2.new(0.8, 0, 0, 30)
unloadButton.Position = UDim2.new(0.1, 0, 0.85, 0)
unloadButton.BackgroundColor3 = Color3.new(1, 0.4, 0.4)
unloadButton.Parent = frame

-- Fly Variables
local flying = false
local flySpeed = 50
local bodyVelocity
local bodyGyro
local flyConnection

-- Fly Functions
local function startFlying()
    if flying then return end
    
    flying = true
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 10000
    bodyGyro.D = 100
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end
        
        local input = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then input = input + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then input = input + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then input = input + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then input = input + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then input = input + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then input = input + Vector3.new(0, -1, 0) end
        
        if input.Magnitude > 0 then
            bodyVelocity.Velocity = (workspace.CurrentCamera.CFrame:VectorToWorldSpace(input) * flySpeed)
        else
            bodyVelocity.Velocity = Vector3.zero
        end
        
        bodyGyro.CFrame = workspace.CurrentCamera.CoordinateFrame
    end)
end

local function stopFlying()
    if not flying then return end
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    if flyConnection then flyConnection:Disconnect() end
end

-- Speed Input (Xeno-Compatible)
local function changeSpeed()
    local inputBox = Instance.new("TextBox")
    inputBox.Parent = frame
    inputBox.Size = UDim2.new(0.8, 0, 0, 30)
    inputBox.Position = speedButton.Position
    inputBox.BackgroundColor3 = Color3.new(1, 1, 1)
    inputBox.TextColor3 = Color3.new(0, 0, 0)
    inputBox.Text = tostring(flySpeed)
    inputBox.TextScaled = true
    inputBox.ClearTextOnFocus = false
    
    local function submit()
        local newSpeed = tonumber(inputBox.Text)
        if newSpeed and newSpeed > 0 then
            flySpeed = newSpeed
            speedButton.Text = "Change Fly Speed ("..flySpeed..")"
        end
        inputBox:Destroy()
    end
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submit()
        end
    end)
    
    inputBox:CaptureFocus()
end

-- Button Events
flyButton.MouseButton1Click:Connect(function()
    stopFlying()
    startFlying()
end)

unflyButton.MouseButton1Click:Connect(stopFlying)
speedButton.MouseButton1Click:Connect(changeSpeed)
unloadButton.MouseButton1Click:Connect(function()
    stopFlying()
    screenGui:Destroy()
end)
