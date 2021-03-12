local MAX_LENGTH = 192

function pluto.chat.Send(ply, ...)
	local args = {...}

	pluto.inv.message(ply)
		:write("chatmessage", args)
	:send()
end

-- override PlayerSay
for idx, name in pairs(debug.getregistry()[3]) do
	if (name == "PlayerSay") then
		debug.getregistry()[3][idx] = "RealPlayerSay"
	end
end

local function GetLoadoutItem(ply, i)
	local item = pluto.itemids[tonumber(ply:GetInfo("pluto_loadout_slot" .. i, nil))]
	if (item and item.Owner == ply:SteamID64()) then
		return item
	end
end

local function GetCosmeticItem(ply, i)
	local item = pluto.itemids[tonumber(ply:GetInfo("pluto_cosmetic_slot" .. i, nil))]
	if (item and item.Owner == ply:SteamID64()) then
		return item
	end
end

hook.Add("RealPlayerSay", "pluto_chat", function(from, texts, teamchat)
	print((teamchat and "[TEAM]" or "") .. from:Nick() .. ": " .. texts)
	local content = {
		from,
	}

	if (texts:StartWith "//") then
		texts = texts:sub(3):Trim()
	end
	local replace = hook.Run("PlayerSay", from, texts, teamchat)

	if replace == "" or not replace then return "" end

	local last_pos = 1
	local length = 0

	for pos, match, next_pos in replace:gmatch "(){([^%}]+)}()" do
		if (pos ~= last_pos) then
			if (length + pos - last_pos > MAX_LENGTH) then
				table.insert(content, replace:sub(last_pos, last_pos + MAX_LENGTH - length))
				break
			end
			length = length + last_pos - pos
			table.insert(content, replace:sub(last_pos, pos - 1))
		end

		local what, id = match:match "^([^:]+):(.+)$"

		local done = false

		local item

		if (what == "item") then
			local slot = pluto.itemids[tonumber(id)]
			if (slot and slot.Owner == from:SteamID64()) then
				item = slot
			end
		elseif (match == "primary") then
			item = GetLoadoutItem(from, 1)
		elseif (match == "secondary") then
			item = GetLoadoutItem(from, 2)
		elseif (match == "model") then
			item = GetCosmeticItem(from, 1)
		elseif (match == "melee") then
			item = GetLoadoutItem(from, 3)
		elseif (match == "grenade") then
			item = GetLoadoutItem(from, 4)
		elseif (match == "other" or match == "holster") then
			item = GetLoadoutItem(from, 6)
		elseif (match == "pickup") then
			item = GetLoadoutItem(from, 5)
		elseif (match == "loadout") then
			
			local items = {}
			for i = 1, 6 do
				local item = GetLoadoutItem(from, i)
				if (item) then
					table.insert(items, item)
				end
			end
			for i = 1, 6 do
				local item = GetCosmeticItem(from, i)
				if (item) then
					table.insert(items, item)
				end
			end

			for _, slot in ipairs(items) do
				table.insert(content, slot)
				table.insert(content, " ")
				length = length + slot:GetPrintName():len() + 1
			end

			done = true
		end

		if (item) then
			table.insert(content, item)
			length = length + item:GetPrintName():len()
			done = true
		end

		if (not done) then
			table.insert(content, "{" .. match .. "}")
		end

		last_pos = next_pos

		if (length > MAX_LENGTH) then
			break
		end
	end

	if (pos ~= #replace) then
		table.insert(content, replace:sub(last_pos, last_pos + math.max(0, MAX_LENGTH - length)))
	end

	for i = #content, 1, -1 do
		if (not isstring(content[i])) then
			continue
		end

		local split = content[i]:Split ":"
		
		local new = {}

		for x = #split - 1, 2, -2 do
			local emoji = split[x]

			local override_size
			if (pluto.cancheat(from)) then
				local e, w, h = emoji:match "([^;]+);(%d+)x(%d+)"
				if (e) then
					emoji = e
					override_size = Vector(w, h)
				end
			end

			if (not pluto.chat.images[emoji]) then
				continue
			end

			content[i] = table.concat(split, ":", 1, x - 1)
			table.insert(content, i + 1, table.concat(split, ":", x + 1))
			for y = x, #split do
				split[y] = nil
			end
			local data = pluto.chat.images[emoji]
			if (override_size) then
				data = table.Copy(data)
				data.Size = override_size
			end
			table.insert(content, i + 1, data)
		end
	end

	if (hook.Run("OnPlayerSay", from, content)) then
		return ""
	end

	for _,ply in pairs(player.GetAll()) do
		local canSee = hook.Run("PlayerCanSeePlayersChat", texts, teamchat, ply, from)
		if canSee then
			pluto.inv.message(ply)
				:write("chatmessage", content, "Server", teamchat)
			:send()
		end
	end

	return ""
end)

function pluto.inv.readchat(from)
	local teamchat = net.ReadBool()
	local texts = net.ReadString():gsub("[\r\n]", "")

	timer.Simple(0, function()
		hook.Run("RealPlayerSay", from, texts, teamchat)
	end)
end

function pluto.inv.writechatmessage(ply, content, channel, teamchat)
	channel = channel or "Server"

	net.WriteBool(teamchat)
	net.WriteString(channel)

	for _, data in ipairs(content) do
		local tpid = TypeID(data)

		if (tpid == TYPE_ENTITY) then
			net.WriteUInt(pluto.chat.type.PLAYER, 4)
			net.WriteEntity(data)
		elseif (IsColor(data)) then
			net.WriteUInt(pluto.chat.type.COLOR, 4)
			net.WriteColor(data)
		elseif (tpid == TYPE_STRING) then
			net.WriteUInt(pluto.chat.type.TEXT, 4)
			net.WriteString(data)
		elseif (tpid == TYPE_TABLE) then
			if (pluto.iscurrency(data)) then
				net.WriteUInt(pluto.chat.type.CURRENCY, 4)
				net.WriteString(data.InternalName)
			elseif (pluto.isitem(data)) then
				if (not data.RowID) then
					net.WriteUInt(pluto.chat.type.COLOR, 4)
					net.WriteColor(data:GetColor())
					net.WriteUInt(pluto.chat.type.TEXT, 4)
					net.WriteString(data:GetPrintName())
				else
					net.WriteUInt(pluto.chat.type.ITEM, 4)
					pluto.inv.writeitem(ply, data)
				end
			elseif (data.Type == "emoji") then
				net.WriteUInt(pluto.chat.type.IMAGE, 4)
				net.WriteString(data.Name)
				net.WriteUInt(data.Size.x, 8)
				net.WriteUInt(data.Size.y, 8)
			else
				net.WriteUInt(pluto.chat.type.TEXT, 4)
				net.WriteString(tostring(data))
			end
		else
			net.WriteUInt(pluto.chat.type.TEXT, 4)
			net.WriteString(tostring(data))
		end
	end
	net.WriteUInt(pluto.chat.type.NONE, 4)
end

function pluto.inv.readchatopen(cl)
	local opened = net.ReadBool()
	if (not opened) then
		cl:StopAnimation()
	else
		cl:StartAnimation(ACT_GMOD_IN_CHAT)
	end
end