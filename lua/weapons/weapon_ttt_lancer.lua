SWEP.Base               = "weapon_tttbase"
SWEP.Author             = ""
SWEP.Contact                = ""
SWEP.Purpose                = ""
SWEP.Instructions               = ""
SWEP.AutoSpawnable         = false
SWEP.Spawnable             = false
SWEP.AdminSpawnable         = false
SWEP.DrawCrosshair          = true
SWEP.PrintName              = "Lancer"
SWEP.Slot               = 2
SWEP.SlotPos                = 73

SWEP.Ortho = {-7, 9}

SWEP.Primary.Sound = Sound "Weapon_AUG.Single"  --needs fixed "sound/weapons/cog-lancer/cogriflefire-1.ogg"
SWEP.Primary.Damage = 19
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.129

SWEP.HeadshotMultiplier = 1.6

SWEP.CanBeSilenced = false
SWEP.Silenced = false

SWEP.FireSoundAffectedByClipSize = true

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30 * 2
SWEP.Primary.Ammo = "pistol"
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.Primary.Recoil = 1

SWEP.ViewModel = "models/weapons/gow2/lancer/c_gow_assaultrifle.mdl"
SWEP.WorldModel = "models/weapons/gow2/lancer/w_gow_assaultrifle.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.NoPlayerModelHands = false

SWEP.HoldType = "ar2"

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 750,
	DamageDropoffRangeMax = 5200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.02, 0.02)
}

SWEP.Ironsights = {
	Pos = Vector(0, 0, 0),
	Angle = Vector(0, 0, 0), --fix this
	TimeTo = 0.23,
	TimeFrom = 0.22,
	SlowDown = 0.3,
	Zoom = 0.9,
}

sound.Add {
	name = "Weapon_lancer.cogriflefire-1",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 135,
	sound = "sound/weapons/cog-lancer/cogriflefire-1.ogg"
}
