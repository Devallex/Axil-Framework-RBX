local resourceModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local config = ReplicatedStorage:WaitForChild("config"):WaitForChild("modules")
local resourceModuleConfig = require(config:WaitForChild("resourceModule"))

local originalRequire = require

function resourceModule.require(path)
	assert(type(path) == "string", "Attempt to require module with invalid path: " .. tostring(path))

	local tablePath = string.split(path, ".")

	local object
	for _, directory in ipairs(resourceModuleConfig.DIRECTORIES) do
		object = directory
		for _, subPath in ipairs(tablePath) do
			object = object:FindFirstChild(subPath)
			if not object then
				break
			end
		end

		if object then
			break
		end
	end

	assert(object, "Failed to find module with path: " .. tostring(path))

	if object:IsA("ModuleScript") then
		local success, returned = pcall(function()
			return originalRequire(object)
		end)

		assert(success, "Error when requiring module:\n" .. tostring(returned))

		object = returned
	end

	return object
end

setmetatable(_G, {
	__index = resourceModule,
	__call = function(self, ...)
		return resourceModule.require(...)
	end,
})

return resourceModule