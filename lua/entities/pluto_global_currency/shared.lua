AddCSLuaFile()
ENT.Base = "pluto_currency"

function ENT:IsVisibleTo(ply)
	return ply:Alive()
end

function ENT:CanPickUp(e)
	if (not e:IsPlayer()) then
		return false
	end

	local r = hook.Run("PlutoCanPickup", e, self)
	if (r == nil) then
		return true
	end

	return r
end

function ENT:ShouldSeeThroughWalls()
	return true
end

function ENT:OnRemove()
	if (SERVER) then
		timer.Simple(0, ttt.CheckTeamWin)
	end
end