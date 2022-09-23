local Players = game:GetService("Players")
local NeoHotbar = script.Parent
local Deps = require(NeoHotbar.Dependencies)

local Fusion = require(Deps.fusion)

local State = Fusion.State

local VALID_TOOL_CLASSES = {"Tool", "HopperBin"}
local Backpack = Players.LocalPlayer:WaitForChild("Backpack")
local Char

local States = {}

function States:Start()
    local function FindToolSlot(Tool)
        local ToolSlots = self.ToolSlots:get()
        for ToolNum, ToolSlot in ipairs(ToolSlots) do
            if ToolSlot.Tool == Tool then
                return ToolSlot, ToolNum
            end
        end
    end

    local function ToolAdded(Tool)
        if table.find(VALID_TOOL_CLASSES, Tool.ClassName) then
            local ToolSlots = self.ToolSlots:get()
            local ToolSlot = FindToolSlot(Tool)
            if not ToolSlot then
                table.insert(ToolSlots, {
                    Tool = Tool,
                    Equipped = Tool.Parent ~= Backpack
                })
            else
                ToolSlot.Equipped = Tool.Parent == Char
            end
            self.ToolSlots:set(ToolSlots, true)
        end
    end

    local function ToolRemoved(Tool)
        local ToolSlots = self.ToolSlots:get()
        local ToolSlot, ToolNum = FindToolSlot(Tool)
        if ToolSlot then
            if not (Tool.Parent == Backpack or Tool.Parent == Char) then
                table.remove(ToolSlots, ToolNum)
            else
                ToolSlot.Equipped = Tool.Parent == Char
            end
            self.ToolSlots:set(ToolSlots, true)
        end
    end

    local function InitialToolScan(ToolDir)
        for _, Child in ipairs(ToolDir:GetChildren()) do
            ToolAdded(Child)
        end
    end

    local function CharacterAdded(NewChar: Model)
        Char = NewChar
        Char.ChildAdded:Connect(ToolAdded)
        Char.ChildRemoved:Connect(ToolRemoved)
        InitialToolScan(Char)

        Backpack = Players.LocalPlayer:WaitForChild("Backpack")
        Backpack.ChildAdded:Connect(ToolAdded)
        Backpack.ChildRemoved:Connect(ToolRemoved)
        InitialToolScan(Backpack)
    end

    Players.LocalPlayer.CharacterAdded:Connect(CharacterAdded)
    Char = Players.LocalPlayer.Character
    if Char then
        CharacterAdded(Char)
    end
end

function States:Init()
    self.ToolSlots = State({})
end

return States