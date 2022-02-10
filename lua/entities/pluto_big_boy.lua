AddCSLuaFile()

ENT.PrintName = "Big Boy"
ENT.Base = "pluto_len_basegrenade"
ENT.Model = "models/weapons/w_models/w_grenade_grenadelauncher.mdl"

function ENT:Explode()

    local pos = self:GetPos()
	local effect = EffectData()
	effect:SetStart(pos)
	effect:SetOrigin(pos)
	effect:SetScale(100)
	effect:SetRadius(250 * self:GetRangeMulti())
	effect:SetMagnitude(1)

	util.Effect("Explosion", effect, true, true)
	util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), (250 * self:GetRangeMulti()), (200 * self:GetDamageMulti()))

end

function ENT:Think()
	if (SERVER) then
		local left = self:GetDieTime() - CurTime()

		local interval = 0.5
		if (left < 3) then
			interval = 0.1
		elseif (left < 1) then
			interval = 0.25
		end

		if (self:GetNextSound() == -math.huge or self:GetNextSound() < CurTime()) then
			self:EmitSound "sticky_grenade"
			self:SetNextSound(CurTime() + interval)
		end
	end
	return BaseClass.Think(self)
end