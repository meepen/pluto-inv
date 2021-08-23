--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
AddCSLuaFile()

ENT.PrintName = "Confetti Grenade"
ENT.Base = "ttt_basegrenade"
ENT.Model = "models/weapons/w_eq_smokegrenade_thrown.mdl"

function ENT:Explode()
	-- Smoke particles can't get cleaned up when a round restarts, so prevent
	-- them from existing post-round.
	if (ttt.GetRoundState() == ttt.ROUNDSTATE_ENDED) then
		return
	end

	local data = EffectData()

	data:SetStart(self:GetPos())
	data:SetOrigin(data:GetStart() + vector_up)
	data:SetMagnitude(13)
	data:SetRadius(400)
	data:SetScale(12)
	data:SetFlags(CONFETTI_GRENADE)
	util.Effect("pluto_confetti", data, true, true)

	sound.Play("weapons/confetti_nade/sound.ogg", self:GetPos(), 75, 100, 1)
end