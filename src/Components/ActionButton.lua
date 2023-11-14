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

	return Hydrate(States.InstanceSet:get().ActionButton:Clone())({
		BackgroundTransparency = Computed(function()
			return (Hovering:get() and 0.95) or 1
		end),

		[Child("Text")] = {
			Text = Computed(function()
				local Name
				if Props.Action:get() then
					Name = Props.Action:get().Name
				end
				return Name or "Action"
			end),
		},

		[OnEvent("Activated")] = function()
			States.ContextMenu:set()

			if Props.Action:get() and Props.Action:get().Function then
				Props.Action:get():Function()
			end
		end,
		[OnEvent("MouseEnter")] = function()
			Hovering:set(true)
		end,
		[OnEvent("MouseLeave")] = function()
			Hovering:set(false)
		end,
	})
end
