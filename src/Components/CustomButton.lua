local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local States = require(NeoHotbar.States)
local EnsureProp = require(NeoHotbar.EnsureProp)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate

local Components = NeoHotbar.Components

local ButtonImage = require(Components.ButtonImage)

return function(Props: table)
	Props.LayoutOrder = EnsureProp(Props.LayoutOrder, "number", "0")
	Props.Callback = EnsureProp(Props.Callback, "function", function()end)
	Props.Icon = EnsureProp(Props.Icon, "string", "")
	
	return Hydrate(States.InstanceSet:get().CustomButton:Clone()) {
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = Props.Callback,

		[Children] = {
			ButtonImage {
				Image = Props.Icon
			}
		}
	}
end