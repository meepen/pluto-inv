SWEP.Base				= "weapon_ttt_shotgun"
SWEP.Category				= "TFA CS:O2"

SWEP.PrintName				= "Dragon's Breath"
SWEP.Slot				= 2

SWEP.Primary.Sound = Sound("tfa_cso2_m3dragon.1")
SWEP.Primary.Damage = 4.5

SWEP.Bullets = {
	HullSize = 0,
	Num = 12,
	DamageDropoffRange = 600,
	DamageDropoffRangeMax = 3600,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.1, 0.1),
	TracerName = "tfa_tracer_incendiary"
}

SWEP.Primary.Delay = 1.2
SWEP.Primary.Automatic = true

SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 16

SWEP.ViewModelFOV			= 75
SWEP.ViewModelFlip			= true
SWEP.UseHands = true
SWEP.HoldType = "shotgun"
SWEP.Offset = {
	Pos = {
		Up = -0.5,
		Right = 0.5,
		Forward = 3.5
	},
	Ang = {
		Up = -1,
		Right = 15,
		Forward = 178
	},
	Scale = 1
}

SWEP.Ortho = {-4, 4, angle = Angle(180, 110, 210)}

SWEP.Ironsights = {
	Pos = Vector(5.3, 0, 1.48),
	Angle = Vector(-0, 0, 0),
	Zoom = 0.9
}

SWEP.Spawnable = false
SWEP.AutoSpawnable = false

SWEP.TracerName 		= "tfa_tracer_incendiary"
SWEP.TracerCount 		= 3

SWEP.WorldModel			= "models/weapons/tfa_cso2/w_m3dragon.mdl"
SWEP.ViewModel			= "models/weapons/tfa_cso2/c_m3dragon.mdl"

DEFINE_BASECLASS(SWEP.Base)

function SWEP:FireBulletsCallback(tr, dmginfo)
	BaseClass.FireBulletsCallback(self, tr, dmginfo)
	if (SERVER and IsValid(tr.Entity)) then
		if (tr.Entity:IsPlayer() and not tr.Entity:Alive()) then
			return
		end
		tr.Entity:Ignite(2)

		if (tr.Entity:IsPlayer()) then
			pluto.statuses.limp(tr.Entity, self:GetDelay())
		end
	end
end
