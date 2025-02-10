s\er
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/VexEdge/Rizz/refs/heads/patch-2/Geckoo.Lib.Fr"))()
local hint = Instance.new("Hint", game.CoreGui)
hint.Text = "VexEdge.inf | V1.3"
local fullText = ""
local typingSpeed = 0.1
-- Typing effect
for i = 1, #fullText do
    hint.Text = string.sub(fullText, 1, i)
    wait(typingSpeed)
end
-- Wait for 5 seconds before disappearing
wait(5)
-- Remove the hint
hint:Destroy()



local PepsisWorld = library:CreateWindow({
    Name = "Geckoo ",
    Credit= "False"
})



local GeneralTab = PepsisWorld:CreateTab({
    Name = "Client"
})

local ClientSided = GeneralTab:CreateSection({
    Name = "Chams & ESP",
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LOCAL_PLAYER = Players.LocalPlayer

local MAX_DISTANCE = 600 * 3.28 -- 600 meters converted to studs

-- Variables to track toggle states
local espEnabled = false
local chamsEnabled = false
local fillColor = Color3.fromRGB(194, 218, 184) -- Default fill color for Chams

-- Table to track players with ESP
local trackedPlayers = {}

-- Function to create ESP for a player
local function createESP(player)
    if not espEnabled or trackedPlayers[player] then return end

    local espElements = {
        espBox = Drawing.new("Square"),
        nameLabel = Drawing.new("Text"),
        distanceLabel = Drawing.new("Text"),
        healthBarBackground = Drawing.new("Square"),
        healthBar = Drawing.new("Square"),
    }

    -- ESP Box Settings
    espElements.espBox.Thickness = 2
    espElements.espBox.Color = Color3.new(1, 0, 0) -- Red box
    espElements.espBox.Filled = false
    espElements.espBox.Visible = false

    -- Name Label Settings
    espElements.nameLabel.Size = 16
    espElements.nameLabel.Center = true
    espElements.nameLabel.Outline = true
    espElements.nameLabel.Color = Color3.new(1, 1, 1) -- White text
    espElements.nameLabel.Visible = false

    -- Distance Label Settings
    espElements.distanceLabel.Size = 14
    espElements.distanceLabel.Center = true
    espElements.distanceLabel.Outline = true
    espElements.distanceLabel.Color = Color3.new(1, 1, 1) -- White text
    espElements.distanceLabel.Visible = false

    -- Health Bar Background Settings
    espElements.healthBarBackground.Size = Vector2.new(50, 5)
    espElements.healthBarBackground.Color = Color3.new(0, 0, 0) -- Black background
    espElements.healthBarBackground.Filled = true
    espElements.healthBarBackground.Visible = false

    -- Health Bar Settings
    espElements.healthBar.Size = Vector2.new(50, 5)
    espElements.healthBar.Color = Color3.new(0, 1, 0) -- Green for health
    espElements.healthBar.Filled = true
    espElements.healthBar.Visible = false

    -- Function to update ESP elements
    local function updateESP()
        if not espEnabled or not player.Character then
            -- Hide all ESP elements
            for _, element in pairs(espElements) do
                element.Visible = false
            end
            return
        end

        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if rootPart and humanoid and humanoid.Health > 0 then
            local rootScreenPos, rootOnScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local distanceStuds = (LOCAL_PLAYER.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
            local distanceMeters = distanceStuds / 3.28

            if rootOnScreen and distanceStuds <= MAX_DISTANCE then
                -- Update small ESP box
                local boxSize = Vector2.new(5, 5)
                espElements.espBox.Position = Vector2.new(rootScreenPos.X - boxSize.X / 2, rootScreenPos.Y - boxSize.Y / 2)
                espElements.espBox.Size = boxSize
                espElements.espBox.Visible = true

                -- Update name label
                espElements.nameLabel.Position = Vector2.new(rootScreenPos.X, rootScreenPos.Y - 20)
                espElements.nameLabel.Text = player.Name
                espElements.nameLabel.Visible = true

                -- Update distance label
                espElements.distanceLabel.Position = Vector2.new(rootScreenPos.X, rootScreenPos.Y + 10)
                espElements.distanceLabel.Text = string.format("%.1f meters", distanceMeters)
                espElements.distanceLabel.Visible = true

                -- Update health bar
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                espElements.healthBarBackground.Position = Vector2.new(rootScreenPos.X - 25, rootScreenPos.Y + 20)
                espElements.healthBar.Position = espElements.healthBarBackground.Position
                espElements.healthBar.Size = Vector2.new(50 * healthPercent, 5)

                espElements.healthBarBackground.Visible = true
                espElements.healthBar.Visible = true
            else
                -- Hide elements if out of range
                for _, element in pairs(espElements) do
                    element.Visible = false
                end
            end
        end
    end

    -- Monitor player updates
    trackedPlayers[player] = espElements
    local connection
    connection = player.CharacterAdded:Connect(function()
        updateESP()
    end)
    
    RunService.RenderStepped:Connect(updateESP)
    
    player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            for _, element in pairs(espElements) do
                element:Remove()
            end
            trackedPlayers[player] = nil
            connection:Disconnect()
        end
    end)
end

-- Toggle ESP
ClientSided:AddToggle({
    Name = "Toggle ESP",
    Flag = "ESP_Toggle",
    Keybind = 1,
    Callback = function(state)
        espEnabled = state
        if not espEnabled then
            -- Remove all ESP elements
            for _, espData in pairs(trackedPlayers) do
                for _, element in pairs(espData) do
                    element:Remove()
                end
            end
            trackedPlayers = {} -- Clear the table
        else
            -- Enable ESP for all players
            for _, player in ipairs(Players:GetPlayers()) do
                createESP(player)
            end
        end
    end
})

-- Connect functions to PlayerAdded and PlayerRemoving events
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(player)
    if trackedPlayers[player] then
        for _, element in pairs(trackedPlayers[player]) do
            element:Remove()
        end
        trackedPlayers[player] = nil
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local maxDistance = 100 -- Default max distance for Chams

-- Function to apply Chams
local function ApplyHighlight(character, isNPC)
    if not chamsEnabled or character == LocalPlayer.Character then return end

    if character:FindFirstChild("Highlight") then return end

    local highlighter = Instance.new("Highlight", character)
    highlighter.FillTransparency = 1 -- Make the fill transparent
    highlighter.OutlineColor = Color3.new(0, 0, 0) -- Set the outline to dark

    local function Disconnect()
        if highlighter then highlighter:Destroy() end
    end

    character:FindFirstChildOfClass("Humanoid").Died:Connect(Disconnect)
end

-- Function to check and reapply Chams
local function CheckAndReapplyChams()
    if not chamsEnabled then return end
    for _, character in ipairs(workspace:GetDescendants()) do
        if character:IsA("Model") and character:FindFirstChildOfClass("Humanoid") and character ~= LocalPlayer.Character then
            local isNPC = not Players:GetPlayerFromCharacter(character)
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            if distance <= maxDistance then
                ApplyHighlight(character, isNPC)
            else
                if character:FindFirstChild("Highlight") then
                    character:FindFirstChild("Highlight"):Destroy()
                end
            end
        end
    end
end

-- Toggle Chams
ClientSided:AddToggle({
    Name = "Toggle Chams",
    Flag = "Chams_Toggle",
    Keybind = 2,
    Callback = function(state)
        chamsEnabled = state
        if chamsEnabled then
            CheckAndReapplyChams()
        else
            for _, character in ipairs(workspace:GetDescendants()) do
                if character:IsA("Model") and character:FindFirstChildOfClass("Humanoid") then
                    if character:FindFirstChild("Highlight") then
                        character:FindFirstChild("Highlight"):Destroy()
                    end
                end
            end
        end
    end
})


-- Apply Chams to all humanoids in the game initially
CheckAndReapplyChams()

-- Ensure new characters are highlighted periodically (every 1 second)
while true do
    wait(1)
    CheckAndReapplyChams()
end

-- Ensure new characters are highlighted upon being added
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") and descendant:FindFirstChildOfClass("Humanoid") then
        local isNPC = not Players:GetPlayerFromCharacter(descendant)
        if chamsEnabled then ApplyHighlight(descendant, isNPC) end
    end
end)


local ClientSided = GeneralTab:CreateSection({
    Name = "Inv View"
})


local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 90)  -- Adjusted size to be smaller
frame.Position = UDim2.new(0.5, -175, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Visible = false

local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.new(1, 0, 0, 20)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
topBar.BorderSizePixel = 0

local nameLabel = Instance.new("TextLabel", topBar)
nameLabel.Size = UDim2.new(1, 0, 1, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.TextSize = 16
nameLabel.Text = ""
nameLabel.TextScaled = true

ClientSided:AddToggle({
    Name = "Toggle",
    Flag = "Inventory_View",
    Callback = function(value)
        frame.Visible = value
    end
})

-- Create 3 ImageLabel boxes with transparent background by default
local imageBoxes = {}
local durabilityBars = {}
for i = 1, 3 do
    local imageBox = Instance.new("ImageLabel", frame)
    imageBox.Size = UDim2.new(0, 70, 0, 60)

    -- Calculate positions using predefined constants
    local xOffset = 10 + (i - 1) * 115
    imageBox.Position = UDim2.new(0, xOffset, 0, 20)

    imageBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- Transparent background
    imageBox.BackgroundTransparency = 1
    imageBox.BorderSizePixel = 2
    imageBox.Image = ""  -- Default to no image
    imageBox.Visible = false
    imageBoxes[i] = imageBox

    -- Create a durability bar next to each imageBox
    local durabilityBar = Instance.new("Frame", frame)
    durabilityBar.Size = UDim2.new(0, 5, 0, 60)  -- Thinner line
    durabilityBar.Position = UDim2.new(0, xOffset + 75, 0, 20)  -- Adjusted position to be next to each weapon
    durabilityBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    durabilityBar.Visible = false
    durabilityBars[i] = durabilityBar

    -- Create a small line between each box
    if i < 3 then
        local separatorLine = Instance.new("Frame", frame)
        separatorLine.Size = UDim2.new(0, 1, 0, 60)
        separatorLine.Position = UDim2.new(0, 10 + i * 115 - 5, 0, 20)
        separatorLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
end


-- FOV Circle Setup (True Circle)
local fovCircle = Instance.new("Frame", gui)
fovCircle.Size = UDim2.new(0, 150, 0, 150)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fovCircle.BackgroundTransparency = 0.5
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.ClipsDescendants = true

local circleMask = Instance.new("UICorner", fovCircle)
circleMask.CornerRadius = UDim.new(0.5, 0)


game:GetService("RunService").RenderStepped:Connect(function()
    -- Update FOV Circle Position to center on the mouse
    fovCircle.Position = UDim2.new(0, mouse.X, 0, mouse.Y)

    local replicatedStorage = game:GetService("ReplicatedStorage")
    local playersFolder = replicatedStorage:FindFirstChild("Players")
    if not playersFolder then return end
    
    local closestPlayer, minDistance = nil, math.huge
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = otherPlayer.Character.HumanoidRootPart
            local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
            if distance < minDistance then
                closestPlayer = otherPlayer
                minDistance = distance
            end
        end
    end
    
    if closestPlayer then
        nameLabel.Text = closestPlayer.Name
        local playerData = playersFolder:FindFirstChild(closestPlayer.Name)
        
        if playerData and playerData:FindFirstChild("Inventory") then
            local inventory = playerData.Inventory
            local items = {}
            
            for _, item in pairs(inventory:GetChildren()) do
                if item:IsA("StringValue") then
                    table.insert(items, item)
                end
            end
            
            -- Set ItemIcon for the first 3 items
            for i, imageBox in ipairs(imageBoxes) do
                if items[i] then
                    local itemProperties = items[i]:FindFirstChild("ItemProperties")  -- Get ItemProperties from StringValue
                    if itemProperties then
                        local itemIcon = itemProperties:FindFirstChild("ItemIcon")  -- Get ItemIcon ImageLabel
                        if itemIcon and itemIcon:IsA("ImageLabel") then
                            imageBox.Image = itemIcon.Image  -- Set the Image from ImageLabel
                            imageBox.Visible = true
                            
                            local durability = itemProperties:GetAttribute("Durability")
                            local maxDurability = itemProperties:GetAttribute("OriginalMaxDurability")
                            if durability and maxDurability then
                                local durabilityBar = durabilityBars[i]
                                local ratio = durability / maxDurability
                                durabilityBar.Size = UDim2.new(0, 5, 0, 60 * ratio)  -- Adjust size based on durability ratio
                                durabilityBar.Position = UDim2.new(0, imageBox.Position.X.Offset - 8, 0, 20 + (60 - durabilityBar.Size.Y.Offset))
                                durabilityBar.Visible = true
                            else
                                durabilityBars[i].Visible = false
                            end
                        else
                            imageBox.Visible = false
                        end
                    else
                        imageBox.Visible = false
                    end
                else
                    imageBox.Visible = false
                end
            end
        else
            for _, imageBox in ipairs(imageBoxes) do
                imageBox.Visible = false
            end
        end
    else
        nameLabel.Text = ""
        for _, imageBox in ipairs(imageBoxes) do
            imageBox.Visible = false
        end
    end

    -- Handle visibility of FOV circle based on toggle
    local toggleValue = ClientSided:GetToggle("Inventory_View")
    fovCircle.Visible = toggleValue
end)


local Sigma = PepsisWorld:CreateTab({
    Name = "Aimbot" 
})

local EdgingAimbot = Sigma:CreateSection({
    Name = "Aimbot",
})

-- // Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- // Default Values
local Aim_Enabled = false
local Prediction_Enabled = false
local Aim_Smoothness = 0.15
local FOV_RADIUS = 150
local HoldingMB2 = false
local LockThroughWalls = false

-- // FOV Circle
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Thickness = 2
FOV_Circle.Filled = false
FOV_Circle.Transparency = 1
FOV_Circle.Color = Color3.fromRGB(255, 0, 0) -- Default color
FOV_Circle.Visible = false -- Initially hidden

-- // Function to update FOV position
local function UpdateFOV()
    local MouseLocation = UserInputService:GetMouseLocation()
    FOV_Circle.Position = MouseLocation
    FOV_Circle.Radius = FOV_RADIUS
    FOV_Circle.Visible = Aim_Enabled -- Only show FOV when Aim Assist is on
end

-- // Function to get closest player inside the FOV
local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ShortestDistance = FOV_RADIUS

    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = Player.Character.HumanoidRootPart
            local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
            local Velocity = RootPart.Velocity

            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)

            if OnScreen then
                local MousePos = UserInputService:GetMouseLocation()
                local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude

                if Distance < ShortestDistance and (not LockThroughWalls or not Camera:GetPartsObscuringTarget({RootPart.Position}, {RootPart.Parent})) then
                    ShortestDistance = Distance
                    ClosestPlayer = RootPart
                end
            end
        end
    end

    return ClosestPlayer
end

-- // Smart Prediction Function
local function GetPredictedPosition(Target)
    if not Target or not Prediction_Enabled then return Target.Position end

    local Velocity = Target.Velocity
    local Distance = (Target.Position - Camera.CFrame.Position).Magnitude

    -- Smart prediction: scales prediction time based on target speed & distance
    local PredictionFactor = math.clamp(Distance / 100, 0.05, 0.2)
    return Target.Position + (Velocity * PredictionFactor)
end

-- // Mouse Button Detection
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        HoldingMB2 = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        HoldingMB2 = false
    end
end)

