--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
AddCSLuaFile()

ENT.PrintName = "Shrinkification Grenade"
ENT.Base = "ttt_basegrenade"
ENT.Model = "models/weapons/w_eq_smokegrenade_thrown.mdl"
ENT.LargeDist = math.pow(150, 2)
ENT.MediumDist = math.pow(100, 2)
ENT.SmallDist = math.pow(50, 2)
ENT.Increment = 0.5

function ENT:Explode()
	local pos = self:GetPos()

	local data = EffectData()

	data:SetStart(pos)
	data:SetOrigin(pos + vector_up)
	data:SetMagnitude(10000)
	data:SetRadius(1000)
	data:SetScale(100)
	util.Effect("ManhackSparks", data, true, true)

	sound.Play("npc/barnacle/barnacle_bark1.wav", self:GetPos(), 75, 100, 1)

	for k, ply in ipairs(player.GetAll()) do
		if (not IsValid(ply) or not ply:Alive()) then
			continue
		end

		local dist = ply:GetPos():DistToSqr(pos)
		local amt = self.Increment
		local scale = ply:GetModelScale()

		if (dist > self.LargeDist) then
			continue
		end

		if (dist < self.MediumDist and scale >= 1 / (1 + self.Increment * 2)) then
			amt = amt + self.Increment
		end

		if (dist > self.SmallDist and scale >= 1 / (1 + self.Increment * 3)) then
			amt = amt + self.Increment
		end

		playerscaling.multiplyscale(ply, 1 / (1 + amt * 0.1))

		ply:ChatPrint("You've been shrinkified!")
	end
end