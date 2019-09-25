local MOD = {}
MOD.Type = "suffix"
MOD.Name = "Flame"
MOD.Tags = {
	"damage", "fire", "dot"
}
MOD.ModType = "dot"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	local roll = rolls[1]
	return string.format("Converts %.01f%% of your damage to Fire on hit", roll)
end

MOD.Tiers = {
	{ 25, 33 },
	{ 10, 25 },
	{ 5,  10 },
}

MOD.Hooks = {}

function MOD.Hooks:Ass(wep, mod1, ...)
end

return MOD