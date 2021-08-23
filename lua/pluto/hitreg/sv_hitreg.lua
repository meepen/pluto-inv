--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
util.AddNetworkString "pluto_hitreg"

local RunCallback -- function(cldata, svdata)
local hitreg_queue = {}
local queue_length = 0.5
-- hitreg_pellets[gun][bullet][pellet]
local hitreg_pellets = setmetatable({}, {
	__index = function(self, shootent)
		local data = setmetatable({}, {
			__index = function(self, bullet_num)
				local data = setmetatable({}, {
					__newindex = function(self, pellet, data)
						local queue = hitreg_queue[shootent]
						if (queue) then
							queue = queue[bullet_num]
							if (queue) then
								queue = queue[pellet]
								if (queue) then
									return RunCallback(queue, data)
								end
							end
						end

						rawset(self, pellet, data)
					end
				})
				self[bullet_num] = data
				return data
			end,
		})

		self[shootent] = data
		return data
	end,
})

function RunCallback(cldata, entry)
	if (entry.Attacker ~= cldata.cl) then
		return
	end
	local shootent = cldata.shootent
	local cl = cldata.cl
	local hitpos = cldata.hitpos
	local hitent = cldata.hitent
	local hitbox = cldata.hitbox

	if (not IsValid(shootent) or not IsValid(hitent) or not shootent:IsWeapon() or not hitent:IsPlayer() or not hitent:Alive()) then
		return
	end

--[[
	if (not util.IntersectRayWithOBB(entry.StartPos, (hitpos - entry.StartPos):GetNormalized() * 160000, hitboxes.Origin, angle_zero, hitboxes.Mins * 1.5, hitboxes.Maxs * 1.5)) then
		pwarnf("Player %s tried to hit %s (invalid)", cl:Nick(), hitent:Nick())
		return
	end
]]

	local hitboxes = entry.Hitboxes[hitent]

	local dmg = DamageInfo()

	dmg:SetAttacker(cl)
	dmg:SetInflictor(shootent)
	dmg:SetDamage(entry.Damage)
	dmg:SetDamagePosition(hitpos)
	dmg:SetDamageType(entry.DamageType)

	entry.Trace.HitPos = hitpos
	entry.Trace.HitGroup = hitboxes[hitbox].Group
	entry.Trace.HitBox = hitbox
	
	shootent:DoDamageDropoff(entry.Trace, dmg)

	hitent:TakeDamageInfo(dmg)
	hook.Run("PlutoHitregOverride", shootent)
end

net.Receive("pluto_hitreg", function(len, cl)
	local shootent = net.ReadEntity()
	local hitpos = net.ReadVector()
	local hitent = net.ReadEntity()
	local bullet_num = net.ReadUInt(8)
	local pellet = net.ReadUInt(8)
	local hitbox = net.ReadUInt(8)

	local cldata = {
		shootent = shootent,
		hitpos = hitpos,
		hitent = hitent,
		hitbox = hitbox,
		cl = cl
	}

	local entry = hitreg_pellets[shootent][bullet_num][pellet]
	if (not entry) then
		local cldata1 = hitreg_queue[shootent]
		if (not cldata1) then
			cldata1 = {}
			hitreg_queue[shootent] = cldata1
		end
		local cldata2 = cldata1[bullet_num]
		if (not cldata2) then
			cldata2 = {}
			cldata1[bullet_num] = cldata2
		end

		cldata2[pellet] = cldata
		return
	end
	hitreg_pellets[shootent][bullet_num][pellet] = nil

	RunCallback(cldata, entry)
end)

local function SnapshotHitboxes()
	local ret = {}
	for _, ply in pairs(player.GetAll()) do
		if (not ply:Alive()) then
			continue
		end
		local mins, maxs = ply:GetCollisionBounds()
		local hitboxes = {
			Mins = mins,
			Maxs = maxs,
			Origin = ply:GetPos(),
		}

		ret[ply] = hitboxes

		local set = ply:GetHitboxSet()

		for hitbox = 0, ply:GetHitBoxCount(set) - 1 do
			local bone = ply:GetHitBoxBone(hitbox, set)

			if (not bone) then
				continue
			end

			local origin, angles = ply:GetBonePosition(bone)
			local mins, maxs = ply:GetHitBoxBounds(hitbox, set)

			hitboxes[hitbox] = {
				Origin = origin,
				Angles = angles,
				Mins = mins,
				Maxs = maxs,
				Group = ply:GetHitBoxHitGroup(hitbox, set)
			}
		end
	end

	return ret
end

hook.Add("EntityFireBullets", "pluto_hitreg", function(ent, data)
	if (not ent.GetBulletsShot) then
		return
	end

	local cb = data.Callback

	local bullet_num = ent:GetBulletsShot()
	local pellet = 0
	local time = CurTime()

	local hitboxes = SnapshotHitboxes()
	local donezo = false
	local damage = ent:GetDamage()

	data.Callback = function(atk, tr, dmginfo, hitreg)
		if (not donezo) then
			pellet = pellet + 1
			if (pellet == (data.Num or 1)) then
				donezo = true
			end
	
			if (not IsValid(tr.Entity) or not tr.Entity:IsPlayer()) then
				hitreg_pellets[ent][bullet_num][pellet] = {
					StartPos = tr.StartPos,
					Normal = tr.Normal,
					Attacker = dmginfo:GetAttacker(),
					Time = time,
					Hitboxes = hitboxes,
					Callback = data.Callback,
					DamageType = dmginfo:GetDamageType(),
					Trace = util.TraceLine(tr),
					Damage = damage,
				}
			end
		end

		if (cb) then
			cb(atk, tr, dmginfo)
		end
	end
end)