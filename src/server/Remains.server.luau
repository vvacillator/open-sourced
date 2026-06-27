-- Ayden
-- June 26th, 2026

local REMAINS_LIFETIME = 180
local RAYCAST_DISTANCE = 50

local Debris = game:GetService("Debris");
local Players = game:GetService("Players");

local Size = Vector3.new(2, 0.2, 2)
local ClipOffset = Vector3.new(0, 0.1, 0)

local RAY_DIRECTION = Vector3.new(0, -RAYCAST_DISTANCE, 0)

local function placeRemains(position, character)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {character}

    local player = Players:GetPlayerFromCharacter(character)

	local hit = workspace:Raycast(position, RAY_DIRECTION, rayParams)

    local remains = Instance.new("Part")
    remains.Name = ("%s_Remains"):format(player.Name)
    remains.Anchored = true
    remains.CanCollide = false
    remains.Size = Size
    remains.Position = (hit and hit.Position or position) + ClipOffset
    remains.Parent = workspace.Junk

    Debris:AddItem(remains, REMAINS_LIFETIME)
end

local function registerCharacter(character)
    local human = character:WaitForChild("Humanoid") :: Humanoid
    local rootPart = human.RootPart

    human.Died:Once(function()
        if rootPart then
            placeRemains(rootPart.Position, character)
        end
    end)
end

local function registerPlayer(player) 
    player.CharacterAdded:Connect(registerCharacter)

    if player.Character then 
        registerCharacter(player.Character) 
    end
end

Players.PlayerAdded:Connect(registerPlayer)
for _, player in Players:GetPlayers() do 
    registerPlayer(player)
end