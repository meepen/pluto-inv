pluto.quests = pluto.quests or {}
pluto.quests.cache = pluto.quests.cache or {}

function pluto.inv.readquest()
	local id = net.ReadUInt(32)

	local quest = pluto.quests.cache[id] or {}

	pluto.quests.cache[id] = quest

	quest.ID = id
	quest.Name = net.ReadString()
	quest.EndTime = os.time() + net.ReadUInt(32)
	quest.ProgressLeft = net.ReadUInt(32)

	return quest
end

function pluto.inv.readquests()
	if (not net.ReadBool()) then
		return
	end

	local quests = {}
	while (net.ReadBool()) do
		local cur_type = {}
		quests[net.ReadString()] = cur_type

		for i = 1, net.ReadUInt(8) do
			cur_type[#cur_type + 1] = pluto.inv.readquest()
		end
	end

	PrintTable(quests)
end
