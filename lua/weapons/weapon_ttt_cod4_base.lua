SWEP.Base = "weapon_tttbase"
DEFINE_BASECLASS(SWEP.Base)

SWEP.PrintName = "Call of Duty 4 Base"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AdminOnly = false
	
SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/cod4/weapons/v_ak47_acog.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_ak47.mdl"
SWEP.ViewModelFlip = false

SWEP.Slot = 2

SWEP.UseHands = false
SWEP.HoldType = "ar2"

SWEP.Primary.Sound = "Weapon_CoD4_AK47.Single"
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Damage = 40
SWEP.Primary.Delay = 0.085

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 4200,
	DamageMinimumPercent = 0.1,
	Spread = vector_origin,
}

SWEP.Ironsights = {
	TimeTo = 0.1,
	TimeFrom = 0.15,
	SlowDown = 0.4,
	Zoom = 0.6,
}

function SWEP:DoZoom(zoomed)
	BaseClass.DoZoom(self, zoomed)

	if (zoomed) then
		self:SendWeaponAnim(ACT_VM_DEPLOY)
	else
		self:SendWeaponAnim(ACT_VM_UNDEPLOY)
	end
end

function SWEP:GetPrimaryAttackAnimation()
	return self:GetIronsights() and ACT_VM_PRIMARYATTACK_DEPLOYED or ACT_VM_PRIMARYATTACK
end

function SWEP:GetAngleDown()
	if (self.Sights or self:GetClass():match "acog" or self:GetClass():match "reflex") then
		return angle_zero
	end

	return Angle(1, 0, 0)
end

function SWEP:GetIronsightsPos(is_ironsights, frac, pos, ang)
	return pos, ang + LerpAngle(is_ironsights and frac or 1 - frac, angle_zero, self:GetAngleDown())
end