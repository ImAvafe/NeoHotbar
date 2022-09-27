local NeoHotbar = script.Parent.Parent
local Components = NeoHotbar.Components

local Deps = require(NeoHotbar.Dependencies)
local Utils = require(NeoHotbar.Utils)
local Theme = require(NeoHotbar.ThemeProvider).Theme

local Fusion = require(Deps.fusion)

local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent

local ButtonText = require(Components.ButtonText)
local ButtonImage = require(Components.ButtonImage)

return function(Props)
	local ToolPreview = Computed(function()
		if Props.Tool.TextureId ~= "" then
			return ButtonImage {
				Image = Props.Tool.TextureId,
			}
		else
			return ButtonText {
				Text = Props.Tool.Name,
			}
		end
	end)
	
	return New "TextButton" {
		Name = "Tool",
		BackgroundColor3 = Theme.ToolButton.BackgroundColor3,
		BackgroundTransparency = Theme.ToolButton.BackgroundTransparency,
		Size = UDim2.fromOffset(60, 60),
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = function()
			Utils:ToggleToolEquipped(Props.Tool)
		end,
		
		[Children] = {
			New "UICorner" {
				Name = "UICorner",
				CornerRadius = Theme.ToolButton.CornerRadius,
			},
			New "UIStroke" {
				Name = "UIStroke",
				Enabled = Props.Equipped,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.ToolButton.StrokeColor,
				Thickness = Theme.ToolButton.StrokeThickness,
			},

			New "TextLabel" {
				Name = "ToolNumber",
				Text = Props.ToolNumber,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(17, 20),
				TextColor3 = Theme.ToolNumber.TextColor3,
				TextSize = Theme.ToolNumber.TextSize,
				FontFace = Theme.ToolNumber.FontFace,
			},

			ToolPreview
		}
	}
end