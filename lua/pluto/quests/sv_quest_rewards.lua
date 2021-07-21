
pluto.quests.rewardhandlers = {
	currency = {
		reward = function(self, db, data)
			mysql_cmysql()

            local cur = self.Currency and pluto.currency.byname[self.Currency] or pluto.currency.random()
            local amount = self.Amount or 1

			pluto.inv.addcurrency(db, data.Player, self.Currency, amount)
			data.Player:ChatPrint(white_text, "You have received ", cur, " × ", amount, white_text, " for completing ", data:GetQuestData().Color, data:GetQuestData().Name, white_text, ".")

			return true
		end,
        small = function(self)
            if (self.Small) then
                return self.Small
            end

            local cur = pluto.currency.byname[self.Currency]
            local amount = self.Amount or 1

            return (amount == 1 and "" or  amount .. " ") .. cur.Name .. (amount == 1 and "" or "s")
        end,
	},
	weapon = {
		reward = function(self, db, data)
			mysql_cmysql()

			local classname = self.ClassName or (self.Grenade and pluto.weapons.randomgrenade()) --[[or (self.Melee and pluto.weapons.randommelee())]] or pluto.weapons.randomgun()

			local tier = self.Tier or pluto.tiers.filter(baseclass.Get(classname), function(t)
				if (self.ModMin and t.affixes < self.ModMin) then
					return false
				end

				if (self.ModMax and t.affixes > self.ModMax) then
					return false
				end

				return true
			end).InternalName

			local new_item = pluto.weapons.generatetier(tier, classname)

			for _, mod in ipairs(self.Mods or {}) do
				pluto.weapons.addmod(new_item, mod)
			end

			if (self.RandomImplicit) then
				local implicits = {
					Diced = true,
					Handed = true,
					Dropletted = true,
					Hearted = true,
				}

				local mod = table.shuffle(pluto.mods.getfor(baseclass.Get(classname), function(m)
					return (implicits[m.Name] or false)
				end))[1]

				pluto.weapons.addmod(new_item, mod.InternalName)
			end

			new_item.CreationMethod = "QUEST"
			pluto.inv.savebufferitem(db, data.Player, new_item)
			data.Player:ChatPrint(white_text, "You have received ", startswithvowel(new_item.Tier.Name) and "an " or "a ", new_item, white_text, " for completing ", data:GetQuestData().Color, data:GetQuestData().Name, white_text, "!")

			return true
		end,
		small = function(self)
			if (self.Small) then
				return self.Small
			end

			local smalltext = ""

			if (self.Tier) then
				smalltext = pluto.tiers.byname[self.Tier].Name .. " "
			end

			if (self.ClassName) then
				smalltext = smalltext .. baseclass.Get(self.ClassName).PrintName
			elseif (self.Grenade) then
				smalltext = smalltext .. "grenade"
			else
				smalltext = smalltext .. "gun"
			end

			local append = {}
			if (self.RandomImplicit) then
				table.insert(append, " a random implicit")
			end
			if (self.ModMin and self.ModMax) then
				if (self.ModMin == self.ModMax) then
					table.insert(append, " " .. tostring(self.ModMin) .. " mods")
				else
					table.insert(append, " between " .. tostring(self.ModMin) .. " and " .. tostring(self.ModMax) .. " mods")
				end
			elseif (self.ModMin) then
				table.insert(append, " at least " .. tostring(self.ModMin) .. " mods")
			elseif (self.ModMax) then
				table.insert(append, " at most " .. tostring(self.ModMax) .. " mods")
			end
			for _, text in ipairs(append) do
				smalltext = smalltext .. (_ == 1 and " with" or " and") .. text
			end

			return smalltext
		end,
	},
	shard = {
		reward = function(self, db, data)
			mysql_cmysql()

			local tier = self.Tier or pluto.tiers.filter(baseclass.Get(pluto.weapons.randomgun()), function(t)
				if (self.ModMin and t.affixes < self.ModMin) then
					return false
				end

				if (self.ModMax and t.affixes > self.ModMax) then
					return false
				end

				return true
			end).InternalName

			pluto.inv.generatebuffershard(db, data.Player, "QUEST", tier)
			tier = pluto.tiers.byname[tier]

			data.Player:ChatPrint(white_text, "You have received ", startswithvowel(tier.Name) and "an " or "a ", tier.Color, tier.Name, " Tier Shard", white_text, " for completing ", data:GetQuestData().Color, data:GetQuestData().Name, white_text, "!")

			return true
		end,
		small = function(self)
            if (self.Small) then
                return self.Small
            end

			local smalltext = "shard"

			if (self.Tier) then
				smalltext = pluto.tiers.byname[self.Tier].Name .. " " .. smalltext
			end

			local append = {}
			if (self.ModMin and self.ModMax) then
				if (self.ModMin == self.ModMax) then
					table.insert(append, " " .. tostring(self.ModMin) .. " mods")
				else
					table.insert(append, " between " .. tostring(self.ModMin) .. " and " .. tostring(self.ModMax) .. " mods")
				end
			elseif (self.ModMin) then
				table.insert(append, " at least " .. tostring(self.ModMin) .. " mods")
			elseif (self.ModMax) then
				table.insert(append, " at most " .. tostring(self.ModMax) .. " mods")
			end
			for _, text in ipairs(append) do
				smalltext = smalltext .. (_ == 1 and " with" or " and") .. text
			end

			return smalltext
		end,
	},
}

