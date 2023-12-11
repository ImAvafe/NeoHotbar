local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local States = require(script.States)
local HotbarGui = require(script.Components.Hotbar)

local GAMEPAD_SELECTOR_INDEXERS = { Left = -1, Right = 1 }

if not RunService:IsStudio() then
	print("NeoHotbar by Avafe 🌟🛠")
end

--[=[
	@class NeoHotbar
]=]
local NeoHotbar = {
	Started = false,
	States = States,
}

--[=[
	Initializes NeoHotbar and deploys its UI with default settings.
]=]
function NeoHotbar:Start()
	if self.Started then
		warn("NeoHotbar has already been started. It cannot be started again.")
		return
	end

	self.Started = true

	States:Start()

	self:_CreateGui()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

	UserInputService.InputEnded:Connect(function(Input)
		if not States.Enabled:get() then return end
		if UserInputService:GetFocusedTextBox() then return end

		local ToolSlots = States.ToolSlots:get()

		if Input.UserInputType == Enum.UserInputType.Keyboard then
			local InputNumber = tonumber(UserInputService:GetStringForKeyCode(Input.KeyCode))
			if InputNumber then
				local ToolSlot = ToolSlots[InputNumber]
				if ToolSlot then
					States:ToggleToolEquipped(ToolSlot.Tool:get())
				end
				States.ManagementMode.Active:set(false)
			elseif Input.KeyCode == Enum.KeyCode.Backquote then
				if States.ManagementMode.Enabled:get() then
					States.ManagementMode.Active:set(not States.ManagementMode.Active:get())
				end
			end
		elseif Input.UserInputType == Enum.UserInputType.Gamepad1 then
			local EquippedToolSlot, EquippedToolSlotIndex = States:GetEquippedToolSlot()
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
					elseif SelectorDirection == "Right" then
						ToolSlot = ToolSlots[1]
					end
				end
			end

			States:ToggleToolEquipped(ToolSlot.Tool:get())
			States.ManagementMode.Active:set(false)
		elseif (Input.UserInputType == Enum.UserInputType.MouseButton1) or (Input.UserInputType == Enum.UserInputType.Touch) then
			local InteractedGuiObjects = Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(Input.Position.X, Input.Position.Y)
			
			local GuiWithinToolSlots
			for _, GuiObject in ipairs(InteractedGuiObjects) do
				local NeoHotbarAncestor = GuiObject:FindFirstAncestor("NeoHotbar")
				if NeoHotbarAncestor == self._HotbarGui then
					GuiWithinToolSlots = true
					break
				end
			end

			if not GuiWithinToolSlots then
				States.ManagementMode.Active:set(false)
				States.ContextMenu.Active:set(false)
			end
		end
	end)
end

--[=[
	Sets whether NeoHotbar or not is enabled. Disabling hides the hotbar and turns off keybinds.

	@param Enabled -- Whether or not to enable NeoHotbar.
]=]
function NeoHotbar:SetEnabled(Enabled: boolean)
	if typeof(Enabled) ~= "boolean" then return end

	if not self.Started then
		warn("NeoHotbar needs to be started before you can change if it's enabled or not.")
		return
	end

	States.Enabled:set(Enabled)

	States.ManagementMode.Active:set(false)
	States.ContextMenu.Active:set(false)
end

--[=[
	Sets whether or not ToolTips are enabled.

	@param Enabled -- Whether or not to enable.
]=]
function NeoHotbar:SetToolTipsEnabled(Enabled: boolean)
	if typeof(Enabled) ~= "boolean" then return end

	if not self.Started then
		warn("NeoHotbar needs to be started before you can change if ToolTips are enabled or not.")
		return
	end

	States.ToolTip.Enabled:set(Enabled)
end

--[=[
	Sets whether or not players can rearrange the tools in their hotbar.

	@param Enabled -- Whether or not to enable.
]=]
function NeoHotbar:SetManagementEnabled(Enabled: boolean)
	if typeof(Enabled) ~= "boolean" then return end

	if not self.Started then
		warn("NeoHotbar needs to be started before you can change if hotbar management is enabled.")
		return
	end

	States.ManagementMode.Enabled:set(Enabled)
end

