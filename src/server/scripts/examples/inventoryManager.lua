local inventoryManager = {}

local Players = game:GetService("Players")

local Container = _G("classes.examples.inventory.Container")

Players.PlayerAdded:Connect(function(player)
	local inventory = Container(player.Name.."'s Backpack")
	inventory:setOwner(player)
end)

return inventoryManager