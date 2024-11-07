local iterate = {}

local instances = {}

-- addInstance is not actually present in Class
function iterate:addInstance()
	local className = self.className
	assert(type(className) == "string", "Attempt to addInstance with invalid className")

	local classInstances = instances[className] or {}

	table.insert(classInstances, self)

	instances[className] = classInstances
end

function iterate:getInstances()
	local className = self.className
	assert(type(className) == "string", "Attempt to getInstances with invalid className")

	return instances[className] or {}
end

function iterate:iter()
	return ipairs(self:getInstances())
end

function iterate:iterCall(callback)
	for index, instance in self:iter() do
		callback(instance, index)
	end
end

function iterate:iterAll(methodName)
	for index, instance in self:iter() do
		local method = instance[methodName]
		assert(method, "Failed to find method in iterMethod: \"" .. tostring(methodName) .. "\"")

		local success, returned = pcall(function()
			method(instance)
		end)
		assert(success, "Failed to run method in iterMethod: \"" .. tostring(methodName) .. "\"")
	end
end

return iterate