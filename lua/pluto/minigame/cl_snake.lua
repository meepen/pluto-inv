local SNAKE = {
	url = true and "http://va1.pluto.gg:7777/app/snake" or "http://localtest.me:9001/app/snake"
}

local PANEL = {}

function PANEL:Paint(w, h)
	local boardsize = self.BoardSize
	local squaresize = math.floor(w / boardsize)
	local snakesize = squaresize * boardsize
	local xoff, yoff = (w - snakesize) / 2, (h - snakesize) / 2

	surface.SetDrawColor(255, 255, 255, 128)
	surface.DrawOutlinedRect(xoff, yoff, snakesize, snakesize)

	for x, yline in pairs(self.BoardInfo) do
		for y, info in pairs(yline) do
			surface.SetDrawColor(info.Color)
			local basex, basey = xoff + (x - 1) * squaresize, yoff + (y - 1) * squaresize 
			if (info.Type == "food") then
				for i = 0, 2 do
					surface.DrawOutlinedRect(basex + i, basey + i, squaresize - i * 2, squaresize - i * 2)
				end
			elseif (info.Type == "snake") then
				surface.DrawRect(basex + 4, basey + 4, squaresize - 8, squaresize - 8)
				if (info.Direction == "left" or info.From == "right") then
					surface.DrawRect(basex, basey + 4, 4, squaresize - 8)
				end
				if (info.Direction == "right" or info.From == "left") then
					surface.DrawRect(basex + squaresize - 4, basey + 4, 4, squaresize - 8)
				end
				
				if (info.Direction == "up" or info.From == "down") then
					surface.DrawRect(basex + 4, basey, squaresize - 8, 4)
				end
				if (info.Direction == "down" or info.From == "up") then
					surface.DrawRect(basex + 4, basey + squaresize - 4, squaresize - 8, 4)
				end
			end
		end
	end
end

function PANEL:KillSnake(snake)
	for _, pos in pairs(snake.History) do
		self.BoardInfo[pos.x][pos.y] = nil
	end
end

function PANEL:AddSnake()
	local snake = {
		Pos = Vector(1, 1),
		Color = HSVToColor(math.random() * 360, 1, 1),
		History = {Vector(1, 1)},
		Length = 3,
		Type = "snake",
		Direction = "right",
		LastDirection = "right",
	}
	self.BoardInfo[snake.Pos.x][snake.Pos.y] = {
		Type = "snake",
		Direction = "Head",
		Snake = snake,
		Color = snake.Color
	}
	return snake
end
function PANEL:AddFood()
	local food = {
		Type = "food",
		Color = HSVToColor(math.random() * 360, 1, 0.3)
	}

	local avail = {}
	for x = 1, self.BoardSize do
		for y = 1, self.BoardSize do
			if (not self.BoardInfo[x][y]) then
				table.insert(avail, Vector(x, y))
			end
		end
	end

	local selected = table.Random(avail)

	if (not selected) then
		return
	end

	food.Pos = selected

	self.BoardInfo[selected.x][selected.y] = food
end

function PANEL:Init()
	self.BoardSize = 21
	self.BoardInfo = {}

	for x = 1, self.BoardSize do
		self.BoardInfo[x] = {}
	end
	
	self.Snake = self:AddSnake()

	hook.Add("KeyPress", self, self.KeyPress)
	timer.Create("pluto_snake_game", 0.3, 0, function()
		if (not IsValid(self)) then
			return
		end

		self:Progress(self.Snake)

		if (math.random(5) == 1) then
			self:AddFood()
		end
	end)
end
function PANEL:OnRemove()
	timer.Remove "pluto_snake_game"
end

local modify = {
	up = function(pos)
		pos.y = pos.y - 1
	end,
	left = function(pos)
		pos.x = pos.x - 1
	end,
	right = function(pos)
		pos.x = pos.x + 1
	end,
	down = function(pos)
		pos.y = pos.y + 1
	end
}

