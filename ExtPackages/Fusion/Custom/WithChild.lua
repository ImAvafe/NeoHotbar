--!strict

--[[
	A special key for selecting child instances
]]

local Package = script.Parent.Parent
local PubTypes = require(Package.PubTypes)
local applyInstanceProps = require(Package.Instances.applyInstanceProps)
local semiWeakRef = require(Package.Instances.semiWeakRef)

local function WithChild(childName: string): PubTypes.SpecialKey
	local withChildKey = {}
	withChildKey.type = "SpecialKey"
	withChildKey.kind = "WithChild"
	withChildKey.stage = "observer"

	function withChildKey:apply(properties, applyToRef: PubTypes.SemiWeakRef, cleanupTasks: {PubTypes.Task})
		local instance = applyToRef.instance:FindFirstChild(childName)
		
        applyInstanceProps(properties, semiWeakRef(instance))
        
        table.insert(cleanupTasks, function()
            
        end)
    end

	return withChildKey
end

return WithChild