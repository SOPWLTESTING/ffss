local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local GUI = Mercury:Create{
	Name = "Shoot To Kill",
	Size = UDim2.fromOffset(600, 400),
	Theme = Mercury.Themes.Rust,
	Link = "https://github.com/deeeity/mercury-lib"
}
GUI:Notification{
	Title = "STK Hub Loaded",
	Text = "Thanks For Purchasing <3",
	Duration = 3,
	Callback = function() end
}
local MainTab = GUI:Tab{
	Name = "Main",
	Icon = "rbxassetid://18298087757"
}
local AimTab = GUI:Tab{
	Name = "Aim",
	Icon = "rbxassetid://18298087757"
}
local VisualsTab = GUI:Tab{
	Name = "Visuals",
	Icon = "rbxassetid://18298086732"
}
local AutofarmTab = GUI:Tab{
	Name = "AutoFarm",
	Icon = "rbxassetid://18298086732"
}
local TeleTab = GUI:Tab{
	Name = "Teleport",
	Icon = "rbxassetid://18298087757"
}
MainTab:Button{
	Name = "Instant Interact",
	Description = "Allows You To Instantly Press E On Prompts.",
	Callback = function()
		local function modifyProximityPrompts()
			local proximityPrompts = game:GetService("Workspace"):GetDescendants()
			for _, instance in ipairs(proximityPrompts) do
				if instance:IsA("ProximityPrompt") then
					instance.HoldDuration = 0
				end
			end
		end
		while true do
			modifyProximityPrompts()
			wait(5)
		end
	end
}
MainTab:Slider{
    Name = "Walk Speed",
    Default = 16,
    Min = 1,
    Max = 22.1,
    Description = "Adjust the walk speed of the character",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                while true do
                    humanoid.WalkSpeed = Value
                    wait(0.1)
                end
            end
        end
    end
}
MainTab:Button{
    Name = "DELETED FLOOR FIX",
	Description = "Stops You From Falling Threw Some Building. (TESTING).",
    Callback = function()
    local baseplateSize = Vector3.new(10000000000, 0, 10000000000)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local function SpawnBaseplate()
    local baseplatePosition = humanoidRootPart.Position + Vector3.new(0, -3.3, 0)
    local baseplate = Instance.new("Part")
    baseplate.Size = baseplateSize
    baseplate.Position = baseplatePosition
    baseplate.Anchored = true
    baseplate.CanCollide = true
    baseplate.Parent = game.Workspace
    baseplate.BrickColor = BrickColor.new("Dark stone grey")
    baseplate.Material = Enum.Material.Concrete
    end
    game.Players.LocalPlayer.CharacterAdded:Connect(function()
     SpawnBaseplate()
    end)
    if game.Players.LocalPlayer.Character then
    SpawnBaseplate()
    end
    end
}
MainTab:Button{
	Name = "C + Click Delete",
	Description = "Hold C and Click To Delete Modules.",
	Callback = function(state)
	local Plr = game:GetService("Players").LocalPlayer
    local Mouse = Plr:GetMouse()
    Mouse.Button1Down:connect(function()
    if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.C) then return end
    if not Mouse.Target then return end
    Mouse.Target:Destroy()
    end)
	end
}
AimTab:Toggle{
    Name = "Aimbot",
    Description = "Locks onto other players.",
    Callback = function(enabled)
        _G.AimbotEnabled = enabled

        if enabled then
            Holding = false -- Reset holding state when enabling Aimbot
        end
    end
}


AimTab:Toggle{
    Name = "FOV Circle",
    Description = "Toggle visibility of FOV Circle.",
    Callback = function(enabled)
        _G.CircleVisible = enabled
        FOVCircle.Visible = enabled
    end
}

AimTab:Slider{
    Name = "FOV Radius",
    Default = 60,
    Min = 20,
    Max = 150,
    Callback = function(value)
        _G.CircleRadius = value
        FOVCircle.Radius = value
    end
}

-- Other necessary variables and services
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Holding = false

