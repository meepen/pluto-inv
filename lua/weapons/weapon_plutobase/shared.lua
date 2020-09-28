SWEP.Base = "weapon_tttbase_old"
DEFINE_BASECLASS "weapon_tttbase_old"

local WEAPON = FindMetaTable "Weapon"

function WEAPON:GetPrintName()
	if (self:GetTable().GetPlutoPrintName) then
		return self:GetTable().GetPlutoPrintName(self) or self.PrintName
	end

	return self.PrintName
end

pluto.wpn_db = pluto.wpn_db or {}

function SWEP:GetInventoryItem()
	return pluto.wpn_db[self:GetPlutoID()]
end

function SWEP:ReceivePlutoData()
	if (self.AlreadyReceived) then
		pwarnf("Already received data!")
		return
	end

	self.AlreadyReceived = true

	if (CLIENT and self:GetOwner() == ttt.GetHUDTarget()) then
		self:DisplayPlutoData()
	end

	local data = self:GetInventoryItem()

	for _, modlist in pairs(data.Mods or {}) do
		for _, mod_data in pairs(modlist) do
			local mod = pluto.mods.byname[mod_data.Mod]
			if (mod.ModifyWeapon) then
				mod:ModifyWeapon(self, pluto.mods.getrolls(mod, mod_data.Tier, mod_data.Roll))
			end
		end
	end
end

pluto.CurrentID = pluto.CurrentID or 0
function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetVar("PlutoID", "Int")
	if (SERVER) then
		self:SetPlutoID(pluto.CurrentID)
		pluto.CurrentID = pluto.CurrentID + 1
	end
end

local function default_translate(old, pct)
	if (pct < 0) then
		pct = 1 / (2 - pct)
	end
	return old * pct
end

function SWEP:DefinePlutoOverrides(type, default, translate)
	if (self.Pluto[type]) then
		return
	end

	self.Pluto[type] = default or 1

	translate = translate or default_translate
	local old = self["Get" .. type]
	self["Get" .. type] = function(self)
		return translate(old(self), self.Pluto[type])
	end
end

function SWEP:ScaleRollType(type, roll, init)
	return roll
end
