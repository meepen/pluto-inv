SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Anri"
SWEP.PrintName				= "Crystalized Acid"
SWEP.Slot				= 2

--[[WEAPON HANDLING]]--

--Firing related
SWEP.Primary.Sound 			= Sound("SF Ethereal.Fire")
SWEP.Primary.Damage		= 12
SWEP.HeadshotMultiplier = 1.4
SWEP.Primary.Automatic			= true
SWEP.Primary.Delay				= 60 / 650

SWEP.Primary.ClipSize			= 60
SWEP.Primary.DefaultClip			= 120
SWEP.Primary.Ammo			= "ar2"
--[[VIEWMODEL]]--

SWEP.ViewModel			= "models/weapons/tfa_cso/c_ethereal.mdl"
SWEP.ViewModelFlip = true
SWEP.WorldModel			= "models/weapons/tfa_cso/w_ethereal.mdl"

SWEP.HoldType 				= "ar2"

SWEP.Offset = {
	Pos = {
		Up = -4.5,
		Right = 0.7,
		Forward = 8,
	},
	Ang = {
		Up = -90,
		Right = -0,
		Forward = 170
	},
	Scale = 1
}

SWEP.MuzzleAttachment			= "0"
SWEP.ShellAttachment			= "2"

SWEP.MuzzleFlashEffect = "tfa_muzzleflash_sniper_energy"

SWEP.TracerName 		= "tfa_tracer_gauss"

local pow = 1.35
SWEP.RecoilInstructions = {
	Interval = 1,
	angle_zero,
}

SWEP.Ironsights = false