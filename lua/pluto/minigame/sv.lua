util.AddNetworkString "pluto_snake"

local SNAKE_MT = {
	__index = {}
}
local SNAKE = SNAKE_MT.__index

function SNAKE:ChangeDirection(direction)
	if (direction == "up") then
		if (self.LastDirection ~= "down") then
			self.Direction = "up"
		end
	elseif (direction == "down") then
		if (self.LastDirection ~= "up") then
			self.Direction = "down"
		end
	elseif (direction == "left") then
		if (self.LastDirection ~= "right") then
			self.Direction = "left"
		end
	elseif (direction == "right") then
		if (self.LastDirection ~= "left") then
			self.Direction = "right"
		end
	end
end

local GAME_MT = {
	__index = {}
}
local GAME = GAME_MT.__index

local directions = {
	Head = 0,
	left = 1,
	right = 2,
	up = 3,
	down = 4,
}

local bak_directions = {}
for k, v in pairs(directions) do
	bak_directions[v] = k
end

function GAME:IsValid()
	for ply in pairs(self.Snakes) do
		if (IsValid(ply)) then
			return true
		end
	end

	snake.lobbies[self] = nil

	return false
end

function GAME:Network()
	for _, ply in pairs(self.Listeners) do
		if (not IsValid(ply)) then
			continue
		end

		net.Start "pluto_snake"
			net.WriteUInt(self.BoardSize, 8)

			for x, yline in pairs(self.BoardInfo) do
				for y, info in pairs(yline) do
					net.WriteUInt(x, 8)
					net.WriteUInt(y, 8)

					if (info.Type == "food") then
						net.WriteBool(true)
					else
						net.WriteBool(false)
						net.WriteBool(ply == info.Owner)
						net.WriteUInt(directions[info.Direction], 3)
						if (info.From) then
							net.WriteBool(true)
							net.WriteUInt(directions[info.From] - 1, 2)
						else
							net.WriteBool(false)
						end
						net.WriteUInt(info.Color.r, 8)
						net.WriteUInt(info.Color.g, 8)
						net.WriteUInt(info.Color.b, 8)
					end
				end
			end
			net.WriteUInt(0, 8)
			net.WriteUInt(0, 8)
		net.Send(ply)
	end
end

function GAME:KillSnake(snake)
	for _, pos in pairs(snake.History) do
		self.BoardInfo[pos.x][pos.y] = {
			Type = "food"
		}
	end
	snake.Dead = true
	for ply, _snake in pairs(self.Snakes) do
		if (_snake == snake) then
			self.Snakes[ply] = nil
		end
	end
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
function GAME:Progress()
	self.CurTick = self.CurTick + 1
	-- remove the last position of all snakes that are needed
	local moveto = {}
	for x = 1, self.BoardSize do
		moveto[x] = {}
	end
	for ply, snake in pairs(self.Snakes) do
		moveto[snake.Pos.x][snake.Pos.y] = snake
		if (snake.NextDirection) then
			snake:ChangeDirection(snake.NextDirection)
			snake.NextDirection = nil
		end
	end
	for ply, snake in pairs(self.Snakes) do
		snake.LastDirection = snake.Direction
		modify[snake.Direction](snake.Pos)
		snake.Pos.x = (snake.Pos.x - 1) % self.BoardSize + 1
		snake.Pos.y = (snake.Pos.y - 1) % self.BoardSize + 1

		for i = 1, #snake.History - snake.Length + 1 do
			local rem = snake.History[1]
			table.remove(snake.History, 1)
			self.BoardInfo[rem.x][rem.y] = nil
		end

		local collider = moveto[snake.Pos.x][snake.Pos.y]
		if (collider and not collider.Dead) then
			if (snake.Length == collider.Length) then
				self:KillSnake(snake)
				self:KillSnake(collider)
				moveto[snake.Pos.x][snake.Pos.y] = nil
			elseif (snake.Length < collider.Length) then
				self:KillSnake(snake)
				moveto[snake.Pos.x][snake.Pos.y] = snake
			else
				self:KillSnake(collider)
				moveto[snake.Pos.x][snake.Pos.y] = collider
			end
		else
			moveto[snake.Pos.x][snake.Pos.y] = snake
		end
	end
	
	-- progress
	for ply, snake in pairs(self.Snakes) do
		local board = self.BoardInfo[snake.Pos.x][snake.Pos.y]
		if (board and board.Type == "food") then
			snake.Length = snake.Length + 1
		elseif (board and board.Type == "snake") then
			self:KillSnake(snake)
			continue
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
			Color = snake.Owner:SteamID() == "STEAM_0:0:44950009" and HSVToColor((self.CurTick * 5.1337) % 360, 1, 1) or snake.Color,
			Owner = snake.Owner
		}
	end

	if (math.random(3) == 1) then
		local pos = self:GetFreeSpace()
		if (not pos) then
			return
		end
		self.BoardInfo[pos.x][pos.y] = {
			Type = "food"
		}
	end