function PANEL:Progress(snake)
	snake.LastDirection = snake.Direction
	modify[snake.Direction](snake.Pos)
	snake.Pos.x = (snake.Pos.x - 1) % self.BoardSize + 1
	snake.Pos.y = (snake.Pos.y - 1) % self.BoardSize + 1

	for i = 1, #snake.History - snake.Length do
		local rem = snake.History[1]
		table.remove(snake.History, 1)
		self.BoardInfo[rem.x][rem.y] = nil
	end

	local board = self.BoardInfo[snake.Pos.x][snake.Pos.y]
	if (board and board.Type == "food") then
		snake.Length = snake.Length + 1
	elseif (board and board.Type == "snake") then
		self:KillSnake(snake)
		self.Snake = self:AddSnake()
		return
	end

	local last = snake.History[#snake.History]
	if (last) then
		local info = self.BoardInfo[last.x][last.y]
		if (info) then
			info.Direction = snake.Direction
		end
	end
	table.insert(snake.History, snake.Pos * 1)
	self.BoardInfo[snake.Pos.x][snake.Pos.y] = {
		Type = "snake",
		Direction = "Head",
		From = snake.Direction,
		Snake = snake,
		Color = snake.Color
	}
end

function PANEL:KeyPress(_, key)
	if (not IsFirstTimePredicted()) then
		return
	end

	local snake = self.Snake

	if (key == IN_FORWARD) then
		if (snake.LastDirection ~= "down") then
			snake.Direction = "up"
		end
	elseif (key == IN_BACK) then
		if (snake.LastDirection ~= "up") then
			snake.Direction = "down"
		end
	elseif (key == IN_MOVELEFT) then
		if (snake.LastDirection ~= "right") then
			snake.Direction = "left"
		end
	elseif (key == IN_MOVERIGHT) then
		if (snake.LastDirection ~= "left") then
			snake.Direction = "right"
		end
	end
end

vgui.Register("pluto_minigame_snake_sp", PANEL, "EditablePanel")

local PANEL = {}

local directions = {
	[0] = "Head",
	"left",
	"right",
	"up",
	"down"
}

local colors = {
	["76561198050165746"] = function()
		local timing = 5
		local col = HSVToColor((CurTime() % timing) / timing * 360, 1, 1)
		return Color(col.r, col.g, col.b)
	end,
	["76561198280637226"] = function()
		return HexColor "#341c02"
	end
}

local mt = {
	__index = function(self, k)
		if (k == "Color") then
			return colors[self.SteamID64]()
		end
	end
}

function pluto.inv.readsnakeauth()
	if (IsValid(snake_mp)) then
		snake_mp.Authorization = net.ReadString()
		print "AUTHORIZATION RECEIVED"
		print(snake_mp.Authorization)
	end
end

function pluto.inv.writegetsnakeauth()
end

function PANEL:Init()
	snake_mp = self
	self.UpdateInterval = 0.05
	self.LastUpdate = -math.huge

	self.LastRequest = -math.huge
	self.RequestInterval = 20
end

function PANEL:UpdateGameBoard(json)
	if (json.waiting) then
		return
	end

	local game = {
		BoardSize = json.boardSize,
		BoardInfo = {},
		Players = {}
	}
	for x = 1, game.BoardSize do
		game.BoardInfo[x] = {}
	end

	for i, snake in ipairs(json.snakes) do
		local ply = {}
		local col = HSVToColor(i / #json.snakes * 255, 1, 1)
		ply.Name = snake.info.displayname
		ply.SteamID64 = snake.info.steamid
		ply.Color = ply.SteamID64 == LocalPlayer():SteamID64() and Color(255, 255, 255) or Color(col.r, col.g, col.b)
		ply.ID = snake.id
		ply.Dead = snake.dead
		ply.Score = snake.length
		ply.info = snake.info
		if (colors[ply.SteamID64]) then
			setmetatable(ply, mt)
			ply.Color = nil
		end
		game.Players[ply.ID] = ply
	end
	local max = game.BoardSize * game.BoardSize

	for _, data in ipairs(json.board) do
		local is_food = data.what == "food"
		local obj
		if (is_food) then
			obj = {
				Type = "food",
				Color = ColorRand(),
			}
		else
			obj = {
				Type = "snake",
				Direction = data.direction or "Head",
			}
			obj.Player = game.Players[data.snake]
		end

		game.BoardInfo[data.x + 1][data.y + 1] = obj
	end
	if (IsValid(snake_mp)) then
		snake_mp.Board = game
	end
end


function PANEL:Think()
	if (self.LastRequest + self.RequestInterval <= RealTime()) then
		self.LastRequest = RealTime()
		pluto.inv.message()
			:write "getsnakeauth"
			:send()
	end

	if (self.LastUpdate + self.UpdateInterval > RealTime()) then
		return
	end
	self.LastUpdate = RealTime()

	http.Fetch(SNAKE.url, function(body)
		local json = util.JSONToTable(body)
		if (IsValid(snake_mp)) then
			self:UpdateGameBoard(json)
		end
	end, function(...)
		if (IsValid(self)) then
			self.LastUpdate = RealTime() + 5
		end
	end)
end

function PANEL:SendMovement(direction)
	if (not self.Authorization) then
		return
	end

	HTTP {
		url = SNAKE.url .. "/" .. self.Authorization,
		method = "POST",
		success = function(code, body, headers)
			print(body)
		end,
		parameters = {
			direction = direction
		},
		failed = print
	}
end

function PANEL:OnMousePressed()
	self.InputPanel = vgui.Create "EditablePanel"
	function self.InputPanel:Paint()
		if (not self.HasFocussed) then
			self:RequestFocus()
			self.HasFocussed = true
			return
		end
	end

	function self.InputPanel.OnKeyCodePressed(s, code)
		if (code == KEY_W) then
			self:SendMovement "up"
		elseif (code == KEY_S) then
			self:SendMovement "down"
		elseif (code == KEY_A) then
			self:SendMovement "left"
		elseif (code == KEY_D) then
			self:SendMovement "right"
		end
	end
 
	hook.Add("VGUIMousePressed", self.InputPanel, function(self, p)
		self:Remove()
	end)

	self.InputPanel:MakePopup()
	self.InputPanel:SetMouseInputEnabled(false)
end

function PANEL:Paint(w, h)
	local board = self.Board
	if (not board) then
		surface.SetDrawColor(255, 0, 0, 100)
		surface.DrawRect(0, 0, w, h)
		return
	end

	local players = {}
	for _, ply in pairs(board.Players) do
		table.insert(players, ply)
	end

	table.sort(players, function(a, b)
		return a.Score > b.Score
	end)

	local y = 0
	surface.SetFont "BudgetLabel"
	surface.SetTextColor(Color(255, 255, 255))
	local _, th = surface.GetTextSize "A"
	for _, ply in pairs(players) do
		surface.SetDrawColor(ply.Color)
		surface.DrawRect(0, y, th, th)
		surface.SetTextPos(th + 3, y)
		surface.DrawText(ply.Name or ply.SteamID64)
		y = y + th + 3
	end


	local boardsize = board.BoardSize
	local squaresize = math.floor(math.min(w, h) / boardsize)
	local snakesize = squaresize * boardsize
	local xoff, yoff = (w - snakesize) / 2, (h - snakesize) / 2

	surface.SetDrawColor(255, 255, 255, 128)
	surface.DrawOutlinedRect(xoff, yoff, snakesize, snakesize)
	surface.SetMaterial(pluto.currency.byname._banna:GetMaterial())

	for x = 1, boardsize do
		for y = 1, boardsize do
			local info = board.BoardInfo[x][y]
			if (not info) then
				continue
			end
			local basex, basey = xoff + (x - 1) * squaresize, yoff + (y - 1) * squaresize 
			if (info.Type == "food") then
				surface.SetDrawColor(255, 255, 255)
				surface.DrawTexturedRect(basex, basey, squaresize, squaresize)
			elseif (info.Type == "snake") then
				local siding = 2
				local sx, sy, sw, sh = basex + siding, basey + siding, squaresize - siding * 2, squaresize - siding * 2
				surface.SetDrawColor(info.Player.Color)

				if (info.Direction == "right") then
					sw = sw + siding * 2
				elseif (info.Direction == "left") then
					sw = sw + siding * 2
					sx = sx - siding * 2
				elseif (info.Direction == "up") then
					sy = sy - siding * 2
					sh = sh + siding * 2
				elseif (info.Direction == "down") then
					sh = sh + siding * 2
				end

				surface.DrawRect(sx, sy, sw, sh)
			end
		end
	end

	if (not IsValid(self.InputPanel)) then
		surface.SetTextColor(white_text)
		surface.SetTextPos(2, 3)
		surface.SetFont "BudgetLabel"
		surface.DrawText "Click window to play!"
	end
end

function PANEL:OnRemove()
	if (IsValid(self.InputPanel)) then
		self.InputPanel:Remove()
	end
end

vgui.Register("pluto_minigame_snake", PANEL, "EditablePanel")

