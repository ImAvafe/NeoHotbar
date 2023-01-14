local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate

local Components = NeoHotbar.UI.Components
local DehydratedComps = require(NeoHotbar.UI.DehydratedComps)

local ButtonImage = require(Components.ButtonImage)

return function(Props)
	return Hydrate(DehydratedComps:Get().CustomButton:Clone()) {
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = Props.Callback,

		[Children] = {
			ButtonImage {
				Image = Props.Icon
			}
		}
	}
end