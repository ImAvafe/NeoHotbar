local Players = game:GetService("Players")

local NeoHotbar = script.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)

local Value = Fusion.Value
local Observer = Fusion.Observer

local States = {
  Enabled = Value(true),
  InstanceSet = Value(NeoHotbar.DefaultInstances),
  DefaultEffectsEnabled = Value(true),
  ManagementMode = {
    Enabled = Value(true),
    Active = Value(false),
    Swapping = {
      PrimarySlot = Value(),
      SecondarySlot = Value(),
    },
  },
  ToolTip = {
    Enabled = Value(true),
    Visible = Value(false),
    Text = Value(''),
  },
  ContextMenu = {
    Enabled = Value(true),
    Active = Value(false),
    GuiObject = Value(),
    Actions = Value()
  },
  ToolSlots = Value({}),
  CustomButtons = Value({}),
}

function States:DropTool(Tool: Tool)
  States.Humanoid:EquipTool(Tool)
  Tool.Parent = workspace
end

function States:ToggleToolEquipped(Tool: Tool)
  if Tool.Parent == States.Backpack then
      States.Humanoid:EquipTool(Tool)
  else
      States.Humanoid:UnequipTools()
  end
end

function States:SwapToolSlots(SlotIndex1: number, SlotIndex2: number)
  local ToolSlots = States.ToolSlots:get()
  local ToolSlot1, ToolSlot2 = ToolSlots[SlotIndex1], ToolSlots[SlotIndex2]
  if ToolSlot1 and ToolSlot2 then
    ToolSlots[SlotIndex1] = ToolSlot2
    ToolSlots[SlotIndex2] = ToolSlot1
  end
  States.ToolSlots:set(ToolSlots)
end

function States:ToggleContextMenuToSlot(ToolButton: Instance, Tool: Tool)
	if States.ContextMenu.GuiObject:get() ~= ToolButton then
		States:SetContextMenuToSlot(ToolButton, Tool)
	else
		States.ContextMenu.Active:set(false)
		States.ContextMenu.GuiObject:set(nil)
		States.ContextMenu.Actions:set({})
	end
end

function States:SetContextMenuToSlot(ToolButton: GuiObject, Tool: Tool)
  if typeof(ToolButton) ~= "Instance" then return end
  if typeof(Tool) ~= "Instance" then return end
  if not Tool:IsA("Tool") then return end
  
  local Actions = {}
  if Tool.CanBeDropped then
    table.insert(Actions, {
      Name = "Drop",
      Function = function()
        States:DropTool(Tool)
      end
    })
  end
  self.ContextMenu.Actions:set(Actions)

  if #Actions >= 1 then
    if self.ContextMenu.Enabled:get() then
      self.ContextMenu.GuiObject:set(ToolButton)
      self.ContextMenu.Active:set(true)
    end
  else
    self.ContextMenu.GuiObject:set(nil)
    self.ContextMenu.Active:set(false)
  end

  self.ToolTip.Visible:set(false)
end

function States:GetEquippedToolSlot()
  local ToolSlots = self.ToolSlots:get()
  for _, ToolSlot in ipairs(ToolSlots) do
      if ToolSlot.Equipped:get() then
          local Index = table.find(ToolSlots, ToolSlot)
          return ToolSlot, Index
      end
  end
end

function States:FindCustomButton(ButtonName: string)
  local CustomButtons = self.CustomButtons:get()
  for _, CustomButton in ipairs(CustomButtons) do
      if CustomButton.Name == ButtonName then
          return CustomButton
      end
  end
end

function States:_FindToolSlot(Tool: Tool)
  local ToolSlots = self.ToolSlots:get()
  for ToolNum, ToolSlot in ipairs(ToolSlots) do
    if ToolSlot.Tool:get() == Tool then
      return ToolNum
    end
  end
end

function States:_ToolAdded(Tool: Tool)
  if Tool:IsA("Tool") then
    local NewToolSlots = self.ToolSlots:get()
    local ToolSlot = NewToolSlots[self:_FindToolSlot(Tool)]
    if not ToolSlot then
      table.insert(NewToolSlots, {
        Tool = Value(Tool),
        Equipped = Value(Tool.Parent == self.Char)
      })
      ToolSlot = NewToolSlots[self:_FindToolSlot(Tool)]
    else
      ToolSlot.Equipped:set(Tool.Parent == self.Char)
    end
    self.ToolSlots:set(NewToolSlots)

    if ToolSlot.Equipped:get() and not self.ManagementMode.Active:get() then
      if utf8.len(Tool.ToolTip) >= 1 then
        self.ToolTip.Text:set(Tool.ToolTip)
        self.ToolTip.Visible:set(States.ToolTip.Enabled:get() and true)
        if self.ToolTipProcess then
          task.cancel(self.ToolTipProcess)
        end
        self.ToolTipProcess = task.delay(2, function()
          self.ToolTip.Visible:set(false)
        end)
      else
        self.ToolTip.Visible:set(false)
      end
    end
  end
end

function States:_ToolRemoved(Tool: Tool)
  local NewToolSlots = self.ToolSlots:get()
  local ToolNum = self:_FindToolSlot(Tool)
  local ToolSlot = NewToolSlots[ToolNum]
  if ToolSlot then
    if Tool.Parent ~= self.Backpack and Tool.Parent ~= self.Char then
      table.remove(NewToolSlots, ToolNum)
      self.ToolTip.Visible:set(false)
    else
      ToolSlot.Equipped:set(Tool.Parent == self.Char)
    end
    self.ToolSlots:set(NewToolSlots)
  end
end

function States:_ScanToolDir(ToolDir: Instance)
  for _, Child in ipairs(ToolDir:GetChildren()) do
    self:_ToolAdded(Child)
  end
end

function States:_CharacterAdded(NewChar: Model)
  self.ToolSlots:set({})
  
  self.Char = NewChar
  self.Humanoid = self.Char:WaitForChild("Humanoid")

  self.Char.ChildAdded:Connect(function(Tool)
    self:_ToolAdded(Tool)
  end)
  self.Char.ChildRemoved:Connect(function(Tool)
    self:_ToolRemoved(Tool)
  end)
  self:_ScanToolDir(self.Char)

  self.Backpack = Players.LocalPlayer:WaitForChild("Backpack")
  self.Backpack.ChildAdded:Connect(function(Tool)
    self:_ToolAdded(Tool)
  end)
  self.Backpack.ChildRemoved:Connect(function(Tool)
    self:_ToolRemoved(Tool)
  end)
  self:_ScanToolDir(self.Backpack)
end

function States:Start()
  self.Backpack = Players.LocalPlayer:WaitForChild("Backpack")

  Players.LocalPlayer.CharacterAdded:Connect(function(Char)
      self:_CharacterAdded(Char)
  end)
  local ExistingCharacter = Players.LocalPlayer.Character
  if ExistingCharacter then
    self:_CharacterAdded(ExistingCharacter)
  end

  Observer(self.ManagementMode.Active):onChange(function()
    if self.ManagementMode.Active:get() then
      if self.Humanoid then
        self.Humanoid:UnequipTools()
      end
    end
  end)
end

return States