pluto.statuses = pluto.statuses or {}

hook.Add("TTTGetHiddenPlayerVariables", "pluto_limp", function(vars)
	table.insert(vars, {
		Name = "SlowedUntil",
		Type = "Float",
		Default = -math.huge,
		Enums = {}
	})
	table.insert(vars, {
		Name = "SlowedStart",
		Type = "Float",
		Default = -math.huge,
		Enums = {}
	})
end)

hook.Add("TTTUpdatePlayerSpeed", "pluto_limp", function(ply, data)
	local sloweduntil = ply:GetSlowedUntil()

	if (sloweduntil > CurTime() and ply:GetSlowedStart() < CurTime()) then
		data.FinalMultiplier = data.FinalMultiplier * 0.5
	end
end)

function pluto.statuses.limp(ply, time)
	if (not IsValid(ply) or not ply:IsPlayer()) then
		return
	end
	time = math.min(1.3, time * 3)

	local start = CurTime() + ply:Ping() * 4 / 1000
	ply:SetSlowedUntil(start + time)
	ply:SetSlowedStart(start)
end

print "JHEAKLDSA "