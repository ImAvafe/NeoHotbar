local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)
local Utils = require(NeoHotbar.Utils)

local Children = Fusion.Children
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate
local WithChild = Fusion.WithChild

local Components = NeoHotbar.UI.Components
local Instances = require(NeoHotbar.UI.Instances)

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
	
	return Hydrate(Instances:Get().ToolButton:Clone()) {
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = function()
			Utils:ToggleToolEquipped(Props.Tool)
		end,

		[WithChild "UIStroke"] = {
			Enabled = Props.Equipped
		},
		[WithChild "ToolNumber"] = {
			Text = Props.ToolNumber,
			Font = Enum.Font.Gotham,
		},

		[Children] = {
			ToolPreview
		}
	}
end