local NeoHotbar = script.Parent.Parent
local Components = NeoHotbar.Components

local Deps = require(NeoHotbar.Dependencies)
local Theme = require(NeoHotbar.ThemeProvider).Theme

local Fusion = require(Deps.fusion)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local ButtonImage = require(Components.ButtonImage)

return function(Props)
	return New "TextButton" {
		Name = "CustomButton",
		BackgroundColor3 = Theme.CustomButton.BackgroundColor3,
		BackgroundTransparency = Theme.CustomButton.BackgroundTransparency,
		Size = UDim2.fromOffset(60, 60),
		Text = "",
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = Props.Callback,
		
		[Children] = {
			New "UICorner" {
				Name = "UICorner",
				CornerRadius = Theme.CustomButton.CornerRadius,
			},
			New "UIStroke" {
				Name = "UIStroke",
				Enabled = true,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.CustomButton.StrokeColor,
				Thickness = Theme.CustomButton.StrokeThickness,
			},

            ButtonImage {
                Image = Props.Icon,
            }
		}
	}
end