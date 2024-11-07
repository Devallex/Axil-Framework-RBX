-- Initialize the resourceModule
require(game:GetService("ReplicatedStorage"):WaitForChild("modules"):WaitForChild("resourceModule"))

-- Do other stuff here, such as requiring other scripts.
-- _G("scripts.somethingManager")

-- Run the example scripts
_G("scripts.examples.worldManager")
_G("scripts.examples.inventoryManager")