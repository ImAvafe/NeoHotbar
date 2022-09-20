local NeoHotbar = script.Parent.Parent
local Deps = require(NeoHotbar.Dependencies)
local Components = script.Parent

local Fusion = require(Deps.fusion)

local New = Fusion.New
local Children = Fusion.Children
local State = Fusion.State
local Computed = Fusion.Computed

local Tool = require(Components.Tool)

return function(Props)
	local HotbarTools = Computed(function()
		local Return = {}
		table.insert(Return, Tool {
			ToolNumber = 1
		})
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