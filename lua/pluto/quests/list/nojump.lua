QUEST.Name = "Cemented"
QUEST.Description = "Kill people rightfully in one round without jumping"
QUEST.Credits = "add__123"
QUEST.Color = Color(204, 61, 5)

function QUEST:GetRewardText(seed)
	return "gun with at most 4 mods and a random implicit"
end

function QUEST:Init(data)
	local current = 0
	data:Hook("TTTBeginRound", function(data, gren)
		current = 0
	end)

	data:Hook("KeyPress", function(data, ply, key)
		if (ply == data.Player and key == IN_JUMP and ply:IsOnGround()) then
			current = 0
		end
	end)

	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			current = current + 1

			if (current == data.ProgressLeft) then
				data:UpdateProgress(data.ProgressLeft)
			end
		end
	end)
end

function QUEST:Reward(data)
	local gun = pluto.weapons.randomgun()
	local new_item = pluto.weapons.generatetier(pluto.tiers.filter(baseclass.Get(gun), function(t)
		return t.affixes <= 4
	end), gun)

	local mod = table.shuffle(pluto.mods.getfor(baseclass.Get(new_item.ClassName), function(mod)
		return mod.Type == "implicit" and not mod.PreventChange
	end))[1]

	pluto.weapons.addmod(new_item, mod.InternalName)

	pluto.inv.savebufferitem(data.Player, new_item):Run()

	data.Player:ChatPrint("You have received a ", new_item.Tier.Color, new_item:GetPrintName(), white_text, " with the ", mod.Color or white_text, mod.Name, white_text, " modifier for completing ", self.Color, self.Name, white_text, "!")
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(2, 3)
end