-- // Main loop to update aim
RunService.RenderStepped:Connect(function()
    UpdateFOV()

    if Aim_Enabled and HoldingMB2 then
        local Target = GetClosestPlayer()
        if Target then
            local AimPosition = GetPredictedPosition(Target)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, AimPosition), Aim_Smoothness)
        end
    end
end)

-- // UI Callbacks
EdgingAimbot:AddToggle({
    Name = "Toggle",
    Flag = "FarmingSection_CollectCoins",
    Callback = function(Value)
        Aim_Enabled = Value
        FOV_Circle.Visible = Value -- Ensure visibility updates correctly
    end
})

EdgingAimbot:AddToggle({
    Name = "Prediction Aiming",
    Flag = "FarmingSection_PredictionAiming",
    Callback = function(Value)
        Prediction_Enabled = Value
    end
})

EdgingAimbot:AddToggle({
    Name = "Lock Through Walls",
    Flag = "FarmingSection_LockThroughWalls",
    Callback = function(Value)
        LockThroughWalls = Value
    end
})

EdgingAimbot:AddSlider({
    Name = "Strength",
    Flag = "FarmingSection_TrickRate",
    Value = 0.15,
    Precise = 2,
    Min = 0,
    Max = 1,
    Callback = function(Value)
        Aim_Smoothness = Value
    end
})

