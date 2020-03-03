SWEP.PrintName = "G36C"

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/cod4/weapons/v_g36c.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_g36c.mdl"
SWEP.ViewModelFlip = false

SWEP.Slot = 2

SWEP.UseHands = false
SWEP.HoldType = "ar2"

SWEP.Base = "weapon_ttt_cod4_base"

SWEP.Primary.Sound = "Weapon_CoD4_G36C.Single"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Damage = 12.5
SWEP.Primary.Delay = 0.08

SWEP.ReloadSpeed = 1.3

SWEP.HeadshotMultiplier = 15 / SWEP.Primary.Damage

SWEP.Sights = true

sound.Add {
	name = "Weapon_CoD4_G36C.Single",
	channel = CHAN_WEAPON,
	level = 80,
	sound = "cod4/weapons/g36c/weap_g36_slst_1.wav"
}
sound.Add {
	name = "Weapon_CoD4_G36C.Chamber",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g36c/wpfoly_g36_reload_chamber_v1.wav"
}
sound.Add {
	name = "Weapon_CoD4_G36C.ClipIn",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g36c/wpfoly_g36_reload_clipin_v1.wav"
}
sound.Add {
	name = "Weapon_CoD4_G36C.ClipOut",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g36c/wpfoly_g36_reload_clipout_v1.wav"
}
sound.Add {
	name = "Weapon_CoD4_G36C.Lift",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g36c/wpfoly_g36_reload_lift_v1.wav"
}

local pow = 2.5
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-6, -2),
	pow * Angle(-4, -1),
	pow * Angle(-2, 3),
	pow * Angle(-1, 0),
	pow * Angle(-1, 0),
	pow * Angle(-3, 2),
	pow * Angle(-3, 1),
	pow * Angle(-2, 0),
	pow * Angle(-3, -3),
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 1600,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.035, 0.035),
}

SWEP.Ironsights = {
	TimeTo = 0.25,
	TimeFrom = 0.15,
	SlowDown = 0.6,
	Zoom = 0.8,
}