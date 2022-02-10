AddCSLuaFile()

ENT.PrintName = "Rolling Thunder Grenade"
ENT.Base = "pluto_len_basegrenade"
ENT.Model = "models/weapons/w_eq_smokegrenade_thrown.mdl"
DEFINE_BASECLASS("pluto_len_basegrenade")

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
    timer.Create("thundercrack",10,1, function()
        if self:IsValid() && (SERVER) then
            self.ThunderStrikes = 1
            self:Explode()
        end
    end)
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
	effect:SetRadius(100 * self:GetRangeMulti())
	effect:SetMagnitude(1)
    self:FireBomb()
	util.Effect("Explosion", effect, true, true)
	util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), (100 * self:GetRangeMulti()), (35 * self:GetDamageMulti()))
    self.ThunderStrikes = self.ThunderStrikes - 1
    if self.ThunderStrikes <= 0 then
        self.Entity:Remove()
        timer.Remove("thundercrack")
    end
end

function ENT:Think()
    self:Move()
	self:NextThink(CurTime())
	if (CLIENT) then
		self:SetNextClientThink(CurTime())
		--debugoverlay.Box(self:GetOrigin(), self.Bounds.Mins, self.Bounds.Maxs, 1, color_white)
	end

	return true
end

function ENT:GrenadeBounce()
    self:Explode()
end

