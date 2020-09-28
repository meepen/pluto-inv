AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

AccessorFunc(ENT,"dist","EmissionDistance",FORCE_NUMBER)
AccessorFunc(ENT,"RAD","RAD",FORCE_NUMBER)
function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:DrawShadow(false)
	self:SetNoDraw(true)
	self.dist = self.dist || 500
	self.RAD = self.RAD || 1
end

function ENT:SetEntityOwner(ent)
	self.m_entOwner = ent
	self:SetOwner(ent)
end

function ENT:GetEntityOwner() return self.m_entOwner end

function ENT:SetLife(duration)
	self.lifeStart = CurTime()
	self.lifeDuration = duration
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	if(key == "radius") then self:SetEmissionDistance(tonumber(value))
	elseif(key == "rad") then self:SetRAD(tonumber(value))
	elseif(key == "life") then
		local tm = tonumber(value)
		if(tm != -1) then self:SetLife(tm) end
	end
end

function ENT:Irradiate(ent,RAD)
	local owner = self:GetEntityOwner()
	local valid = IsValid(owner)
	if(valid) then
		if(ent == owner) then return end
		if(ent.GetNPCFaction && ent:GetNPCFaction() == NPC_FACTION_GHOUL) then
			local hp = ent:Health()
			local hpMax = ent:GetMaxHealth()
			hp = math.min(hp +RAD,hpMax)
			ent:slvSetHealth(hp)
			return
		end
	end
	local dmg = DamageInfo()
	dmg:SetDamageType(DMG_RADIATION)
	dmg:SetDamage(RAD)
	dmg:SetAttacker(self)
	dmg:SetInflictor(self)
	dmg:SetDamagePosition(ent:GetPos() +ent:OBBCenter())
	ent:TakeDamageInfo(dmg)
end

function ENT:Think()
	local RAD
	if !self.lifeDuration then RAD = self.RAD
	else
		local diff = CurTime() -self.lifeStart
		if diff > self.lifeDuration then self:Remove(); return end
		RAD = self.RAD -math.floor((self.RAD /self.lifeDuration) *diff)
	end
	local pos = self:GetPos()
	for _, ent in ipairs(ents.FindInSphere(pos,self.dist)) do
		if((ent:IsPlayer() || ent:IsNPC()) && ent:Alive()) then
			local dist = ent:NearestPoint(pos):Distance(pos)
			local RAD = math.ceil(RAD -((dist /self.dist) *RAD))
			//ent:Irradiate(RAD)
			self:Irradiate(ent,RAD)
		end
	end
	self:NextThink(CurTime() +1)
	return true
end

