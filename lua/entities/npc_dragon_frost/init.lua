AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_DRAGON,CLASS_DRAGON)
end
ENT.sModel = "models/skyrim/dragonsnow.mdl"
ENT.m_shouts = bit.bor(1,4,64)
ENT.ScaleExp = 5
ENT.ScaleLootChance = 0.05
function ENT:SubInit()
end