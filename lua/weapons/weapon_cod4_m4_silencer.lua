SWEP.PrintName = "M4 Carbine-S"

SWEP.ViewModel = "models/cod4/weapons/v_m4_silencer.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_m4_silencer.mdl"

SWEP.Base = "weapon_cod4_m4"

SWEP.Primary.Sound = "Weapon_CoD4_M4.Silenced"

sound.Add {
	name = "Weapon_CoD4_M4.Silenced",
	channel = CHAN_WEAPON,
	volume = 0.5,
	sound = "cod4/weapons/m4/weap_m4_silencer_slst_1x.wav"
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 2500,
	DamageMinimumPercent = 0.15,
	Spread = Vector(0.015, 0.015),
}

SWEP.AutoSpawnable = false
