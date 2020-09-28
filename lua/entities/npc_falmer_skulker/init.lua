AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_FALMER,CLASS_FALMER)
end

function ENT:GenerateArmor()
	self:SetBodygroup(1,math.random(2,4))
end