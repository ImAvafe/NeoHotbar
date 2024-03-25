local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
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
local New = Fusion.New
local Observer = Fusion.Observer
local Cleanup = Fusion.Cleanup

local Components = NeoHotbar.Components

local ButtonText = require(Components.ButtonText)
local ButtonImage = require(Components.ButtonImage)
local ContextMenu = require(Components.ContextMenu)

local Mouse = Players.LocalPlayer:GetMouse()
local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")

local HoveredToolSlot = Value()

local MouseMoveConnection: RBXScriptConnection
local TouchMoveConnection: RBXScriptConnection

UserInputService.InputEnded:Connect(function(Input: InputObject)
	if (Input.UserInputType == Enum.UserInputType.MouseButton1) or Input.UserInputType == Enum.UserInputType.Touch then
		if MouseMoveConnection then
			MouseMoveConnection:Disconnect()
		end
		if TouchMoveConnection then
			TouchMoveConnection:Disconnect()
		end

		if States.ManagementMode.Swapping.PrimarySlot:get() and States.ManagementMode.Swapping.SecondarySlot:get() then
			States:SwapToolSlots(
				States.ManagementMode.Swapping.PrimarySlot:get():GetAttribute("SlotNumber"),
				States.ManagementMode.Swapping.SecondarySlot:get():GetAttribute("SlotNumber")
			)
		end
		States.ManagementMode.Swapping.PrimarySlot:set(nil)
		States.ManagementMode.Swapping.SecondarySlot:set(nil)
	end
end)

local function SelectionMove(X: number, Y: number)
	if PlayerGui then
		local Objects = PlayerGui:GetGuiObjectsAtPosition(X, Y)
		for _, Object in ipairs(Objects) do
			if CollectionService:HasTag(Object, "NeoHotbarToolButton") then
				if Object ~= HoveredToolSlot:get() then
					HoveredToolSlot:set(Object)
					States.ManagementMode.Swapping.SecondarySlot:set(Object)
				end
			end
		end
	end
end

return function(Props: table)
	Props.LayoutOrder = EnsureProp(Props.LayoutOrder, "number", 1)
	Props.Equipped = EnsureProp(Props.Equipped, "boolean", false)
	Props.Tool = EnsureProp(Props.Tool, "Tool", Instance.new("Tool"))
	Props.ToolNumber = EnsureProp(Props.ToolNumber, "number", 1)

	local Holding = Value(false)
	local ObserverDisconnects = {}

	local ToolButton
	ToolButton = Hydrate(States.InstanceSet:get()[script.Name]:Clone()) {
		LayoutOrder = Props.LayoutOrder,

		[OnEvent "Activated"] = function()
			if States.ManagementMode.Active:get() then
				local SwappedTool = false
				if GuiService.SelectedObject == ToolButton then
					if States.ManagementMode.Swapping.PrimarySlot:get() then
						States.ManagementMode.Swapping.SecondarySlot:set(ToolButton)
						States:SwapToolSlots(
							States.ManagementMode.Swapping.PrimarySlot:get():GetAttribute("SlotNumber"),
							States.ManagementMode.Swapping.SecondarySlot:get():GetAttribute("SlotNumber")
						)

						States.ManagementMode.Swapping.PrimarySlot:set()
						States.ManagementMode.Swapping.SecondarySlot:set()
						SwappedTool = true
					else
						States.ManagementMode.Swapping.PrimarySlot:set(ToolButton)
					end
				end

				if SwappedTool then
					States.ContextMenu.Active:set(false)
				else
					States:ToggleContextMenuToSlot(ToolButton, Props.Tool:get())
				end
			else
				States:ToggleToolEquipped(Props.Tool:get())
			end
		end,
		[OnEvent "MouseButton2Click"] = function()
			States:ToggleContextMenuToSlot(ToolButton, Props.Tool:get())
		end,
		[OnEvent "MouseButton1Down"] = function()
			Holding:set(true)

			if States.ManagementMode.Enabled:get() then
				if not States.ManagementMode.Active:get() or GuiService.SelectedObject == ToolButton then
					if States.HotbarHoldProcess then
						task.cancel(States.HotbarHoldProcess)
					end
					States.HotbarHoldProcess = task.delay(0.25, function()
						if Holding:get() == true then
							Holding:set(false)

							States.ManagementMode.Active:set(not States.ManagementMode.Active:get())
							States.ToolTip.Visible:set(false)
							States.ContextMenu.Active:set(false)

							if
								(not States.ManagementMode.Active:get()) and (GuiService.SelectedObject == ToolButton)
							then
								GuiService.SelectedObject = nil
							end
						end
					end)
				end
			end

			if States.ManagementMode.Active:get() and GuiService.SelectedObject ~= ToolButton then
				States.ManagementMode.Swapping.PrimarySlot:set(ToolButton)

				MouseMoveConnection = Mouse.Move:Connect(function()
					SelectionMove(Mouse.X, Mouse.Y)
				end)
				TouchMoveConnection = UserInputService.TouchMoved:Connect(function(Input: InputObject)
					SelectionMove(Input.Position.X, Input.Position.Y)
				end)
			end
		end,
		[OnEvent "MouseButton1Up"] = function()
			Holding:set(false)

			if States.ManagementMode.Swapping.PrimarySlot:get() == ToolButton then
				States.ManagementMode.Swapping.PrimarySlot:set(nil)
			end

			if MouseMoveConnection then
				MouseMoveConnection:Disconnect()
			end
			if TouchMoveConnection then
				TouchMoveConnection:Disconnect()
			end
		end,
		[OnEvent "MouseLeave"] = function()
			Holding:set(false)
		end,

		[Cleanup] = function()
			if MouseMoveConnection then
				MouseMoveConnection:Disconnect()
			end
			for _, Disconnect in ipairs(ObserverDisconnects) do
				Disconnect()
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
		},
	}

	if States.DefaultEffectsEnabled:get() then
		Hydrate(ToolButton)({
			BackgroundColor3 = Fusion.Computed(function()
				local PrimarySlot = States.ManagementMode.Swapping.PrimarySlot:get()
				local SecondarySlot = States.ManagementMode.Swapping.SecondarySlot:get()

				local IsPrimarySwapSlot = PrimarySlot and (PrimarySlot == ToolButton)
				local IsSecondarySwapSlot = SecondarySlot and (SecondarySlot == ToolButton)

				if Holding:get() or (IsPrimarySwapSlot or IsSecondarySwapSlot) then
					return Color3.fromRGB(20, 20, 20)
				else
					return Color3.fromRGB(0, 0, 0)
				end
			end),

			[Child "UIStroke"] = {
				Enabled = Props.Equipped,
			},
		})
	end

	table.insert(
		ObserverDisconnects,
		Observer(Holding):onChange(function()
			ToolButton:SetAttribute("Holding", Holding:get())
		end)
	)
	ToolButton:SetAttribute("Holding", Holding:get())
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
