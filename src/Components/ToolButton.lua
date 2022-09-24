local NeoHotbar = script.Parent.Parent
local Components = NeoHotbar.Components

local Deps = require(NeoHotbar.Dependencies)
local Utils = require(NeoHotbar.Utils)

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
		BackgroundColor3 = Color3.fromRGB(31, 31, 31),
		BackgroundTransparency = 0.3,
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
				CornerRadius = UDim.new(0.1, 0),
			},
			New "UIStroke" {
				Name = "UIStroke",
				Enabled = Props.Equipped,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(214, 214, 214),
				Thickness = 1.85,
			},

			New "TextLabel" {
				Name = "ToolNumber",
				Text = Props.ToolNumber,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(17, 20),
				TextColor3 = Color3.fromRGB(170, 170, 170),
				TextSize = 13,
				FontFace = Font.new(
						"rbxasset://fonts/families/GothamSSm.json",
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
				),
			},

			ToolPreview
		}
	}
end