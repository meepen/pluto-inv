local PANEL = {}
DEFINE_BASECLASS "tttrw_base_panel"

function PANEL:Init()
	self:SetSize(640, 400)
	self:MakePopup()
	self:Center()
	BaseClass.Init(self)
end

vgui.Register("pluto_mapvote", PANEL, "tttrw_base_panel")

do return end
if (IsValid(mapvote)) then
	mapvote:Remove()
end

mapvote = vgui.Create "pluto_mapvote"
for i = 1, 32 do
	local pn = vgui.Create "ttt_curved_panel"
	pn:SetColor(ColorRand())
	pn:SetSize(math.random() * ScrW(), math.random() * ScrH())
	mapvote:AddTab(tostring(i), pn)
end