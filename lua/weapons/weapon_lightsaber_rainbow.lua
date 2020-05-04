AddCSLuaFile()

SWEP.Base = "weapon_rb566_lightsaber"
SWEP.PrintName = "Double-bladed Lightsaber"

DEFINE_BASECLASS(SWEP.Base)

local mdl = "models/weapons/starwars/w_maul_saber_staff_hilt.mdl"
function SWEP:Initialize()
	BaseClass.Initialize(self)

	self:SetWorldModel(mdl)
	self:SetModel(mdl)
	self:SetMaxLength(self:GetMaxLength() * 2 / 3)
	self:SetDarkInner(true)
end


function SWEP:Think()
	local r = BaseClass.Think(self)

	local col = HSVToColor((CurTime() % 4) / 4 * 360, 1, 0.5)
	self:SetCrystalColor(Vector(col.r, col.g, col.b))

	return r
end