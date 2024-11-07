local Page = _G("classes.gui.Page")
local Sidebar = Page:create("Sidebar")

function Sidebar:__init(guiName, guiParent)
	Page.__init(self, guiName, guiParent)

	self.buttons = {}
	self.buttonInstances = {}

	self:on("apply", function(instance)
		table.clear(self.buttonInstances)

		local presetButton = instance:WaitForChild("Content"):WaitForChild("ButtonPreset")

		local activeButton = nil

		for index, data in ipairs(self.buttons) do
			local text = data.text

			local newButton = presetButton:Clone()
			newButton.Name = text
			newButton.Text = text
			newButton.LayoutOrder = index
			newButton.Visible = true
			newButton.Parent = presetButton.Parent

			local callback = data.callback
			newButton.MouseButton1Click:Connect(function()
				if activeButton then
					activeButton:FindFirstChildOfClass("UIStroke").Enabled = false
				end
				activeButton = newButton
				activeButton:FindFirstChildOfClass("UIStroke").Enabled = true
				if callback then
					callback()
				end
			end)

			table.insert(self.buttonInstances, newButton)
		end

		instance.Size = UDim2.new(0.1, 0, (#self.buttons - 1) * 0.15 + 0.2, 10)
	end)
end

function Sidebar:addButton(text, callback)
	local instance = self.instance

	assert(instance, "Attempt to add button without Instance")

	table.insert(self.buttons, {
		text = text,
		callback = callback,
	})

	self:apply()
end

function Sidebar:unselect()
	for _, buttonInstance in self.buttonInstances do
		local buttonStroke = buttonInstance:FindFirstChildOfClass("UIStroke")
		if not buttonStroke then
			continue
		end
		buttonStroke.Enabled = false
	end
end

return Sidebar