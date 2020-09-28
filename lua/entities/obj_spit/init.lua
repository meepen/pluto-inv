
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.HasHit = false

AccessorFunc(ENT,"m_dmg","Damage",FORCE_NUMBER)
AccessorFunc(ENT,"m_sndHit","HitSound",FORCE_STRING)
AccessorFunc(ENT,"m_particle","ParticleEffect",FORCE_STRING)
AccessorFunc(ENT,"m_force","Force")
AccessorFunc(ENT,"m_dmgType","DamageType",FORCE_NUMBER)
function ENT:Initialize()
	self:SetModel("models/fallout/goregrenade.mdl")
	self:DrawShadow(false)
	self:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then
		phys:Wake()
		phys:SetBuoyancyRatio(0)
	end
	self.m_dmg = self.m_dmg || 1
	self.m_force = self.m_force || vector_origin
	self.m_dmgType = self.m_dmgType || DMG_ACID
	self.delayRemove = CurTime() +8
	self.m_sndHit = self.m_sndHit || "fx/bullet/impact/flesh/fx_bullet_impact_flesh_04.wav"
	self.m_particle = self.m_particle || "centaur_spit"
	self:DeleteOnRemove(util.ParticleEffect(self:GetParticleEffect(),self:GetPos(),self:GetAngles(),self,nil,false))
end

function ENT:SetEntityOwner(ent)
	self:SetOwner(ent)
	self.entOwner = ent
end

function ENT:GetEntityOwner()
	return IsValid(self.entOwner) && self.entOwner || self
end

function ENT:OnRemove()
end

function ENT:Think()
	-- print(self.HasHit)
	if(CurTime() < self.delayRemove) then return end
	self:Remove()
end

function ENT:OnHit(ent,dist) self.HasHit = true; self:Remove() end

function ENT:PhysicsCollide(data, physobj)
	if self.HasHit then
		self:Remove()
		return
	end
	if !data.HitEntity || self.bHit then return true end
	if IsValid(self) && (!IsValid(data.HitEntity) || (!data.HitEntity:IsPlayer() && !data.HitEntity:IsNPC())) then self.HasHit = true; sound.Play(self:GetHitSound(),self:GetPos(),75,100); self:OnHit(data.HitEntity); return true end
	local owner = self:GetEntityOwner()
	data.HitEntity.attacker = owner
	data.HitEntity.inflictor = self
	if data.HitEntity:IsPlayer() || data.HitEntity:IsNPC() then
		local sClass = data.HitEntity:GetClass()
		if sClass != "npc_turret_floor" then
			local dmg = DamageInfo()
			dmg:SetDamage(self:GetDamage())
			dmg:SetAttacker(self:GetEntityOwner())
			dmg:SetInflictor(self)
			dmg:SetDamagePosition(data.HitPos)
			dmg:SetDamageType(self:GetDamageType())
			data.HitEntity:TakeDamageInfo(dmg)
		elseif !data.HitEntity.bSelfDestruct then
			data.HitEntity:GetPhysicsObject():ApplyForceCenter(self:GetVelocity():GetNormal() *10000)
			data.HitEntity:Fire("selfdestruct", "", 0)
			data.HitEntity.bSelfDestruct = true
		end
	end
	sound.Play(self:GetHitSound(),self:GetPos(),75,100)
	self:OnHit(data.HitEntity)
	self.HasHit = true
	return true
end