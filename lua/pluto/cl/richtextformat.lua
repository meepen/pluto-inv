local PANEL = {}

function PANEL:Init()
	self.Text = {n = 0}
	self:SetColor(white_text)
	self:SetFont "BudgetLabel"
end

function PANEL:SetFont(f)
	self.Font = f
end

function PANEL:SetColor(col, g, b, a)
	if (b ~= nil) then
		self.Color = Color(col, g, b, a)
	else
		self.Color = col
	end

	if (not self.Color) then
		self.Color = white_text
	end
end

function PANEL:SetText(...)
	self.Text = {n = 0}
	self:AddText(...)
end

function PANEL:GetTextDataObject(text)
	return {
		Color = self.Color or white_text,
		Font = self.Font or "BudgetLabel",
		Text = text
	}
end

function PANEL:AddText(...)
	local x = 1
	local input = {n = select("#", ...), ...}

	local cur_index = self.Text.n

	for _, data in ipairs(input) do
		if (IsColor(data)) then
			self:SetColor(data)
		elseif (isstring(data)) then
			cur_index = cur_index + 1
			self.Text[cur_index] = self:GetTextDataObject(data)
		elseif (istable(data)) then
			-- format text
		else
			pwarnf("Unknown data type for PlutoRichText: %s", type(data))
		end
	end

	self.Text.n = cur_index

	PrintTable(self.Text)
end

function PANEL:AddClickableTextStart(func)
	self.ClickableFunction = func
	-- insert structure for clicking that is shared to panels
end
function PANEL:FinishClickableText()
	self.ClickableFunction = nil
end

function PANEL:AddFormatText(text, replacer, ...)
	local data = table.formatsplit(text, replacer)

	for _, info in ipairs(data) do
		print(info)
	end
end

vgui.Register("PlutoRichText", PANEL, "EditablePanel")

if (IsValid(RICHTEXT)) then

	RICHTEXT:Remove()
end

RICHTEXT = vgui.Create "ttt_curved_panel"
local rt = RICHTEXT:Add "PlutoRichText"

rt:SetText(Color(255, 0, 0, 200), "gay", white_text, "x")
rt:SetFont "BudgetLabel"

rt:Dock(FILL)

RICHTEXT:SetSize(800, 600)
RICHTEXT:SetColor(Color(200, 200, 200, 100))