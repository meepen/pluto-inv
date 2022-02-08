--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
sql.Query [[
	CREATE TABLE IF NOT EXISTS pluto_loadouts (
		idx INTEGER PRIMARY KEY AUTOINCREMENT,
		name VARCHAR(16),
		slot1 INT UNSIGNED DEFAULT NULL,
		slot2 INT UNSIGNED DEFAULT NULL,
		slot3 INT UNSIGNED DEFAULT NULL,
		slot4 INT UNSIGNED DEFAULT NULL,
		slot5 INT UNSIGNED DEFAULT NULL,
		slot6 INT UNSIGNED DEFAULT NULL
	);
]]
sql.Query [[
	CREATE TABLE IF NOT EXISTS pluto_cosmetic_loadouts (
		idx INTEGER PRIMARY KEY AUTOINCREMENT,
		name VARCHAR(16),
		slot1 INT UNSIGNED DEFAULT NULL,
		slot2 INT UNSIGNED DEFAULT NULL,
		slot3 INT UNSIGNED DEFAULT NULL,
		slot4 INT UNSIGNED DEFAULT NULL,
		slot5 INT UNSIGNED DEFAULT NULL,
		slot6 INT UNSIGNED DEFAULT NULL
	);
]]

for i = tonumber(sql.QueryValue "SELECT COUNT(*) FROM pluto_loadouts") + 1, 3 do
	sql.Query([[
		INSERT INTO pluto_loadouts (name) VALUES ('Loadout ]] .. i .. [[');
	]])
end

for i = tonumber(sql.QueryValue "SELECT COUNT(*) FROM pluto_cosmetic_loadouts") + 1, 3 do
	sql.Query([[
		INSERT INTO pluto_cosmetic_loadouts (name) VALUES ('Cosmetic ]] .. i .. [[');
	]])
end

local pluto_equip_cosmetics = CreateConVar("pluto_equip_cosmetics_mode", "0", {FCVAR_ARCHIVE, FCVAR_UNREGISTERED, FCVAR_NEVER_AS_STRING})

local pluto_last_loadout = CreateConVar("pluto_last_loadout", "1", {FCVAR_ARCHIVE, FCVAR_UNREGISTERED, FCVAR_NEVER_AS_STRING})
local pluto_last_cosmetic_loadout = CreateConVar("pluto_last_cosmetic_loadout", "1", {FCVAR_ARCHIVE, FCVAR_UNREGISTERED, FCVAR_NEVER_AS_STRING})

local loadout_slot_convars = {}
for i = 1, 6 do
	loadout_slot_convars[i] = CreateConVar("pluto_loadout_slot" .. i, "NULL", {FCVAR_USERINFO})
end

local cosmetic_slot_convars = {}
for i = 1, 6 do
	cosmetic_slot_convars[i] = CreateConVar("pluto_cosmetic_slot" .. i, "NULL", {FCVAR_USERINFO})
end

local function GetLoadoutItems(idx)
	local items = sql.Query("SELECT * from pluto_loadouts WHERE idx = " .. sql.SQLStr(idx) .. ";")

	if (not items) then
		return
	end
	items = items[1]

	local ret = {}

	for i = 1, 6 do
		local id = items["slot" .. i]

		local wep
		if (id ~= "NULL") then
			wep = pluto.received.item[tonumber(id)]
		end

		ret[i] = wep

		loadout_slot_convars[i]:SetString(id)
	end

	return ret
end

local function GetCosmeticItems(idx)
	local items = sql.Query("SELECT * from pluto_cosmetic_loadouts WHERE idx = " .. sql.SQLStr(idx) .. ";")

	if (not items) then
		return
	end
	items = items[1]

	local ret = {}

	for i = 1, 6 do
		local id = items["slot" .. i]

		local wep
		if (id ~= "NULL") then
			wep = pluto.received.item[tonumber(id)]
		end

		ret[i] = wep

		cosmetic_slot_convars[i]:SetString(id)
	end

	return ret
end

GetLoadoutItems(pluto_last_loadout:GetInt())
GetCosmeticItems(pluto_last_cosmetic_loadout:GetInt())

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_component"

