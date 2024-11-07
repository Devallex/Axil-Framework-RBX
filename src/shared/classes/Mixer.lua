local Emitter = _G("classes.Emitter")
local Mixer = Emitter:create("Mixer")

local config = _G("config.classes.Mixer")

function Mixer:__init()
	self.inputs, self.outputs, self.parameters, self.functions = {}, {}, {}, table.clone(config.DEFAULT_FUNCTIONS)
end

-- Calculations
function Mixer:update()
	for name, expression in pairs(self.parameters) do
		-- Replace outputs (reusing last value)

		-- Replace inputs
		for variableDefinition in expression:gmatch("%$") do
			local variableName = variableDefinition:match("%a")
			expression = expression:gmatch()
		end

		-- Replace functions
		for functionCall in expression:gmatch("!%a*%(.*%)") do
			local functionName = functionCall:match("!(%a*)%(")
			local functionParameters = functionCall:match("%((.*)%)")
			local actualParamaters = {}
			for functionParamater in functionParameters:gmatch("(%d*),?") do
				local actualParamater = tonumber(functionParamater)
				if actualParamater then
					table.insert(actualParamaters, actualParamater)
				end
			end
			local actualFunction = self.functions[functionName]
			local actualValue = actualFunction(table.unpack(actualParamaters))
			expression = expression:gmatch(functionCall, tostring(actualValue), 1)
		end
	end
end

function Mixer:setParameter(name, expression)
	self.parameters[name] = expression
end

function Mixer:setFunction(name, callback)
	self.functions[name] = callback
end

-- Inputs
function Mixer:setInput(key, value)
	self.inputs[key] = value
end

function Mixer:setInputs(values)
	for key, value in pairs(values) do
		self:setInput(key, value)
	end
end

function Mixer:getInput(key)
	return self.inputs[key]
end

-- Outputs
function Mixer:getOutput(key)
	return self.outputs[key]
end

return Mixer
