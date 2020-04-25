TFA = TFA or {}
local SoundChannels = {
	["shoot"] = CHAN_WEAPON,
	["shootwrap"] = CHAN_STATIC,
	["misc"] = CHAN_AUTO
}

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

function TFA.AddFireSound( id, path, wrap, kindv, volume )
	kindv = kindv or ")"
	if isstring(path) then
		sound.Add({
			name = id,
			channel = wrap and SoundChannels.shootwrap or SoundChannels.shoot,
			volume = volume or 1.0,
			level = 120,
			pitch = { 97, 103 },
			sound = TFA.PatchSound( path, kindv )
		})
	elseif istable(path) then
		local tb = table.Copy( path )
		for k,v in pairs(tb) do
			tb[k] = TFA.PatchSound( v, kindv )
		end
		sound.Add({
			name = id,
			channel = wrap and SoundChannels.shootwrap or SoundChannels.shoot,
			volume = volume or 1.0,
			level = 120,
			pitch = { 97, 103 },
			sound = tb
		})
	end
end

function TFA.AddWeaponSound( id, path, kindv )
	kindv = kindv or ")"
	if isstring(path) then
		sound.Add({
			name = id,
			channel = SoundChannels.misc,
			volume = 1.0,
			level = 80,
			pitch = { 97, 103 },
			sound = TFA.PatchSound( path, kindv )
		})
	elseif istable(path) then
		local tb = table.Copy( path )
		for k,v in pairs(tb) do
			tb[k] = TFA.PatchSound( v, kindv )
		end
		sound.Add({
			name = id,
			channel = SoundChannels.misc,
			volume = 1.0,
			level = 80,
			pitch = { 97, 103 },
			sound = tb
		})
	end
end
