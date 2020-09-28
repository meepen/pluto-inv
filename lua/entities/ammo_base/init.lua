
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.model = ""
ENT.bPhysics = false
ENT.AmmoType = "none"
ENT.AmmoPickup = 1
ENT.MaxAmmo = -1

function ENT:Initialize()
	self:SetModel(self.model)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	if !self.bPhysics then
		self:SetTrigger(true)
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionBounds(Vector(-20,-20,0), Vector(20,20,20))
		return
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)

	local phys = self.Entity:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(1)
	end
end

function ENT:Touch(ent)
	if !ent:IsPlayer() || !ent:Alive() then return end
	local iAmmoPickup = self.MaxAmmo != -1 && math.Clamp(self.AmmoPickup, 0, (self.MaxAmmo -ent:GetAmmunition(self.AmmoType))) || self.AmmoPickup
	if iAmmoPickup == 0 then return end
	ent:EmitSound("items/ammo_pickup.wav", 75, 100)
	local ammo = util.GetAmmoName(self.AmmoType)
	umsg.Start("HLR_HUDItemPickedUp", ent)
		umsg.String(ammo .. "," .. iAmmoPickup)
	umsg.End()
	ent:AddAmmunition(self.AmmoType, iAmmoPickup)
	self:Remove()
end

function ENT:Think()
end
