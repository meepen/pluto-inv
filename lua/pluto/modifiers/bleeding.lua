local MOD = {}
MOD.Type = "suffix"
MOD.Name = "Bleeding"
MOD.Tags = {
	"damage", "bleed", "dot"
}
MOD.ModType = "dot"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	return string.format("Converts %.01f%% of your damage to Bleed on hit", rolls[1])
end

MOD.Tiers = {
	{ 25, 33 },
	{ 10, 25 },
	{ 5,  10 },
}

MOD.Hooks = {
}

function MOD.Hooks:Ass(wep, mod1, ...)
end

return MOD