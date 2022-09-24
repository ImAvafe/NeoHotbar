local NeoHotbar = script.Parent.Parent
local Components = NeoHotbar.Components

local Deps = require(NeoHotbar.Dependencies)
local Utils = require(NeoHotbar.Utils)

local Fusion = require(Deps.fusion)

local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent

local ToolName = require(Components.ToolName)
local ToolImage = require(Components.ToolImage)

return function(Props)
	local ToolPreview = Computed(function()
		if Props.Tool.TextureId ~= "" then
			return ToolImage {
				Tool = Props.Tool
			}
		else
			return ToolName {
				Tool = Props.Tool
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
		LayoutOrder = Props.ToolNumber,

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