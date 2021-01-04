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

for i = tonumber(sql.QueryValue "SELECT COUNT(*) FROM pluto_loadouts") + 1, 3 do
	sql.Query([[
		INSERT INTO pluto_loadouts (name) VALUES ('Loadout ]] .. i .. [[');
	]])
end

local pluto_last_loadout = CreateConVar("pluto_last_loadout", "1", {FCVAR_ARCHIVE, FCVAR_UNREGISTERED, FCVAR_NEVER_AS_STRING})

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_component"

local item_size = 56
local inner_area = 5
local outer_area = 10

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

function PANEL:Init()
	self:DockPadding(6, 2, 6, 2)

	self.Inner = self:Add "EditablePanel"
	self.Inner:Dock(FILL)

	self.Upper = self.Inner:Add "EditablePanel"
	self.Upper:Dock(TOP)
	self.Upper:SetTall(22)

	self.ToggleCosmetic = self.Upper:Add "pluto_toggle"
	self.ToggleCosmetic:SetPos(2, self.Upper:GetTall() / 2 - self.ToggleCosmetic:GetTall() / 2)
	self.Dropdown = self:Add "pluto_dropdown"
	self.Dropdown:SetSize(80, 20)
	self.Dropdown:SetCurveTopLeft(false)
	self.Dropdown:SetCurveBottomRight(false)

	self.ItemContainer = self.Inner:Add "EditablePanel"
	self.ItemContainer:Dock(LEFT)
	self.ItemContainer:SetWide(64)


	self.PlayerModel = self.Inner:Add "PlutoPlayerModel"
	self.PlayerModel:Dock(FILL)
	self.PlayerModel:SetPlutoModel(pluto.models.default)
	self.PlayerModel:SetFOV(38)

	self.Items = {}

	for i = 1, 6 do
		local container = self.ItemContainer:Add "EditablePanel"
		container:Dock(TOP)
		container:SetTall(62)

		local item2 = container:Add "pluto_inventory_item"
		item2:SetPos(8, 6)
		item2:SetAlpha(128)

		local item = container:Add "pluto_inventory_item"
		function item:CanClickWith(other)
			return filters[i] and filters[i](other.Item)
		end
		function item.ClickedWith(s, other)
			sql.Query([[UPDATE pluto_loadouts SET slot]] .. i .. [[ = ]] .. (other.Item and other.Item.ID or "NULL") .. [[ WHERE idx = ]] .. self.ActiveLoadout)
			s:SetItem(other.Item)
		end
	
		self.Items[i] = item
		if (i ~= 6) then
			item:DockMargin(0, 0, 0, 5)
			item2:DockMargin(0, 0, 0, 5)
		end
	end

	for _, loadout in ipairs(sql.Query [[SELECT idx, name FROM pluto_loadouts ORDER BY idx ASC]]) do
		self.Dropdown:AddOption(loadout.name, function()
			self:LoadLoadout(tonumber(loadout.idx))
		end)
	end

	self:LoadLoadout(pluto_last_loadout:GetInt())
end

function PANEL:LoadLoadout(idx)
	self.ActiveLoadout = idx
	local items = sql.Query("SELECT * from pluto_loadouts WHERE idx = " .. sql.SQLStr(idx) .. ";")
	if (not items) then
		return
	end
	items = items[1]

	for i = 1, 6 do
		local id = items["slot" .. i]

		local wep
		if (id ~= "NULL") then
			wep = pluto.received.item[tonumber(id)]
		end

		self.Items[i]:SetItem(wep)
	end
end

function PANEL:PerformLayout(w, h)
	BaseClass.PerformLayout(self, w, h)
	self.Dropdown:SetPos(w - self.Dropdown:GetWide(), 0)
end

vgui.Register("pluto_inventory_equip", PANEL, "pluto_inventory_component")