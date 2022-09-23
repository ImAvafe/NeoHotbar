local NeoHotbar = script.Parent.Parent
local Deps = require(NeoHotbar.Dependencies)
local Components = script.Parent

local Fusion = require(Deps.fusion)

local States = require(NeoHotbar.States)

local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed

local ToolButton = require(Components.ToolButton)

return function(Props)
	local HotbarTools = Computed(function()
		local Return = {}
		local ToolSlots = States.ToolSlots:get()
		for ToolNum, ToolSlot in ipairs(ToolSlots) do
			table.insert(Return, ToolButton {
				Tool = ToolSlot.Tool,
				ToolNumber = ToolNum,
				Equipped = ToolSlot.Equipped,
			})
		end
		return Return
	end)

	return New "ScreenGui" {
		Name = "NeoHotbar",
		Parent = Props.Parent,
	
		[Children] = {
			New "Frame" {
				Name = "Frame",
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, -327, 1, -70),
				Size = UDim2.fromOffset(655, 70),
	
				[Children] = {
					New "UIListLayout" {
						Name = "UIListLayout",
						Padding = UDim.new(0, 7),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
					},

					HotbarTools
				}
			},
		}
	}
end