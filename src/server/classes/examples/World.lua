-- Get the Emitter class
local Emitter = _G("classes.Emitter")

-- Create the class, inheriting from Emitter
local World = Emitter:create("World")

-- Fetch services, modules, and other classes
local terrain = workspace.Terrain

-- Default properties
World.worldName = "Unnamed World"
World.terrainSize = 0
World.isGenerated = false

-- This is automatically called when World.new(...) or World(...) is run, passing paramaters as well
function World:__init(worldName, terrainSize, ...)
	-- Because it's being overwritten, you need to call this to inherit it's behavior.
	Emitter.__init(self, worldName, terrainSize, ...) -- The Emitter doesn't neccecarily use these paramaters, but it's a good practice to send them anyway

	-- You can update properties here
	self.worldName = worldName
	self.terrainSize = terrainSize
	-- ( And you can also set default properties here too )

	-- This is a good place to listen for Emitter events. (Outside of the class works too!)
	self:on("clear", function()
		print("The world was cleared!")
	end)
end

-- This is automatically called when World:create(className, ...) is run, passing paramaters (except for className)
function World:__create(...)
	print("A new class is inheriting directly from this one to be created!")
end

function World:generate()
	self:clear() -- Call a method on this object

	local length = self.terrainSize / 2

	terrain:FillBlock(
		CFrame.new(),
		Vector3.new(length, 5, length),
		Enum.Material.Grass
	)

	self.isGenerated = true -- Update a property
	self:call("generate", self.terrainSize) -- Calls an Emitter event
end

-- A "static" function, not specific to any fixed amount of World instances
-- This uses iteration functions, which preforms bulk-actions on multiple instances of this class
function World.clearAll()
	-- This method:
	World:iterAll("clear")

	-- ...is identical to:
	World:iterCall(function(self)
		self:clear()
	end)

	-- ...and also identical too:
	for self in World:iter() do
		self:clear()
	end

	-- ...as well as:
	for _, self in ipairs(World:getInstances()) do
		self:clear()
	end

	-- They all do the same thing, call the "clear" method on every instance of the class.
	-- (Just don't call these all at once, or it'll run multiple times.)
end

function World:clear()
	terrain:Clear()
	self.isGenerated = false
	self:call("clear") -- Calls an Emitter event
end

return World