AddCSLuaFile()

SWEP.HoldType              = "ar2"

SWEP.PrintName          = "UMP45"
SWEP.Slot               = 2

SWEP.ViewModelFlip      = false
SWEP.ViewModelFOV       = 64

SWEP.Ortho = {2, 7.5}

SWEP.Base                  = "weapon_tttbase"

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 600,
	DamageDropoffRangeMax = 3500,
	DamageMinimumPercent = 0.35,
	Spread = Vector(0.01, 0.01, 0),
}

SWEP.Primary.Damage        = 19
SWEP.Primary.Delay         = 0.115
SWEP.Primary.Recoil        = 1.5
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "SMG1"
SWEP.Primary.ClipSize      = 25 --30
SWEP.Primary.DefaultClip   = 50 --60
SWEP.Primary.Sound         = Sound "Weapon_UMP45.Single"

SWEP.HeadshotMultiplier    = 1.4
SWEP.DeploySpeed = 1.5

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_smg1_ttt"

SWEP.ViewModel             = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel            = "models/weapons/w_smg_ump45.mdl"

SWEP.Ironsights = {
	Pos = Vector(-8.8, -2, 4.3),
	Angle = Vector(-1.3, -0.4, -3),
	TimeTo = 0.175,
	TimeFrom = 0.175,
	SlowDown = 0.45,
	Zoom = .9,
}

local power = 6

SWEP.RecoilInstructions = {
	Interval = 2,
	Angle(-power * 1.4, -power * 0.6),
	Angle(-power * 1.4, -power * 0.48),
	Angle(-power * 1.4, -power * 0.2),
	Angle(-power * 1.4, power * 0.4),
	Angle(-power * 1.4, power * 0.2),
	Angle(-power * 1.4, power * 0.6),
	Angle(-power * 1.4, power * 0.35),
	Angle(-power * 1.4, power * 0.2),
	Angle(-power * 1.4, -power * 0.2),
	Angle(-power * 1.4, -power * 0.4),
}