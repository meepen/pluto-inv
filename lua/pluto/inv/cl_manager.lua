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

pluto.buffer = pluto.buffer or {}

pluto.inv = pluto.inv or {
	status = "uninitialized",
}

function pluto.inv.readmod(item)
	local rolls = {}
	local minsmaxs = {}

	local amt = net.ReadUInt(2)

	for i = 1, amt do
		rolls[i] = net.ReadString()

		minsmaxs[i] = {net.ReadString(), net.ReadString()}
	end

	local name = net.ReadString()
	local tier = net.ReadUInt(4)
	local desc = net.ReadString()

	return {
		Rolls = rolls,
		MinsMaxs = minsmaxs,
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

	local item = pluto.received.item[id] or setmetatable({
		ID = id,
		Version = 0,
		Owner = LocalPlayer():SteamID64(),
	}, pluto.inv.item_mt)

	item.Version = item.Version + 1

	item.ClassName = net.ReadString()
	item.Experience = net.ReadUInt(32)
	if (net.ReadBool()) then
		item.SpecialName = net.ReadString()
	end
	if (net.ReadBool()) then
		item.Nickname = net.ReadString()
	end

	item.Type = pluto.inv.itemtype(item)

	if (item.Type == "Weapon") then
		item.Mods = {
			prefix = {},
			suffix = {},
		}
		item.Tier = net.ReadString()
		item.SubDescription = net.ReadString()
		item.Color = net.ReadColor()

		item.AffixMax = net.ReadUInt(3)
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
	elseif (item.Type == "Model") then
		item.Model = pluto.models[item.ClassName:match "^model_(.+)$"]
		item.Color = item.Model.Color or Color(255, 255, 255)
		item.Name = item.Model.Name .. " Model"
		item.SubDescription = item.Model.SubDescription
	end

	pluto.received.item[id] = item

	hook.Run("PlutoItemUpdate", item)

	return item
end

function pluto.inv.readstatus()
	pluto.inv.status = net.ReadString()

	pprintf("Inventory status = %s", pluto.inv.status)
end

function pluto.inv.readfullupdate()
	pluto.cl_inv = {}
	pluto.buffer = {}
	pluto.cl_currency = {}
	if (IsValid(pluto.ui.pnl)) then
		pluto.ui.pnl:Remove()
	end
	

	for i = 1, net.ReadUInt(32) do
		pluto.inv.readtab()
	end

	for i = 1, net.ReadUInt(32) do
		pluto.inv.readcurrencyupdate()
	end
	
	for i = 1, net.ReadUInt(8) do
		pluto.inv.readbufferitem()
	end

	pluto.inv.readstatus()
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

function pluto.inv.readbufferitem()
	local id = net.ReadInt(32)
	local class = net.ReadString()

	local item = setmetatable({
		BufferID = id,
		ClassName = class
	}, pluto.inv.item_mt)

	item.Type = pluto.inv.itemtype(item)

	if (item.Type == "Weapon") then
		item.Tier = net.ReadString()
		item.Color = net.ReadColor()
		item.Mods = {
			prefix = {},
			suffix = {},
		}

		for i = 1, net.ReadUInt(8) do
			item.Mods.prefix[i] = pluto.inv.readmod()
		end

		for i = 1, net.ReadUInt(8) do
			item.Mods.suffix[i] = pluto.inv.readmod()
		end
	elseif (item.Type == "Model") then
		item.Model = pluto.models[item.ClassName:match "^model_(.+)$"]
		item.Color = item.Model.Color or Color(255, 255, 255)
		item.Name = item.Model.Name .. " Model"
		item.SubDescription = item.Model.SubDescription
	end

	table.insert(pluto.buffer, item)
	if (#pluto.buffer > 5) then
		table.remove(pluto.buffer, 1)
	end
	hook.Run("PlutoBufferChanged")
end

function pluto.inv.writeitemdelete(tabid, tabindex, itemid)
	net.WriteUInt(tabid, 32)
	net.WriteUInt(tabindex, 8)
	net.WriteUInt(itemid, 32)
end

function pluto.inv.writecurrencyuse(currency, item)
	net.WriteString(currency)
	net.WriteBool(not not item)
	if (item) then
		net.WriteUInt(item.ID, 32)
	end
end

function pluto.inv.writetabswitch(tabid1, tabindex1, tabid2, tabindex2)
	local tab1, tab2 = pluto.cl_inv[tabid1], pluto.cl_inv[tabid2]

	tab1.Items[tabindex1], tab2.Items[tabindex2] = tab2.Items[tabindex2], tab1.Items[tabindex1]

	net.WriteUInt(tabid1, 32)
	net.WriteUInt(tabindex1, 8)
	net.WriteUInt(tabid2, 32)
	net.WriteUInt(tabindex2, 8)
end

function pluto.inv.writetabrename(tabid, text)
	net.WriteUInt(tabid, 32)
	net.WriteString(text)

	local tab = pluto.cl_inv[tabid]
	if (tab) then
		tab.Name = text
	end
end

function pluto.inv.writeclaimbuffer(bufferid, tabid, tabindex)
	net.WriteInt(bufferid, 32)
	net.WriteUInt(tabid, 32)
	net.WriteUInt(tabindex, 8)
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