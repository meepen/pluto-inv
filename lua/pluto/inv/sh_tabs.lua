pluto.tabs = {
	normal = {
		canaccept = function(tabindex, item)
			return true
		end,
		canremove = function(tabindex, item)
			return true
		end,
		size = 64,
	},
	currency = {
		canaccept = function(tabindex, item)
			return false
		end,
		canremove = function(tabindex, item)
			return false
		end,
		size = 0,
	},
}