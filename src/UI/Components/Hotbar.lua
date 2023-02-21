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

return function(Props)
	local HotbarTools = Computed(function()
		local ToolSlots = States.ToolSlots:get()
		local Return = {}
		for ToolNumber, ToolSlot in ipairs(ToolSlots) do
			table.insert(Return, ToolButton {
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
	
	return Hydrate(States.InstanceSet:get().Hotbar:Clone()) {
		Name = "NeoHotbar",
		Parent = Props.Parent,

		[WithChild "Hotbar"] = {
			[WithChild "CustomButtons"] = {
				[Children] = HotbarCustomButtons,
			},
			[WithChild "ToolSlots"] = {
				[Children] = HotbarTools,
			},
		}
	}
end