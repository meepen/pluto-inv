include "shared.lua"
AddCSLuaFile "cl_init.lua"

function ENT:IsVisibleTo(ply)
	return ply == self:GetOwner() and ply:Alive()
end

function ENT:CanPickUp(e)
	return self:GetOwner() == e
end

function ENT:Reward(e)
	local cur = self.Currency
	if (cur.Pickup) then
		if (not cur.Pickup(e)) then
			return false
		end
	end

	net.Start "pluto_currency"
		net.WriteVector(self:GetPos())
	net.Send(e)


	if (not cur.Fake) then
		pluto.db.instance(function(db)
			local succ, err = pluto.inv.addcurrency(db, e, cur.InternalName, 1)
			if (not IsValid(e)) then
				return
			end

			if (not succ) then
				e:ChatPrint("i tried to add currency but it didn't work, tell meepen you lost: " .. cur.InternalName)
			end
		end)
		print (cur)
		e:ChatPrint(cur.Color, "+ ", white_text, "You received ", startswithvowel(cur.Name) and "an " or "a ", cur)
	end

	self.Got = true

	return true
end

function ENT:Touch(e)
	if (self:IsVisibleTo(e) and not self.Got and self:CanPickUp(e)) then
		if (self:Reward(e)) then
			self:Remove()
		end
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