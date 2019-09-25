local MOD = {}
MOD.Type = "suffix"
MOD.Name = "Toxicity"
MOD.Tags = {
	"damage", "poison", "dot"
}
MOD.ModType = "dot"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	return string.format("Converts %.01f%% of your damage and amplifies it by %.01f%% to Poison on hit", rolls[1], rolls[2])
end

MOD.Tiers = {
	{ 25, 33, 50, 75 },
	{ 10, 25, 50, 75 },
	{ 5,  10, 50, 75 },
}

MOD.Hooks = {
}

function MOD.Hooks:Ass(wep, mod1, ...)
end

return MOD