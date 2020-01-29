AddCSLuaFile()

ENT.PrintName = "Map Blocker"

ENT.Type = "anim"
ENT.Base = "base_brush"

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "Mins")
	self:NetworkVar("Vector", 1, "Maxs")
end

function ENT:Initialize()
    self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionBounds(self:GetMins(), self:GetMaxs())
	self:SetCustomCollisionCheck(true)
	self:PhysicsInitBox(self:GetMins(), self:GetMaxs())
    local physobj = self:GetPhysicsObject()
    if (IsValid(physobj)) then
		physobj:EnableMotion(false)
	end

	hook.Add("ShouldCollide", self, self.ShouldCollide)
	self:CollisionRulesChanged()
end

function ENT:ShouldCollide(e1, e2)
	if (e1 == self or e2 == self) then
		return true
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

hook.Add("TTTAddPermanentEntities", "pluto_block", function(list)
	table.insert(list, "pluto_block")
end)