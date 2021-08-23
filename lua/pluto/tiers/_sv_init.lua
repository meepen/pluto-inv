--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local share_count = {
	common = 50000,
	confused = 1000,
	junk = 600000,
	otherworldly = 500,
	shadowy = 750,
	uncommon = 10000,
	vintage = 300000,
	unstable = 100,
	powerful = 10000,
	stable = 7000,
	mystical = 1000,
}

for _, typelist in pairs(pluto.tiers.bytype) do
	typelist.shares = 0
end

for name, tier in pairs(pluto.tiers.byname) do
	tier.Shares = share_count[name] or 0

	local typelist = pluto.tiers.bytype[tier.Type or "Weapon"]

	typelist.shares = typelist.shares + tier.Shares
end