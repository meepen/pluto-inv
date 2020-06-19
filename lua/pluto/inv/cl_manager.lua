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

local function ReadIfExists(mod, key)
	if (net.ReadBool()) then
		local typ = net.ReadUInt(4)

		if (typ == 0) then
			mod[key] = net.ReadFunction()
		elseif (typ == 1) then
			mod[key] = net.ReadString()
		elseif (typ == 2) then
			mod[key] = net.ReadColor()
		end
	end
end

function pluto.inv.readmod(item)
	local rolls = {}
	local minsmaxs = {}

	local InternalName = net.ReadString()

	if (net.ReadBool()) then
		local mod = pluto.mods.byname[InternalName] or {}
		pluto.mods.byname[InternalName] = mod

		mod.InternalName = true

		mod.Type = net.ReadString()
		mod.Name = net.ReadString()

		ReadIfExists(mod, "Color")
		ReadIfExists(mod, "FormatModifier")
		ReadIfExists(mod, "GetDescription")
		ReadIfExists(mod, "Description")
		ReadIfExists(mod, "IsNegative")
		ReadIfExists(mod, "GetModifier")
		ReadIfExists(mod, "ModifyWeapon")

		mod.Tags = {}
		while (net.ReadBool()) do
			local tag = net.ReadString()
			mod.Tags[#mod.Tags + 1] = tag
			mod.Tags[tag] = true
		end

		mod.Tiers = {}
		for i = 1, net.ReadUInt(8) do
			mod.Tiers[i] = {}
			for j = 1, net.ReadUInt(4) do
				mod.Tiers[i][j] = net.ReadFloat()
			end
		end

		setmetatable(mod, pluto.mods.mt)
	end

	local mod = {}
	mod.Tier = net.ReadUInt(4)
	mod.Roll = {}
	mod.Mod = InternalName

	for i = 1, net.ReadUInt(4) do
		mod.Roll[i] = net.ReadFloat()
	end

	return mod
end

function pluto.inv.readbaseitem(item)
	setmetatable(item, pluto.inv.item_mt)

	item.ClassName = net.ReadString()

	item.Experience = net.ReadUInt(32)
	if (net.ReadBool()) then
		item.SpecialName = net.ReadString()
	end
	if (net.ReadBool()) then
		item.Nickname = net.ReadString()
	end

	item.Type = pluto.inv.itemtype(item)

	if (item.Type == "Weapon" or item.Type == "Shard") then
		item.Tier = net.ReadString()
		item.SubDescription = net.ReadString()
		item.Color = net.ReadColor()

		item.AffixMax = net.ReadUInt(3)
	end

	if (item.Type == "Weapon") then
		item.Mods = {
			implicit = {},
			prefix = {},
			suffix = {},
		}

		for k in pairs(item.Mods) do
			item.Mods[k] = {}
		end

		for i = 1, net.ReadUInt(8) do
			local t = {}
			item.Mods[net.ReadString()] = t

			for i = 1, net.ReadUInt(8) do
				t[i] = pluto.inv.readmod()
			end
		end

		item.Crafted = net.ReadBool()

		if (net.ReadBool()) then
			item.BackgroundMaterial = net.ReadString()
		end
	elseif (item.Type == "Model") then
		item.Model = pluto.models[item.ClassName:match "^model_(.+)$"]
		if (item.Model) then
			item.Color = item.Model.Color or Color(255, 255, 255)
			item.Name = item.Model.Name .. " Model"
			item.SubDescription = item.Model.SubDescription
		else
			item.Model = pluto.models.default
			item.Color = color_white
			item.Name = "Unknown Model: " .. item.ClassName
			item.SubDescription = "unknown"
		end
	end
end

function pluto.inv.readitem()
	local id = net.ReadUInt(32)

	if (not net.ReadBool()) then
		return pluto.received.item[id]
	end

	local item = pluto.received.item[id] or setmetatable({
		ID = id,
		Version = 0,
	}, pluto.inv.item_mt)

	item.Version = item.Version + 1

	pluto.inv.readbaseitem(item)

	item.Locked = net.ReadBool()
	item.OriginalOwner = net.ReadString()
	item.OriginalOwnerName = net.ReadString()
	item.Untradeable = net.ReadBool()

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

	while (pluto.inv.readtab()) do

	end

	for i = 1, net.ReadUInt(32) do
		pluto.inv.readcurrencyupdate()
	end

	for i = 1, net.ReadUInt(8) do
		pluto.inv.readbufferitem()
	end

	pluto.inv.readstatus()
	pluto.inv.remakefake()
end

function pluto.inv.readtab()
	local id = net.ReadUInt(32)
	if (id == 0) then
		return false
	end

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

	return true
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
	local id = net.ReadUInt(32)

	local item = setmetatable({
		BufferID = id,
	}, pluto.inv.item_mt)

	pluto.inv.readbaseitem(item)

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
	net.WriteUInt(bufferid, 32)
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

function pluto.inv.readcrate_id()
	hook.Run("CrateOpenResponse", net.ReadInt(32))
end


function pluto.inv.readexpupdate()
	local itemid = net.ReadUInt(32)
	local exp = net.ReadUInt(32)


	local item = pluto.received.item[itemid]

	if (not item) then
		pwarnf("Item ID not found for expupdate: %i", itemid)
		return
	end

	item.Experience = exp
end

function pluto.inv.readplayerexp(cl, ply, exp)
	local ply = net.ReadEntity()
	local exp = net.ReadUInt(32)
	if (IsValid(ply)) then
		ply:SetPlutoExperience(exp)
	end
end

function pluto.inv.writeitemlock(itemid)
	net.WriteUInt(itemid, 32)
end

function pluto.inv.readitemlock()
	local itemid = net.ReadUInt(32)
	local locked = net.ReadBool()

	local item = pluto.received.item[itemid]

	if (not item) then
		pwarnf("Item ID not found for itemlock: %i", itemid)
		return
	end

	item.Locked = locked
end

function pluto.inv.writeui(b)
	net.WriteBool(b)
end
