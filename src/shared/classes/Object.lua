-- An abstract class which inherits from Replicators. Contains an instance (cloned) model, and a base (original) model as attributes.

local RunService = game:GetService("RunService")

local Preset = _G("classes.Preset")
local Object = Preset:create("Object")

function Object:__init(...)
	Preset.__init(self, ...)

	self.model = nil
	self.baseModel = nil

	self:on("replicated", function()
		self:onServer("newModel", function(newModel)
			self.model = newModel
		end)
		
		self:onServer("destroy", function()
			self:destroy()
		end)
	end)
end

function Object:getBaseModel()
	local baseModel = self.baseModel

	local id = self.baseModelId or self.id
	if not baseModel then
		if id then
			baseModel = _G("assets."..self.className):FindFirstChild(id)
		else
			warn("Object missing id and baseModelId", self)
		end
	end

	if not baseModel then
		warn("Object missing baseModel", self)
		baseModel = _G("assets.missing")
	end

	return baseModel
end

function Object:getModel(parent)
	local model = self.model
	if model then
		return model
	end
	if not RunService:IsServer() and self.replication then
		repeat task.wait() until self.model
		return self.model
	end

	local baseModel = self:getBaseModel()

	model = baseModel:Clone()
	model:PivotTo(CFrame.new())
	if parent then
		model.Parent = parent
	end
	self.model = model

	self:call("newModel", model)

	return model
end

function Object:destroy()
	if self.model then
		self.model:Destroy()
		self.model = nil
	end
	self:call("destroy")
end

function Object:setModel(newId)
	local pivot = nil
	local parent = nil
	if self.model then
		pivot = self.model:GetPivot()
		parent = self.model.Parent
	end

	self.baseModelId = newId
	local id = self.baseModelId or self.id

	assert(_G("assets."..self.className), "Attempt to set Object model without assets folder: " .. tostring(id))

	local newModel = _G("assets."..self.className):WaitForChild(id, 5)
	assert(newModel, "Attempt to swap model without new model")
	newModel = newModel:Clone()

	if pivot then
		newModel:PivotTo(pivot)
	end
	if parent then
		newModel.Parent = parent
	end
	self.model = newModel

	self:call("newModel", newModel)
end

function Object:waitForPrimaryPart()
	local model = self:getModel()

	assert(model, "Attempt to waitForPrimaryPart without model")

	repeat task.wait() until model.PrimaryPart

	return model.PrimaryPart
end

return Object