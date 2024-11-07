if not game:IsLoaded() then game.Loaded:Wait() end

require(game:GetService("ReplicatedStorage"):WaitForChild("modules"):WaitForChild("resourceModule"))

_G("classes.Replicator")

-- Load in all scripts automatically
local loadedModules = {}
local function loadModule(module)
	if not module then
		return
	end
	if module.Parent == nil or not module:IsA("ModuleScript") or table.find(loadedModules, module) then
		return
	end
	table.insert(loadedModules, module)

	local success, returned = pcall(function()
		return require(module)
	end)

	assert(success, "Error when running module "..tostring(module.Name)..":\n"..tostring(returned))
end

for _, module in script.Parent:GetChildren() do
	loadModule(module)
end
script.Parent.ChildAdded:Connect(function(module)
	loadModule(module)
end)