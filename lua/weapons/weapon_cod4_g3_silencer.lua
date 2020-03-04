SWEP.PrintName = "G3-S"
SWEP.Category = "Call of Duty 4: Modern Warfare"

SWEP.ViewModel = "models/cod4/weapons/v_g3_silencer.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_g3_silencer.mdl"

SWEP.Base = "weapon_cod4_g3"

SWEP.Primary.Sound = "Weapon_CoD4_G3.Silenced"

sound.Add {
	name = "Weapon_CoD4_G3.Silenced",
	channel = CHAN_WEAPON,
	volume = 0.5,
	sound = "cod4/weapons/g3/weap_m4_silencer_slst_1x.ogg"
}

SWEP.AutoSpawnable = false

SWEP.Ortho = {0, -0.5}
