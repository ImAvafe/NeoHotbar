local NeoHotbar = script.Parent.Parent.Parent

local Fusion = require(NeoHotbar.ExtPackages.Fusion)
local States = require(NeoHotbar.UI.States)


local Hydrate = Fusion.Hydrate

return function(Props)
	return Hydrate(States.InstanceSet:get().ButtonText:Clone()) {
		Text = Props.Text or "Text",
		Font = (States.DefaultEffectsEnabled:get() and Enum.Font.Gotham) or nil,
	}
end