EdgingAimbot:AddSlider({
    Name = "FOV Size",
    Flag = "FarmingSection_FOVSize",
    Value = 150,
    Precise = 0,
    Min = 50,
    Max = 300,
    Callback = function(Value)
        FOV_RADIUS = Value
    end
})


local EdgingAimbot = Sigma:CreateSection({
    Name = "Look",
    Side = "Right"
})

EdgingAimbot:AddColorPicker({
    Name = "FOV Color",
    Flag = "FOVColor_Flag",
    Callback = function(Value)
        FOV_Circle.Color = Value
        print("")
    end
})

EdgingAimbot:AddSlider({
    Name = "Transparency",
    Flag = "Deaddassss_FOVTransparency",
    Value = 1,
    Precise = 2,
    Min = 0,
    Max = 1,
    Callback = function(Value)
        FOV_Circle.Transparency = Value
    end
})






local GeneralTab = PepsisWorld:CreateTab({
    Name = "Experimental"
})

local ClientSettings = GeneralTab:CreateSection({
    Name = "Client Settings"
})

ClientSettings:AddSlider({
    Name = "Fov",
    Min = 20,
    Max = 140,
    Default = 120,
    Callback = function(value)
        local player = game.Players.LocalPlayer -- Get the local player
        local playerFolder = game.ReplicatedStorage.Players:FindFirstChild(player.Name)

        if playerFolder then
            local settings = playerFolder:FindFirstChild("Settings")
            local gameplaySettings = settings and settings:FindFirstChild("GameplaySettings")

            if gameplaySettings then
                if gameplaySettings:GetAttribute("DefaultFOV") ~= nil then
                    gameplaySettings:SetAttribute("DefaultFOV", tostring(value)) -- Store as a string
                    print("Default FOV set to: " .. tostring(value))
                else
                    warn("Attribute 'DefaultFOV' does not exist in GameplaySettings for player " .. player.Name)
                end
            else
                warn("GameplaySettings folder not found inside Settings for player " .. player.Name)
            end
        else
            warn("Player folder not found in ReplicatedStorage for player " .. player.Name)
        end
    end
})


