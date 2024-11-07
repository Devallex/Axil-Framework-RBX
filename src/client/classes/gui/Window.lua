local Page = _G("classes.gui.Page")
local Window = Page:create("Window")

function Window:__init(guiName, guiParent)
	Page.__init(self, guiName, guiParent)

	local instance = self.instance

	local title = instance:FindFirstChild("Title")
	if title then
		title.Text = guiName
	else
		warn("No title found in Window")
	end

	local closeButton = instance:FindFirstChild("Close")
	if closeButton then
		closeButton.MouseButton1Click:Connect(function()
			self:close()
		end)
	else
		warn("No close button found in Window")
	end
end

return Window