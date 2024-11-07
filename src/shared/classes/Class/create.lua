local create = {}

local config = _G("config.classes.Class")

local tools = _G("modules.tools")

-- Prevent direct class instances
function create.__call()
	error("Cannot create direct instances of Class")
end
create.new = create.__call

function create:inheritMethod(methodName, newMethod, ending)
	local originalMethod = self[methodName]

	self[methodName] = function(self, ...)
		if ending then
			newMethod(self, ...)
		end

		originalMethod(self, ...)

		if not ending then
			newMethod(self, ...)
		end
	end
end

function create:inherit(class)
	tools.inherit(self, class)
end

function create:inheritMultiple(others, class)
	others = table.clone(others)
	table.insert(others, 1, self)
	tools.inheritMultiple(others, class)
end

function create:inheritFrom(class)
	tools.inherit(class, self)
end

function create:inheritMultipleFrom(classes)
	tools.inheritMultiple(classes, self)
end

function create:create(className, ...)
	local class = {}
	
	local address = tostring(class):match("table: 0x(.*)")
	tools.inherit(self, class)
	class.className = className
	class.__address = address

	local __create = class["__create"]
	if __create then
		__create(class, ...)
	end

	return class
end

function create:new(...)
	local class = {}

	self.__address = tostring(class):match("table: 0x(.*)")
	tools.inherit(self, class)

	local __init = class["__init"]
	if __init then
		__init(class, ...)
	end

	return class
end

setmetatable(create, {
	__call = create.new
})

return create