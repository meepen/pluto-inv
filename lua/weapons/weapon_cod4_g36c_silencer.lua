SWEP.PrintName = "G36C-S"

SWEP.ViewModel = "models/cod4/weapons/v_g36c_silencer.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_g36c_silencer.mdl"

SWEP.Base = "weapon_cod4_g36c"

SWEP.Primary.Sound = "Weapon_CoD4_G36C.Silenced"

sound.Add {
	name = "Weapon_CoD4_G36C.Silenced",
	channel = CHAN_WEAPON,
	volume = 0.5,
	sound = "cod4/weapons/g36c/weap_m4_silencer_slst_1x.ogg"
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 2200,
	DamageMinimumPercent = 0.12,
	Spread = Vector(0.01, 0.01),
}

SWEP.AutoSpawnable = false

SWEP.CraftBuff = 3.3

SWEP.Ortho = {3, -4.5}