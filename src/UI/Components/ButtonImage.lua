local NeoHotbar = script.Parent.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local FusionUtils = require(NeoHotbar.Parent.FusionUtils)
local States = require(NeoHotbar.UI.States)

local Hydrate = Fusion.Hydrate
local Child = FusionUtils.Child

return function(Props)
	return Hydrate(States.InstanceSet:get().ButtonImage:Clone()) {
		[Child "Image"] = {
			Image = Props.Image
		}
	}
end