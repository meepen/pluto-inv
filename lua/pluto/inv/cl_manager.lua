--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

pluto_buffer_notify = CreateConVar("pluto_buffer_notify", "0", FCVAR_ARCHIVE, "", 0, 1)

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
	local mod = {}
	mod.Mod = net.ReadString()
	mod.Tier = net.ReadUInt(4)
	mod.Roll = {}

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
		if (net.ReadBool()) then
			local t1, t2, t3 = net.ReadString(), net.ReadString(), net.ReadString()
			item.Tier = pluto.tiers.craft {t1, t2, t3}
		else
			item.Tier = pluto.tiers.byname[net.ReadString()]
		end
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
	item.CreationMethod = net.ReadString()
	item.Owner = net.ReadString()
	item.Untradeable = net.ReadBool()
	if (net.ReadBool()) then
		item.constellations = pluto.inv.readconstellations()
	else
		item.constellations = nil
	end

	if (net.ReadBool()) then
		local oldtabid = item.TabID
		local oldtabidx = item.TabIndex
		item.TabID = net.ReadUInt(32)
		item.TabIndex = net.ReadUInt(32)
		if (item.TabID ~= oldtabid or item.TabIndex ~= oldtabidx) then
			local oldtab = pluto.cl_inv[oldtabid]
			local newtab = pluto.cl_inv[item.TabID]
			if (newtab and newtab.Type ~= "buffer") then
				if (oldtab) then
					oldtab.Items[oldtabidx] = nil
				end

				if (newtab) then
					newtab.Items[item.TabIndex] = item
				end
			end
		end
	end

	pluto.received.item[id] = item

	hook.Run("PlutoItemUpdate", item, item.TabID, item.TabIndex)

	return item
end

function pluto.inv.readstatus()
	pluto.inv.status = net.ReadString()

	pluto.message("INV", "Status = ", pluto.inv.status)
end

function pluto.inv.readfullupdate()
	pluto.cl_inv = {}
	pluto.cl_currency = {}
	if (IsValid(pluto.ui.pnl)) then
		pluto.ui.pnl:Remove()
	end

	while (pluto.inv.readtab()) do

	end

	for i = 1, net.ReadUInt(32) do
		pluto.inv.readcurrencyupdate()
	end

	pluto.inv.readstatus()
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
	tab.Shape = net.ReadString()
	local col = net.ReadUInt(24)
	local r = bit.band(bit.rshift(col, 16), 0xff)
	local g = bit.band(bit.rshift(col, 8), 0xff)
	local b = bit.band(col, 0xff)
	tab.Color = Color(r, g, b)

	for i = 1, net.ReadUInt(8) do
		local tabindex = net.ReadUInt(8)
		local item = pluto.inv.readitem()
		tab.Items[tabindex] = item
		item.TabID = id
		item.TabIndex = tabindex
	end

	if (tab.Type == "buffer") then
		pluto.buffer = tab.Items
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
	if (item) then
		item.TabID = tabid
		item.TabIndex = tabindex
	end

	hook.Run("PlutoTabUpdate", tabid, tabindex, item)
end

function pluto.inv.readbufferitem()
	local item = pluto.inv.readitem()
	local is_new = net.ReadBool()
	item.IsNewItem = is_new
	pluto_buffer_notify:SetBool(true)

	if (is_new) then
		chat.AddText("You have received ", item)
	end

	table.insert(pluto.buffer, 1, item)
	for i = 37, #pluto.buffer do
		pluto.buffer[i] = nil
	end
	hook.Run "PlutoBufferChanged"
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

	local item1, item2 = tab1.Items[tabindex1], tab2.Items[tabindex2]
	if (item1) then
		item1.TabID, item1.TabIndex = tabid1, tabindex1
	end
	if (item2) then
		item2.TabID, item2.TabIndex = tabid2, tabindex2
	end

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

function pluto.inv.readplayertokens()
	pluto.cl_tokens = net.ReadUInt(32)
end

function pluto.inv.readplayerexp(cl, ply, exp)
	local ply = net.ReadString()
	local exp = net.ReadUInt(32)
	pluto.experience[ply] = exp
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


hook.Add("TTTRWDrawWeaponName", "pluto_name", function(wep, w, h)
	local item = wep:GetInventoryItem()
	if (not item) then
		return
	end

	local mt = getmetatable(item).__colorprint
	if (not mt) then
		return
	end

	local data = mt(item)
	if (IsColor(data[1])) then
		table.remove(data, 1)
	end
	local fulltext = {}
	for _, v in ipairs(data) do
		if (isstring(v)) then
			table.insert(fulltext, v)
		end
	end

	fulltext = table.concat(fulltext)

	local surface = surface
	if (data.rendersystem) then
		surface = pluto.fonts.systems[data.rendersystem] or surface
	end

	surface.SetFont "ttt_weapon_select_font"
	local tw, th = surface.GetTextSize(fulltext)
	local x, y = w / 2 - tw / 2, h / 2 - th / 2
	surface.SetTextPos(x, y)
	surface.SetTextColor(wep:GetPrintNameColor())

	for _, v in ipairs(data) do
		if (isstring(v)) then
			surface.DrawText(v)
		else
			surface.SetTextColor(v)
		end
	end

	return true
end)

hook.Add("CalcMainActivity", "pluto_inventory", function(ply)
	local wep = ply:GetActiveWeapon()
	if (not IsValid(wep)) then
		return
	end

	if (ply:GetNW2Bool "InInventory") then
		wep.PlutoRealHoldType = wep.PlutoRealHoldType or wep:GetHoldType()
		wep:SetHoldType "magic"
	elseif (wep.PlutoRealHoldType) then
		wep:SetHoldType(wep.PlutoRealHoldType)
	end
end)
local test_frame = vgui.Create "EditablePanel"
function test_frame:Paint(w, h)
	surface.SetDrawColor(12, 13, 14, 200)
	surface.DrawRect(0, 0, w, h)
end
test_frame:SetSize(64, 64)
test_frame:SetPaintedManually(true)

local ui_frame = 0
hook.Add("PreRender", "pluto_inventory_pnl", function()
	ui_frame = ui_frame + 1
end)

hook.Add("PostPlayerDraw", "pluto_inventory", function(ply)
	if (not ply:GetNW2Bool "InInventory" or ply.LastInventoryDraw == ui_frame) then
		return
	end
	ply.LastInventoryDraw = ui_frame

	local ang = ply:EyeAngles()
	local pos = ply:EyePos() + ply:GetAimVector() * 35 - ang:Up() * 15
	ang:RotateAroundAxis(ang:Right(), 90)
	
	vgui.Start3D2D(pos, ang, 0.2)
		test_frame:Paint3D2D()
	vgui.End3D2D()
end)