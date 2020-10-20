hook.Add("PlutoDatabaseInitialize", "pluto_inv_init", function()
	pluto.db.instance(function(db)
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_tabs (
				idx int UNSIGNED NOT NULL AUTO_INCREMENT,
				owner BIGINT UNSIGNED NOT NULL,
				color INT UNSIGNED NOT NULL DEFAULT 0,
				tab_type varchar(16) NOT NULL DEFAULT "normal",
				name VARCHAR(16) NOT NULL,
				PRIMARY KEY(idx),
				INDEX USING HASH(owner)
			)
		]])
		mysql_query(db, [[
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
				untradeable tinyint(1) NOT NULL DEFAULT 0,

				original_owner BIGINT UNSIGNED NOT NULL,

				FOREIGN KEY(tab_id) REFERENCES pluto_tabs(idx) ON DELETE CASCADE,
				PRIMARY KEY(tab_id, tab_idx),
				INDEX USING HASH(tab_id),

				INDEX USING HASH(idx)
			)
		]])
		mysql_query(db, [[
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
		]])
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_craft_data (
				gun_index INT UNSIGNED NOT NULL,

				tier1 VARCHAR(16) NOT NULL,
				tier2 VARCHAR(16) NOT NULL,
				tier3 VARCHAR(16) NOT NULL,

				PRIMARY KEY(gun_index),

				FOREIGN KEY (gun_index) REFERENCES pluto_items(idx) ON DELETE CASCADE
			)
		]])
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_weapon_stats (
				gun_index INT UNSIGNED NOT NULL AUTO_INCREMENT,
				stat VARCHAR(16) NOT NULL,
				val BIGINT UNSIGNED NOT NULL,
				FOREIGN KEY (gun_index) REFERENCES pluto_items(idx) ON DELETE CASCADE,
				INDEX USING HASH(gun_index)
			)
		]])
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_stats (
				stat VARCHAR(16) NOT NULL,
				val BIGINT UNSIGNED NOT NULL,
				INDEX USING HASH(stat)
			)
		]])
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_currency_tab (
				owner BIGINT UNSIGNED NOT NULL,
				currency VARCHAR(8) NOT NULL,
				amount INT UNSIGNED NOT NULL DEFAULT 0,
				PRIMARY KEY(owner, currency),
				INDEX USING HASH(owner)
			)
		]])
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_map_vote (
				voter BIGINT UNSIGNED NOT NULL,
				liked BOOLEAN NOT NULL,
				mapname VARCHAR(32) NOT NULL,

				PRIMARY KEY(voter, mapname),
				INDEX USING HASH(mapname)
			)
		]])
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_map_info (
				mapname VARCHAR(32) NOT NULL,
				played INT UNSIGNED NOT NULL DEFAULT 0,

				PRIMARY KEY(mapname)
			)
		]])
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_nitro_rewards (
				steamid BIGINT UNSIGNED NOT NULL,
				reward_num SMALLINT UNSIGNED NOT NULL,
				assoc_discordid BIGINT UNSIGNED NOT NULL,

				PRIMARY KEY(steamid, reward_num),
				INDEX USING HASH(steamid)
			)
		]])
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_quests (
				idx INT UNSIGNED NOT NULL AUTO_INCREMENT,
				steamid BIGINT UNSIGNED NOT NULL,
				quest_id VARCHAR(16) NOT NULL,
				type TINYINT UNSIGNED NOT NULL,

				expiry_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
				progress_needed INT UNSIGNED NOT NULL,
				total_progress INT UNSIGNED NOT NULL,

				rand FLOAT NOT NULL,

				PRIMARY KEY(idx),
				UNIQUE(steamid, quest_id),
				INDEX USING HASH(steamid)
			)
		]])
	end)
end)
