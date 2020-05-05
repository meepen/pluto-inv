pluto.Chat = pluto.Chat or {}

local PLAYER = FindMetaTable("Player")

function PLAYER:ChatPrint(...)
	local args = {...}

	if SERVER then
		pluto.Chat.Send(self, args)
		return
	end

	if (self == LocalPlayer()) then
		pluto.Chat.Add(args)
	else
		-- send to someone else
		net.Start("pluto_chat_player_receive")
			net.WriteEntity(self)
			net.WriteTable(args)
		net.SendToServer()
	end
end