SWEP.PrintName = "AK-47-S"

SWEP.ViewModel = "models/cod4/weapons/v_ak47_silencer.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_ak47_silencer.mdl"

SWEP.Base = "weapon_cod4_ak47"

SWEP.Primary.Sound = "Weapon_CoD4_AK47.Silenced"

sound.Add {
	name = "Weapon_CoD4_AK47.Silenced",
	channel = CHAN_WEAPON,
	volume = 0.5,
	sound = "cod4/weapons/ak47/weap_m4_silencer_slst_1x.wav"
}

SWEP.AutoSpawnable = false

SWEP.Ortho = {0, -2.5}