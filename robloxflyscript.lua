local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Fly Control",
    LoadingTitle = "Loading",
    LoadingSubtitle = "by i_want_tobe_famouse",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Config"
    }
})
local Tab = Window:CreateTab("Fly Settings", 4483362458)
local Tab2 = Window:CreateTab("Speed Changer", 4483362458)
local Tab4 = Window:CreateTab("TP", 4483362458)
local Tab3 = Window:CreateTab("Discord", 4483362458)
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local function startFlying()
    if flying then return end
    flying = true
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
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
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
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
local flyToggle = Tab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            startFlying()
        else
            stopFlying()
        end
    end,
})
local speedInput = Tab:CreateInput({
    Name = "Fly Speed",
    PlaceholderText = "Enter speed...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local newSpeed = tonumber(Text)
        if newSpeed and newSpeed > 0 then
            flySpeed = newSpeed
            if flying then
                stopFlying()
                startFlying()
            end
        end
    end,
})
local discordButton1 = Tab3:CreateButton({
    Name = "Get all kinds of scripts",
    Callback = function()
        if syn then
            syn.write_clipboard("https://discord.gg/MtFU8qmpqJ")
        elseif setclipboard then
            setclipboard("https://discord.gg/MtFU8qmpqJ")
        else
            print("This exploit doesnt support clipboards")
        end
        Rayfield:Notify({
            Title = "Copied!",
            Content = "Discord invite link copied to clipboard.",
            Duration = 3,
            Image = 4483362458,
        })
    end
})
local discordButton2 = Tab3:CreateButton({
    Name = "Owner discord server!",
    Callback = function()
        if syn then
            syn.write_clipboard("https://discord.gg/tX9dd54a6e")
        elseif setclipboard then
            setclipboard("https://discord.gg/tX9dd54a6e")
        else
            print("This exploit doesnt support clipboards")
        end
        Rayfield:Notify({
            Title = "Copied!",
            Content = "Discord invite link copied to clipboard.",
            Duration = 3,
            Image = 4483362458,
        })
    end
})
local walkSpeedEnabled = false
local walkSpeedSlider = Tab2:CreateSlider({
    Name = "Walk Speed",
    Range = {5, 1000},
    Increment = 5,
    Suffix = " studs/sec",
    CurrentValue = 16,
    Callback = function(Value)
        if walkSpeedEnabled then
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = Value
            end
        end
    end
})
local walkSpeedToggle = Tab2:CreateToggle({
    Name = "Enable Walk Speed Control",
    CurrentValue = false,
    Callback = function(Value)
        walkSpeedEnabled = Value
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            if Value then
                player.Character.Humanoid.WalkSpeed = walkSpeedSlider.CurrentValue
            else
                player.Character.Humanoid.WalkSpeed = 16 -- Revert to default speed
            end
        end
    end
})
local targetPlayerName = ""
local TeleportButton = Tab4:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        -- Find the target player
        local targetPlayer = nil
        for i, v in pairs(game.Players:GetPlayers()) do
            if string.lower(v.Name) == string.lower(targetPlayerName) then
                targetPlayer = v
                break
            end
        end
        -- Teleport to the target player
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local char = player.Character
            local root = char:WaitForChild("HumanoidRootPart")
            root.CFrame = targetHRP.CFrame + Vector3.new(0, 5, 0) -- Teleport above the player
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Player not found or no HumanoidRootPart",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

local TargetPlayerInput = Tab4:CreateInput({
    Name = "Enter player full user name (not display name)",
    PlaceholderText = "Enter player name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        targetPlayerName = Text
    end,
})
Rayfield:LoadConfiguration()
