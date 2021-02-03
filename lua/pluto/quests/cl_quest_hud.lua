
local function paintquest(x, y, _x, quest)
	draw.SimpleTextOutlined(quest.Name .. ":", "pluto_quest_hud", x, y, quest.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
	surface.SetDrawColor(color_grey)
	surface.DrawRect(_x, y, 150, 20)
	surface.SetDrawColor(quest.Color)
	surface.DrawRect(_x, y, Lerp((quest.TotalProgress - quest.ProgressLeft) / quest.TotalProgress, 0, 150), 20)
	surface.SetDrawColor(color_black)
	surface.DrawOutlinedRect(_x, y, 150, 20, 1)
end

hook.Add("HUDPaint", "pluto_quest_hud", function()
	if (not pluto or not pluto.quests or not pluto.quests.current) then
		return
	end

	if (not GetConVar "pluto_quest_hud":GetBool()) then
		return 
	end

	local y = ScrH() - 25
	local x = math.max(450, ScrW()/4) + 50
	local _x = x
	surface.SetFont "pluto_quest_hud"

	local topaint = {}
	topaint.unique = {}
	topaint.hourly = {}
	topaint.daily = {}
	topaint.weekly = {}

	for k, quest in ipairs(pluto.quests.current) do
		_x = math.max(_x, x + surface.GetTextSize(quest.Name) + 10)

		if (not GetConVar "pluto_inactive_quests":GetBool() and (quest.ProgressLeft <= 0 or quest.EndTime < CurTime())) then
			continue
		end

		table.insert(topaint[quest.Tier], quest)
	end

	for k, quest in ipairs(topaint.weekly) do
		paintquest(x, y, _x, quest)
		y = y - 25
	end
	for k, quest in ipairs(topaint.daily) do
		paintquest(x, y, _x, quest)
		y = y - 25
	end
	for k, quest in ipairs(topaint.hourly) do
		paintquest(x, y, _x, quest)
		y = y - 25
	end
	for k, quest in ipairs(topaint.unique) do
		paintquest(x, y, _x, quest)
		y = y - 25
	end
end)