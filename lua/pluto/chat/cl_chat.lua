local pluto_chatbox_x = CreateConVar("pluto_chatbox_x", 0.05, FCVAR_ARCHIVE, "Pluto chatbox x position", 0, 1)
local pluto_chatbox_y = CreateConVar("pluto_chatbox_y", 0.15, FCVAR_ARCHIVE, "Pluto chatbox y position", 0, 1)
local pluto_chat_fade_enable = CreateConVar("pluto_chat_fade_enable", "1", FCVAR_ARCHIVE, "enable", 0, 1)
local pluto_chat_fade_sustain = CreateConVar("pluto_chat_fade_sustain", "5", FCVAR_ARCHIVE, "sustain", 0, 10)
local pluto_chat_fade_length = CreateConVar("pluto_chat_fade_length", "0.5", FCVAR_ARCHIVE, "length", 0, 10)
local pluto_chat_closed_alpha = CreateConVar("pluto_chat_closed_alpha", "0", FCVAR_ARCHIVE, "alpha", 0, 0.75)

local function reposition()
	if (IsValid(pluto.chat.Box)) then
		pluto.chat.Box:SetPos(pluto_chatbox_x:GetFloat() * ScrW(), ScrH() * (1 - pluto_chatbox_y:GetFloat()) - pluto.chat.Box:GetTall())
	end
end

pluto.chat.cl_commands = {
	{
		aliases = {
			"screenshot",
			"ss",
			"scr",
			"srnsht",
			"capture",
		},
		Run = function(channel)
			local ScreenshotRequested = true
			hook.Add("PostRender", "pluto_screenshot", function()
				if (not ScreenshotRequested) then
					return
				end
				ScreenshotRequested = false
			
				local data = render.Capture {
					format = "png",
					x = 0,
					y = 0,
					w = ScrW(),
					h = ScrH(),
					alpha = false,
				}
				imgur.image(data):next(function(data)
					SetClipboardText(data.data.link)
					chat.AddText("Screenshot link made! Paste from your clipboard.")
				end):catch(function()
					chat.AddText("Couldn't upload your screenshot. Sorry!")
				end)
			end)
		end
	},
	{
		aliases = {
			"inv",
			"inventory",
			"ps",
			"pointshop",
		},
		Run = function(channel)
			pluto.ui.toggle()
		end
	},
	{
		aliases = {
			"mapvote",
			"mv",
		},
		Run = function(channel)
			if (pluto.mapvote) then
				pluto.mapvote_create()
			end
		end
	},
	{
		aliases = {
			"commands",
			"help",
		},
		Run = function(channel)
			local commands = {}

			for _, cmd in ipairs(pluto.chat.cl_commands) do
				if (cmd.aliases[1]) then
					table.insert(commands, ttt.roles.Innocent.Color)
					table.insert(commands, cmd.aliases[1])
					table.insert(commands, white_text)
					table.insert(commands, ", ")
				end
			end

			table.remove(commands)

			chat.AddText("Here is a list of all ", ttt.roles.Innocent.Color, "chat ", white_text, "commands:")
			chat.AddText(unpack(commands))
		end
	},
}

pluto.chat.cl_commands.byname = {}
for _, cmd in ipairs(pluto.chat.cl_commands) do
	for _, alias in pairs(cmd.aliases) do
		pluto.chat.cl_commands.byname[alias] = cmd
	end
end

cvars.AddChangeCallback(pluto_chatbox_x:GetName(), reposition, pluto_chatbox_x:GetName())
cvars.AddChangeCallback(pluto_chatbox_y:GetName(), reposition, pluto_chatbox_y:GetName())

hook.Add("HUDShouldDraw", "plutoHideChatBox", function(name) 
	if (name == "CHudChat") then
		return false
	end 
end)

hook.Add("PlayerBindPress", "plutoChatBind", function(ply, bind, pressed)
	if (bind == "messagemode") then
		pluto.chat.Open()
	elseif (bind == "messagemode2") then
		pluto.chat.Open(true)
	else
		return
	end

	return true
end)

local closed_alpha = 0.75 * 255
local opened_alpha = 0.75 * 255

local chatAddText = chat.AddText

function chat.AddText(...)
	pluto.chat.Add({...}, "Server")
