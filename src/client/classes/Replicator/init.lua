-- An abstract class derivved from Emitter. Connects emitter across client-server boundary.

local Emitter = _G("classes.Emitter")
local Replicator = Emitter:create("Replicator")

local shared = _G("classes.Replicator.shared")
local replicatorRemotes = shared.replicatorRemotes

local replicatorReplication = require(script:WaitForChild("replication"))
local replicatorListener = require(script:WaitForChild("listener"))

Replicator:inheritMultipleFrom({ replicatorReplication, replicatorListener })

replicatorRemotes:WaitForChild("ready"):FireServer()

return Replicator