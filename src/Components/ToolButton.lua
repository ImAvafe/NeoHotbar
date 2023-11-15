local NeoHotbar = script.Parent.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)
local FusionUtils = require(NeoHotbar.Parent.FusionUtils)
local States = require(NeoHotbar.States)
local EnsureProp = require(NeoHotbar.ExtPackages.EnsureProp)

local Children = Fusion.Children
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate
local Child = FusionUtils.Child
local Value = Fusion.Value

local Components = NeoHotbar.Components

local ButtonText = require(Components.ButtonText)
local ButtonImage = require(Components.ButtonImage)
local ContextMenu = require(Components.ContextMenu)

return function(Props: table)
	Props.LayoutOrder = EnsureProp(Props.LayoutOrder, "number", 1)
	Props.Equipped = EnsureProp(Props.Equipped, "boolean", false)
	Props.Tool = EnsureProp(Props.Tool, "Tool", Instance.new("Tool"))
	Props.ToolNumber = EnsureProp(Props.ToolNumber, "number", 1)

	local Holding = Value(false)

	local ToolButton
	ToolButton = Hydrate(States.InstanceSet:get().ToolButton:Clone())({
		LayoutOrder = Props.LayoutOrder,

		[OnEvent("Activated")] = function()
			if not States.ManagementMode.Active:get() then
				States:ToggleToolEquipped(Props.Tool:get())
			end
		end,
		[OnEvent("MouseButton2Click")] = function()
			States:SetContextMenuToSlot(ToolButton, Props.Tool:get())
		end,
		[OnEvent("MouseButton1Down")] = function()
			Holding:set(true)

			if not States.ManagementMode.Active:get() then
				if States.HotbarHoldProcess then
					task.cancel(States.HotbarHoldProcess)
				end
				States.HotbarHoldProcess = task.delay(0.25, function()
					if Holding:get() == true then
						States.ManagementMode.Active:set(States.ManagementMode.Enabled:get() and true)
						States.ToolTip.Visible:set(false)
					end
				end)
			else
				States:SetContextMenuToSlot(ToolButton, Props.Tool:get())
			end
		end,
		[OnEvent("MouseButton1Up")] = function()
			Holding:set(false)
		end,

		[Child "ToolNumber"] = {
			Text = Props.ToolNumber,
			Font = (States.DefaultEffectsEnabled:get() and Enum.Font.Gotham) or nil,
		},

		[Children] = {
			Computed(function()
				if Props.Tool:get().TextureId ~= "" then
					return ButtonImage {
						Image = Computed(function()
							local Image
							if Props.Tool:get() then
								Image = Props.Tool:get().TextureId
							end
							return Image or ""
						end),
					}
				else
					return ButtonText {
						Text = Computed(function()
							local Name
							if Props.Tool:get() then
								Name = Props.Tool:get().Name
							end
							return Name or "Tool"
						end),
					}
				end
			end, Fusion.cleanup),

			Computed(function()
				if States.ContextMenu.Active:get() and States.ContextMenu.GuiObject:get() == ToolButton then
					return ContextMenu {}
				else
					return {}
				end
			end, Fusion.cleanup),
		}
	})

	if States.DefaultEffectsEnabled:get() then
		Hydrate(ToolButton)({
			[Child "UIStroke"] = {
				Enabled = Props.Equipped,
			},
		})
	end

	ToolButton:SetAttribute("Equipped", Props.Equipped:get())

	return ToolButton
end
