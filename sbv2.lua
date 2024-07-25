--Lib--
    local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
    local Main = library:CreateWindow("simply.fun","Deep Sea")
--Tabs--
    local tab1 = Main:CreateTab("Aimbot")
    local tab2 = Main:CreateTab("Visuals")
    local tab3 = Main:CreateTab("Auto Farm")
    local tab4 = Main:CreateTab("Teleports")
    local tab5 = Main:CreateTab("Misc")
--Aimbot--
    local Camera = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local Holding = false
    _G.TeamCheck = false
    _G.AimPart = "UpperTorso"
    _G.Sensitivity = 0.1
    _G.CircleSides = 64
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
    local function GetClosestPlayer()
    local MaximumDistance = _G.CircleRadius
    local Target = nil
    local MousePosition = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    for _, v in ipairs(Players:GetPlayers()) do
    if v.Name ~= LocalPlayer.Name then
    if _G.TeamCheck and v.Team ~= LocalPlayer.Team or not _G.TeamCheck then
    local character = v.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health > 0 then
    local ScreenPoint = Camera:WorldToScreenPoint(character.HumanoidRootPart.Position)
    local VectorDistance = (MousePosition - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).magnitude
    if VectorDistance < MaximumDistance then
    if _G.CircleVisible then
    if VectorDistance < _G.CircleRadius then
    Target = v
    MaximumDistance = VectorDistance
    end
    else
    Target = v
    MaximumDistance = VectorDistance
    end
    end
    end
    end
    end
    end
    end
    return Target
    end
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
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness
    end)
    tab1:CreateToggle("Aimbot", function(enabled)
    _G.AimbotEnabled = enabled
    if enabled then
    Holding = false
    end
    end)
    tab1:CreateToggle("FOV Circle", function(enabled)
    _G.CircleVisible = enabled
    FOVCircle.Visible = enabled
    end)
    tab1:CreateSlider("FOV Slider", 20, 250, function(value)
    _G.CircleRadius = value
    FOVCircle.Radius = value
    end)
    tab1:CreateDropdown("Aim Part", {"Head", "UpperTorso"}, function(selectedOption)
    if selectedOption == "Head" then
    _G.AimPart = "Head"
    elseif selectedOption == "UpperTorso" then
    _G.AimPart = "UpperTorso"
    elseif selectedOption == "Torso" then
    _G.AimPart = "Torso"
    end
    end)
--Spin Bot--
    local spinEnabled = false
    local spinSpeed = 0
    local player = game.Players.LocalPlayer
    local function UpdateSpin()
    local character = player.Character
    if character and spinEnabled then
    local rootPart = character.HumanoidRootPart
    local currentRotation = rootPart.CFrame
    local newRotation = currentRotation * CFrame.Angles(0, math.rad(spinSpeed), 0)
    rootPart.CFrame = newRotation
    end
    end
    local function ToggleCallback(enabled)
    spinEnabled = enabled
    end
    local function SliderCallback(value)
    spinSpeed = value
    end
    tab1:CreateToggle("Spin Bot", ToggleCallback)
    tab1:CreateSlider("Spin Speed", 1, 100, SliderCallback)
    game:GetService("RunService").RenderStepped:Connect(function()
    UpdateSpin()
    end)

--Boxes Esp--
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Camera = game.Workspace.CurrentCamera  -- Assuming Camera is accessible from this context
    local espEnabled = false
    local espThickness = 1
    local EspList = {}
    local function createESP(Player)
    local Box = Drawing.new("Square")
    Box.Thickness = espThickness
    Box.Filled = false
    Box.Color = Color3.fromRGB(44,84,212)  -- Baby blue color
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
    end,
    setThickness = function(newThickness)
    Box.Thickness = newThickness
    end
    }
    end
    local function toggleESP(enabled)
    espEnabled = enabled
    for _, espInstance in ipairs(EspList) do
    espInstance.update()
    end
    end
    local function createAllESP()
    for _, Player in pairs(Players:GetPlayers()) do
    if Player ~= Players.LocalPlayer then
    table.insert(EspList, createESP(Player))
    end
    end
    end
    Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
    table.insert(EspList, createESP(player))
    end
    end)
    createAllESP()
    game:GetService("RunService").RenderStepped:Connect(function()
    for _, espInstance in ipairs(EspList) do
    espInstance.update()
    end
    end)
    local function toggleCallback(state)
    espEnabled = state
    toggleESP(state)
    end
    local function sliderCallback(value)
    espThickness = value
    for _, espInstance in ipairs(EspList) do
    espInstance.setThickness(value)
    end
    end
    tab2:CreateToggle("Boxes", toggleCallback)
    tab2:CreateSlider("Boxes Size", 1, 10, sliderCallback)

