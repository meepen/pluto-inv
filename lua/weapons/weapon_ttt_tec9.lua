AddCSLuaFile()

SWEP.Base = "weapon_tttbase"
SWEP.Category = "SMGs"
SWEP.Author = "Trash Burglar"

SWEP.PrintName = "Tec-9"
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 47
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_smg_tec10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_tec10.mdl"

SWEP.Offset = {
	Pos = {
		Up = 0,
		Right = 0,
		Forward = 0,
	},
	Ang = {
		Up = -1,
		Right = -2,
		Forward = 178
	},
	Scale = 1
}

sound.Add {
	name = "TEC9_MAGOUT",
	channel = CHAN_WEAPON,
	sound = "weapons/tec9/tec9magout.ogg"
}
sound.Add {
	name = "TEC9_MAGIN",
	channel = CHAN_WEAPON,
	sound = "weapons/tec9/tec9magin.ogg"
}
sound.Add {
	name = "TEC9_COCK",
	channel = CHAN_WEAPON,
	sound = "weapons/tec9/tec9cock.ogg"
}

SWEP.Sounds = {
	draw = {
		{time = 0.4, sound = "TEC9_COCK"},
	},
	reload = {
		{time = 0.27, sound = "TEC9_MAGOUT"},
		{time = 1, sound = "TEC9_MAGIN"},
		{time = 2.1, sound = "TEC9_COCK"},
	}
}

SWEP.Spawnable = true

sound.Add {
	name = "TEC9_SHOOT",
	channel = CHAN_WEAPON,
	volume = 0.3,
	sound = "weapons/tec9/tec9bangbang.ogg"
}

SWEP.Offset = {
	Pos = {
		Up = 3,
		Right = 1,
		Forward = -2.5,
	},
	Ang = {
		Up = 0,
		Right = -10,
		Forward = 180,
	}
}

SWEP.HeashotMultiplier = 1.5

SWEP.Primary.Damage = 16
SWEP.Primary.Sound = "TEC9_SHOOT"
SWEP.Primary.Delay = 60 / 500
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 64
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 2
SWEP.Primary.Ammo          = "smg1"
SWEP.AmmoEnt               = "item_ammo_smg1_ttt"

SWEP.Ironsights = {
	Pos = Vector(4.039, 6.278, 2.279),
	Angle = Vector(-0.04, 0.086, 0),
	TimeTo = 0.2,
	TimeFrom = 0.15,
	SlowDown = 0.3,
	Zoom = 0.9,
}

SWEP.Primary.Recoil = 1

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 300,
	DamageDropoffRangeMax = 1200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.02, 0.02)
}

function SWEP:FireAnimationEvent(_, _, event)
	if (event == 5001) then
		return true
	end
end