local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)

local Hydrate = Fusion.Hydrate
local WithChild = Fusion.WithChild

local Dehydrated = NeoHotbar.UI.Dehydrated

return function(Props)
	return Hydrate(Dehydrated.ButtonImage:Clone()) {
		[WithChild "Image"] = {
			Image = Props.Image
		}
	}

	-- return New "Frame" {
	-- 	Name = "ImageContainer",
	-- 	Size = UDim2.fromScale(1, 1),
	-- 	BackgroundTransparency = 1,

	-- 	[Children] = {
	-- 		New "UIPadding" {
	-- 			PaddingBottom = UDim.new(0.14, 0),
	-- 			PaddingLeft = UDim.new(0.14, 0),
	-- 			PaddingRight = UDim.new(0.14, 0),
	-- 			PaddingTop = UDim.new(0.14, 0),
	-- 		},

	-- 		New "ImageLabel" {
	-- 			Name = "ButtonImage",
	-- 			Image = Props.Image,
	-- 			BackgroundTransparency = 1,
	-- 			Size = UDim2.fromScale(1, 1),
	-- 		}
	-- 	}
	-- }
end