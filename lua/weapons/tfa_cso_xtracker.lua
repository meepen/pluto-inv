SWEP.Base				= "weapon_tttbase"
SWEP.Category				= "TFA CS:O"

SWEP.Author				= "Kamikaze"

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false
SWEP.DrawCrosshair			= true

SWEP.PrintName				= "X-TRACKER (Scoped)"
SWEP.Slot				= 2

SWEP.Primary.Sound 			= Sound "XTracker.Fire"

SWEP.Primary.Damage        = 21

SWEP.Primary.Automatic			= true
SWEP.Primary.Delay				= 60 / 550
SWEP.Primary.ClipSize			= 50
SWEP.Primary.DefaultClip			= 100
SWEP.Primary.Ammo			= "ar2"

SWEP.HeadshotMultiplier = 1.2

SWEP.ViewModel			= "models/weapons/tfa_cso/c_xtracker.mdl"
SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= true
SWEP.UseHands = true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_xtracker_nrm.mdl"

SWEP.HoldType 				= "ar2"

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

SWEP.ThirdPersonReloadDisable=false
SWEP.HasScope				= true

SWEP.Secondary.ScopeTable = {
	["ScopeMaterial"] =  Material("scope/xtracker_scope.png", "smooth"),
	["ScopeBorder"] = Color(53,185,173,14),
	["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 255, ["s"] = 0 }
}
SWEP.Ironsights = {
	Pos = Vector(5.802, -7.447, -5),
	Angles = Vector(-1.481, 0.98, 0),
	TimeTo = 0.2,
	TimeFrom = 0.15,
	SlowDown = 0.3,
	Zoom = 0.4,
}

SWEP.MuzzleAttachment			= "1"
SWEP.ShellAttachment			= "2"
SWEP.DoMuzzleFlash = true
SWEP.CustomMuzzleFlash = true
SWEP.AutoDetectMuzzleAttachment = true

SWEP.MuzzleFlashEffect = "muz_xtracker"
SWEP.Tracer				= 0
SWEP.TracerCount 		= 1

local pow = 1.4
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-6, -2),
	pow * Angle(-4, -1),
	pow * Angle(-2, 3),
	pow * Angle(-1, 2.5),
	pow * Angle(-3, 0),
	pow * Angle(-3, 1),
	pow * Angle(-3, -3),
}
SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 3500,
	DamageDropoffRangeMax = 6520,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.01, 0.015, 0),
	Tracer = 1,
	TracerName = "tfa_xtracker_sniper"
}
