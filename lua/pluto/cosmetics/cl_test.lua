pluto.cosmetics = pluto.cosmetics or {}

for p, ent in pairs(pluto.cosmetics) do
	if (type(p) == "Player" and p:IsPlayer() and IsValid(ent)) then
		ent:Remove()
	end
end

local Cosmetic = {
	Model = "models/balloons/balloon_star.mdl",
	Init = function(mdl)
		mdl:SetModelScale(0.15, 0)
		mdl:SetMaterial "models/player/shared/gold_player"
		mdl.rand = math.random()

		return true
	end,
	Delete = function(mdl)
		if (IsValid(mdl)) then
			mdl:Remove()
		end

		return true
	end,
	Attach = function(mdl, p)
		local bone = p:LookupBone "ValveBiped.Bip01_Head1"
		if (not bone) then
			return false
		end

		mdl.Bone = bone
		--mdl:FollowBone(p, bone)

		return true
	end,
	Think = function(mdl, p)
		local rotate_time = 3
		local rotate_time2 = 4
		local time = CurTime() + mdl.rand
		local ang = Angle((time % rotate_time) / rotate_time * 360, (time % rotate_time2) / rotate_time2 * 360)
		mdl:SetAngles(ang)

		local center_offset = Vector(0, 0, 1)
		center_offset:Rotate(ang)
		local offset = Vector(0, 8, 4)

		local bpos = p:GetBonePosition(mdl.Bone)
		local base = LocalToWorld(offset, angle_zero, bpos, p:EyeAngles())

		mdl:SetPos(base - center_offset)
	end,
}

function pluto.cosmetics.get(p)
	local c = pluto.cosmetics[p]

	if (not IsValid(c)) then
		if (not IsValid(p) or not p:Alive() or p:IsDormant()) then
			return
		end

		c =  ClientsideModel(Cosmetic.Model)
		p:CallOnRemove(tostring(c), function()
			if (IsValid(c)) then
				c:Remove()
			end
		end)
		if (Cosmetic.Init) then
			Cosmetic.Init(c)
		end
		pluto.cosmetics[p] = c
	end

	if (IsValid(c) and c:GetParent() ~= p) then
		Cosmetic.Attach(c, p)
	end

	return {
		Model = c,
		Cosmetic = Cosmetic
	}
end

local pluto_disable_cosmetics = CreateConVar("pluto_disable_cosmetics", 1, FCVAR_ARCHIVE)

cvars.AddChangeCallback(pluto_disable_cosmetics:GetName(), function(cv, old, new)
	if (pluto_disable_cosmetics:GetBool()) then
		-- reinit

		for p, ent in pairs(pluto.cosmetics) do
			if (type(p) == "Player" and p:IsPlayer() and IsValid(ent)) then
				ent:Remove()
			end
		end
	end
end)

hook.Add("Think", "pluto_cosmetics", function()
	if (pluto_disable_cosmetics:GetBool()) then
		return
	end

	local st = SysTime()
	local rendered = 0
	for _, p in pairs(player.GetAll()) do
		if (p.LastModel ~= p:GetModel()) then
			p.LastModel = p:GetModel()

			-- reinit
			local cosmetics = pluto.cosmetics[p]
			if (cosmetics) then
				cosmetics:Remove()
			end
		end

		local c = pluto.cosmetics.get(p)
		if (not c or not IsValid(c.Model)) then
			continue
		end
		local nodraw = p:IsDormant() or not p:Alive() or p == LocalPlayer() and not p:ShouldDrawLocalPlayer()
		c.Model:SetNoDraw(nodraw)

		if (not nodraw and c.Cosmetic.Think) then
			rendered = rendered + 1
			c.Cosmetic.Think(c.Model, p)
		end
	end
	--print("TIME", SysTime() - st, rendered)
end)