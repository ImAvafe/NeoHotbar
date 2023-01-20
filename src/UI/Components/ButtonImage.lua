local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)

local Hydrate = Fusion.Hydrate
local WithChild = Fusion.WithChild

local Instances = require(NeoHotbar.UI.Instances)

return function(Props)
	return Hydrate(Instances:Get().ButtonImage:Clone()) {
		[WithChild "Image"] = {
			Image = Props.Image
		}
	}
end