local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local FusionUtils = require(NeoHotbar.Parent.FusionUtils)
local States = require(NeoHotbar.States)
local EnsureProp = require(NeoHotbar.ExtPackages.EnsureProp)

local Hydrate = Fusion.Hydrate
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Computed = Fusion.Computed
local Child = FusionUtils.Child

return function(Props: table)
	Props.Action = EnsureProp(Props.Action, "table", {})

	local Hovering = Value(false)

	local ContextActionButton = Hydrate(States.InstanceSet:get()[script.Name]:Clone()) {
		[OnEvent "Activated"] = function()
			States.ContextMenu.Active:set(false)

			if Props.Action:get() and Props.Action:get().Function then
				Props.Action:get():Function()
			end
		end,
		[OnEvent "MouseEnter"] = function()
			Hovering:set(true)
		end,
		[OnEvent "MouseLeave"] = function()
			Hovering:set(false)
		end,

		[Child "Text"] = {
			Text = Computed(function()
				local Name
				if Props.Action:get() then
					Name = Props.Action:get().Name
				end
				return Name or "Action"
			end),
		},
	}

	if States.DefaultEffectsEnabled:get() then
		Hydrate(ContextActionButton) {
			BackgroundTransparency = Computed(function()
				return (Hovering:get() and 0.925) or 1
			end),

			[Child "Text"] = {
				FontFace = Font.fromName("GothamSsm")
			}
		}
	end

	return ContextActionButton
end
