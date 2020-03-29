local TFA = {}

local SoundChars = {
	["*"] = "STREAM",--Streams from the disc and rapidly flushed; good on memory, useful for music or one-off sounds
	["#"] = "DRYMIX",--Skip DSP, affected by music volume rather than sound volume
	["@"] = "OMNI",--Play the sound audible everywhere, like a radio voiceover or surface.PlaySound
	[">"] = "DOPPLER",--Left channel for heading towards the listener, Right channel for heading away
	["<"] = "DIRECTIONAL",--Left channel = front facing, Right channel = read facing
	["^"] = "DISTVARIANT",--Left channel = close, Right channel = far
	["("] = "SPATIALSTEREO_LOOP",--Position a stereo sound in 3D space; broken
	[")"] = "SPATIALSTEREO",--Same as above but actually useful
	["}"] = "FASTPITCH",--Low quality pitch shift
	["$"] = "CRITICAL",--Keep it around in memory
	["!"] = "SENTENCE",--NPC dialogue
	["?"] = "USERVOX"--Fake VOIP data; not that useful
}
local DefaultSoundChar = ")"

local SoundChannels = {
	["shoot"] = CHAN_WEAPON,
	["shootwrap"] = CHAN_STATIC,
	["misc"] = CHAN_AUTO
}

--Sounds

function TFA.PatchSound( path, kind )
	local pathv
	local c = string.sub(path,1,1)

	if SoundChars[c] then
		pathv = string.sub( path, 2, string.len(path) )
	else
		pathv = path
	end

	local kindstr = kind
	if not kindstr then
		kindstr = DefaultSoundChar
	end
	if string.len(kindstr) > 1 then
		local found = false
		for k,v in pairs( SoundChars ) do
			if v == kind then
				kindstr = k
				found = true
				break
			end
		end
		if not found then
			kindstr = DefaultSoundChar
		end
	end

	return kindstr .. pathv
end

function TFA.AddSound( name, channel, volume, level, pitch, wave, char )
	char = char or ""

	local SoundData = {
		name = name,
		channel = channel or CHAN_AUTO,
		volume = volume or 1,
		level = level or 75,
		pitch = pitch or 100
	}

	if char ~= "" then
		if type(wave) == "string" then
			wave = TFA.PatchSound(wave, char)
		elseif type(wave) == "table" then
			local patchWave = table.Copy(wave)

			for k, v in pairs(patchWave) do
				patchWave[k] = TFA.PatchSound(v, char)
			end

			wave = patchWave
		end
	end

	SoundData.sound = wave

	sound.Add(SoundData)
end

function TFA.AddFireSound( id, path, wrap, kindv )
	kindv = kindv or ")"

	TFA.AddSound(id, wrap and SoundChannels.shootwrap or SoundChannels.shoot, 1, 120, {97, 103}, path, kindv)
end

function TFA.AddWeaponSound( id, path, kindv )
	kindv = kindv or ")"

	TFA.AddSound(id, SoundChannels.misc, 1, 80, {97, 103}, path, kindv)
end


--AWM
TFA.AddFireSound( "tfa_cso2_awp_tw.1", "tfa_cso2/weapons/awp_tw/awp_tw-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_awp_tw.Boltpull", "tfa_cso2/weapons/awp_tw/awp_tw_boltpull.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp_tw.Clipout01", "tfa_cso2/weapons/awp_tw/awp_tw_clipout_01.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp_tw.Clipout", "tfa_cso2/weapons/awp_tw/awp_tw_clipout.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp_tw.Clipin", "tfa_cso2/weapons/awp_tw/awp_tw_clipin.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp_tw.Reload", "tfa_cso2/weapons/awp_tw/awp_tw_reload.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp_tw.Draw", "tfa_cso2/weapons/awp_tw/awp_tw_draw.ogg")

