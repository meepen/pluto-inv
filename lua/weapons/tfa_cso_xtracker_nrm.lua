SWEP.Base				= "tfa_cso_xtracker"

SWEP.Primary.Sound 			= Sound "XTracker.Fire"
SWEP.Primary.Delay				= 60 / 630

SWEP.Offset = {
	Pos = {
		Up = -4,
		Right = 0.7,
		Forward = 5,
	},
	Ang = {
		Up = -90,
		Right = 0,
		Forward = 170
	},
	Scale = 1.25
}

SWEP.ViewModel			= "models/weapons/tfa_cso/c_xtracker_nrm.mdl"
SWEP.WorldModel			= "models/weapons/tfa_cso/w_xtracker_nrm.mdl"

SWEP.Ironsights = {
	Pos = Vector(0, 2, 0),
	Angles = Vector(0, 0, 0),
	TimeTo = 0.2,
	TimeFrom = 0.15,
	SlowDown = 0.6,
	Zoom = 0.9,
}
SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 3500,
	DamageDropoffRangeMax = 6520,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.015, 0.015, 0),
}

SWEP.MuzzleAttachment			= "1"
SWEP.ShellAttachment			= "2"
SWEP.DoMuzzleFlash = true
SWEP.CustomMuzzleFlash = true
SWEP.AutoDetectMuzzleAttachment = true
SWEP.MuzzleFlashEffect = "muz_xtracker"

SWEP.Secondary.ScopeTable = false
SWEP.HasScope = false