AddCSLuaFile()

ENT.PrintName = "Rolling Thunder Grenade"
ENT.Base = "ttt_basegrenade"
ENT.Model = "models/weapons/w_eq_smokegrenade_thrown.mdl"
DEFINE_BASECLASS("ttt_basegrenade")

function ENT:GetThunderStrikes()
    if self.WeaponData == nil then return end
    if self.WeaponData.ThunderStrikes == nil then return end
    return self.WeaponData.ThunderStrikes
end

function ENT:Initialize()
    if (CLIENT) then end
    self.ThunderStrikes = (self:GetThunderStrikes() or 3)
    self:SetMoveType(MOVETYPE_NONE)
	self:SetModel(self.Model)
	self:DrawShadow(false)
end


function ENT:Explode()
	if not IsValid(self.Owner) then
		self.Entity:Remove()
		return
	end
    local pos = self:GetPos()
	local effect = EffectData()
	effect:SetStart(pos)
	effect:SetOrigin(pos)
	effect:SetScale(100)
	effect:SetRadius(100 * self:GetRangeMultiplier())
	effect:SetMagnitude(1)
	util.Effect("Explosion", effect, true, true)
	util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), (150 * self:GetRangeMultiplier()), (50 * self:GetDamageMultiplier()))
    self.ThunderStrikes = self.ThunderStrikes - 1
    if self.ThunderStrikes <= 0 then
        self.Entity:Remove()
    end
end

function ENT:GrenadeBounce()
    self:Explode()
end