--AWP
TFA.AddFireSound( "tfa_cso2_awp.1", "tfa_cso2/weapons/awp/awp1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_awp.Bolt", "tfa_cso2/weapons/awp/awp_bolt.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp.Boltpull", "tfa_cso2/weapons/awp/awp_boltpull.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp.Clipoff", "tfa_cso2/weapons/awp/awp_clipoff.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp.Clipout", "tfa_cso2/weapons/awp/awp_clipout.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp.Clipin", "tfa_cso2/weapons/awp/awp_clipin.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp.Reload", "tfa_cso2/weapons/awp/awp_reload.ogg")
TFA.AddWeaponSound( "tfa_cso2_awp.Deploy", "tfa_cso2/weapons/awp/awp_draw.ogg")

--AWP-Tan
TFA.AddFireSound( "tfa_cso2_awptan.1", { "tfa_cso2/weapons/awp_tan/awp_1.ogg", "tfa_cso2/weapons/awp_tan/awp_2.ogg", "tfa_cso2/weapons/awp_tan/awp_3.ogg" }, true, "^" )

TFA.AddWeaponSound( "tfa_cso2_awptan.Bolt", "tfa_cso2/weapons/awp_tan/awp_bolt.ogg")
TFA.AddWeaponSound( "tfa_cso2_awptan.Boltpull", "tfa_cso2/weapons/awp_tan/awp_boltpull.ogg")
TFA.AddWeaponSound( "tfa_cso2_awptan.Clipoff", "tfa_cso2/weapons/awp_tan/awp_clipoff.ogg")
TFA.AddWeaponSound( "tfa_cso2_awptan.Clipout", "tfa_cso2/weapons/awp_tan/awp_clipout.ogg")
TFA.AddWeaponSound( "tfa_cso2_awptan.Clipin", "tfa_cso2/weapons/awp_tan/awp_clipin.ogg")
TFA.AddWeaponSound( "tfa_cso2_awptan.Reload", "tfa_cso2/weapons/awp_tan/awp_reload.ogg")
TFA.AddWeaponSound( "tfa_cso2_awptan.Deploy", "tfa_cso2/weapons/awp_tan/awp_draw.ogg")

--AWM_GAUSS
TFA.AddFireSound( "tfa_cso2_awmgauss.1", "tfa_cso2/weapons/awm_gauss/awm_gauss-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_awmgauss.Boltpull", "tfa_cso2/weapons/awm_gauss/awm_gauss_boltpull.ogg")
TFA.AddWeaponSound( "tfa_cso2_awmgauss.Hiteffect", "tfa_cso2/weapons/awm_gauss/awm_gauss_hit_effect.ogg")
TFA.AddWeaponSound( "tfa_cso2_awmgauss.Clipout", "tfa_cso2/weapons/awm_gauss/awm_gauss_clipout.ogg")
TFA.AddWeaponSound( "tfa_cso2_awmgauss.Clipin", "tfa_cso2/weapons/awm_gauss/awm_gauss_clipin.ogg")
TFA.AddWeaponSound( "tfa_cso2_awmgauss.Reload", "tfa_cso2/weapons/awm_gauss/awm_gauss_reload.ogg")
TFA.AddWeaponSound( "tfa_cso2_awmgauss.Draw", "tfa_cso2/weapons/awm_gauss/awm_gauss_draw.ogg")

--China Lake
TFA.AddFireSound( "tfa_cso2_chinalake.1", "tfa_cso2/weapons/chinalake/chinalake-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_chinalake.Chamberclose", "tfa_cso2/weapons/chinalake/chinalake_chamberclose.ogg")
TFA.AddWeaponSound( "tfa_cso2_chinalake.Chamberopen", "tfa_cso2/weapons/chinalake/chinalake_chamberopen.ogg")
TFA.AddWeaponSound( "tfa_cso2_chinalake.Pump", "tfa_cso2/weapons/chinalake/chinalake_pump.ogg")
TFA.AddWeaponSound( "tfa_cso2_chinalake.InsertShell", "tfa_cso2/weapons/chinalake/chinalake_insertshell.ogg")
TFA.AddWeaponSound( "tfa_cso2_chinalake.Draw", "tfa_cso2/weapons/chinalake/chinalake_draw.ogg")

