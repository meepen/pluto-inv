SWEP.PrintName = "G3"

SWEP.ViewModel = "models/cod4/weapons/v_g3.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_g3.mdl"

SWEP.Slot = 2

SWEP.UseHands = false
SWEP.HoldType = "ar2"
SWEP.Base = "weapon_ttt_cod4_base"

SWEP.Primary.Sound = "Weapon_CoD4_G3.Single"
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo          = "357"
SWEP.Primary.Damage = 40
SWEP.Primary.Delay = 0.4
SWEP.Primary.RecoilTiming = 0.1

SWEP.HeadshotMultiplier = 1.5

SWEP.Sights = true

sound.Add {
	name = "Weapon_CoD4_G3.Single",
	channel = CHAN_WEAPON,
	level = 80,
	sound = "cod4/weapons/g3/weap_g3_slst_2.ogg"
}
sound.Add {
	name = "Weapon_CoD4_G3.Chamber",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g3/wpfoly_g3_reload_chamber_v1.ogg"
}
sound.Add {
	name = "Weapon_CoD4_G3.ClipIn",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g3/wpfoly_g3_reload_clipin_v1.ogg"
}
sound.Add {
	name = "Weapon_CoD4_G3.ClipOut",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g3/wpfoly_g3_reload_clipout_v2.ogg"
}
sound.Add {
	name = "Weapon_CoD4_G3.Lift",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/g3/wpfoly_g3_reload_lift_v1.ogg"
}

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-40),
}

SWEP.Ironsights = {
	TimeTo = 0.075,
	TimeFrom = 0.1,
	SlowDown = 0.5,
	Zoom = 0.8,
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 4300,
	DamageMinimumPercent = 0.15,
	Spread = Vector(0.01, 0.01),
}

SWEP.AutoSpawnable = true

SWEP.Ortho = {2, -3}
