AddCSLuaFile()

ENT.PrintName = "Inhibitor Field Grenade"
ENT.Base = "pluto_len_basegrenade"
ENT.Model = "models/weapons/w_eq_fraggrenade_thrown.mdl"

function ENT:Explode()
    for k,v in pairs(ents.GetAll()) do
		local top = v:GetPos() + vector_up * (v:OBBMaxs().z - v:OBBMins().z)
		local dist = math.min(top:Distance(self:GetOrigin()), v:GetPos():Distance(self:GetOrigin()))

		if (dist < max_dist) then

			local tr = util.TraceLine {
				start = self:GetOrigin(),
				endpos = v:GetPos(),
				mask = MASK_SHOT,
				filter = self,
			}

			if (not tr.Hit and tr.Entity ~= v and tr.Fraction ~= 1) then
				continue
			end
            -- add effect here
		end
	end
    local pos = self:GetPos()
	local effect = EffectData()
	effect:SetStart(pos)
	effect:SetOrigin(pos)
	effect:SetScale(100)
	effect:SetRadius(75 * self:GetRangeMulti())
	effect:SetMagnitude(1)

	util.Effect("Explosion", effect, true, true)
	util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), (75 * self:GetRangeMulti()), (50 * self:GetDamageMulti()))
    self:Remove()
end


function ENT:GrenadeBounce()
    self:Explode()
end
