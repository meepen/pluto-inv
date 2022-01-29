--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
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

local function WriteIfExists(mod, key)
	local data = mod[key]
	if (data) then
		net.WriteBool(true)

		local typ = type(data)

		if (typ == "function") then
			net.WriteUInt(0, 4)
			net.WriteFunction(data)
		elseif (typ == "string") then
			net.WriteUInt(1, 4)
			net.WriteString(data)
		elseif (IsColor(data)) then
			net.WriteUInt(2, 4)
			net.WriteColor(data)
		else
			net.WriteUInt(3, 4)
		end
	else
		net.WriteBool(false)
	end
end

function pluto.inv.writemod(ply, item, gun)
	net.WriteString(item.Mod)

	local tier = item.Tier

	net.WriteUInt(item.Tier, 4)
	net.WriteUInt(#item.Roll, 4)

	for _, roll in ipairs(item.Roll) do
		net.WriteFloat(roll)
	end
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
		net.WriteString(item.OriginalOwner or "0")
		net.WriteString(item.OriginalOwnerName or "[unknown]")
		net.WriteString(item.CreationMethod or "UNKNOWN")
		net.WriteString(item.Owner or "0")
		net.WriteBool(item.Untradeable)

		if (item.constellations) then
			net.WriteBool(true)
			pluto.inv.writeconstellations(ply, item.constellations)
		else
			net.WriteBool(false)
		end

		if (item.TabID) then
			net.WriteBool(true)
			net.WriteUInt(item.TabID, 32)
			net.WriteUInt(item.TabIndex, 32)
		else
			net.WriteBool(false)
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
	net.WriteString(tab.Shape)
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

		if (not tabtype) then
			continue
		end

		pluto.inv.writetab(ply, tab)
	end
	net.WriteUInt(0, 32)

	net.WriteUInt(table.Count(pluto.inv.currencies[ply]), 32)
	for currency in pairs(pluto.inv.currencies[ply]) do
		pluto.inv.writecurrencyupdate(ply, currency)
	end

	pluto.inv.writestatus(ply, "ready")
end

function pluto.inv.sendfullupdate(ply)
	if (pluto.inv.loading[ply]) then
		pwarnf("Player inventory already loading: %s", ply:Nick())
		return
	end

	pluto.inv.message(ply)
		:write("status", "retrieving")
		:send()

	pluto.inv.invs[ply] = nil
	pluto.inv.loading[ply] = true

	pluto.message("INV", "Loading ", ply, "'s inventory")

	pluto.inv.init(ply, function()
		pluto.inv.loading[ply] = nil
		pluto.message("INV", "Loaded ", ply, "'s inventory")
		hook.Run("PlutoInventoryLoad", ply)
		if (ply:Alive() and ttt.GetRoundState() ~= ttt.ROUNDSTATE_ACTIVE) then
			ply:StripWeapons()
			ply:StripAmmo()
			hook.Run("PlayerLoadout", ply)
		end
		pluto.inv.message(ply)
			:write "fullupdate"
			:write "emojis"
			:send()
	end)
end

concommand.Add("pluto_fullupdate", function(ply, cmd, args)
	if (not pluto.cancheat(ply) or (ply.LastFullUpdate or -math.huge) > CurTime() - 5) then
		return
	end
	ply.LastFullUpdate = CurTime()
	pluto.inv.sendfullupdate(ply)
end)

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
		if (item.Tier.InternalName == "crafted") then
			net.WriteBool(true)
			for i = 1, 3 do
				net.WriteString(item.Tier.Tiers[i])
			end
		else
			net.WriteBool(false)
			net.WriteString(item.Tier.InternalName)
		end
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

		net.WriteBool(item.Tier.Crafted)

		if (item.Tier.BackgroundMaterial) then
			net.WriteBool(true)
			net.WriteString(item.Tier.BackgroundMaterial)
		else
			net.WriteBool(false)
		end
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
	local function TrySucceed(where)
		success = success + 1

		if (not IsValid(ply)) then
			return cb(false, "disconnected")
		end

		if (success == 4) then
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

		TrySucceed "tabs"
	end

	pluto.inv.retrievetabs(ply, function(_tabs)
		if (not _tabs) then
			return cb(false, "tabs")
		end

		tabs = _tabs

		InitTabs()
	end)

	pluto.inv.retrieveitems(ply, function(_items, why)
		if (not _items) then
			return cb(false, "items: " .. tostring(why))
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

		TrySucceed "currency"
	end)

	pluto.emoji.init(ply):next(function()
		TrySucceed "emojis"
	end)

	pluto.quests.init(ply, function(_quests)
		TrySucceed "quests"
	end)

	pluto.db.simplequery("SELECT experience, tokens from pluto_player_info where steamid = ?", {pluto.db.steamid64(ply)}, function(d, err)
		d = d and d[1] or {experience = 0}
		if (IsValid(ply)) then
			pluto.inv.message(ply)
				:write("playertokens", d.tokens or 0)
				:send()

			ply:SetPlutoExperience(d.experience)
			pluto.inv.addplayerexperience(ply, 0)

			local msg = pluto.inv.message(ply)
		
			for _, ply in pairs(player.GetAll()) do
				msg:write("playerexp", ply, ply:GetPlutoExperience() or 0)
			end
		
			msg:send()
		end
	end)
end

function pluto.inv.writeplayertokens(cl, tokens)
	net.WriteUInt(tokens, 32)
end

function pluto.inv.readtabswitch(ply)
	local tabid1 = net.ReadUInt(32)
	local tabindex1 = net.ReadUInt(8)
	local tabid2 = net.ReadUInt(32)
	local tabindex2 = net.ReadUInt(8)

	if (tabid1 == tabid2 and tabindex1 == tabindex2) then
		return
	end
	pluto.db.transact(function(db)
		local tab1 = pluto.inv.invs[ply][tabid1]
		local tab2 = pluto.inv.invs[ply][tabid2]

		if (not tab1 or not tab2) then
			pluto.inv.sendfullupdate(ply)
			return
		end

		local canswitch, fail = pluto.canswitchtabs(tab1, tab2, tabindex1, tabindex2)

		if (not canswitch) then
			print("FAILED TAB SWITCH: ", fail, tabindex2, tabindex2)
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

		if (tab1.Type == "buffer" or tab2.Type == "buffer") then
			local buffer = tab1.Type == "buffer" and tab1 or tab2
			local bufferindex = tab1 == buffer and tabindex1 or tabindex2
			
			pluto.inv.lockbuffer(db, ply)
			if (not pluto.inv.switchtab(db, tabid1, tabindex1, tabid2, tabindex2)) then
				pluto.inv.reloadfor(ply)
				mysql_rollback(db)
				return
			end

			pluto.inv.popbuffer(db, ply, bufferindex)

			mysql_commit(db)
		else
			if (not pluto.inv.switchtab(db, tabid1, tabindex1, tabid2, tabindex2)) then
				pluto.inv.reloadfor(ply)
				mysql_rollback(db)
				return
			end
			mysql_commit(db)
		end
	end)
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

	pluto.db.transact(function(db)
		local succ = pluto.inv.deleteitem(db, ply, itemid)

		if (not succ) then
			return
		end
		
		if (IsValid(ply) and i.Type == "Weapon" and i.Tier.InternalName ~= "crafted" and math.random() < 0.8) then
			pluto.inv.generatebuffershard(db, ply, "DELETE", i.Tier.InternalName)
			if (pluto.tiers.byname[i.Tier.InternalName] and pluto.tiers.byname[i.Tier.InternalName].affixes >= 5) then
				hook.Run("PlutoRareDrop", ply, "Shard")
			end
		end

		mysql_commit(db)
	end)
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

	if (not cur:AllowedUse(wpn) or wpn and wpn:ShouldPreventChange()) then
		return
	end

	if (cur.Contents) then
		local gotten, data = pluto.inv.roll(cur.Contents)
		local type = pluto.inv.itemtype(gotten)

		pluto.db.transact(function(db)
			pluto.inv.lockbuffer(db, ply)
			pluto.inv.waitbuffer(db, ply)

			if (not pluto.inv.addcurrency(db, ply, currency, -1)) then
				mysql_rollback(db)
				return
			end

			local wpn
			if (type == "Model") then -- model
				wpn = pluto.inv.generatebuffermodel(db, ply, "UNBOXED", gotten:match "^model_(.+)$")
			elseif (type == "Weapon") then -- unique
				wpn = pluto.inv.generatebufferweapon(db, ply, "UNBOXED", istable(data) and data.Tier or cur.DefaultTier or "unique", gotten)
			end

			if (istable(data) and data.Rare) then
				hook.Run("PlutoRareDrop", ply, type)
				discord.Message():AddEmbed(
					wpn:GetDiscordEmbed()
						:SetAuthor(ply:Nick() .. "'s", "https://steamcommunity.com/profiles/" .. ply:SteamID64())
				):Send "drops"
			end

			hook.Run("PlayerCurrencyUse", ply, nil, currency)
			mysql_commit(db)
		end)
	else
		cur:Use(ply, wpn):next(function()
			if (wpn and IsValid(ply)) then
				pluto.inv.message(ply)
					:write("item", wpn)
					:send()
			end
		end)
		hook.Run("PlayerCurrencyUse", ply, wpn, currency)
	end
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

function pluto.inv.readchangetabdata(ply)
	local id = net.ReadUInt(32)
	local col = net.ReadColor()
	col = col.b + bit.lshift(col.g, 8) + bit.lshift(col.r, 16)
	local shape = net.ReadString()

	local tab = pluto.inv.invs[ply][id]
	if (not tab) then
		return
	end

	tab.Shape = shape
	tab.Color = col

	timer.Create("changetabdata" .. id, 2, 1, function()
		pluto.db.instance(function(db)
			mysql_stmt_run(db, "UPDATE pluto_tabs SET color = ?, tab_shape = ? WHERE idx = ?", col, shape, id)
		end)
	end)
end

function pluto.inv.readend()
	return true
end

function pluto.inv.writeexpupdate(cl, item)
	net.WriteUInt(item.RowID, 32)
	net.WriteUInt(item.Experience, 32)
end

function pluto.inv.writeplayerexp(cl, ply, exp)
	net.WriteString(ply:SteamID64())
	net.WriteUInt(exp, 32)
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

function pluto.inv.readui(ply)
	local is_in = net.ReadBool()

	ply.IsInInventory = math.Clamp((ply.IsInInventory or 0) + (is_in and 1 or -1), 0, 1)

	if (ply.IsInInventory == 1) then
		ply:SetNW2Bool("InInventory", 1)
	else
		ply:SetNW2Bool("InInventory", 0)
	end
end

hook.Add("PlayerAuthed", "pluto_init_inventory", pluto.inv.sendfullupdate)