discord = discord or {}

local base_url = "https://discord-gmod.pluto.gg/discord/"

local config = util.JSONToTable [[{
	"port": 3030,
	"channels": {
		"errors": {
			"url": "https://discordapp.com/api/webhooks/620024553787228161/uTNaEdWP05R16ErqZ_E-upbOckm_3dkoIyfDaEE8amkCqwQtuzR5rIhGfWYnDvj7u2hJ",
			"authentication": "4tZ#L5gyhpFk"
		},

		"drops": {
			"url": "https://discordapp.com/api/webhooks/662806193261117462/uigdPgTczbWEMVjmv0V8_8Uw27zjB-zxoJfFnvb8eZCjtzO2uvTN4u2ZxmGmDdwfsGpq",
			"authentication": "tZ633@ydve$8"
		}
	}
}]]

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

	print(util.TableToJSON(self))

	HTTP {
		success = function(code, body, headers)
			print(code)
			PrintTable(headers)
			print(body)
		end,
		failed = function(reason)
			print(reason)
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