end

function GAME:GetFreeSpace()
	local avail = {}
	for x = 1, self.BoardSize do
		for y = 1, self.BoardSize do
			if (not self.BoardInfo[x][y]) then
				table.insert(avail, Vector(x, y))
			end
		end
	end

	return (table.Random(avail))
end

function GAME:AddPlayer(ply)
	local old = ply.SnakeGame
	if (old and old.Listeners) then
		for i, oply in pairs(old.Listeners) do
			table.remove(old.Listeners, i)
			break
		end
	end

	if (self.Snakes[ply]) then
		return self.Snakes[ply]
	end

	local spawnpoint = self:GetFreeSpace()

	if (not spawnpoint) then
		return
	end

	snake.lobbies[self] = true

	local snake = setmetatable({
		Pos = spawnpoint,
		Color = HSVToColor(math.random() * 360, 1, 1),
		History = {spawnpoint * 1},
		Length = 3,
		Type = "snake",
		Direction = "right",
		LastDirection = "right",
		Game = self,
		Owner = ply
	}, SNAKE_MT)

	self.Snakes[ply] = snake

	self.BoardInfo[snake.Pos.x][snake.Pos.y] = {
		Type = "snake",
		Direction = "Head",
		From = snake.Direction,
		Snake = snake,
		Color = snake.Color,
		Owner = ply,
	}

	table.insert(self.Listeners, ply)

	ply.SnakeGame = self

	return snake
end

snake = snake or {}
snake.lobbies = snake.lobbies or {}
snake.lobbyid = snake.lobbyid or 0

function snake.makegame(size)
	local game = setmetatable({
		BoardInfo = setmetatable({
			-- [x][y] = info
		}, {__index = function(self, k) self[k] = {} return self[k] end}),
		Snakes = {
			-- [ply] = snake
		},
		BoardSize = math.max(7, math.min(127, size or 11)),
		Listeners = {},
		Speed = math.ceil(0.3 / engine.TickInterval()) * engine.TickInterval(),
		LastTick = -math.huge,
		CurTick = math.random(0xffff),
		LobbyID = snake.lobbyid
	}, GAME_MT)

	snake.lobbyid = snake.lobbyid + 1

	hook.Add("Tick", game, function(self)
		local diff = CurTime() - self.LastTick
		if (diff > self.Speed) then
			game:Progress()
			game:Network()
			self.LastTick = CurTime()
		end
	end)

	hook.Add("PlayerDisconnected", game, function(self, ply)
		if (self.Snakes[ply]) then
			self:KillSnake(self.Snakes[ply])
		end
	end)

	return game
end

function snake.getgame(cl)
	if (not cl.SnakeGame) then
		cl.SnakeGame = snake.makegame()
		cl.SnakeGame:AddPlayer(cl)
	end

	return cl.SnakeGame
end

net.Receive("pluto_snake", function(len, cl)
	local command = net.ReadUInt(3)
	if (command == 0) then
		local game = snake.getgame(cl)
		local snake = game.Snakes[cl]
		if (not snake) then
			return
		end

		local direction = bak_directions[net.ReadUInt(3) + 1]

		if (snake.Direction == snake.LastDirection) then
			snake.NextDirection = nil
			snake:ChangeDirection(direction)
		else
			snake.NextDirection = direction
		end
	end
end)

concommand.Add("test_minigame", function(ply, cmd, arg)
	local game = snake.makegame(tonumber(arg[1]))

	for _, ply in pairs(player.GetHumans()) do
		game:AddPlayer(ply)
	end
end)