--Crossbow / TAC-15
TFA.AddFireSound( "tfa_cso2_tac15.1", "tfa_cso2/weapons/tac15/tac15-1.ogg", true, "^" )

TFA.AddWeaponSound( "tfa_cso2_tac15.Arrowin", "tfa_cso2/weapons/tac15/tac15_arrowin.ogg")
TFA.AddWeaponSound( "tfa_cso2_tac15.Windup", "tfa_cso2/weapons/tac15/tac15_windup.ogg")
TFA.AddWeaponSound( "tfa_cso2_tac15.Draw", "tfa_cso2/weapons/tac15/tac15_draw.ogg")
--Double Defender / DBarrel
TFA.AddFireSound( "tfa_cso2_dbarrel.1", "tfa_cso2/weapons/dbarrel/dbarrel-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_dbarrel.Draw", "tfa_cso2/weapons/dbarrel/dbarrel_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_dbarrel.Ejectshell", "tfa_cso2/weapons/dbarrel/dbarrel_ejectshell.ogg")
TFA.AddWeaponSound( "tfa_cso2_dbarrel.Insertshell", "tfa_cso2/weapons/dbarrel/dbarrel_insertshell.ogg")

--DP12/DP-12
TFA.AddFireSound( "tfa_cso2_dp12.1", "tfa_cso2/weapons/dp12/dp12-1.ogg", false, "^" )
TFA.AddWeaponSound( "tfa_cso2_dp12.Lastshoot", "tfa_cso2/weapons/dp12/dp12_lastshoot.ogg")

TFA.AddWeaponSound( "tfa_cso2_dp12.Draw", "tfa_cso2/weapons/dp12/dp12_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_dp12.Insertshell", { "tfa_cso2/weapons/dp12/dp12_insertshell_01.ogg", "tfa_cso2/weapons/dp12/dp12_insertshell_02.ogg", "tfa_cso2/weapons/dp12/dp12_insertshell_03.ogg", "tfa_cso2/weapons/dp12/dp12_insertshell_04.ogg" } )
TFA.AddWeaponSound( "tfa_cso2_dp12.Startreload", "tfa_cso2/weapons/dp12/dp12_startreload.ogg")
TFA.AddWeaponSound( "tfa_cso2_dp12.Endreload", "tfa_cso2/weapons/dp12/dp12_endreload.ogg")

--K12
TFA.AddFireSound( "tfa_cso2_k12.1", "tfa_cso2/weapons/k12/k12-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_k12.Boltpull", "tfa_cso2/weapons/k12/k12_boltpull.ogg")
TFA.AddWeaponSound( "tfa_cso2_k12.Chain", "tfa_cso2/weapons/k12/k12_chain.ogg")
TFA.AddWeaponSound( "tfa_cso2_k12.Coverup", "tfa_cso2/weapons/k12/k12_coverup.ogg")
TFA.AddWeaponSound( "tfa_cso2_k12.Coverdown", "tfa_cso2/weapons/k12/k12_coverdown.ogg")
TFA.AddWeaponSound( "tfa_cso2_k12.Draw", "tfa_cso2/weapons/k12/k12_draw.ogg")

--M107A1
TFA.AddFireSound( "tfa_cso2_m107a1.1", "tfa_cso2/weapons/m107a1/m107a1-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_m107a1.Clipout", "tfa_cso2/weapons/m107a1/m107a1_clipout.ogg")
TFA.AddWeaponSound( "tfa_cso2_m107a1.Clipin", "tfa_cso2/weapons/m107a1/m107a1_clipin.ogg")
TFA.AddWeaponSound( "tfa_cso2_m107a1.Draw", "tfa_cso2/weapons/m107a1/m107a1_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_m107a1.Boltpull", "tfa_cso2/weapons/m107a1/m107a1_boltpull.ogg")

