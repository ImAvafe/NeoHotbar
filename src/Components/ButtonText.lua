local NeoHotbar = script.Parent.Parent

local Deps = require(NeoHotbar.Dependencies)
local Theme = require(NeoHotbar.ThemeProvider).Theme

local Fusion = require(Deps.Fusion)

local New = Fusion.New
local Children = Fusion.Children

return function(Props)
	return New "TextLabel" {
		Name = "ButtonText",
		Text = Props.Text or "Text",
		TextColor3 = Theme.ButtonText.TextColor3,
		TextSize = Theme.ButtonText.TextSize,
		FontFace = Theme.ButtonText.FontFace,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
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