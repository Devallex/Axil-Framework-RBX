local ownership = {}

function ownership:setOwner(client)
	local replication = self:isReplicated()
	assert(replication, "Attempt to setOwner without replication")
	

	self:addClient(client)

	replication.owner = client
end

function ownership:getOwner()
	local replication = self:isReplicated()
	assert(replication, "Attempt to setOwner without replication")

	local owner = replication.owner

	if not owner then
		warn("Attempt to get owner with no owner")
	end

	return owner
end

function ownership:onServerOwner(eventName, callback, ...)
	local vararg = {...}

	self:onServer(eventName, function(client)
		local owner = self:getOwner()
		assert(owner, "Attempt to receive onServerOwner without owner")

		if client ~= owner then
			warn("Non-owner attempted to call owner-only event")
			return
		end

		callback(client, table.unpack(vararg))
	end)
end

function ownership:callOwner(eventName, ...)
	local owner = self:getOwner()

	assert(owner, "Attempt to callOwner without owner")

	self:callClient(eventName, owner, ...)
end

return ownership