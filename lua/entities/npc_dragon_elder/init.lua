AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_DRAGON,CLASS_DRAGON)
end
ENT.m_shouts = bit.bor(1,2,4,8,16,32,64)
ENT.sModel = "models/skyrim/dragontundra.mdl"
ENT.skName = "dragon_elder"
ENT.ScaleExp = 7
ENT.ScaleLootChance = 0.04
function ENT:SubInit()
end