_G.TeamCheck = false -- Set to true to lock aim at enemy team members only
_G.AimPart = "UpperTorso" -- Aimbot locks onto UpperTorso instead of Head
_G.Sensitivity = 0.1 -- Adjust how quickly the aimbot locks on (lower is slower)
_G.CircleSides = 64 -- FOV circle details
_G.CircleColor = Color3.fromRGB(255, 255, 255)
_G.CircleTransparency = 0.7
_G.CircleRadius = 60
_G.CircleFilled = false
_G.CircleVisible = false
_G.CircleThickness = 0

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

-- Function to get the closest player within FOV radius
local function GetClosestPlayer()
    local MaximumDistance = _G.CircleRadius
    local Target = nil

    for _, v in ipairs(Players:GetPlayers()) do
        if v.Name ~= LocalPlayer.Name then
            if _G.TeamCheck and v.Team ~= LocalPlayer.Team or not _G.TeamCheck then
                local character = v.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local ScreenPoint = Camera:WorldToScreenPoint(character.HumanoidRootPart.Position)
                        local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).magnitude
                        if VectorDistance < MaximumDistance then
                            Target = v
                            MaximumDistance = VectorDistance
                        end
                    end
                end
            end
        end
    end

    return Target
end

-- Toggle holding state when MouseButton2 is pressed
UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

-- RenderStepped function to handle aimbot and FOV Circle updates
RunService.RenderStepped:Connect(function()
    if Holding and _G.AimbotEnabled then
        local closestPlayer = GetClosestPlayer()
        if closestPlayer and closestPlayer.Character and closestPlayer.Character[_G.AimPart] then
            local torsoPosition = closestPlayer.Character[_G.AimPart].Position
            local torsoOffset = Vector3.new(math.random(-5, 5)/10, 0, math.random(-5, 5)/10) -- Random small offset for smoother movement
            local targetPosition = torsoPosition + torsoOffset
            TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)}):Play()
        end
    end

    -- Update FOV Circle visibility and properties
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = game.Workspace.CurrentCamera  -- Assuming Camera is accessible from this context

local espEnabled = false
local EspList = {}

-- Function to create ESP for a player
local function createESP(Player)
    local Box = Drawing.new("Square")
    Box.Thickness = 2
    Box.Filled = false
    Box.Color = Color3.fromRGB(230, 60, 0)  -- Orange color

    local function update()
        local Character = Player.Character
        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid and Humanoid.Health > 0 then
                local Pos, OnScreen = Camera:WorldToViewportPoint(Character.Head.Position)
                if OnScreen then
                    local X = Pos.X
                    local Y = Pos.Y
                    Box.Size = Vector2.new(2450 / Pos.Z, 3850 / Pos.Z)
                    Box.Position = Vector2.new(X - Box.Size.X / 2, Y - Box.Size.Y / 9)
                    Box.Visible = espEnabled
                    return
                end
            end
        end
        Box.Visible = false
    end
    update()

    local Connection1 = Player.CharacterAdded:Connect(function()
        update()
    end)
    local Connection2 = Player.CharacterRemoving:Connect(function()
        Box.Visible = false
    end)

    return {
        update = update,
        disconnect = function()
            Box:Remove()
            Connection1:Disconnect()
            Connection2:Disconnect()
        end
    }
end

-- Function to toggle ESP visibility
local function toggleESP(enabled)
    espEnabled = enabled
    for _, espInstance in ipairs(EspList) do
        espInstance.update()
    end
end

-- Function to create ESP for all current players
local function createAllESP()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= Players.LocalPlayer then
            table.insert(EspList, createESP(Player))
        end
    end
end

-- Handle new player joining
Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        table.insert(EspList, createESP(player))
    end
end)

-- Initialize ESP for existing players
createAllESP()

-- Connect to RenderStepped to update ESP positions
game:GetService("RunService").RenderStepped:Connect(function()
    for _, espInstance in ipairs(EspList) do
        espInstance.update()
    end
end)

