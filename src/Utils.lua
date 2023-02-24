local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local States = require(NeoHotbar.UI.States)

local Utils = {}

function Utils:SetContextMenuToSlot(ToolButton: GuiObject, Tool: Tool)
    States.ContextMenu:set({GuiObject = ToolButton, Actions = {
        {Name = "Drop Item", Disabled = not Tool.CanBeDropped, Function = function()
            self:DropTool(Tool)
        end}
    }})
    States.ToolTipVisible:set(false)
end

function Utils:DropTool(Tool: Tool)
    States.Humanoid:EquipTool(Tool)
    Tool.Parent = workspace
end

function Utils:ToggleToolEquipped(Tool: Tool)
    if Tool.Parent == States.Backpack then
        States.Humanoid:EquipTool(Tool)
    else
        States.Humanoid:UnequipTools()
    end
end

function Utils:GetEquippedToolSlot()
    local ToolSlots = States.ToolSlots:get()
    for _, ToolSlot in ipairs(ToolSlots) do
        if ToolSlot.Equipped then
            local Index = table.find(ToolSlots, ToolSlot)
            return ToolSlot, Index
        end
    end
end

function Utils:FindCustomButton(ButtonName: string)
    local CustomButtons = States.CustomButtons:get()
    for _, CustomButton in ipairs(CustomButtons) do
        if CustomButton.Name == ButtonName then
            return CustomButton
        end
    end
end

return Utils