local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local States = require(NeoHotbar.States)
local EnsureProp = require(NeoHotbar.ExtPackages.EnsureProp)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate

local Components = NeoHotbar.Components

local ButtonImage = require(Components.ButtonImage)
local ButtonHint = require(Components.ButtonHint)

return function(Props: table)
	Props.LayoutOrder = EnsureProp(Props.LayoutOrder, "number", 0)
	Props.Callback = EnsureProp(Props.Callback, "function", function()end)
	Props.Icon = EnsureProp(Props.Icon, "string", "")
	Props.GamepadKeybind = EnsureProp(Props.GamepadKeybind, "EnumItem", nil)
	
	return Hydrate(States.InstanceSet:get()[script.Name]:Clone()) {
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = function()
			if Props.Callback:get() then
				Props.Callback:get()()
			end
		end,

		[Children] = {
			ButtonImage {
				Image = Props.Icon
			},
			ButtonHint {
				Keycode = Props.GamepadKeybind
			}
		}
	}
end