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

local closed_alpha = 0
local opened_alpha = .75 * 255

local chatAddText = chat.AddText

function chat.AddText(...)
	pluto.chat.Add({...}, "server")
end

function pluto.inv.readchatmessage()
	local size = net.ReadUInt(8)
	local teamchat = net.ReadBool()
	local channel = net.ReadString()
	local content = {}

	for i = 1, size do
		local data
		local type = net.ReadUInt(2)

		if type == pluto.chat.type.TEXT then
			data = net.ReadString()
		elseif type == pluto.chat.type.COLOR then
			data = net.ReadColor()
		elseif type == pluto.chat.type.PLAYER then
			data = net.ReadEntity()
		elseif type == pluto.chat.type.ITEM then
			data = pluto.inv.readitem()
		end

		table.insert(content, data)
	end

	pluto.chat.Add(content, channel, teamchat)
end

function pluto.inv.writechat(teamchat, data)
	net.WriteUInt(#data, 8)
	net.WriteBool(teamchat)
	for k,element in pairs(data) do
		if type(element) == "string" then
			net.WriteUInt(pluto.chat.type.TEXT, 2)
			net.WriteString(element)
		elseif type(element) == "Color" then
			net.WriteUInt(pluto.chat.type.COLOR, 2)
			net.WriteColor(element)
		elseif type(element) == "Player" then
			net.WriteUInt(pluto.chat.type.PLAYER, 2)
			net.WriteEntity(element)
		elseif type(element) == "table" then
			net.WriteUInt(pluto.chat.type.ITEM, 2)
			net.WriteUInt(element, 32)
		end
	end
end

function pluto.chat.Add(content, channel, teamchat)
	--PrintTable(content)
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
		if (ttt.GetRoundState() ~= ttt.ROUNDSTATE_PREPARING and IsValid(from.HiddenState) and not from.HiddenState:IsDormant()) then
			local col = from:GetRoleData().Color
			pluto.chat.Box:Color(channel, col.r, col.g, col.b, 255)
		else
			pluto.chat.Box:Color(channel, 17, 15, 13, 255)
		end
		pluto.chat.Box:Text(channel, from:Nick())
		pluto.chat.Box:Color(channel, 255, 255, 255, 255)
		pluto.chat.Box:Text(channel, "COLON:COLON ")
	end
	print("x")
	for k,v in pairs(content) do
		if (IsColor(v)) then
			pluto.chat.Box:Color(channel, v)
		elseif (type(v) == "string") then
			pluto.chat.Box:Text(channel, v)
		elseif (IsValid(v) and v:IsPlayer()) then
			if (ttt.GetRoundState() ~= ttt.ROUNDSTATE_PREPARING and IsValid(v.HiddenState) and not v.HiddenState:IsDormant()) then
				local col = v:GetRoleData().Color
				pluto.chat.Box:Color(channel, col.r, col.g, col.b, 255)
			else
				pluto.chat.Box:Color(channel, 17, 15, 13, 255)
			end
			pluto.chat.Box:Text(channel, v:Nick())
			pluto.chat.Box:Color(channel, 255, 255, 255, 255)
			--pluto.chat.Box:Text(channel, ": ")
		else
			print("other type")
			PrintTable(v)
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

	function self.TextEntry:OnFocusChanged(gained)
		if (not gained) then
			self:SetKeyboardInputEnabled(false)
			pluto.chat.Box:SetKeyboardInputEnabled(false)
		end
	end

	self.TextEntry:SetEnterAllowed(false)

	function self.TextEntry:OnKeyCode(code)
		if (code == KEY_ESCAPE) then
			self:SetText("")
			gui.HideGameUI()
			pluto.chat.Close()
		elseif (code == KEY_ENTER) then
			text = self:GetText()
			print("SAYING", text)
			self:SetText ""
			if (text ~= "") then
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
	self.Inner:DockPadding(pad, pad, pad, pad)
end

function PANEL:SetAlpha(a)
	self.Inner:SetColor(Color(17, 15, 13, a))
	self.TextEntry:SetAlpha(a)
	self.Buttons:SetAlpha(a)
end

function PANEL:Paint(w, h)
end

vgui.Register("pluto_chatbox_inner", PANEL, "ttt_curved_panel_shadow")

local PANEL = {}

function PANEL:Init()
	self:SetSize(ScrW()/4,ScrH()/4)
	self:SetPos(150,ScrH()-self:GetTall()*2)

	self.Tabs = self:Add("EditablePanel")
	self.Tabs:Dock(TOP)
	self.Tabs:SetTall(50)

	self.Tabs.table = {}
	
	self.Chatbox = self:Add("pluto_chatbox_inner")
	self.Chatbox:Dock(FILL)

	self:AddTab("server")
	self:AddTab("admin")
	self:AddTab("global")

	self:SelectTab("server")

	self.Tabs.active:SetVerticalScrollbarEnabled(false)

	self:SetAlpha(closed_alpha)
end

function PANEL:SetAlpha(a)
	self.Tabs:SetAlpha(a)
	self.Chatbox:SetAlpha(a)
end

function PANEL:AddTab(name)
	local chat = self.Chatbox.Text:Add("RichText")
	chat:AppendText("Channel: "..name.."\n")
	chat:Hide()
	chat:Dock(FILL)

	local tab = self.Tabs:Add("pluto_chatbox_button")
	tab.name = name
	tab:SetText(name)
	tab:Dock(LEFT)

	function tab:DoClick()
		pluto.chat.Box:SelectTab(self.name)
	end

	function chat:PerformLayout()
		self:SetFontInternal "pluto_trade_chat_bold"
	end

	self.Tabs.table[name] = chat
end

function PANEL:SelectTab(name)
	if (self.Tabs.active ~= nil) then
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
	local box = self.Tabs.table[channel]
	box:Color(item.Tier.Color)
	box:InsertClickableLinkStart(item.TabID)
	box:Color(0,255,0,255)
	box:Text("ITEMHERE")
	box:InsertClickableLinkEnd()
	box:Color(255, 255, 255, 255)
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
	pluto.chat.Box:Remove()
	pluto.chat.Box = vgui.Create("pluto_chatbox")
end

hook.Add("Initialize", "init_chatbox", function()
	pluto.chat.Box = vgui.Create("pluto_chatbox")
end)