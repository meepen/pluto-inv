SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Anri"
SWEP.PrintName				= "Crystalized Acid"
SWEP.Slot				= 2

--[[WEAPON HANDLING]]--

--Firing related
SWEP.Primary.Sound 			= Sound("SF Ethereal.Fire")
SWEP.Primary.Damage		= 12
SWEP.HeadshotMultiplier = 1.4
SWEP.Primary.Automatic			= true
SWEP.Primary.Delay				= 60 / 650

SWEP.Primary.ClipSize			= 60
SWEP.Primary.DefaultClip			= 120
SWEP.Primary.Ammo			= "ar2"

SWEP.Secondary.Delay = 1
SWEP.Secondary.Automatic = true

SWEP.ViewModel			= "models/weapons/tfa_cso/c_ethereal.mdl"
SWEP.ViewModelFlip = true
SWEP.WorldModel			= "models/weapons/tfa_cso/w_ethereal.mdl"

SWEP.HoldType 				= "ar2"

SWEP.Offset = {
	Pos = {
		Up = -4.5,
		Right = 0.7,
		Forward = 8,
	},
	Ang = {
		Up = -90,
		Right = -0,
		Forward = 170
	},
	Scale = 1
}

SWEP.MuzzleAttachment			= "0"
SWEP.ShellAttachment			= "2"

SWEP.MuzzleFlashEffect = "tfa_muzzleflash_sniper_energy"

SWEP.TracerName 		= "tfa_tracer_gauss"

local pow = 1.35
SWEP.RecoilInstructions = {
	Interval = 1,
	angle_zero,
}

SWEP.Ironsights = false

DEFINE_BASECLASS(SWEP.Base)

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetVar("PickupEntity", "Entity")
	self:NetVar("RealEntity", "Entity")
	self:NetVar("PickupDistance", "Float")
end

function SWEP:Initialize()
	BaseClass.Initialize(self)

	if (CLIENT) then
		hook.Add("PreDrawEffects", self, self.DrawLink)
	end
end
local matBeam2 = Material("trails/physbeam")
function SWEP:DrawLink()
	if (self:IsDormant() or not IsValid(self:GetOwner()) or not IsValid(self:GetRealEntity())) then
		return
	end

	local e1 = self:GetOwner()

	local e2 = self:GetRealEntity()

	if (e1 == ttt.GetHUDTarget()) then
		halo.Add({e2}, e1:GetRoleData().Color)
	else
		render.SetMaterial(matBeam2)
		render.DrawBeam(e1:GetShootPos(), e2:GetPos(), 4, 1, 0, color_white)
	end
end

local function PlayerStandsOn(ent)
	for _, ply in ipairs(player.GetAll()) do
		if ply:GetGroundEntity() == ent and ply:Alive() then
			return true
		end
	end

	return false
end

function SWEP:AllowPickup(target)
	local phys = target:GetPhysicsObject()
	local ply = self:GetOwner()

	return IsValid(phys) and IsValid(ply) and not target:IsPlayer() and
			  not phys:HasGameFlag(FVPHYSICS_NO_PLAYER_PICKUP) and
			  phys:GetMass() < 500 and
			  not PlayerStandsOn(target) and
			  target.CanPickup ~= false
end

function SWEP:SecondaryAttack()
	if (self:GetNextSecondaryFire() > CurTime() or not SERVER) then
		return
	end

	if (IsValid(self:GetPickupEntity())) then
		self:ResetEntity()
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
		return
	end

	self:ResetEntity()

	local owner = self:GetOwner()
	local tr = util.TraceLine {
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * 8096,
		mask = MASK_BULLET,
		filter = owner
	}

	if (not IsValid(tr.Entity) and not tr.Entity:IsPlayer()) then
		return
	end

	local phys = tr.Entity:GetPhysicsObject()
	if (not IsValid(phys) or not phys:IsMoveable() or phys:HasGameFlag(FVPHYSICS_PLAYER_HELD)) then
		return
	end

	if (not self:AllowPickup(tr.Entity)) then
		return
	end

	self.SecondEntity = ents.Create "prop_physics"
	self.SecondEntity:SetModel "models/weapons/w_bugbait.mdl"
	self.SecondEntity:SetColor(Color(50, 250, 50, 240))
	self.SecondEntity:SetNoDraw(true)
	self.SecondEntity:DrawShadow(false)

	self.SecondEntity:SetHealth(999)
	self.SecondEntity:SetOwner(ply)
	self.SecondEntity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.SecondEntity:SetSolid(SOLID_NONE)
	self.SecondEntity:SetPos(owner:GetShootPos())
	self.SecondEntity:SetAngles(owner:EyeAngles())
	self.SecondEntity:Spawn()
	local phys = self.SecondEntity:GetPhysicsObject()
	if (IsValid(phys)) then
		phys:EnableMotion(false)
	end

	self:SetRealEntity(tr.Entity)

	local e = constraint.Weld(self.SecondEntity, tr.Entity, 0, tr.PhysicsBone, 20000, true, true)

	e:CallOnRemove(self:GetClass(), function()
		if (IsValid(self) and self:GetRealEntity() == tr.Entity) then
			self:SetRealEntity()
		end
	end)

	self:SetPickupEntity(e or nil)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:Think()
	BaseClass.Think(self)

	local e = self.SecondEntity
	local e1 = self:GetRealEntity()

	if (IsValid(self:GetPickupEntity()) and IsValid(e1)) then
		e1:SetPhysicsAttacker(self:GetOwner(), 5)
	end

	if (IsValid(e)) then
		e:SetAngles(self:GetOwner():EyeAngles())
		e:SetPos(self:GetOwner():GetShootPos())
	end
end

function SWEP:Holster()
	self:ResetEntity()
	return BaseClass.Holster(self)
end

function SWEP:PreDrop()
	self:ResetEntity()
end

function SWEP:ResetEntity()
	local ent = self:GetPickupEntity()
	if (IsValid(ent)) then
		ent:Remove()
	end

	local e = self:GetRealEntity()
	if (IsValid(e)) then
		e:PhysWake()
	end

	self:SetRealEntity()

	if (IsValid(self.SecondEntity)) then
		self.SecondEntity:Remove()
	end
end

function SWEP:OnRemove()
	self:ResetEntity()
	return BaseClass.OnRemove(self)
end

function SWEP:Deploy()
	self:ResetEntity()

	return BaseClass.Deploy(self)
end