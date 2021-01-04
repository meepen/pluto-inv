local pluto_weapon_droprate = CreateConVar("pluto_weapon_droprate", "0.5", nil, nil, 0, 1)

pluto.afk = pluto.afk or {}

hook.Add("PlayerInitialSpawn", "pluto_afk", function(ply)
	pluto.afk[ply] = {}
end)

hook.Add("TTTBeginRound", "pluto_afk", function()
	for _, ply in pairs(round.GetStartingPlayers()) do
		pluto.afk[ply.Player] = {}
	end
end)

hook.Add("PlayerButtonDown", "pluto_afk", function(ply, btn)
	pluto.afk[ply][btn] = true
end)

local function name(x)
	if (not IsValid(x)) then
		return "INVALID ENTITY"
	elseif (x:IsPlayer()) then
		return x:Nick()
	elseif (IsValid(x)) then
		return x.GetPrintName and x:GetPrintName() or x.PrintName or x:GetClass()
	end
	return "idk"
end

local types = {
	"were crushed to death",
	"were shot to death",
	"were slashed to death",
	"burned to death",
	"got driven over",
	"fell to your death",
	"exploded",
	"were clubbed to death",
	"were shocked to death",
	"bled to death",
	"were lasered to death",
	nil,
	nil,
	nil,
	"drowned to death",
	"were paralyzed to death",
	"were gassed to death",
	"were poisoned to death",
	"were radiated to death",
	nil,
	"were acidified to death",
	"were slowly cooked alive",
	nil,
	"were graity gunned to death",
	"were plasmaed to death",
	"were shot by an airboat",
	"were dissolved to death",
	"were blasted to death",
	nil, -- "were damaged directly",
	"were shotgunned to death",
	"were sniped to death",
	"were exploded by a missile defense",
}

local function damagedesc(n)
	for i = 1, 31 do
		if (bit.band(n, 2 ^ (i - 1)) ~= 0 and types[i]) then
			return "You " .. types[i]
		end
	end

	return "You died"
end

hook.Add("DoPlayerDeath", "pluto_info", function(vic, atk, dmg)
	local wep = dmg:GetInflictor()
	local atk = dmg:GetAttacker()

	local text = {white_text, damagedesc(dmg:GetDamageType())}

	if (IsValid(atk)) then
		if (atk == vic) then
			text = {white_text, "You have ", atk:GetRoleData().Color, "suicided", white_text, "."}
		elseif (atk:IsPlayer()) then
			local next_text = {
				" by ", atk:GetRoleData().Color, atk:Nick(), white_text, " who was a", (atk:GetRole():match "^[aeiouAEIOU]" and "n" or ""), " ", atk:GetRoleData().Color, atk:GetRole(), white_text, "."
			}

			for i, v in ipairs(next_text) do
				text[#text + 1] = v
			end

			if (IsValid(wep) and wep:IsWeapon()) then
				if (wep.PlutoGun) then
					for i, v in ipairs {" They used their ", wep.PlutoGun} do
						text[#text + 1] = v
					end
				else
					for i, v in ipairs {" They used their ", name(wep)} do
						text[#text + 1] = v
					end
				end
			end
		elseif (game.GetWorld() == atk) then
			text[#text + 1] = " by the world"
		elseif (atk:IsWeapon()) then
			text[#text + 1] = " by " .. atk:GetPrintName()
		elseif (atk.PrintName) then
			text[#text + 1] = " by " .. atk.PrintName
		else
			text[#text + 1] = " by " .. atk:GetClass()
		end
	end

	local filtered = {}
	for _, v in ipairs(text) do
		if (isstring(v)) then
			filtered[#filtered + 1] = v
		end
	end

	print(table.concat(filtered))
	vic:ChatPrint(color_black, "- ", unpack(text))
end)

hook.Add("TTTEndRound", "pluto_endround", function()
	timer.Remove "pluto_afkcheck"

	for _, obj in pairs(round.GetStartingPlayers()) do
		local ply = obj.Player
		if (not IsValid(ply)) then
			continue
		end

		if (table.Count(pluto.afk[ply]) <= 5) then
			ply.WasAFK = true
			pprintf("%s was afk this round", ply:Nick())
			continue
		end
		ply.WasAFK = false

		if (not IsValid(ply) or math.random() > pluto_weapon_droprate:GetFloat()) then
			continue
		end
		pluto.db.transact(function(db)
			local item = pluto.inv.generatebufferweapon(db, ply, "DROPPED")

			if (item:GetMaxAffixes() >= 5) then
				local msg = discord.Message()

				msg:AddEmbed(item:GetDiscordEmbed()
					:SetAuthor(ply:Nick() .. "'s", "https://steamcommunity.com/profiles/" .. ply:SteamID64())
				)
				msg:Send "drops"
			end

			ply:ChatPrint("You have received a ", item, white_text, "! Check your inventory.")
			mysql_commit(db)
		end)
	end
end)

local pluto_loaded = {}

hook.Add("TTTPlayerGiveWeapons", "pluto_loadout", function(ply)
	local event = pluto.rounds.getcurrent()
	
	if (event) then
		if (event.Loadout) then
			event:Loadout(ply)
		end

		return true
	end

	for i = 1, 6 do
		local wepid = tonumber(ply:GetInfo("pluto_loadout_slot" .. i, nil))
		local wep = pluto.itemids[wepid]
		if (wep and wep.Owner == ply:SteamID64()) then
			pluto.NextWeaponSpawn = wep
			ply:Give(wep.ClassName)
		end
	end

	pluto_loaded[ply:SteamID64()] = true
	return true
end)

hook.Add("TTTRoundStart", "pluto_loadout_fallback", function(plys)
	for _, ply in ipairs(plys) do
		if (not ply:Alive()) then
			continue
		end

		hook.Run("PlayerSetModel", ply)

		if (not pluto_loaded[ply:SteamID64()]) then
			ply:StripWeapons()
			ply:StripAmmo()
			hook.Run("PlayerLoadout", ply)
		end
	end
end)