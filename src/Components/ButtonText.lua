local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local States = require(NeoHotbar.States)
local EnsureProp = require(NeoHotbar.ExtPackages.EnsureProp)

local Hydrate = Fusion.Hydrate

return function(Props: table)
	Props.Text = EnsureProp(Props.Text, "string", "Text")

	return Hydrate(States.InstanceSet:get().ButtonText:Clone()) {
		Text = Props.Text,
		Font = (States.DefaultEffectsEnabled:get() and Enum.Font.Gotham) or nil,
	}
end