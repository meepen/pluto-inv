AddCSLuaFile()

SWEP.Base = "weapon_rb566_lightsaber"
SWEP.PrintName = "Rainbow Lightsaber"

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Think()
	local r = BaseClass.Think(self)

	local col = HSVToColor((CurTime() % 4) / 4 * 360, 1, 0.5)
	self:SetCrystalColor(Vector(col.r, col.g, col.b))

	return r
end
