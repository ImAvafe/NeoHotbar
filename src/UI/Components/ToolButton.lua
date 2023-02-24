local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)
local Utils = require(NeoHotbar.Utils)
local States = require(NeoHotbar.UI.States)

local Children = Fusion.Children
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate
local WithChild = Fusion.WithChild
local Value = Fusion.Value

local Components = NeoHotbar.UI.Components

local ButtonText = require(Components.ButtonText)
local ButtonImage = require(Components.ButtonImage)
local ContextMenu = require(Components.ContextMenu)

local ToolButtonInstance = States.InstanceSet:get().ToolButton

return function(Props)
	local Holding = Value(false)

	local ToolButton -- ewwwww
	ToolButton = Hydrate(ToolButtonInstance:Clone()) {
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = function()
			if not States.ManagementModeEnabled:get() then
				Utils:ToggleToolEquipped(Props.Tool)
			else
				Utils:SetContextMenuToSlot(ToolButton, Props.Tool)
			end
		end,
		[OnEvent "MouseButton2Click"] = function()
			Utils:SetContextMenuToSlot(ToolButton, Props.Tool)
		end,
		[OnEvent "MouseButton1Down"] = function()
			if not States.ManagementModeEnabled:get() then
				task.spawn(function()
					Holding:set(true)
					task.wait(0.2)
					if Holding:get() == true then
						States.ManagementModeEnabled:set(true)
						Utils:SetContextMenuToSlot(ToolButton, Props.Tool)
						States.ToolTipVisible:set(false)
					end
				end)
			end
		end,
		[OnEvent "MouseButton1Up"] = function()
			Holding:set(false)
		end,

		[WithChild "ToolNumber"] = {
			Text = Props.ToolNumber,
			Font = (States.DefaultEffectsEnabled:get() and Enum.Font.Gotham) or nil,
		},

		[Children] = {
			Computed(function()
				if Props.Tool.TextureId ~= "" then
					return ButtonImage {
						Image = Props.Tool.TextureId,
					}
				else
					return ButtonText {
						Text = Props.Tool.Name,
					}
				end
			end),
			Computed(function()
				local ContextMenuValue = States.ContextMenu:get()
				if not ContextMenuValue then return {} end
				if ContextMenuValue.GuiObject == ToolButton then
					return ContextMenu {}
				end
			end),
		}
	}

	if States.DefaultEffectsEnabled:get() then
		Hydrate(ToolButton) {
			[WithChild "UIStroke"] = {
				Enabled = Props.Equipped
			},
		}
	end

	ToolButton:SetAttribute("Equipped", Props.Equipped)

	return ToolButton
end