--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
pluto.quests = pluto.quests or {}
pluto.quests.cache = pluto.quests.cache or {}

function pluto.inv.readquest()
	local id = net.ReadUInt(32)

	local quest = pluto.quests.cache[id] or {}

	pluto.quests.cache[id] = quest

	quest.ID = id

	quest.Name = net.ReadString()
	quest.Description = net.ReadString()
	quest.Color = net.ReadColor()
	quest.Tier = net.ReadString()
	if (net.ReadBool()) then
		quest.Credits = net.ReadString()
	end

	quest.Reward = net.ReadString()

	quest.EndTime = os.time() + net.ReadInt(32)
	quest.ProgressLeft = net.ReadUInt(32)
	quest.TotalProgress = net.ReadUInt(32)

	hook.Run("PlutoQuestUpdated", quest)

	return quest
end

function pluto.inv.readquests()
	local quests = {}
	while (net.ReadBool()) do
		quests[#quests + 1] = pluto.inv.readquest()
	end

	pluto.quests.current = quests
	
	hook.Run("PlutoActiveQuestsUpdated", quests)
end

