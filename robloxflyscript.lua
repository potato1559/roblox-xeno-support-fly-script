local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "1559Hub",
    LoadingTitle = "1559Hub is loading...",
    LoadingSubtitle = "Made by i_want_tobe_famouse",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "1559HubConfig",
        FileName = "Settings"
    }
})

-- Player Services
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Fly System
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro

local function startFlying()
    if flying then return end
    flying = true
    
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    
    if not rootPart then
        Rayfield:Notify({Title = "Error", Content = "HumanoidRootPart not found!"})
        return
    end

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    RunService.RenderStepped:Connect(function()
        if not flying then return end
        
        local input = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then input += Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then input += Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then input += Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then input += Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then input += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then input += Vector3.new(0, -1, 0) end

        bodyVelocity.Velocity = (workspace.CurrentCamera.CFrame:VectorToWorldSpace(input) * flySpeed)
        bodyGyro.CFrame = workspace.CurrentCamera.CoordinateFrame
    end)
end

local function stopFlying()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

-- Fly Tab
local FlyTab = Window:CreateTab("Fly Settings", 4483362458)
FlyTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        if Value then startFlying() else stopFlying() end
    end
})

FlyTab:CreateInput({
    Name = "Fly Speed",
    PlaceholderText = tostring(flySpeed),
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num > 0 then flySpeed = num end
    end
})

-- Speed Changer Tab
local SpeedTab = Window:CreateTab("Speed Changer", 4483362458)

local walkSpeedEnabled = false
local walkSpeed = 16

SpeedTab:CreateToggle({
    Name = "Walk Speed",
    CurrentValue = false,
    Callback = function(Value)
        walkSpeedEnabled = Value
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value and walkSpeed or 16
        end
    end
})

SpeedTab:CreateInput({
    Name = "Walk Speed Value",
    PlaceholderText = tostring(walkSpeed),
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num > 0 then
            walkSpeed = num
            if walkSpeedEnabled then
                player.Character.Humanoid.WalkSpeed = walkSpeed
            end
        end
    end
})

local tpWalkEnabled = false
local tpWalkDistance = 5

SpeedTab:CreateToggle({
    Name = "TP Walk",
    CurrentValue = false,
    Callback = function(Value)
        tpWalkEnabled = Value
    end
})

SpeedTab:CreateInput({
    Name = "TP Walk Distance",
    PlaceholderText = tostring(tpWalkDistance),
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        tpWalkDistance = tonumber(Text) or 5
    end
})

RunService.RenderStepped:Connect(function()
    if tpWalkEnabled and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and humanoid.MoveDirection.Magnitude > 0 and root then
            root.CFrame = root.CFrame + (humanoid.MoveDirection * tpWalkDistance)
        end
    end
end)

-- TP Tab
local TPTab = Window:CreateTab("Teleport", 4483362458)
TPTab:CreateButton({
    Name = "Teleport to Random Player",
    Callback = function()
        local players = game:GetService("Players"):GetPlayers()
        local target = players[math.random(2, #players)] -- Skip local player
        if target and target.Character then
            player.Character:MoveTo(target.Character.PrimaryPart.Position)
        end
    end
})

-- Discord Tab
local DiscordTab = Window:CreateTab("Discord", 4483362458)
DiscordTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/your-invite-code")
        Rayfield:Notify({
            Title = "Copied!",
            Content = "Discord link copied to clipboard",
            Duration = 3,
            Image = 4483362458
        })
    end
})

Rayfield:LoadConfiguration()
