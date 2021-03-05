AddCSLuaFile()

SWEP.Base = "weapon_rb566_lightsaber"
SWEP.PrintName = "Crossguard Lightsaber"

DEFINE_BASECLASS(SWEP.Base)

local mdl = "models/weapons/starwars/w_kr_hilt.mdl"
function SWEP:Initialize()
	BaseClass.Initialize(self)

	self:SetWorldModel(mdl)
	self:SetModel(mdl)
end

SWEP.Ortho = {-4.5, 3}