--M249
TFA.AddFireSound( "tfa_cso2_m249.1", "tfa_cso2/weapons/m249/m249-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_m249.Boxin", "tfa_cso2/weapons/m249/m249_boxin.ogg")
TFA.AddWeaponSound( "tfa_cso2_m249.Boxout", "tfa_cso2/weapons/m249/m249_boxout.ogg")
TFA.AddWeaponSound( "tfa_cso2_m249.Chain", "tfa_cso2/weapons/m249/m249_chain.ogg")
TFA.AddWeaponSound( "tfa_cso2_m249.Coverup", "tfa_cso2/weapons/m249/m249_coverup.ogg")
TFA.AddWeaponSound( "tfa_cso2_m249.Coverdown", "tfa_cso2/weapons/m249/m249_coverdown.ogg")
TFA.AddWeaponSound( "tfa_cso2_m249.Deploy", "tfa_cso2/weapons/m249/m249_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_m249.Draw", "tfa_cso2/weapons/m249/m249_draw.ogg")

--M3
TFA.AddFireSound( "tfa_cso2_m3.1", "tfa_cso2/weapons/m3/m3-1.ogg", false, "^" )
TFA.AddFireSound( "tfa_cso2_m3boom.1", "tfa_cso2/weapons/m3/m3boom-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_m3.Draw", "tfa_cso2/weapons/m3/m3_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_m3.Insertshell", "tfa_cso2/weapons/m3/m3_insertshell.ogg" )
TFA.AddWeaponSound( "tfa_cso2_m3.Pump", "tfa_cso2/weapons/m3/m3_pump.ogg")

--M3 Dragon
TFA.AddFireSound( "tfa_cso2_m3dragon.1", "tfa_cso2/weapons/m3dragon/m3dragon-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_m3dragon.Draw", "tfa_cso2/weapons/m3dragon/m3dragon_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_m3dragon.Insert", { "tfa_cso2/weapons/m3dragon/m3dragon_reload_insert1.ogg", "tfa_cso2/weapons/m3dragon/m3dragon_reload_insert2.ogg", "tfa_cso2/weapons/m3dragon/m3dragon_reload_insert3.ogg", "tfa_cso2/weapons/m3dragon/m3dragon_reload_insert4.ogg" } )
TFA.AddWeaponSound( "tfa_cso2_m3dragon.Startreload", "tfa_cso2/weapons/m3dragon/m3dragon_reload_start.ogg")
TFA.AddWeaponSound( "tfa_cso2_m3dragon.Endreload", "tfa_cso2/weapons/m3dragon/m3dragon_reload_end.ogg")

--M60
TFA.AddFireSound( "tfa_cso2_m60.1", "tfa_cso2/weapons/m60/m60-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_m60.Boxin", "tfa_cso2/weapons/m60/m60_boxin.ogg")
TFA.AddWeaponSound( "tfa_cso2_m60.Boxout", "tfa_cso2/weapons/m60/m60_boxout.ogg")
TFA.AddWeaponSound( "tfa_cso2_m60.Chain", "tfa_cso2/weapons/m60/m60_chain.ogg")
TFA.AddWeaponSound( "tfa_cso2_m60.Coverup", "tfa_cso2/weapons/m60/m60_coverup.ogg")
TFA.AddWeaponSound( "tfa_cso2_m60.Coverdown", "tfa_cso2/weapons/m60/m60_coverdown.ogg")
TFA.AddWeaponSound( "tfa_cso2_m60.Deploy", "tfa_cso2/weapons/m60/m60_draw.ogg")

--M79
TFA.AddFireSound( "tfa_cso2_m79.1", "tfa_cso2/weapons/m79/m79-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_m79.Insertshell", "tfa_cso2/weapons/m79/m79_insertshell.ogg")
TFA.AddWeaponSound( "tfa_cso2_m79.Ejectshell", "tfa_cso2/weapons/m79/m79_ejectshell.ogg")
TFA.AddWeaponSound( "tfa_cso2_m79.Draw", "tfa_cso2/weapons/m79/m79_draw.ogg")

