local NeoHotbar = script.Parent.Parent.Parent

local Fusion = require(NeoHotbar.ExtPackages.Fusion)
local States = require(NeoHotbar.UI.States)

local Hydrate = Fusion.Hydrate
local WithChild = Fusion.WithChild
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Computed = Fusion.Computed

return function(Props)
	local Hovering = Value(false)

	return Hydrate(States.InstanceSet:get().ActionButton:Clone())({
		BackgroundTransparency = Computed(function()
			return (Hovering:get() and 0.95) or 1
		end),

		[WithChild("Text")] = {
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
