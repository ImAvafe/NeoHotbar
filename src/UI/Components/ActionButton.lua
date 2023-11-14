local NeoHotbar = script.Parent.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local FusionUtils = require(NeoHotbar.Parent.FusionUtils)
local States = require(NeoHotbar.UI.States)

local Hydrate = Fusion.Hydrate
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Computed = Fusion.Computed
local Child = FusionUtils.Child

return function(Props)
	local Hovering = Value(false)

	return Hydrate(States.InstanceSet:get().ActionButton:Clone())({
		BackgroundTransparency = Computed(function()
			return (Hovering:get() and 0.95) or 1
		end),

		[Child("Text")] = {
			Text = Props.Action.Name,
		},

		[OnEvent("Activated")] = function()
			States.ContextMenu:set()
			Props.Action:Function()
		end,
		[OnEvent("MouseEnter")] = function()
			Hovering:set(true)
		end,
		[OnEvent("MouseLeave")] = function()
			Hovering:set(false)
		end,
	})
end
