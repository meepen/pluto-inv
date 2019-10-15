pluto.inv.invs = pluto.inv.invs or {}
pluto.inv.items = pluto.inv.items or {}
--[[
	{
		[ply] = {
			[tabid] = {
				RowID = uint32,
				Name = string,
				Items = {[tabindex] = item},
			}
		},
	}
]]

pluto.inv.currencies = pluto.inv.currencies or {}

pluto.inv.sent = pluto.inv.sent or {}

util.AddNetworkString "pluto_inv_data"

function pluto.inv.writemod(ply, item, gun)
	local mod = pluto.mods.byname[item.Mod]
	local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)

	local name = pluto.mods.formataffix(mod.Type, mod.Name)
	local tier = item.Tier
	local desc = mod:GetDescription(rolls, gun.ClassName)

	net.WriteString(name)
	net.WriteUInt(tier, 4)
	net.WriteString(desc)
end

function pluto.inv.writeitem(ply, item)
	net.WriteUInt(item.RowID, 32)

	if (not pluto.inv.sent[ply]) then
		pluto.inv.sent[ply] = {}
	end

	local sent = pluto.inv.sent[ply].items

	if (not sent) then
		sent = {}
		pluto.inv.sent[ply].items = sent
	end


	local data = sent[item.RowID]
	if (not data or data ~= item.LastUpdate) then
		sent[item.RowID] = item.LastUpdate
		net.WriteBool(true)

		net.WriteString(item.Tier.Name)
		net.WriteColor(item.Tier.Color or color_white)
		net.WriteString(item.ClassName)

		if (item.Mods.prefix) then
			net.WriteUInt(#item.Mods.prefix, 8)
			for ind, mod in ipairs(item.Mods.prefix) do
				pluto.inv.writemod(ply, mod, item)
			end
		else
			net.WriteUInt(0, 8)
		end

		if (item.Mods.suffix) then
			net.WriteUInt(#item.Mods.suffix, 8)
			for ind, mod in ipairs(item.Mods.suffix) do
				pluto.inv.writemod(ply, mod, item)
			end
		else
			net.WriteUInt(0, 8)
		end
	else
		net.WriteBool(false)
	end
end

function pluto.inv.send(ply, what, ...)
	local id = pluto.inv.messages.sv2cl[what]
	if (not id) then
		pwarnf("id = nil for %s\n%s", what, debug.traceback())
		return
	end

	net.WriteUInt(id, 8)
	local fn = pluto.inv["write" .. what]
	fn(ply, ...)
end

function pluto.inv.writestatus(ply, str)
	net.WriteString(str)
end

function pluto.inv.writeend()
end

function pluto.inv.writetab(ply, tab)
	net.WriteUInt(tab.RowID, 32)
	net.WriteString(tab.Name)
	net.WriteString(tab.Type)
	net.WriteUInt(tab.Color, 24) -- rgb8

	net.WriteUInt(table.Count(tab.Items), 8)

	for _, item in pairs(tab.Items) do
		net.WriteUInt(item.TabIndex, 8)
		pluto.inv.writeitem(ply, item)
	end
end

function pluto.inv.sendfullupdate(ply)
	if (not pluto.inv.invs[ply]) then
		pluto.inv.message(ply)
			:write("status", "retrieving")
			:send()
		pluto.inv.init(ply, function()
			pluto.inv.sendfullupdate(ply)
		end)

		return
	end

	local m = pluto.inv.message(ply)
		
	for _, tab in pairs(pluto.inv.invs[ply]) do
		m:write("tab", tab)
	end

	for currency in pairs(pluto.inv.currencies[ply]) do
		m:write("currencyupdate", currency)
	end

	for _, item in ipairs(pluto.inv.getbufferitems(ply)) do
		m:write("bufferitem", item)
	end
	
	m:write("status", "ready"):send()
end

function pluto.inv.writetabupdate(ply, tabid, tabindex)
	local tab = pluto.inv.invs[ply][tabid]

	local item = tab.Items[tabindex]

	net.WriteUInt(tabid, 32)
	net.WriteUInt(tabindex, 8)

	if (item) then
		net.WriteBool(true)
		pluto.inv.writeitem(ply, item)
	else
		net.WriteBool(false)
	end
end

function pluto.inv.writecurrencyupdate(ply, currency)
	net.WriteString(currency)
	net.WriteUInt(pluto.inv.currencies[ply][currency], 32)
end

function pluto.inv.writebufferitem(ply, item)
	net.WriteInt(item.BufferID, 32)

	net.WriteString(item.Tier.Name)
	net.WriteColor(item.Tier.Color or color_white)
	net.WriteString(item.ClassName)

	if (item.Mods.prefix) then
		net.WriteUInt(#item.Mods.prefix, 8)
		for ind, mod in ipairs(item.Mods.prefix) do
			pluto.inv.writemod(ply, mod, item)
		end
	else
		net.WriteUInt(0, 8)
	end

	if (item.Mods.suffix) then
		net.WriteUInt(#item.Mods.suffix, 8)
		for ind, mod in ipairs(item.Mods.suffix) do
			pluto.inv.writemod(ply, mod, item)
		end
	else
		net.WriteUInt(0, 8)
	end
end

local function noop() end

function pluto.inv.init(ply, cb2)
	local function cb(success, reason)
		local realcb = cb2
		cb2 = noop

		if (not success and IsValid(ply)) then
			ply:Kick("Couldn't init inventory: " .. reason)
		end

		return realcb(success)
	end

	if (pluto.inv.invs[ply]) then
		return cb(false)
	end

	local tabs, items

	local success = 0
	local function TrySucceed()
		success = success + 1
		if (not IsValid(ply)) then
			return cb(false, "disconnected")
		end

		if (success == 2) then
			cb(pluto.inv.invs[ply])
		end
	end

	local function InitTabs()
		if (not tabs or not items) then
			return
		end

		local inv = {}

		for _, tab in pairs(tabs) do
			inv[tab.RowID] = tab
			tab.Items = {}
		end

		for _, item in pairs(items) do
			local tab = inv[item.TabID]
			tab.Items[item.TabIndex] = item
			pluto.inv.items[item.RowID] = item
			item.Owner = ply:SteamID64()
		end

		pluto.inv.invs[ply] = inv

		TrySucceed()
	end

	pluto.inv.retrievetabs(ply, function(_tabs)
		if (not _tabs) then
			return cb(false, "tabs")
		end

		tabs = _tabs

		InitTabs()
	end)

	pluto.inv.retrieveitems(ply, function(_items)
		if (not _items) then
			return cb(false, "items")
		end

		items = _items

		InitTabs()
	end)

	pluto.inv.retrievecurrency(ply, function(currencies)
		if (not currencies) then
			return cb(false, "currency")
		end

		for name in pairs(pluto.currency.byname) do
			if (not currencies[name]) then
				currencies[name] = 0
			end
		end

		pluto.inv.currencies[ply] = currencies

		TrySucceed()
	end)
end

function pluto.inv.readtabswitch(ply)
	local tabid1 = net.ReadUInt(32)
	local tabindex1 = net.ReadUInt(8)
	local tabid2 = net.ReadUInt(32)
	local tabindex2 = net.ReadUInt(8)

	local tab1 = pluto.inv.invs[ply][tabid1]
	local tab2 = pluto.inv.invs[ply][tabid2]

	local canswitch, fail = pluto.canswitchtabs(tab1, tab2, tabindex1, tabindex2)

	if (not canswitch) then
		ply:Kick("tab switch failed (" .. fail .. ") report to meepen on discord")
		return
	end

	pluto.inv.switchtab(ply, tabid1, tabindex1, tabid2, tabindex2, function(succ)
		if (not succ and IsValid(ply)) then
			ply:Kick "tab switch failed (save) report to meepen on discord"
		end
	end)
end

function pluto.inv.readitemdelete(ply)
	local tabid = net.ReadUInt(32)
	local tabindex = net.ReadUInt(8)
	local itemid = net.ReadUInt(32)

	local tab = pluto.inv.invs[ply][tabid]

	if (not tab) then
		ply:Kick "no tab"
		return
	end

	if (not tab.Items[tabindex]) then
		ply:Kick "Tried to delete an item that wasn't there."
		return
	end

	local i = tab.Items[tabindex]

	if (i.RowID ~= itemid) then
		ply:Kick "Prevented you from deleting the wrong item Report to meepen."
		return
	end
	
	pluto.inv.deleteitem(ply, itemid, function(succ)
		if (not succ) then
			ply:Kick "Couldn't delete item."
			return
		end

		tab.Items[tabindex] = nil
	end)
end

function pluto.inv.readcurrencyuse(ply)
	local currency = net.ReadString()
	local wpn
	if (net.ReadBool()) then
		local id = net.ReadUInt(32)

		local amount = pluto.inv.currencies[ply][currency]
		if (not amount or amount <= 0) then
			return
		end

		local wpn = pluto.inv.items[id]

		if (not wpn or wpn.Owner ~= ply:SteamID64()) then
			return
		end
	end

	pluto.currency.byname[currency].Use(ply, wpn)
end

function pluto.inv.readtabrename(ply)
	local id = net.ReadUInt(32)
	local name = net.ReadString()

	if (utf8.len(name) > 16) then
		return
	end

	local inv = pluto.inv.invs[ply]

	if (not inv) then
		return
	end

	local tab = inv[id]
	if (not tab) then
		return
	end

	tab.Name = name

	pluto.inv.renametab(tab, function() end)
end

function pluto.inv.readclaimbuffer(ply, bufferid, tabid, tabindex)
	local bufferid = net.ReadInt(32)
	local tabid = net.ReadUInt(32)
	local tabindex = net.ReadUInt(8)

	local i = pluto.inv.getbufferitem(bufferid)

	if (not i) then
		ply:Kick "no buffer item"
		return
	end

	if (i.Owner ~= ply:SteamID64()) then
		ply:Kick "NO"
		return
	end

	local can, err = pluto.canswitchtabs({
		ID = 0,
		Items = {i},
	}, pluto.inv.invs[ply][tabid], 1, tabindex)

	if (not can) then
		ply:Kick("cannot receive buffer item: " .. err)
		return
	end

	i.TabID, i.TabIndex = tabid, tabindex

	print "saving"

	pluto.weapons.save(i, ply, function(id)
		if (not id) then
			ply:Kick("error claiming gun")
			return
		end

		sql.Query("DELETE FROM pluto_items WHERE idx = " .. SQLStr(i.BufferID))
	end)
end

function pluto.inv.readend()
	return true
end

hook.Add("PlayerAuthed", "pluto_init_inventory", pluto.inv.sendfullupdate)