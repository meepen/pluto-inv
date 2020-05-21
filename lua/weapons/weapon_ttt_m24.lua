AddCSLuaFile()

SWEP.HoldType              = "ar2"

SWEP.PrintName          = "M24-S"
SWEP.Slot               = 2

SWEP.ViewModelFlip      = true
SWEP.ViewModelFOV       = 64

SWEP.Ortho = {-10, 12}

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_HEAVY
SWEP.WeaponID              = AMMO_RIFLE
SWEP.ViewModelFOV          = 85
SWEP.UseHands = true
SWEP.NoPlayerModelHands = false

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 5300,
	DamageDropoffRangeMax = 9600,
	DamageMinimumPercent = 0.1,
	Spread = vector_origin
}

SWEP.Primary.Damage        = 33
SWEP.Primary.Delay         = 1.3
SWEP.Primary.Recoil        = 6
SWEP.Primary.RecoilTiming  = 0.09
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "357"
SWEP.Primary.ClipSize      = 5
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.Sound         = "Weapon_M4A1.Silenced"

SWEP.Secondary.Sound       = Sound "Default.Zoom"

SWEP.IsSilent = true
SWEP.HeadshotMultiplier    = 5
SWEP.DeploySpeed = 1.3
SWEP.ReloadSpeed = 1.66

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.ViewModel             = "models/weapons/v_snip_agu.mdl"
SWEP.WorldModel            = "models/weapons/w_snip_agu.mdl"
SWEP.HasScope              = true
SWEP.IsSniper              = false

SWEP.Offset = {
	Pos = {
		Up = 2,
		Right = 1,
		Forward = 0,
	},
	Ang = {
		Up = 0,
		Right = -10,
		Forward = 180,
	}
}

sound.Add {
	name = "Weapon_cod4m21.Boltpull",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 135,
	sound = "weapons/cod4m21/sg550_boltpull.ogg"
}

sound.Add {
	name = "Weapon_cod4m21_clipin",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 50,
	sound = "weapons/cod4m21/sg550_clipin.ogg"
}

sound.Add {
	name = "Weapon_cod4m21.clipout",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 50,
	sound = "weapons/cod4m21/sg550_clipout.ogg"
}

sound.Add {
	name = "Weapon_cod4m21.trigger",
	channel = CHAN_ITEM,
	volume = 1,
	soundlevel = 50,
	sound = "weapons/cod4m21/trigger.ogg"
}

SWEP.Sounds = {
	reload = {
		{time = 0.58, sound = "Weapon_cod4m21.clipout"},
		{time = 1.48, sound = "Weapon_cod4m21_clipin"},
		{time = 2.6, sound = "Weapon_cod4m21.Boltpull"},
	},
}

SWEP.Ironsights = {
	Pos = Vector(5, -15, -2),
	Angle = Vector(2.6, 1.37, 3.5),
	TimeTo = 0.075,
	TimeFrom = 0.1,
	SlowDown = 0.3,
	Zoom = 0.2,
}

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-70),
}