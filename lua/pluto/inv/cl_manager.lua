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
pluto.cl_currency = pluto.cl_currency or {}

pluto.received = pluto.received or {
	item = {},
}

pluto.inv = pluto.inv or {
	status = "uninitialized",
}

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

	local item = pluto.received.item[id] or {
		ID = id,
		Mods = {
			prefix = {},
			suffix = {},
		},
		Version = 0,
	}

	item.Version = item.Version + 1

	item.Tier = net.ReadString()
	item.Color = net.ReadColor()

	item.ClassName = net.ReadString()

	for k in pairs(item.Mods.prefix) do
		item.Mods.prefix[k] = nil
	end

	for k in pairs(item.Mods.suffix) do
		item.Mods.suffix[k] = nil
	end

	for i = 1, net.ReadUInt(8) do
		item.Mods.prefix[i] = pluto.inv.readmod()
	end

	for i = 1, net.ReadUInt(8) do
		item.Mods.suffix[i] = pluto.inv.readmod()
	end

	PrintTable(item)

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
	tab.Type = net.ReadString()
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

function pluto.inv.readcurrencyupdate(ply)
	local currency = net.ReadString()
	local amt = net.ReadUInt(32)
	pluto.cl_currency[currency] = amt
end

function pluto.inv.readtabupdate()
	local tabid = net.ReadUInt(32)
	local tabindex = net.ReadUInt(8)

	local item
	if (net.ReadBool()) then
		item = pluto.inv.readitem()
	end
	pluto.cl_inv[tabid].Items[tabindex] = item

	hook.Run("PlutoTabUpdate", tabid, tabindex, item)
end

function pluto.inv.writeitemdelete(tabid, tabindex, itemid)
	net.WriteUInt(tabid, 32)
	net.WriteUInt(tabindex, 8)
	net.WriteUInt(itemid, 32)
end

function pluto.inv.writecurrencyuse(currency, item)
	net.WriteString(currency)
	net.WriteUInt(item.ID, 32)
end

function pluto.inv.writetabswitch(tabid1, tabindex1, tabid2, tabindex2)
	local tab1, tab2 = pluto.cl_inv[tabid1], pluto.cl_inv[tabid2]

	tab1.Items[tabindex1], tab2.Items[tabindex2] = tab2.Items[tabindex2], tab1.Items[tabindex1]

	net.WriteUInt(tabid1, 32)
	net.WriteUInt(tabindex1, 8)
	net.WriteUInt(tabid2, 32)
	net.WriteUInt(tabindex2, 8)
end

function pluto.inv.writeend()
end

function pluto.inv.send(what, ...)
	local id = pluto.inv.messages.cl2sv[what]

	if (not id) then
		pwarnf("id = nil for %s\n%s", what, debug.traceback())
		return
	end

	net.WriteUInt(id, 8)
	local fn = pluto.inv["write" .. what]
	fn(...)
end

function pluto.inv.readend()
	return true
end