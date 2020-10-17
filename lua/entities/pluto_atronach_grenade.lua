AddCSLuaFile()

ENT.PrintName = "Atronach Grenade"
ENT.Base = "ttt_basegrenade"
ENT.Model = "models/weapons/tfa_cso/w_pumpkin.mdl"

function ENT:GetGrenadeColor()
	return self.WeaponData.GrenadeColor
end

function ENT:Explode()
	if (ttt.GetRoundState() == ttt.ROUNDSTATE_ENDED) then
		return
	end

	local npcs = {}
	for i = 1, 1 do 
		local npc = ents.Create "npc_atronach_flame"
		npc:SetPos(self:GetPos())
		npc:SetAngles(angle_zero)
		npc:SetDamageOwner(self:GetOwner())
		npc:Spawn()
		npcs[i] = npc
	end

	timer.Simple(30, function()
		for _, npc in pairs(npcs) do
			if (IsValid(npc)) then
				npc:TakeDamage(100000)
			end
		end
	end)
end