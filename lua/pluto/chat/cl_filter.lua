--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
hook.Add("ChatText", "pluto_chat_filter", function(index, name, text, type)
	if (type == "joinleave") then
		print(text)
		return true
	end
end)