-- Example of toggling ESP via UI (adjust this according to your UI setup)
VisualsTab:Toggle{
    Name = "Boxes",
    Description = "Shows Boxes Around Players.",
    Callback = function(state)
        espEnabled = state
        toggleESP(state)
    end
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = game.Workspace.CurrentCamera  -- Assuming Camera is accessible from this context

local espEnabled = false
local EspList = {}

-- Function to create ESP for a player
local function createESP(Player)
    local Name = Drawing.new("Text")
    Name.Text = Player.Name
    Name.Size = 16
    Name.Outline = true
    Name.Center = true
    Name.Color = Color3.fromRGB(230, 60, 0)  -- Blood orange color (RGB: 230, 60, 0)

    local function update()
        local Character = Player.Character
        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid and Humanoid.Health > 0 then
                local Pos, OnScreen = Camera:WorldToViewportPoint(Character.Head.Position)
                if OnScreen then
                    local X = Pos.X
                    local Y = Pos.Y
                    Name.Position = Vector2.new(X, Y - 33)
                    Name.Visible = espEnabled
                    return
                end
            end
        end
        Name.Visible = false
    end
    update()

    local Connection1 = Player.CharacterAdded:Connect(function()
        update()
    end)
    local Connection2 = Player.CharacterRemoving:Connect(function()
        Name.Visible = false
    end)

    return {
        update = update,
        disconnect = function()
            Name:Remove()
            Connection1:Disconnect()
            Connection2:Disconnect()
        end
    }
end

-- Function to toggle ESP visibility
local function toggleESP(enabled)
    espEnabled = enabled
    for _, espInstance in ipairs(EspList) do
        espInstance.update()
    end
end

-- Function to create ESP for all current players
local function createAllESP()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= Players.LocalPlayer then
            table.insert(EspList, createESP(Player))
        end
    end
end

-- Handle new player joining
Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        table.insert(EspList, createESP(player))
    end
end)

-- Initialize ESP for existing players
createAllESP()

-- Connect to RenderStepped to update ESP positions
game:GetService("RunService").RenderStepped:Connect(function()
    for _, espInstance in ipairs(EspList) do
        espInstance.update()
    end
end)

-- Example of toggling ESP via UI (adjust this according to your UI setup)
VisualsTab:Toggle{
    Name = "Names",
    Description = "Shows Names Above Players.",
    Callback = function(state)
        espEnabled = state
        toggleESP(state)
    end
}



VisualsTab:Toggle{
    Name = "Health",
    StartingState = false,
    Description = "Shows Health Bars Above Players.",
    Callback = function(enabled)
        local function createHealthBar(player)
            if player == game.Players.LocalPlayer then
                return
            end
            local humanoid = player.Character:WaitForChild("Humanoid")
            
            local gui = Instance.new("BillboardGui")
            gui.Name = "HealthBar"
            gui.Adornee = player.Character.Head
            gui.Size = UDim2.new(5, 0, .3, 0)  -- Make the health bar thinner and taller
            gui.StudsOffset = Vector3.new(0, -5.7, 0)  -- Adjust to move it significantly down and to the right
            gui.AlwaysOnTop = true
            gui.Parent = player.Character.Head           
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(230, 60, 0)
            frame.BorderSizePixel = 0
            frame.Parent = gui
            
            humanoid.HealthChanged:Connect(function()
                frame.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
            end)
            
            player.CharacterAdded:Connect(function(character)
                humanoid = character:WaitForChild("Humanoid")
                gui.Adornee = character.Head
                frame.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
            end)
        end
        
        local function toggleHealthBars(enabled)
            for _, player in pairs(game.Players:GetPlayers()) do
                if enabled then
                    createHealthBar(player)
                else
                    if player ~= game.Players.LocalPlayer then
                        local healthBar = player.Character and player.Character:FindFirstChild("Head"):FindFirstChild("HealthBar")
                        if healthBar then
                            healthBar:Destroy()
                        end
                    end
                end
            end
        end
        
        toggleHealthBars(enabled)
        
        game.Players.PlayerAdded:Connect(function(player)
            if enabled then
                createHealthBar(player)
            end
        end)
    end
}

local excludedTools = {
    "Card", "Hot Chips", "Potato Chips", "Phone", "Fist",
    "Crate", "TrashBag", "Knife", "Fake ID", "Standard Clip",
    "Potato", "Drum Magazine", "Extended Clip", "Speed Loader",
    "SkiMask", "Flour", "Heavy Magazine", "CaneBeam", "Bacon Egg And Cheese"
}

