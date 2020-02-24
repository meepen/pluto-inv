AddCSLuaFile()

ENT.PrintName = "Map Killer"

ENT.Base = "pluto_block"
DEFINE_BASECLASS "pluto_block"

function ENT:Initialize()
	BaseClass.Initialize(self)
	self:SetTrigger(true)
end

function ENT:StartTouch(e)
	if (IsValid(e) and e:IsPlayer()) then
		e:Kill()
	end
end

hook.Add("TTTAddPermanentEntities", "pluto_kill", function(list)
	table.insert(list, "pluto_kill")
end)