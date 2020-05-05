hook.Add("HUDShouldDraw", "plutoHideChatBox", function(name) 
	if (name == "CHudChat") then
		return false
	end 
end)

hook.Add("PlayerBindPress", "plutoChatBind", function(ply, bind, pressed)
	if (bind == "messagemode") then
		pluto.Chat.Open()
	elseif (bind == "messagemode2") then
		pluto.Chat.Open(true)
	else
		return
	end

	return true
end)

local chatAddText = chat.AddText

function chat.AddText(...)
	pluto.Chat.Send({...})
end

function pluto.Chat.Add(...)
	local content = {...}
end

function pluto.Chat.Open(teamchat = false)
	pluto.Chat.isOpened = true

	pluto.Chat.Box:SetMouseInputEnabled(true)
	pluto.Chat.Box:SetKeyboardInputEnabled(true)
end

function pluto.Chat.Close()
	pluto.Chat.isOpened = false

	pluto.Chat.Box:SetMouseInputEnabled(false)
	pluto.Chat.Box:SetKeyboardInputEnabled(false)
end

local PANEL = {}
DEFINE_BASECLASS "ttt_curved_panel"

function PANEL:Init()
	
end

function PANEL:Paint(w, h)
	if (pluto.Chat.isOpened) then
		baseclass.Paint(self, w, h)
	end
end

vgui.Register("pluto_chatbox_inner", PANEL, "ttt_curved_panel")

local PANEL = {}

function PANEL:Init()
	pluto.Chat.isOpened = false

	self.Inner = self:Add("pluto_chatbox_inner")
	self.Inner:Dock(FILL)
end

vgui.Register("pluto_chatbox", PANEL, "EditablePanel")

pluto.Chat.Box = vgui.Create("pluto_chatbox")