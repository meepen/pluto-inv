SWEP.PrintName = "STG44"
SWEP.Category = "Call of Duty 4: Modern Warfare"

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/cod4/weapons/v_mp44.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_mp44.mdl"
SWEP.ViewModelFlip = false

SWEP.Slot = 2

SWEP.UseHands = false
SWEP.HoldType = "ar2"
SWEP.Base = "weapon_ttt_cod4_base"

SWEP.Primary.Sound = "Weapon_CoD4_MP44.Single"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.1
SWEP.Primary.Damage = 17
SWEP.HeadshotMultiplier = 24 / 15

SWEP.Sights = true

sound.Add {
	name = "Weapon_CoD4_MP44.Single",
	channel = CHAN_WEAPON,
	level = 80,
	sound = "cod4/weapons/mp44/weap_ak47_slst_3.ogg"
}
sound.Add {
	name = "Weapon_CoD4_MP44.Chamber",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/mp44/wpfoly_m44_reload_chamber_v1.ogg"
}
sound.Add {
	name = "Weapon_CoD4_MP44.ClipIn",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/mp44/wpfoly_m44_reload_clipin_v1.ogg"
}
sound.Add {
	name = "Weapon_CoD4_MP44.ClipOut",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/mp44/wpfoly_m44_reload_clipout_v1.ogg"
}
sound.Add {
	name = "Weapon_CoD4_MP44.Lift",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/mp44/wpfoly_m44_reload_lift_v1.ogg"
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 450,
	DamageDropoffRangeMax = 3500,
	DamageMinimumPercent = 0.15,
	Spread = Vector(0.01, 0.02)
}

local pow = 1.35
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

SWEP.AutoSpawnable = false

SWEP.Ortho = {2.5, -3.5}

SWEP.Primary.Ammo          = "smg1"