--M870
TFA.AddFireSound( "tfa_cso2_m870.1", "tfa_cso2/weapons/m870/m870_shoot.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_m870.Draw", "tfa_cso2/weapons/m870/m870_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_m870.Insert", "tfa_cso2/weapons/m870/m870_reload_insert.ogg" )
TFA.AddWeaponSound( "tfa_cso2_m870.Startreload", "tfa_cso2/weapons/m870/m870_reload_start.ogg" )
TFA.AddWeaponSound( "tfa_cso2_m870.Endreload", "tfa_cso2/weapons/m870/m870_reload_end.ogg" )

--M95
TFA.AddFireSound( "tfa_cso2_m95.1", "tfa_cso2/weapons/m95/m95-1.ogg", true, "^" )

TFA.AddWeaponSound( "tfa_cso2_m95.Boltpull", "tfa_cso2/weapons/m95/m95_boltpull.ogg")
TFA.AddWeaponSound( "tfa_cso2_m95.Clipout", "tfa_cso2/weapons/m95/m95_clipout.ogg")
TFA.AddWeaponSound( "tfa_cso2_m95.Clipin", "tfa_cso2/weapons/m95/m95_clipin.ogg")
TFA.AddWeaponSound( "tfa_cso2_m95.Reload", "tfa_cso2/weapons/m95/m95_reload.ogg")
TFA.AddWeaponSound( "tfa_cso2_m95.Draw", "tfa_cso2/weapons/m95/m95_draw.ogg")

--M99
TFA.AddFireSound( "tfa_cso2_m99.1", "tfa_cso2/weapons/m99/m99-1.ogg", true, "^" )

TFA.AddWeaponSound( "tfa_cso2_m99.Boltpull", "tfa_cso2/weapons/m99/m99_boltpull.ogg")
TFA.AddWeaponSound( "tfa_cso2_m99.Bulletin", "tfa_cso2/weapons/m99/m99_bulletin.ogg")
TFA.AddWeaponSound( "tfa_cso2_m99.Reload", "tfa_cso2/weapons/m99/m99_reload.ogg")
TFA.AddWeaponSound( "tfa_cso2_m99.Draw", "tfa_cso2/weapons/m99/m99_draw.ogg")

--Mg3
TFA.AddFireSound( "tfa_cso2_mg3.1", "tfa_cso2/weapons/mg3/mg3-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_mg3.Boxin", "tfa_cso2/weapons/mg3/mg3_boxin.ogg")
TFA.AddWeaponSound( "tfa_cso2_mg3.Boxout", "tfa_cso2/weapons/mg3/mg3_boxout.ogg")
TFA.AddWeaponSound( "tfa_cso2_mg3.Boltpull", "tfa_cso2/weapons/mg3/mg3_boltpull.ogg")
TFA.AddWeaponSound( "tfa_cso2_mg3.Coverup", "tfa_cso2/weapons/mg3/mg3_coverup.ogg")
TFA.AddWeaponSound( "tfa_cso2_mg3.Coverdown", "tfa_cso2/weapons/mg3/mg3_coverdown.ogg")
TFA.AddWeaponSound( "tfa_cso2_mg3.Draw", "tfa_cso2/weapons/mg3/mg3_draw.ogg")

--Paw20
TFA.AddFireSound( "tfa_cso2_paw20.1", "tfa_cso2/weapons/paw20/paw20-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_paw20.Clipout", "tfa_cso2/weapons/paw20/paw20_clipout.ogg")
TFA.AddWeaponSound( "tfa_cso2_paw20.Clipin", "tfa_cso2/weapons/paw20/paw20_clipin.ogg")
TFA.AddWeaponSound( "tfa_cso2_paw20.Boltpull", "tfa_cso2/weapons/paw20/paw20_boltpull.ogg")
TFA.AddWeaponSound( "tfa_cso2_paw20.Draw", "tfa_cso2/weapons/paw20/paw20_draw.ogg")

