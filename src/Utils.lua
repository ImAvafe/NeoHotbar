local NeoHotbar = script.Parent

local States = require(NeoHotbar.States)

local Utils = {}

function Utils:ToggleToolEquipped(Tool: Tool)
    if Tool.Parent == States.Backpack then
        States.Humanoid:EquipTool(Tool)
    else
        States.Humanoid:UnequipTools()
    end
end

return Utils