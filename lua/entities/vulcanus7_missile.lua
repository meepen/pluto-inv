ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Vulcanus7_missile"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/weapons/tfa_cso/w_missile_v7.mdl"
ENT.MyModelScale = 1
ENT.Damage = 400
ENT.Radius = 300
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or "models/weapons/tfa_cso/w_missile_v7.mdl"
		
		self.Class = self:GetClass()
		
		self:SetModel(model)
		
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetHealth(1)
		self:SetModelScale(self.MyModelScale,0)
        local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetMass(1)
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:SetBuoyancyRatio(0)
		end
		
		if (phys:IsValid()) then
			phys:Wake()
		end
	ParticleEffectAttach("rocket_smoke_trail", PATTACH_ABSORIGIN_FOLLOW, self, 1)
	end

	function ENT:PhysicsCollide(data, physobj)
		local owent = self.Owner and self.Owner or self
		util.BlastDamage(self,owent,self:GetPos(),self.Radius,self.Damage)
		local fx = EffectData()
		fx:SetOrigin(self:GetPos())
		fx:SetNormal(data.HitNormal)
		util.Effect("exp_grenade",fx)
		self:Remove()
	end
end

if CLIENT then
	
	function ENT:Draw()
		self:DrawModel()
	end

end
