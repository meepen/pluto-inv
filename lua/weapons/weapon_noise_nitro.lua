SWEP.Base = "weapon_tttbase"
SWEP.PrintName = "Noise Maker"
SWEP.Slot = 5

SWEP.ViewModelFlip      = false
SWEP.ViewModelFOV       = -100
SWEP.HoldType           = "normal"

SWEP.AllowDrop = false

sound.Add {
	name = "pluto_confetti",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 65,
	pitch = { 95, 110 },
	sound = {
		"weapons/confetti/noise4-01.ogg",
		"weapons/confetti/noise4-02.ogg",
		"weapons/confetti/noise4-03.ogg",
		"weapons/confetti/noise4-04.ogg",
		"weapons/confetti/noise4-05.ogg",
		"weapons/confetti/noise4-06.ogg",
		"weapons/confetti/noise4-07.ogg"
	}
}

SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "none"
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Delay         = 5
SWEP.Primary.Damage        = 0
SWEP.Primary.Recoil = 0

SWEP.Primary.Sound         = "pluto_confetti"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.AutoSpawnable         = false
SWEP.Spawnable             = true

SWEP.ViewModel             = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel            = "models/weapons/w_crowbar.mdl"

SWEP.PlutoIcon             = "vgui/entities/confetti.png"

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 1000,
	DamageDropoffRangeMax = 5500,
	DamageMinimumPercent = 0.3,
	Spread = Vector(0.01, 0.01),
	TracerName = "pluto_confetti",
	Distance = 0,
}
SWEP.Ironsights = false

function SWEP:DoFireBullets()
	if (CLIENT and not IsFirstTimePredicted()) then
		return
	end

	local data = EffectData()
	local owner = self:GetOwner()
	data:SetStart(owner:GetShootPos())
	data:SetOrigin(data:GetStart() + owner:GetAimVector())
	util.Effect("pluto_confetti", data)
end

function SWEP:Deploy()
	if SERVER and IsValid(self:GetOwner()) then
	self:GetOwner():DrawViewModel(false)
	end

	self:DrawShadow(false)

	return true
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end