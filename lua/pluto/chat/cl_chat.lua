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

surface.CreateFont("pluto_chat_font", {
	font = "Roboto Bk",
	size = 18,
	bold = true,
	weight = 100,
})

local closed_alpha = 0
local opened_alpha = .75 * 255

local chatAddText = chat.AddText

function chat.AddText(...)
	debug.Trace()
	pluto.chat.Add({...}, "server")
end

function pluto.inv.readchatmessage()
	local size = net.ReadUInt(8)
	local teamchat = net.ReadBool()
	local channel = net.ReadString()
	local content = {}

	for i = 1, size do
		local data
		local type = net.ReadUInt(3)

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
	pluto.chat.Box:Color(channel, 255, 255, 255, 255)
	if (type(content[1]) ~= "string" and IsValid(content[1]) and content[1]:IsPlayer()) then
		from = table.remove(content, 1)
		if (channel == "server") then 
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
		pluto.chat.Box:Color(channel, 255, 255, 255, 255)
		pluto.chat.Box:Text(channel, ": ")
	end

	for k,v in pairs(content) do
		if (IsColor(v)) then
			pluto.chat.Box:Color(channel, v)
		elseif (type(v) == "string") then
			pluto.chat.Box:Text(channel, v)
		elseif (IsValid(v) and v:IsPlayer()) then
			local col = ttt.teams.innocent.Color
			pluto.chat.Box:Color(channel, col.r, col.g, col.b, 255)
			pluto.chat.Box:Text(channel, v:Nick())
			pluto.chat.Box:Color(channel, 255, 255, 255, 255)
			--pluto.chat.Box:Text(channel, ": ")
		else
			print("other type", v)
			PrintTable(v)
			if (v.Type ~= nil) then
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
	print("OPEN")
	pluto.chat.isOpened = true
	pluto.chat.teamchat = teamchat or false

	pluto.chat.Box:SetAlpha(opened_alpha)
	pluto.chat.Box:ResetFade()
	--timer.Create("AlphaSetChatbox", 1, 0, function()
		print("timer")
		pluto.chat.Box:ResetFade()
	--end)

	pluto.chat.Box:Scrollbar(true)

	pluto.chat.Box:MakePopup()
	pluto.chat.Box.Chatbox.TextEntry:RequestFocus()
end

function pluto.chat.Close()
	print("CLOSE")
	pluto.chat.isOpened = false
	pluto.chat.teamchat = false

	pluto.chat.Box:SetAlpha(closed_alpha)
	timer.Remove("AlphaSetChatbox")

	pluto.chat.Box:Scrollbar(false)

	pluto.chat.Box:SetMouseInputEnabled(false)
	pluto.chat.Box:SetKeyboardInputEnabled(false)
end

local PANEL = {}
DEFINE_BASECLASS "ttt_curved_button"

function PANEL:Init()
	self:SetTall(25)
	self:SetText("A")
	self:SetColor(Color(10, 10, 10, .9 * 255))
	self:DockMargin(5, 5, 5, 5)
	self:SetCurve(4)
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
	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:SetCurve(4)
	self.Inner:SetCurveTopLeft(false)
	self.Inner:Dock(FILL)
	self.Inner:SetColor(Color(17, 15, 13, 0.25 * 255))

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

	self.TextEntry:SetEnterAllowed(false)

	function self.TextEntry:OnKeyCode(code)
		if (code == KEY_ESCAPE) then
			self:SetText("")
			gui.HideGameUI()
			pluto.chat.Close()
		elseif (code == KEY_ENTER) then
			text = self:GetText()

			self:SetText ""
			if (text ~= "") then
				if (pluto.chat.Box.Tabs.active.name == "admin") then
					text = "@" .. text
				end

				if (not pluto.chat.teamchat and text:sub(1,1) == "@") then
					pluto.chat.Box:SelectTab("admin")
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

	self.Buttons.Settings = self.Buttons:Add("pluto_chatbox_button")
	self.Buttons.Settings:Dock(TOP)

	self.Buttons.Flag = self.Buttons:Add("pluto_chatbox_button")
	self.Buttons.Flag:Dock(TOP)

	self.Buttons.Pin = self.Buttons:Add("pluto_chatbox_button")
	self.Buttons.Pin:Dock(BOTTOM)

	self.Buttons.Page = self.Buttons:Add("pluto_chatbox_button")
	self.Buttons.Page:Dock(BOTTOM)

	self.Buttons.Inventory = self.Buttons:Add("pluto_chatbox_button")
	self.Buttons.Inventory:Dock(BOTTOM)

	self.Buttons.Emoji = self.Buttons:Add("pluto_chatbox_button")
	self.Buttons.Emoji:Dock(BOTTOM)

	local pad = self.Inner:GetCurve() / 2
	self.Inner:DockPadding(pad, 0, pad, pad)
