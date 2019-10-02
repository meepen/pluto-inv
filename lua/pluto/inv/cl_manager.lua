pluto.cl_inv = pluto.cl_inv or {}
--[[
	{
		[tabid] = {
			Name = string,
			Color = uint32,
			Items = {
				-- 64 items
			},
		}
	}
]]

pluto.received = {
	item = {},
}

net.Receive("pluto_inv_data", function(len)
	pprintf("Collecting %i bits of inventory data...", len)

	while (not pluto.inv.readmessage()) do
		print "Message read."
	end
end)

pluto.inv = pluto.inv or {
	status = "uninitialized",
}

function pluto.inv.readmessage()
	local uid = net.ReadUInt(8)
	local id = pluto.inv.messages.sv2cl[uid]

	if (id == "end") then
		pluto.inv.readend()
		return true
	end

	local fn = pluto.inv["read" .. id]

	if (not fn) then
		pwarnf("no function for %i", uid)
		return false
	end

	fn()
end

function pluto.inv.readmod(item)
	local name = net.ReadString()
	local tier = net.ReadUInt(4)
	local desc = net.ReadString()
	return {
		Name = name,
		Tier = tier,
		Desc = desc
	}
end

function pluto.inv.readitem()
	local id = net.ReadUInt(32)

	if (not net.ReadBool()) then
		return pluto.received.item[id]
	end

	local item = {
		ID = id,
		Tier = net.ReadString(),
		Mods = {
			suffix = {},
			prefix = {},
		}
	}

	for i = 1, net.ReadUInt(8) do
		item.Mods.prefix[i] = pluto.inv.readmod()
	end

	for i = 1, net.ReadUInt(8) do
		item.Mods.suffix[i] = pluto.inv.readmod()
	end

	pluto.received.item[id] = item

	return item
end

function pluto.inv.readstatus()
	pluto.inv.status = net.ReadString()

	pprintf("Inventory status = %s", pluto.inv.status)
end

function pluto.inv.readtab()
	local id = net.ReadUInt(32)
	local tab = pluto.cl_inv[id]
	if (not tab) then		
		tab = {
			ID = id,
			Name = "???",
			Color = color_white,
			Items = {}
		}
		pluto.cl_inv[id] = tab
	end

	tab.Name = net.ReadString()
	local col = net.ReadUInt(24)
	local r = bit.band(bit.rshift(col, 16), 0xff)
	local g = bit.band(bit.rshift(col, 8), 0xff)
	local b = bit.band(col, 0xff)
	tab.Color = Color(r, g, b)

	for i = 1, net.ReadUInt(8) do
		local tabindex = net.ReadUInt(8)
		local item = pluto.inv.readitem()
		tab.Items[tabindex] = item
	end
end

function pluto.inv.readend()
	pluto.inv.status = "ready"
	pprintf("Inventory ready.")
	return true
end