end

function pluto.inv.readchatmessage()
	local teamchat = net.ReadBool()
	local channel = net.ReadString()
	local content = {}

	while (1) do
		local data
		local type = net.ReadUInt(4)

		if type == pluto.chat.type.TEXT then
			data = net.ReadString()
		elseif type == pluto.chat.type.COLOR then
			data = net.ReadColor()
		elseif type == pluto.chat.type.PLAYER then
			data = net.ReadEntity()
		elseif type == pluto.chat.type.ITEM then
			data = pluto.inv.readitem()
		elseif type == pluto.chat.type.CURRENCY then
			data = pluto.currency.byname[net.ReadString()]
		elseif (type == pluto.chat.type.IMAGE) then
			data = table.Copy(pluto.chat.images[net.ReadString()])
			data.Size = Vector(net.ReadUInt(8), net.ReadUInt(8))
		elseif (type == pluto.chat.type.NONE) then
			break
		end

		table.insert(content, data)
	end

	pluto.chat.Add(content, channel, teamchat)
end

function pluto.inv.writechat(teamchat, data)
	net.WriteBool(teamchat)
	for i = #data, 1, -1 do
		if (type(data[i]) ~= "string") then
			table.remove(data, i)
		end
	end

	net.WriteString(table.concat(data, " "))
end

function pluto.chat.Add(content, channel, teamchat)
	local data = pluto.chat.channels.byname[channel]
	if (not data) then
		return
	end
	if (data.Relay) then
		for _, channel in pairs(data.Relay) do
			pluto.chat.Add(table.Copy(content), channel, teamchat)
		end
	end
	local from
	pluto.chat.Box:Color(channel, white_text.r, white_text.g, white_text.b, white_text.a)
	if (type(content[1]) ~= "string" and IsValid(content[1]) and content[1]:IsPlayer()) then
		from = table.remove(content, 1)
		if (channel == "Server") then 
			if (not from:Alive()) then
				pluto.chat.Box:Color(channel, 255, 0, 0, 255)
				pluto.chat.Box:Text(channel, "*DEAD* ")
			elseif (teamchat) then
				pluto.chat.Box:Color(channel, from:GetRoleData().Color)
				pluto.chat.Box:Text(channel, "(TEAM) ")
			end
		end

		local col = ttt.teams.innocent.Color
		pluto.chat.Box:Color(channel, col.r, col.g, col.b, 255)

		pluto.chat.Box:Text(channel, from:Nick())
		pluto.chat.Box:Color(channel, white_text.r, white_text.g, white_text.b, white_text.a)
		pluto.chat.Box:Text(channel, ": ")
	end

	pluto.chat.Box:DefaultFade(pluto.chat.Box.Tabs.active.name)

	for k,v in pairs(content) do
		if (IsColor(v)) then
			pluto.chat.Box:Color(channel, v)
		elseif (type(v) == "string") then
			pluto.chat.Box:Text(channel, v)
		elseif (IsValid(v) and v:IsPlayer()) then
			local col = ttt.teams.innocent.Color
			pluto.chat.Box:Color(channel, col.r, col.g, col.b, 255)
			pluto.chat.Box:Text(channel, v:Nick())
			pluto.chat.Box:Color(channel, white_text.r, white_text.g, white_text.b, white_text.a)
			--pluto.chat.Box:Text(channel, ": ")
		else
			if (v.Type == "emoji") then
				pluto.chat.Box.Tabs.table[channel]:AddImageFromURL(v.URL, v.Size.x, v.Size.y)
			elseif (v.Type ~= nil) then
				pluto.chat.Box:Item(channel, v)
			elseif (v.InternalName ~= nil) then
				pluto.chat.Box:Cur(channel, v)
			end
		end
	end

	pluto.chat.Box:Newline(channel)
end

function pluto.chat.Open(teamchat)
	if (pluto.chat.isOpened) then return end

	pluto.chat.isOpened = true
	pluto.chat.teamchat = teamchat or false

	pluto.chat.Box:SetAlpha(opened_alpha)
	pluto.chat.Box:ResetFade(true)

	if (not teamchat) then
		pluto.inv.message()
			:write("chatopen", true)
			:send()
	end

	pluto.chat.Box:MakePopup()
	pluto.chat.Box.Chatbox.TextEntry:RequestFocus()