local showGunsEnabled = false

local function isExcludedTool(toolName)
    for _, excludedName in ipairs(excludedTools) do
        if toolName == excludedName then
            return true
        end
    end
    return false
end

local function updatePlayerTool(player)
    if player == game.Players.LocalPlayer then
        return  -- Skip updating for the local player
    end
    if not showGunsEnabled then return end
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local currentTool = humanoid.Parent:FindFirstChildOfClass("Tool")
    local billboardName = "ToolDisplay"
    local billboard = character:FindFirstChild(billboardName)
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = billboardName
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(3, 0, 1, 0)
        billboard.StudsOffset = Vector3.new(0, 6, 0) 
        local textLabel = Instance.new("TextLabel", billboard)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.TextSize = 20
        textLabel.TextStrokeTransparency = 0.5
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.SourceSansBold
        billboard.Parent = character
    end
    local textLabel = billboard.TextLabel
    if currentTool then
        local toolName = currentTool.Name
        if isExcludedTool(toolName) then
            textLabel.Text = ""
        else
            textLabel.Text = toolName
            if string.find(toolName, "Micro ARP") or
               string.find(toolName, "AK Draco") then
                textLabel.TextColor3 = Color3.new(1, 0, 0)
            elseif string.find(toolName, "MCX") or
                   string.find(toolName, "Draco") or
                   string.find(toolName, "Tec-9") or
                   string.find(toolName, "Springfield XD MOD") or
                   string.find(toolName, "AR Pistol") or
                   string.find(toolName, "P320E") or
                   string.find(toolName, "FN57") or
                   string.find(toolName, "G19EXT") then
                textLabel.TextColor3 = Color3.new(0, 1, 0)
            elseif string.find(toolName, "Drum") then
                textLabel.TextColor3 = Color3.new(1, 0.8, 0)
            else
                textLabel.TextColor3 = Color3.new(1, 1, 1)
            end
        end
    else
        textLabel.Text = ""
    end
end

local function updatePlayerToolsLoop()
    while true do
        for _, player in ipairs(game.Players:GetPlayers()) do
            updatePlayerTool(player)
        end
        wait(0.1)
    end
end

spawn(updatePlayerToolsLoop)

local function onCharacterAdded(character)
    updatePlayerTool(character.Parent)
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character)
    end)
end)

local function toggleShowGuns(state)
    showGunsEnabled = state
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            if showGunsEnabled then
                updatePlayerTool(player)
            else
                local billboard = player.Character:FindFirstChild("ToolDisplay")
                if billboard then
                    billboard:Destroy()
                end
            end
        end
    end
end

VisualsTab:Toggle{
    Name = "Show Guns",
    StartingState = false,
    Description = "Shows Guns Above Heads.",
    Callback = toggleShowGuns
}

VisualsTab:Button{
	Name = "Show STK Users",
	Description = "Permanently Shows STK Users In The Game",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/SSGWLTEST/gg/main/ShowSTKHubUsers.lua"))()
   end
}

