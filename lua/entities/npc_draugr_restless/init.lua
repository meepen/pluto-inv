AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_DRAUGR,CLASS_DRAUGR)
end
ENT.skName = "draugr_restless"
ENT.m_shouts = SHOUT_UNRELENTING_FORCE

function ENT:GenerateArmor()
	local gender = self:GetGender()
	if(gender == 0) then self:SetBodygroup(3,math.random(2,4))
	else self:SetBodygroup(3,math.random(1,2)) end
	local helmet = math.random(0,1)
	self:SetBodygroup(4,helmet)
end