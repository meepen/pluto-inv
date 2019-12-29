SWEP.Base = "weapon_tttbase"

SWEP.PrintName = "USAS12"
SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Ortho = {0, 0, angle = Angle(0, 20, -35)}

SWEP.ViewModelPos = Vector(0, 0, -0.8)

function SWEP:FireAnimationEvent(_, _, event)
	if (event == 5001) then
		return true
	end
end

SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_shot_u12.mdl"
SWEP.WorldModel = "models/weapons/w_shot_u12.mdl"
SWEP.ViewModelFOV = 57

SWEP.HoldType = "ar2"

SWEP.Primary.Sound = Sound "Weapon_USAS.Single"
SWEP.Primary.Recoil = 1.2
SWEP.Primary.Damage = 6.3
SWEP.Primary.RecoilTiming  = 0.06
SWEP.Primary.Cone = 0.04
SWEP.Primary.Delay = 60 / 150
SWEP.Primary.ClipSize = 9
SWEP.Primary.DefaultClip = 18
SWEP.Primary.Automatic = true

SWEP.HeadshotMultiplier = 1.5

SWEP.Primary.Ammo = "Buckshot"
SWEP.AmmoEnt = "item_box_buckshot_ttt"

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


function SWEP:DrawWorldModel()
	self:SetRenderAngles()
	if (not IsValid(self:GetOwner())) then
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)
		self:SetRenderAngles(ang)
	end
	self:DrawModel()
end