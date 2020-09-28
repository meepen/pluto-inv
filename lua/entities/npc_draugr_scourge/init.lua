AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_DRAUGR,CLASS_DRAUGR)
end
ENT.skName = "draugr_scourge"
ENT.m_shouts = bit.bor(SHOUT_UNRELENTING_FORCE,SHOUT_DISMAY,SHOUT_ICE_STORM)

function ENT:GenerateArmor()
	local gender = self:GetGender()
	if(gender == 0) then self:SetBodygroup(3,math.random(4,6))
	else self:SetBodygroup(3,math.random(2,3)) end
	local helmet = math.random(1,2)
	self:SetBodygroup(4,helmet)
end