--[=[
	Sets whether or not players can open the context menu. *(the one that appears when you right click on a tool)*

	@param Enabled -- Whether or not to enable.
]=]
function NeoHotbar:SetContextMenuEnabled(Enabled: boolean)
	if typeof(Enabled) ~= "boolean" then return end

	if not self.Started then
		warn("NeoHotbar needs to be started before you can change if the context menu is enabled or not.")
		return
	end

	States.ContextMenu.Enabled:set(Enabled)
end

--[=[
	Overrides NeoHotbar's UI with a new set of Gui objects.

	@param CustomGuiSet -- The parent folder containing your custom Gui objects.
	@param DefaultEffectsEnabled -- Whether or not to enable NeoHotbar's built-in UI effects. Not compatible with ultra-customized themes.
]=]
function NeoHotbar:OverrideGui(CustomGuiSet: Folder, DefaultEffectsEnabled: boolean?)
	if typeof(CustomGuiSet) ~= "Instance" then return end

	if not self.Started then
		warn("NeoHotbar needs to be started before you can override its GUI.")
		return
	end
	
	if DefaultEffectsEnabled == nil then
		DefaultEffectsEnabled = false
	end

	States.InstanceSet:set(CustomGuiSet)
	States.DefaultEffectsEnabled:set(DefaultEffectsEnabled)
	self._HotbarGui:Destroy()
	self:_CreateGui()
end

--[=[
	Reset NeoHotbar's UI back to the default.
]=]
function NeoHotbar:ResetGui()
	if not self.Started then
		warn("NeoHotbar needs to be started before you can reset its GUI.")
		return
	end

	States.InstanceSet:set(script.DefaultInstances)
	States.DefaultEffectsEnabled:set(true)
	self._HotbarGui:Destroy()
	self:_CreateGui()
end

--[=[
	Adds a custom button to the hotbar, prepended to the left-most side.

	@param ButtonName -- The name/identifier of the button to be added.
	@param IconImage -- The image URI to be used on the button icon. E.g. "rbxassetid://".
	@param Callback -- The function called upon button activation (click/touch/etc).
	@param GamepadKeybind -- A gamepad keycode to trigger your custom button.
]=]
function NeoHotbar:AddCustomButton(ButtonName: string, IconImage: string, Callback: any, GamepadKeybind: EnumItem?)
	if typeof(ButtonName) ~= "string" then return end
	if typeof(IconImage) ~= "string" then return end

	if not self.Started then
		warn("NeoHotbar needs to be started before you can add or remove custom buttons.")
		return
	end

	local CustomButtons = States.CustomButtons:get()
	table.insert(CustomButtons, {
		Name = ButtonName,
		Icon = IconImage,
		Callback = Callback,
		GamepadKeybind = GamepadKeybind,
	})
	States.CustomButtons:set(CustomButtons)

	if GamepadKeybind then
		ContextActionService:BindAction(`NeoHotbar_{ButtonName}`, function(_, InputState: EnumItem)
			if InputState == Enum.UserInputState.End then
				Callback()
			end
		end, false, GamepadKeybind)
	end
end

--[=[
	Removes the specified custom button from the hotbar.

	@param ButtonName -- The name of the button to be removed.
]=]
function NeoHotbar:RemoveCustomButton(ButtonName: string)
	if typeof(ButtonName) ~= "string" then return end

	if not self.Started then
		warn("NeoHotbar needs to be started before you can add or remove custom buttons.")
		return
	end

	local CustomButton = States:FindCustomButton(ButtonName)
	assert(CustomButton, 'Custom button "' .. ButtonName .. '" could not be found.')

	local CustomButtons = States.CustomButtons:get()
	table.remove(CustomButtons, table.find(CustomButtons, CustomButton))
	States.CustomButtons:set(CustomButtons)

	if CustomButton.GamepadKeybind then
		ContextActionService:UnbindAction(`NeoHotbar_{ButtonName}`)
	end
end

--[=[
	Returns the specified custom button if found.

	@param ButtonName -- The name of the button to be searched for.
]=]
function NeoHotbar:FindCustomButton(ButtonName: string)
	if typeof(ButtonName) ~= "string" then return end

	return States:FindCustomButton(ButtonName)
end

--[=[
	@private

	Builds NeoHotbar's UI. Only intended for internal use.
]=]
function NeoHotbar:_CreateGui()
	self._HotbarGui = HotbarGui({
		Parent = Players.LocalPlayer.PlayerGui,
	})
end

return NeoHotbar