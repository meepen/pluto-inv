--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
pluto.divine = pluto.divine or {}
pluto.divine.stardust_shop = pluto.divine.stardust_shop or {}

function pluto.inv.readstardustshop()
	pluto.divine.stardust_shop = {}
	for i = 1, net.ReadUInt(32) do
		local item = {}
		pluto.inv.readbaseitem(item)
		local price = net.ReadUInt(32)
		local endtime = net.ReadUInt(32)
		pluto.divine.stardust_shop[i] = {
			ID = i,
			Item = setmetatable(item, pluto.inv.item_mt),
			Price = price,
			EndTime = endtime + os.time(),
		}
	end

	hook.Run("ReceiveStardustShop", pluto.divine.stardust_shop)
end

surface.CreateFont("headline_font", {
	font = "Permanent Marker",
	size = 48,
	antialias = true,
	weight = 500
})
