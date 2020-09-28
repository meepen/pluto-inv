AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_DRAGON,CLASS_DRAGON)
end
ENT.sModel = "models/skyrim/dragonforest.mdl"
ENT.skName = "dragon_blood"
ENT.ScaleExp = 5
ENT.ScaleLootChance = 0.05
function ENT:SubInit()
	if(math.random(1,6) == 1) then self:AddShouts(bit.bor(1,4,16,32,64)); return end
	self:AddShouts(math.random(1,2) == 1 && bit.bor(4,64) || bit.bor(1,16,32))
end