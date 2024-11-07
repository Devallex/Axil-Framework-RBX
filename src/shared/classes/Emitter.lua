-- An abstract class which allows for transmission of same-side events

local Class = _G("classes.Class")
local Emitter = Class:create("Emitter")

function Emitter:__create(...)
	Class.__create(self, ...)
	self.callbacks = {}
	self:call("create", ...)
end

function Emitter:__init(...)
	Class.__init(self, ...)
	self.callbacks = {}
	self:call("init", ...)
end

function Emitter:call(eventName, ...)
	local callbacks = self.callbacks or {}
	local eventCallbacks = callbacks[eventName] or {}

	local disconnectedCallbacks = {}
	for _, eventCallback in eventCallbacks do
		local returned = eventCallback(...)
		if returned == false then
			table.insert(disconnectedCallbacks, eventCallback)
		end
	end
	for _, disconnectedCallback in disconnectedCallbacks do
		table.remove(eventCallbacks, table.find(eventCallbacks, disconnectedCallback))
	end

	if eventName ~= "all" then
		self:call("all", eventName, ...)
	end
end

function Emitter:on(eventName, callback)
	local callbacks = self.callbacks or {}
	local eventCallbacks = callbacks[eventName] or {}
	
	table.insert(eventCallbacks, callback)

	callbacks[eventName] = eventCallbacks
	self.callbacks = callbacks

	self:call("bind", eventName, callback)
end

function Emitter:hasBindings(eventName)
	local callbacks = self.callbacks or {}
	local eventCallbacks = callbacks[eventName] or {}
	
	if #eventCallbacks >= 1 then
		return true
	end
	return false
end

return Emitter