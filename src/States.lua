local NeoHotbar = script.Parent
local Deps = require(NeoHotbar.Dependencies)

local Fusion = require(Deps.fusion)

local State = Fusion.State

local States = {}

function States:Start()
    
end

function States:Init()
    self.Tools = State({})
end

return States