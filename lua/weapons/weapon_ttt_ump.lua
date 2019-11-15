AddCSLuaFile()

SWEP.PrintName				= "UMP9"
SWEP.Slot				= 2
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawWeaponInfoBox			= true
SWEP.BounceWeaponIcon   		= true

SWEP.Category = "Razor's SWEPS"
SWEP.Author = "Razor"
SWEP.Contact = "Razor"
SWEP.Purpose = "Personal Defence Weapon"
SWEP.Instructions = ""
SWEP.DrawCrosshair = true

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_rif_ump9.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ump9.mdl"
SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = false

SWEP.Primary.Sound = "CW_UMP9_FIRE"
SWEP.Primary.Delay = 60 / 500

SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 74
SWEP.Primary.Automatic = true 
SWEP.Primary.Damage = 20
SWEP.Primary.Ammo = "pistol"
SWEP.AmmoEnt = "item_ammo_pistol_ttt"

SWEP.HeadshotMultiplier = 1.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false 
SWEP.Secondary.Ammo = ""

SWEP.PreventLowered = true

SWEP.Ironsights = {
	Pos = Vector(-2.86, -6.433, -0.361),
	Angle = Vector(-0.731, -2.401, 0),
	TimeTo = 0.2,
	TimeFrom = 0.15,
	SlowDown = 0.3,
	Zoom = 0.75,
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 250,
	DamageDropoffRangeMax = 2200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.01, 0.01),
	Tracer = 0,
}

SWEP.Primary.Recoil = 1.5
SWEP.HoldType = "ar2"
SWEP.ReloadSpeed = 0.9

SWEP.Offset = {
	Pos = {
		Up = 2,
		Right = 1,
		Forward = 1.5,
	},
	Ang = {
		Up = 0,
		Right = -10,
		Forward = 180,
	}
}

SWEP.Sounds = {
	draw = {
		{time = 0, sound = "weapons/ump9/draw.ogg"}
	},
	reload = {
		{time = 0, sound = "UMP9_RELEASE"},
		{time = 0.58, sound = "CW_UMP9_MAGOUT"},
		{time = 1.48, sound = "CW_UMP9_MAGIN"},
	}
}

sound.Add {
	name = "CW_UMP9_FIRE",
	channel = CHAN_WEAPON,
	sound = "weapons/ump9/fire.ogg"
}
sound.Add {
	name = "UMP9_RELEASE",
	channel = CHAN_WEAPON,
	sound = "weapons/ump9/cliprelease.ogg"
}
sound.Add {
	name = "CW_UMP9_MAGOUT",
	channel = CHAN_WEAPON,
	sound = "weapons/ump9/clipout.ogg"
}
sound.Add {
	name = "CW_UMP9_MAGIN",
	channel = CHAN_WEAPON,
	sound = "weapons/ump9/clipin.ogg"
}