local NeoHotbar = script.Parent
local Deps = require(NeoHotbar.Dependencies)

local Fusion = require(Deps.fusion)

local State = Fusion.State

local InternalTheme = require(script.InternalTheme)

local ThemeProvider = {}

ThemeProvider.Theme = {}

function ThemeProvider:_Init(Theme: table)
    for ThingName, Properties in pairs(Theme) do
        self.Theme[ThingName] = {}
        for Key, Value in pairs(Properties) do
            self.Theme[ThingName][Key] = State(Value)
        end
    end
end

function ThemeProvider:SetTheme(Theme: table)
    for ThingName, Properties in pairs(Theme) do
        local Thing = self.Theme[ThingName]
        for Key, Value in pairs(Properties) do
            local PropertyState = Thing[Key]
            assert(PropertyState, "Invalid theme property")
            PropertyState:set(Value)
        end
    end
end

ThemeProvider:_Init(InternalTheme)

return ThemeProvider