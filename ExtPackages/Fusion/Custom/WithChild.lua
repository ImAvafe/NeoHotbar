--!strict

--[[
	A special key for selecting child instances
]]

local Package = script.Parent.Parent
local PubTypes = require(Package.PubTypes)
local applyInstanceProps = require(Package.Instances.applyInstanceProps)

local function WithChild(childName: string): PubTypes.SpecialKey
	local withChildKey = {}
	withChildKey.type = "SpecialKey"
	withChildKey.kind = "WithChild"
	withChildKey.stage = "observer"

	function withChildKey:apply(properties, target: Instance, cleanupTasks: {PubTypes.Task})
		local instance = target:FindFirstChild(childName)
		
        applyInstanceProps(properties, instance)
        
        table.insert(cleanupTasks, function()
            
        end)
    end

	return withChildKey
end

return WithChild