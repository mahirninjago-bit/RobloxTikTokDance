-- tiktok_allsee.lua
-- Dieses Script erzeugt RemoteEvent, Server und UI für TikTok-Dances (sichtbar für alle)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Animation-IDs (deine drei IDs)
local dances = {
    {name = "Dance 1", id = 18953372238},
    {name = "Dance 2", id = 966270845},
    {name = "Dance 3", id = 4868656243},
}

-- RemoteEvent erstellen (falls noch nicht vorhanden)
local eventName = "PlayDanceEvent"
local playDanceEvent = ReplicatedStorage:FindFirstChild(eventName)
if not playDanceEvent then
    playDanceEvent = Instance.new("RemoteEvent")
    playDanceEvent.Name = eventName
    playDanceEvent.Parent = ReplicatedStorage
end

-- Server-Teil: Animation für alle Spieler sichtbar abspielen
if game:GetService("RunService"):IsServer() then
    playDanceEvent.OnServerEvent:Connect(function(player, animId)
        if type(animId) ~= "number" then return end
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = humanoid
        end
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://"..tostring(animId)
        local success, track = pcall(function() return animator:LoadAnimation(animation) end)
        if success and track then
            track.Priority = Enum.AnimationPriority.Action
            track:Play()
        end
    end)
end

-- Client-Teil: UI erstellen
if game:GetService("RunService"):IsClient() then
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TikTokDanceUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,220,0,30 + #dances*40)
    frame.Position = UDim2.new(0,10,0,80)
    frame.BackgroundTransparency = 0.15
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,30)
    title.BackgroundTransparency = 1
    title.Text = "TikTok Dances"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = frame

    local yOffset = 30
    for _, dance in ipairs(dances) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-10,0,36)
        btn.Position = UDim2.new(0,5,0,yOffset)
        btn.BackgroundTransparency = 0.05
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 16
        btn.Text = dance.name
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            playDanceEvent:FireServer(dance.id)
        end)

        yOffset = yOffset + 40
    end

    -- Stop Button
    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(1,-10,0,28)
    stopBtn.Position = UDim2.new(0,5,0,yOffset)
    stopBtn.BackgroundTransparency = 0.05
    stopBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    stopBtn.TextColor3 = Color3.new(1,1,1)
    stopBtn.Font = Enum.Font.SourceSans
    stopBtn.TextSize = 14
    stopBtn.Text = "Stop Dance"
    stopBtn.Parent = frame
    stopBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end
    end)
end
