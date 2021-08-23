--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
hook.Add("EntityFireBullets", "pluto_hitreg", function(ent, data)
	if (ent:GetOwner() ~= LocalPlayer() or not IsFirstTimePredicted()) then
		return
	end

	if (not ent.GetBulletsShot) then
		return
	end

	local cb = data.Callback

	local bullet_num = ent:GetBulletsShot()
	local pellet = 0

	data.Callback = function(atk, tr, dmginfo)
		if (cb) then
			cb(atk, tr, dmginfo)
		end
		pellet = pellet + 1
		if (not IsValid(tr.Entity) or not tr.Entity:IsPlayer()) then
			return
		end

		net.Start("pluto_hitreg")
			net.WriteEntity(ent)
			net.WriteVector(tr.HitPos)
			net.WriteEntity(tr.Entity)
			net.WriteUInt(bullet_num, 8)
			net.WriteUInt(pellet, 8)
			net.WriteUInt(tr.HitBox, 8)
		net.SendToServer()
	end
end)