QUEST.Name = "Ghost Buster"
QUEST.Description = "Kill ghosty bois"
QUEST.Color = Color(230, 230, 230)
QUEST.RewardPool = "unique"

function QUEST:GetRewardText()
	return "Jack o Lantern Grenade"
end

function QUEST:Init(data)
	data:Hook("PlutoPlayerKilledGhost", function(data, ply, atk)
		if (ply == data.Player) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	local trans, new_item = pluto.inv.generatebufferweapon(data.Player, "unique", "tfa_cso_pumpkin")
	trans:Run()

	data.Player:ChatPrint(white_text, "You have received ", startswithvowel(new_item.Tier.Name) and "an " or "a ", new_item, white_text, " for completing ", self.Color, self.Name, white_text, "!")
end

function QUEST:GetProgressNeeded()
	return 269
end
