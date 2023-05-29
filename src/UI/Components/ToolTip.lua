local NeoHotbar = script.Parent.Parent.Parent

local Fusion = require(NeoHotbar.ExtPackages.Fusion)
local States = require(NeoHotbar.UI.States)

local Hydrate = Fusion.Hydrate
local WithChild = Fusion.WithChild
local Computed = Fusion.Computed
local Spring = Fusion.Spring

return function()
	local GroupTransparency = Computed(function()
		local ToolTipVisible = States.ToolTipVisible:get()
		return (ToolTipVisible and 0) or 1
	end)

	local ToolTip = Hydrate(States.InstanceSet:get().ToolTip:Clone())({
		GroupTransparency = Spring(GroupTransparency, 25, 1),

		[WithChild("Text")] = {
			Text = States.ToolTipText,
		},
	})

	if States.DefaultEffectsEnabled:get() then
		Hydrate(ToolTip)({
			[WithChild("Text")] = {
				Font = Enum.Font.Gotham,
			},
		})
	end

	return ToolTip
end
