AddCSLuaFile()

ENT.PrintName = "Big Boy"
ENT.Base = "pluto_len_basegrenade"
ENT.Model = "models/weapons/w_models/w_grenade_grenadelauncher.mdl"
DEFINE_BASECLASS("pluto_len_basegrenade")

function ENT:Explode()

    local pos = self:GetPos()
	local effect = EffectData()
	effect:SetStart(pos)
	effect:SetOrigin(pos)
	effect:SetScale(100)
	effect:SetRadius(200 * self:GetRangeMulti())
	effect:SetMagnitude(1)
    self:FireBomb()
	util.Effect("Explosion", effect, true, true)
	util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), (200 * self:GetRangeMulti()), (150 * self:GetDamageMulti()))

end