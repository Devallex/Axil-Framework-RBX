local preset = {
	id = "baseItem",
	tasty = 0,
	useful = 0,
	canLegallyHitSomeoneWithIt = false,

	subClasses = {
		["baseFood"] = {
			tasty = 80,
			subClasses = {
				["Pizza"] = {
					tasty = 95
				}
			}
		},
		["baseTool"] = {
			useful = 80,
			subClasses = {
				["Pickaxe"] = {
					useful = 85,
					-- canLegallyHitSomeoneWithIt is automatically false, because it inherits false from baseItem
				},
				["Hammer"] = {
					useful = 90,
					subClasses = { -- Can go forever deep in inheritance
						["Ban-Hammer"] = {
							displayName = "Ban Hammuh", -- Instead of using the ID, use this as what is shown (in your code, do `self.displayName or self.id`)
							canLegallyHitSomeoneWithIt = true,
						}
					}
				}
			}
		}
	}
}

return preset