pluto.quests.rewards = {
	unique = { -- This should never be used
		{
			Type = "unique",
			Shares = 1,
		},
	},
	hourly = {
		{
			Type = "currency",
			Currency = "tome",
			Amount = 3,
			Shares = 1,
		},
		{
			Type = "currency",
			Currency = "crate3_n",
			Amount = 1,
			Shares = 0.1,
		},
		{
			Type = "currency",
			Currency = "crate3",
			Amount = 1,
			Shares = 0.1,
		},
		{
			Type = "currency",
			Currency = "crate1",
			Amount = 1,
			Shares = 0.1,
		},
		{
			Type = "currency",
			Currency = "brainegg",
			Amount = 1,
			Shares = 0.1,
		},
		{
			Type = "currency",
			Currency = "xmas2020",
			Amount = 1,
			Shares = 0.1,
		},
		{
			Type = "currency",
			Currency = "aciddrop",
			Amount = 2,
			Shares = 1,
		},
		{
			Type = "currency",
			Currency = "pdrop",
			Amount = 2,
			Shares = 1,
		},
		{
			Type = "currency",
			Currency = "stardust",
			Amount = 25,
			Shares = 1.5,
		},
		{
			Type = "currency",
			Currency = "tp",
			Amount = 3,
			Shares = 1.5,
		},
		{
			Type = "weapon",
			RandomImplicit = true,
			ModMax = 5,
			ModMin = 4,
			Shares = 2,
		},
		{
			Type = "weapon",
			ModMin = 4,
			Shares = 1,
		},
		{
			Type = "weapon",
			Grenade = true,
			Shares = 1,
		},
		{
			Type = "weapon",
			Tier = "inevitable",
			Shares = 2,
		},
		{
			Type = "shard",
			ModMin = 4,
			Shares = 2,
		},
		{
			Type = "shard",
			Tier = "promised",
			Shares = 0.5,
		},
	},
	daily = {
		{
			Type = "currency",
			Currency = "crate2",
			Amount = 10,
			Shares = 1,
		},
		{
			Type = "currency",
			Currency = "crate3_n",
			Amount = 10,
			Shares = 0.1,
		},
		{
			Type = "currency",
			Currency = "crate3",
			Amount = 3,
			Shares = 0.1,
		},
		{
			Type = "currency",
			Currency = "crate1",
			Amount = 3,
			Shares = 0.1,
		},
		{
			Type = "currency",
			Currency = "stardust",
			Amount = 125,
			Shares = 1.5,
		},
		{
			Type = "currency",
			Currency = "tp",
			Amount = 15,
			Shares = 1.5,
		},
		{
			Type = "currency",
			Currency = "heart",
			Amount = 2,
			Shares = 1.5,
		},
		{
			Type = "weapon",
			ClassName = "weapon_cod4_ak47_silencer",
			Tier = "uncommon",
			Shares = 0.5,
		},
		{
			Type = "weapon",
			ClassName = "weapon_cod4_m4_silencer",
			Tier = "uncommon",
			Shares = 0.5,
		},
		{
			Type = "weapon",
			ClassName = "weapon_cod4_m14_silencer",
			Tier = "uncommon",
			Shares = 0.5,
		},
		{
			Type = "weapon",
			ClassName = "weapon_cod4_g3_silencer",
			Tier = "uncommon",
			Shares = 0.5,
		},
		{
			Type = "weapon",
			ClassName = "weapon_cod4_g36c_silencer",
			Tier = "uncommon",
			Shares = 0.5,
		},
		{
			Type = "weapon",
			ModMin = 5,
			Shares = 2,
		},
		{
			Type = "weapon",
			Tier = "uncommon",
			Mods = {"dropletted", "handed", "diced", "hearted"},
			Small = "Dropletted, Handed, Diced, Hearted Uncommon gun",
			Shares = 1,
		},
		{
			Type = "weapon",
			Tier = "common",
			Mods = {"tomed",},
			Small = "Tomed Common gun",
			Shares = 2,
		},
		{
			Type = "shard",
			ModMin = 5,
			Shares = 1,
		},
	},
	weekly = {
		{
			Type = "currency",
			Currency = "tome",
			Amount = 20,
			Shares = 0.5,
		},
		{
			Type = "currency",
			Currency = "coin",
			Amount = 1,
			Shares = 1,
		},
		{
			Type = "currency",
			Currency = "quill",
			Amount = 1,
			Shares = 1,
		},
		{
			Type = "currency",
			Currency = "tp",
			Amount = 50,
			Shares = 1,
		},
		{
			Type = "currency",
			Currency = "stardust",
			Amount = 500,
			Shares = 1,
		},
		{
			Type = "weapon",
			ModMin = 6,
			ModMax = 6,
			Shares = 1,
		},
		{
			Type = "weapon",
			Tier = "mystical",
			Mods = {"dropletted", "handed", "diced", "hearted"},
			Small = "Dropletted, Handed, Diced, Hearted Mystical gun",
			Shares = 1,
		},
		{
			Type = "weapon",
			Tier = "promised",
			Shares = 1,
		},
		{
			Type = "shard",
			ModMin = 6,
			ModMax = 6,
			Shares = 1,
		},
	},
}


function pluto.quests.poolreward(pick, db, quest)
	mysql_cmysql()

	local QUEST = quest:GetQuestData()
	if (QUEST.Reward) then
		return QUEST.Reward(quest)
	end
	return pluto.quests.rewardhandlers[pick.Type].reward(pick, db, quest)
end

function pluto.quests.poolrewardtext(pick, quest)
	local QUEST = quest:GetQuestData()
	if (QUEST.GetRewardText) then
		return QUEST.GetRewardText(quest)
	end
	return pluto.quests.rewardhandlers[pick.Type].small(pick)
end