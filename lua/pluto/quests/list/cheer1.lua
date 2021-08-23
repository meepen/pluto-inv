--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

QUEST.Name = "S.A.N.T.A. Supreme"
QUEST.Description = "Deliver Toys"
QUEST.Color = Color(21, 128, 0)
QUEST.RewardPool = "unique"

function QUEST:GetRewardText()
	return "Dart Pistol"
end

function QUEST:Init(data)
	data:Hook("PlutoToyDelivered", function(data, ply)
		if (IsValid(ply) and ply == data.Player) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(db, data)
	local new_item = pluto.inv.generatebufferweapon(db, data.Player, "QUEST", "unique", "tfa_cso_dartpistol")

	data.Player:ChatPrint(white_text, "You have received ", startswithvowel(new_item.Tier.Name) and "an " or "a ", new_item, white_text, " for completing ", self.Color, self.Name, white_text, "!")
	return true
end

function QUEST:GetProgressNeeded()
	return 100
end
