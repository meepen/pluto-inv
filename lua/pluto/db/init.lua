hook.Add("PlutoDatabaseInitialize", "pluto_inv_init", function(db)
	pluto.db.transact {
		{
			[[
				CREATE TABLE IF NOT EXISTS pluto_tabs (
					idx int UNSIGNED NOT NULL AUTO_INCREMENT,
					owner BIGINT UNSIGNED NOT NULL,
					color INT UNSIGNED NOT NULL DEFAULT 0,
					tab_type varchar(16) NOT NULL DEFAULT "normal",
					name VARCHAR(16) NOT NULL,
					PRIMARY KEY(idx),
					INDEX USING HASH(owner)
				)
			]]
		},
		{
			[[
				CREATE TABLE IF NOT EXISTS pluto_items (
					idx INT UNSIGNED NOT NULL AUTO_INCREMENT,
					tier VARCHAR(16) NOT NULL,
					class VARCHAR(32) NOT NULL,
					nick VARCHAR(32) NULL,
					special_name VARCHAR(32) NULL,
					exp INT UNSIGNED NOT NULL DEFAULT 0,
	
					tab_id INT UNSIGNED NOT NULL,
					tab_idx TINYINT UNSIGNED NOT NULL,

					locked tinyint(1) NOT NULL DEFAULT 0,
	
					FOREIGN KEY(tab_id) REFERENCES pluto_tabs(idx) ON DELETE CASCADE,
					PRIMARY KEY(tab_id, tab_idx),
					INDEX USING HASH(tab_id),
	
					INDEX USING HASH(idx)
				)
			]]
		},
		{
			[[
				CREATE TABLE IF NOT EXISTS pluto_mods (
					idx INT UNSIGNED NOT NULL AUTO_INCREMENT,
					gun_index INT UNSIGNED NOT NULL,
					modname VARCHAR(16) NOT NULL,
					tier TINYINT UNSIGNED NOT NULL,
					roll1 FLOAT,
					roll2 FLOAT,
					roll3 FLOAT,
	
					deleted BOOLEAN NOT NULL DEFAULT FALSE,
					PRIMARY KEY(idx),
					UNIQUE(gun_index, modname),
					INDEX USING HASH(gun_index),
					FOREIGN KEY (gun_index) REFERENCES pluto_items(idx) ON DELETE CASCADE
				)
			]]
		},
		{
			[[
				CREATE TABLE IF NOT EXISTS pluto_craft_data (
					gun_index INT UNSIGNED NOT NULL,

					tier1 VARCHAR(16) NOT NULL,
					tier2 VARCHAR(16) NOT NULL,
					tier3 VARCHAR(16) NOT NULL,

					PRIMARY KEY(gun_index),

					FOREIGN KEY (gun_index) REFERENCES pluto_items(idx) ON DELETE CASCADE
				)
			]]
		},
		{
			[[
				CREATE TABLE IF NOT EXISTS pluto_weapon_stats (
					gun_index INT UNSIGNED NOT NULL AUTO_INCREMENT,
					stat VARCHAR(16) NOT NULL,
					val BIGINT UNSIGNED NOT NULL,
					FOREIGN KEY (gun_index) REFERENCES pluto_items(idx) ON DELETE CASCADE,
					INDEX USING HASH(gun_index)
				)
			]]
		},
		{
			[[
				CREATE TABLE IF NOT EXISTS pluto_stats (
					stat VARCHAR(16) NOT NULL,
					val BIGINT UNSIGNED NOT NULL,
					INDEX USING HASH(stat)
				)
			]]
		},
		{
			[[
				CREATE TABLE IF NOT EXISTS pluto_currency_tab (
					owner BIGINT UNSIGNED NOT NULL,
					currency VARCHAR(8) NOT NULL,
					amount INT UNSIGNED NOT NULL DEFAULT 0,
					PRIMARY KEY(owner, currency),
					INDEX USING HASH(owner)
				)
			]]
		},
		{
			[[
				CREATE TABLE IF NOT EXISTS pluto_map_vote (
					voter BIGINT UNSIGNED NOT NULL,
					liked BOOLEAN NOT NULL,
					mapname VARCHAR(32) NOT NULL,

					PRIMARY KEY(voter, mapname),
					INDEX USING HASH(mapname)
				)
			]]
		},
		{
			[[
				CREATE TABLE IF NOT EXISTS pluto_map_info (
					mapname VARCHAR(32) NOT NULL,
					played INT UNSIGNED NOT NULL DEFAULT 0,

					PRIMARY KEY(mapname)
				)
			]]
		},
	}:wait(true)

	local queries = {
		[[
			CREATE TABLE IF NOT EXISTS pluto_items (
				idx INTEGER PRIMARY KEY AUTOINCREMENT,
				tier VARCHAR(16) NOT NULL,
				class VARCHAR(32) NOT NULL,
				owner BIGINT UNSIGNED NOT NULL
			)
		]],
		[[CREATE INDEX IF NOT EXISTS item_index ON pluto_items (owner)]],
		[[
			CREATE TABLE IF NOT EXISTS pluto_mods (
				gun_index INT UNSIGNED NOT NULL,
				modname VARCHAR(16) NOT NULL,
				tier TINYINT UNSIGNED NOT NULL,
				roll1 FLOAT,
				roll2 FLOAT,
				roll3 FLOAT,
				FOREIGN KEY (gun_index) REFERENCES pluto_items(idx) ON DELETE CASCADE
			)
		]],
		[[CREATE INDEX IF NOT EXISTS mod_index ON pluto_mods (gun_index)]]
	}
	for _, query in ipairs(queries) do
		sql.Query(query)
	end
end)

hook.Add("CheckPassword", "pluto_db", function()
	RunConsoleCommand("sv_hibernate_think", GetConVar("sv_hibernate_think"):GetInt() + 1)
	pluto.db.db:ping()
	RunConsoleCommand("sv_hibernate_think", GetConVar("sv_hibernate_think"):GetInt() - 1)
end)