--Names Esp--
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Camera = game.Workspace.CurrentCamera
    local espEnabled = false
    local EspList = {}
    local yOffset = 33  -- Default Y-offset
    local function createESP(Player)
    local Name = Drawing.new("Text")
    Name.Text = Player.Name
    Name.Size = 10
    Name.Outline = true
    Name.Center = true
    Name.Color = Color3.fromRGB(44, 84, 212)
    local function update()
    local Character = Player.Character
    if Character then
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid and Humanoid.Health > 0 then
    local Pos, OnScreen = Camera:WorldToViewportPoint(Character.Head.Position)
    if OnScreen then
    local X = Pos.X
    local Y = Pos.Y
    Name.Position = Vector2.new(X, Y - yOffset)  -- Apply Y-offset
    Name.Visible = espEnabled
    return
    end
    end
    end
    Name.Visible = false
    end
    update()
    local Connection1 = Player.CharacterAdded:Connect(update)
    local Connection2 = Player.CharacterRemoving:Connect(function()
    Name.Visible = false
    end)
    local function disconnect()
    Name:Remove()
    Connection1:Disconnect()
    Connection2:Disconnect()
    end
    table.insert(EspList, {
    update = update,
    disconnect = disconnect,
    Name = Name
    })
    return {
    update = update,
    disconnect = disconnect,
    Name = Name
    }
    end
    local function toggleESP(enabled)
    espEnabled = enabled
    for _, espInstance in ipairs(EspList) do
    espInstance.update()
    end
    end
    local function toggleCallback(state)
    espEnabled = state
    toggleESP(state)
    end
    local function sliderCallback(value, sliderType)
    if sliderType == "Size" then
    for _, espInstance in ipairs(EspList) do
    espInstance.Name.Size = value
    end
    elseif sliderType == "YOffset" then
    yOffset = value  -- Update yOffset
    end
    end
    local function createAllESP()
    for _, Player in pairs(Players:GetPlayers()) do
    if Player ~= Players.LocalPlayer then
    createESP(Player)
    end
    end
    end
    Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
    createESP(player)
    end
    end)
    createAllESP()
    game:GetService("RunService").RenderStepped:Connect(function()
    for _, espInstance in ipairs(EspList) do
    espInstance.update()
    end
    end)
    tab2:CreateToggle("Names", toggleCallback)
    tab2:CreateSlider("Names Size", 1, 20, function(value)
    sliderCallback(value, "Size")
    end)
    tab2:CreateSlider("Names Offset", 0, 50, function(value)
    sliderCallback(value, "YOffset")
    end)
--Health Esp--
    local function createHealthBar(player)
    if player == game.Players.LocalPlayer then
    return
    end
    local humanoid = player.Character:WaitForChild("Humanoid")
    local gui = Instance.new("BillboardGui")
    gui.Name = "HealthBar"
    gui.Adornee = player.Character.Head
    gui.Size = UDim2.new(5, 0, .3, 0)
    gui.StudsOffset = Vector3.new(0, -5.7, 0)
    gui.AlwaysOnTop = true
    gui.Parent = player.Character.Head           
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(44, 84, 212)
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
    local function toggleCallback(enabled)
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
    tab2:CreateToggle("Health", toggleCallback)
--Guns Esp--
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
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local currentTool = humanoid.Parent:FindFirstChildOfClass("Tool")
    local billboardName = "ToolDisplay"
    local billboard = character:FindFirstChild(billboardName)
    if showGunsEnabled then
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
    textLabel.TextColor3 = Color3.new(44, 84, 212)  -- Example color
    end
    else
    textLabel.Text = ""
    end
    else
    if billboard then
    billboard:Destroy()
    end
    end
    end
    local function updatePlayerToolsLoop()
    while true do
    for _, player in ipairs(game.Players:GetPlayers()) do
    updatePlayerTool(player)
    end
    wait(1)  -- Update once per second
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
    tab2:CreateToggle("Guns", toggleShowGuns)
