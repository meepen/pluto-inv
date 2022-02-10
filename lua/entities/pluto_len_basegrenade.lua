AddCSLuaFile()


ENT.Base = "ttt_basegrenade"
ENT.Model = "models/weapons/w_eq_flashbang_thrown.mdl"


function ENT:GetDamageMulti()
    if self.WeaponData == nil then return 1 end
    if self.WeaponData.DamageMulti == nil then return 1 end
    return self.WeaponData.DamageMulti
end


function ENT:GetRangeMulti()
    if self.WeaponData == nil then return 1 end
    if self.WeaponData.RangeMulti == nil then return 1 end
    return self.WeaponData.RangeMulti
end

function ENT:GetMartyrDomChance()
    if self.WeaponData == nil then return 0 end
    if self.WeaponData.MartyrDomChance == nil then return 0 end
    return self.WeaponData.MartyrDomChance
end

function ENT:GetSpiciness()
    if self.WeaponData == nil then return 0 end
    if self.WeaponData.Spiciness == nil then return 0 end
    return self.WeaponData.Spiciness
end

function ENT:FireBomb()
    local chance = math.random(100)
    if (chance <= self:GetSpiciness()) then
        self:StartFires(self:GetPos(),6,10,false,self:GetOwner())
    end
end