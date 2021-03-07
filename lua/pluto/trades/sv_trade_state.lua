pluto.trades = pluto.trades or {}

local opposites = setmetatable({
	inbound = "outbound",
	outbound = "inbound"
}, {
	__index = function(s, a)
		return a
	end
})

pluto.trades.active = pluto.trades.active or {}

pluto.trades.status = pluto.trades.status or setmetatable({
	-- [ply][oply] = "inbound" | "outbound" | "none" | "in progress"
}, {
	__index = function(self, ply)
		self[ply] = setmetatable({}, {
			__index = function(s, oply)
				if (oply == ply) then
					return "none"
				end

				if (rawget(self[oply], ply)) then
					return opposites[self[oply][ply]]
				end

				return "none"
			end,
			__newindex = function(s, oply, data)
				if (ply == oply) then
					return
				end

				if (rawget(self[oply], ply)) then
					self[oply][ply] = opposites[data]
					return
				end

				rawset(s, oply, data)
			end
		})
		return self[ply]
	end,
	__call = function(self, ply, oply, status)
		if (status) then
			self[ply][oply] = status
			pluto.trades.updatefor(ply, oply)
		else
			return self[ply][oply]
		end
	end
})

pluto.trades.mt = pluto.trades.mt or {
	__index = {}
}

local TRADE = pluto.trades.mt.__index

function TRADE:Set(who, what, index, data)
	local recv = self[who][what]
	if (recv.lookup and recv.lookup[data] and recv.lookup[data] ~= index) then
		-- TODO(meep): don't allow and send update
		return
	end

	local old = recv[index]
	if (recv.lookup and old) then
		recv.lookup[old] = nil
	end

	recv[index] = data
	if (recv.lookup and data) then
		recv.lookup[data] = index
	end

	pluto.inv.message(self[who].other)
		:write("tradeupdate", who, what, index, data)
		:send()

	if (self[who].accepted) then
		self:SetAccepted(who, false)
	end
	if (self[self[who].other].accepted) then
		self:SetAccepted(self[who].other, false)
	end

	self:AddSystemMessage(who:Nick() .. " changed " .. what .. " " .. index)

	return self
end

function TRADE:AddPlayerMessage(ply, msg)
	table.insert(self.messages, {sender = ply:SteamID64(), msg})

	pluto.inv.message(self.players)
		:write("trademessage", msg, ply)
		:send()
end

function TRADE:AddSystemMessage(msg)
	table.insert(self.messages, {msg})

	pluto.inv.message(self.players)
		:write("trademessage", msg)
		:send()
end

function TRADE:SetAccepted(cl, b)
	if (not b) then
		timer.Remove("trade_" .. tostring(self))
	end

	self[cl].accepted = b

	pluto.inv.message(self.players)
		:write("tradestatus", cl, b)
		:send()

	self:AddSystemMessage(cl:Nick() .. " " .. (b and "is ready to trade" or "is no longer ready to trade"))

	if (b and self[self[cl].other].accepted) then
		self:Commit()
	end
end

function TRADE:CreateSnapshot()
	local snap = {}

	for _, ply in pairs(self.players) do
		snap[ply:SteamID64()] = {
			item = {},
			currency = {},
			name = ply:Nick(),
		}
		
		for slot, item in pairs(self[ply].item) do
			if (type(slot) ~= "number") then
				continue
			end

			snap[ply:SteamID64()].item[slot] = util.JSONToTable(util.TableToJSON(item))
		end
		
		for slot, data in pairs(self[ply].currency) do
			if (type(slot) ~= "number") then
				continue
			end

			snap[ply:SteamID64()].currency[slot] = data
		end
	end

	snap.messages = self.messages

	return snap
end

function TRADE:Commit()
	local left = 5
	timer.Create("trade_" .. tostring(self), 1, left + 1, function()
		if (left == 0) then
			self:AddSystemMessage "Trade commenced"
			self:End()

			local snapshot = json.stringify(self:CreateSnapshot())

			pluto.db.transact(function(db)
				local dat, err = mysql_stmt_run(db, "INSERT INTO pluto_trades (version, snapshot, accepted) VALUES (1, ?, 1)", snapshot)
				if (not dat) then
					pluto.error("TRADE", err)
					mysql_rollback(db)
					for _, ply in pairs(self.players) do
						ply:ChatPrint "Failed adding to trade logs. Trade reversed."
					end
					return
				end

				local snap_id = dat.LAST_INSERT_ID

				for _, ply in pairs(self.players) do
					local oply = self[ply].other

					if (not mysql_stmt_run(db, "INSERT INTO pluto_trades_players (trade_id, player) VALUES (?, ?)", snap_id, ply:SteamID64())) then
						pluto.error("TRADE", "Couldn't save player ", ply, " to snapshot association. Rolling back.")
						mysql_rollback(db)
						return
					end

					for slot, data in pairs(self[ply].currency) do
						if (type(slot) ~= "number") then
							continue
						end

						if (not pluto.inv.addcurrency(db, ply, data.What, -data.Amount)) then
							mysql_rollback(db)
							return
						end

						if (not pluto.inv.addcurrency(db, oply, data.What, data.Amount)) then
							mysql_rollback(db)
							return
						end
					end

					local tab = pluto.inv.invs[oply].tabs.buffer

					for slot, item in pairs(self[ply].item) do
						if (type(slot) ~= "number") then
							continue
						end

						pluto.inv.pushbuffer(db, oply)
						pluto.inv.invs[ply][item.TabID].Items[item.TabIndex] = nil
						item.Owner = oply:SteamID64()
						if (not pluto.inv.setitemplacement(db, oply, item, tab.RowID, 1)) then
							for _, ply in pairs(self.players) do
								ply:ChatPrint "err"
							end
							return
						end

						if (not mysql_stmt_run(db, "INSERT INTO pluto_trades_items (trade_id, item_id) VALUES (?, ?)", snap_id, item.RowID)) then
							pluto.error("TRADE", "Couldn't save item ", item, " to snapshot association. Rolling back.")
							mysql_rollback(db)
							return
						end

						pluto.inv.notifybufferitem(oply, item)

						pluto.inv.message(self.players)
							:write("item", item)
							:send()
					end
				end

				mysql_commit(db)
			end)
	
		else
			self:AddSystemMessage("Trade will commence in " .. left .. " seconds...")
		end
		left = left - 1
	end)
