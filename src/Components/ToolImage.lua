local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)

local New = Fusion.New
local Children = Fusion.Children

return function(Props)
	return New "ImageLabel" {
		Name = "ToolImage",
		Image = Props.Tool.TextureId,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			New "UIPadding" {
				PaddingBottom = UDim.new(0.1, 0),
				PaddingLeft = UDim.new(0.1, 0),
				PaddingRight = UDim.new(0.1, 0),
				PaddingTop = UDim.new(0.1, 0),
			}
		}
	}
end