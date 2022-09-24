local NeoHotbar = script.Parent.Parent
local Components = NeoHotbar.Components

local Deps = require(NeoHotbar.Dependencies)

local Fusion = require(Deps.fusion)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local ButtonImage = require(Components.ButtonImage)

return function(Props)
	return New "TextButton" {
		Name = "CustomButton",
		BackgroundColor3 = Color3.fromRGB(31, 31, 31),
		BackgroundTransparency = 0.3,
		Size = UDim2.fromOffset(60, 60),
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = Props.Callback,
		
		[Children] = {
			New "UICorner" {
				Name = "UICorner",
				CornerRadius = UDim.new(0.15, 0),
			},
			New "UIStroke" {
				Name = "UIStroke",
				Enabled = true,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(214, 214, 214),
				Thickness = 1.85,
                Transparency = 0.35,
			},

            ButtonImage {
                Image = Props.Icon,
            }
		}
	}
end