SWEP.PrintName = "AK-47-S"
SWEP.Category = "Call of Duty 4: Modern Warfare"

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/cod4/weapons/v_ak47_silencer.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_ak47_silencer.mdl"
SWEP.ViewModelFlip = false

SWEP.Slot = 2

SWEP.UseHands = false
SWEP.HoldType = "ar2"

SWEP.Base = "weapon_ttt_cod4_base"

SWEP.Primary.Sound = "Weapon_CoD4_AK47.Silenced"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Damage = 40
SWEP.Primary.Delay = 0.085

sound.Add {
	name = "Weapon_CoD4_AK47.Silenced",
	channel = CHAN_WEAPON,
	volume = 0.5,
	sound = "cod4/weapons/ak47/weap_m4_silencer_slst_1x.wav"
}