AutofarmTab:Button{
	Name = "PRESS BEFORE AUTOFARM/AUTO JOB",
	Description = "Press F1 To Stop Farming. (TESTING).",
    Callback = function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/SSGWLTEST/gg/main/PartDeleteAutoFarm.lua'))()
   end
}
AutofarmTab:Button{
	Name = "Start Trash Job",
	Description = "Auto Starts The Trash Job. (TESTING).",
    Callback = function()
    local function teleportAndHoldE(x, y, z)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(x, y, z)
    local virtualInputManager = game:GetService("VirtualInputManager")
    virtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(5)
    virtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
    teleportAndHoldE(717.5482788085938, 3.5371992588043213, 169.90029907226562)
	end
}
AutofarmTab:Button{
	Name = "Start Trash Farm",
	Description = "Press F1 To Stop Farming. (TESTING).",
    Callback = function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/SSGWLTEST/gg/main/TrashAutoFarm.lua'))() 
    end
}
AutofarmTab:Button{
	Name = "Start Box Job",
	Description = "Auto Starts The Box Job (TESTING).",
    Callback = function()
    local function teleportAndHoldE(x, y, z)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(x, y, z)
    local virtualInputManager = game:GetService("VirtualInputManager")
    virtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(5)
    virtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
    teleportAndHoldE(-579.7178344726562, 3.5371451377868652, -71.9795913696289)
	end
}
AutofarmTab:Button{
	Name = "Start Box Farm",
	Description = "Press F1 To Stop Farming. (TESTING).",
    Callback = function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/SSGWLTEST/gg/main/BoxAutoFarm.lua'))() 
    end
}
TeleTab:Button{
    Name = "PRESS BEFORE TELEPORTING",
	Description = "Allows Teleporting (TESTING).",
    Callback = function()
    local baseplateSize = Vector3.new(10000000000, 0, 10000000000)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local function SpawnBaseplate()
    local baseplatePosition = humanoidRootPart.Position + Vector3.new(0, -12, 0)
    local baseplate = Instance.new("Part")
    baseplate.Size = baseplateSize
    baseplate.Position = baseplatePosition
    baseplate.Anchored = true
    baseplate.CanCollide = true
    baseplate.Parent = game.Workspace
    baseplate.BrickColor = BrickColor.new("Dark stone grey")
    baseplate.Material = Enum.Material.Concrete
    print("Baseplate spawned under your feet!")
    end
    game.Players.LocalPlayer.CharacterAdded:Connect(function()
    SpawnBaseplate()
    end)
    if game.Players.LocalPlayer.Character then
    SpawnBaseplate()
    end
    end
}
local function teleportTo(target)
    print("Teleporting to:", target)
