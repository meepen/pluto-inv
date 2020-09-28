SWEP.HoldType = "pistol"
if SERVER then
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )

	SWEP.Weight = 2
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
	SWEP.tblSounds = {}
	SWEP.tblSounds["Primary"] = "npc/legion/handgun_gen.wav"
	SWEP.tblSounds["Reload"] = "npc/legion/handgun_reload.wav"
end

if CLIENT then
	SWEP.CSMuzzleFlashes = true
end

SWEP.Base = "ai_weapons_base"
-- SWEP.Category		= "Half-Life 1"
SWEP.InWater = true

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/masseffect/weapons/w_pistolc.mdl"
SWEP.WorldModel = "models/masseffect/weapons/w_pistolc.mdl"

SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.014
SWEP.Primary.Delay = 0.9
SWEP.Primary.Damage = "sk_dmg_bullet"
SWEP.Primary.Ammo = "none"
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.AmmoSize = 72
SWEP.Primary.AmmoPickup	= 15
SWEP.PrimaryClip = 15

SWEP.Type = "pistol"
SWEP.DelayEquip = 0.7
SWEP.ReloadTime = 0.45

function SWEP:DoReload()
	-- self.Owner:StopMoving()
	-- self.Owner:RestartGesture(ACT_RELOAD)
	self.Owner:PlayLayeredGesture(self.Owner.WeaponReload,2,1)
	if SERVER then
		self:slvPlaySound("Reload")
	end
	self.Weapon:SetNextSecondaryFire(CurTime() +self.ReloadTime)
	self.Weapon:SetNextPrimaryFire(CurTime() +self.ReloadTime)
	-- timer.Simple(0.4,function() if IsValid(self) then
		self.PrimaryClip = 15
	-- end end)
	return true
end

function SWEP:ShootEffects(bSecondary)
	self.Owner:MuzzleFlash()
end