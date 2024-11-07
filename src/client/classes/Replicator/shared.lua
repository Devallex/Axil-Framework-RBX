local shared = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Find remotes
local remotes = ReplicatedStorage:WaitForChild("remotes")
local replicatorRemotes = remotes:WaitForChild("Replicator")

shared.replicatorRemotes = replicatorRemotes

-- Create cache
shared.cache = {}

return shared