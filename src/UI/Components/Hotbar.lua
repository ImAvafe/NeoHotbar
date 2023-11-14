local NeoHotbar = script.Parent.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local FusionUtils = require(NeoHotbar.Parent.FusionUtils)
local States = require(NeoHotbar.UI.States)

local Computed = Fusion.Computed
local Children = Fusion.Children
local Hydrate = Fusion.Hydrate
local Child = FusionUtils.Child
local ForPairs = Fusion.ForPairs

local Components = NeoHotbar.UI.Components

local ToolButton = require(Components.ToolButton)
local CustomButton = require(Components.CustomButton)
local ToolTip = require(Components.ToolTip)

return function(Props)
	local Hotbar = Hydrate(States.InstanceSet:get().Hotbar:Clone()) {
		Name = "NeoHotbar",
		Parent = Props.Parent,

		[Child "Hotbar"] = {
			[Child "Buttons"] = {
				[Child "CustomButtons"] = {
					[Children] = ForPairs(States.CustomButtons, function(ButtonNum, ButtonEntry)
						return ButtonNum, CustomButton {
							Icon = ButtonEntry.Icon,
							Callback = ButtonEntry.Callback,
							LayoutOrder = ButtonEntry,
						}
					end, Fusion.cleanup),
				},
				[Child "ToolSlots"] = {
					[Children] = ForPairs(States.ToolSlots, function(ToolNum, ToolSlot)
						return ToolNum, ToolButton {
							Slot = ToolSlot,
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
			local ManagementModeEnabled = States.ManagementModeEnabled:get()
			return UDim.new(0, (ManagementModeEnabled and 5) or 0)
		end)

		Hydrate(Hotbar) {
			[Child "Hotbar"] = {
				[Child "Buttons"] = {
					[Child "ToolSlots"] = {
						BackgroundTransparency = Computed(function()
							local ManagementModeEnabled = States.ManagementModeEnabled:get()
							return (ManagementModeEnabled and 0.75) or 1
						end),

						[Child "UIPadding"] = {
							PaddingTop = Padding,
							PaddingBottom = Padding,
							PaddingRight = Padding,
							PaddingLeft = Padding,
						},
						[Child "UIStroke"] = {
							Enabled = States.ManagementModeEnabled,
						},
					},
					[Child "CustomButtons"] = {
						Visible = Computed(function()
							local ManagementModeEnabled = States.ManagementModeEnabled:get()
							return not ManagementModeEnabled
						end)
					},
					[Child "UIListLayout"] = {
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