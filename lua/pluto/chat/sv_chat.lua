FindMetaTable "Player".ChatPrint = function(self, ...)
	local content = pluto.chat.determineTypes({...})

	pluto.inv.message(self)
		:write("chatmessage", content)
	:send()
end

function pluto.chat.Send(ply, ...)
	local args = {...}

	pluto.inv.message(ply)
		:write("chatmessage", args)
	:send()
end

function pluto.inv.readchat(from)
	local size = net.ReadUInt(8)
	local teamchat = net.ReadBool()
	local texts = ""
	local content = {
		pluto.chat.type.PLAYER,
		from,
	}

	for i = 1, size do
		local data
		local ctype = net.ReadUInt(2)

		if ctype == pluto.chat.type.TEXT then
			table.insert(content, pluto.chat.type.TEXT)
			data = net.ReadString()
			-- DO TEXT REPLACEMENT HERE
			texts = texts .. data
		elseif ctype == pluto.chat.type.COLOR then
			table.insert(content, pluto.chat.type.COLOR)
			data = net.ReadColor()
		elseif ctype == pluto.chat.type.PLAYER then
			table.insert(content, pluto.chat.type.PLAYER)
			data = net.ReadEntity()
		elseif ctype == pluto.chat.type.ITEM then
			local id = net.ReadUInt(32)
			
			local item = pluto.itemids[id]

			if item then
				table.insert(content, pluto.chat.type.ITEM)
				data = item
			else
				table.insert(content, pluto.chat.type.TEXT)
				data = "[UNKNOWN ITEM]"
			end
		end

		table.insert(content, data)
	end

	local replace = hook.Run("PlayerSay", from, texts, teamchat)

	if replace == "" or not replace then return end

	print("replace", replace)

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
	print(content)
	PrintTable(content)
	net.WriteUInt(#content/2, 8)
	net.WriteBool(teamchat)
	net.WriteString(channel)
	for i = 1, #content, 2 do
		local ctype = content[i]
		data = content[i+1]

		net.WriteUInt(ctype, 2)

		if (ctype == pluto.chat.type.TEXT) then
			net.WriteString(data)
		elseif (ctype == pluto.chat.type.COLOR) then
			net.WriteColor(data)
		elseif (ctype == pluto.chat.type.PLAYER) then
			net.WriteEntity(data)
		elseif (ctype == pluto.chat.type.ITEM) then
			pluto.inv.writeitem(ply, data)
		end
	end
end