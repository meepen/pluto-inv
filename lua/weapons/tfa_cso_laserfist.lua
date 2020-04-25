SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Kamikaze"

SWEP.PrintName				= "Infinity Laser Fist"
SWEP.Slot				= 2

SWEP.Primary.Sound 			= Sound "Laserfist.FireA"
SWEP.Primary.Damage		= 10

SWEP.Primary.Automatic			= true
SWEP.Primary.Delay				= 60 / 1000
SWEP.Primary.ClipSize			= 500
SWEP.Primary.AmmoConsumption = 4
SWEP.Primary.DefaultClip			= 3000
SWEP.Primary.Ammo			= "smg1"


SWEP.ViewModel			= "models/weapons/tfa_cso/c_laserfist.mdl"
SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= true
SWEP.UseHands = true
SWEP.Ironsights = false


SWEP.WorldModel			= "models/weapons/tfa_cso/w_laserfist_r.mdl"

SWEP.HoldType 				= "duel"

SWEP.WElements = {
	["otherfist"] = { type = "Model", model = "models/weapons/tfa_cso/w_laserfist_l.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(6.479, 1.812, 1.055), angle = Angle(0, 75.515, 0), size = Vector(1.2, 1.2,1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = {
	Pos = {
		Up = -1,
		Right = 1.25,
		Forward = 8,
	},
	Ang = {
		Up = -90,
		Right = 0,
		Forward = 180
	},
	Scale = 1.2
}

SWEP.MuzzleAttachment			= "0"
--SWEP.MuzzleAttachmentRaw = 1
SWEP.ShellAttachment			= "2"

SWEP.DoMuzzleFlash = true
SWEP.CustomMuzzleFlash = true
SWEP.AutoDetectMuzzleAttachment = true
SWEP.MuzzleFlashEffect = "tfa_muzzleflash_sniper_energy"

SWEP.RecoilInstructions = {
	Interval = 1,
	angle_zero,
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 0,
	DamageDropoffRangeMax = 6200,
	DamageMinimumPercent = 0.4,
	Spread = Vector(0.03, 0.03),
}

SWEP.AllowDrop = false