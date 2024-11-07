-- An abstract base class which is almost all classes are derrived from

local Class = {}
Class.className = "Class"
setmetatable(Class, Class)

local tools = _G("modules.tools")

local config = _G("config.classes.Class")

for _, moduleName in ipairs(config.SUB_MODULES) do
	local module = require(script:WaitForChild(moduleName))

	tools.inherit(module, Class)

	-- TODO: REMOVE
	-- for methodName, method in pairs(require(script:WaitForChild(moduleName))) do
	-- 	Class[methodName] = method
	-- end
end

function Class:label()
	local className = self.className or "UNKNOWN_CLASS"
	local address = self.__address or "UNKNOWN_ADDRESS"

	local replication = self.replication
	local replicationString = ""
	if replication then
		local replicationId = replication.id
		if replicationId then
			replicationId = replicationId:sub(1, 5)
		else
			replicationId = "UNKNOWN_REP_ID"
		end
		replicationString = "/"..replicationId
	end

	return "{ "..className..": "..address..replicationString.." }"
end

-- To avoid errors on classes which call them:
function Class:__init()
	return
end
function Class:__create()
	
end

return Class