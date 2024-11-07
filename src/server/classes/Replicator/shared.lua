local shared = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes = ReplicatedStorage:WaitForChild("remotes")

shared.remotes = remotes

-- Create remotes
local replicatorRemotes = Instance.new("Folder")
replicatorRemotes.Name = "Replicator"

local replicatorRemoteReplicate = Instance.new("RemoteEvent")
replicatorRemoteReplicate.Name = "replicate"
replicatorRemoteReplicate.Parent = replicatorRemotes
local replicatorRemoteUnreplicate = Instance.new("RemoteEvent")
replicatorRemoteUnreplicate.Name = "unreplicate"
replicatorRemoteUnreplicate.Parent = replicatorRemotes
local replicatorRemoteEstablish = Instance.new("RemoteEvent")
replicatorRemoteEstablish.Name = "establish"
replicatorRemoteEstablish.Parent = replicatorRemotes
local replicatorRemoteReady = Instance.new("RemoteEvent")
replicatorRemoteReady.Name = "ready"
replicatorRemoteReady.Parent = replicatorRemotes

replicatorRemotes.Parent = remotes
shared.replicatorRemotes = replicatorRemotes

-- Create cache
shared.cache = {}
shared.clientReplicationQue = {}

return shared