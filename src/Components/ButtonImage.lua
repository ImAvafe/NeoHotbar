local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)

local New = Fusion.New
local Children = Fusion.Children

return function(Props)
	return New "Frame" {
		Name = "ImageContainer",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		[Children] = {
			New "UIPadding" {
				PaddingBottom = UDim.new(0.14, 0),
				PaddingLeft = UDim.new(0.14, 0),
				PaddingRight = UDim.new(0.14, 0),
				PaddingTop = UDim.new(0.14, 0),
			},

			New "ImageLabel" {
				Name = "ButtonImage",
				Image = Props.Image,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
			}
		}
	}
end