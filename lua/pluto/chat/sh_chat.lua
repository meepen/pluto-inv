pluto.chat = pluto.chat or {}
pluto.chat.type = {}
pluto.chat.type.TEXT = 0
pluto.chat.type.COLOR = 1
pluto.chat.type.PLAYER = 2
pluto.chat.type.ITEM = 3
pluto.chat.type.CURRENCY = 4
pluto.chat.type.NONE = 5

pluto.chat.channels = {
	{
		Name = "Server",
		Prefix = "//"
	},
	{
		Name = "Admin",
		Prefix = "@",
		Relay = {
			"Server",
		}
	},
	{
		Name = "Cross",
		Prefix = "#",
	},
	byname = {}
}

for _, channel in ipairs(pluto.chat.channels) do
	pluto.chat.channels.byname[channel.Name] = channel
end

local function override()
	FindMetaTable "Player".ChatPrint = function(self, ...)
		if (SERVER) then
			pluto.inv.message(self)
				:write("chatmessage", {...})
				:send()
		elseif (LocalPlayer() == self) then
			pluto.chat.Add(content, "Server", false)
		end
	end
end

override()

hook.Add("PostGamemodeLoaded", "OverrideChatPrint", override)
