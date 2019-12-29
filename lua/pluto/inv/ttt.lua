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
		return nil
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

	local text = damagedesc(dmg:GetDamageType())

	if (IsValid(atk)) then
		if (atk:IsPlayer()) then
			text = text .. " by " .. atk:Nick() .. " who was a" .. (atk:GetRole():match "^[aeiouAEIOU]" and "n" or "") .. " " .. atk:GetRole()

			if (IsValid(wep)) then
				text = text .. ". They used their " .. name(wep)
			end
		elseif (game.GetWorld() == atk) then
			text = text .. " by the world"
		elseif (atk:IsWeapon()) then
			text = text .. " by " .. atk:GetPrintName()
		elseif (atk.PrintName) then
			text = text .. " by " .. atk.PrintName
		else
			text = text .. " by " .. atk:GetClass()
		end
	end

	print(text)
	vic:ChatPrint(text)
end)

hook.Add("TTTEndRound", "pluto_endround", function()
	timer.Remove "pluto_afkcheck"
	sql.Begin()
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

		pluto.inv.generatebufferweapon(ply)

		ply:ChatPrint("You have received a weapon! Check your inventory.")
	end
	sql.Commit()
end)

hook.Add("TTTPlayerGiveWeapons", "pluto_loadout", function(ply)
	if (not pluto.inv.invs[ply]) then
		return
	end

	local equip_tab

	for _, tab in pairs(pluto.inv.invs[ply]) do
		if (tab.Type == "equip") then
			equip_tab = tab
			break
		end
	end

	if (not equip_tab) then
		pwarnf("Player doesn't have equip tab!")
		return
	end

	local i1 = equip_tab.Items[1]

	if (i1) then
		pluto.NextWeaponSpawn = i1
		ply:Give(i1.ClassName)
	end

	local i2 = equip_tab.Items[2]

	if (i2) then
		pluto.NextWeaponSpawn = i2
		ply:Give(i2.ClassName)
	end
end)