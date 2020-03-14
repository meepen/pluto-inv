pluto.inv.invs = pluto.inv.invs or {}
pluto.inv.items = pluto.inv.items or pluto.itemids or {}
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
pluto.inv.loading = pluto.inv.loading or {}

pluto.inv.sent = pluto.inv.sent or {}

util.AddNetworkString "pluto_inv_data"

function pluto.inv.writemod(ply, item, gun)
	local mod = pluto.mods.byname[item.Mod]
	local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)

	local name = pluto.mods.formataffix(mod.Type, mod.Name)
	local tier = item.Tier
	local tierroll = mod.Tiers[item.Tier] or mod.Tiers[#mod.Tiers]

	net.WriteUInt(#rolls, 2)
	for i, roll in ipairs(rolls) do
		net.WriteString(mod:FormatModifier(i, math.abs(roll), gun.ClassName))
		net.WriteString(mod:FormatModifier(i, tierroll[i * 2 - 1], gun.ClassName))
		net.WriteString(mod:FormatModifier(i, tierroll[i * 2], gun.ClassName))
	end

	net.WriteBool(not not mod.Color)
	if (mod.Color) then
		net.WriteColor(mod.Color)
	end

	net.WriteString(name)
	net.WriteUInt(tier, 4)
	net.WriteString(mod.Description or mod:GetDescription(rolls))
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

		pluto.inv.writebaseitem(ply, item)

		net.WriteBool(item.Locked or false)
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

function pluto.inv.writefullupdate(ply)
	for key, tab in pairs(pluto.inv.invs[ply]) do
		if (not isnumber(key)) then
			continue
		end

		local tabtype = pluto.tabs[tab.Type]

		if (not tabtype or not tabtype.element) then
			continue
		end

		pluto.inv.writetab(ply, tab)
	end
	net.WriteUInt(0, 32)

	net.WriteUInt(table.Count(pluto.inv.currencies[ply]), 32)
	for currency in pairs(pluto.inv.currencies[ply]) do
		pluto.inv.writecurrencyupdate(ply, currency)
	end

	local buffer = pluto.inv.getbufferitems(ply)

	net.WriteUInt(#buffer, 8)
	for i = #buffer, 1, -1 do
		local item = buffer[i]
		pluto.inv.writebufferitem(ply, item)
	end
	
	pluto.inv.writestatus(ply, "ready")
end

function pluto.inv.sendfullupdate(ply)
	if (pluto.inv.loading[ply]) then
		return
	end

	pluto.inv.message(ply)
		:write("status", "retrieving")
		:send()

	pluto.inv.invs[ply] = nil
	pluto.inv.loading[ply] = true

	pluto.inv.init(ply, function()
		pluto.inv.loading[ply] = nil
		hook.Run("PlutoInventoryLoad", ply)
		if (ply:Alive() and ttt.GetRoundState() ~= ttt.ROUNDSTATE_ACTIVE) then
			ply:StripWeapons()
			ply:StripAmmo()
			hook.Run("PlayerLoadout", ply)
		end
		pluto.inv.message(ply):write "fullupdate":send()
	end)
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

function pluto.inv.writebaseitem(ply, item)
	item.Type = item.Type or pluto.inv.itemtype(item)

	net.WriteString(item.ClassName)
	net.WriteUInt(item.Experience or 0, 32)

	if (item.SpecialName) then
		net.WriteBool(true)
		net.WriteString(item:GetPrintName())
	else
		net.WriteBool(false)
	end

	if (item.Nickname) then
		net.WriteBool(true)
		net.WriteString(item.Nickname)
	else
		net.WriteBool(false)
	end

	if (item.Type == "Shard" or item.Type == "Weapon") then
		if (not item.Tier) then
			PrintTable(item)
		end

		net.WriteString(item.Tier.Name)
		net.WriteString(item.Tier:GetSubDescription())
		net.WriteColor(item.Tier.Color or color_white)
		net.WriteUInt(item:GetMaxAffixes(), 3)
	end

	if (item.Type == "Weapon") then
		net.WriteUInt(table.Count(item.Mods), 8)
		for type, mods in pairs(item.Mods) do
			net.WriteString(type)
			net.WriteUInt(#mods, 8)

			for ind, mod in ipairs(mods) do
				pluto.inv.writemod(ply, mod, item)
			end
		end
	end
end

function pluto.inv.writebufferitem(ply, item)
	net.WriteUInt(item.RowID, 32)

	pluto.inv.writebaseitem(ply, item)
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

		if (success == 3) then
			cb(pluto.inv.invs[ply])
		end
	end

	local function InitTabs()
		if (not tabs or not items) then
			return
		end

		local inv = {
			tabs = {},
		}

		for _, tab in pairs(tabs) do
			inv[tab.RowID] = tab
			tab.Items = {}

			inv.tabs[tab.Type] = tab
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

	pluto.quests.init(ply, function(_quests)
		TrySucceed()
	end)
end

function pluto.inv.readtabswitch(ply)
	local tabid1 = net.ReadUInt(32)
	local tabindex1 = net.ReadUInt(8)
	local tabid2 = net.ReadUInt(32)
	local tabindex2 = net.ReadUInt(8)

	if (tabid1 == tabid2 and tabindex1 == tabindex2) then
		return
	end

	local tab1 = pluto.inv.invs[ply][tabid1]
	local tab2 = pluto.inv.invs[ply][tabid2]

	if (not tab1 or not tab2) then
		pluto.inv.sendfullupdate(ply)
		return
	end

	local canswitch, fail = pluto.canswitchtabs(tab1, tab2, tabindex1, tabindex2)

	if (not canswitch) then
		pluto.inv.sendfullupdate(ply)
		return
	end

	local i1, i2 = tab1.Items[tabindex1], tab2.Items[tabindex2]

	if (i1 and ply:SteamID64() ~= i1.Owner or i2 and i2.Owner ~= ply:SteamID64()) then
		pluto.inv.sendfullupdate(ply)
		return
	end

	tab1.Items[tabindex1], tab2.Items[tabindex2] = i2, i1

	if (i1) then
		i1.TabID, i1.TabIndex = tabid2, tabindex2
	end

	if (i2) then
		i2.TabID, i2.TabIndex = tabid1, tabindex1
	end

	local equip
	if (tab1.Type == "equip") then
		equip = tab1
	elseif (tab2.Type == "equip") then
		equip = tab2
	end

	if (equip) then
		timer.Simple(0, function()
			if (IsValid(ply) and ply:Alive() and ttt.GetRoundState() ~= ttt.ROUNDSTATE_ACTIVE) then
				ply:StripWeapons()
				ply:StripAmmo()
				hook.Run("PlayerLoadout", ply)
			end
		end)
	end

	pluto.inv.switchtab(ply, tabid1, tabindex1, tabid2, tabindex2, function(succ)
		if (succ or not IsValid(ply)) then
			return
		end

		pluto.inv.sendfullupdate(ply)
	end):Run()
end

function pluto.inv.readitemdelete(ply)
	local tabid = net.ReadUInt(32)
	local tabindex = net.ReadUInt(8)
	local itemid = net.ReadUInt(32)

	local tab = pluto.inv.invs[ply][tabid]

	if (not tab) then
		pluto.inv.sendfullupdate(ply)
		return
	end

	if (not tab.Items[tabindex]) then
		pluto.inv.sendfullupdate(ply)
		return
	end

	local i = tab.Items[tabindex]

	if (i.RowID ~= itemid) then
		pluto.inv.sendfullupdate(ply)
		return
	end
	
	tab.Items[tabindex] = nil

	pluto.inv.deleteitem(ply, itemid, function(succ)
		if (succ) then
			if (IsValid(ply)) then
				if (i.Type == "Weapon" and i.Tier.InternalName ~= "crafted" and math.random() < 1 / 2) then
					pluto.inv.generatebuffershard(ply, i.Tier.InternalName):Run()
				end
			end
			return
		end

		pluto.inv.sendfullupdate(ply)
	end)
end

local function allowed(types, wpn)
	if (wpn and wpn.Locked) then
		return false
	end

	local type = wpn and wpn.Type or "None"
	if (isstring(types)) then
		return types == type
	end

	if (istable(types) and table.HasValue(types, type)) then
		return true
	end

	return false
end

function pluto.inv.readcurrencyuse(ply)
	local currency = net.ReadString()
	local wpn
	if (net.ReadBool()) then
		local id = net.ReadUInt(32)

		wpn = pluto.inv.items[id]

		if (not wpn or wpn.Owner ~= ply:SteamID64()) then
			return
		end
	end

	local amount = pluto.inv.currencies[ply]
	if (not amount) then
		return
	end

	amount = amount[currency]

	if (not amount or amount < 1) then
		return
	end

	local cur = pluto.currency.byname[currency]

	if (not allowed(cur.Types, wpn) or wpn and wpn:ShouldPreventChange()) then
		return
	end

	cur.Use(ply, wpn)
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
	local bufferid = net.ReadUInt(32)
	local tabid = net.ReadUInt(32)
	local tabindex = net.ReadUInt(8)

	local i = pluto.inv.getbufferitem(ply, bufferid)

	if (not i) then
		pprintf "ERROR: no i"
		pluto.inv.sendfullupdate(ply)
		return
	end

	if (i.Owner ~= ply:SteamID64()) then
		pprintf "ERROR: Owner not equal"
		pluto.inv.sendfullupdate(ply)
		return
	end

	local can, err = pluto.canswitchtabs({
		ID = 0,
		Items = {i},
	}, pluto.inv.invs[ply][tabid], 1, tabindex)

	if (not can) then
		pprintf "ERROR: not can"
		pluto.inv.sendfullupdate(ply)
		return
	end

	local pop_from = i.TabIndex

	local transact = pluto.inv.setitemplacement(ply, i, tabid, tabindex, function(succ)
		if (succ or not IsValid(ply)) then
			if (IsValid(ply)) then
				pluto.inv.message(ply)
					:write("tabupdate", i.TabID, i.TabIndex)
					:send()
			end
			return
		end

		pprintf "ERROR: bad err"
		pluto.inv.sendfullupdate(ply)
	end)

	if (not pluto.inv.popbuffer(ply, pop_from, transact)) then
		pprintf "ERROR: no pop"
		pluto.inv.sendfullupdate(ply)
		return
	end

	transact:Run()
	transact:AddCallback(function(err)
		if (err) then
			return
		end

		for i, item in pairs(pluto.inv.invs[ply].tabs.buffer.Items) do
			if (item == i) then
				table.remove(pluto.inv.invs[ply].tabs.buffer.Items, i)
			end
		end
	end)
end

function pluto.inv.readend()
	return true
end

function pluto.inv.writecrate_id(ply, id)
	net.WriteInt(id, 32)
end

function pluto.inv.writeexpupdate(cl, item)
	net.WriteUInt(item.RowID, 32)
	net.WriteUInt(item.Experience, 32)
end

function pluto.inv.writeitemlock(ply, itemid, locked)
	net.WriteUInt(itemid, 32)
	net.WriteBool(locked)
end

function pluto.inv.readitemlock(ply)
	local itemid = net.ReadUInt(32)

	local wpn = pluto.inv.items[itemid]

	if (not wpn) then
		pluto.inv.sendfullupdate(ply)
		return
	end

	wpn.Locked = not wpn.Locked

	pluto.inv.lockitem(ply, itemid, wpn.Locked, function(succ)
		if (IsValid(ply)) then
			if (succ) then
				pluto.inv.message(ply)
					:write("itemlock", itemid, wpn.Locked)
					:send()
				return
			end

			pluto.inv.sendfullupdate(ply)
		end
	end)
end

hook.Add("PlayerAuthed", "pluto_init_inventory", pluto.inv.sendfullupdate)