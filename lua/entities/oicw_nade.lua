ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "OICW Grenade"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/weapons/tfa_cso/w_shell_svdex.mdl"
ENT.MyModelScale = 0.35
ENT.Damage = 200
ENT.Radius = 192
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or "models/weapons/tfa_cso/w_shell_svdex.mdl"
		
		self.Class = self:GetClass()
		
		self:SetModel(model)
		util.SpriteTrail(self, 0, Color(255,255,255), false, 7, 1, 0.5, 0.125, "trails/smoke.vmt")
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
		end
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