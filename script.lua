_G.LocalPlayer = game.Players.LocalPlayer
_G.newcam = false
_G.aimbot = false
_G.destroy = false

local refresh = 0.05

function MakeRay(startPos, endPos, show) -- Creates a new ray
    local dir = endPos - startPos
    local d = dir.Magnitude
    local ray = Ray.new(startPos, dir)
    local obj, endPoint = workspace:FindPartOnRay(ray)
    if show then -- This is for debugging. It will make the rays visible
        local rayPart = Instance.new("Part", workspace)
        rayPart.Name          = "RayPart"
        rayPart.BrickColor    = BrickColor.new("Bright red")
        rayPart.Transparency  = 0
        rayPart.Anchored      = true
        rayPart.CanCollide    = false
        rayPart.TopSurface    = Enum.SurfaceType.Smooth
        rayPart.BottomSurface = Enum.SurfaceType.Smooth
        rayPart.formFactor    = Enum.FormFactor.Custom
        rayPart.Size          = Vector3.new(0.2, 0.2, d)
        rayPart.CFrame        = CFrame.new(startPos, Vector3.new(endPos.x, endPos.y, endPos.z)) * CFrame.new(0, 0, -d/2)
        game.Debris:AddItem(rayPart, refresh) -- Add the part to Debris so it will remove itself after 0.1 second
    end
    return obj -- Return any found objects with ray
end

function toggle(inputObject, gameProcessedEvent)
    if inputObject.KeyCode == Enum.KeyCode.L then
        _G.aimbot = not _G.aimbot
        print("Aimbot: "..tostring(_G.aimbot))
        run()
    elseif inputObject.KeyCode == Enum.KeyCode.O then
        if _G.mouseEvent ~= nil and _G.cameraEvent ~= nil then
            print("Destroying keyboard and camera hooks")
            _G.destroy = true
            _G.aimbot = false
            _G.mouseEvent:Disconnect()
            _G.cameraEvent:Disconnect()
        end
    end
end

_G.mouseEvent = game:GetService("UserInputService").InputBegan:connect(toggle)

local stepTime = 1.0/60.0
local aimTime = 1.0/10.0
local numOfSteps = aimTime / stepTime
local i = 0

function step() -- On
	i = i+1
	if i > numOfSteps or not _G.aiming or not _G.aimbot or _G.destroy then 
		i = 0
	end
    if not _G.destroy and _G.aimbot and _G.aiming then
        local localPlayerBody = _G.LocalPlayer.Character
        local Camera = workspace.CurrentCamera

        if localPlayerBody ~= nil and localPlayerBody:WaitForChild("Head") ~= nil then
            local head = localPlayerBody.Head

            if head ~= nil and _G.target ~= nil and localPlayerBody:WaitForChild("Humanoid") ~= nil then
				Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(head.Position, _G.target.Position), i/numOfSteps)
			end
        end
    end
end

_G.cameraEvent = game:GetService('RunService').Stepped:Connect(step)

function findTarget(show)
    local players = game.Players:GetPlayers()
    for i=0, #players do
        local player = players[i]
        if player ~= nil then
            if player.TeamColor ~= _G.LocalPlayer.TeamColor then
                local me = _G.LocalPlayer.Character.Head

                local myPos = me.Position
                local playerChar = player.Character
                if playerChar ~= nil and playerChar:WaitForChild("Humanoid").Health ~= 0 then
                    local targetPos = playerChar.Head.Position

                    local direction = targetPos - myPos
                    local directionM = direction.unit

                    local hit = MakeRay(me.Position + directionM*1.5, targetPos + directionM*5, show)
                    if hit ~= nil and hit.Parent ~= nil and hit.Parent.Name == player.Name then
                        return hit
                    end
                end
            end
        end
    end
end

local debug = false

function run()
    while not _G.destroy do
        if _G.aimbot then
            local localPlayerBody = _G.LocalPlayer.Character
            if localPlayerBody ~= nil and localPlayerBody:WaitForChild("Humanoid").Health ~= 0 then
                local head = localPlayerBody.Head
                local target = findTarget(debug)

                if target ~= nil and head ~= nil then
                    if target.Parent ~= nil and target.Parent.Humanoid ~= nil then
                        local targetName = target.Parent.Name

                        if target.Parent.Humanoid.Health ~= 0 then
                            _G.aiming = true
                            _G.target = target
                        else
                            _G.aiming = false
                        end
                    end
                else
                    _G.aiming = false
                end
            end
        end

        game:GetService("RunService").RenderStepped:wait()
        wait(refresh)
    end
end