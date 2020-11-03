SWEP.PrintName = "M4 Carbine"

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/cod4/weapons/v_m4.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_m4.mdl"
SWEP.ViewModelFlip = false

SWEP.Slot = 2

SWEP.UseHands = false
SWEP.HoldType = "ar2"

SWEP.Base = "weapon_ttt_cod4_base"

SWEP.Primary.Sound = Sound( "Weapon_CoD4_M4.Single" )
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 60
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 15
SWEP.Primary.Delay = 0.09

SWEP.HeadshotMultiplier = 1.333

SWEP.Sights = true

SWEP.Primary.Ammo          = "Pistol"

sound.Add {
	name = "Weapon_CoD4_M4.Single",
	channel = CHAN_WEAPON,
	level = 80,
	sound = "cod4/weapons/m4/weap_m4_slst_1c4.ogg"
}
sound.Add {
	name = "Weapon_CoD4_M4.Chamber",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/m4/wpfoly_ak47_reload_chamber_v4.ogg"
}
sound.Add {
	name = "Weapon_CoD4_M4.ReloadChamber",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/m4/wpfoly_m4_reload_chamber.ogg"
}
sound.Add {
	name = "Weapon_CoD4_M4.ClipIn",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/m4/wpfoly_m4_reload_clipin.ogg"
}
sound.Add {
	name = "Weapon_CoD4_M4.ClipOut",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/m4/wpfoly_m4_reload_clipout.ogg"
}
sound.Add {
	name = "Weapon_CoD4_M4.Lift",
	channel = CHAN_ITEM,
	volume = 0.5,
	sound = "cod4/weapons/m4/wpfoly_m4_reload_lift.ogg"
}


local pow = 1.3
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-8, -2),
	pow * Angle(-7, -1),
	pow * Angle(-5, 3),
	pow * Angle(-4, 0),
	pow * Angle(-5, 0),
	pow * Angle(-5, 2),
	pow * Angle(-7, 1),
	pow * Angle(-6, 0),
	pow * Angle(-5, -3),
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 3500,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.02, 0.02),
}

SWEP.Ironsights = {
	TimeTo = 0.25,
	TimeFrom = 0.15,
	SlowDown = 0.6,
	Zoom = 0.8,
}

SWEP.AutoSpawnable = true

SWEP.Ortho = {3, -4}
