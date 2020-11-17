AddCSLuaFile()

sound.Add {
	name = "CW_PPS_FIRE",
	channel = CHAN_WEAPON,
	sound = "weapons/pps/p90-1.ogg"
}
sound.Add {
	name = "CW_PPS_MAGOUT",
	channel = CHAN_WEAPON,
	sound = "weapons/pps/p90_clipout.ogg"
}
sound.Add {
	name = "CW_PPS_MAGIN",
	channel = CHAN_WEAPON,
	sound = "weapons/pps/p90_clipin.ogg"
}
sound.Add {
	name = "CW_PPS_BOLTPULL",
	channel = CHAN_WEAPON,
	sound = "weapons/pps/p90_boltpull.ogg"
}
sound.Add {
	name = "CW_PPS_BOLTFORWARD",
	channel = CHAN_WEAPON,
	sound = "weapons/pps/p90_cliprelease.ogg"
}

SWEP.Offset = {
	Pos = {
		Up = -3,
		Right = 1,
		Forward = 0,
	},
	Ang = {
		Up = 0,
		Right = -10,
		Forward = 180,
	}
}

SWEP.Ortho = {-5, -1}

SWEP.DrawCrosshair = true
SWEP.PrintName = "PPSh"
SWEP.CSMuzzleFlashes = true

SWEP.Ironsights = {
	Pos = Vector(6.3, -4, 2.1),
	Angle = Vector(1, 0, 0),
	TimeTo = 0.25,
	TimeFrom = 0.22,
	SlowDown = 0.39,
	Zoom = 0.9,
}

SWEP.Sounds = {
	reload = {
		{time = 0.4, sound = "CW_PPS_MAGOUT"},
		{time = 2, sound = "CW_PPS_MAGIN"},
		{time = 3.05, sound = "CW_PPS_BOLTPULL"},
		{time = 3.3, sound = "CW_PPS_BOLTFORWARD"}
	}
}

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "ar2"

SWEP.Author			= "Spy"

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= true
SWEP.ViewModel		= "models/weapons/pps/v_smg_pps.mdl"
SWEP.WorldModel		= "models/weapons/pps/w_smg_pps.mdl"

SWEP.Primary.ClipSize		= 60
SWEP.Primary.DefaultClip	= 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo          = "smg1"

SWEP.Primary.Sound = "CW_PPS_FIRE"
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 60 / 850
SWEP.Primary.Damage = 10.5
SWEP.ReloadSpeed = 1.3
SWEP.DeploySpeed = 1.4

SWEP.HeadshotMultiplier = 1.6

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AdminSpawnable		= true

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 250,
	DamageDropoffRangeMax = 1500,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.035, 0.045)
}

local power = 10
SWEP.RecoilInstructions = {
	Interval = 2,
	Angle(-power, -power * 0.6),
	Angle(-power, -power * 0.48),
	Angle(-power, power * 0.6),
	Angle(-power, power * 0.7),
	Angle(-power, power * 1),
	Angle(-power, power * 0.55),
	Angle(-power, power * 0.2),
	Angle(-power, -power * 0.5),
	Angle(-power, -power * 0.7),
	Angle(-power, -power * 0.45),
}