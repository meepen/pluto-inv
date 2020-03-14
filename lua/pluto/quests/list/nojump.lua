QUEST.Name = "Cemented"
QUEST.Description = "Kill people rightfully in one round without jumping"
QUEST.Credits = "add__123"
QUEST.Color = Color(204, 61, 5)

function QUEST:GetRewardText(seed)
	return "gun with a random implicit"
end

function QUEST:Init(data)
	local current = {}
	data:Hook("TTTBeginRound", function(data, gren)
		current = {}
	end)

	data:Hook("EntityTakeDamage", function(data, vic, dmg)
		local inf, atk = dmg:GetInflictor(), dmg:GetAttacker()

		if (IsValid(inf) and atk == data.Player and inf.Slot == 0 and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			current[vic] = true

			if (table.Count(current) == data.ProgressLeft) then
				data:UpdateProgress(data.ProgressLeft)
			end
		end
	end)
end

function QUEST:Reward(data)
	local new_item = pluto.weapons.generatetier()

	local mod = table.shuffle(pluto.mods.getfor(baseclass.Get(new_item.ClassName), function(mod)
		return mod.Type == "implicit" and not mod.PreventChange
	end))[1]

	pluto.weapons.addmod(new_item, mod.InternalName)

	pluto.inv.savebufferitem(data.Player, new_item):Run()

	data.Player:ChatPrint("You have received a ", new_item.Tier.Color, new_item:GetPrintName(), white_text, " with the ", mod.Color or white_text, mod.Name, white_text, " modifier for completeing ", self.Color, self.Name, white_text, "!")
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(3, 4)
end