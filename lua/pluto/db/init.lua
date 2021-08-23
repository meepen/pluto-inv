--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
hook.Add("PlutoDatabaseInitialize", "pluto_inv_init", function()
	pluto.db.instance(function(db)
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_tabs (
				idx int UNSIGNED NOT NULL AUTO_INCREMENT,
				owner BIGINT UNSIGNED NOT NULL,
				color INT UNSIGNED NOT NULL DEFAULT 0,
				tab_type varchar(16) NOT NULL DEFAULT "normal",
				tab_shape varchar(16) NOT NULL DEFAULT "square",
				name VARCHAR(16) NOT NULL,

				PRIMARY KEY(idx),
				INDEX steamid(owner)
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
				tab_idx INT UNSIGNED NOT NULL,

				locked tinyint(1) NOT NULL DEFAULT 0,
				untradeable tinyint(1) NOT NULL DEFAULT 0,

				original_owner BIGINT UNSIGNED NOT NULL,

				creation_method enum("DROPPED", "SPAWNED", "UNBOXED", "FOUND", "DELETE", "QUEST", "REWARD", "MIRROR", "CRAFT", "BOUGHT") NOT NULL DEFAULT "DROPPED",

				UNIQUE INDEX (tab_id, tab_idx),
				INDEX itemid(idx)
			)
		]])
		-- ALTER TABLE pluto_items DROP PRIMARY KEY;
		-- ALTER TABLE pluto_items ADD UNIQUE INDEX (tab_id, tab_idx);
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
				UNIQUE INDEX one_mod(gun_index, modname),
				INDEX itemid(gun_index),
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
		--[=[
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
		]=]
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_quests_new (
				idx INT UNSIGNED NOT NULL AUTO_INCREMENT,
				owner BIGINT UNSIGNED NOT NULL,
				quest_name VARCHAR(32) NOT NULL,
				reward JSON NOT NULL,
				type ENUM("unique", "hourly", "daily", "weekly") NOT NULL,

				expiry_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
				current_progress INT UNSIGNED NOT NULL,
				total_progress INT UNSIGNED NOT NULL,

				PRIMARY KEY(idx),
				UNIQUE(owner, quest_name),
				INDEX(owner)
			)
		]])
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_class_stats (
				classname VARCHAR(32) NOT NULL,
				date DATE NOT NULL DEFAULT (CURRENT_DATE),

				tracked INT UNSIGNED DEFAULT 0,
				rounds_used INT UNSIGNED DEFAULT 0,

				damage INT UNSIGNED DEFAULT 0,
				healed INT UNSIGNED DEFAULT 0,
				damage_taken INT UNSIGNED DEFAULT 0,

				fired INT UNSIGNED DEFAULT 0,
				missed INT UNSIGNED DEFAULT 0,

				headshots INT UNSIGNED DEFAULT 0,

				kills INT UNSIGNED DEFAULT 0,
				deaths INT UNSIGNED DEFAULT 0,
				assists INT UNSIGNED DEFAULT 0,
				hit_to_death INT UNSIGNED DEFAULT 0,

				ads_shots INT UNSIGNED DEFAULT 0,
				ads_hits INT UNSIGNED DEFAULT 0,
				crouch_shots INT UNSIGNED DEFAULT 0,
				crouch_hits INT UNSIGNED DEFAULT 0,
				jump_shots INT UNSIGNED DEFAULT 0,
				jump_hits INT UNSIGNED DEFAULT 0,

				mods INT UNSIGNED DEFAULT 0,
				mod_tiers INT UNSIGNED DEFAULT 0,

				currency_used INT UNSIGNED DEFAULT 0,

				PRIMARY KEY (classname, date),
				INDEX USING HASH(classname),
				INDEX (date)
			)
		]])

		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_trades (
				idx INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
				snapshot JSON NOT NULL,
				accepted TINYINT NOT NULL DEFAULT 0,
				version SMALLINT UNSIGNED DEFAULT 0
			)
		]])

		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_trades_players (
				trade_id INT UNSIGNED NOT NULL REFERENCES pluto_trades(idx) ON DELETE CASCADE,
				player BIGINT UNSIGNED NOT NULL,

				INDEX (trade_id),
				INDEX (player)
			)
		]])

		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_trades_items (
				trade_id INT UNSIGNED NOT NULL REFERENCES pluto_trades(idx) ON DELETE CASCADE,
				item_id BIGINT UNSIGNED NOT NULL,

				INDEX (trade_id),
				INDEX (item_id)
			)
		]])

		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_item_nodes (
				idx INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
				item_id INT UNSIGNED NOT NULL REFERENCES pluto_items(idx) ON DELETE CASCADE,

				node_bubble SMALLINT UNSIGNED NOT NULL,
				node_id SMALLINT UNSIGNED NOT NULL,
				node_unlocked TINYINT UNSIGNED NOT NULL DEFAULT 0,

				node_name VARCHAR(16) NOT NULL,

				node_val1 FLOAT NULL,
				node_val2 FLOAT NULL,
				node_val3 FLOAT NULL,

				UNIQUE INDEX (item_id, node_bubble, node_id),
				FOREIGN KEY(item_id) REFERENCES pluto_items(idx)
			)
		]])
		
		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_stardust_shop (
				id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
				item VARCHAR(64) NOT NULL,
				price INT UNSIGNED NOT NULL,
				endtime TIMESTAMP NOT NULL,
				bought INT UNSIGNED NOT NULL DEFAULT 0
			)
		]])

		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_auction_info (
				idx INT UNSIGNED NOT NULL,
				owner BIGINT UNSIGNED NOT NULL REFERENCES pluto_player_info(steamid),
				price INT UNSIGNED NOT NULL,
				listed TIMESTAMP NOT NULL,
				name VARCHAR(64) NOT NULL DEFAULT '',
				max_mods SMALLINT UNSIGNED NULL DEFAULT NULL,

				INDEX(name),
				INDEX(max_mods),
				INDEX USING HASH(owner),
				INDEX(price),
				INDEX(listed),
				UNIQUE INDEX(idx),
				FOREIGN KEY(idx) REFERENCES pluto_items(tab_idx)
			)
		]])

		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_class_kv (
				class VARCHAR(32) NOT NULL,
				k VARCHAR(16) NOT NULL,
				v varchar(32) NOT NULL,

				KEY v_index (v),

				UNIQUE KEY (class, k)
			)
		]])

		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_emoji_unlocks (
				steamid BIGINT UNSIGNED NOT NULL,
				name VARCHAR(32) NOT NULL,

				KEY (steamid),
				UNIQUE(steamid, name)
			)
		]])

		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_blackmarket (
				idx INT UNSIGNED NOT NULL PRIMARY KEY,
				date DATE NOT NULL, 
				what INT UNSIGNED NOT NULL,
				sold TINYINT UNSIGNED NOT NULL DEFAULT 0
			)
		]])

		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_round_queue (
				idx INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
				server VARCHAR(16) NOT NULL,
				time TIMESTAMP NOT NULL,
				name VARCHAR(32) NOT NULL,
				requester BIGINT UNSIGNED NOT NULL REFERENCES pluto_player_info(steamid),
				finished BOOLEAN NOT NULL DEFAULT FALSE,
				INDEX(time),
				INDEX(finished)
			)
		]])

		mysql_query(db, [[
			CREATE TABLE IF NOT EXISTS pluto_highscores (
				player BIGINT UNSIGNED NOT NULL,
				highscore VARCHAR(16) NOT NULL,
				score INT UNSIGNED NOT NULL DEFAULT 0,
				PRIMARY KEY(player, highscore),
				INDEX(score)
			)
		]])
	end)
end)
