SWEP.Base				= "tfa_cso_tbarrel"
SWEP.Category				= "TFA CS:O" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author				= "Kamikaze" --Author Tooltip
SWEP.PrintName				= "Quad-Barreled Shotgun"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 1

SWEP.Primary.ClipSize = 4

SWEP.Primary.Sound 			= Sound("Tbarrel.Fire")				-- This is the sound of the weapon, when you shoot.
SWEP.Primary.Damage		= 1

SWEP.ViewModel			= "models/weapons/tfa_cso/c_qbarrel.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 80		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.
SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.
SWEP.VMAng = Vector(0,0,0) --The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.

--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_qbarrel.mdl" -- Weapon world model path

SWEP.Speedup = 1.2
SWEP.HealthMult = 0.9

DEFINE_BASECLASS(SWEP.Base)

function SWEP:ShootBullet(...)
	local r = BaseClass.ShootBullet(self, ...)

	local p = self:GetOwner()
	local dir = p:EyeAngles()
	dir.r = 0
	dir = -dir:Forward()
	dir.z = dir.z * 0.6
	dir.y = dir.y * 0.1
	dir.x = dir.x * 0.1
	self:GetOwner():SetVelocity(dir * 300)

	return r
end

function SWEP:FireBulletsCallback(tr, dmg, data)
	BaseClass.FireBulletsCallback(self, tr, dmg, data)

	local ent = tr.Entity

	if (IsValid(ent)) then
		if (ent:IsPlayer()) then
			ent:SetVelocity(ent:GetVelocity() + tr.Normal * 500)

		elseif (IsValid(ent:GetPhysicsObject())) then
			ent:GetPhysicsObject():AddVelocity(tr.Normal * 1000)
		end
	end
end