--AF Lib--
    local function executeScript()
    local partNameToDelete = "backp"
    local modelNameToDelete = "boxing gym"
    local function deleteTruckProp()
    local cratetruck2 = game.Workspace:FindFirstChild("cratetruck2")
    if cratetruck2 then
    local truckProp = cratetruck2:FindFirstChild("TruckProp")
    if truckProp then
    truckProp:Destroy()
    else
    warn("Part '" .. partNameToDelete .. "' not found in 'cratetruck2'.")
    end
    else
    warn("Model 'cratetruck2' not found in Workspace.")
    end
    end
    local function deleteChild(parent, childName)
    local child = parent:FindFirstChild(childName)
    if child then
    child:Destroy()
    else
    warn("Child '" .. childName .. "' not found under parent.")
    end
    end
    local function deleteBoxingGym()
    local mapFolder = game.Workspace:FindFirstChild("Map")
    if mapFolder then
    local boxJob = mapFolder:FindFirstChild("Box Job")
    if boxJob then
    deleteChild(boxJob, modelNameToDelete)
    else
    warn("Model 'Box Job' not found under 'Map'.")
    end
    else
    warn("Folder 'Map' not found in Workspace.")
    end
    end
    local function deletePartsByNameUnderParent(parent, parentName, name)
    local children = parent:GetChildren()
    for _, child in ipairs(children) do
    if child:IsA("Model") or child:IsA("BasePart") then
    if child.Name == name and child.Parent.Name == parentName then
    child:Destroy()
    elseif child:IsA("Model") then
    deletePartsByNameUnderParent(child, parentName, name)
    end
    end
    end
    end
    local function modifyProximityPrompts()
    local function modifyPrompt(prompt)
    if prompt then
    prompt.HoldDuration = 0
    prompt.MaxActivationDistance = 10
    else
    warn("ProximityPrompt not found or invalid.")
    end
    end
    local trashcan = game.Workspace:FindFirstChild("trashcan")
    if trashcan then
    local prox = trashcan:FindFirstChild("prox")
    if prox then
    local attachment = prox:FindFirstChild("Attachment")
    if attachment then
    modifyPrompt(attachment:FindFirstChildOfClass("ProximityPrompt"))
    else
    warn("Attachment not found under 'prox'.")
    end
    else
    warn("Part 'prox' not found under 'Trashcan'.")
    end
    else
    warn("Model 'Trashcan' not found in Workspace.")
    end
    local garbageDumpster = game.Workspace:FindFirstChild("GarbageDumpster")
    if garbageDumpster then
    modifyPrompt(garbageDumpster:FindFirstChild("Attachment"):FindFirstChildOfClass("ProximityPrompt"))
    else
    warn("Model 'GarbageDumpster' not found in Workspace.")
    end
    for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
    modifyPrompt(obj)
    end
    end
    end
    local function searchAndDelete()
    local map = game.Workspace.Map
    local trashJob = map:FindFirstChild("Trash Job")
    if trashJob then
    deletePartsByNameUnderParent(trashJob, "Trash Job", partNameToDelete)
    else
    warn("Model 'Trash Job' not found under 'Map'.")
    end
    end    
    while true do
    modifyProximityPrompts()
    deleteTruckProp()
    deleteBoxingGym()
    searchAndDelete()
    wait(100)
    end
    end
    tab3:CreateButton("MUST CLICK", executeScript)
--Noclip--
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Plr = Players.LocalPlayer
    local noclipEnabled = false
    local Stepped
    local function enableNoclip()
    Stepped = RunService.Stepped:Connect(function()
    if noclipEnabled then
    for _, child in ipairs(game.Workspace:GetChildren()) do
    if child.Name == Plr.Name then
    for _, part in ipairs(child:GetChildren()) do
    if part:IsA("BasePart") then
    part.CanCollide = false
    end
    end
    end
    end
    end
    end)
    end
    local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if not noclipEnabled then
    if Stepped then
    Stepped:Disconnect()
    end
    else
    enableNoclip()
    end
    end
    local function ToggleNoclip()
    toggleNoclip()
    end
    tab3:CreateToggle("Noclip", ToggleNoclip)