end

function TRADE:End()
	self:AddSystemMessage("-- trade ended --")
	timer.Remove("trade_" .. tostring(self))
	pluto.trades.status(self.players[1], self.players[2], "none")
	pluto.trades.active[self.players[1]] = nil
	pluto.trades.active[self.players[2]] = nil
end

function pluto.trades.updatefor(ply, oply)
	pluto.inv.message(oply)
		:write("traderequestinfo", ply)
		:send()
	pluto.inv.message(ply)
		:write("traderequestinfo", oply)
		:send()
end

function pluto.trades.start(ply, oply)
	for _, ply2 in pairs(player.GetAll()) do
		if (ply2 == ply or ply2 == oply) then
			continue
		end

		if (pluto.trades.status(ply, ply2) == "outbound") then
			pluto.trades.status(ply, ply2, "none")
		end
		if (pluto.trades.status(oply, ply2) == "outbound") then
			pluto.trades.status(oply, ply2, "none")
		end
	end

	local tradedata = setmetatable({
		[ply] = {
			item = {
				lookup = {},
			},
			currency = {
				lookup = {},
			},
			other = oply,
		},
		[oply] = {
			item = {
				lookup = {},
			},
			currency = {
				lookup = {},
			},
			other = ply,
		},
		messages = {},
		players = {ply, oply},
	}, pluto.trades.mt)

	pluto.trades.active[ply] = {
		other = oply,
		data = tradedata
	}

	pluto.trades.active[oply] = {
		other = ply,
		data = tradedata
	}

	pluto.trades.status(ply, oply, "in progress")
end

function pluto.inv.readrequesttrade(ply)
	local oply = net.ReadEntity()
	if (not IsValid(oply) or not oply:IsPlayer()) then
		return
	end

	local trade = pluto.trades.active[ply]
	if (trade) then
		trade.data:End()
	end

	local status = pluto.trades.status(ply, oply)
	if (status == "in progress") then
		return
	end
	
	if (oply:IsBot() and status == "outbound") then
		ply, oply, status = oply, ply, "inbound"
	end

	if (status == "none") then
		pluto.trades.status(ply, oply, "outbound")
		oply:ChatPrint(ttt.roles.Traitor.Color, ply:Nick(), white_text, " has requested a trade with you.")
	elseif (status == "inbound") then
		pluto.trades.start(ply, oply)
	end
end

function pluto.inv.readtradeupdate(ply)
	local what = net.ReadString()
	local index = net.ReadUInt(8)

	local data
	if (what == "currency") then
		if (index == 0 or index > 3) then
			return
		end

		if (net.ReadBool()) then
			data = {}
			data.What = net.ReadString()
			data.Amount = net.ReadUInt(32)
		end

	elseif (what == "item") then
		if (index == 0 or index > 9) then
			return
		end

		if (net.ReadBool()) then
			data = pluto.itemids[net.ReadUInt(32)]
			if (data and data.Owner ~= ply:SteamID64()) then
				ply:ChatPrint "YOU DON'T OWN THAT ITEM!!! REEEE"
				pluto.inv.message(ply)
					:write("tradeupdate", ply, what, index, nil)
					:send()
				return
			end

			if (data.Untradeable == 1) then
				ply:ChatPrint "UNTRADEABLE"
				pluto.inv.message(ply)
					:write("tradeupdate", ply, what, index, nil)
					:send()
			end
		end
	else
		return
	end

	local trade = pluto.trades.active[ply]
	if (not trade) then
		ply:ChatPrint "You have no active trade!!1"
		return
	end

	trade.data:Set(ply, what, index, data)
end

function pluto.inv.readtradestatus(cl)
	local status = net.ReadBool()

	local active = pluto.trades.active[cl]
	if (not active) then
		return
	end

	active.data:SetAccepted(cl, status)
end