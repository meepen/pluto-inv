SWEP.Base = "weapon_tttbase_old"
DEFINE_BASECLASS "weapon_tttbase_old"

pluto.wpn_db = pluto.wpn_db or {}

function SWEP:GetInventoryItem()
	if (not self.Handle) then
		self.Handle = self:GetHandle()
	end
	return pluto.wpn_db[self.Handle]
end