local NeoHotbar = script:FindFirstAncestor("NeoHotbar")

local States = require(NeoHotbar.UI.States)

local Utils = {}

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

return Utils