local GuiModules = {script.Parent.Components.Hotbar}

return function(Target)
    local Guis = {}

    for _, GuiModule in ipairs(GuiModules) do
        local GuiNameSplit = string.split(GuiModule.Name, ".")
        local StorySuffix = GuiNameSplit[2]
        
        if not StorySuffix and GuiModule:IsA("ModuleScript") then
            local Gui = require(GuiModule)
            table.insert(Guis, Gui {
                Parent = Target
            })
        end
    end

    return function()
        for _, Gui in ipairs(Guis) do
            Gui:Destroy()
        end
    end
end