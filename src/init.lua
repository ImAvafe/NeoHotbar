local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

local States = require(script.UI.States)
local Utils = require(script.Utils)
local Instances = require(script.UI.Instances)

local HotbarGui = require(script.UI.Components.Hotbar)

if not RunService:IsStudio() then
    print("NeoHotbar 0.1.0 by Avafe 🌟🛠")
end

local NeoHotbar = {}

function NeoHotbar:Start()
    assert(not self._Started, "NeoHotbar has already been started. It cannot be started again.")
    self._Started = true

    States:Init()
    States:Start()

    self:_CreateGui()

    if not VRService.VREnabled then -- Don't disable default backpack on VR
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    end

    UserInputService.InputBegan:Connect(function(Input)
        local ToolSlots = States.ToolSlots:get()
        local InputNumber = tonumber(UserInputService:GetStringForKeyCode(Input.KeyCode))
        local ToolSlot = ToolSlots[InputNumber]
        if ToolSlot and not UserInputService:GetFocusedTextBox() then
            Utils:ToggleToolEquipped(ToolSlot.Tool)
        end
    end)
end

function NeoHotbar:UpdateGuiSet(CustomGuiSet: ScreenGui)
    assert(self._Started, "NeoHotbar needs to have been started to reload its GUI.")
    Instances:Overwrite(CustomGuiSet)
    self._HotbarGui:Destroy()
    self:_CreateGui()
end

function NeoHotbar:AddCustomButton(IconImage: string, Callback: any)
   local CustomButtons = States.CustomButtons:get()
   table.insert(CustomButtons, {
		Icon = IconImage,
		Callback = Callback,
   })
   States.CustomButtons:set(CustomButtons)
end

function NeoHotbar:_CreateGui()
    self._HotbarGui = HotbarGui {
        Parent = Players.LocalPlayer.PlayerGui
    }
end

return NeoHotbar