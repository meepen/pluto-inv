MOD.Type = "suffix"
MOD.Name = "Greed"
MOD.Tags = {
	"greed"
}

function MOD:IsNegative(roll)
	return false
end

function MOD:CanRollOn(class)
	return true
end

function MOD:FormatModifier(index, roll)
	return string.format("%.2f", roll)
end

-- 39.37 units = 1 meter
MOD.Description = "[Limited] After a rightful kill, will show currencies within %s meters for %s seconds"

MOD.Tiers = {
	{ 10, 20, 5, 10 },
	{ 5, 10, 5, 10 },
	{ 2, 5, 5, 10 },
}

function MOD:OnKill(wep, rolls, atk, vic)
	if (atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
		pluto.statuses.greed(atk, rolls[1] * 39.37, rolls[2])
	end
end

return MOD