local was_visible = false

local msg = [[
--------------------------------------------------------------------------------------------
|  Hi. If you are seeing this, and you just wanted to change console variables - go ahead! |
|  This message is here to thank the people that have severely helped me in my endeavor to |
|  create this server and hopefully maintain it as a healthy, fun place to hang out with   |
|  other people.                                                                           |
|------------------------------------------------------------------------------------------|
]]

local people = {
	"| Ling       [BFF] | Helped me get off the ground. One of my longest and best friends.     |",
	"| Squigble   [BFF] | Designer since day 1. Designed all of the original currency and ui.   |",
	"| Mae              | Although not here long, helped create the groundwork of some images.  |",
	"| Kat              | Best girl. Always there for me. I love her.                           |",
	"| Crossboy         | Friend who has been there since the start. I appreciate him immensely.|",
	"| Addi             | Started as a player. Dedicated his time to helping without being      |\n" ..
	"|                  | recognized. Became an amazing friend. Truly a wonder and will go far. |",
	"| Badger           | Although not always there, was still my friend and tried to help.     |",
	"| Eppen            | Has always been a background pseudo-developer. The forefront of our   |\n" ..
	"|                  | community. Maintains almost solely the entire wiki and is amazing.    |",
	"| Sniperz          | One of the most amazing admins (and friends) ever. We will finish     |\n" ..
	"|                  | a game one day. Probably.                                             |",
	"| Geralt of Rivia  | Literally my best friend. Always there.                               |",
	"| Froggy           | Another one of my greatest friends. Dedicated player and amazing Teemo|",
	"| Shootr31         | Another one of my greatest friends. Doesn't play, but still helps     |\n" .. 
	"|                  | with pretty much everything you see on the server.                    |",
	"| Hound            | Helped me in my time of need. One of the best friends I've ever had.  |\n" ..
	"|                  | Created the staff framework. I'm sorry the pain I caused you.         |",
}

hook.Add("Think", "pluto_credits", function()
	if (not gui.IsConsoleVisible()) then
		return
	end

	MsgN "\n\n"
	MsgC(white_text, msg)
	local line_sep = "|" .. string.rep("-", people[1]:len() - 2) .. "|\n"
	for _, line in RandomPairs(people) do
		MsgC(white_text, "|")
		MsgC(HSVToColor(math.random() * 360, 1, 1), line:sub(2, 19))
		MsgC(white_text, line:sub(20) .. "\n")
		MsgC(white_text, line_sep)
	end
	MsgC(white_text, "| All the temporary staff from the beginning when there wasn't even a staff team.          |\n")
	MsgC(white_text, line_sep)
	MsgC(white_text, "| Everyone who believed in me from the start. I don't think I would have made it without   |\n| all of you.                                                                              |\n")
	MsgC(white_text, line_sep)
	MsgC(white_text, "| Anyone I've missed - my memory and ability to think on the spot is not good.             |\n")
	MsgC(white_text, string.rep("-", line_sep:len()))
	MsgN "\n\n"
	hook.Remove("Think", "pluto_credits")
end)