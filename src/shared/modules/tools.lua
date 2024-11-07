local tools = {}

-- Inheritance
function tools.inherit(from, to)
	local metatableFrom = getmetatable(from) or {}
	local metatableTo = getmetatable(to) or {}

	local finalMetatable = {}
	for key, value in pairs(metatableFrom) do
		finalMetatable[key] = value
	end
	for key, value in pairs(metatableTo) do
		finalMetatable[key] = value
	end

	-- Extends the current __index function, if any
	local originalIndex = rawget(finalMetatable, "__index")
	function finalMetatable:__index(index) -- Values are inherited via __index, not via cloning
		-- Patching previous __index
		local value = from[index]
		if value ~= nil then
			return value
		end

		if type(originalIndex) == "table" then
			value = rawget(originalIndex, index)
		elseif type(originalIndex) == "function" then
			value = originalIndex(self, index)
		end

		return value
	end

	setmetatable(to, finalMetatable)
end

function tools.inheritMultiple(fromMultiple, to)
	for _, from in ipairs(fromMultiple) do
		tools.inherit(from, to)
	end
end

-- Tables
function tools.deepCopy(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[tools.deepCopy(orig_key, copies)] = tools.deepCopy(orig_value, copies)
			end
			setmetatable(copy, tools.deepCopy(getmetatable(orig), copies))
		end
	else
		copy = orig
	end
	return copy
end

function tools.expandTable(object, allTables) --Turns a table into a list of all the sub tables
	allTables = allTables or {}

	if type(object) ~= "table" then
		return
	end
	if table.find(allTables, object) then
		return
	end

	table.insert(allTables, object)

	for key, value in pairs(object) do
		tools.expandTable(key, allTables)
		tools.expandTable(value, allTables)
	end

	return allTables
end

function tools.respectClone(object, allObjects)
	if type(object) ~= "table" then
		return object
	end

	allObjects = allObjects or {}
	if allObjects[object] then
		return allObjects[object]
	else
		allObjects[object] = table.clone(object)
		object = allObjects[object]
	end

	for key, value in pairs(object) do
		object[tools.respectClone(key, allObjects)] = tools.respectClone(value, allObjects)
	end

	return object
end

local function deepFilter(object, callback, objects)
	if table.find(objects, object) then
		return
	end

	callback(object)

	if type(object) ~= "table" then
		return
	end
	table.insert(objects, object)

	for key, value in pairs(object) do
		deepFilter(key, callback, objects)
		deepFilter(value, callback, objects)
	end
end
function tools.deepFilter(object, callback)
	deepFilter(object, callback, {})
end

function tools.deepContains(object, target)
	local targetFound = false

	tools.deepFilter(object, function(value)
		targetFound = targetFound or value == target

		return value
	end)

	return targetFound
end

return tools