local Preset = _G("classes.Preset")
local GuiPreset = _G("presets.Gui")

local Gui = Preset:create("Gui", GuiPreset, "Gui")

local allGuis = {}

local function makeGui(self)
	local guiInstance = Instance.new(self.className)
	for propertyNames, propertyValue in pairs(self.properties or {}) do
		for _, propertyName in ipairs(string.split(propertyNames, ";")) do
			if propertyValue == "nil" then
				propertyValue = nil
			end

			guiInstance[propertyName] = propertyValue
		end
	end

	for _, child in ipairs(self.children or {}) do
		local childInstance = makeGui(child)
		childInstance.Parent = guiInstance
	end

	return guiInstance
end

function Gui:__init(guiName, guiParent)
	assert(type(guiName) == "string", "Attempt to initialize Gui without valid guiName")

	Preset.__init(self, self.className)

	self.name = guiName
	self.parent = guiParent

	table.insert(allGuis, self)
	self:apply()
end

function Gui:__create()
	local className = self.className

	Preset.__create(self, className, className)
end

function Gui:apply()
	local presetItem = self.presetItem
	local parent = self.parent

	local existingInstance = self.instance

	assert(presetItem, "Attempt to apply Gui without presetItem")

	if existingInstance then
		existingInstance:Destroy()
	end

	local guiInstance = makeGui(presetItem)
	self.instance = guiInstance
	guiInstance.Name = self.name or guiInstance.Name

	if not guiInstance.Parent then
		if parent then
			guiInstance.Parent = parent
		else
			warn("Gui doesn't have parent", self)
		end
	end

	self:call("apply", guiInstance)
end

function Gui:applyAll()
	for _, guiObject in ipairs(self.guis or {}) do
		guiObject:apply()
	end
end

return Gui