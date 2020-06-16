AddCSLuaFile()

SWEP.HoldType              = "ar2"

SWEP.PrintName          = "D-101 Longbow DMR"
SWEP.Slot               = 2

SWEP.ViewModelFlip      = false
SWEP.ViewModelFOV       = 64

SWEP.Ortho = {-10, 12}

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_RIFLE
SWEP.ViewModelFOV          = 65
SWEP.UseHands = true
SWEP.NoPlayerModelHands = false

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 5300,
	DamageDropoffRangeMax = 9600,
	DamageMinimumPercent = 0.1,
	Spread = vector_origin
}

SWEP.Primary.Damage        = 35
SWEP.Primary.Delay         = 0.285
SWEP.Primary.Recoil        = 8
SWEP.Primary.RecoilTiming  = 0.09
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "357"
SWEP.Primary.ClipSize      = 12
SWEP.Primary.DefaultClip   = 24
SWEP.Primary.Sound         = "Weapon_DMR.shoot"

SWEP.Secondary.Sound       = Sound "Default.Zoom"

SWEP.IsSilent = false
SWEP.HeadshotMultiplier    = 2
SWEP.DeploySpeed = 1.3
SWEP.ReloadSpeed = 1

SWEP.AutoSpawnable         = false
SWEP.Spawnable             = false
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.ViewModel             = "models/weapons/rspn101_dmr/ptpov_rspn101_dmr.mdl"
SWEP.WorldModel            = "models/weapons/rspn101_dmr/w_rspn101_dmr.mdl"
SWEP.HasScope              = true
SWEP.IsSniper              = false

SWEP.Offset = {
	Pos = {
		Up = 2,
		Right = 1,
		Forward = 0,
	},
	Ang = {
		Up = 0,
		Right = -10,
		Forward = 180,
	}
}

sound.Add {
	name = "Weapon_DMR.shoot",
	channel = CHAN_WEAPON,
	volume = 1,
	soundlevel = 50,
	sound = "weapons/dmr/wpn_dmr_1p_wpnfire_crack_2ch_v1_01.wav"
}