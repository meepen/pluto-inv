SWEP.PrintName = "M14-S"

SWEP.ViewModel = "models/cod4/weapons/v_m14_silencer.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_m14_silencer.mdl"

SWEP.Base = "weapon_cod4_m14"

SWEP.Primary.Sound = "Weapon_CoD4_M14.Silenced" 

sound.Add {
	name = "Weapon_CoD4_M14.Silenced",
	channel = CHAN_WEAPON,
	volume = 0.5,
	sound = "cod4/weapons/m14/weap_m4_silencer_slst_1x.ogg"
}

SWEP.Ironsights = {
	TimeTo = 0.1,
	TimeFrom = 0.15,
	SlowDown = 0.4,
	Zoom = 0.85,
}

SWEP.AutoSpawnable = false

SWEP.CraftBuff = 3.3

SWEP.Ortho = {0, -2}