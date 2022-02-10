AddCSLuaFile()

SWEP.Base = "weapon_ttt_basegrenade"
SWEP.PrintName = "Base Grenade"

SWEP.Primary.Delay = 3

SWEP.Slot = 3

SWEP.Primary.ClipSize = 1

SWEP.GrenadeEntity = "pluto_len_basegrenade"

SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel          = "models/weapons/cstrike/c_eq_smokegrenade.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Ortho = {2, 2.6}

SWEP.PlutoIcon             = "vgui/entities/confetti.png"

SWEP.Bounciness = 0.3
SWEP.DamageMulti = 1
SWEP.RangeMulti = 1
SWEP.Spiciness = 0
SWEP.LastHeld = nil
SWEP.AutoSpawnable = false

function SWEP:OnDrop()
    if (CLIENT) then return end
    if !IsValid(self) and self.LastHeld ~= nil then return end
    if !self.LastHeld:Alive() then
        local chance = math.random(100)
        if (chance <= self.MartyrDomChance) then
            local e = ents.Create(self.GrenadeEntity)
            e:SetOwner(self.LastHeld)
            e:SetPos(self:GetPos())
            e:Spawn()
        end
    end
end

function SWEP:Equip(owner)
self.LastHeld = owner
end

function SWEP:Throw()
	local e
	if (SERVER) then
		e = ents.Create(self.GrenadeEntity)
		e.DoRemove = true
	end

	if (IsValid(e)) then
		e:SetOrigin(self:GetOwner():EyePos())
		e:SetOwner(self:GetOwner())
		e.Owner = self:GetOwner()
		e:SETVelocity(self:GetOwner():GetAimVector() * self.ThrowVelocity + self:GetOwner():GetVelocity() * 0.8)
		e:SetDieTime(self:GetThrowStart() + self.Primary.Delay)
		e:SetBounciness(self.Bounciness)
		e:SetWeapon(self)
		e:Spawn()

        self:TakePrimaryAmmo(1)
		self:SetThrowStart(math.huge)
        if !(self:CanPrimaryAttack()) then
		    hook.Run("DropCurrentWeapon", self:GetOwner())
		    self:Remove()
        end
	end
end

