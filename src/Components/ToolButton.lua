local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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
local Cleanup = Fusion.Cleanup
local New = Fusion.New

local Components = NeoHotbar.Components

local ButtonText = require(Components.ButtonText)
local ButtonImage = require(Components.ButtonImage)
local ContextMenu = require(Components.ContextMenu)

local Mouse = Players.LocalPlayer:GetMouse()
local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")

local MouseMoveConnection: RBXScriptConnection
UserInputService.InputEnded:Connect(function(Input: InputObject)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		if MouseMoveConnection then
			MouseMoveConnection:Disconnect()
		end

		if States.ManagementMode.Swapping.PrimarySlot:get() and States.ManagementMode.Swapping.SecondarySlot:get() then
			States:SwapToolSlots(States.ManagementMode.Swapping.PrimarySlot:get():GetAttribute("SlotNumber"), States.ManagementMode.Swapping.SecondarySlot:get():GetAttribute("SlotNumber"))
		end
		States.ManagementMode.Swapping.SecondarySlot:set(nil)
	end
end)

return function(Props: table)
	Props.LayoutOrder = EnsureProp(Props.LayoutOrder, "number", 1)
	Props.Equipped = EnsureProp(Props.Equipped, "boolean", false)
	Props.Tool = EnsureProp(Props.Tool, "Tool", Instance.new("Tool"))
	Props.ToolNumber = EnsureProp(Props.ToolNumber, "number", 1)

	local Holding = Value(false)
	local HoveredToolSlot = Value()

	local ToolButton
	ToolButton = Hydrate(States.InstanceSet:get()[script.Name]:Clone()) {
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = function()
			if not States.ManagementMode.Active:get() then
				States:ToggleToolEquipped(Props.Tool:get())
			else
				States:ToggleContextMenuToSlot(ToolButton, Props.Tool:get())
			end
		end,
		[OnEvent "MouseButton2Click"] = function()
			States:ToggleContextMenuToSlot(ToolButton, Props.Tool:get())
		end,
		[OnEvent "MouseButton1Down"] = function()
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
				States.ManagementMode.Swapping.PrimarySlot:set(ToolButton)
				MouseMoveConnection = Mouse.Move:Connect(function()
					if PlayerGui then
						local Objects = PlayerGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)
						for _, Object in ipairs(Objects) do
							if CollectionService:HasTag(Object, "NeoHotbarToolButton") then
								if Object ~= HoveredToolSlot:get() then
									HoveredToolSlot:set(Object)
									States.ManagementMode.Swapping.SecondarySlot:set(Object)
								end
							end
						end
					end
				end)
			end
		end,
		[OnEvent "MouseButton1Up"] = function()
			Holding:set(false)

			if MouseMoveConnection then
				MouseMoveConnection:Disconnect()
			end
		end,
		[OnEvent "MouseLeave"] = function()
			Holding:set(false)
		end,

		[Cleanup] = function()
			if MouseMoveConnection then
				MouseMoveConnection:Disconnect()
			end
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
	}

	if States.DefaultEffectsEnabled:get() then
		Hydrate(ToolButton)({
			BackgroundColor3 = Fusion.Computed(function()
				if Holding:get() or (States.ManagementMode.Swapping.SecondarySlot:get() and (States.ManagementMode.Swapping.SecondarySlot:get() == ToolButton)) then
					return Color3.fromRGB(37, 40, 43)
				else
					return Color3.fromRGB(25, 27, 29)
				end
			end),

			[Child "UIStroke"] = {
				Enabled = Props.Equipped,
			},
		})
	end

	ToolButton:SetAttribute("Equipped", Props.Equipped:get())
	ToolButton:SetAttribute("SlotNumber", Props.ToolNumber:get())
	New "ObjectValue" {
		Name = "Tool",
		Value = Props.Tool:get(),
		Parent = ToolButton,
	}

	CollectionService:AddTag(ToolButton, "NeoHotbarToolButton")

	return ToolButton
end
