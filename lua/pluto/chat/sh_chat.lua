pluto.chat = pluto.chat or {}
pluto.chat.type = {}
pluto.chat.type.TEXT = 0
pluto.chat.type.COLOR = 1
pluto.chat.type.PLAYER = 2
pluto.chat.type.ITEM = 3
pluto.chat.type.CURRENCY = 4

local function override()
	
	FindMetaTable "Player".ChatPrint = function(self, ...)
		if (SERVER) then
			pluto.inv.message(self)
				:write("chatmessage", {...})
				:send()
		elseif (LocalPlayer() == self) then
			pluto.chat.Add(content, "server", false)
		end
	end
end

override()

hook.Add("PostGamemodeLoaded", "OverrideChatPrint", override)
