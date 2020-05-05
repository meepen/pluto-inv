util.AddNetworkString("pluto_chat_player_send")
util.AddNetworkString("pluto_chat_add_text")
util.AddNetworkString("pluto_chat_send_message")

net.Receive("pluto_chat_player_receive", function()
	local ply = net.ReadEntity()
	local args = net.ReadTable()

	pluto.Chat.Send(ply, args)
end)

net.Receive("pluto_chat_send_message", callback)

function pluto.Chat.Send(ply, ...)
	if not IsValid(ply) then return end

	net.Start("pluto_chat_add_text")
		net.WriteTable({...})
	net.Send(ply)
end

function pluto.Chat.Broadcast(...)
	net.Start("pluto_chat_add_text")
		net.WriteTable({...})
	net.Broadcast()
end