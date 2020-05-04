
QUEST.Name = "The Dark Side"
QUEST.Description = "Kill evil players with your lightsaber"
QUEST.Color = Color(219, 29, 41)

function QUEST:GetRewardText(seed)
	return "Double-bladed Lightsaber"
end

function QUEST:Init(data)
	data:Hook("DoPlayerDeath", function(data, ply, atk, dmg)
		local wep = dmg:GetInflictor()
		if (ply:GetRoleData():GetEvil() and IsValid(atk) and IsValid(ply) and atk:IsPlayer() and ply:GetRoleTeam() ~= atk:GetRoleTeam() and atk == data.Player and IsValid(wep) and wep:IsWeapon() and rb655_IsLightsaber(wep)) then
			local gun = wep.PlutoGun
			if (gun and gun.Owner == atk:SteamID64()) then
				data:UpdateProgress(1)
			end
		end
	end)
end

function QUEST:Reward(data)
	local trans, new_item = pluto.inv.generatebufferweapon(data.Player, "unique", "weapon_lightsaber_dual")
	trans:Run()

	data.Player:ChatPrint("You have received a ", new_item, white_text, " for completing ", self.Color, self.Name, white_text, "!")
end

function QUEST:IsType(type)
	return false
end

function QUEST:GetProgressNeeded(type)
	return 75
end