--Pkm
TFA.AddFireSound( "tfa_cso2_pkm.1", "tfa_cso2/weapons/pkm/pkm-1.ogg", false, "^" )
TFA.AddFireSound( "tfa_cso2_pkmfire.1", "tfa_cso2/weapons/pkm/pkmfire-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_pkm.Boxin", "tfa_cso2/weapons/pkm/pkm_boxin.ogg")
TFA.AddWeaponSound( "tfa_cso2_pkm.Boxout", "tfa_cso2/weapons/pkm/pkm_boxout.ogg")
TFA.AddWeaponSound( "tfa_cso2_pkm.Chain", "tfa_cso2/weapons/pkm/pkm_chain.ogg")
TFA.AddWeaponSound( "tfa_cso2_pkm.Coverup", "tfa_cso2/weapons/pkm/pkm_coverup.ogg")
TFA.AddWeaponSound( "tfa_cso2_pkm.Coverdown", "tfa_cso2/weapons/pkm/pkm_coverdown.ogg")
TFA.AddWeaponSound( "tfa_cso2_pkm.Boltpull", "tfa_cso2/weapons/pkm/pkm_boltpull.ogg")
TFA.AddWeaponSound( "tfa_cso2_pkm.Draw", "tfa_cso2/weapons/pkm/pkm_draw.ogg")

--QBs09
TFA.AddFireSound( "tfa_cso2_qbs09.1", "tfa_cso2/weapons/qbs09/qbs09-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_qbs09.Draw", "tfa_cso2/weapons/qbs09/qbs09_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_qbs09.Insertshell", { "tfa_cso2/weapons/qbs09/qbs09_insertshell_01.ogg", "tfa_cso2/weapons/qbs09/qbs09_insertshell_02.ogg", "tfa_cso2/weapons/qbs09/qbs09_insertshell_03.ogg", "tfa_cso2/weapons/qbs09/qbs09_insertshell_04.ogg" } )
TFA.AddWeaponSound( "tfa_cso2_qbs09.Startreload", "tfa_cso2/weapons/qbs09/qbs09_startreload.ogg")
TFA.AddWeaponSound( "tfa_cso2_qbs09.Endreload", "tfa_cso2/weapons/qbs09/qbs09_endreload.ogg")

--Qjy88
TFA.AddFireSound( "tfa_cso2_qjy88.1", "tfa_cso2/weapons/qjy88/qjy88-1.ogg", false, "^" )


TFA.AddWeaponSound( "tfa_cso2_qjy88.Boxin", "tfa_cso2/weapons/qjy88/qjy88_boxin.ogg")
TFA.AddWeaponSound( "tfa_cso2_qjy88.Boxout", "tfa_cso2/weapons/qjy88/qjy88_boxout.ogg")
TFA.AddWeaponSound( "tfa_cso2_qjy88.Chain", "tfa_cso2/weapons/qjy88/qjy88_chain.ogg")
TFA.AddWeaponSound( "tfa_cso2_qjy88.Coverup", "tfa_cso2/weapons/qjy88/qjy88_coverup.ogg")
TFA.AddWeaponSound( "tfa_cso2_qjy88.Coverdown", "tfa_cso2/weapons/qjy88/qjy88_coverdown.ogg")
TFA.AddWeaponSound( "tfa_cso2_qjy88.Draw", "tfa_cso2/weapons/qjy88/qjy88_draw.ogg")

--RPG
TFA.AddFireSound( "tfa_cso2_rpg.1", "tfa_cso2/weapons/rpg/rpg-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_rpg.Draw", "tfa_cso2/weapons/rpg/rpg_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_rpg.Reload", "tfa_cso2/weapons/rpg/rpg_reload.ogg")

--Scout
TFA.AddFireSound( "tfa_cso2_scout.1", "tfa_cso2/weapons/scout/scout_fire-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_scout.Bolt", "tfa_cso2/weapons/scout/scout_bolt.ogg")
TFA.AddWeaponSound( "tfa_cso2_scout.Clipout", "tfa_cso2/weapons/scout/scout_clipout.ogg")
TFA.AddWeaponSound( "tfa_cso2_scout.Clipin", "tfa_cso2/weapons/scout/scout_clipin.ogg")
TFA.AddWeaponSound( "tfa_cso2_scout.Deploy", "tfa_cso2/weapons/scout/scout_draw.ogg")

