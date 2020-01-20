include "shared.lua"
AddCSLuaFile "cl_init.lua"

function ENT:IsVisibleTo(ply)
	return ply == self:GetOwner() and ply:Alive()
end

function ENT:Touch(e)
	if (self:GetOwner() == e and not self.Got) then
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

		end)
		e:ChatPrint(cur.Color, "+ ", white_text, "You received a ", cur.Color, cur.Name)

		self.Got = true
		self:Remove()
	end
end

function ENT:SV_Initialize()
	self:SetTrigger(true)
	self:PhysicsInitBox(self:GetCollisionBounds())
	self:SetCustomCollisionCheck(true)
	hook.Add("SetupPlayerVisibility", self, self.SetupPlayerVisibility)

	self.RoundCreated = ttt.GetRoundNumber()

	hook.Add("TTTPrepareRound", self, self.TTTPrepareRound)
end

function ENT:TTTPrepareRound()
	if (ttt.GetRoundNumber() - self.RoundCreated >= 3) then
		self:Remove()
	end
end

function ENT:SetCurrency(currency)
	self.Currency = currency

	self:SetIcon(currency.Icon)
end

hook.Add("TTTAddPermanentEntities", "pluto_currency", function(list)
	table.insert(list, "pluto_currency")
end)