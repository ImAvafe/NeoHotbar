local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local FusionUtils = require(NeoHotbar.Parent.FusionUtils)
local States = require(NeoHotbar.States)
local EnsureProp = require(NeoHotbar.ExtPackages.EnsureProp)

local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate
local Child = FusionUtils.Child
local ForPairs = Fusion.ForPairs

local Components = NeoHotbar.Components

local ToolButton = require(Components.ToolButton)
local CustomButton = require(Components.CustomButton)
local ToolTip = require(Components.ToolTip)

return function(Props: table)
	Props.Parent = EnsureProp(Props.Parent, "Instance", nil)

	local Hotbar = Hydrate(States.InstanceSet:get()[script.Name]:Clone()) {
		Name = "NeoHotbar",
		Parent = Props.Parent,
		Enabled = States.Enabled,

		[Child "Hotbar"] = {
			[Child "Buttons"] = {
				[Child "CustomButtons"] = {
					Visible = Computed(function()
						return not States.ManagementMode.Active:get()
					end),

					[Children] = ForPairs(States.CustomButtons, function(ButtonNum, ButtonEntry)
						return ButtonNum,
							CustomButton {
								Icon = ButtonEntry.Icon,
								Callback = ButtonEntry.Callback,
								LayoutOrder = ButtonEntry.LayoutOrder,
								GamepadKeybind = ButtonEntry.GamepadKeybind,
							}
					end, Fusion.cleanup),
				},
				[Child "ToolSlots"] = {
					[Children] = ForPairs(States.ToolSlots, function(ToolNum, ToolSlot)
						return ToolNum,
							ToolButton {
								Tool = ToolSlot.Tool,
								Equipped = ToolSlot.Equipped,
								ToolNumber = ToolNum,
								LayoutOrder = ToolNum,
							}
					end, Fusion.cleanup),
				},
			},

			[Children] = {
				ToolTip {},
			},
		},
	}

	if States.DefaultEffectsEnabled:get() then
		local Padding = Computed(function()
			local ManagementModeEnabled = States.ManagementMode.Active:get()
			return UDim.new(0, (ManagementModeEnabled and 4) or 0)
		end)

		Hydrate(Hotbar) {
			[Child "Hotbar"] = {
				[Child "Buttons"] = {
					[Child "ToolSlots"] = {
						BackgroundTransparency = Computed(function()
							return (States.ManagementMode.Active:get() and 0.8) or 1
						end),

						[Child "UIPadding"] = {
							PaddingTop = Padding,
							PaddingBottom = Padding,
							PaddingRight = Padding,
							PaddingLeft = Padding,
						},
						[Child "UIStroke"] = {
							Enabled = States.ManagementMode.Active,
						},
					},
					[Child "UIListLayout"] = {
						Padding = Computed(function()
							local ToolSlots = States.ToolSlots:get()
							local CustomButtons = States.CustomButtons:get()
							local OffsetPadding = ((#ToolSlots >= 1 and #CustomButtons >= 1) and 10) or 0
							return UDim.new(0, OffsetPadding)
						end),
					},
				},
			},
		}
	end

	return Hotbar
end
