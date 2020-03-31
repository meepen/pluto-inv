AddCSLuaFile()

SWEP.Base				= "weapon_tttbase"

SWEP.Author				= "Trash Burglar"
SWEP.PrintName				= "MP7"
SWEP.Slot				= 2
SWEP.SlotPos				= 0
SWEP.DrawCrosshair			= true
SWEP.HoldType 				= "smg"

SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/razorswep/weapons/v_smg_mp7.mdl"
SWEP.WorldModel				= "models/razorswep/weapons/w_smg_mp7.mdl"

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

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("razorswep/mp7/mp7.wav")
SWEP.Primary.Delay			= 60 / 950
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip		= 60
SWEP.Primary.Recoil = 1.1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo			= "pistol"
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.Primary.NumShots	= 1
SWEP.Primary.Damage		= 16
SWEP.HeadshotMultiplier = 1.6

SWEP.Ironsights = {
	Pos = Vector(-2.425, -2.343, 0.647),
	Angle = Vector(0.681, -0.005, 0),
	TimeTo = 0.2,
	TimeFrom = 0.15,
	SlowDown = 0.3,
	Zoom = 0.9,
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 300,
	DamageDropoffRangeMax = 900,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.035, 0.045)
}

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/magout.wav"
instbl["name"] = "MP7.magout"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/magdraw.wav"
instbl["name"] = "MP7.magdraw"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/magin.wav"
instbl["name"] = "MP7.magin"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/magin2.wav"
instbl["name"] = "MP7.magin2"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/boltrelease.wav"
instbl["name"] = "MP7.boltrelease"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/handle.wav"
instbl["name"] = "MP7.handle"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/draw.wav"
instbl["name"] = "MP7.draw"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/mp7/foregrip.wav"
instbl["name"] = "MP7.foregrip"

sound.Add(instbl)