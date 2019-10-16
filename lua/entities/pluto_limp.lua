AddCSLuaFile()
pluto.statuses = pluto.statuses or {}

ENT.Base = "pluto_status"
function ENT:Initialize()
	hook.Add("TTTUpdatePlayerSpeed", self, self.TTTUpdatePlayerSpeed)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:SetupDataTables()
	self:NetVar("DeleteTime", "Float", CurTime())
end

function ENT:Think()
	if (self:GetDeleteTime() < CurTime()) then
		print("delete")
		self:Remove()
	end
end

function ENT:TTTUpdatePlayerSpeed(ply, data)
	if (ply == self:GetParent() and CurTime() % 0.2 > 0.15) then
		data.FinalMultiplier = data.FinalMultiplier * 0.1
	end
end

function pluto.statuses.limp(ply, time)
	local flame
	for _, e in pairs(ply:GetChildren()) do
		if (e:GetClass() == "pluto_limp") then
			flame = e
			break
		end
	end

	if (not IsValid(flame)) then
		flame = ents.Create "pluto_limp"
		flame:SetParent(ply)
		flame:Spawn()
	end

	flame:SetDeleteTime(flame:GetDeleteTime() + time)
end
