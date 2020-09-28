AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_DRAGON,CLASS_DRAGON)
end
ENT.sModel = "models/skyrim/dragonboss.mdl"
ENT.m_shouts = bit.bor(1,2,4,8,16,32,64)
ENT.skName = "dragon_ancient"
ENT.ScaleExp = 10
ENT.ScaleLootChance = 0.025
function ENT:SubInit()
end