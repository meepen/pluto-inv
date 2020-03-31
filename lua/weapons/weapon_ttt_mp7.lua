AddCSLuaFile()

SWEP.Base				= "weapon_tttbase"

SWEP.PrintName				= "MP7"
SWEP.Slot				= 2
SWEP.SlotPos				= 0
SWEP.DrawCrosshair			= true
SWEP.HoldType 				= "smg"

SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/razorswep/weapons/v_smg_mp7.mdl"
SWEP.WorldModel				= "models/razorswep/weapons/w_smg_mp7.mdl"

SWEP.AutoSpawnable          = false
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("Weapon_mp7.shoot") --razorswep/mp7/mp7.ogg  ---place holder Weapon_SMG1.Double
SWEP.Primary.Delay			= 60 / 700
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip		= 60
SWEP.Primary.Recoil = 2
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo			= "pistol"
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.Primary.NumShots	= 1
SWEP.Primary.Damage		= 16
SWEP.HeadshotMultiplier = 1.3

SWEP.Ironsights = {
	Pos = Vector(-2.425, -2.343, 0.647),
	Angle = Vector(0.681, -0.005, 0),
	TimeTo = 0.2,
	TimeFrom = 0.15,
	SlowDown = 0.3,
	Zoom = 0.9,
}

SWEP.Offset = {
	Pos = {
		Up = -2.5,
		Right = 1.5,
		Forward = 4.5
	},
	Ang = {
		Up = 5,
		Right = -8,
		Forward = 180
	},
	Scale = 1
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 300,
	DamageDropoffRangeMax = 900,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.035, 0.045)
}

local pow = 0.6
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-6, -2),
	pow * Angle(-4, -1),
	pow * Angle(-2, 3),
	pow * Angle(-1, 0),
	pow * Angle(-1, 0),
	pow * Angle(-3, 2),
	pow * Angle(-3, 1),
	pow * Angle(-2, 0),
	pow * Angle(-3, -3),
}





-- sounds


local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/magout.ogg"
instbl["name"] = "MP7.magout"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/magdraw.ogg"
instbl["name"] = "MP7.magdraw"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/magin.ogg"
instbl["name"] = "MP7.magin"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/magin2.ogg"
instbl["name"] = "MP7.magin2"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/boltrelease.ogg"
instbl["name"] = "MP7.boltrelease"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/handle.ogg"
instbl["name"] = "MP7.handle"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/draw.ogg"
instbl["name"] = "MP7.draw"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/foregrip.ogg"
instbl["name"] = "MP7.foregrip"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/mp7.ogg"
instbl["name"] = "MP7.fire"

sound.Add(instbl)

sound.Add {
	name = "Weapon_mp7.shoot",
	channel = CHAN_WEAPON,
	volume = 1,
	soundlevel = 50,
	sound = "razorswep/mp7/mp7.ogg"
}