ClientSettings:AddToggle({
    Name = "SpinBot",
    Default = false,
    Callback = function(enabled)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local lowerTorso = character and character:FindFirstChild("LowerTorso")
        local rootJoint = lowerTorso and lowerTorso:FindFirstChild("Root") -- RootJoint connects torso to HumanoidRootPart
        local camera = game.Workspace.CurrentCamera

        if rootPart then
            _G.Rotating = enabled
            if enabled then
                task.spawn(function()
                    while _G.Rotating do
                        task.wait(0.03)
                        
                        if player.CameraMode == Enum.CameraMode.LockFirstPerson then
                            -- Rotate rootPart directly in first-person mode without affecting the camera
                            rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(_G.RotationSpeed or 10), 0)
                        elseif rootJoint then
                            -- Rotate normally in third-person mode
                            rootJoint.C0 = rootJoint.C0 * CFrame.Angles(0, math.rad(_G.RotationSpeed or 10), 0)
                        end
                    end
                end)
            end
        else
            warn("RootPart or RootJoint not found for player " .. player.Name)
        end
    end
})

ClientSettings:AddSlider({
    Name = "Spin Bot Speed",
    Min = 1,
    Max = 100,
    Default = 10,
    Callback = function(value)
        _G.RotationSpeed = value
    end
})