--Trash Job--
    local function callback()
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
    tab3:CreateButton("Start Trash Job", callback)
--Trash Farm--
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local backpack = player.Backpack
    local coordinates = {
    Vector3.new(698.394287109375, 3.5371994972229004, 170.7313232421875),
    Vector3.new(729.8390502929688, 3.4121947288513184, 211.96453857421875)
    }
    local stopScript = true
    local running = false
    local function HoldEFor2Seconds()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
    local function MoveBackAndForth()
    while running do
    for i = 1, #coordinates do
    if not running then return end
    local coord = coordinates[i]
    humanoid.WalkSpeed = 22
    humanoid:MoveTo(coord)
    humanoid.MoveToFinished:Wait()
    if not running then return end
    if backpack then
    local crate = backpack:FindFirstChild("TrashBag")
    if crate then
    crate.Parent = character
    end
    end
    HoldEFor2Seconds()
    end
    end
    end
    local function StartScript()
    running = true
    stopScript = false
    MoveBackAndForth()
    end
    local function StopScript()
    running = false
    stopScript = true
    humanoid.WalkSpeed = 16
    end
    local function OnToggleChanged()
    if stopScript then
    StartScript()
    else
    StopScript()
    end
    end
    game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
    if running then
    StopScript()
    else
    StartScript()
    end
    end
    end)
    tab3:CreateToggle("Trash Farm", OnToggleChanged)
--Box Job--
    local function callback()
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
    tab3:CreateButton("Start Box Job", callback)
--Box Farm--
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local backpack = player.Backpack
    local coordinates = {
    Vector3.new(-547.0848388671875, 3.412132740020752, -85.62256622314453),
    Vector3.new(-403.59765625, 3.4121932983398438, -66.5368881225586)
    }
    local stopScript = true
    local running = false
    local function HoldEFor2Seconds()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
    local function teleportTo(target)
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
    end
    local function MoveBackAndForth()
    while running do
    for i = 1, #coordinates do
    if not running then return end
    local coord = coordinates[i]
    teleportTo(coord)
    if not running then return end
    humanoid.WalkSpeed = 22
    humanoid:MoveTo(coord)
    humanoid.MoveToFinished:Wait()
    if not running then return end
    if backpack then
    local crate = backpack:FindFirstChild("Crate")
    if crate then
    crate.Parent = character
    end
    end
    HoldEFor2Seconds()
    end
    end
    end
    local function StartScript()
    running = true
    stopScript = false
    MoveBackAndForth()
    end
    local function StopScript()
    running = false
    stopScript = true
    humanoid.WalkSpeed = 16
    end
    local function OnToggleChanged()
    if stopScript then
    StartScript()
    else
    StopScript()
    end
    end
    game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
    OnToggleChanged()
    end
    end)
    tab3:CreateToggle("Box Farm", OnToggleChanged)
--Teleports Noclip--
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Plr = Players.LocalPlayer
    local noclipEnabled = false
    local Stepped
    local function enableNoclip()
    Stepped = RunService.Stepped:Connect(function()
    if noclipEnabled then
    for _, child in ipairs(game.Workspace:GetChildren()) do
    if child.Name == Plr.Name then
    for _, part in ipairs(child:GetChildren()) do
    if part:IsA("BasePart") then
    part.CanCollide = false
    end
    end
    end
    end
    end
    end)
    end
    local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if not noclipEnabled then
    if Stepped then
    Stepped:Disconnect()
    end
    else
    enableNoclip()
    end
    end
    local function ToggleNoclip()
    toggleNoclip()
    end
    tab4:CreateToggle("Noclip", ToggleNoclip)
