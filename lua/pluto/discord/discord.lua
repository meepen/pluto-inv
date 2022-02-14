--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

discord = discord or {}

local config = util.JSONToTable(file.Read("cfg/pluto.json", "GAME"))["discord-gmod"]

if (not config) then -- People's test servers will not have this
	print("No discord config, returning")
	return
end

local base_url = config.remote

local ITEM = {}
local EMBED = {
	__index = ITEM
}

function ITEM:AddField(name, value, inline)
	self.fields = self.fields or {}
	table.insert(self.fields, {
		name = name,
		value = value,
		inline = inline
	})
	return self
end

function ITEM:SetDescription(desc)
	self.description = desc
	return self
end

function ITEM:SetFooter(text, icon)
	self.footer = {
		text = text,
		icon_url = icon
	}
	return self
end

function ITEM:SetImage(img)
	self.image = {
		url = img
	}
	return self
end

function ITEM:SetTimestamp(time)
	self.timestamp = os.date("!%Y-%m-%dT%TZ", time or os.time())
	return self
end

function ITEM:SetThumbnail(img)
	self.thumbnail = {
		url = img
	}
	return self
end

function ITEM:SetURL(url)
	self.url = url
	return self
end

function ITEM:SetTitle(title)
	self.title = title
	return self
end

function ITEM:SetAuthor(name, url, icon)
	self.author = {
		name = name,
		url = url,
		icon_url = icon
	}
	return self
end

function ITEM:SetColor(col)
	self.color = bit.lshift(col.r, 16) + bit.lshift(col.g, 8) + col.b
	return self
end

local MSG = {}
local MESSAGE = {
	__index = MSG
}

function MSG:Send(where)
	local channel = config.channels[where]

	if (not channel) then
		ErrorNoHalt("Message not sent to " .. where .. "!")
		return
	end


	if (config.disabled) then
		return
	end

	HTTP {
		success = function(code, body, headers)
		end,
		failed = function(reason)
		end,

		method = "POST",
		url = base_url .. where,
		body = util.TableToJSON(self),
		headers = {
			Authentication = channel.authentication,
		},
		type = "application/json"
	}
	return self
end

function MSG:AddEmbed(emb)
	self.embeds = self.embeds or {}
	table.insert(self.embeds, emb)
	return self
end

function MSG:SetText(text)
	self.content = text
	return self
end

function MSG:SetAvatar(url)
	self.avatar_url = url
	return self
end

function MSG:SetUsername(name)
	self.username = name
	return self
end

function discord.Embed()
	return setmetatable({}, EMBED)
end

function discord.Message()
	return setmetatable({}, MESSAGE)
end
