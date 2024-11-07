local Replicator = _G("classes.Replicator")
local Container = Replicator:create("examples.inventory.Container")

function Container:__replicate(data)
	-- Class is initialized here instead of :__init()
	-- No data is automatically replicated into the class instance

	print("Replicated", data)

	self.items = {}

	-- The hook method
	self:on("addItem", function(item)
		table.insert(self.items, item)
	end)
	self:hook("addItem", data.items)

	--[[

	self:hook(eventName, defaultValues)

	Whenever onClient for the eventName is received, the local event will be called with the same name also.
	This means, instead of doing :onClient(eventName), you can just do :on(eventName).

	This is even more useful when using the default values paramater.
	If provided, it will automatically call the local event multiple times, passing each item in the array.
	This way, it can behave as if each item was being dropped one-by-one into the class.

	--]]
end

return Container