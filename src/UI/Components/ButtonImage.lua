local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)

local Hydrate = Fusion.Hydrate
local WithChild = Fusion.WithChild

local DehydratedComps = require(NeoHotbar.UI.DehydratedComps)

return function(Props)
	return Hydrate(DehydratedComps:Get().ButtonImage:Clone()) {
		[WithChild "Image"] = {
			Image = Props.Image
		}
	}
end