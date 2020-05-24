hook.Add("PlutoWorkshopFinish", "pluto_workshop", function()
	CreateMaterial("pluto_glow", "SpriteCard", {
		["$basetexture"] = "sprites/animglow02",
		["$additive"] = "1",
		["$vertexcolor"] = "1",
		["$vertexalpha"] = "1",
	})

	game.AddParticles "particles/pluto_sparklies.pcf"
end)

pluto.sparklelist = pluto.sparklelist or setmetatable({}, {__mode = "k"})

function pluto.sparkle(what, turnon)
	local system = pluto.sparklelist[what]
	if (IsValid(system) and not turnon) then
		system:StopEmissionAndDestroyImmediately()
	elseif (not IsValid(system) and turnon) then
		pluto.sparklelist[what] = CreateParticleSystem(what, "pluto_sparklies", PATTACH_ABSORIGIN_FOLLOW, 0)
	end
end

timer.Create("pluto_sparkle_update", 0.5, 0, function()
	for what, system in pairs(pluto.sparklelist) do
		if (not IsValid(what) or not IsValid(system)) then
			continue
		end

		system:SetShouldDraw(not what:IsPlayer() or not (what:IsDormant() or not what:Alive() or what == LocalPlayer() and not what:ShouldDrawLocalPlayer()))
	end
end)