local inner_area = 5
local outer_area = 10

local defaults = {
	loadout = {
		{ "weapon_ttt_m4a1", "Weapon" },
		{ "weapon_ttt_pistol", "Weapon" },
		{ "weapon_ttt_crowbar", "Weapon" },
		{ "weapon_ttt_basegrenade", "Weapon" },
	},
	cosmetic = {
		{ "default", "Model" }
	}
}

local filters = {
	[1] = function(item)
		if (item.Type ~= "Weapon") then
			return false
		end
		local class = baseclass.Get(item.ClassName)
		return class.Slot == 2
	end,
	[2] = function(item)
		if (item.Type ~= "Weapon") then
			return false
		end
		local class = baseclass.Get(item.ClassName)
		return class.Slot == 1
	end,
	[3] = function(item)
		if (item.Type ~= "Weapon") then
			return false
		end
		local class = baseclass.Get(item.ClassName)
		return class.Slot == 0
	end,
	[4] = function(item)
		if (item.Type ~= "Weapon") then
			return false
		end
		local class = baseclass.Get(item.ClassName)
		return class.Slot == 3
	end,
	[5] = function(item)
		if (item.Type ~= "Weapon") then
			return false
		end
		local class = baseclass.Get(item.ClassName)
		return class.Slot == 4
	end,
	[6] = function(item)
		if (item.Type ~= "Weapon") then
			return false
		end
		local class = baseclass.Get(item.ClassName)
		return class.Slot == 5
	end,
}


local cosmetic_filters = {
	[1] = function(item)
		return item and item.Type == "Model"
	end
}

function pluto.inv.equip(item)
	for slot, fn in pairs(filters) do
		if (fn(item)) then
			sql.Query([[UPDATE pluto_loadouts SET slot]] .. slot .. [[ = ]] .. item.ID .. [[ WHERE idx = ]] .. pluto_last_loadout:GetInt())
			loadout_slot_convars[slot]:SetString(item.ID)
			hook.Run("PlutoLoadoutChanged", slot, item)
			return true
		end
	end

	for slot, fn in pairs(cosmetic_filters) do
		if (fn(item)) then
			sql.Query([[UPDATE pluto_cosmetic_loadouts SET slot]] .. slot .. [[ = ]] .. item.ID .. [[ WHERE idx = ]] .. pluto_last_cosmetic_loadout:GetInt())
			cosmetic_slot_convars[slot]:SetString(item.ID)
			hook.Run("PlutoCosmeticChanged", slot, item)
			return true
		end
	end

	return false
end

