local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Check if Rayfield loaded properly
if not Rayfield then
	error("Failed to load Rayfield UI Library.")
	return
end

local Window = Rayfield:CreateWindow({
	Name = "1559Hub",
	LoadingTitle = "Loading",
	LoadingSubtitle = "by i_want_tobe_famouse",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "Config"
	}
})

-- Check if Window creation was successful
if not Window then
	error("Failed to create the main window.")
	return
end

local Tab = Window:CreateTab("Fly Settings", 4483362458)
local Tab2 = Window:CreateTab("Speed Changer", 4483362458)
local Tab4 = Window:CreateTab("TP", 4483362458)
local Tab3 = Window:CreateTab("Discord", 4483362458)

-- Check if Tabs creation was successful
if not Tab or not Tab2 or not Tab3 or not Tab4 then
	error("Failed to create one or more tabs.")
	return
end

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

local jumpPowerSlider = Tab:CreateSlider({
	Name = "Jump Power",
	Range = {0, 1000},
	Increment = 10,
	Suffix = " Power",
	CurrentValue = 50,
	Callback = function(Value)
		if player and player.Character and player.Character:FindFirstChild("Humanoid") then
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if humanoid and jumpPowerEnabled then
				humanoid.JumpPower = Value
			end
		end
	end
})

local jumpPowerEnabled = true
local jumpPowerToggle = Tab:CreateToggle({
	Name = "Enable Jump Power",
	CurrentValue = true,
	Callback = function(Value)
		jumpPowerEnabled = Value
		if player and player.Character and player.Character:FindFirstChild("Humanoid") then
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if humanoid then
				if Value then
					humanoid.JumpPower = jumpPowerSlider.CurrentValue
				else
					humanoid.JumpPower = 50
				end
			end
		end
	end,
})

local gravityEnabled = true
local gravitySlider = Tab:CreateSlider({
	Name = "Gravity",
	Range = {-1000, 1000},
	Increment = 50,
	Suffix = " Agility",
	CurrentValue = 196.2,
	Callback = function(Value)
		if gravityEnabled then
			workspace.Gravity = Value
		end
	end
})

