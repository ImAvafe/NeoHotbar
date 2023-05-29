local NeoHotbar = script.Parent.Parent.Parent

local Fusion = require(NeoHotbar.ExtPackages.Fusion)
local States = require(NeoHotbar.UI.States)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate

local Components = NeoHotbar.UI.Components

local ButtonImage = require(Components.ButtonImage)

return function(Props)
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