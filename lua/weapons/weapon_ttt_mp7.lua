AddCSLuaFile()
local path = "weapons/tfa_ins2/mp7/"
local pref = "TFA_INS2.MP7"

TFA.AddFireSound(pref .. ".1", path .. "fp.ogg", false, ")")
TFA.AddFireSound(pref .. ".2", path .. "fp_suppressed.ogg", false, ")")

TFA.AddWeaponSound("TFA_INS2.BipodSwivel", { "weapons/tfa_ins2/uni/uni_bipod_swivel_01.ogg", "weapons/tfa_ins2/uni/uni_bipod_swivel_02.ogg", "weapons/tfa_ins2/uni/uni_bipod_swivel_03.ogg", "weapons/tfa_ins2/uni/uni_bipod_swivel_04.ogg", "weapons/tfa_ins2/uni/uni_bipod_swivel_05.ogg" })

TFA.AddWeaponSound(pref .. ".Empty", path .. "empty.ogg")
TFA.AddWeaponSound(pref .. ".Boltback", path .. "boltback.ogg")
TFA.AddWeaponSound(pref .. ".Boltrelease", path .. "boltrelease.ogg")
TFA.AddWeaponSound(pref .. ".Magrelease", path .. "magrelease.ogg")
TFA.AddWeaponSound(pref .. ".Magout", path .. "magout.ogg")
TFA.AddWeaponSound(pref .. ".Magin", path .. "magin.ogg")
TFA.AddWeaponSound(pref .. ".ROF", path .. "fireselect.ogg")


SWEP.Base				= "weapon_tttbase"

SWEP.Author				= "Trash Burglar"
SWEP.PrintName				= "MP7"
SWEP.Slot				= 2
SWEP.SlotPos				= 0
SWEP.DrawCrosshair			= true
SWEP.HoldType 				= "smg"

SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/tfa_ins2/c_mp7.mdl"
SWEP.WorldModel				= "models/weapons/tfa_ins2/w_mp7.mdl"

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

SWEP.Primary.Sound			= pref .. ".1"
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