local gravityToggle = Tab:CreateToggle({
	Name = "Enable Gravity Control",
	CurrentValue = true,
	Callback = function(Value)
		gravityEnabled = Value
		if Value then
			workspace.Gravity = gravitySlider.CurrentValue
		else
			workspace.Gravity = 196.2
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

-- TP Walk Feature
local tpWalkEnabled = false
local tpWalkDistance = 5
local tpWalkConnection = nil

local TpWalkToggle = Tab2:CreateToggle({
	Name = "TP Walk",
	CurrentValue = false,
	Callback = function(Value)
		tpWalkEnabled = Value
		if Value then
			tpWalkConnection = RunService.RenderStepped:Connect(function()
				if player.Character and player.Character:FindFirstChild("Humanoid") then
					local humanoid = player.Character.Humanoid
					local root = player.Character:FindFirstChild("HumanoidRootPart")

					if root and humanoid.MoveDirection.Magnitude > 0 then
						local offset = humanoid.MoveDirection * tpWalkDistance
						root.CFrame = root.CFrame + Vector3.new(offset.X, 0, offset.Z)
					end
				end
			end)
		else
			if tpWalkConnection then
				tpWalkConnection:Disconnect()
				tpWalkConnection = nil
			end
		end
	end,
})

local TpWalkDistanceInput = Tab2:CreateInput({
	Name = "TP Walk Distance",
	PlaceholderText = "Studs per frame (1-50)",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		local num = tonumber(Text)
		if num and num > 0 then
			tpWalkDistance = math.clamp(num, 1, 50) -- Safer distance limits
			Rayfield:Notify({
				Title = "TP Walk Updated",
				Content = "New distance: " .. tpWalkDistance .. " studs/frame",
				Duration = 2,
				Image = 4483362458,
			})
		else
			Rayfield:Notify({
				Title = "Invalid Input",
				Content = "Please enter a positive number",
				Duration = 3,
				Image = 4483362458,
			})
		end
	end,
})

local targetPlayerName = ""
local teleportDistance = 5
local loopDelay = 1
local isLoopingSelected = false
local loopConnectionSelected = nil
local isLooping = false
local loopConnection = nil

local TargetPlayerInput = Tab4:CreateInput({
	Name = "Enter player full user name (not display name)",
	PlaceholderText = "Enter player name...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		targetPlayerName = Text
	end
})

local TeleportDistanceInput = Tab4:CreateInput({
	Name = "Teleport Distance (studs)",
	PlaceholderText = "Enter distance...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		local newDistance = tonumber(Text)
		if newDistance then
			teleportDistance = newDistance
		else
			teleportDistance = 5
			Rayfield:Notify({
				Title = "Invalid Distance",
				Content = "Invalid distance. Set to default (5 studs).",
				Duration = 3,
				Image = 4483362458,
			})
		end
	end
})

local function teleportToRandomPlayer()
	local players = game:GetService("Players"):GetPlayers()
	local localPlayer = game:GetService("Players").LocalPlayer

	-- Remove the local player from the list
	local availablePlayers = {}
	for i, v in pairs(players) do
		if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(availablePlayers, v)
		end
	end

	if #availablePlayers > 0 then
		local randomIndex = math.random(1, #availablePlayers)
		local targetPlayer = availablePlayers[randomIndex]
		local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

		if targetHRP then
			local char = player.Character
			local root = char:WaitForChild("HumanoidRootPart")
			root.CFrame = targetHRP.CFrame + Vector3.new(0, 5, 0) -- Teleport above the player
			Rayfield:Notify({
				Title = "Teleported",
				Content = "Teleported to " .. targetPlayer.Name,
				Duration = 3,
				Image = 4483362458,
			})
		else
			Rayfield:Notify({
				Title = "Error",
				Content = "Target player's HumanoidRootPart not found.",
				Duration = 3,
				Image = 4483362458,
			})
		end
	else
		Rayfield:Notify({
			Title = "Error",
			Content = "No other players found with a HumanoidRootPart.",
			Duration = 3,
			Image = 4483362458,
		})
	end
end

local function toggleLoopTeleport()
	isLooping = not isLooping

	if isLooping then
		-- Start the loop
		loopConnection = RunService.Heartbeat:Connect(function()
			teleportToRandomPlayer()
			task.wait(loopDelay)
		end)
		Rayfield:Notify({
			Title = "Looping Teleport",
			Content = "Looping teleport to random players started.",
			Duration = 3,
			Image = 4483362458,
		})
	else
		-- Stop the loop
		if loopConnection then
			loopConnection:Disconnect()
			loopConnection = nil
		end
		Rayfield:Notify({
			Title = "Looping Teleport",
			Content = "Looping teleport to random players stopped.",
			Duration = 3,
			Image = 4483362458,
		})
	end
end

local function toggleLoopTeleportToSelected()
	isLoopingSelected = not isLoopingSelected
	if isLoopingSelected then
		if targetPlayerName == "" then
			Rayfield:Notify({
				Title = "Error",
				Content = "Please enter a player name first.",
				Duration = 3,
				Image = 4483362458,
			})
			isLoopingSelected = false
			return
		end

		loopConnectionSelected = RunService.Heartbeat:Connect(function()
			local targetPlayer = nil
			for i, v in pairs(game.Players:GetPlayers()) do
				if string.lower(v.Name) == string.lower(targetPlayerName) then
					targetPlayer = v
					break
				end
			end

			if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
				local char = player.Character
				local root = char:WaitForChild("HumanoidRootPart")
				root.CFrame = targetHRP.CFrame + Vector3.new(0, teleportDistance, 0)
				task.wait(loopDelay)

			else
				Rayfield:Notify({
					Title = "Error",
					Content = "Player not found or no HumanoidRootPart",
					Duration = 3,
					Image = 4483362458,
				})
				isLoopingSelected = false
				loopConnectionSelected:Disconnect()
				loopConnectionSelected = nil
				return
			end
		end)
		Rayfield:Notify({
			Title = "Looping Teleport",
			Content = "Looping teleport to " .. targetPlayerName .. " started.",
			Duration = 3,
			Image = 4483362458,
		})
	else
		if loopConnectionSelected then
			loopConnectionSelected:Disconnect()
			loopConnectionSelected = nil
		end
		Rayfield:Notify({
			Title = "Looping Teleport",
			Content = "Looping teleport to selected player stopped.",
			Duration = 3,
			Image = 4483362458,
		})
	end
end

local function stopLoopTeleport()
	-- Stop the loop
	if isLooping then
		isLooping = false
		if loopConnection then
			loopConnection:Disconnect()
			loopConnection = nil
		end
		Rayfield:Notify({
			Title = "Looping Teleport",
			Content = "Looping teleport to random players stopped.",
			Duration = 3,
			Image = 4483362458,
		})
	else
		Rayfield:Notify({
			Title = "Looping Teleport",
			Content = "Looping teleport is already stopped.",
			Duration = 3,
			Image = 4483362458,
		})
	end
end

local function stopLoopTeleportSelected()
	-- Stop the loop
	if isLoopingSelected then
		isLoopingSelected = false
		if loopConnectionSelected then
			loopConnectionSelected:Disconnect()
			loopConnectionSelected = nil
		end
		Rayfield:Notify({
			Title = "Looping Teleport",
			Content = "Looping teleport to selected player stopped.",
			Duration = 3,
			Image = 4483362458,
		})
	else
		Rayfield:Notify({
			Title = "Looping Teleport",
			Content = "Looping teleport is already stopped.",
			Duration = 3,
			Image = 4483362458,
		})
	end
end

local RandomTeleportButton = Tab4:CreateButton({
	Name = "Teleport to Random Player",
	Callback = teleportToRandomPlayer
})

local LoopTeleportButton = Tab4:CreateButton({
	Name = "Loop Teleport to Random Player",
	Callback = toggleLoopTeleport
})

local StopLoopTeleportButton = Tab4:CreateButton({
	Name = "Stop Loop Teleport",
	Callback = stopLoopTeleport
})

local LoopTeleportSelectedButton = Tab4:CreateButton({
	Name = "Loop Teleport to Selected Player",
	Callback = toggleLoopTeleportToSelected
})

local StopLoopTeleportSelectedButton = Tab4:CreateButton({
	Name = "Stop Loop Teleport to Selected Player",
	Callback = stopLoopTeleportSelected
})

local WebsiteButton = Tab3:CreateButton({
	Name = "Our Website",
	Callback = function()
		if syn then
			syn.write_clipboard("https://sites.google.com/view/1559hub/home")
		elseif setclipboard then
			setclipboard("https://sites.google.com/view/1559hub/home")
		else
			print("This exploit doesnt support clipboards")
		end
		Rayfield:Notify({
			Title = "Copied!",
			Content = "Website link copied to clipboard.",
			Duration = 3,
			Image = 4483362458,
		})
	end
})

local TeleportToSelectedButton = Tab4:CreateButton({
	Name = "Teleport to Selected Player",
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
			root.CFrame = targetHRP.CFrame + Vector3.new(0, teleportDistance, 0) -- Teleport above the player
			Rayfield:Notify({
				Title = "Teleported",
				Content = "Teleported to " .. targetPlayer.Name,
				Duration = 3,
				Image = 4483362458,
			})
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

local LoopDelayInput = Tab4:CreateInput({
	Name = "Loop Delay (seconds)",
	PlaceholderText = "Enter delay...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		local newDelay = tonumber(Text)
		if newDelay and newDelay > 0 then
			loopDelay = newDelay
		else
			loopDelay = 1
			Rayfield:Notify({
				Title = "Invalid Delay",
				Content = "Invalid delay. Set to default (1 second).",
				Duration = 3,
				Image = 4483362458,
			})
		end
	end
})

for i, tab in pairs(Window.Tabs) do
	tab.ScrollingEnabled = true
end

Rayfield:LoadConfiguration()
