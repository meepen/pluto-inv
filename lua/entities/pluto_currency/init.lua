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

		local cur = self.Currency
		
		pluto.inv.addcurrency(e, cur.InternalName, 1, function(succ)
			if (not IsValid(e)) then
				return
			end

			if (not succ) then
				e:ChatPrint("i tried to add currency but it didn't work, tell meepen you lost: " .. cur.InternalName)
				return
			end

			e:ChatPrint("You received a " .. cur.Name)
		end)
		self:Remove()
	end
end

function ENT:SV_Initialize()
	self:SetTrigger(true)
	self:PhysicsInitBox(self:GetCollisionBounds())
	self:SetCustomCollisionCheck(true)
	hook.Add("SetupPlayerVisibility", self, self.SetupPlayerVisibility)
end

function ENT:SetCurrency(currency)
	self.Currency = currency

	self:SetIcon(currency.Icon)
end