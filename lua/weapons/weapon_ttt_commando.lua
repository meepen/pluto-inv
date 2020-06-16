AddCSLuaFile()

SWEP.HoldType              = "ar2"

SWEP.PrintName          = "Commando"
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
SWEP.Primary.Sound         = Sound "Weapon_commando.shoot"

SWEP.HeadshotMultiplier    = 1.4
SWEP.DeploySpeed = 1.5

SWEP.AutoSpawnable         = false
SWEP.Spawnable             = false
SWEP.AmmoEnt               = "item_ammo_smg1_ttt"

SWEP.ViewModel             = "models/razorswep/weapons/v_rif_comma.mdl"
SWEP.WorldModel            = "models/razorswep/weapons/w_rif_comm.mdl"

SWEP.Ironsights = {
	Pos = Vector(-5.18, -10, 0.89),
	Angle = Vector(-0.3, 0.39, -1),
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


--Crotch Gun Fix
SWEP.Offset = {
	Pos = {
		Up = 0,
		Right = 1,
		Forward = -3,
	},
	Ang = {
		Up = 0,
		Right = 0,
		Forward = 180,
	}
}

sound.Add {
	name = "Weapon_commando.shoot",
	channel = CHAN_WEAPON,
	volume = 1,
	soundlevel = 50,
	sound = "razorswep/commando/fire.wav"
}