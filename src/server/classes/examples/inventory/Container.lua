local Replicator = _G("classes.Replicator")
local Container = Replicator:create("examples.inventory.Container")

Container.name = "Unnamed Container"

function Container:__init(containerName)
	self.name = containerName
	self.items = {}

	local function updateItems()
		self:bicall("updateItems", self.items) -- bicall runs both self:call(...) and self:callAllClients(...)
	end
	self:on("addItem", updateItems)
	self:on("removeItem", updateItems)

	-- If an owner is set, an an event is received from them
	self:onServerOwner("removeItem", function(item)
		self:removeItem(item)
	end)

	self:replicate()
end

function Container:addItem(item)
	table.insert(self.items, item)
	item.inventory = self -- Circular references supported!
	self:bicall("addItem", item)
end

function Container:removeItem(item)
	table.remove(self.items, table.find(self.items, item))
	item.inventory = nil
	self:bicall("removeItem", item)
end

return Container