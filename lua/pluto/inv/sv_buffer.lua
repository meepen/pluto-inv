local function ornull(n)
	return n and SQLStr(n) or "NULL"
end

function pluto.inv.pushbuffer(ply, transact)
	local tab = pluto.inv.invs[ply].tabs.buffer

	if (not tab) then
		return false
	end

	if (not transact) then
		transact = pluto.db.transact()
	end

	transact:AddQuery([[DELETE FROM pluto_items where tab_id = ? and tab_idx = 5]], {tab.RowID})
	transact:AddQuery([[UPDATE pluto_items set tab_idx = tab_idx + 1 where tab_id = ? and tab_idx = 4]], {tab.RowID})
	transact:AddQuery([[UPDATE pluto_items set tab_idx = tab_idx + 1 where tab_id = ? and tab_idx = 3]], {tab.RowID})
	transact:AddQuery([[UPDATE pluto_items set tab_idx = tab_idx + 1 where tab_id = ? and tab_idx = 2]], {tab.RowID})
	transact:AddQuery([[UPDATE pluto_items set tab_idx = tab_idx + 1 where tab_id = ? and tab_idx = 1]], {tab.RowID})

	for i = 4, 1, -1 do
		local item = tab.Items[i]
		tab.Items[i + 1] = item
		if (item) then
			item.TabIndex = i + 1
		end
	end

	return transact
end

function pluto.inv.popbuffer(ply, index, transact)
	local tab = pluto.inv.invs[ply].tabs.buffer

	if (not tab) then
		return false
	end

	if (not transact) then
		transact = pluto.db.transact()
	end

	for i = index + 1, 5 do
		transact:AddQuery([[UPDATE pluto_items set tab_idx = tab_idx - 1 where tab_id = ? and tab_idx = ?]], {tab.RowID, i})
		tab.Items[i - 1] = tab.Items[i]
	end

	return transact
end

function pluto.inv.savebufferitem(ply, new_item, transact)
	local tab = pluto.inv.invs[ply].tabs.buffer

	if (not transact) then
		transact = pluto.db.transact()
	end

	pluto.inv.pushbuffer(ply, transact)

	new_item.TabID = tab.RowID
	new_item.TabIndex = 1
	new_item.Owner = ply:SteamID64()

	pluto.weapons.save(new_item, ply, nil, transact)

	transact:AddCallback(function()
		pluto.inv.notifybufferitem(ply, new_item)
	end)

	return transact, new_item
end

function pluto.inv.generatebufferweapon(ply, ...)
	local new_item = pluto.weapons.generatetier(...)

	return pluto.inv.savebufferitem(ply, new_item)
end

function pluto.inv.generatebuffershard(ply, tier)
	local new_item = setmetatable({
		ClassName = "shard",
		Tier = pluto.tiers.byname[tier],
		Type = "Shard",
	}, pluto.inv.item_mt)

	return pluto.inv.savebufferitem(ply, new_item)
end

concommand.Add("pluto_spawn_weapon", function(ply, cmd, arg, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	pluto.inv.generatebufferweapon(ply, unpack(arg)):Run()
end)

function pluto.inv.generatebuffermodel(ply, mdl)
	local new_item = setmetatable({
		ClassName = "model_" .. mdl,
		Model = pluto.models[mdl]
	}, pluto.inv.item_mt)

	if (not new_item.Model) then
		return false
	end

	return pluto.inv.savebufferitem(ply, new_item)
end

concommand.Add("pluto_spawn_model", function(ply, cmd, arg, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	pluto.inv.generatebuffermodel(ply, unpack(arg))
end)

function pluto.inv.notifybufferitem(ply, i)
	pluto.inv.message(ply)
		:write("bufferitem", i)
		:send()
end

function pluto.inv.getbufferitems(owner)
	return pluto.inv.invs[owner].tabs.buffer.Items
end

function pluto.inv.getbufferitem(ply, id)
	local items = pluto.inv.invs[ply].tabs.buffer.Items
	for _, item in pairs(items) do
		if (item.RowID == id) then
			return item
		end
	end
end