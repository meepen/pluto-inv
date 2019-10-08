include "shared.lua"
AddCSLuaFile "cl_init.lua"

function ENT:IsVisibleTo(ply)
	return ply == self:GetOwner() and ply:Alive()
end

function ENT:StartTouch(e)
	if (self:GetOwner() == e) then
		net.Start(self:GetClass())
			net.WriteVector(self:GetPos())
		net.Send(e)
		print(e, "collected", self)
		self:Remove()
	end
end

function ENT:SV_Initialize()
	self:SetTrigger(true)
	self:PhysicsInitBox(self:GetCollisionBounds())
	self:SetCustomCollisionCheck(true)
	hook.Add("SetupPlayerVisibility", self, self.SetupPlayerVisibility)
	hook.Add("ShouldCollide", self, self.ShouldCollide)
end

function ENT:ShouldCollide(e1, e2)
	if (e1 ~= self and e2 ~= self) then
		return
	end

	local other = e1 == self and e2 or e1

	return other == self:GetOwner()
end

function ENT:SetCurrency(currency)
	self.Currency = currency

	self:SetIcon(currency.Icon)
end