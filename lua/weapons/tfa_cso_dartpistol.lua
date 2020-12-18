SWEP.Base = "tfa_gun_base"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Kamikaze"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "Dart Pistol"
SWEP.Slot = 1

SWEP.Primary.Sound = Sound("Dartpistol.Fire")

SWEP.Primary.Delay = 60 / 70
SWEP.Primary.Damage = 33

SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Ammo = "pistol"

SWEP.ViewModel = "models/weapons/tfa_cso/c_dartpistol.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = true
SWEP.UseHands = true

SWEP.WorldModel = "models/weapons/tfa_cso/w_dartpistol.mdl"

SWEP.HoldType = "revolver"

SWEP.Offset = {
	Pos = {
        Up = -4.5,
        Right = 1,
        Forward = 7,
	},
	Ang = {
        Up = -90,
        Right = 0,
        Forward = 170
	},
	Scale = 1.2
}

SWEP.Ironsights = {
	Pos = Vector(7.403, -3.84, 0.791),
	Angle = Vector(-1.152, 5.633, -2.722),
	TimeTo = 0.23,
	TimeFrom = 0.22,
	SlowDown = 0.8,
	Zoom = 0.9,
}