end

function pluto.chat.Close()
	pluto.chat.isOpened = false

	pluto.chat.Box:SetAlpha(closed_alpha * pluto_chat_closed_alpha:GetFloat())
	pluto.chat.Box:ResetFade(false)
	pluto.chat.Box:ScrollToBottom()
	pluto.chat.Box:SignalClose()
	timer.Remove "AlphaSetChatbox"

	if (not pluto.chat.teamchat) then
		pluto.inv.message()
			:write("chatopen", false)
			:send()
	end

	pluto.chat.teamchat = false

	pluto.chat.Box:SetMouseInputEnabled(false)
	pluto.chat.Box:SetKeyboardInputEnabled(false)
end

function pluto.inv.writechatopen(b)
	net.WriteBool(b)
end

local PANEL = {}
DEFINE_BASECLASS "ttt_curved_button"

function PANEL:Init()
	self:SetTall(25)
	self:SetText("")
	self:SetColor(ColorAlpha(main_color, 200))
	self:DockMargin(5, 5, 5, 5)
	self:SetCurve(4)
end

function PANEL:SetImage(icon)
	if (IsValid(self.Icon)) then
		self.Icon:Remove()
	end
	self.Icon = self:Add "DImage"
	self.Icon:Dock(FILL)
	self.Icon:DockMargin(4, 4, 4, 4)
	self.Icon:SetImage(icon)
end

vgui.Register("pluto_chatbox_button", PANEL, "ttt_curved_button")

local PANEL = {}

function PANEL:Init()
	self.Tabs = {}
	self.CurPos = 0
end

function PANEL:SetTab(name)
	self:Select(self.Tabs[name])
end

local function PerformLayoutHack(self, w, h)
	if (self.OldPerformLayout) then
		self:OldPerformLayout(w, h)
	end

	if (IsValid(self.Before)) then
		self.Position = self.Before.Position + self.Before:GetWide() + 4
	else
		self.Position = 0
	end

	self:GetParent():Recalculate(self)
end

function PANEL:Recalculate(tab)
	tab:SetPos(tab.Position - self.CurPos, 0)
	if (IsValid(tab.Next)) then
		tab.Next.Position = tab.Position + tab:GetWide() + 4
		return self:Recalculate(tab.Next)
	end
end

function PANEL:Select(tab)
	if (self.Current == tab) then
		return
	end

	if (IsValid(self.Current)) then
		self.Current.Selected = false
		self.Current:Unselect()
	end

	self.Current = tab
	if (tab.Position < self.CurPos) then
		self.CurPos = tab.Position
		self:Recalculate(tab)
	end

	if (tab.Position + tab:GetWide() > self.CurPos + self:GetWide()) then
		self.CurPos = self.CurPos + tab.Position + tab:GetWide() - (self.CurPos + self:GetWide())
		if (self.CurPos > tab.Position) then
			self.CurPos = tab.Position
		end
		self:Recalculate(self.Next)
	end

	self:DoSelect(tab)
	tab.Selected = true
	if (tab.OnSelect) then
		tab:OnSelect()
	end
end

function PANEL:DoSelect(tab)
end

function PANEL:PerformLayout(w, h)
	for _, tab in pairs(self.Tabs) do
		tab:SetTall(h)
	end

	if (IsValid(self.Current)) then
		self:Select(self.Current)
	end
end

function PANEL:OnMouseWheeled(delta)
	local totalwide = self.Last.Position + self.Last:GetWide() - self:GetWide()
	if (totalwide < 0) then
		return
	end

	self.CurPos = math.Clamp(self.CurPos - delta * 30, 0, totalwide)

	self:Recalculate(self.Next)
end

vgui.Register("ttt_chat_tabs", PANEL, "EditablePanel")

local PANEL = {}
DEFINE_BASECLASS "ttt_curved_panel"

