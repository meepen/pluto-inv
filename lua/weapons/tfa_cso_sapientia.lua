SWEP.Base				= "weapon_tttbase"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Anri"
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false
SWEP.PrintName				= "Broken Promise"
SWEP.Slot				= 1

SWEP.Primary.Sound 			= Sound("Sapientia.Fire")
SWEP.Primary.Damage		= 60
SWEP.Primary.Automatic			= false
SWEP.Primary.Delay = 0.95

SWEP.Primary.ClipSize			= 7
SWEP.Primary.DefaultClip			= 14
SWEP.Primary.Ammo			= "357"


SWEP.ViewModel			= "models/weapons/tfa_cso/c_sapientia.mdl"
SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= true
SWEP.UseHands = true


SWEP.WorldModel			= "models/weapons/tfa_cso/w_sapientia.mdl"

SWEP.HoldType 				= "revolver"

SWEP.Offset = {
	Pos = {
		Up = -2.75,
		Right = 1,
		Forward = 6,
	},
	Ang = {
		Up = 90,
		Right = 0,
		Forward = 190
	},
	Scale = 1.25
}

SWEP.MuzzleAttachment			= "1"
SWEP.ShellAttachment			= "2"

SWEP.Ironsights = {
	Pos = Vector(4.25, 0, 1.73),
	Angle = Vector(0.3, -1.65, -2.85),
	TimeTo = 0.23,
	TimeFrom = 0.22,
	SlowDown = 0.7,
	Zoom = 0.9,
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 1000,
	DamageDropoffRangeMax = 5500,
	DamageMinimumPercent = 0.6,
	Spread = vector_origin,
}

SWEP.Primary.RecoilTiming  = 0.06
SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-70),
}

SWEP.Ortho = {-0.5, 0.8, angle = Angle(-45, -25, 0), size = 1.1}