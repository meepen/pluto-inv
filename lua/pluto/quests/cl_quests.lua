pluto.quests = pluto.quests or {}
pluto.quests.cache = pluto.quests.cache or {}

function pluto.inv.readquest()
	local id = net.ReadUInt(32)

	local quest = pluto.quests.cache[id] or {}

	pluto.quests.cache[id] = quest

	quest.ID = id
	quest.Name = net.ReadString()
	quest.EndTime = os.time() + net.ReadInt(32)
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

	pluto.quests.current = quests

	hook.Run("PlutoUpdateQuests", quests)
end

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"

function PANEL:Init()
	BaseClass.Init(self)

	self.List = self:Add "DScrollPanel"
	self.List:Dock(FILL)

	for i = 1, 100 do
		local lbl = self.List:Add "DLabel"
		lbl:SetText "a"
		lbl:Dock(TOP)
	end

	self:DockPadding(16, 20, 16, 20)
end

function PANEL:SetTab()
end

vgui.Register("pluto_quest", PANEL, "pluto_inventory_base")