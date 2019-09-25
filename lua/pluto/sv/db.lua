return function(db)
	function db:onConnected()
		pprintf("Database connected!")
		hook.Run("PlutoDatabaseConnected", db)
	end

	function db:onConnectionFailed(err)
		pwarnf("Database disconnected. Reconnecting.")
		hook.Run("PlutoDatabaseConnectionFailed", err)
		self:connect()
	end

	db:connect()
end