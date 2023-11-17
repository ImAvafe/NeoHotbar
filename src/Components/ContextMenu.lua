local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local FusionUtils = require(NeoHotbar.Parent.FusionUtils)
local States = require(NeoHotbar.States)

local Hydrate = Fusion.Hydrate
local Child = FusionUtils.Child
local Children = Fusion.Children
local ForValues = Fusion.ForValues

local Components = NeoHotbar.Components
local ContextActionButton = require(Components.ContextActionButton)

return function()
	return Hydrate(States.InstanceSet:get()[script.Name]:Clone()) {
		Visible = States.ContextMenu.Active,

		[Child "Actions"] = {
			[Children] = {
				ForValues(States.ContextMenu.Actions, function(Action)
					return ContextActionButton({
						Action = Action,
					})
				end, Fusion.cleanup),
			},
		},
	}
end
