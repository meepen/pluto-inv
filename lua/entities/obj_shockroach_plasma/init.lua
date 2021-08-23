
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetMoveCollide(3)
	self:SetModel("models/props_junk/watermelon01_chunk02c.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	self:slvSetHealth(1)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(1)
		phys:SetBuoyancyRatio(0)
		phys:EnableGravity(false)
		phys:EnableDrag(false)
	end
	
	local entLight = ents.Create("light_dynamic")
	entLight:SetKeyValue("_light", "2 110 182 100")
	entLight:SetKeyValue("brightness", "6")
	entLight:SetKeyValue("distance", "60")
	entLight:SetKeyValue("_cone", "0")
	entLight:SetPos(self:GetPos())
	entLight:SetParent(self)
	entLight:Spawn()
	entLight:Activate()
	entLight:Fire("TurnOn", "", 0)
	self.entLight = entLight
	self:DeleteOnRemove(self.entLight)
	
	ParticleEffectAttach("shockroach_projectile_trail", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	self.delayRemove = CurTime() +8
end

function ENT:SetHitEntity(ent)
	self:SetNetworkedEntity("hitent", ent)
end

function ENT:GetHitEntity()
	return self:GetNetworkedEntity("hitent")
end

function ENT:OnRemove()
end

function ENT:SetEntityOwner(ent)
	self:SetOwner(ent)
	self.entOwner = ent
end

function ENT:GetEntityOwner()
	return IsValid(self.entOwner) && self.entOwner || self
end

function ENT:Think()
	if CurTime() >= self.delayRemove then self:Remove(); return end
	if !self.bHit then
		if self:WaterLevel() == 3 then
			for k, v in ipairs(ents.FindInSphere(self:GetPos(), 200)) do
				if IsValid(v) && (v:IsNPC() || v:IsPlayer()) && v:Health() > 0 then
					local sClass = v:GetClass()
					if sClass != "monster_shocktrooper" && sClass != "monster_shockroach" then
						local dmg = DamageInfo()
						dmg:SetDamage(5)
						dmg:SetAttacker(self:GetEntityOwner())
						dmg:SetInflictor(self)
						dmg:SetDamageType(DMG_GENERIC)
						dmg:SetDamagePosition(v:NearestPoint(self:GetCenter()))
						v:TakeDamageInfo(dmg)
					end
				end
			end
		end
		return
	end
	local entLight = self.entLight
	if !IsValid(entLight) then self:Remove(); return end
	local entHit = self:GetHitEntity()
	if CurTime() >= self.delayRemove || (!self.bHitWorld && (!IsValid(entHit) || ((entHit:IsNPC() || entHit:IsPlayer()) && entHit:Health() <= 0))) then self:Remove(); return end
	if self.flLight == 0 then return end
	self.flLight = math.Clamp(self.flLight -0.8,0,6)
	if self.flLight == 0 then entLight:Remove(); return end
	entLight:Fire("brightness", self.flLight, 0)
	self:NextThink(CurTime())
	return true
end

function ENT:Hit(ent)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
	self.flLight = 6
	self.bHit = true
	if (!ent:IsPhysicsEntity() && !ent:IsNPC() && !ent:IsPlayer()) then
		self.bHitWorld = true
	end
	self.delayRemove = CurTime() +0.5
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self:DrawShadow(false)
	self:SetHitEntity(ent)
end

function ENT:PhysicsCollide(data, physobj)
	if !data.HitEntity || self.bHit then return true end
	if IsValid(self) && (!IsValid(data.HitEntity) || (!data.HitEntity:IsPlayer() && !data.HitEntity:IsNPC())) then self:EmitSound("weapons/shock_roach/shock_impact.wav", 75, 100); self:Hit(data.HitEntity); return true end
	local owner = self:GetEntityOwner()
	data.HitEntity.attacker = owner
	data.HitEntity.inflictor = self
	if data.HitEntity:IsPlayer() || data.HitEntity:IsNPC() then
		local sClass = data.HitEntity:GetClass()
		if sClass != "npc_turret_floor" then
			if sClass != "monster_shocktrooper" && sClass != "monster_shockroach" then
				local iDmg
				if owner:IsPlayer() then iDmg = GetConVarNumber("sk_plr_dmg_shockroach")
				else iDmg = GetConVarNumber("sk_npc_dmg_shockroach") end
				local dmg = DamageInfo()
				dmg:SetDamage(iDmg)
				dmg:SetAttacker(self:GetEntityOwner())
				dmg:SetInflictor(self)
				dmg:SetDamagePosition(data.HitPos)
				dmg:SetDamageType(DMG_GENERIC)
				data.HitEntity:TakeDamageInfo(dmg)
			end
		elseif !data.HitEntity.bSelfDestruct then
			data.HitEntity:GetPhysicsObject():ApplyForceCenter(self:GetVelocity():GetNormal() *10000)
			data.HitEntity:Fire("selfdestruct", "", 0)
			data.HitEntity.bSelfDestruct = true
		end
	end
	self:EmitSound("weapons/shock_roach/shock_impact.wav", 75, 100)
	self:Hit(data.HitEntity)
	return true
end
