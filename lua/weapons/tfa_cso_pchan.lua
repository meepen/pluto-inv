SWEP.Base				= "weapon_ttt_p90"
SWEP.Category				= "TFA CS:O" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author				= "Kamikaze" --Author Tooltip
SWEP.PrintName				= "Bunny P90"
SWEP.Slot				= 2

SWEP.Primary.Sound 			= Sound("P90.Fire")				-- This is the sound of the weapon, when you shoot.
SWEP.Primary.Damage		= 17					-- Damage, in standard damage points.
SWEP.Primary.Automatic			= true					-- Automatic/Semi Auto

SWEP.ViewModel			= "models/weapons/tfa_cso/c_p90lapin.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 80		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.

SWEP.WorldModel			= "models/weapons/tfa_cso/w_p90_lapin.mdl" -- Worldmodel path

SWEP.HoldType 				= "ar2"

SWEP.Offset = {
	Pos = {
        Up = 2,
        Right = 0,
        Forward = 0,
	},
	Ang = {
        Up = 0,
        Right = -10,
        Forward = 180
	},
	Scale = 1
}

SWEP.Ironsights = {
	Pos = Vector(5.4, 0, 0.5),
	Angle = Vector(0, 0, 0),
	TimeTo = 0.2,
	TimeFrom = 0.2,
	SlowDown = 0.4,
	Zoom = 0.8,
}

SWEP.MuzzleAttachment			= "0" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
--SWEP.MuzzleAttachmentRaw = 1 --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.ShellAttachment			= "2" 		-- Should be "2" for CSS models or "shell" for hl2 models

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 300,
	DamageDropoffRangeMax = 500,
	DamageMinimumPercent = 0.4,
	Spread = Vector(0.03, 0.04, 0),
}


local power = 8

SWEP.RecoilInstructions = {
	Interval = 2,
	Angle(-power * 0.6, -power * 0.5),
	Angle(-power * 0.48, -power * 0.8),
	Angle(-power * 0.2, -power * 0.3),
	Angle(-power * 0.4, power * 0.2),
	Angle(-power * 0.2, power * 0.1),
	Angle(-power * 0.6, power * 0.4),
	Angle(-power * 0.35, -power * 0.1),
	Angle(-power * 0.2, power * 0.3),
	Angle(-power * 0.2, power * 0.1),
	Angle(-power * 0.4, -power * 0.1),
}

SWEP.Spawnable = false
SWEP.AutoSpawnable = false
SWEP.PlutoSpawnable = false

SWEP.Ortho = {-2, 8}

DEFINE_BASECLASS(SWEP.Base)

SWEP.BaseJump = 160
SWEP.PerKill = 30

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetVar("Kills", "Int", 0)
end

function SWEP:UpdateJumpPower()
	local owner = self:GetOwner()

	if (not IsValid(owner)) then
		return
	end

	owner:SetJumpPower(self.BaseJump + self.PerKill * self:GetKills())
end

function SWEP:Kill(state, atk, vic)
	self:SetKills(self:GetKills() + 1)
	self:UpdateJumpPower()
end

function SWEP:Deploy()
	self:UpdateJumpPower()
	return BaseClass.Deploy(self)
end

function SWEP:Holster()
	self:GetOwner():SetJumpPower(self.BaseJump)
	return BaseClass.Holster(self)
end

function SWEP:PreDrop()
	self:GetOwner():SetJumpPower(self.BaseJump)
end