local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local FreecamEnabled = false

function EnableFreecam()
    FreecamEnabled = true
    Camera.CameraType = Enum.CameraType.Scriptable
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

function DisableFreecam()
    FreecamEnabled = false
    Camera.CameraType = Enum.CameraType.Custom
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end

ClientSettings:AddToggle({
    Name = "Freecam",
    Flag = "Freecam_Toggle",
    Callback = function(value)
        if value then
            EnableFreecam()
        else
            DisableFreecam()
        end
    end
})

RunService.RenderStepped:Connect(function()
    if FreecamEnabled then
        local moveVector = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + Camera.CFrame.RightVector
        end

        Camera.CFrame = Camera.CFrame + moveVector * 0.5
    end
end)





local ClientSided = GeneralTab:CreateSection({
    Name = "Gui",
    Side = "Right"
})

ClientSided:AddButton({
    Name = "No effects",
    Callback = function()
        -- Remove specific blur and effects from Lighting
        local lighting = game:GetService("Lighting")
        
        -- Remove BlurEffects
        local waterBlur = lighting:FindFirstChild("WaterBlur")
        if waterBlur and waterBlur:IsA("BlurEffect") then
            waterBlur:Destroy()
            print("WaterBlur removed")
        end

        local inventoryBlur = lighting:FindFirstChild("InventoryBlur")
        if inventoryBlur and inventoryBlur:IsA("BlurEffect") then
            inventoryBlur:Destroy()
            print("InventoryBlur removed")
        end

        -- Remove HurtEffect (ColorCorrectionEffect)
        local hurtEffect = lighting:FindFirstChild("HurtEffect")
        if hurtEffect and hurtEffect:IsA("ColorCorrectionEffect") then
            hurtEffect:Destroy()
            print("HurtEffect removed")
        end
    end
})


