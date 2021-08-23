--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
pluto.cosmetics.byentity = pluto.cosmetics.byentity or setmetatable({}, {
	__index = function(self, k)
		self[k] = {}
		return self[k]
	end
}) -- byentity[ent][uid]

-- TODO(meep): invalidate on refresh

-- helper function for inventory
function pluto.cosmetics.render(ply, datas)
	if (not datas) then
		datas = pluto.cosmetics.playerdata(ply)
	end

	local tracked = pluto.cosmetics.byentity[ply]

	-- delete any dead cosmetic instances
	for i = #tracked, 1, - 1 do
		local cosmetic = tracked[i]
		if (not datas[cosmetic.ID]) then
			cosmetic:Remove()
			table.remove(tracked, i)
		end
	end

	local nodraw = ply:IsDormant() or not ply:Alive() or ply == LocalPlayer() and not ply:ShouldDrawLocalPlayer() or LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE and LocalPlayer():GetObserverTarget() == ply
	if (tracked.NoDraw ~= nodraw) then
		tracked.NoDraw = nodraw
		for _, cosmetic in ipairs(tracked) do
			cosmetic:OnRenderStateChanged(not nodraw)
		end
	end

	if (nodraw) then
		return
	end

	if (tracked.Model ~= ply:GetModel()) then
		-- invalidate all existing models due to model change

		tracked.Model = ply:GetModel()

		for _, cosmetic in ipairs(tracked) do
			if (not cosmetic:ValidForModel(ply)) then
				-- TODO(meep): REMOVE
				print "unhandled thingy ma bab"
			else
				cosmetic:OnParentChanged()
			end
		end
	end

	-- create any untracked cosmetics
	for id, data in pairs(datas) do
		local found = false
		for _, cosmetic in ipairs(tracked) do
			if (cosmetic.ID == id) then
				found = true
				break
			end
		end

		if (not found and pluto.cosmetics.byname[data.Type]) then
			local newcosmetic = setmetatable({
				ID = id
			}, pluto.cosmetics.byname[data.Type].mt)
			if (not newcosmetic:ValidForModel(ply)) then
				continue
			end
			newcosmetic:Init(ply)

			table.insert(tracked, newcosmetic)
		end
	end

	for _, cosmetic in ipairs(tracked) do
		cosmetic:Think()
	end
end

function pluto.cosmetics.localdata()
	-- TODO
end
local rand = math.random()

function pluto.cosmetics.playerdata(ply)
	if (ply == LocalPlayer()) then
		-- return pluto.cosmetics.localdata()
	end
	
	return {
		[rand] = {
			Type = "headcrab",
			Data = {},
		}
	}
end


local pluto_cosmetic_level = CreateConVar("pluto_cosmetic_level", 0, FCVAR_ARCHIVE)

cvars.AddChangeCallback(pluto_cosmetic_level:GetName(), function(cv, old, new)
	-- TODO(meep): remove and invalidate all active cosmetics
end)

hook.Add("PreRender", "pluto_cosmetics", function()
	-- TODO(meep): different cosmetic levels will be handled in cosmetics themselves
	if (pluto_cosmetic_level:GetInt() ~= 0 or true) then-- TODO(meep) (added by Addi) Temporarily removed because I deployed on accident
		return
	end

	perfmon.enter "pluto_cosmetics"
	for _, p in pairs(player.GetAll()) do
		pluto.cosmetics.render(p)
	end
	perfmon.exit "pluto_cosmetics"
end)