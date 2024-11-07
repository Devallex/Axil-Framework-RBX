local replication = {}

local serializationModule = _G("modules.serializationModule")
local tools = _G("modules.tools")

local shared = require(script.Parent:WaitForChild("shared"))
local cache = shared.cache
local replicatorRemotes = shared.replicatorRemotes

local function onClientReplicate(replication, data)
	local replicationId = replication.id

	if cache[replicationId] then
		warn("Duplicate class cached on client")
		return
	end

	local className = replication.className
	local class = _G.require("classes." .. tostring(className))

	if not class then
		warn("Attempt to replicate class which could not be found", className)
		return
	end

	data = serializationModule.unserializeReplication(cache, data)

	local self = {}
	tools.inherit(class, self)

	local __replicate = self["__replicate"]
	if __replicate then
		__replicate(self, data)
	end

	cache[replicationId] = self

	replicatorRemotes:WaitForChild("replicate"):FireServer(replicationId)

	self:call("replicate")
end

local function onClientUnreplicate(replicationId)
	local self = cache[replicationId]

	if not self then
		return
	end

	self.replication = nil
	self:call("unreplicate")
end

replicatorRemotes:WaitForChild("replicate").OnClientEvent:Connect(onClientReplicate)
replicatorRemotes:WaitForChild("unreplicate").OnClientEvent:Connect(onClientUnreplicate)

return replication