SWEP.Base               = "weapon_tttbase"
SWEP.Author             = ""
SWEP.Contact                = ""
SWEP.Purpose                = ""
SWEP.Instructions               = ""
SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AdminSpawnable         = false
SWEP.DrawCrosshair          = true
SWEP.PrintName              = "Lancer"
SWEP.Slot               = 2
SWEP.SlotPos                = 73

SWEP.Ortho = {-4,5 , 1, size = 0.8, angle = Angle(-18, 39, -45)}

SWEP.Primary.Sound = Sound "Weapon_AUG.Single"   --needs fixed "Weapon_COG.Single"
SWEP.Primary.Automatic = true
SWEP.FireSoundAffectedByClipSize = true
SWEP.CanBeSilenced = false
SWEP.Silenced = false
SWEP.PlutoSpawnable = true

SWEP.ViewModel = "models/weapons/gow2/lancer/c_gow_assaultrifle.mdl"
SWEP.WorldModel = "models/weapons/gow2/lancer/w_gow_assaultrifle.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.HoldType = "ar2"


SWEP.Primary.Damage = 19
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30 * 3
SWEP.Primary.Ammo = "SMG1"
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Primary.Recoil = 1
SWEP.HeadshotMultiplier = 1.3
SWEP.Primary.Delay = 0.126

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 750,
	DamageDropoffRangeMax = 5200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.01, 0.02)
}

SWEP.Ironsights = {
	Pos = Vector(1, -4, 0), --scope and barrel dont line up actually aids
	Angle = Vector(0, 0, 0),
	TimeTo = 0.23,
	TimeFrom = 0.22,
	SlowDown = 0.3,
	Zoom = 0.9,
}

sound.Add {
    name = "Weapon_COG.Single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 135,
    sound = {
        "weapons/cog-lancer/cogriflefire-1.ogg",
        "weapons/cog-lancer/cogriflefire-2.ogg",
        "weapons/cog-lancer/cogriflefire-3.ogg",
    },
}