function PANEL:Init()
	self:DockPadding(6, 2, 6, 2)

	self.Inner = self:Add "pluto_inventory_playermodel"
	self.Inner:Dock(FILL)
	self.PlayerModel = self.Inner

	self.Upper = self.Inner:Add "EditablePanel"
	self.Upper:Dock(TOP)
	self.Upper:SetTall(22)

	self.ToggleCosmetic = self.Upper:Add "pluto_toggle"
	self.ToggleCosmetic:SetPos(2, self.Upper:GetTall() / 2 - self.ToggleCosmetic:GetTall() / 2)
	function self.ToggleCosmetic.OnToggled(s, b)
		self:OnCosmeticToggled(b)
	end

	self.Dropdown = self:Add "pluto_dropdown"
	self.Dropdown:SetSize(80, pluto.ui.sizings "pluto_inventory_font" + 8)
	self.Dropdown:SetCurveTopLeft(false)
	self.Dropdown:SetCurveBottomRight(false)

	self.CosmeticDropdown = self:Add "pluto_dropdown"
	self.CosmeticDropdown:SetSize(80, pluto.ui.sizings "pluto_inventory_font" + 8)
	self.CosmeticDropdown:SetCurveTopLeft(false)
	self.CosmeticDropdown:SetCurveBottomRight(false)
	self.CosmeticDropdown:SetVisible(false)

	self.ItemContainer = self.Inner:Add "EditablePanel"
	self.ItemContainer:Dock(LEFT)
	self.ItemContainer:SetWide(pluto.ui.sizings "ItemSize" + 16)

	self.CosmeticsContainer = self.ItemContainer:Add "EditablePanel"
	self.CosmeticsContainer:SetSize(pluto.ui.sizings "ItemSize", pluto.ui.sizings "ItemSize" * 6 + 6 * 5)
	self.CosmeticsContainer:SetPos(6, 8)
	self.CosmeticsContainer:SetMouseInputEnabled(false)
	self.CosmeticsContainer:SetAlpha(128)

	self.LoadoutContainer = self.ItemContainer:Add "EditablePanel"
	self.LoadoutContainer:SetSize(pluto.ui.sizings "ItemSize", pluto.ui.sizings "ItemSize" * 6 + 6 * 5)
	self.LoadoutContainer:SetPos(0, 0)

	self.PlayerModel:Dock(FILL)
	self.PlayerModel:SetPlutoModel(pluto.models.default)
	self.PlayerModel:SetFOV(45)
	self.PlayerModel:SetLookAt(Vector(0, -12, 40))

	self.Items = {}
	self.Cosmetics = {}

	for i = 1, 6 do
		local item2 = self.CosmeticsContainer:Add "pluto_inventory_item"
		local item = self.LoadoutContainer:Add "pluto_inventory_item"
		item:Dock(TOP)
		item2:Dock(TOP)

		if (defaults.cosmetic[i]) then
			local model, type = unpack(defaults.cosmetic[i])
			item2:SetDefaultClass(model, type)
		end

		function item2:CanClickWith(other)
			return cosmetic_filters[i] and cosmetic_filters[i](other.Item)
		end
		hook.Add("PlutoCosmeticChanged", item2, function(self, index, item)
			if (index == i) then
				self:SetItem(item)
			end
		end)
		function item2.ClickedWith(s, other)
			sql.Query([[UPDATE pluto_cosmetic_loadouts SET slot]] .. i .. [[ = ]] .. (other.Item and other.Item.ID or "NULL") .. [[ WHERE idx = ]] .. self.ActiveCosmeticLoadout)
			cosmetic_slot_convars[i]:SetString(other.Item and other.Item.ID or "NULL")
			s:SetItem(other.Item)
		end
		function item2.OnRightClick(s)
			if (not s.Item) then
				return
			end

			pluto.ui.rightclickmenu(s.Item, function(menu)
				menu:AddOption("Unequip", function()
					sql.Query([[UPDATE pluto_cosmetic_loadouts SET slot]] .. i .. [[ = NULL WHERE idx = ]] .. self.ActiveCosmeticLoadout)
					cosmetic_slot_convars[i]:SetString "NULL"
					s:SetItem()
				end):SetIcon("icon16/cancel.png")
			end)
		end
		function item2.OnLeftClick(s)
			if (not s.Item) then
				return
			end
			pluto.ui.highlight(s.Item)
			if (CurTime() - (s.LastClick or -math.huge) < 0.2) then
				s:OnRightClick()
			end
			s.LastClick = CurTime()
		end

		function item2.OnSetItem(s, item)
			if (i == 1) then
				self.PlayerModel:SetPlutoModel(item and item.Model or pluto.models.default, item)
			end
		end

		if (defaults.loadout[i]) then
			local model, type = unpack(defaults.loadout[i])
			item:SetDefaultClass(model, type)
		end
		function item:CanClickWith(other)
			return filters[i] and filters[i](other.Item)
		end
		hook.Add("PlutoLoadoutChanged", item, function(self, index, item)
			if (index == i) then
				self:SetItem(item)
			end
		end)
		function item.ClickedWith(s, other)
			sql.Query([[UPDATE pluto_loadouts SET slot]] .. i .. [[ = ]] .. (other.Item and other.Item.ID or "NULL") .. [[ WHERE idx = ]] .. self.ActiveLoadout)
			loadout_slot_convars[i]:SetString(other.Item and other.Item.ID or "NULL")
			s:SetItem(other.Item)
		end
		function item.OnRightClick(s)
			if (not s.Item) then
				return
			end

			pluto.ui.rightclickmenu(s.Item, function(menu)
				menu:AddOption("Unequip", function()
					sql.Query([[UPDATE pluto_loadouts SET slot]] .. i .. [[ = NULL WHERE idx = ]] .. self.ActiveLoadout)
					loadout_slot_convars[i]:SetString "NULL"
					s:SetItem()
				end):SetIcon("icon16/cancel.png")
			end)
		end
		function item.OnLeftClick(s)
			if (not s or not s.Item) then
				return
			end
			pluto.ui.highlight(s.Item)
			if (CurTime() - (s.LastClick or -math.huge) < 0.2) then
				s:OnRightClick()
			end
			s.LastClick = CurTime()
		end

		function item.OnSetItem(s, item)
			if (i == 1) then
				self.PlayerModel:SetPlutoWeapon(item)
			end
		end
	
		self.Items[i] = item
		self.Cosmetics[i] = item2
		if (i ~= 6) then
			item:DockMargin(0, 0, 0, 5)
			item2:DockMargin(0, 0, 0, 5)
		end
	end

	local chosen

	for _, loadout in ipairs(sql.Query [[SELECT idx, name FROM pluto_loadouts ORDER BY idx ASC]]) do
		self.Dropdown:AddOption(loadout.name, function()
			self:LoadLoadout(tonumber(loadout.idx))
		end)
		if (not chosen or pluto_last_loadout:GetInt() == tonumber(loadout.idx)) then
			chosen = #self.Dropdown.Options
		end
	end

	if (chosen) then
		self.Dropdown:ChooseOption(chosen)
	end

	local chosen

	for _, loadout in ipairs(sql.Query [[SELECT idx, name FROM pluto_cosmetic_loadouts ORDER BY idx ASC]]) do
		self.CosmeticDropdown:AddOption(loadout.name, function()
			self:LoadCosmetics(tonumber(loadout.idx))
		end)
		if (not chosen or pluto_last_cosmetic_loadout:GetInt() == tonumber(loadout.idx)) then
			chosen = #self.CosmeticDropdown.Options
		end
	end

	if (chosen) then
		self.CosmeticDropdown:ChooseOption(chosen)
	end

	if (pluto_equip_cosmetics:GetBool()) then
		self.ToggleCosmetic:Toggle()
	end
