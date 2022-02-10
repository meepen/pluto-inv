AddCSLuaFile()

ENT.PrintName = "Cherry Bomb"
ENT.Base = "pluto_len_basegrenade"
ENT.Model = "models/weapons/w_eq_fraggrenade_thrown.mdl"

function ENT:Explode()

    local pos = self:GetPos()
	local effect = EffectData()
	effect:SetStart(pos)
	effect:SetOrigin(pos)
	effect:SetScale(100)
	effect:SetRadius(75 * self:GetRangeMulti())
	effect:SetMagnitude(1)

	util.Effect("Explosion", effect, true, true)
	util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), (75 * self:GetRangeMulti()), (50 * self:GetDamageMulti()))

end