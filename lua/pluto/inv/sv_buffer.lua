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

	print(index)
	for i = index + 1, 5 do
		print("pop", i)
		transact:AddQuery([[UPDATE pluto_items set tab_idx = tab_idx - 1 where tab_id = ? and tab_idx = ?]], {tab.RowID, i})
	end

	return transact
end

function pluto.inv.generatebufferweapon(ply, ...)
	local transact = pluto.inv.pushbuffer(ply)
	local tab = pluto.inv.invs[ply].tabs.buffer

	local new_item = pluto.weapons.generatetier(...)
	new_item.TabID = tab.RowID
	new_item.TabIndex = 1
	new_item.Owner = ply:SteamID64()

	pluto.weapons.save(new_item, ply, nil, transact)

	transact:AddCallback(function()
		pluto.inv.notifybufferitem(ply, new_item)
	end)

	return transact, new_item
end

function pluto.inv.generatebuffershard(ply, tier)
	local transact = pluto.inv.pushbuffer(ply)
	local tab = pluto.inv.invs[ply].tabs.buffer

	local new_item = setmetatable({
		ClassName = "shard",
		Tier = pluto.tiers[tier],
		Type = "Shard",
	}, pluto.inv.item_mt)

	new_item.TabID = tab.RowID
	new_item.TabIndex = 1
	new_item.Owner = ply:SteamID64()

	pluto.weapons.save(new_item, ply, nil, transact)

	transact:AddCallback(function()
		pluto.inv.notifybufferitem(ply, new_item)
	end)

	return transact, new_item
end

concommand.Add("pluto_spawn_weapon", function(ply, cmd, arg, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	pluto.inv.generatebufferweapon(ply, unpack(arg))
end)

function pluto.inv.generatebuffermodel(ply, mdl)
	local transact = pluto.inv.pushbuffer(ply)
	local tab = pluto.inv.invs[ply].tabs.buffer

	local new_item = setmetatable({
		ClassName = "model_" .. mdl,
		Model = pluto.models[mdl]
	}, pluto.inv.item_mt)

	if (not new_item.Model) then
		return false
	end

	new_item.TabID = tab.RowID
	new_item.TabIndex = 1
	new_item.Owner = ply:SteamID64()

	pluto.weapons.save(new_item, ply, nil, transact)

	transact:AddCallback(function()
		pluto.inv.notifybufferitem(ply, new_item)
	end)

	return transact, new_item
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