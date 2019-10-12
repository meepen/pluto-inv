pluto.tabs = {
	normal = {
		canaccept = function(tabindex, item)
			return true
		end,
		canremove = function(tabindex, item)
			return true
		end,
		size = 36,
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
	equip = {
		canaccept = function(tabindex, item)
			if (tabindex == 1) then -- primary
				local wep = weapons.GetStored(item.ClassName)
				if (not wep) then
					return false
				end

				return wep.Slot == 2
			elseif (tabindex == 2) then -- secondary
				local wep = weapons.GetStored(item.ClassName)
				if (not wep) then
					return false
				end

				return wep.Slot == 3
			end
		end,
		canremove = function(tabindex, item)
			return true
		end,
		size = 2,
		element = "pluto_inventory_equip",
	},
}