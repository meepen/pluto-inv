--hack to make my editor not dum
do
	--
end

local json = {}


-- Internal functions.

local function kind_of(obj)
  if type(obj) ~= 'table' then return type(obj) end
  local i = 1
  for _ in pairs(obj) do
    if obj[i] ~= nil then i = i + 1 else return 'table' end
  end
  if i == 1 then return 'table' else return 'array' end
end

local function escape_str(s)
  local in_char  = {'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}
  local out_char = {'\\', '"', '/',  'b',  'f',  'n',  'r',  't'}
  for i, c in ipairs(in_char) do
    s = s:gsub(c, '\\' .. out_char[i])
  end
  return s
end

-- Returns pos, did_find; there are two cases:
-- 1. Delimiter found: pos = pos after leading space + delim; did_find = true.
-- 2. Delimiter not found: pos = pos after leading space;     did_find = false.
-- This throws an error if err_if_missing is true and the delim is not found.
local function skip_delim(str, pos, delim, err_if_missing)
  pos = pos + #str:match('^%s*', pos)
  if str:sub(pos, pos) ~= delim then
    if err_if_missing then
      error('Expected ' .. delim .. ' near position ' .. pos)
    end
    return pos, false
  end
  return pos + 1, true
end

-- Expects the given pos to be the first character after the opening quote.
-- Returns val, pos; the returned pos is after the closing quote character.
local function parse_str_val(str, pos, val)
  val = val or ''
  local early_end_error = 'End of input found while parsing string.'
  if pos > #str then error(early_end_error) end
  local c = str:sub(pos, pos)
  if c == '"'  then return val, pos + 1 end
  if c ~= '\\' then return parse_str_val(str, pos + 1, val .. c) end
  -- We must have a \ character.
  local esc_map = {b = '\b', f = '\f', n = '\n', r = '\r', t = '\t'}
  local nextc = str:sub(pos + 1, pos + 1)
  if not nextc then error(early_end_error) end
  return parse_str_val(str, pos + 2, val .. (esc_map[nextc] or nextc))
end

-- Returns val, pos; the returned pos is after the number's final character.
local function parse_num_val(str, pos)
  local num_str = str:match('^-?%d+%.?%d*[eE]?[+-]?%d*', pos)
  local val = tonumber(num_str)
  if not val then error('Error parsing number at position ' .. pos .. '.') end
  return val, pos + #num_str
end


-- Public values and functions.

function json.stringify(obj, as_key)
  local s = {}  -- We'll build the string as an array of strings to be concatenated.
  local kind = kind_of(obj)  -- This is 'array' if it's an array or type(obj) otherwise.
  if kind == 'array' then
    if as_key then error('Can\'t encode array as key.') end
    s[#s + 1] = '['
    for i, val in ipairs(obj) do
      if i > 1 then s[#s + 1] = ', ' end
      s[#s + 1] = json.stringify(val)
    end
    s[#s + 1] = ']'
  elseif kind == 'table' then
    if as_key then error('Can\'t encode table as key.') end
    s[#s + 1] = '{'
    for k, v in pairs(obj) do
      if #s > 1 then s[#s + 1] = ', ' end
      s[#s + 1] = json.stringify(k, true)
      s[#s + 1] = ':'
      s[#s + 1] = json.stringify(v)
    end
    s[#s + 1] = '}'
  elseif kind == 'string' then
    return '"' .. escape_str(obj) .. '"'
  elseif kind == 'number' then
    if as_key then return '"' .. tostring(obj) .. '"' end
    return tostring(obj)
  elseif kind == 'boolean' then
    return tostring(obj)
  elseif kind == 'nil' then
    return 'null'
  else
    error('Unjsonifiable type: ' .. kind .. '.')
  end
  return table.concat(s)
end

json.null = {}  -- This is a one-off table to represent the null value.

function json.parse(str, pos, end_delim)
  pos = pos or 1
  if pos > #str then error('Reached unexpected end of input.') end
  local pos = pos + #str:match('^%s*', pos)  -- Skip whitespace.
  local first = str:sub(pos, pos)
  if first == '{' then  -- Parse an object.
    local obj, key, delim_found = {}, true, true
    pos = pos + 1
    while true do
      key, pos = json.parse(str, pos, '}')
      if key == nil then return obj, pos end
      if not delim_found then error('Comma missing between object items.') end
      pos = skip_delim(str, pos, ':', true)  -- true -> error if missing.
      obj[key], pos = json.parse(str, pos)
      pos, delim_found = skip_delim(str, pos, ',')
    end
  elseif first == '[' then  -- Parse an array.
    local arr, val, delim_found = {}, true, true
    pos = pos + 1
    while true do
      val, pos = json.parse(str, pos, ']')
      if val == nil then return arr, pos end
      if not delim_found then error('Comma missing between array items.') end
      arr[#arr + 1] = val
      pos, delim_found = skip_delim(str, pos, ',')
    end
  elseif first == '"' then  -- Parse a string.
    return parse_str_val(str, pos + 1)
  elseif first == '-' or first:match('%d') then  -- Parse a number.
    return parse_num_val(str, pos)
  elseif first == end_delim then  -- End of an object or array.
    return nil, pos + 1
  else  -- Parse true, false, or null.
    local literals = {['true'] = true, ['false'] = false, ['null'] = json.null}
    for lit_str, lit_val in pairs(literals) do
      local lit_end = pos + #lit_str - 1
      if str:sub(pos, lit_end) == lit_str then return lit_val, lit_end + 1 end
    end
    local pos_info_str = 'position ' .. pos .. ': ' .. str:sub(pos, pos + 10)
    error('Invalid json syntax starting at ' .. pos_info_str)
  end
end

local function trademsg(noalive, ...)
	if (not noalive or not LocalPlayer():Alive() or ttt.GetRoundState() ~= ttt.ROUNDSTATE_ACTIVE) then
		chat.AddText(white_text, "[", ttt.teams.traitor.Color, "TRADE", white_text, "] ", ttt.teams.innocent.Color, ...)
	end
end

local function tradeevent(event, ...)
	hook.Run(event, ...)
	if (not pluto.trade) then
		return
	end

	table.insert(pluto.trade.Events, {Event = event, ...})
end

local curve = pluto.ui.curve
local count = 6

function pluto.inv.writetrademessage(msg)
	net.WriteString(msg)
end

function pluto.inv.writegettrades(who)
	net.WriteString(who)
end

function pluto.inv.writetradeaccept(accepted, cancel)
	net.WriteBool(accepted)
	net.WriteBool(cancel)
end

function pluto.inv.writetradeupdate(tab)
	local items, currencies = tab.Items, tab.Currency
	net.WriteUInt(table.Count(currencies), 3)
	for currency, amount in pairs(currencies) do
		net.WriteString(currency)
		net.WriteUInt(amount, 32)
	end

	net.WriteUInt(table.Count(tab.Items), 4)
	for i, item in pairs(tab.Items) do
		net.WriteUInt(i, 4)
		net.WriteUInt(item.ID, 32)
	end
end

function pluto.inv.writetraderequest(ply)
	net.WriteEntity(ply)
end

function pluto.inv.writegettradesnapshot(id)
	net.WriteUInt(id, 32)
end

function pluto.inv.readtradelogsnapshot()
	local id = net.ReadUInt(32)
	local len = net.ReadUInt(32)
	local data = util.Decompress(net.ReadData(len))

	hook.Run("PlutoTradeLogSnapshot", id, data)
end

function pluto.inv.readtradelogresults(recv)
	local trades = {}
	for i = 1, net.ReadUInt(32) do
		local trade = {}
		trades[i] = trade
		trade.ID = net.ReadUInt(32)
		trade.p1name = net.ReadString()
		trade.p1steamid = net.ReadString()
		trade.p2name = net.ReadString()
		trade.p2steamid = net.ReadString()
	end

	hook.Run("PlutoPastTradesReceived", trades)
end

function pluto.inv.readtradeaccept()
	local accepted = net.ReadBool()
	hook.Run("PlutoTradeAccept", accepted)
	trademsg(true, IsValid(pluto.trade.Other) and pluto.trade.Other:Nick() or "Other Player", accepted and " is ready to accept" or " is no longer ready to accept")
end

function pluto.inv.readtrademessage()
	local ply = net.ReadEntity()
	local msg = net.ReadString()

	trademsg(true, ply:Nick(), ": ", white_text, msg)
	tradeevent("PlutoTradeMessage", ply, msg)
end

function pluto.inv.readtradeupdate()
	local trade

	if (net.ReadBool()) then
		trade = {
			Currency = {},
			Items = {},
			Other = net.ReadEntity(),
			Events = {},
		}

		for i = 1, net.ReadUInt(3) do
			trade.Currency[net.ReadString()] = net.ReadUInt(32)
		end

		for i = 1, net.ReadUInt(4) do
			trade.Items[net.ReadUInt(4)] = pluto.inv.readitem()
		end

		trade.CanAccept = net.ReadBool()
	else
		trademsg(false, "Trade" .. (pluto.trade and IsValid(pluto.trade.Other) and " with " .. pluto.trade.Other:Nick() or "") .. " ended")
	end

	if (not pluto.trade and trade) then
		table.Empty(pluto.tradetab.Items)
		table.Empty(pluto.tradetab.Currency)
	end

	if (not pluto.trade) then
		trademsg(false, "Trade with ", trade.Other:Nick(), " opened")
	end

	pluto.trade = trade
	
	tradeevent("PlutoTradeUpdate", trade)
end
