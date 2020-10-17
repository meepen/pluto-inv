AddCSLuaFile()

SWEP.Base				= "weapon_tttbase"

SWEP.PrintName				= "MP7"
SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawCrosshair			= true
SWEP.HoldType 				= "smg"

SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/razorswep/weapons/v_smg_mp7.mdl"
SWEP.WorldModel				= "models/razorswep/weapons/w_smg_mp7.mdl"

SWEP.AutoSpawnable         = true	
SWEP.Spawnable             = true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("Weapon_mp7.shoot") --razorswep/mp7/mp7.ogg  ---place holder Weapon_SMG1.Double
SWEP.Primary.Delay			= 60 / 750
SWEP.Primary.ClipSize			= 30
SWEP.Primary.DefaultClip		= 60
SWEP.Primary.Recoil = 2
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Primary.NumShots	= 1
SWEP.Primary.Damage		= 10
SWEP.HeadshotMultiplier = 1.75
SWEP.DeploySpeed = 1.78
SWEP.ReloadSpeed = 1.06
SWEP.Ortho = {0, 5}

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

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 300,
	DamageDropoffRangeMax = 1500,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.035, 0.045)
}

local power = 4

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-power, -power * 0.6),
	Angle(-power, -power * 0.48),
	Angle(-power, -power * 0.2),
	Angle(-power, power * 0.4),
	Angle(-power, power * 0.2),
	Angle(-power, power * 0.6),
	Angle(-power, power * 0.35),
	Angle(-power, power * 0.2),
	Angle(-power, -power * 0.2),
	Angle(-power, -power * 0.4),
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