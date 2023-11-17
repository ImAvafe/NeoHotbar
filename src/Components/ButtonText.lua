local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local States = require(NeoHotbar.States)
local EnsureProp = require(NeoHotbar.ExtPackages.EnsureProp)

local Hydrate = Fusion.Hydrate

return function(Props: table)
	Props.Text = EnsureProp(Props.Text, "string", "Text")

	local ButtonText = Hydrate(States.InstanceSet:get()[script.Name]:Clone()) {
		Text = Props.Text,
	}

	if States.DefaultEffectsEnabled:get() then
		Hydrate(ButtonText)({
			FontFace = Font.fromName("GothamSsm")
		})
	end

	return ButtonText
end