--Teleports--
    local locations = {
    Dealership = Vector3.new(732.9501342773438, 3.709825038909912, 434.654296875),
    BoxJob = Vector3.new(-520.0985107421875, 3.4121336936950684, -82.7499008178711),
    TrashJob = Vector3.new(709.990234375, 3.5371994972229004, 157.0732421875),
    Bank = Vector3.new(-52.92890548706055, 3.7371387481689453, -332.91278076171875),
    FakeID = Vector3.new(216.716064453125, 3.7371325492858887, -332.35711669921875),
    MainGunStore = Vector3.new(219.3710479736328, 3.7300682067871094, -163.08628845214844),
    GunStore = Vector3.new(501.29888916015625, 3.5371241569519043, -182.6074981689453)
    }
    local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local distanceThreshold = 0.1
    while (target - humanoidRootPart.Position).magnitude > distanceThreshold do
    local direction = (target - humanoidRootPart.Position).unit
    local newPosition = humanoidRootPart.Position + direction * 3.4
    if (newPosition - target).magnitude < (humanoidRootPart.Position - target).magnitude then
    humanoidRootPart.CFrame = CFrame.new(newPosition)
    else
    humanoidRootPart.CFrame = CFrame.new(target)
    break
    end
    wait(0.1)
    end
    end
    local function callback(item)
    local targetPosition = locations[item]
    if targetPosition then
    teleportTo(targetPosition)
    else
    end
    end
    tab4:CreateDropdown("Teleports", 
    {"Dealership", "BoxJob", "TrashJob", "Bank", "FakeID", "MainGunStore", "GunStore"},
    callback)
--ATMS Teleport--
    local locations = {
    ATM1 = Vector3.new(-32.586585998535156, 3.763624668121338, -300.15673828125),
    ATM2 = Vector3.new(538.3597412109375, 3.7636241912841797, -350.0778503417969),
    ATM3 = Vector3.new(497.42108154296875, 3.783940315246582, 405.0294189453125),
    ATM4 = Vector3.new(236.2193145751953, 3.844614028930664, -162.059814453125),
    ATM5 = Vector3.new(524.8828125, -7.7628631591796875, -95.50765228271484),
    ATM6 = Vector3.new(-454.386962890625, 3.7371325492858887, 370.9426574707031),
    ATM7 = Vector3.new(-266.3318176269531, 3.8589463233947754, -210.8848419189453),
    ATM8 = Vector3.new(-10.801584243774414, 3.7636241912841797, 233.79428100585938),
    ATM9 = Vector3.new(716.7405395507812, 3.8176207542419434, 413.26226806640625),
    ATM10 = Vector3.new(-535.468017578125, 3.7371325492858887, -20.530590057373047),
    ATM11 = Vector3.new(-650.62890625, 3.7371325492858887, 155.3464813232422),
    ATM12 = Vector3.new(713.520263671875, 3.7636241912841797, -240.45089721679688),
    ATM13 = Vector3.new(-314.93701171875, 3.7371325492858887, 144.9151153564453),
    ATM14 = Vector3.new(-378.14996337890625, 3.7300682067871094, -361.021484375),
    ATM15 = Vector3.new(360.02764892578125, 3.7636241912841797, -361.6149597167969)
    }
    local function teleportTo(target)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local distanceThreshold = 0.1
    while (target - humanoidRootPart.Position).magnitude > distanceThreshold do
    local direction = (target - humanoidRootPart.Position).unit
    local newPosition = humanoidRootPart.Position + direction * 3.4
    if (newPosition - target).magnitude < (humanoidRootPart.Position - target).magnitude then
    humanoidRootPart.CFrame = CFrame.new(newPosition)
    else
    humanoidRootPart.CFrame = CFrame.new(target)
    break
    end
    wait(0.1)
    end
    end
    local function isATMEnabled(atmName)
    local workspace = game:GetService("Workspace")
    local atmFolder = workspace:FindFirstChild("ATMS")
    if atmFolder then
    local atm = atmFolder:FindFirstChild(atmName)
    if atm then
    local attachment = atm:FindFirstChild("Attachment")
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
    local function callback(item)
    local targetPosition = locations[item]
    if targetPosition then
    if isATMEnabled(item) then
    teleportTo(targetPosition)
    else
    end
    else
    end
    end
    tab4:CreateDropdown("ATMS", 
    {"ATM1", "ATM2", "ATM3", "ATM4", "ATM5", "ATM6", "ATM7", "ATM8", "ATM9", "ATM10", "ATM11", "ATM12", "ATM13", "ATM14", "ATM15"},
    callback)
--Instaloot--
    local function executeScript()
    while true do
    local proximityPrompts = game:GetService("Workspace"):GetDescendants()
    for _, instance in ipairs(proximityPrompts) do
    if instance:IsA("ProximityPrompt") then
    instance.HoldDuration = 0
    end
    end
    wait(20)
    end
    end
    tab5:CreateButton("Instaloot", executeScript)
