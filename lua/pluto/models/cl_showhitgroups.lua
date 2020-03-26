local pluto_showhitgroups = CreateConVar("pluto_showhitgroups", 0, { FCVAR_CHEAT }, "Show hitgroups on player models.", 0, 1)

local pluto_showhitgroups_basic = CreateConVar("pluto_showhitgroups_basic", 1, { FCVAR_CHEAT }, "Show hitgroups with basic text", 0, 1)

local health_full = Color(58, 180, 80)
local health_ok = Color(240, 255, 0)
local health_dead = Color(255, 51, 0)

local function ColorLerp(col_from, col_mid, col_to, amt)
	if (amt > 0.5) then
		col_from = col_mid
		amt = (amt - 0.5) * 2
	else
		col_to = col_mid
		amt = amt * 2
	end

	local fr, fg, fb = col_from.r, col_from.g, col_from.b
	local tr, tg, tb = col_to.r, col_to.g, col_to.b

	return fr + (tr - fr) * amt, fg + (tg - fg) * amt, fb + (tb - fb) * amt
end

local first = Color(0, 0, 255, 100)
local middle = Color(0, 255, 0, 100)
local last = Color(255, 0, 0, 100)


local hitgroup_translate = {
	[HITGROUP_HEAD] = "Head",
	[HITGROUP_CHEST] = "Chest",
	[HITGROUP_STOMACH] = "Stomach",
	[HITGROUP_LEFTARM] = "Left Arm",
	[HITGROUP_RIGHTARM] = "Right Arm",
	[HITGROUP_LEFTLEG] = "Left Leg",
	[HITGROUP_RIGHTLEG] = "Right Leg",
	[HITGROUP_GEAR] = "Gear",
	[HITGROUP_GENERIC] = "Generic",
}

local hitgroup_translate_text = {}

for k, v in pairs(hitgroup_translate) do
	hitgroup_translate_text[v] = k
end

hook.Add("PostPlayerDraw", "pluto_showhitgroups", function(ply)
	if (not pluto_showhitgroups:GetBool() or ply:IsDormant() or ply:IsBot()) then
		return
	end

	local set = ply:GetHitboxSet()

	local count = ply:GetHitBoxCount(set)

	for hitbox = 0, count - 1 do
		local boneid = ply:GetHitBoxBone(hitbox, set)
		local mins, maxs = ply:GetHitBoxBounds(hitbox, set)
		local origin, angles = ply:GetBonePosition(boneid)

		local hitgroup = ply:GetHitBoxHitGroup(hitbox, set)

		render.DrawWireframeBox(origin, angles, mins, maxs, Color(ColorLerp(first, middle, last, hitbox / (count - 1))))
	end

	surface.SetFont "BudgetLabel"

	cam.Start2D()
		for hitbox = 0, count - 1 do
			local boneid = ply:GetHitBoxBone(hitbox, set)
			local mins, maxs = ply:GetHitBoxBounds(hitbox, set)
			local origin, angles = ply:GetBonePosition(boneid)

			local hitgroup = ply:GetHitBoxHitGroup(hitbox, set)

			local corner0 = LocalToWorld(mins, angle_zero, origin, angles)
			local corner1 = LocalToWorld(maxs, angle_zero, origin, angles)

			local mid = ((corner0 + corner1) / 2):ToScreen()

			if (not mid.visible) then
				continue
			end

			local text
			if (pluto_showhitgroups_basic:GetBool()) then
				text = string.format("%i", hitbox)
			else
				text = string.format("%i (%s)", hitbox, hitgroup_translate[hitgroup] or "unknown")
			end

			local w, h = surface.GetTextSize(text)

			surface.SetTextPos(mid.x - w / 2, mid.y - h / 2)

			surface.SetTextColor(Color(ColorLerp(first, middle, last, hitbox / (count - 1))))

			surface.DrawText(text)
		end
	cam.End2D()
end)

