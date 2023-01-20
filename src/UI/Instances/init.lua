local DEFAULT_DEHYDRATED_COMPONENTS = script.DefaultInstances

local Instances = {
    _DefaultInstances = DEFAULT_DEHYDRATED_COMPONENTS
}

function Instances:Get()
    return self._CustomGuiSet or self._DefaultInstances
end

function Instances:Overwrite(GuiSet: ScreenGui)
    self._CustomGuiSet = GuiSet
end

return Instances