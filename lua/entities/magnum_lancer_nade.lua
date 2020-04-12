ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "lancer"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/hunter/blocks/cube025x025x025.mdl"
ENT.MyModelScale = 1
ENT.Damage = 1000
ENT.Radius = 100
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()
local owent = self.Owner and self.Owner or self
		local model = self.MyModel 
		
		self.Class = self:GetClass()
		
		self:SetModel(model)
		self.Entity:PhysicsInitSphere( 4, "metal_bouncy" ) 
		self.Entity:SetCollisionBounds( Vector()*-4, Vector()*4 )

		 
		local phys = self:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
			      phys:SetDamping( .0001, .0001 )
				phys:EnableGravity( false )
		--  phys:SetVelocity( owent:GetAimVector() * 2000 )
		end
  self:StartMotionController()
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