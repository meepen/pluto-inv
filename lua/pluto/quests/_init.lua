--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
pluto.quests = pluto.quests or {}
pluto.quests.current = pluto.quests.current or {}
pluto.quests.loading = pluto.quests.loading or {}
pluto.quests.byname = pluto.quests.byname or {}

pluto.addmodule("QUEST", Color(124, 203, 54))

for _, id in pairs {
	"april_fools",
	"light1",
	"light2",
	"light3",
	"cheer1",
	"cheer2",

	"melee",
	"nojump",
	"oneshot",
	"traitors",
	"floor",
	"wepswitch",
	"nomove",
	"winstreak",
	"killstreak",

	"nodamage",
	"credits",
	"pcrime",
	"crusher",
	"healthgain",
	"lowhealth",

	"dnatrack",
	"fourcraft",
	"sacrifices",
	--"burn",
	"postround",
	"minis",
	"identify",
	"cubanpete",

	"halloween_nade",
} do
	QUEST = pluto.quests.byname[id] or {}
	table.Empty(QUEST)
	pluto.quests.byname[id] = QUEST

	QUEST.ID = id
	QUEST.Name = id
	include("list/" .. id .. ".lua")
	QUEST = nil
end