function pluto.chat.Send(ply, ...)
	local args = {...}

	pluto.inv.message(ply)
		:write("chatmessage", args)
	:send()
end

function pluto.inv.readchat(from)
	local teamchat = net.ReadBool()
	local texts = net.ReadString():sub(1, 256)
	local content = {
		from,
	}

	local replace = hook.Run("PlayerSay", from, texts, teamchat)

	if replace == "" or not replace then return end

	local last_pos = 1

	for pos, match, next_pos in replace:gmatch "(){([^%}]+)}()" do
		if (pos ~= last_pos) then
			table.insert(content, replace:sub(last_pos, pos - 1))
		end

		local what, id = match:match "^([^:]+):(.+)$"

		local done = false

		if (what == "item") then
			local item = pluto.itemids[tonumber(id)]
			if (item and item.Owner == from:SteamID64()) then
				table.insert(content, item)
				done = true
			end
		elseif (match == "primary") then
			local eq = pluto.inv.invs[from].tabs.equip

			local slot = eq.Items[1]
			table.insert(content, slot)
			done = true
		elseif (match == "secondary") then
			local eq = pluto.inv.invs[from].tabs.equip

			local slot = eq.Items[2]
			table.insert(content, slot)
			done = true
		elseif (match == "model") then
			local eq = pluto.inv.invs[from].tabs.equip

			local slot = eq.Items[3]
			table.insert(content, slot)
			done = true
		elseif (match == "melee") then
			local eq = pluto.inv.invs[from].tabs.equip

			local slot = eq.Items[4]
			table.insert(content, slot)
			done = true
		elseif (match == "grenade") then
			local eq = pluto.inv.invs[from].tabs.equip

			local slot = eq.Items[5]
			table.insert(content, slot)
			done = true
		elseif (match == "other" or match == "holster") then
			local eq = pluto.inv.invs[from].tabs.equip

			local slot = eq.Items[6]
			table.insert(content, slot)
			done = true
		elseif (match == "pickup") then
			local eq = pluto.inv.invs[from].tabs.equip

			local slot = eq.Items[7]
			table.insert(content, slot)
			done = true
		elseif (match == "loadout") then
			
			local eq = pluto.inv.invs[from].tabs.equip

			for i = 1, 14 do
				local slot = eq.Items[i]
				
				if (slot) then
					table.insert(content, slot)
					table.insert(content, " ")
				end
			end

			done = true
		end

		if (not done) then
			table.insert(content, "{" .. match .. "}")
		end

		last_pos = next_pos
	end

	if (pos ~= #replace) then
		table.insert(content, replace:sub(last_pos))
	end

	for _,ply in pairs(player.GetAll()) do
		local canSee = hook.Run("PlayerCanSeePlayersChat", texts, teamchat, ply, from)
		if canSee then
			pluto.inv.message(ply)
				:write("chatmessage", content, "server", teamchat)
			:send()
		end
	end
end

function pluto.inv.writechatmessage(ply, content, channel, teamchat)
	channel = channel or "server"

	net.WriteUInt(#content, 8)
	net.WriteBool(teamchat)
	net.WriteString(channel)

	for _, data in ipairs(content) do
		local tpid = TypeID(data)

		if (tpid == TYPE_ENTITY) then
			net.WriteUInt(pluto.chat.type.PLAYER, 3)
			net.WriteEntity(data)
		elseif (IsColor(data)) then
			net.WriteUInt(pluto.chat.type.COLOR, 3)
			net.WriteColor(data)
		elseif (tpid == TYPE_STRING) then
			net.WriteUInt(pluto.chat.type.TEXT, 3)
			net.WriteString(data)
		elseif (tpid == TYPE_TABLE) then
			if (pluto.iscurrency(data)) then
				net.WriteUInt(pluto.chat.type.CURRENCY, 3)
				net.WriteString(data.InternalName)
			elseif (pluto.isitem(data)) then
				if (not data.RowID) then
					net.WriteUInt(pluto.chat.type.COLOR, 3)
					net.WriteColor(data.Tier.Color)
					net.WriteUInt(pluto.chat.type.TEXT, 3)
					net.WriteString(data:GetPrintName())
				else
					net.WriteUInt(pluto.chat.type.ITEM, 3)
					pluto.inv.writeitem(ply, data)
				end
			else
				net.WriteUInt(pluto.chat.type.TEXT, 3)
				net.WriteString(tostring(data))
			end
		else
			net.WriteUInt(pluto.chat.type.TEXT, 3)
			net.WriteString(tostring(data))
		end
	end
end