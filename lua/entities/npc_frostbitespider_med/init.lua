AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_SPIDER,CLASS_SPIDER_FROSTBITE)
end
ENT.sModel = "models/skyrim/frostbitespider_medium.mdl"
ENT.CollisionBounds = Vector(27,27,24)
ENT.fMeleeDistance	= 40
ENT.fMeleeForwardDistance = 220
ENT.fRangeDistance = 700
ENT.skName = "frostbitespider_medium"