AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_DRAGON,CLASS_DRAGON)
end
ENT.sModel = "models/skyrim/dragonskeleton.mdl"
ENT.m_shouts = bit.bor(1,2,4,8,16,32,64)
ENT.ScaleExp = 8
ENT.CanFly = false
ENT.skName = "dragon_skeleton"
ENT.ScaleLootChance = 0.04
function ENT:SubInit()
end