local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.fusion)

local New = Fusion.New
local Children = Fusion.Children

return function(Props)
	return New "TextLabel" {
		Name = "ToolName",
		Text = Props.Tool.Name or "Tool",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		TextSize = 14,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextWrapped = true,
	
		[Children] = {
			New "UIPadding" {
				Name = "UIPadding",
				PaddingBottom = UDim.new(0, 5),
				PaddingLeft = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 5),
				PaddingTop = UDim.new(0, 5),
			},
		}
	}
end