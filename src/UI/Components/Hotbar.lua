local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)
local States = require(NeoHotbar.UI.States)

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children

local Components = NeoHotbar.UI.Components

local ToolButton = require(Components.ToolButton)
local CustomButton = require(Components.CustomButton)

return function(Props)
	local HotbarTools = Computed(function()
		local Return = {}
		local ToolSlots = States.ToolSlots:get()
		local CustomButtons = States.CustomButtons:get()
		for ToolNum, ToolSlot in ipairs(ToolSlots) do
			table.insert(Return, ToolButton {
				Tool = ToolSlot.Tool,
				ToolNumber = ToolNum,
				Equipped = ToolSlot.Equipped,
				LayoutOrder = #CustomButtons + ToolNum,
			})
		end
		return Return
	end)
	local HotbarCustomButtons = Computed(function()
		local Return = {}
		local CustomButtons = States.CustomButtons:get()
		for ButtonNumber, CustomButtonData in ipairs(CustomButtons) do
			table.insert(Return, CustomButton {
				Icon = CustomButtonData.Icon,
				Callback = CustomButtonData.Callback,
				LayoutOrder = ButtonNumber,
			})
		end
		return Return
	end)

	return New "ScreenGui" {
		Name = "NeoHotbar",
		Parent = Props.Parent,

		[Children] = {
			New "Frame" {
				Name = "Hotbar",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(UDim.new(0.5, 0), UDim.new(1, -70)),
				Size = UDim2.fromOffset(655, 70),
				BackgroundTransparency = 1,

				[Children] = {
					New "UIListLayout" {
						Padding = UDim.new(0, 7),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					},

					HotbarTools,
					HotbarCustomButtons,
				}
			}
		}
	}
end