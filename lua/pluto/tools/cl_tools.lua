--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local colour = Material "models/debug/debugwhite"

concommand.Add("pluto_generate_weapon", function(ply, cmd, args)
	local arg = args[1]
	local list = {}
	if (arg == "all") then
		for _, wep in pairs(weapons.GetList()) do
			if (wep.AutoSpawnable) then
				table.insert(list, wep)
			end
		end
	else
		local wep = baseclass.Get(arg)

		if (not wep) then
			pwarnf("No weapon %s", args[1])
			return
		end

		if (not wep.AutoSpawnable) then
			pwarnf("Not valid")
			return
		end

		table.insert(list, wep)
	end

	local w = tonumber(args[2] or 128)
	local h = w

	for _, wep in pairs(list) do
		wep = baseclass.Get(wep.ClassName)
		local err = ClientsideModel(wep.WorldModel, RENDERGROUP_OTHER)

		local lookup = wep.Ortho or {0, 0}

		local x, y = 0, 0
		local mins, maxs = err:GetModelBounds()
		local angle = Angle(0, -90)
		local size = mins:Distance(maxs) / 2.5 * (lookup.size or 1) * 1.1

		local fname = wep.ClassName .. ".png"
		

		render.SetStencilWriteMask(0xff)
		render.SetStencilTestMask(0xff)

		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)

		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_ZERO)
		render.SetStencilZFailOperation(STENCIL_KEEP)

		render.OverrideAlphaWriteEnable(true, true)
		render.Clear(255, 255, 255, 255, true, true)
		render.OverrideAlphaWriteEnable(false, false)

		render.SetStencilEnable(true)
		cam.Start3D(vector_origin, lookup.angle or angle, 90, x, y, w, h)
			cam.StartOrthoView(lookup[1] + -size, lookup[2] + size, lookup[1] + size, lookup[2] + -size)
				render.SuppressEngineLighting(true)
					err:SetAngles(Angle(-40, 10, 10))
					render.PushFilterMin(TEXFILTER.ANISOTROPIC)
					render.PushFilterMag(TEXFILTER.ANISOTROPIC)
						render.OverrideAlphaWriteEnable(true, false)
							err:DrawModel()
						render.OverrideAlphaWriteEnable(false, false)
					render.PopFilterMag()
					render.PopFilterMin()
				render.SuppressEngineLighting(false)
			cam.EndOrthoView()
		cam.End3D()

		render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)

		render.ClearBuffersObeyStencil(0, 0, 0, 0, false)
		render.SetStencilEnable(false)

		file.Write(fname, render.Capture {
			format = "png",
			alpha = true,
			x = x,
			y = y,
			w = w,
			h = h
		})

		err:Remove()

		pprintf("Done. Saved to %s (copied to clipboard)", "data/" .. fname)
		SetClipboardText("data/" .. fname)
	end
end)

concommand.Add("pluto_generate_model", function(ply, cmd, args)
	local arg = args[1]
	local list = {}
	if (arg == "all") then
		for _, mdl in pairs(pluto.models) do
			table.insert(list, mdl)
		end
	else
		list[1] = pluto.models[arg]
	end

	local w = tonumber(args[2] or 128)
	local h = w

	for _, mdl in pairs(list) do
		local err = ClientsideModel(mdl.Model, RENDERGROUP_OTHER)
		err:ResetSequence(err:LookupSequence "idle_all_01")
		local fname = "model_" .. mdl.InternalName .. ".png"

		local mins, maxs = err:GetModelBounds()
		local x, y = 0, 0

		render.SetStencilWriteMask(0xff)
		render.SetStencilTestMask(0xff)

		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)

		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_ZERO)
		render.SetStencilZFailOperation(STENCIL_KEEP)

		render.OverrideAlphaWriteEnable(true, true)
		render.Clear(255, 255, 255, 255, true, true)
		render.OverrideAlphaWriteEnable(false, false)

		render.SetStencilEnable(true)
		cam.Start3D(Vector(50, 0, (maxs.z - mins.z) / 2 - 2), Angle(0, -180), 90, x, y, w, h)
			render.SuppressEngineLighting(true)
				render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				render.PushFilterMag(TEXFILTER.ANISOTROPIC)
					render.OverrideAlphaWriteEnable(true, false)
						err:DrawModel()
					render.OverrideAlphaWriteEnable(false, false)
				render.PopFilterMag()
				render.PopFilterMin()
			render.SuppressEngineLighting(false)
		cam.End3D()


		render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)

		render.ClearBuffersObeyStencil(0, 0, 0, 0, false)
		render.SetStencilEnable(false)

		file.Write(fname, render.Capture {
			format = "png",
			alpha = true,
			x = x,
			y = y,
			w = w,
			h = h
		})
		pprintf("Done. Saved to %s (copied to clipboard)", "data/" .. fname)
		SetClipboardText("data/" .. fname)

		err:Remove()
	end
end)