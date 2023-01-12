local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate

local Components = NeoHotbar.UI.Components
local Dehydrated = NeoHotbar.UI.Dehydrated

local ButtonImage = require(Components.ButtonImage)

return function(Props)
	return Hydrate(Dehydrated.CustomButton:Clone()) {
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = Props.Callback,

		[Children] = {
			ButtonImage {
				Image = Props.Icon
			}
		}
	}

	-- return New "TextButton" {
	-- 	Name = "CustomButton",
	-- 	BackgroundColor3 = Theme.CustomButton.BackgroundColor3,
	-- 	BackgroundTransparency = Theme.CustomButton.BackgroundTransparency,
	-- 	Size = UDim2.fromOffset(60, 60),
	-- 	Text = "",
	-- 	LayoutOrder = Props.LayoutOrder,

	-- 	[OnEvent "Activated"] = Props.Callback,
		
	-- 	[Children] = {
	-- 		New "UICorner" {
	-- 			Name = "UICorner",
	-- 			CornerRadius = Theme.CustomButton.CornerRadius,
	-- 		},
	-- 		New "UIStroke" {
	-- 			Name = "UIStroke",
	-- 			Enabled = true,
	-- 			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	-- 			Color = Theme.CustomButton.StrokeColor,
	-- 			Thickness = Theme.CustomButton.StrokeThickness,
	-- 		},

    --         ButtonImage {
    --             Image = Props.Icon,
    --         }
	-- 	}
	-- }
end