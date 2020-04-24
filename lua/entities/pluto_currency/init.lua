include "shared.lua"
AddCSLuaFile "cl_init.lua"

function ENT:IsVisibleTo(ply)
	return ply == self:GetOwner() and ply:Alive()
end

function ENT:CanPickUp(e)
	return self:GetOwner() == e
end

function ENT:Reward(e)
	net.Start "pluto_currency"
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
	e:ChatPrint(cur.Color, "+ ", white_text, "You received a ", cur)
	self.Got = true
end

function ENT:Touch(e)
	if (self:CanPickUp(e) and self:IsVisibleTo(e) and not self.Got) then
		self:Reward(e)
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

function pluto.statuses.greed(ply, dist, time)
	ply:SetCurrencyTime(time + CurTime())
	ply:SetCurrencyDistance(dist)
end

hook.Add("PlayerSpawn", "pluto_currency", function(p)
	p:SetCurrencyTime(-math.huge)
end)

hook.Add("TTTAddPermanentEntities", "pluto_currency", function(list)
	table.insert(list, "pluto_currency")
end)