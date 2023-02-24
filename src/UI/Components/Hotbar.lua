local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)
local States = require(NeoHotbar.UI.States)

local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate
local WithChild = Fusion.WithChild

local Components = NeoHotbar.UI.Components

local ToolButton = require(Components.ToolButton)
local CustomButton = require(Components.CustomButton)
local ToolTip = require(Components.ToolTip)
local ContextMenu = require(Components.ContextMenu)

return function(Props)
	

	local HotbarTools = Computed(function()
		local ToolSlots = States.ToolSlots:get()
		local Return = {}
		for ToolNumber, ToolSlot in ipairs(ToolSlots) do
			table.insert(Return, ToolButton {
				Slot = ToolSlot,
				Tool = ToolSlot.Tool,
				ToolNumber = ToolNumber,
				Equipped = ToolSlot.Equipped,
				LayoutOrder = ToolNumber,
			})
		end
		return Return
	end)
	local HotbarCustomButtons = Computed(function()
		local CustomButtons = States.CustomButtons:get()
		local Return = {}
		for CustomButtonNumber, CustomButtonData in ipairs(CustomButtons) do
			table.insert(Return, CustomButton {
				Icon = CustomButtonData.Icon,
				Callback = CustomButtonData.Callback,
				LayoutOrder = CustomButtonNumber,
			})
		end
		return Return
	end)
	
	local Hotbar = Hydrate(States.InstanceSet:get().Hotbar:Clone()) {
		Name = "NeoHotbar",
		Parent = Props.Parent,

		[WithChild "Hotbar"] = {
			[WithChild "Buttons"] = {
				[WithChild "CustomButtons"] = {
					[Children] = HotbarCustomButtons,
				},
				[WithChild "ToolSlots"] = {
					[Children] = HotbarTools,
				},
			},
			[Children] = {
				ToolTip {},
			},
		},
		[Children] = {
			ContextMenu {},
		},
	}

	if States.DefaultEffectsEnabled:get() then
		local Padding = Computed(function()
			local ManagementModeEnabled = States.ManagementModeEnabled:get()
			return UDim.new(0, (ManagementModeEnabled and 5) or 0)
		end)

		Hydrate(Hotbar) {
			[WithChild "Hotbar"] = {
				[WithChild "Buttons"] = {
					[WithChild "ToolSlots"] = {
						BackgroundTransparency = Computed(function()
							local ManagementModeEnabled = States.ManagementModeEnabled:get()
							return (ManagementModeEnabled and 0.75) or 1
						end),

						[WithChild "UIPadding"] = {
							PaddingTop = Padding,
							PaddingBottom = Padding,
							PaddingRight = Padding,
							PaddingLeft = Padding,
						},
						[WithChild "UIStroke"] = {
							Enabled = States.ManagementModeEnabled,
						},
					},
					[WithChild "CustomButtons"] = {
						Visible = Computed(function()
							local ManagementModeEnabled = States.ManagementModeEnabled:get()
							return not ManagementModeEnabled
						end)
					},
					[WithChild "UIListLayout"] = {
						Padding = Computed(function()
							local ToolSlots = States.ToolSlots:get()
							local CustomButtons = States.CustomButtons:get()
							local OffsetPadding = ((#ToolSlots >= 1 and #CustomButtons >= 1) and 10) or 0
							return UDim.new(0, OffsetPadding)
						end)
					},
				},
			}
		}
	end

	return Hotbar
end