AddCSLuaFile()

local instbl = {}
instbl["channel"] = CHAN_WEAPON
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "weapons/tfa_csgo/tec9/tec9_clipin.ogg"
instbl["name"] = "TFA_CSGO_TEC9.CLIPIN"
sound.Add(instbl)

local instbl = {}
instbl["channel"] = CHAN_WEAPON
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "weapons/tfa_csgo/tec9/tec9_clipout.ogg"
instbl["name"] = "TFA_CSGO_TEC9.CLIPOUT"
sound.Add(instbl)

local instbl = {}
instbl["channel"] = CHAN_WEAPON
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "weapons/tfa_csgo/tec9/tec9_boltpull.ogg"
instbl["name"] = "TFA_CSGO_TEC9.BOLTPULL"
sound.Add(instbl)

local instbl = {}
instbl["channel"] = CHAN_WEAPON
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "weapons/tfa_csgo/tec9/tec9_boltrelease.ogg"
instbl["name"] = "TFA_CSGO_TEC9.BOLTRELEASE"
sound.Add(instbl)

local instbl = {}
instbl["channel"] = CHAN_WEAPON
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "weapons/tfa_csgo/tec9/tec9_draw.ogg"
instbl["name"] = "TFA_CSGO_TEC9.DRAW"
sound.Add(instbl)

local instbl = {}
instbl["channel"] = CHAN_WEAPON
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "0"
instbl["pitch"] = "95,105"
instbl["sound"] = "weapons/tfa_csgo/tec9/tec9-1.ogg"
instbl["name"] = "TFA_CSGO_TEC9.1"
sound.Add(instbl)

SWEP.Base = "weapon_tttbase"
SWEP.Category = "SMGs"
SWEP.Author = "Trash Burglar"

SWEP.PrintName = "Tec-9"
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Ortho = {0, -0.5, angle = Angle(0, -90, 90)}

SWEP.ViewModelFOV = 47
SWEP.ViewModelFlip = false
SWEP.HoldType = "pistol"
SWEP.ViewModel = "models/weapons/tfa_csgo/tec9/c_tec9.mdl"
SWEP.WorldModel = "models/weapons/tfa_csgo/tec9/w_tec9.mdl"

SWEP.Offset = {
	Pos = {
		Up =  -2,
		Right = 1,
		Forward = 7
	},
	Ang = {
		Up = 0,
		Right = 90,
		Forward = 180,
	}
}

SWEP.HeadshotMultiplier = 1.5

SWEP.Primary.Damage = 16
SWEP.Primary.Sound = "TFA_CSGO_TEC9.1"
SWEP.Primary.Delay = 60 / 500
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 64
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 2
SWEP.Primary.Ammo          = "smg1"
SWEP.AmmoEnt               = "item_ammo_smg1_ttt"

SWEP.Ironsights = {
	Pos = Vector(-5.14, -2, 2.6),
	Angle = vector_origin,
	TimeTo = 0.18,
	TimeFrom = 0.13,
	SlowDown = 0.42,
	Zoom = 0.9,
}

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AdminSpawnable		= true

SWEP.Primary.Recoil = 1

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 300,
	DamageDropoffRangeMax = 1200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.02, 0.02)
}

function SWEP:FireAnimationEvent(_, _, event)
	if (event == 5001) then
		return true
	end
end