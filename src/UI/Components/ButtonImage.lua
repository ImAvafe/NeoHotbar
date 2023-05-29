local NeoHotbar = script.Parent.Parent.Parent

local Fusion = require(NeoHotbar.ExtPackages.Fusion)
local States = require(NeoHotbar.UI.States)

local Hydrate = Fusion.Hydrate
local WithChild = Fusion.WithChild

return function(Props)
	return Hydrate(States.InstanceSet:get().ButtonImage:Clone()) {
		[WithChild "Image"] = {
			Image = Props.Image
		}
	}
end