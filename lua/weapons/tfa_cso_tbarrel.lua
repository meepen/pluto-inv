
SWEP.Base				= "weapon_tttbase"
SWEP.Category				= "TFA CS:O" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author				= "Kamikaze" --Author Tooltip
SWEP.PrintName				= "Triple Barrel"
SWEP.Slot				= 1
SWEP.Spawnable = false

SWEP.Primary.Sound 			= Sound "Tbarrel.Fire"
SWEP.Primary.Delay				= 60 / 85					-- This is in Rounds Per Minute / RPM

SWEP.Primary.ClipSize			= 3				-- This is the size of a clip
SWEP.Primary.DefaultClip			= 12				-- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo          = "Buckshot"
SWEP.Primary.Damage = 5

SWEP.ViewModel			= "models/weapons/tfa_cso/c_tbarrel.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 80		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true
SWEP.WorldModel			= "models/weapons/tfa_cso/w_tbarrel.mdl"

SWEP.AllowDrop = false
SWEP.Speedup = 1.35
SWEP.HealthMult = 0.7

SWEP.HoldType = "shotgun"

SWEP.Offset = {
	Pos = {
        Up = -5,
        Right = 1.8,
        Forward = 9.5,
	},
	Ang = {
        Up = -90,
        Right = 0,
        Forward = 170
	},
	Scale = 1.2
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 12,
	DamageDropoffRange = 300,
	DamageDropoffRangeMax = 800,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.11, 0.08)
}

SWEP.ShowWorldModel = true

SWEP.IronSightsPos = Vector(6.71, 0, 2.13)
SWEP.IronSightsAng = Vector(2.108, 0, 0)

SWEP.MuzzleAttachment			= "0" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
--SWEP.MuzzleAttachmentRaw = 1 --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.ShellAttachment			= "2" 		-- Should be "2" for CSS models or "shell" for hl2 models

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	hook.Add("TTTUpdatePlayerSpeed", self, function(self, ply, data)
		if (not self:IsDormant() and ply == self:GetOwner()) then
			data[self] = self.Speedup
		end
	end)
end

function SWEP:OwnerChanged()
	BaseClass.OwnerChanged(self)

	if (not SERVER) then
		return
	end
	owner:SetMaxHealth(owner:GetMaxHealth() * self.HealthMult)
	owner:SetHealth(owner:Health() * self.HealthMult)
end

function SWEP:ShootBullet(...)
	local r = BaseClass.ShootBullet(self, ...)

	local p = self:GetOwner()
	local dir = p:EyeAngles()
	dir.r = 0
	dir = -dir:Forward()
	dir.z = dir.z * 0.7
	dir.y = dir.y * 0.1
	dir.x = dir.x * 0.1
	self:GetOwner():SetVelocity(dir * 300)

	return r
end

SWEP.Ortho = {-4, 1, angle=Angle(0, 180, -45)}

SWEP.Ironsights = false