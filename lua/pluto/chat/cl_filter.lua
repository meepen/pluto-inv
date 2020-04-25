hook.Add("ChatText", "pluto_chat_filter", function(index, name, text, type)
	if (type == "joinleave") then
		print(text)
		return true
	end
end)
