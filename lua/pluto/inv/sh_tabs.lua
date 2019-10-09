pluto.tabs = {
	normal = {
		canaccept = function(tabindex, item)
			return true
		end,
		canremove = function(tabindex, item)
			return true
		end,
		size = 64,
		element = "pluto_inventory_items",
	},
	currency = {
		canaccept = function(tabindex, item)
			return false
		end,
		canremove = function(tabindex, item)
			return false
		end,
		size = 0,
		element = "pluto_inventory_currencies",
	},
}