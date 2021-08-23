--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
function pluto.inv.writequest(ply, quest)
	net.WriteUInt(quest.RowID, 32)

	local QUEST = quest:GetQuestData()

	net.WriteString(QUEST.Name)
	net.WriteString(QUEST.Description)
	net.WriteColor(QUEST.Color)
	net.WriteString(quest.Type)

	net.WriteBool(QUEST.Credits)
	if (QUEST.Credits) then
		net.WriteString(QUEST.Credits)
	end

	net.WriteString(pluto.quests.poolrewardtext(quest.RewardData, quest))

	net.WriteInt(quest.EndTime - os.time(), 32)
	net.WriteUInt(quest.ProgressLeft, 32)
	net.WriteUInt(quest.TotalProgress, 32)
end

function pluto.inv.writequests(ply)
	local quests = pluto.quests.players(ply)

	if (not quests) then
		net.WriteBool(false)
		return
	end

	for _, quest in ipairs(quests) do
		if (quest.Dead) then
			continue
		end

		net.WriteBool(true)
		pluto.inv.writequest(ply, quest)
	end
	net.WriteBool(false)
end


-- DEV SERVER RELOAD
-- also geralt gay
for _, ply in pairs(player.GetHumans()) do
	pluto.inv.message(ply)
		:write "quests"
		:send()
end