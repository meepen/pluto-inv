AddCSLuaFile()

ENT.PrintName = "MIRV Grenade"
ENT.Base = "pluto_len_basegrenade"
ENT.Model = "models/weapons/w_eq_smokegrenade_thrown.mdl"
DEFINE_BASECLASS("pluto_len_basegrenade")

function ENT:Explode()


    local cases = {
        [1] = Vector(80,0,5),
        [2] = Vector(0,80,5),
        [3] = Vector(-80,0,5),
        [4] = Vector(0,-80,5)
    }

    for i = 1,4,1 do
        local ent = ents.Create("pluto_cherry_bombs")
        if (not ent:IsValid()) then return end
        local thrower = self:GetOwner()
        local grenadepos = self:GetPos()
        ent:SetPos(grenadepos + cases[i])
        ent:SetOwner(self:GetOwner())
        ent:Spawn()
        timer.Simple(1.5, function()
            if IsValid(ent) then
                ent:Explode()
            end
        end)
    end
   
    local pos = self:GetPos()
	local effect = EffectData()
	effect:SetStart(pos)
	effect:SetOrigin(pos)
	effect:SetScale(100)
	effect:SetRadius(150 * self:GetRangeMulti())
	effect:SetMagnitude(1)
    self:FireBomb()
	util.Effect("Explosion", effect, true, true)
	util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), (150 * self:GetRangeMulti()), (75 * self:GetDamageMulti()))

end