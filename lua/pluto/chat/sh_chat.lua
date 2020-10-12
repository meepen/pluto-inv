pluto.chat = pluto.chat or {}
pluto.chat.type = {}
pluto.chat.type.TEXT = 0
pluto.chat.type.COLOR = 1
pluto.chat.type.PLAYER = 2
pluto.chat.type.ITEM = 3
pluto.chat.type.CURRENCY = 4

hook.Add("PostGamemodeLoaded", "OverrideChatPrint", function()
	FindMetaTable "Player".ChatPrint = function(self, ...)
		print("CHATPRINT")
		local content = pluto.chat.determineTypes({...})
	
		if (SERVER) then
			pluto.inv.message(self)
				:write("chatmessage", content)
			:send()
		elseif (LocalPlayer() == self) then
			pluto.chat.Add(content, "server", false)
		end
	end
end)

pluto.chat.determineTypes = function(x)
	local content = {}
	for k,element in pairs (x) do
		if type(element) == "string" then
			table.insert(content, pluto.chat.type.TEXT)
			table.insert(content, element)
		elseif type(element) == "Color" or element["r"] ~= nil then
			table.insert(content, pluto.chat.type.COLOR)
			table.insert(content, element)
		elseif type(element) == "Player" then
			table.insert(content, pluto.chat.type.PLAYER)
			table.insert(content, element)
		elseif type(element) == "table" then
			if (element.Type ~= nil) then
				table.insert(content, pluto.chat.type.ITEM)
				table.insert(content, element)
			elseif (element.InternalName ~= nil) then
				table.insert(content, pluto.chat.type.CURRENCY)
				table.insert(content, element.InternalName)
			end
		end
	end

	return content
end