end

function PANEL:SetAlpha(a)
	self.Inner:SetColor(Color(17, 15, 13, a))
	self.TextEntry:SetAlpha(a)
	self.Buttons:SetAlpha(a)
end

vgui.Register("pluto_chatbox_inner", PANEL, "ttt_curved_panel_shadow")

local PANEL = {}

function PANEL:Init()
	self:SetSize(ScrW()/4,ScrH()/4)
	self:SetPos(150,ScrH()-self:GetTall()*2)

	self.Tabs = self:Add "EditablePanel"
	self.Tabs:Dock(TOP)
	self.Tabs:SetTall(50)

	self.Tabs.table = {}
	
	self.Chatbox = self:Add "pluto_chatbox_inner"
	self.Chatbox:Dock(FILL)

	self:AddTab "server"
	self:AddTab "admin"
	--self:AddTab("global") this doesn't do anything yet so im commenting it out until we do discord/socket things to make it work

	self:SelectTab "server"

	self.Tabs.active:SetVerticalScrollbarEnabled(false)

	self:SetAlpha(closed_alpha)

	self.Showcase = nil
end

function PANEL:SetAlpha(a)
	self.Tabs:SetAlpha(a)
	self.Chatbox:SetAlpha(a)
end

function PANEL:AddTab(name)
	local chat = self.Chatbox.Text:Add "RichText"
	chat:AppendText("Channel: " .. name .. "\n")
	chat:Hide()
	chat:Dock(FILL)
	chat.name = name

	local tab = self.Tabs:Add "tttrw_base_tab"
	tab.name = name
	tab:SetText(name)
	tab:Dock(LEFT)

	function tab:DoClick()
		pluto.chat.Box:SelectTab(self.name)
	end

	function chat:PerformLayout()
		self:SetFontInternal "pluto_chat_font"
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
end

function PANEL:SelectTab(name)
	if (self.Tabs.active ~= nil) then
		if (self.Tabs.active.name == name) then return end
		
		self.Tabs.active:Hide()
	end

	self.Tabs.table[name]:Show()
	self.Tabs.active = self.Tabs.table[name]

	self.Chatbox.Text:InvalidateLayout()
end

function PANEL:Text(channel, text)
	self.Tabs.table[channel]:AppendText(text)
	self.Tabs.table[channel]:InsertFade(5,.2)
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

	print("channel", channel)

	self.Tabs.table[channel]:InsertColorChange(r, g, b, a)
end

function PANEL:Item(channel, item)
	print("item")
	PrintTable(item)
	local box = self.Tabs.table[channel]
	self:Color(channel, item.Color)
	box:InsertClickableTextStart(util.TableToJSON({type = "item", val = item.ID}))
	self:Text(channel, item:GetDefaultName())
	box:InsertClickableTextEnd()
	self:Color(channel, 255, 255, 255, 255)
end

function PANEL:Cur(channel, cur)
	print("currency", cur)
	local box = self.Tabs.table[channel]

	if not cur then return end

	self:Color(channel, cur.Color)
	box:InsertClickableTextStart(util.TableToJSON({type = "currency", val = cur.InternalName}))
	self:Text(channel, cur.Name)
	box:InsertClickableTextEnd()
	self:Color(channel, 255, 255, 255, 255)
end

function PANEL:Newline(channel)
	self.Tabs.table[channel]:AppendText("\n")
end

function PANEL:ResetFade()
	print("fade reset")
	if (self.Tabs.active ~= nil) then
		self.Tabs.active:ResetAllFades(true, false, 1)
	end
end

function PANEL:Scrollbar(bool)
	if (self.Tabs.active ~= nil) then
		self.Tabs.active:SetVerticalScrollbarEnabled(bool)
	end
end

vgui.Register("pluto_chatbox", PANEL, "EditablePanel")

if (IsValid(pluto.chat.Box)) then
	if (IsValid(pluto.chat.Box.Showcase)) then
		pluto.chat.Box.Showcase:Remove()
	end
	pluto.chat.Close()
	pluto.chat.Box:Remove()
	pluto.chat.Box = vgui.Create("pluto_chatbox")
end

hook.Add("Initialize", "init_chatbox", function()
	pluto.chat.Box = vgui.Create("pluto_chatbox")
end)