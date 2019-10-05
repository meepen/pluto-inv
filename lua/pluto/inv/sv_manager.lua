pluto.inv.invs = pluto.inv.invs or {}
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

pluto.inv.sent = pluto.inv.sent or {}

util.AddNetworkString "pluto_inv_data"

function pluto.inv.writemod(ply, item)
	local mod = pluto.mods.byname[item.Mod]
	local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)

	local name = pluto.mods.formataffix(mod.Type, mod.Name)
	local tier = item.Tier
	local desc = mod:GetDescription(rolls)

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
		net.WriteString(item.ClassName)

		if (item.Mods.prefix) then
			net.WriteUInt(#item.Mods.prefix, 8)
			for ind, item in ipairs(item.Mods.prefix) do
				pluto.inv.writemod(ply, item)
			end
		else
			net.WriteUInt(0, 8)
		end

		if (item.Mods.suffix) then
			net.WriteUInt(#item.Mods.suffix, 8)
			for ind, item in ipairs(item.Mods.suffix) do
				pluto.inv.writemod(ply, item)
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
		:write("status", "updating")
		
	for _, tab in pairs(pluto.inv.invs[ply]) do
		m:write("tab", tab)
	end
	
	m:send()
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

function pluto.inv.init(ply, cb)
	if (pluto.inv.invs[ply]) then
		return cb(false)
	end

	pluto.inv.retrievetabs(ply, function(tabs)
		if (not IsValid(ply)) then
			return cb(false)
		end
		if (not tabs) then
			ply:Kick "Tabs not retrieved. Please report on our discord to Meepen."
			return cb(false)
		end

		pluto.inv.retrieveitems(ply, function(items)
			if (not IsValid(ply)) then
				return cb(false)
			end
	
			if (not items) then
				ply:Kick "Items not retrieved. Please report on our discord to Meepen."
				return cb(false)
			end


			local inv = {}

			for _, tab in pairs(tabs) do
				inv[tab.RowID] = tab
				tab.Items = {}
			end

			for _, item in pairs(items) do
				local tab = inv[item.TabID]
				tab.Items[item.TabIndex] = item
			end

			pluto.inv.invs[ply] = inv
			cb(inv)
		end)
	end)
end

function pluto.inv.readtabswitch(ply)
	local tabid1 = net.ReadUInt(32)
	local tabindex1 = net.ReadUInt(8)
	local tabid2 = net.ReadUInt(32)
	local tabindex2 = net.ReadUInt(8)
	
	pluto.inv.switchtab(ply, tabid1, tabindex1, tabid2, tabindex2, print)
end

function pluto.inv.readend()
	return true
end

hook.Add("PlayerAuthed", "pluto_init_inventory", pluto.inv.sendfullupdate)