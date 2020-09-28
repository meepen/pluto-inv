AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_FALMER,CLASS_FALMER)
end

function ENT:GenerateArmor()
	self:SetBodygroup(1,math.random(6,7))
	self:SetBodygroup(2,1)
end