--STriker12
TFA.AddFireSound( "tfa_cso2_striker12.1", "tfa_cso2/weapons/striker12/striker12_shoot.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_striker12.Draw", "tfa_cso2/weapons/striker12/striker12_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_striker12.Insert", "tfa_cso2/weapons/striker12/striker12_insert.ogg" )
TFA.AddWeaponSound( "tfa_cso2_striker12.Startreload", "tfa_cso2/weapons/striker12/striker12_start_reload.ogg")
TFA.AddWeaponSound( "tfa_cso2_striker12.Afterreload", "tfa_cso2/weapons/striker12/striker12_after_reload.ogg")

--TRG42 / TRG-42
TFA.AddFireSound( "tfa_cso2_trg42.1", "tfa_cso2/weapons/trg42/trg42-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_trg42.Clipon", "tfa_cso2/weapons/trg42/trg42_clipon.ogg")
TFA.AddWeaponSound( "tfa_cso2_trg42.Clipin", "tfa_cso2/weapons/trg42/trg42_clipin.ogg")
TFA.AddWeaponSound( "tfa_cso2_trg42.Clipout", "tfa_cso2/weapons/trg42/trg42_clipout.ogg")
TFA.AddWeaponSound( "tfa_cso2_trg42.Draw", "tfa_cso2/weapons/trg42/trg42_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_trg42.Boltpull", "tfa_cso2/weapons/trg42/trg42_boltpull.ogg")

--Triple Barrel / Triple-Barrel / Tribarrel
TFA.AddFireSound( "tfa_cso2_tribarrel.1", "tfa_cso2/weapons/tribarrel/tribarrel-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_tribarrel.Draw", "tfa_cso2/weapons/tribarrel/tribarrel_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_tribarrel.Ejectshell", "tfa_cso2/weapons/tribarrel/tribarrel_ejectshell.ogg")
TFA.AddWeaponSound( "tfa_cso2_tribarrel.Insertshell", "tfa_cso2/weapons/tribarrel/tribarrel_insertshell.ogg")

--USAS12 / USAS-12
TFA.AddFireSound( "tfa_cso2_usas12.1", "tfa_cso2/weapons/usas12/usas12-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_usas12.Clipin", "tfa_cso2/weapons/usas12/usas12_clipin.ogg")
TFA.AddWeaponSound( "tfa_cso2_usas12.Clipout", "tfa_cso2/weapons/usas12/usas12_clipout.ogg")
TFA.AddWeaponSound( "tfa_cso2_usas12.Draw", "tfa_cso2/weapons/usas12/usas12_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_usas12.Boltpull", "tfa_cso2/weapons/usas12/usas12_boltpull.ogg")

--XM1014 / XM-1014
TFA.AddFireSound( "tfa_cso2_xm1014.1", "tfa_cso2/weapons/xm1014/xm1014-1.ogg", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_xm1014.Deploy", "tfa_cso2/weapons/xm1014/xm1014_draw.ogg")
TFA.AddWeaponSound( "tfa_cso2_xm1014.Insertshell", "tfa_cso2/weapons/xm1014/xm1014_insertshell.ogg")


hook.Add("PlutoWorkshopFinish", "tfa_cso2_heavy", function()
	local function AddFile( fn )
		return game.AddParticles("particles/" .. fn .. ".pcf")
	end

	AddFile("tfa_cso2_particles")
	--[[
	AddFile("cso2_rocket_fx")
	AddFile("cso2_explosion_cso2part")
	AddFile("cso2_achievement2")
	AddFile("cso2_muzzleflashes")
	AddFile("cso2_fire_01")
	]]--

	PrecacheParticleSystem("ss_m3dragon_fire_f")
	PrecacheParticleSystem("cso2_pkmfire_01")
	PrecacheParticleSystem("cso2_pkmfire_02")
end)