local worldManager = {}

local World = _G("classes.examples.World")

-- Create a new instance/copy of World
-- You can also do World:new(...)
local world = World("Epic World", 50)

-- Receives an emitter event
world:on("generate", function(size)
	print("The world has been generated with a size of "..size)
end)

world:generate()

return worldManager