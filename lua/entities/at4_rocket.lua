ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "AT4_Rocket"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/weapons/tfa_cso/w_at4_rocket.mdl"
ENT.MyModelScale = 1
ENT.Damage = 1000
ENT.Radius = 400
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or "models/weapons/tfa_cso/w_at4_rocket.mdl"
		
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
		
		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(1)
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:SetBuoyancyRatio(0)
		end
	ParticleEffectAttach("rocket_smoke_trail", PATTACH_ABSORIGIN_FOLLOW, self, 1)
	end

	function ENT:PhysicsCollide(data, physobj)
		local owent = self.Owner and self.Owner or self
		util.BlastDamage(self,owent,self:GetPos(),self.Radius,self.Damage)
		local fx = EffectData()
		fx:SetOrigin(self:GetPos())
		--fx:SetNormal(data.HitNormal)
		util.Effect("exp_grenade",fx)
		self:Remove()
	end
	
	function ENT:Think()
		for key,thing in pairs(ents.FindInSphere(self:GetPos(),500))do
            if((thing:IsNPC())and(self:Visible(thing)))then
                if(table.HasValue({"npc_strider","npc_combinegunship","npc_helicopter","npc_turret_floor","npc_turret_ground","npc_turret_ceiling"},thing:GetClass())) then
                    thing:SetHealth(1)
                    thing:Fire("selfdestruct","",.5)
					self:PhysicsCollide()
                end
            end
        end
	end
end

if CLIENT then
	
	function ENT:Draw()
		self:DrawModel()
	end

end