end
local MyDropdown = TeleTab:Dropdown{
    Name = "Teleports",
    StartingText = "None",
    Description = "Teleport to any location on the list.",
    Items = {
        {"Dealership", 1},      
        {"Box Job", 2},         
        {"Trash Job", 3},       
        {"Bank", 4},            
        {"Fake ID", 5},         
        {"Main Gun Store", 6},  
        {"Gun Store", 7}        
    },
    Callback = function(item)
        if item == 1 then
local targetPosition = Vector3.new(732.9501342773438, 3.709825038909912, 434.654296875)
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1
    while (target - currentPosition).magnitude > distanceThreshold do
        local direction = (target - currentPosition).unit
        local newPosition = currentPosition + direction * 3.4
        if (newPosition - target).magnitude < (currentPosition - target).magnitude then
            humanoidRootPart.CFrame = CFrame.new(newPosition)
        else
            humanoidRootPart.CFrame = CFrame.new(target)
            break
        end
        wait(0.1)
        currentPosition = humanoidRootPart.Position
    end
    print("Teleportation to target position completed!")
end
teleportTo(targetPosition)

        elseif item == 2 then

            local targetPosition = Vector3.new(-520.0985107421875, 3.4121336936950684, -82.7499008178711)  -- Replace with your desired coordinates
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting

    while (target - currentPosition).magnitude > distanceThreshold do
        -- Calculate direction towards the target
        local direction = (target - currentPosition).unit

        -- Move in small increments towards the target
        local newPosition = currentPosition + direction * 3.4  -- Adjust increment size

        -- Check if the newPosition would overshoot the target
        if (newPosition - target).magnitude < (currentPosition - target).magnitude then
            humanoidRootPart.CFrame = CFrame.new(newPosition)
        else
            humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
            break  -- Exit the loop if we've reached the target position
        end

        -- Wait briefly before checking again
        wait(0.1)  -- Adjust wait time as needed
        currentPosition = humanoidRootPart.Position
    end

    -- Teleportation completed
    print("Teleportation to target position completed!")
end
teleportTo(targetPosition)

        elseif item == 3 then

            local targetPosition = Vector3.new(709.990234375, 3.5371994972229004, 157.0732421875)  -- Replace with your desired coordinates
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting

    while (target - currentPosition).magnitude > distanceThreshold do
        -- Calculate direction towards the target
        local direction = (target - currentPosition).unit

        -- Move in small increments towards the target
        local newPosition = currentPosition + direction * 3.4  -- Adjust increment size

        -- Check if the newPosition would overshoot the target
        if (newPosition - target).magnitude < (currentPosition - target).magnitude then
            humanoidRootPart.CFrame = CFrame.new(newPosition)
        else
            humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
            break  -- Exit the loop if we've reached the target position
        end

        -- Wait briefly before checking again
        wait(0.1)  -- Adjust wait time as needed
        currentPosition = humanoidRootPart.Position
    end

    -- Teleportation completed
    print("Teleportation to target position completed!")
end
teleportTo(targetPosition)

        elseif item == 4 then
local targetPosition = Vector3.new(-52.92890548706055, 3.7371387481689453, -332.91278076171875)  -- Replace with your desired coordinates
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting

    while (target - currentPosition).magnitude > distanceThreshold do
        -- Calculate direction towards the target
        local direction = (target - currentPosition).unit

        -- Move in small increments towards the target
        local newPosition = currentPosition + direction * 3.4  -- Adjust increment size

        -- Check if the newPosition would overshoot the target
        if (newPosition - target).magnitude < (currentPosition - target).magnitude then
            humanoidRootPart.CFrame = CFrame.new(newPosition)
        else
            humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
            break  -- Exit the loop if we've reached the target position
        end

        -- Wait briefly before checking again
        wait(0.1)  -- Adjust wait time as needed
        currentPosition = humanoidRootPart.Position
    end

    -- Teleportation completed
    print("Teleportation to target position completed!")
end
teleportTo(targetPosition)
            -- Replace with your actual script for Bank
        elseif item == 5 then
local targetPosition = Vector3.new(216.716064453125, 3.7371325492858887, -332.35711669921875)  -- Replace with your desired coordinates
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting

    while (target - currentPosition).magnitude > distanceThreshold do
        -- Calculate direction towards the target
        local direction = (target - currentPosition).unit

        -- Move in small increments towards the target
        local newPosition = currentPosition + direction * 3.4  -- Adjust increment size

        -- Check if the newPosition would overshoot the target
        if (newPosition - target).magnitude < (currentPosition - target).magnitude then
            humanoidRootPart.CFrame = CFrame.new(newPosition)
        else
            humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
            break  -- Exit the loop if we've reached the target position
        end

        -- Wait briefly before checking again
        wait(0.1)  -- Adjust wait time as needed
        currentPosition = humanoidRootPart.Position
    end
    print("Teleportation to target position completed!")
end
teleportTo(targetPosition)
            -- Replace with your actual script for Fake ID
        elseif item == 6 then
local targetPosition = Vector3.new(219.3710479736328, 3.7300682067871094, -163.08628845214844)  -- Replace with your desired coordinates
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting

    while (target - currentPosition).magnitude > distanceThreshold do
        -- Calculate direction towards the target
        local direction = (target - currentPosition).unit

        -- Move in small increments towards the target
        local newPosition = currentPosition + direction * 3.4  -- Adjust increment size

        -- Check if the newPosition would overshoot the target
        if (newPosition - target).magnitude < (currentPosition - target).magnitude then
            humanoidRootPart.CFrame = CFrame.new(newPosition)
        else
            humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
            break  -- Exit the loop if we've reached the target position
        end

        -- Wait briefly before checking again
        wait(0.1)  -- Adjust wait time as needed
        currentPosition = humanoidRootPart.Position
    end

    -- Teleportation completed
    print("Teleportation to target position completed!")
end

-- Call the teleport function with the target position
teleportTo(targetPosition)
            -- Replace with your actual script for Main Gun Store
        elseif item == 7 then
local targetPosition = Vector3.new(501.29888916015625, 3.5371241569519043, -182.6074981689453)  -- Replace with your desired coordinates
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1
    while (target - currentPosition).magnitude > distanceThreshold do
        local direction = (target - currentPosition).unit
        local newPosition = currentPosition + direction * 3.4
        if (newPosition - target).magnitude < (currentPosition - target).magnitude then
            humanoidRootPart.CFrame = CFrame.new(newPosition)
        else
            humanoidRootPart.CFrame = CFrame.new(target)
            break
        end
        wait(0.1)
        currentPosition = humanoidRootPart.Position
    end
    print("Teleportation to target position completed!")
end
teleportTo(targetPosition)
        else
            print("No script defined for this item:", item)
        end
    end
}
local MyDropdown = TeleTab:Dropdown{
    Name = "ATMs",
    StartingText = "None",
    Description = "Teleports You To The ATM If Active.",
    Items = {
        {"ATM1", 1},
        {"ATM2", 2},
        {"ATM3", 3},
        {"ATM4", 4},
        {"ATM5", 5},
        {"ATM6", 6},
        {"ATM7", 7},
        {"ATM8", 8},
        {"ATM9", 9},
        {"ATM10", 10},
        {"ATM11", 11},
        {"ATM12", 12},
        {"ATM13", 13},
        {"ATM14", 14},
        {"ATM15", 15},
    },
    Callback = function(item)
        if item == 1 then
            local targetPosition = Vector3.new(-32.586585998535156, 3.763624668121338, -300.15673828125)
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM1")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)
                break
            end
            wait(0.1)
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)

        elseif item == 2 then
            local targetPosition = Vector3.new(538.3597412109375, 3.7636241912841797, -350.0778503417969)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM2")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)

        elseif item == 3 then
