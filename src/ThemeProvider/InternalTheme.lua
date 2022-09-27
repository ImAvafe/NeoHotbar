local Fonts = {
	GothamSsm = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Regular,
			Enum.FontStyle.Normal
	),
}

local Theme = {}

function Theme:Init()
	self.ToolButton = {
		BackgroundColor3 = Color3.fromRGB(31, 31, 31),
		BackgroundTransparency = 0.3,
		CornerRadius = UDim.new(0.1, 0),
		StrokeColor = Color3.fromRGB(214, 214, 214),
		StrokeThickness = 1.85,
	}
	self.ButtonText = {
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		FontFace = Fonts.GothamSsm,
	}
	self.ToolNumber = {
		TextColor3 = Color3.fromRGB(170, 170, 170),
		FontFace = Fonts.GothamSsm,
		TextSize = 13,
	}
	self.CustomButton = {
		BackgroundColor3 = Color3.fromRGB(31, 31, 31),
		BackgroundTransparency = 0.3,
		CornerRadius = UDim.new(0.15, 0),
		StrokeColor = Color3.fromRGB(180, 180, 180),
		StrokeThickness = 1.85,
	}
	self.ToolTip = {
		BackgroundColor3 = self.ToolButton.BackgroundColor3,
		BackgroundTransparency = 1,
		FontFace = Fonts.GothamSsm,
		TextSize = 13,
	}
end

Theme:Init()

return Theme