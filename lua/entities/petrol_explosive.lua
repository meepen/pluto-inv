ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Petro Boomer Canister"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/weapons/tfa_cso/w_petrol.mdl"
ENT.MyModelScale = 1
ENT.Damage = 75
ENT.Radius = 256
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or "models/weapons/tfa_cso/w_petrol.mdl"
		
		self.Class = self:GetClass()
		
		self:SetModel(model)
		
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(true)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetHealth(1)
		self:SetModelScale(self.MyModelScale,0)
		util.SpriteTrail(self, 0, Color(255,255,255), false, 7, 1, 0.5, 0.125, "trails/smoke.vmt")
		
		local phys = self:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		local owent = self.Owner and self.Owner or self
		util.BlastDamage(self,owent,self:GetPos(),self.Radius,self.Damage)
		local fx = EffectData()
		fx:SetOrigin(self:GetPos())
		fx:SetNormal(data.HitNormal)
		util.Effect("exp_janus1",fx)
		self.Entity:EmitSound("PetrolBoomer.Exp", self.Pos, 100, 100 )
		for k,v in pairs(ents.FindInSphere(self.Entity:GetPos(),350)) do
			if GetConVar( "sv_tfa_cso_dmg_trinity_detect_player" ):GetInt() == 0 then
				if v:IsNPC() or v:IsNextBot() or v:GetClass() == "prop_physics" then
					v:Ignite(15)
					--print(v)
				end
			else
				if v:IsNPC() or v:IsNextBot() or v:IsPlayer() or v:GetClass() == "prop_physics" then
					v:Ignite(15)
					--print("ply")
				end
			end
		end
		self:Remove()
	end
end

if CLIENT then
	
	function ENT:Draw()
		self:DrawModel()
	end

end