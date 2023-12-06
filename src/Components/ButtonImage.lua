local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local FusionUtils = require(NeoHotbar.Parent.FusionUtils)
local States = require(NeoHotbar.States)
local EnsureProp = require(NeoHotbar.ExtPackages.EnsureProp)

local Hydrate = Fusion.Hydrate
local Child = FusionUtils.Child

return function(Props: table)
	Props.Image = EnsureProp(Props.Image, "string", "")

	return Hydrate(States.InstanceSet:get()[script.Name]:Clone()) {
		[Child "Image"] = {
			Image = Props.Image
		}
	}
end