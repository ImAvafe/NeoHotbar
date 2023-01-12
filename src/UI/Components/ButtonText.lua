local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)

local Hydrate = Fusion.Hydrate

local Dehydrated = NeoHotbar.UI.Dehydrated

return function(Props)
	return Hydrate(Dehydrated.ButtonText:Clone()) {
		Text = Props.Text or "Text"
	}

	-- return New "TextLabel" {
	-- 	Name = "ButtonText",
	-- 	Text = Props.Text or "Text",
	-- 	TextColor3 = Theme.ButtonText.TextColor3,
	-- 	TextSize = Theme.ButtonText.TextSize,
	-- 	FontFace = Theme.ButtonText.FontFace,
	-- 	BackgroundTransparency = 1,
	-- 	Size = UDim2.fromScale(1, 1),
	-- 	TextWrapped = true,
	
	-- 	[Children] = {
	-- 		New "UIPadding" {
	-- 			Name = "UIPadding",
	-- 			PaddingBottom = UDim.new(0, 5),
	-- 			PaddingLeft = UDim.new(0, 5),
	-- 			PaddingRight = UDim.new(0, 5),
	-- 			PaddingTop = UDim.new(0, 5),
	-- 		},
	-- 	}
	-- }
end