local targetPosition = Vector3.new(497.42108154296875, 3.783940315246582, 405.0294189453125)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM3")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 4 then
local targetPosition = Vector3.new(236.2193145751953, 3.844614028930664, -162.059814453125)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM4")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 5 
    then local targetPosition = Vector3.new(524.8828125, -7.7628631591796875, -95.50765228271484)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM5")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 6 then
 local targetPosition = Vector3.new(-454.386962890625, 3.7371325492858887, 370.9426574707031)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM6")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 7 then
local targetPosition = Vector3.new(-266.3318176269531, 3.8589463233947754, -210.8848419189453)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM7")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 8 then
 local targetPosition = Vector3.new(-10.801584243774414, 3.7636241912841797, 233.79428100585938)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM8")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 9 then
 local targetPosition = Vector3.new(716.7405395507812, 3.8176207542419434, 413.26226806640625)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM9")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 10 then
  local targetPosition = Vector3.new(-535.468017578125, 3.7371325492858887, -20.530590057373047)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM10")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 11 then
  local targetPosition = Vector3.new(-650.62890625, 3.7371325492858887, 155.3464813232422)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM11")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 12 then
local targetPosition = Vector3.new(713.520263671875, 3.7636241912841797, -240.45089721679688)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM12")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 13 then
  local targetPosition = Vector3.new(-314.93701171875, 3.7371325492858887, 144.9151153564453)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM13")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 14 then
local targetPosition = Vector3.new(-378.14996337890625, 3.7300682067871094, -361.021484375)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM14")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        elseif item == 15 then
local targetPosition = Vector3.new(360.02764892578125, 3.7636241912841797, -361.6149597167969)  -- Replace with your desired coordinates
local function isATMEnabled()
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
        local atm1 = atmFolder:FindFirstChild("ATM15")
        if atm1 then
            local attachment = atm1:FindFirstChild("Attachment")
            if attachment then
                local proximityPrompt = attachment:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt and proximityPrompt.Enabled then
                    return true
                end
            end
        end
    end
    return false
end
local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local distanceThreshold = 0.1  -- Adjust as needed, determines when to stop teleporting
    if isATMEnabled() then
        while (target - currentPosition).magnitude > distanceThreshold do
            local direction = (target - currentPosition).unit
            local newPosition = currentPosition + direction * 3.4  -- Adjust increment size
            if (newPosition - target).magnitude < (currentPosition - target).magnitude then
                humanoidRootPart.CFrame = CFrame.new(newPosition)
            else
                humanoidRootPart.CFrame = CFrame.new(target)  -- Set directly to the target position
                break  -- Exit the loop if we've reached the target position
            end
            wait(0.1)  -- Adjust wait time as needed
            currentPosition = humanoidRootPart.Position
        end
        print("Teleportation to target position completed!")
    else
        print("ATM is not enabled, teleportation aborted.")
    end
end
teleportTo(targetPosition)
        else
            -- Handle unexpected cases or add more conditions as needed
            print("No script defined for this item:", item)
        end
    end
}