--Speed--
    local player = game.Players.LocalPlayer
    local character = player.Character
    local function updateWalkSpeed(value)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
    humanoid.WalkSpeed = value
    end
    end
    local function getCurrentSliderValue()
    return tab5:GetSliderValue("Walk Speed")
    end
    spawn(function()
    while true do
    local currentWalkSpeed = getCurrentSliderValue()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
    if humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
    humanoid.WalkSpeed = currentWalkSpeed
    end
    end
    wait(0.1) -- Adjust wait time as needed
    end
    end)
    tab5:CreateSlider("Walk Speed", 16, 22.1, function(value)
    updateWalkSpeed(value)
    end)

--C + Delete--
    local Plr = game:GetService("Players").LocalPlayer
    local Mouse = Plr:GetMouse()
    local deleteEnabled = false
    Mouse.Button1Down:connect(function()
    if not deleteEnabled then
    return
    end
    if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.C) then
    return
    end
    if not Mouse.Target then
    return
    end
    Mouse.Target:Destroy()
    end)
    local function OnToggleChanged(toggleState)
    deleteEnabled = toggleState
    end
    tab5:CreateToggle("C Delete", OnToggleChanged)
--Floor Fix--
    local function SpawnBaseplateUnderFeet()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local baseplatePosition = humanoidRootPart.Position + Vector3.new(0, -10.9, 0)
    local baseplate = Instance.new("Part")
    baseplate.Size = Vector3.new(10000000, 0, 10000000)  -- Adjust size as needed
    baseplate.Position = baseplatePosition
    baseplate.Anchored = true
    baseplate.CanCollide = true
    baseplate.Parent = game.Workspace
    baseplate.BrickColor = BrickColor.new("Bright blue")  -- Adjust color as desired
    baseplate.Material = Enum.Material.Concrete  -- Adjust material as desired
    end
    local function SpawnBaseplateAtMiddle()
    local middlePosition = Vector3.new(0, 0, 0)
    local baseplate = Instance.new("Part")
    baseplate.Size = Vector3.new(10000000, 0, 10000000)
    baseplate.Position = middlePosition
    baseplate.Anchored = true
    baseplate.CanCollide = true
    baseplate.Parent = game.Workspace
    baseplate.BrickColor = BrickColor.new("Bright blue")
    baseplate.Material = Enum.Material.Concrete
    end
    local function onFloorFixButtonClick()
    SpawnBaseplateUnderFeet()
    SpawnBaseplateAtMiddle()
    end
    tab5:CreateButton("Floor Fix", onFloorFixButtonClick)
--Move Up--
    local function movePlayerUp(distance)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local newPosition = currentPosition + Vector3.new(0, distance, 0)
    humanoidRootPart.CFrame = CFrame.new(newPosition)
    end
    local function SpawnBaseplateAtMiddle()
    local middlePosition = Vector3.new(0, 0, 0)
    local baseplate = Instance.new("Part")
    baseplate.Size = Vector3.new(10000000, 0, 10000000)
    baseplate.Position = middlePosition
    baseplate.Anchored = true
    baseplate.CanCollide = true
    baseplate.Parent = game.Workspace
    baseplate.BrickColor = BrickColor.new("Bright blue")
    baseplate.Material = Enum.Material.Concrete
    end
    local function Callback()
    movePlayerUp(5)  -- Move the player up by 5 studs
    SpawnBaseplateAtMiddle()  -- Spawn the baseplate at the middle
    end
    tab5:CreateButton("Move Up", Callback)

--Move Down--
    local function movePlayerDown(distance)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = humanoidRootPart.Position
    local newPosition = currentPosition - Vector3.new(0, distance, 0) -- Subtract distance to move down
    humanoidRootPart.CFrame = CFrame.new(newPosition)
    end
    local function DeleteBaseplate()
    local baseplate = game.Workspace:FindFirstChild("Baseplate")
    if baseplate then
    baseplate:Destroy()  -- Delete the baseplate if found
    else
    end
    end
    local function Callback()   
    movePlayerDown(5)  -- Move the player down by 5 studs
    DeleteBaseplate()  -- Delete the baseplate from the workspace
    end 
    tab5:CreateButton("Move Down", Callback)
