local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local FusionUtils = require(NeoHotbar.Parent.FusionUtils)
local States = require(NeoHotbar.States)

local Hydrate = Fusion.Hydrate
local Child = FusionUtils.Child
local Computed = Fusion.Computed
local Spring = Fusion.Spring

return function()
	local ToolTip = Hydrate(States.InstanceSet:get().ToolTip:Clone())({
		[Child "Text"] = {
			Text = States.ToolTip.Text,
		},
	})

	if States.DefaultEffectsEnabled:get() then
		Hydrate(ToolTip)({
			GroupTransparency = Spring(Computed(function()
				local Visible = States.ToolTip.Enabled:get() and States.ToolTip.Visible:get()
				return (Visible and 0) or 1
			end), 25, 1),

			[Child "Text"] = {
				Font = Enum.Font.Gotham,
			},
		})
	end

	return ToolTip
end
