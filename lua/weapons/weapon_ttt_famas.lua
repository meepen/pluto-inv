AddCSLuaFile()

SWEP.HoldType           = "ar2"

SWEP.PrintName          = "FAMAS"
SWEP.Slot               = 2

SWEP.Ortho = {9, 1}

SWEP.ViewModelFlip      = false
SWEP.ViewModelFOV       = 54

SWEP.IconLetter         = "w"

SWEP.Base                  = "weapon_tttbase"

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 3100,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.015, 0.015),
}

SWEP.Primary.Damage        = 14
SWEP.Primary.Delay         = 0.5
SWEP.Primary.RecoilTiming  = 0.36 / 6
SWEP.Primary.Recoil        = 2.65
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "Pistol"
SWEP.Primary.ClipSize      = 36
SWEP.Primary.DefaultClip   = 72
SWEP.Primary.Sound         = Sound "Weapon_FAMAS.Single"

SWEP.BurstAmount = 3

SWEP.HeadshotMultiplier    = 29 / 14
SWEP.DeploySpeed = 1.3

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true

SWEP.ViewModel             = "models/weapons/cstrike/c_rif_famas.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_famas.mdl"

SWEP.Ironsights = {
	Pos = Vector(-6.5, 0, 1.25),
	Angle = Vector(0.5, -1, 0),
	TimeTo = 0.25,
	TimeFrom = 0.15,
	SlowDown = 0.4,
	Zoom = 0.8,
}

local pow = 5
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-5, -0.2),
	pow * Angle(-3, -0.1),
	pow * Angle(-5, 0.2),
}

DEFINE_BASECLASS(SWEP.Base)

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetVar("CurrentBurstShot", "Int", 0)
end

function SWEP:StartShoot()
	BaseClass.StartShoot(self)
	self:SetCurrentBurstShot(1)
end

function SWEP:Reload()
	if (self:GetCurrentBurstShot() ~= 0) then
		return
	end
	
	return BaseClass.Reload(self)
end

function SWEP:Deploy()
	self:SetCurrentBurstShot(0)

	return BaseClass.Deploy(self)
end

function SWEP:Think()
	local diff = CurTime() - self:GetRealLastShootTime()
	local interval = self:GetDelay() / 3

	if (diff < interval and self:GetCurrentBurstShot() ~= 0) then
		local nextinterval = interval / self.BurstAmount * self:GetCurrentBurstShot()

		if (diff >= nextinterval) then
			local this_shot = (self:GetCurrentBurstShot() + 1) % self.BurstAmount
			self:SetCurrentBurstShot(this_shot)
			self:DefaultShoot()
		end
	end

	return BaseClass.Think(self)
end
