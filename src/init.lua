local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

local States = require(script.UI.States)
local Utils = require(script.Utils)

local HotbarGui = require(script.UI.Components.Hotbar)

local GAMEPAD_SELECTOR_INDEXERS = {Left = -1, Right = 1}

if not RunService:IsStudio() then
    print("NeoHotbar 0.1.0 by Avafe 🌟🛠")
end

--[=[
    @class NeoHotbar
]=]
local NeoHotbar = {
    _Started = false,
    _States = script.UI.States,
    _Utils = script.Utils,
}

--[=[
    Initializes NeoHotbar and deploys its UI with default settings.
]=]
function NeoHotbar:Start()
    assert(not self._Started, "NeoHotbar has already been started. It cannot be started again.")
    self._Started = true

    States:Init()
    States:Start()

    self:_CreateGui()

    if not VRService.VREnabled then -- Don't disable default backpack on VR
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    end

    UserInputService.InputEnded:Connect(function(Input)
        local ToolSlots = States.ToolSlots:get()
        if Input.UserInputType == Enum.UserInputType.Keyboard then
            local InputNumber = tonumber(UserInputService:GetStringForKeyCode(Input.KeyCode))
            local ToolSlot = ToolSlots[InputNumber]
            if ToolSlot and not UserInputService:GetFocusedTextBox() then
                Utils:ToggleToolEquipped(ToolSlot.Tool)
            end
        elseif Input.UserInputType == Enum.UserInputType.Gamepad1 then
            local EquippedToolSlot, EquippedToolSlotIndex = Utils:GetEquippedToolSlot()
            local SelectorDirection
            if Input.KeyCode == Enum.KeyCode.ButtonL1 then
                SelectorDirection = "Left"
            elseif Input.KeyCode == Enum.KeyCode.ButtonR1 then
                SelectorDirection = "Right"
            else
                return
            end
            local ToolSlot
            if EquippedToolSlot then
                local ToolSlotIndex = EquippedToolSlotIndex + GAMEPAD_SELECTOR_INDEXERS[SelectorDirection]
                ToolSlot = ToolSlots[ToolSlotIndex]
                ToolSlot = ToolSlot or EquippedToolSlot -- Set equipped tool to be unequipped if reached end
            else
                if not ToolSlot then -- For default / wrapover selection based on direction
                    if SelectorDirection == "Left" then
                        ToolSlot = ToolSlots[#ToolSlots]
                    else
                        ToolSlot = ToolSlots[1]
                    end
                end
            end
            Utils:ToggleToolEquipped(ToolSlot.Tool)
        end
    end)
end

--[=[
    Overrides NeoHotbar's UI with a new set of Gui objects.

    @param CustomGuiSet -- The parent folder containing your custom Gui objects.
]=]
function NeoHotbar:OverrideGui(CustomGuiSet: Folder, DefaultEffectsEnabled: any)
    assert(self._Started, "NeoHotbar needs to be started before you can override its GUI!")
    DefaultEffectsEnabled = (DefaultEffectsEnabled == nil and false) or DefaultEffectsEnabled

    States.InstanceSet:set(CustomGuiSet)
    States.DefaultEffectsEnabled:set(DefaultEffectsEnabled)
    self._HotbarGui:Destroy()
    self:_CreateGui()
end

--[=[
    Adds a custom button to the hotbar, prepended to the left-most side.

    @param ButtonName string -- The name/identifier of the button to be added.
    @param IconImage string -- The image URI to be used on the button icon. E.g. "rbxassetid://".
    @param Callback function -- The function called upon button activation (click/touch/etc).
]=]
function NeoHotbar:AddCustomButton(ButtonName: string, IconImage: string, Callback: any)
    assert(self._Started, "NeoHotbar needs to be started before you can add custom buttons!")

    local CustomButtons = States.CustomButtons:get()
    table.insert(CustomButtons, {
        Name = ButtonName,
	    Icon = IconImage,
		Callback = Callback,
    })
    States.CustomButtons:set(CustomButtons)
end

--[=[
    Removes the specified custom button from the hotbar.

    @param ButtonName string -- The name of the button to be removed.
]=]
function NeoHotbar:RemoveCustomButton(ButtonName: string)
    assert(self._Started, "NeoHotbar needs to be started before you can remove custom buttons!")

    local CustomButton = Utils:FindCustomButton(ButtonName)
    assert(CustomButton, "Custom button \""..ButtonName.."\" could not be found.")

    local CustomButtons = States.CustomButtons:get()
    table.remove(CustomButtons, table.find(CustomButtons, CustomButton))
    States.CustomButtons:set(CustomButtons)
end

--[=[
    @private

    Creates/updates NeoHotbar's UI. To be used internally.
]=]
function NeoHotbar:_CreateGui()
    self._HotbarGui = HotbarGui {
        Parent = Players.LocalPlayer.PlayerGui
    }
end

return NeoHotbar