concommand.Add("pluto_print_hitgroups", function(ply)
	local set = ply:GetHitboxSet()

	local count = ply:GetHitBoxCount(set)
	local zbase = ply:GetPos().z

	for hitbox = 0, count - 1 do
		local boneid = ply:GetHitBoxBone(hitbox, set)
		local mins, maxs = ply:GetHitBoxBounds(hitbox, set)
		local origin, angles = ply:GetBonePosition(boneid)

		local hitgroup = ply:GetHitBoxHitGroup(hitbox, set)

		local corner0 = LocalToWorld(mins, angle_zero, origin, angles)
		local corner1 = LocalToWorld(maxs, angle_zero, origin, angles)

		local mid = (corner0 + corner1) / 2

		pprintf("Hitbox %i\n\tHitGroup: %s\n\tZ Pos: %.2f", hitbox, hitgroup_translate[hitgroup] or "unknown", mid.z - zbase)
	end
end)

--[[
Hitbox 0
	HitGroup: Generic
	Z Pos: 32.44
]]

local function ReadFileToTable(fname)
	local f = file.Read(fname, "GAME")

	if (not f) then
		return false, "Couldn't find file"
	end

	local ret = {}

	for hitbox, hitgroup in f:gmatch "Hitbox (%d+)%s+HitGroup:%s+([^\n\r\t]+)" do
		ret[tonumber(hitbox)] = hitgroup_translate_text[hitgroup]
	end

	return ret
end

local function StringToLong(str)
	local a, b, c, d = str:byte(1, 4)

	return a + bit.lshift(b, 8) + bit.lshift(c, 16) + bit.lshift(d, 24)
end

concommand.Add("pluto_update_hitgroups", function(ply, cmd, args, arg)
	local model = ply:GetModel()

	local update = ReadFileToTable(arg) or {}

	if (not update) then
		pwarnf("Couldn't read update file %q", arg)
	end

	local current = file.Open(model, "rb", "GAME")

	if (not current) then
		pwarnf("Cannot open model file %s!", model)
		return
	end

	model = "addons/test_models/" .. model

	local cur_path = ""

	for folder in model:GetPathFromFilename():gmatch "[^/\\]+" do
		cur_path = cur_path .. folder .. "/"
		file.CreateDir(cur_path:sub(1, -2))
	end

	local new = file.Open(model .. ".dat", "wb", "DATA")

	if (not new) then
		pwarnf("Cannot open write file data/" .. model .. ".dat")
		return
	end

	new:Write(current:Read(current:Size()))

	current:Seek(176)
	local offset = current:ReadLong()

	for group = 0, ply:GetHitboxSetCount() - 1 do
		current:Seek(offset + 12 * group + 8)
		local new_offset = offset + current:ReadLong()
		for hitbox = 0, ply:GetHitBoxCount(group) - 1 do
			if (update[hitbox]) then
				new:Seek(new_offset + hitbox * 68 + 4 + 4)
				new:WriteLong(update[hitbox])
			end

			new:Seek(new_offset + hitbox * 68 + 4 + 8)
			current:Seek(new_offset + hitbox * 68 + 4 + 8)

			local maxs, mins = Vector(), Vector()
			for i = 1, 3 do
				mins[i] = current:ReadFloat()
			end
			for i = 1, 3 do
				maxs[i] = current:ReadFloat()
			end

			if (hitbox == 14) then
				mins.z = mins.z + 3
				maxs.z = maxs.z - 3
				mins.y = mins.y - 3
				maxs.y = maxs.y + 3
				mins.x = mins.x - 3
				maxs.x = maxs.x + 3
			end

			for i = 1, 3 do
				new:WriteFloat(mins[i])
			end
			for i = 1, 3 do
				new:WriteFloat(maxs[i])
			end

			print(hitbox, mins, maxs)
		end
	end

	new:Close()
	current:Close()

	pprintf("File written to %s", util.RelativePathToFull("data/" .. model .. ".dat"))
end)