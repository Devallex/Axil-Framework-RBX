local listener = {}

local Players = game:GetService("Players")

local shared = _G("classes.Replicator.shared")
local cache = shared.cache
local replicatorRemotes = shared.replicatorRemotes

local serializationModule = _G("modules.serializationModule")

local establishedRemotes = {}

-- Create events
function listener:establish(eventName)
	local replication = self:isReplicated()
	assert(replication, "Attempt to establish without replication")

	local remotes = replication.remotes
	assert(remotes, "Attempt to establish without remotes")

	local specificRemote = remotes:FindFirstChild(eventName)
	if specificRemote then
		return specificRemote
	end

	specificRemote = Instance.new("RemoteEvent")
	specificRemote.Name = eventName
	specificRemote.Parent = remotes

	specificRemote.OnServerEvent:Connect(function(client, replicationId, vararg)
		assert(type(replicationId) == "string", "Attempt to receive event with invalid replicationId")

		local replicationCallbacks = self.replicationCallbacks or {}
		local eventCallbacks = replicationCallbacks[eventName] or {}

		local self = cache[replicationId]

		assert(self, "Attempt to receive event without cached class")

		vararg = serializationModule.unserializeReplication(vararg) or {}

		for _, eventCallback in ipairs(eventCallbacks) do
			local success, returned = pcall(function()
				eventCallback(client, table.unpack(vararg))
			end)
			assert(success, "Error when running onServer callback for " .. tostring(client) .. " on " .. tostring(replicationId) .. ":\n" .. tostring(returned))
		end
	
		self:call("onServer", eventName, client, table.unpack(vararg))
	end)

	table.insert(establishedRemotes, specificRemote)

	replicatorRemotes.establish:FireAllClients({specificRemote})

	return specificRemote
end

Players.PlayerAdded:Connect(function(client)
	replicatorRemotes.establish:FireClient(client, establishedRemotes)
end)

-- Calls events
function listener:callClient(eventName, client, ...) -- Calls a specific client, replicating if neccecary
	assert(type(eventName) == "string", "Attempt to callClient with invalid eventName")
	assert(client, "Attempt to callClient with invalid clients")
	
	local remote = self:establish(eventName)

	self:addClient(client)

	local replication = self:isReplicated()
	assert(replication, "Attempt to callClient without being replicated")

	local replicationId = replication.id

	assert(replicationId, "Attempt to callClient without replicationId")

	local vararg = serializationModule.serializeReplication({...})

	remote:FireClient(client, replicationId, vararg)

	self:call("callClient", eventName, client, vararg)
end

function listener:callClients(eventName, clients, ...) -- Calls specific clients, replicating if neccecary
	assert(type(eventName) == "string", "Attempt to callClients with invalid ventName")
	assert(type(clients) == "table", "Attempt to callClients with invalid clients")

	local replication = self:isReplicated()
	assert(replication, "Attempt to callClients without replication")
	
	for _, client in ipairs(clients) do
		self:callClient(eventName, client, ...)
	end
end

function listener:callAllClients(eventName, ...) -- Calls all currently replicated clients
	local replication = self:isReplicated()
	assert(replication, "Attempt to callAllClients without replication")

	local clients = replication["clients"] or Players:GetPlayers()

	self:callClients(eventName, clients)
end

-- On events
function listener:onServer(eventName, callback)
	if self:isReplicated() then
		self:establish(eventName)
	end

	local replicationCallbacks = self.replicationCallbacks or {}
	local eventCallbacks = replicationCallbacks[eventName] or {}
	
	table.insert(eventCallbacks, callback)

	replicationCallbacks[eventName] = eventCallbacks
	self.replicationCallbacks = replicationCallbacks

	self:call("bindServer", eventName, callback)
end

-- Unique methods
function listener:hook(eventName)
	self:on(eventName, function(...)
		self:callAllClients(eventName, ...)
	end)
end

return listener