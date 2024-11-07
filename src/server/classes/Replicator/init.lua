local Emitter = _G("classes.Emitter")
local Replicator = Emitter:create("Replicator")

local replicatorReplication = require(script:WaitForChild("replication"))
local replicatorListener = require(script:WaitForChild("listener"))
local replicatorOwnership = require(script:WaitForChild("ownership"))

Replicator:inheritMultipleFrom({ replicatorReplication, replicatorListener, replicatorOwnership })

return Replicator
