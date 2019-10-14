MOD.Type = "suffix"
MOD.Name = "Orbital Strikes"
MOD.Tags = {
	"damage", "aoe", "explosive",
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return class.Primary and class.Primary.Ammo == "357"
end

function MOD:GetDescription(rolls)
	return string.format("%.02f%% of your shots will fire a rocket", rolls[1])
end

MOD.Tiers = {
	{ 0.25, 0.3 },
	{ 0.15, 0.25 },
	{ 0.05, 0.15 },
}

return MOD