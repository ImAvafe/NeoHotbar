local Players = game:GetService("Players")

local NeoHotbar = script.Parent

local Fusion = require(NeoHotbar.Parent.Fusion)

local Value = Fusion.Value
local Observer = Fusion.Observer
local Computed = Fusion.Computed

local VALID_TOOL_CLASSES = {"Tool", "HopperBin"}

local States = {
  InstanceSet = Value(NeoHotbar.DefaultInstances),
  DefaultEffectsEnabled = Value(true),
  ManagementModeEnabled = Value(false),
  ToolTipText = Value(''),
  ToolTipVisible = Value(false),
  ContextMenu = Value(),
  ContextMenuActions = Value({}),
  ToolSlots = Value({}),
  CustomButtons = Value({}),
  Enabled = Value(true),
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

function States:SetContextMenuToSlot(ToolButton: GuiObject, Tool: Tool)
  self.ContextMenu:set({GuiObject = ToolButton, Actions = {
      {Name = "Drop Item", Disabled = not Tool.CanBeDropped, Function = function()
          States:DropTool(Tool)
      end}
  }})
  self.ToolTipVisible:set(false)
end

function States:GetEquippedToolSlot()
  local ToolSlots = self.ToolSlots:get()
  for _, ToolSlot in ipairs(ToolSlots) do
      if ToolSlot.Equipped then
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
  if table.find(VALID_TOOL_CLASSES, Tool.ClassName) then
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

    if ToolSlot.Equipped:get() and not self.ManagementModeEnabled:get() then
      if string.len(Tool.ToolTip) >= 1 then
        self.ToolTipText:set(Tool.ToolTip)
        self.ToolTipVisible:set(true)
        if self.ToolTipProcess then
          task.cancel(self.ToolTipProcess)
        end
        self.ToolTipProcess = task.delay(2, function()
          self.ToolTipVisible:set(false)
        end)
      else
        self.ToolTipVisible:set(false)
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
      self.ToolTipVisible:set(false)
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

  self.ContextMenuActions = Computed(function()
    local ContextMenu = self.ContextMenu:get()
    return (ContextMenu and ContextMenu.Actions) or {}
  end)

  Players.LocalPlayer.CharacterAdded:Connect(function(Char)
      self:_CharacterAdded(Char)
  end)
  local Char = Players.LocalPlayer.Character
  if Char then
    self:_CharacterAdded(Char)
  end

  Observer(self.ManagementModeEnabled):onChange(function()
    local ManagementModeEnabled = self.ManagementModeEnabled:get()
    if ManagementModeEnabled then
      self.Humanoid:UnequipTools()
    end
  end)
end

return States