end

function PANEL:OnCosmeticToggled(b)
	pluto_equip_cosmetics:SetBool(b)
	local front_tbl = b and self.Cosmetics or self.Items
	local back_tbl = b and self.Items or self.Cosmetics

	self.CosmeticsContainer:SetZPos(b and 1 or 0)
	self.LoadoutContainer:SetZPos(b and 0 or 1)

	self.CosmeticsContainer:SetMouseInputEnabled(b)
	self.CosmeticsContainer:SetAlpha(b and 255 or 128)
	self.LoadoutContainer:SetMouseInputEnabled(not b)
	self.LoadoutContainer:SetAlpha(b and 128 or 255)

	self.Dropdown:SetVisible(not b)
	self.CosmeticDropdown:SetVisible(b)
end

function PANEL:LoadLoadout(idx)
	pluto_last_loadout:SetInt(idx)
	self.ActiveLoadout = idx

	local items = GetLoadoutItems(idx)

	for i = 1, 6 do
		local wep = items[i]
		self.Items[i]:SetItem(wep)
	end
end

function PANEL:LoadCosmetics(idx)
	pluto_last_cosmetic_loadout:SetInt(idx)
	self.ActiveCosmeticLoadout = idx

	local items = GetCosmeticItems(idx)

	for i = 1, 6 do
		local wep = items[i]
		self.Cosmetics[i]:SetItem(wep)
	end
end

function PANEL:PerformLayout(w, h)
	BaseClass.PerformLayout(self, w, h)
	self.Dropdown:SetPos(w - self.Dropdown:GetWide(), 0)
	self.CosmeticDropdown:SetPos(self.Dropdown:GetPos())
end

vgui.Register("pluto_inventory_equip", PANEL, "pluto_inventory_component")