hook.Add("PlutoDatabaseInitialize", "pluto_db_init", function(db)
	pluto.db.transact {
		{
			[[
				CREATE TABLE IF NOT EXISTS pluto_weapons (
					idx INT UNSIGNED NOT NULL AUTO_INCREMENT,
					id BIGINT UNSIGNED NOT NULL,
					owner BIGINT UNSIGNED NOT NULL,
					tier VARCHAR(16) NOT NULL,
					class VARCHAR(32) NOT NULL,
					PRIMARY KEY(id),
					INDEX(idx),
					INDEX(owner)
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
					PRIMARY KEY(idx),
					FOREIGN KEY (gun_index) REFERENCES pluto_weapons(idx) ON DELETE CASCADE
				)
			]]
		}
	} -- :wait(true)
end)
