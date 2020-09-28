AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

AccessorFunc(ENT,"m_bHeatSeek","HeatSeeking",FORCE_BOOL)
AccessorFunc(ENT,"m_flSpeed","Speed",FORCE_NUMBER)
ENT.Model = "models/fallout/projectiles/missile.mdl"
ENT.ParticleTrail = "rpg_firetrail"
ENT.ParticleTrailSmoke = "rocket_smoke_trail"
function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveCollide(COLLISION_GROUP_PROJECTILE)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(1)
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0)
	end
	
	self.cspSound = CreateSound(self,"weapons/missilelauncher/missile_nozzle_lp.wav")
	self.cspSound:Play()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	self:DeleteOnRemove(util.ParticleEffect(self.ParticleTrail,pos,ang,self,nil,false))
	self:DeleteOnRemove(util.ParticleEffect(self.ParticleTrailSmoke,pos,ang,self,nil,false))
	self.m_flSpeed = self.m_flSpeed || 1000
end

function ENT:SetEntityOwner(ent)
	self:SetOwner(ent)
	self.entOwner = ent
end

function ENT:PhysicsCollide(data, physobj)
	self:DoExplode(85,500,IsValid(self.entOwner) && self.entOwner)
	return true
end

function ENT:OnRemove()
	if self.cspSound then self.cspSound:Stop() end
end

function ENT:LookForTarget()
	local pos = self:GetPos()
	local dist = math.huge
	local entTgt
	for _, ent in ipairs(self:SLVFindInCone(35,8000,function(ent) return (ent:IsNPC() || (ent:IsPlayer() && (self.entOwner:IsPlayer() && gamemode.Call("CanPlayerDamagePlayer",ent,self.entOwner) || self.entOwner:IsNPC()))) && ent:Alive() && (!ent:IsNPC() || ent:slvDisposition(self.entOwner) == D_HT) && self:Visible(ent) end)) do
		local distEnt = ent:NearestPoint(pos):Distance(pos)
		if(distEnt < dist) then
			dist = distEnt
			entTgt = ent
		end
	end
	return entTgt || NULL
end

function ENT:Think()
	local phys = self:GetPhysicsObject()
	if(!phys:IsValid()) then return end
	local b
	if(IsValid(self.entOwner) && self:GetHeatSeeking()) then
		if(!IsValid(self.entTgt) || !self.entTgt:Alive()) then self.entTgt = self:LookForTarget() end
		if(self.entTgt:IsValid()) then
			local ang = (self.entTgt:GetCenter() -(self:GetPos() +self:OBBCenter())):Angle()
			self:TurnDegree(1,ang,true)
			self:NextThink(CurTime())
			b = true
		end
	end
	phys:SetVelocity(self:GetForward() *self:GetSpeed())
	return b
end

