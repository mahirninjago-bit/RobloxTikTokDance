-- Roblox Lua Script: TikTok & Meme Dances
-- Autor: Meister
-- Nutzung: Einfach in ein LocalScript einfügen

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Sammlung bekannter Tanzanimationen
local DanceAnimations = {
    ["Runaway"] = 210136288,      -- Runaway Meme
    ["BlackGoku"] = 1234567890,   -- Platzhalter ID
    ["Tacata"] = 9876543210,      -- Platzhalter ID
    ["DefaultDance1"] = 507768133,
    ["DefaultDance2"] = 180435571,
    ["DefaultDance3"] = 180435574,
    ["Floss"] = 180426354,        -- Klassischer Floss Dance
    ["OrangeJustice"] = 180426467 -- Fortnite Klassiker
}

-- Funktion zum Abspielen einer Tanzanimation
local function playDance(danceName)
    local animId = DanceAnimations[danceName]
    if animId then
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://"..animId
        local animTrack = Humanoid:LoadAnimation(animation)
        animTrack:Play()
    else
        warn("Tanz '"..danceName.."' nicht gefunden!")
    end
end

-- Standardmäßig: Runaway Meme spielen
playDance("Runaway")

-- Chatsteuerung: Spieler können Tänze per Chat starten
LocalPlayer.Chatted:Connect(function(msg)
    local danceName = msg:match("!dance (%w+)")
    if danceName then
        playDance(danceName)
    end
end)