function PANEL:Init()
	self:SetCurve(8)
	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:SetCurve(8)
	self.Inner:Dock(FILL)
	self.Inner:SetColor(Color(255,0,0))
	self.Inner:SetCurveTopLeft(false)
	self:SetCurveTopLeft(false)
	self.Inner:SetCurveTopRight(false)
	self:SetCurveTopRight(false)

	self.Chat = self.Inner:Add("EditablePanel")
	--self.Chat = vgui.Create("EditablePanel")
	self.Chat:DockMargin(10, 10, 10, 10)
	self.Chat:Dock(FILL)

	self.Text = self.Chat:Add "EditablePanel"
	self.Text:Dock(FILL)

	self.TextEntry = self.Chat:Add "DTextEntry"
	self.TextEntry:SetTall(25)
	self.TextEntry:Dock(BOTTOM)
	function self.TextEntry:OnMousePressed(m)
		self:SetKeyboardInputEnabled(true)
		pluto.chat.Box:SetKeyboardInputEnabled(true)
	end
	self.TextEntry:DockMargin(0, 5, 0, 0)

	self.TextEntry:SetFont "pluto_chat_font"
	self.TextEntry:SetEnterAllowed(false)

	function self.TextEntry:Think()
		if (pluto.chat.isOpened and not self:HasFocus()) then
			if (not IsValid(vgui.GetKeyboardFocus()) or vgui.GetKeyboardFocus():GetClassName() ~= "pluto_text") then
				self:RequestFocus()
			end
		end
	end

	function self.TextEntry:OnValueChange(val)
		for _, channel in ipairs(pluto.chat.channels) do
			if (val:StartWith(channel.Prefix)) then
				pluto.chat.Box:SelectTab(channel.Name)
			end
		end
	end

	self.TextEntry:SetUpdateOnType(true)

	function self.TextEntry:OnKeyCode(code)
		if (code == KEY_ESCAPE) then
			self:SetText("")
			gui.HideGameUI()
			pluto.chat.Close()
		elseif (code == KEY_TAB) then
			local text = string.Explode(" ", self:GetText():Trim())

			if (not text or #text == 0 or (#text == 1 and text[1][1] == "!" or text[1][1] == "/")) then
				return
			end

			local complete = text[#text]

			if (select(1, string.find(complete, "\"")) == 1) then
				complete = string.sub(complete, 2)
			end

			for _, ply in ipairs(player.GetAll()) do
				if (not IsValid(ply) or not ply:Nick():lower():StartWith(complete:lower())) then
					continue 
				end

				complete = ply:Nick()

				if (text[1][1] == "!" or text[1][1] == "/") then
					complete = "\"" .. complete .. "\""
				end

				break
			end

			text[#text] = complete

			self:SetText(table.concat(text, " "))
		elseif (code == KEY_ENTER) then
			local text = self:GetText():Trim()

			self:SetText ""
			if (text ~= "") then
				if (text:StartWith "!" or text:StartWith "/") then
					local curcmd = text:sub(2)
					local cmd = pluto.chat.cl_commands.byname[curcmd]
					if (not cmd) then
						cmd = hook.Run("PlutoGetChatCommand", curcmd)
					end
					if (cmd) then
						if (not isbool(cmd)) then
							cmd.Run(pluto.chat.Box.Tabs.active.name)
						end
						pluto.chat.Close()
						return
					end
				end
				local selected = false
				for prefix, tab in pairs(pluto.chat.Box.Tabs.prefixes) do
					if (text:StartWith(prefix)) then
						pluto.chat.Box:SelectTab(tab)
						selected = true
					end
				end

				if (not selected) then
					text = pluto.chat.Box.Tabs.active.prefix .. text
				end

				pluto.inv.message()
					:write("chat", pluto.chat.teamchat, {text})
				:send()
			end
			pluto.chat.Close()
		end
	end

	self.Buttons = self.Inner:Add("EditablePanel")
	self.Buttons:SetWide(35)
	self.Buttons:DockMargin(0, 5, 0, 5)
	self.Buttons:Dock(RIGHT)

	self.Buttons.Mover = self.Buttons:Add "pluto_chatbox_button"
	self.Buttons.Mover:SetCursor "sizeall"
	self.Buttons.Mover:SetImage "icon16/arrow_out.png"
	self.Buttons.Mover:Dock(TOP)

	function self.Buttons.Mover:OnMousePressed(code)
		if (code ~= MOUSE_LEFT) then
			return
		end

		local cur = pluto.chat.Box
		local basex, basey = gui.MousePos()
		local ox, oy = pluto_chatbox_x:GetFloat(), pluto_chatbox_y:GetFloat()
		hook.Add("Think", "pluto_chatbox", function()
			if (not IsValid(cur) or pluto.chat.Box ~= cur or not input.IsMouseDown(MOUSE_LEFT)) then
				hook.Remove("Think", "pluto_chatbox")
				return
			end

			local curx, cury = gui.MousePos()

			pluto_chatbox_x:SetFloat(ox + (curx - basex) / ScrW())
			pluto_chatbox_y:SetFloat(oy + (basey - cury) / ScrH())
		end)
	end

	self.Buttons.Inventory = self.Buttons:Add "pluto_chatbox_button"
	self.Buttons.Inventory:Dock(TOP)
	self.Buttons.Inventory:SetImage("icon16/controller.png")

	function self.Buttons.Inventory:DoClick()
		pluto.ui.toggle()
	end

	local pad = self.Inner:GetCurve() / 2
	self.Inner:DockPadding(pad, 0, pad, pad)

	
	self.Buttons.Links = self.Buttons:Add "pluto_chatbox_button"
	self.Buttons.Links:Dock(TOP)
	self.Buttons.Links:SetImage("icon16/world_link.png")
	local links = {
		{
			Name = "Discord",
			URL = "https://discord.gg/pluto",
			Icon = "icon16/email.png"
		},
		{
			Name = "Website",
			URL = "https://pluto.gg",
			Icon = "icon16/world.png"
		},
		{
			Name = "Wiki",
			URL = "https://pluto.fandom.com/wiki/Pluto.gg_Wiki",
			Icon = "icon16/newspaper.png"
		},
	}
	function self.Buttons.Links:DoClick()
		local mn = DermaMenu()
		for _, link in ipairs(links) do
			mn:AddOption(link.Name, function() gui.OpenURL(link.URL) end):SetImage(link.Icon)
		end
		mn:Open()
	end
end

function PANEL:SetAlpha(a)
	self.Inner:SetColor(ColorAlpha(main_color, a))
	self:SetColor(ColorAlpha(solid_color, a))
	self.TextEntry:SetAlpha(a)
	self.Buttons:SetAlpha(a)
end

vgui.Register("pluto_chatbox_inner", PANEL, "ttt_curved_panel_outline")

local PANEL = {}

function PANEL:Init()
	self:SetSize(math.max(450, ScrW()/4),math.max(300, ScrH()/4))
	pluto.chat.Box = self
	reposition()

	self.Tabs = self:Add "EditablePanel"
	self.Tabs:Dock(TOP)
	self.Tabs:SetTall(50)

	self.Tabs.table = {}
	self.Tabs.prefixes = {}
	
	self.Chatbox = self:Add "pluto_chatbox_inner"
	self.Chatbox:Dock(FILL)

	local first = true
	for _, channel in ipairs(pluto.chat.channels) do
		self:AddTab(channel.Name, channel.Prefix)
	end

	self:SelectTab(pluto.chat.channels[1].Name)

	self:SetAlpha(closed_alpha * pluto_chat_closed_alpha:GetFloat())

	self.Showcase = nil
end

function PANEL:SetAlpha(a)
	self.Tabs:SetAlpha(a)
	self.Chatbox:SetAlpha(a)
	self.Tabs.active.Scrollbar:SetAlpha(a)
end

function PANEL:AddTab(name, prefix)
	local chat = self.Chatbox.Text:Add "pluto_text"
	chat:SetDefaultFont "pluto_chat_font"
	chat:SetDefaultRenderSystem "shadow"
	chat:SetDefaultTextColor(white_text)
	chat:Hide()
	chat:Dock(FILL)
	
	chat.name = name
	chat.prefix = prefix

	local tab = self.Tabs:Add "tttrw_base_tab"
	tab.name = name
	tab:SetText(name)
	tab:Dock(LEFT)

	function tab:DoClick()
		pluto.chat.Box:SelectTab(self.name)
	end

	function chat:PerformLayout()
		self:SetFontInternal "pluto_chat_font"
		self:SetUnderlineFont "pluto_chat_font_clickable"
	end

	function chat:ActionSignal(name, value)
		if (name == "TextClicked") then
			local x = util.JSONToTable(value)
			local thing

			if (x.type == "item") then
				thing = pluto.received.item[x.val]
			elseif (x.type == "currency") then
				thing = pluto.currency.byname[x.val]
			end

			local x,y = input.GetCursorPos()
			if (IsValid(pluto.chat.Box.Showcase)) then
				pluto.chat.Box.Showcase:Remove()
			end

			pluto.chat.Box.Showcase = pluto.ui.showcase(thing)
			pluto.chat.Box.Showcase:MakePopup()
			pluto.chat.Box.Showcase:SetPos(x,y-pluto.chat.Box.Showcase:GetTall() - 20)
			local i = 0
			function pluto.chat.Box.Showcase:OnFocusChanged(gained)
				if (not gained) then
					pluto.chat.Box.Showcase:Remove()
				end
			end
		end
	end

	self.Tabs.table[name] = chat
	self.Tabs.prefixes[prefix] = name

	self:DefaultFade(name)
	chat:AppendText("Channel: " .. name .. "\n")
end

function PANEL:SelectTab(name)
	if (self.Tabs.active ~= nil) then
		if (self.Tabs.active.name == name) then return end
		
		self.Tabs.active:Hide()
	end

	self.Tabs.table[name]:Show()
	self.Tabs.active = self.Tabs.table[name]

	self.Chatbox.Text:InvalidateLayout()
	pluto.chat.Box:ResetFade(false)
end

function PANEL:Text(channel, text)
	MsgC(self.Tabs.table[channel]:GetCurrentTextColor(), text)
	self:DefaultFade(channel)
	self.Tabs.table[channel]:AppendText(text)
end

function PANEL:Color(channel, col, g, b, a)
	local r
	if (IsColor(col)) then
		r = col.r
		g = col.g
		b = col.b
		a = col.a
	else
		r = col
	end

	self.Tabs.table[channel]:InsertColorChange(r, g, b, a)
end

function PANEL:Item(channel, item)
	local box = self.Tabs.table[channel]
	self:Color(channel, item:GetColor())
	self:InsertShowcaseItem(channel, item)
	self:Color(channel, white_text.r, white_text.g, white_text.b, white_text.a)
end

function PANEL:Cur(channel, cur)
	local box = self.Tabs.table[channel]

	if not cur then return end

	self:InsertShowcaseItem(channel, cur)
	self:Color(channel, white_text.r, white_text.g, white_text.b, white_text.a)
	self:DefaultFade(channel)
end

function PANEL:DefaultFade(channel)
	self.Tabs.table[channel]:InsertFade(pluto.chat.isOpened and -1 or pluto_chat_fade_enable:GetBool() and pluto_chat_fade_sustain:GetFloat() or -1, pluto_chat_fade_length:GetFloat())
end

function PANEL:Newline(channel)
	self:DefaultFade(channel)
	self.Tabs.table[channel]:AppendText("\n")
	if (not pluto.chat.isOpened) then
		self:ScrollToBottom()
	end
	MsgN ""
end

function PANEL:InsertShowcaseItem(channel, item)
	self:DefaultFade(channel)
	self.Tabs.table[channel]:InsertShowcaseItem(item)
	MsgC(item:GetColor(), item:GetPrintName())
end

function PANEL:ResetFade(enable)
	if (self.Tabs.active ~= nil) then
		self.Tabs.active:ResetAllFades(enable, false, enable and -1 or pluto_chat_fade_sustain:GetFloat())
	end
end

function PANEL:ScrollToBottom()
	self.Tabs.active:ScrollToBottom()
end

function PANEL:SignalClose()
	self.Tabs.active:SignalClose()
end

vgui.Register("pluto_chatbox", PANEL, "EditablePanel")

if (IsValid(pluto.chat.Box)) then
	if (IsValid(pluto.chat.Box.Showcase)) then
		pluto.chat.Box.Showcase:Remove()
	end
	pluto.chat:Close()
	pluto.chat.Box:Remove()
	pluto.chat.Box = vgui.Create "pluto_chatbox"
	pluto.chat.Box:ScrollToBottom()
end

hook.Add("Initialize", "init_chatbox", function()
	pluto.chat.Box = vgui.Create "pluto_chatbox"
	pluto.chat.Box:ScrollToBottom()
end)