ClientSided:AddButton({
    Name = "Rejoin",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer

        -- Store the current game ID (the player's current place)
        local currentGameID = game.PlaceId
        local currentJobID = game.JobId

        -- Rejoin the same game
        game:GetService("TeleportService"):TeleportToPlaceInstance(currentGameID, currentJobID, player)
        
        print("Rejoining the same game...")
    end
})


local Lighting = game:GetService("Lighting") -- Ensure Lighting is properly referenced

local ClientSided = GeneralTab:CreateSection({
    Name = "environment",
    Side = "Right"
})
ClientSided:AddButton({
    Name = "Green",
    Callback = function()
        Lighting.Ambient = Color3.fromRGB(0, 255, 0)
    end
})
ClientSided:AddButton({
    Name = "Yellow",
    Callback = function()
        Lighting.Ambient = Color3.fromRGB(255, 255, 0)
    end
})
ClientSided:AddButton({
    Name = "Blue",
    Callback = function()
        Lighting.Ambient = Color3.fromRGB(0, 0, 255)
    end
})
ClientSided:AddButton({
    Name = "White",
    Callback = function()
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    end
})
ClientSided:AddButton({
    Name = "Purple",
    Callback = function()
        Lighting.Ambient = Color3.fromRGB(128, 0, 128)
    end
})
game.StarterGui:SetCore("SendNotification", {
    Title = "Script loaded",
    Text = "V|1.3",
    Button1 = "yeah.",
    Button2 = "really?!!?!?!?!?!?",
    Duration = math.huge
})
