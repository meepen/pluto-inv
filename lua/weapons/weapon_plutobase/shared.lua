SWEP.Base = "weapon_tttbase_old"
DEFINE_BASECLASS "weapon_tttbase_old"

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

	local mods = data.Mods

	for _, list in pairs(mods) do
		for _, mod in pairs(list) do
			if (mod.Mod and mod.Mod.ModifyWeapon) then
				mod.Mod:ModifyWeapon(self, mod.Rolls)
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

function SWEP:DefinePlutoOverrides(type)
	if (self.Pluto[type]) then
		return
	end

	self.Pluto[type] = 1

	local old = self["Get" .. type]
	self["Get" .. type] = function(self)
		return old(self) * self.Pluto[type]
	end
end

function SWEP:PlutoInitialize()
	self.Pluto = {}
end