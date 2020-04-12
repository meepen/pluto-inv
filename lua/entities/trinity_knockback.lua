ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Trinity - Knockback"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/weapons/tfa_cso/w_trinity_knockback.mdl"
ENT.MyModelScale = 1
ENT.Damage = 25
ENT.Radius = 500

ENT.IsArmed = false

if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or "models/weapons/tfa_cso/w_trinity_knockback.mdl"
		
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
		end
	end
	
	function ENT:Think()
		--print("Inital Think")
		if !self.IsArmed then return end
		--print("Armed Think")
		for k,v in pairs(ents.FindInSphere(self.Entity:GetPos(),350)) do
			if GetConVar( "sv_tfa_cso_dmg_trinity_detect_player" ):GetInt() == 0 then
				if v:IsNPC() or v:IsNextBot() then
					if v:Health() > 0 then
						self:Explode()
					end
				end
			else
				if v != self.Owner and (v:IsNPC() or v:IsPlayer() or v:IsNextBot()) then
					if v:Health() > 0 then
						self:Explode()
					end
				end	
			end
		end
	end


	function ENT:PhysicsCollide(data, physobj)
		physobj:EnableMotion(false)
		--print("Motion disabled!")
		if self.IsArmed then return end
		--print("Playing impact sound.")
		self:EmitSound(Sound("Trinity.TransformWhite"))
		--print("Arming!")
		self.IsArmed = true
	end
	
	function ENT:Explode()
		local owent = self.Owner and self.Owner or self
		util.BlastDamage(self,owent,self:GetPos(),self.Radius,self.Damage)
		local fx = EffectData()
		fx:SetOrigin(self:GetPos())
		--fx:SetNormal(data.HitNormal)
		util.Effect("exp_trinity_knockback",fx)
		self:EmitSound(Sound("Trinity.ExplodeWhite"))
		
		local phys_force = 2048
		local push_force = 1250
		for k, target in pairs( ents.FindInSphere( self.Entity:GetPos(), self.Radius ) ) do
			if GetConVar( "sv_tfa_cso_dmg_trinity_detect_player" ):GetInt() == 0 then
				if IsValid( target ) then
					local tpos = target:LocalToWorld( target:OBBCenter() )
					local dir = ( tpos - self.Entity:GetPos() ):GetNormal()
					local phys = target:GetPhysicsObject()

					if target:IsNPC() or target:IsNextBot() then

						dir.z = math.abs( dir.z ) + 1

						local push = dir * push_force

						local vel = target:GetVelocity() + push
						vel.z = math.min( vel.z, push_force / 3 )

						target:SetVelocity( vel )

						target.was_pushed = { att=self.Entity, t=CurTime(), wep="weapon_fraggrenade" }

					elseif IsValid( phys ) then
						phys:ApplyForceCenter( dir * -1 * phys_force )
					end
				end
			else
				if IsValid( target ) then
					local tpos = target:LocalToWorld( target:OBBCenter() )
					local dir = ( tpos - self.Entity:GetPos() ):GetNormal()
					local phys = target:GetPhysicsObject()

					if target != self.Owner and ( target:IsPlayer() && !target:IsFrozen() && ( !target.was_pushed || target.was_pushed.t != CurTime() ) or target:IsNPC() ) then

						dir.z = math.abs( dir.z ) + 1

						local push = dir * push_force

						local vel = target:GetVelocity() + push
						vel.z = math.min( vel.z, push_force / 3 )

						target:SetVelocity( vel )

						target.was_pushed = { att=self.Entity, t=CurTime(), wep="weapon_fraggrenade" }

					elseif IsValid( phys ) then
						phys:ApplyForceCenter( dir * -1 * phys_force )
					end
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