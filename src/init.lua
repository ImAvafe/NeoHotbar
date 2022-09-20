local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local NeoHotbar = script

local States = require(NeoHotbar.States)

local HotbarGui = require(NeoHotbar.Components.Hotbar)

if not RunService:IsStudio() then
    print("NeoHotbar 0.1.0 by @Cyphical 🌟🛠")
end

local NeoHotbarAPI = {}

function NeoHotbarAPI:Start()
    States:Init()
    States:Start()

    HotbarGui {
        Parent = Players.LocalPlayer.PlayerGui
    }

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)


end

return NeoHotbarAPI