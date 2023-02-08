local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)
local Utils = require(NeoHotbar.Utils)
local States = require(NeoHotbar.UI.States)

local Children = Fusion.Children
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate
local WithChild = Fusion.WithChild

local Components = NeoHotbar.UI.Components

local ButtonText = require(Components.ButtonText)
local ButtonImage = require(Components.ButtonImage)

return function(Props)
	local ToolButton = Hydrate(States.InstanceSet:get().ToolButton:Clone()) {
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = function()
			Utils:ToggleToolEquipped(Props.Tool)
		end,

		[WithChild "ToolNumber"] = {
			Text = Props.ToolNumber,
			Font = (States.DefaultEffectsEnabled:get() and Enum.Font.Gotham) or nil,
		},

		[Children] = {
			Computed(function()
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
		}
	}

	if States.DefaultEffectsEnabled:get() then
		Hydrate(ToolButton) {
			[WithChild "UIStroke"] = {
				Enabled = Props.Equipped
			}
		}
	end

	ToolButton:SetAttribute("Equipped", Props.Equipped)

	return ToolButton
end