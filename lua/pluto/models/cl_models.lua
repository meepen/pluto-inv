fixups = {
	png = {},
	vmt = {},
}

CreateConVar("pluto_model", "", FCVAR_USERINFO)

function pluto.model(name)
	return function(d)
		player_manager.AddValidModel(d.Name, d.Model)
		if (d.Hands) then
			player_manager.AddValidHands(d.Name, d.Hands, 0, "00000000")
		end

		for _, fname in pairs(d.Downloads or {}) do
			for _, add in pairs((file.Find(fname .. "*", "GAME"))) do
				local ext = add:GetExtensionFromFilename()
				local name = fname .. add
				if (fixups[ext]) then
					fixups[ext][fname .. add] = fname .. add
				end
			end
		end
	end
end

include "sh_list.lua"

do return end

local function init()
	for ind, data in pairs(fixups.png) do
		local mat = Material(ind)
		local w, h = mat:GetInt "$realwidth", mat:GetInt "$realheight"
		local rt = GetRenderTargetEx("lua_" .. ind, w, h, RT_SIZE_LITERAL, MATERIAL_RT_DEPTH_NONE, 2, 0, IMAGE_FORMAT_RGBA8888)
		render.PushRenderTarget(rt)
		render.OverrideAlphaWriteEnable(true, true)
		render.Clear(0, 0, 0, 0)
		render.SetMaterial(mat)
		render.DrawScreenQuad()
		render.OverrideAlphaWriteEnable(false)
		render.PopRenderTarget()
		fixups.png[ind] = rt
	end

	local function tryfix(mat, dat, keys)
		for _, key in pairs(keys) do
			local real = dat[key]
			if (not real) then
				return
			end

			local png = fixups.png["materials/" .. real:gsub("\\", "/") .. ".png"]

			if (not png) then
				return
			end

			mat:SetTexture(key, png)
		end
	end

	for ind, data in pairs(fixups.vmt) do
		if (file.Exists(ind, "GAME")) then
			local mat = Material(ind:sub(11, -5))
			if (mat:IsError()) then
				continue
			end
			local t = util.KeyValuesToTable(file.Read(ind, "GAME"))

			tryfix(mat, t, {"$basetexture", "$bumpmap", "$phongexponenttexture"})
		end
	end
end

hook.Add("PreRender", "pluto_png", function()
	hook.Remove("PreRender", "pluto_png")
	init()
end)