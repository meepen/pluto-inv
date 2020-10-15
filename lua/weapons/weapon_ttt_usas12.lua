SWEP.Base = "weapon_tttbase"

SWEP.PrintName = "USAS12"
SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Ortho = {-2, 7, size = 1.0, angle = Angle(10, -80, -6)}

SWEP.ViewModelPos = Vector(0, 0, -0.8)

function SWEP:FireAnimationEvent(_, _, event)
	if (event == 5001) then
		return true
	end
end

SWEP.ViewModelFlip = true
SWEP.ViewModel			= "models/weapons/tfa_cso2/c_usas12.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_cso2/w_usas12.mdl" -- Weapon world model path
SWEP.ViewModelFOV = 80

SWEP.HoldType = "ar2"

SWEP.Primary.Sound = Sound "Weapon_USAS.Single"
SWEP.Primary.Recoil = 1.2
SWEP.Primary.Damage = 5.3
SWEP.Primary.RecoilTiming  = 0.06
SWEP.Primary.Cone = 0.04
SWEP.Primary.Delay = 60 / 150
SWEP.Primary.ClipSize = 9
SWEP.Primary.DefaultClip = 18
SWEP.Primary.Automatic = true

SWEP.HeadshotMultiplier = 1.5

SWEP.Primary.Ammo = "Buckshot"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AdminSpawnable		= true

SWEP.Bullets = {
	HullSize = 0,
	Num = 5,
	DamageDropoffRange = 300,
	DamageDropoffRangeMax = 900,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.05, 0.05)
}

SWEP.Ironsights = {
	Pos = Vector(2.487, 0, 0.37),
	Angle = Vector(0.699, -0.051, 0),
	TimeTo = 0.23,
	TimeFrom = 0.23,
	SlowDown = 0.38,
	Zoom = 0.9,
}

sound.Add {
	name = "Weapon_USAS.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 135,
	sound = "weapons/usas12/ak47-1.ogg"
}

sound.Add {
	name = "Weapon_USAS.Boltpull",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 50,
	sound = "weapons/usas12/ak47_boltpull.ogg"
}

sound.Add {
	name = "Weapon_USAS.Clipout",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 50,
	sound = "weapons/usas12/ak47_clipout.ogg"
}

sound.Add {
	name = "Weapon_USAS.Clipin",
	channel = CHAN_ITEM,
	volume = 1.0,
	soundlevel = 50,
	sound = "weapons/usas12/ak47_clipin.ogg"
}
SWEP.Offset = {
	Pos = {
		Up = -0.1,
		Right = 0.5,
		Forward = 3
	},
	Ang = {
		Up = -1,
		Right = -10,
		Forward = 178
	},
	Scale = 0.8
}


SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-20),
}