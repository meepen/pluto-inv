ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Black Dragon Cannon Grenade"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/weapons/tfa_cso/w_cannon_fireball.mdl"
ENT.MyModelScale = 0.5
ENT.Damage = 500
ENT.Radius = 300
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or "models/weapons/tfa_cso/w_cannon_fireball.mdl"
		
		self.Class = self:GetClass()
		
		self:SetModel(model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetHealth(1)
		self:SetModelScale(self.MyModelScale,0)
		local phys = self:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(1)
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:SetBuoyancyRatio(0)
		end
	end		

	function ENT:PhysicsCollide(data, physobj)
		local owent = self.Owner and self.Owner or self
		util.BlastDamage(self,owent,self:GetPos(),self.Radius,self.Damage)
		local fx = EffectData()
		fx:SetOrigin(self:GetPos())
		--fx:SetNormal(data.HitNormal)
		util.Effect("exp_cannon",fx)
		self:Remove()
	end
end

if CLIENT then
	
	function ENT:Draw()
		self:DrawModel()
	end

end