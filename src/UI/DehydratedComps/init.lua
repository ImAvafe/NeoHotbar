local DEFAULT_DEHYDRATED_COMPONENTS = script.DefaultGuiSet

local DehydratedComps = {
    _DefaultGuiSet = DEFAULT_DEHYDRATED_COMPONENTS
}

function DehydratedComps:Get()
    return self._CustomGuiSet or self._DefaultGuiSet
end

function DehydratedComps:Overwrite(GuiSet: ScreenGui)
    self._CustomGuiSet = GuiSet
end

return DehydratedComps