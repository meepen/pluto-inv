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

				return wep.Slot == 1
			end
		end,
		canremove = function(tabindex, item)
			return true
		end,
		size = 2,
		element = "pluto_inventory_equip",
	},
}

function pluto.canswitchtabs(tab1, tab2, tabindex1, tabindex2)
	if (not tab1 or not tab2) then
		ply:Kick "tab switch failed (1) report to meepen on discord"
		return false, "no tab"
	end

	if (not tab1.Items and not tab2.Items) then
		return false, "buffer"
	end

	local i1 = tab1.Items and tab1.Items[tabindex1]
	local i2 = tab2.Items and tab2.Items[tabindex2]

	if (not i1 and not i2) then
		return false, "no item"
	end

	local tabtype1 = pluto.tabs[tab1.Type]
	local tabtype2 = pluto.tabs[tab2.Type]

	if (not tabtype1 and not tabtype2) then
		return false, "no tab types"
	end

	if (i1 and (tabtype1 and not tabtype1.canremove(tabindex1, i1) or tabtype2 and not tabtype2.canaccept(tabindex2, i1))) then
		return false, "item1"
	end

	if (i2 and (tabtype2 and not tabtype2.canremove(tabindex2, i2) or tabtype1 and not tabtype1.canaccept(tabindex1, i2))) then
		return false, "item2"
	end

	if (tabtype2 and tabindex2 < 1 or tabindex2 > tabtype2.size) then
		return false, "tab2.size"
	end

	if (tabtype1 and (tabindex1 < 1 or tabindex1 > tabtype1.size)) then
		return false, "tab1.size"
	end
	
	return true
end