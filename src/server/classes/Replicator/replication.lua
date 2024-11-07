-- An abstract class derivved from Emitter. Connects emitter across client-server boundary.

local replication = {}

local serializationModule = _G("modules.serializationModule")
local tools = _G("modules.tools")

local shared = _G("classes.Replicator.shared")
local cache = shared.cache
local remotes = shared.remotes
local replicatorRemotes = shared.replicatorRemotes

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Emitter = _G("classes.Emitter")

local config = _G("config.classes.Replicator")

local clientReplicationQue = shared.clientReplicationQue

function replication:__init(...)
	Emitter.__init(self, ...)

	self.initParams = { ... }
	self.replicationCallbacks = {}
	self.replication = nil
end

function replication:__create(...)
	Emitter.__create(self, ...)

	self.replicationCallbacks = {}
	self.replication = nil
end

function replication:__replicate(data)
	-- Pass
end

local function replicateToClient(self, client)
	local replication = self:isReplicated(client)
	assert(replication, "Attempt to replicateToClient without replication")

	local replicationId = replication.id

	local clientReplication = {
		className = self.className,
		remotes = replication.remotes,
		id = replicationId,
	}

	-- Serialize TODO 
	-- local serializedSelf = table.clone(self)
	-- serializedSelf.replication = clientReplication

	local data = {}
	self:call("replicateData", data, client)

	-- Replace classes
	data = serializationModule.serializeReplication(cache, data)

	local received = false
	local connection
	connection = replicatorRemotes.replicate.OnServerEvent:Connect(function(otherClient, otherReplicationId)
		if client ~= otherClient or replicationId ~= otherReplicationId then
			return
		end

		received = true
		connection:Disconnect()
		self:call("clientAdded", client)
	end)

	replicatorRemotes.replicate:FireClient(client, clientReplication, data)

	task.spawn(function()
		task.wait(1)
		if not received then
			warn("Failed to replicate object to client " .. tostring(client.Name))
			client:Kick("Failed to replicate object to client")
			connection:Disconnect()
		end
	end)
end

local function getClientReplicationQue(client)
	local clientQue = clientReplicationQue[client]
	if clientQue then
		return clientQue
	end

	clientQue = {
		ready = false,
		classes = {},
	}
	clientReplicationQue[client] = clientQue

	return clientQue
end

local function queReplicateToClient(self, client)
	local clientQue = getClientReplicationQue(client)

	if clientQue.ready then
		replicateToClient(self, client)
		return
	end

	table.insert(clientQue.classes, self)
end

shared.replicatorRemotes.ready.OnServerEvent:Connect(function(client)
	local clientQue = getClientReplicationQue(client)
	clientQue.ready = true

	for _, class in ipairs(clientQue.classes) do
		replicateToClient(class, client)
	end
end)
Players.PlayerRemoving:Connect(function(client)
	clientReplicationQue[client] = nil
end)

function replication:replicate(clients)
	assert(not self.replication, "Attempt to replicate an already-replicated class")

	local className = self.className

	-- Create a unique replicationId
	local replicationId
	repeat
		replicationId = HttpService:GenerateGUID(false)
	until not cache[replicationId]
	cache[replicationId] = self

	local specificClassRemotes = remotes:FindFirstChild(className)
	if not specificClassRemotes then
		specificClassRemotes = Instance.new("Folder")
		specificClassRemotes.Name = className
		specificClassRemotes.Parent = remotes
	end

	if typeof(clients) == "Instance" then
		clients = { clients }
	end
	local replication = {
		remotes = specificClassRemotes,
		id = replicationId,
		clients = clients,
	}

	self.replication = replication

	if clients then
		for _, client in ipairs(clients) do
			queReplicateToClient(self, client)
		end
	else
		local connection = Players.PlayerAdded:Connect(function(client)
			queReplicateToClient(self, client)
		end)
		replication.connection = connection
		for _, client in ipairs(Players:GetPlayers()) do
			queReplicateToClient(self, client)
		end
	end

	for eventName in pairs(self.replicationCallbacks or {}) do
		self:establish(eventName)
	end

	self:call("replicate")

	return replication
end

function replication:addClient(client)
	assert(client, "Attempt to addClient without client")

	local replication = self:isReplicated()
	assert(replication, "Attempt to addClient without replication")

	local clients = replication.clients
	if not clients then
		return
	end
	if table.find(clients, client) then
		return
	end

	table.insert(clients, client)

	replicateToClient(self, client)
end

function replication:addClients(clients)
	assert(type(clients) == "table", "Attempt to addClients with invalid clients")

	local replication = self:isReplicated()
	assert(replication, "Attempt to addClients without replication")

	for _, client in ipairs(clients) do
		self:addClient(client)
	end
end

function replication:isReplicated()
	local replication = self.replication
	if replication then
		return replication
	end

	return false
end

function replication:unreplicate()
	local replication = self.replication

	assert(replication, "Attempt to unreplicate without replication")

	local clients = replication.clients or Players:GetPlayers()
	local id = replication.id
	for _, client in clients do
		replicatorRemotes.unreplicate:FireClient(client, id)
	end
	cache[id] = nil

	local connection = replication.connection
	if connection then
		connection:Disconnect()
	end

	-- TODO: Destroy remotes IF no other class instances are using them

	self.replication = nil
	self:call("unreplicate")
end

-- function replication:__serialize(serializedSelf)
-- 	serializedSelf = Emitter.__serialize(self, serializedSelf)

-- 	local newSerializedSelf = {}

-- 	for attributeKey, attributeValue in pairs(serializedSelf) do
-- 		if type(attributeValue) == "function" then
-- 			continue
-- 		end
-- 		if attributeKey:sub(1, 1) == "_" then
-- 			continue
-- 		end
-- 		if table.find(config.IGNORE_KEYS, attributeKey) then
-- 			continue
-- 		end
-- 		newSerializedSelf[attributeKey] = attributeValue
-- 	end

-- 	newSerializedSelf = serializationModule.serializeCyclic(newSerializedSelf)

-- 	return newSerializedSelf
-- end

return replication