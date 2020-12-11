pluto.divine = pluto.divine or {}


local options = {
	brainegg = {
		Shares = 100,
		Amount = {4, 10},
		Ratio = {900, 1100},
	},
	crate1 = {
		Shares = 100,
		Amount = {4, 10},
		Ratio = {900, 1100},
	},
	mirror = {
		Shares = 1,
		Amount = {1, 2},
		Ratio = {20000, 30000},
	},
	crate3 = {
		Shares = 10,
		Amount = {1, 2},
		Ratio = {8000, 9000},
	},
	crate3_n = {
		Shares = 80,
		Amount = {4, 10},
		Ratio = {900, 1100},
	}
}

local function generate()
	local currency, data = pluto.inv.roll(options)
	options[currency] = nil

	return {
		Currency = currency,
		Ratio = math.random(data.Ratio[1], data.Ratio[2]),
		Amount = math.random(data.Amount[1], data.Amount[2]),
	}
end

pluto.divine.currency_exchange = pluto.divine.currency_exchange or {
	Offers = {
		generate(),
		generate(),
	}
}

function pluto.divine.currency_exchange.update()
	for i, offer in ipairs(pluto.divine.currency_exchange.Offers) do
		SetGlobalInt("pluto_currency_exchange.Ratio:" .. i, offer.Ratio)
		SetGlobalInt("pluto_currency_exchange.Amount:" .. i, offer.Amount)
		SetGlobalString("pluto_currency_exchange.Currency:" .. i, offer.Currency)
	end
end

function pluto.divine.currency_exchange.lookup()
	local r = {}
	for _, offer in ipairs(pluto.divine.currency_exchange.Offers) do
		r[offer.Currency] = offer
	end

	return r
end

pluto.divine.currency_exchange.update()

function pluto.inv.readexchangestardust(cl)
	local forwhat = net.ReadString()
	local howmany = net.ReadUInt(32)

	local lookup = pluto.divine.currency_exchange.lookup()

	local curr = pluto.currency.byname[forwhat]
	if (howmany == 0 or not curr or not (curr.StardustRatio or lookup[forwhat])) then
		return
	end

	local ratio = curr.StardustRatio or lookup[forwhat].Ratio

	if (lookup[forwhat] and lookup[forwhat].Amount > howmany) then
		return
	end

	local function revert()
		lookup[forwhat].Amount = lookup[forwhat].Amount + howmany
		pluto.divine.currency_exchange.update()
	end
	lookup[forwhat].Amount = lookup[forwhat].Amount - howmany
	pluto.divine.currency_exchange.update()

	pluto.db.transact(function(db)
		if (not pluto.inv.addcurrency(db, cl, "stardust", math.ceil(-howmany * ratio))) then
			revert()
			mysql_rollback(db)
			return
		end

		if (not pluto.inv.addcurrency(db, cl, forwhat, math.ceil(howmany))) then
			revert()
			mysql_rollback(db)
			return
		end

		mysql_commit(db)
		cl:ChatPrint("You traded " .. (math.ceil(howmany * ratio)) .. " ", pluto.currency.byname.stardust, " for " .. howmany .. " ", pluto.currency.byname[forwhat])
	end)
end