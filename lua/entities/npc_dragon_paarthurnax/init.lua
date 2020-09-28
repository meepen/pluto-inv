AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_PLAYER,CLASS_PLAYER_ALLY)
end
ENT.sModel = "models/skyrim/dragonparthurnax.mdl"
ENT.m_shouts = bit.bor(1,2,4,8,16,32,64)
ENT.ScaleExp = 10
ENT.ScaleLootChance = 0.03
function ENT:SubInit()
end