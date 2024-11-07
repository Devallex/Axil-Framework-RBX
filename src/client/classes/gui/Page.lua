local Gui = _G("classes.gui.Gui")
local Page = Gui:create("Page")

local pages = {}

function Page:isOpen()
	return pages[#pages] == self
end

function Page:open()
	if pages[#pages] == self then
		warn("Attempt to open alread-open page")
		return
	end
	for _, other in ipairs(pages) do
		other.instance.Visible = false
	end

	table.insert(pages, self)
	self.instance.Visible = true

	self:call("open")
end

function Page:close()
	if pages[#pages] ~= self then
		warn("Attempt to close non-active page")
		return
	end

	table.remove(pages, #pages)
	self.instance.Visible = false

	local newActivePage = pages[#pages]
	if newActivePage then
		newActivePage.instance.Visible = true
	end

	self:call("close")
end

function Page:toggle()
	if self:isOpen() then
		self:close()
	else
		self:open()
	end
end

return Page