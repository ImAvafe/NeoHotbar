local Players = game:GetService("Players")

local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local Fusion = require(NeoHotbar.ExtPackages.Fusion)

local Value = Fusion.Value

local VALID_TOOL_CLASSES = {"Tool", "HopperBin"}

local States = {}

function States:_FindToolSlot(Tool)
    local ToolSlots = self.ToolSlots:get()
    for ToolNum, ToolSlot in ipairs(ToolSlots) do
        if ToolSlot.Tool == Tool then
            return ToolSlot, ToolNum
        end
    end
end

function States:_ToolAdded(Tool)
    if table.find(VALID_TOOL_CLASSES, Tool.ClassName) then
        local ToolSlots = self.ToolSlots:get()
        local ToolSlot = self:_FindToolSlot(Tool)
        if not ToolSlot then
            table.insert(ToolSlots, {
                Tool = Tool,
                Equipped = Tool.Parent == self.Char
            })
        else
            ToolSlot.Equipped = Tool.Parent == self.Char
        end
        self.ToolSlots:set(ToolSlots)
    end
end

function States:_ToolRemoved(Tool)
    local ToolSlots = self.ToolSlots:get()
    local ToolSlot, ToolNum = self:_FindToolSlot(Tool)
    if ToolSlot then
        if not (Tool.Parent == self.Backpack or Tool.Parent == self.Char) then
            table.remove(ToolSlots, ToolNum)
        else
            ToolSlot.Equipped = Tool.Parent == self.Char
        end
        self.ToolSlots:set(ToolSlots)
    end
end

function States:_ScanToolDir(ToolDir)
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
    local Char = Players.LocalPlayer.Character
    if Char then
        self:_CharacterAdded(Char)
    end
end

function States:Init()
    self.InstanceSet = Value(NeoHotbar.UI.DefaultInstances)
    self.DefaultEffectsEnabled = Value(true)

    self.ToolSlots = Value({})
    self.CustomButtons = Value({})
end

return States