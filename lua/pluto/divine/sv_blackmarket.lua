local CURR = pluto.currency.byname.tp
local options = {
	-- NEVER REMOVE ITEMS, SET SHARES TO 0
	{
		Shares = 1,
		Price = 485,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "weapon_neszapper",
			Tier = pluto.tiers.byname.legendary,
		}, pluto.inv.item_mt)
	},
	{
		Shares = 1,
		Price = 505,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "weapon_raygun",
			Tier = pluto.tiers.byname.legendary,
		}, pluto.inv.item_mt)
	},
	{
		Shares = 1,
		Price = 520,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "weapon_ttt_deagle_gold",
			Tier = pluto.tiers.byname.unique,
		}, pluto.inv.item_mt)
	},
	{
		Shares = 1,
		Price = 500,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "tfa_cso_elvenranger",
			Tier = pluto.tiers.byname.legendary,
		}, pluto.inv.item_mt)
	},
	{
		Shares = 1,
		Price = 498,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "weapon_lightsaber_rainbow",
			Tier = pluto.tiers.byname.unique,
		}, pluto.inv.item_mt)
	},
	{
		Shares = 1,
		Price = 450,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "weapon_cbox",
			Tier = pluto.tiers.byname.unique,
		}, pluto.inv.item_mt)
	},
	{
		Shares = 1,
		Price = 350,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "weapon_lightsaber_rb",
			Tier = pluto.tiers.byname.unique,
		}, pluto.inv.item_mt)
	},
	{
		Shares = 1,
		Price = 350,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "weapon_lightsaber_rb",
			Tier = pluto.tiers.byname.unique,
		}, pluto.inv.item_mt)
	},
	{
		Shares = 1,
		Price = 365,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "tfa_cso_skull1",
			Tier = pluto.tiers.byname.legendary,
		}, pluto.inv.item_mt)
	},
	{
		Shares = 1,
		Price = 385,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "tfa_cso_skull5",
			Tier = pluto.tiers.byname.legendary,
		}, pluto.inv.item_mt)
	},
	{
		Shares = 1,
		Price = 435,
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "tfa_cso_skull9",
			Tier = pluto.tiers.byname.unique,
		}, pluto.inv.item_mt)
	},
}

pluto.divine = pluto.divine or {}
pluto.divine.blackmarket = pluto.divine.blackmarket or {}

hook.Add("Initialize", "pluto_blackmarket", function()
	pluto.db.transact(function(db)
		local offers = {}
		mysql_query(db, "LOCK TABLES pluto_blackmarket WRITE")
		mysql_query(db, "SET @date = date(convert_tz(now(),@@session.time_zone,'-1:00'))") -- updates at 9 pm EST
		local data = mysql_query(db, "SELECT idx, IF(@date = `date`, 1, 0) as is_active, what, sold FROM pluto_blackmarket")
		for _, data in ipairs(data) do
			if (data.is_active == 0) then
				data.what = pluto.inv.roll(options)
				data.sold = 0
				mysql_stmt_run(db, "UPDATE pluto_blackmarket SET `date` = @date, what = ?, sold = 0 WHERE idx = ?", data.what, data.idx)
			end

			if (data.sold == 0) then
				offers[data.idx] = data.what
			end
		end
		mysql_query(db, "UNLOCK TABLES")

		pluto.divine.blackmarket.next = os.time() + mysql_query(db, "SELECT TIMESTAMPDIFF(SECOND, CURRENT_TIMESTAMP, TIMESTAMP(@date) + interval 1 day) as remaining;")[1].remaining

		pluto.divine.blackmarket.offers = offers
	end)
end)

concommand.Add("pluto_send_blackmarket", function(p)
	pluto.inv.message(p)
		:write "blackmarket"
		:send()
end)

concommand.Add("pluto_blackmarket_buy_offer", function(p, cmd, args)
	local idx = tonumber(args[1])
	local offerid = pluto.divine.blackmarket.offers[idx]
	local what = options[offerid]
	if (not what) then
		p:ChatPrint "No offer exists."
		return
	end

	if (what.Item.ClassName ~= args[2]) then
		p:ChatPrint "No offer exists. Sorry."
		return
	end

	local item = what.Item:Duplicate()
	item.CreationMethod = "BOUGHT"
	pluto.db.transact(function(db)
		if (not pluto.inv.addcurrency(db, p, CURR.InternalName, -what.Price)) then
			p:ChatPrint("You do not have enough ", CURR, " to buy that.")
			mysql_rollback(db)
			return
		end
		local succ = mysql_stmt_run(db, "UPDATE pluto_blackmarket SET sold = sold + 1 WHERE idx = ? AND sold = 0", idx)
		if (not succ or succ.AFFECTED_ROWS ~= 1) then
			p:ChatPrint "Sorry, that offer is gone!"
			mysql_rollback(db)
			return
		end
		pluto.divine.blackmarket.offers[idx] = nil

		pluto.inv.savebufferitem(db, p, item)
		
		p:ChatPrint("You have bought ", item, " for " .. what.Price .. " ", CURR)
		mysql_commit(db)
	end)
end)

concommand.Add("pluto_blackmarket_buy", function(p, cmd, args)
	local num = tonumber(args[1])

	if (num == 1) then
		pluto.db.transact(function(db)
			if (not pluto.inv.addcurrency(db, p, CURR.InternalName, -195)) then
				p:ChatPrint("You do not have enough ", CURR, " to buy that.")
				mysql_rollback(db)
				return
			end
			pluto.inv.addcurrency(db, p, "potato", 1)
			p:ChatPrint("You bought a ", pluto.currency.byname.potato, " for 195 ", CURR)
			mysql_commit(db)
		end)
	elseif (num == 2) then
		pluto.db.transact(function(db)
			if (not pluto.inv.addcurrency(db, p, CURR.InternalName, -10)) then
				p:ChatPrint("You do not have enough ", CURR, " to buy that.")
				mysql_rollback(db)
				return
			end
			local item = pluto.inv.generatebuffershard(db, p, "BOUGHT", (table.Random(pluto.tiers.filter_real("Weapon", function(tier) return tier.affixes >= 5 end))).InternalName)
			p:ChatPrint("You bought a ", item, " for 10 ", CURR)
			mysql_commit(db)
		end)

	else
		p:ChatPrint "unknown buy"
	end
end)

function pluto.inv.writeblackmarket(cl)
	net.WriteUInt(math.max(0, pluto.divine.blackmarket.next - os.time()), 32)
	for id, offer in pairs(pluto.divine.blackmarket.offers) do
		local what = options[offer]
		net.WriteUInt(id, 8)
		net.WriteUInt(what.Price, 32)
		pluto.inv.writebaseitem(cl, what.Item)
	end
	net.WriteUInt(0, 8)
end