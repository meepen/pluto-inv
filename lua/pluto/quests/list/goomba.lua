QUEST.Name = "Noob Stomper"
QUEST.Description = "Goomba stomp people rightfully without movement abilities"
QUEST.Credits = "Eppen"
QUEST.Color = Color(204, 43, 75)

function QUEST:GetReward(seed)
	local items = {
		crate3_n = 4,
		crate3 = 3,
		crate1 = 10,
	}

	local max = 0

	for _, amt in pairs(items) do
		max = max + amt
	end

	local item

	local num = max * seed
	for cur, amt in pairs(items) do
		num = num - amt
		if (num <= 0) then
			item = cur
			break
		end
	end

	local amount = ({
		crate3_n = 20,
		crate3 = 3,
		crate1 = 5
	})[item]

	return amount, item
end

function QUEST:GetRewardText(seed)
	local amount, cur = self:GetReward(seed)
	return "set of " .. amount .. " " .. pluto.currency.byname[cur].Name .. "s"
end

function QUEST:Init(data)
	local failed = false
	data:Hook("TTTBeginRound", function()
		failed = false
	end)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		if (failed) then
			return
		end
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and dmg:IsDamageType(DMG_FALL)) then
			data:UpdateProgress(1)
		end
	end)
	data:Hook("PlutoMovementAbility", function(ply, what)
		failed = true
	end)
end

function QUEST:Reward(data)
	local amount, item = self:GetReward(data.Seed)

	pluto.inv.addcurrency(data.Player, item, amount)

	local cur = pluto.currency.byname[item]
	data.Player:ChatPrint(white_text, "You have received ", startswithvowel(cur.Name) and "an " or "a ", cur, white_text, " for completing ", self.Color, self.Name, white_text, "! (x" .. tostring(amount) .. ")")
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(10, 15)
end