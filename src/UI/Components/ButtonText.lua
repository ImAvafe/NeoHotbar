local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)

local Hydrate = Fusion.Hydrate

local DehydratedComps = require(NeoHotbar.UI.DehydratedComps)

return function(Props)
	return Hydrate(DehydratedComps:Get().ButtonText:Clone()) {
		Text = Props.Text or "Text",
		Font = Enum.Font.Gotham,
	}
end