local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)

local Hydrate = Fusion.Hydrate

local Instances = require(NeoHotbar.UI.Instances)

return function(Props)
	return Hydrate(Instances:Get().ButtonText:Clone()) {
		Text = Props.Text or "Text",
		Font = Enum.Font.Gotham,
	}
end