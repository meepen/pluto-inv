SWEP.PrintName = "G36C"

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/cod4/weapons/v_g36c.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_g36c.mdl"
SWEP.ViewModelFlip = false

SWEP.Slot = 2

SWEP.UseHands = false
SWEP.HoldType = "smg"

SWEP.Base = "weapon_ttt_cod4_base"

SWEP.Primary.Sound = "Weapon_CoD4_G36C.Single"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Damage = 14
SWEP.Primary.Delay = 0.07

SWEP.ReloadSpeed = 1.5

SWEP.HeadshotMultiplier = 19 / SWEP.Primary.Damage

SWEP.Sights = true

sound.Add {
	name = "Weapon_CoD4_G36C.Single",
	channel = CHAN_WEAPON,
	level = 80,
	sound = "cod4/weapons/g36c/weap_g36_slst_1.ogg"
}
sound.Add {
	name = "Weapon_CoD4_G36C.Chamber",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g36c/wpfoly_g36_reload_chamber_v1.ogg"
}
sound.Add {
	name = "Weapon_CoD4_G36C.ClipIn",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g36c/wpfoly_g36_reload_clipin_v1.ogg"
}
sound.Add {
	name = "Weapon_CoD4_G36C.ClipOut",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g36c/wpfoly_g36_reload_clipout_v1.ogg"
}
sound.Add {
	name = "Weapon_CoD4_G36C.Lift",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g36c/wpfoly_g36_reload_lift_v1.ogg"
}

local pow = 3
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-4, -3),
	pow * Angle(-4, -2),
	pow * Angle(-2, 1),
	pow * Angle(-1, -1),
	pow * Angle(-1, 2),
	pow * Angle(-3, 3),
	pow * Angle(-3, 2),
	pow * Angle(-2, 2),
	pow * Angle(-3, -1),
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

SWEP.AutoSpawnable = true

SWEP.Ortho = {5.5, -7}

SWEP.Primary.Ammo          = "smg1"
