hook.Add("ChatText", "pluto_chat_filter", function(index, name, text, type)
	if (type == "joinleave") then
		return true
	end
end)
