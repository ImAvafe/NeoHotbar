local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local States = require(script.UI.States)
local Utils = require(script.Utils)

local HotbarGui = require(script.UI.Components.Hotbar)

if not RunService:IsStudio() then
    print("NeoHotbar 0.1.0 by @Cyphical 🌟🛠")
end

local NeoHotbar = {}

function NeoHotbar:Start()
    if self.Started then
        warn("NeoHotbar has already been started. It cannot be started again.")
    end
    self.Started = true

    States:Init()
    States:Start()

    HotbarGui {
        Parent = Players.LocalPlayer.PlayerGui
    }

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

    UserInputService.InputBegan:Connect(function(Input)
        local ToolSlots = States.ToolSlots:get()
        local InputNumber = tonumber(UserInputService:GetStringForKeyCode(Input.KeyCode))
        local ToolSlot = ToolSlots[InputNumber]
        if ToolSlot and not UserInputService:GetFocusedTextBox() then
            Utils:ToggleToolEquipped(ToolSlot.Tool)
        end
    end)
end

function NeoHotbar:AddCustomButton(IconImage: string, Callback: any)
   local CustomButtons = States.CustomButtons:get()
   table.insert(CustomButtons, {
		Icon = IconImage,
		Callback = Callback,
   })
   States.CustomButtons:set(CustomButtons, true)
end

return NeoHotbar