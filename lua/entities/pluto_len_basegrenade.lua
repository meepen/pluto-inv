AddCSLuaFile()


ENT.Base = "ttt_basegrenade"
ENT.Model = "models/weapons/w_eq_flashbang_thrown.mdl"


function ENT:GetDamageMulti()
    if self.WeaponData == nil then return end
    if self.WeaponData.DamageMulti == nil then return end
    return self.WeaponData.DamageMulti
end


function ENT:GetRangeMulti()
    if self.WeaponData == nil then return end
    if self.WeaponData.RangeMulti == nil then return end
    return self.WeaponData.RangeMulti
end