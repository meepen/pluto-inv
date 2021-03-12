pluto.chat = pluto.chat or {}
pluto.chat.type = {}
pluto.chat.type.TEXT = 0
pluto.chat.type.COLOR = 1
pluto.chat.type.PLAYER = 2
pluto.chat.type.ITEM = 3
pluto.chat.type.CURRENCY = 4
pluto.chat.type.IMAGE = 5
pluto.chat.type.NONE = 6

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

pluto.chat.images = {
	B1 = {
		Material = "pluto/emoji/b1.png",
		Size = Vector(30, 30)
	}
}

for name, emoji in pairs(pluto.chat.images) do
	if (SERVER) then
		resource.AddSingleFile("materials/" .. emoji.Material)
	end
	emoji.Name = name
	emoji.Type = "emoji"
	emoji.Material = Material(emoji.Material)
end

override()

hook.Add("PostGamemodeLoaded", "OverrideChatPrint", override)
