imgur = imgur or {}
local auth = "Client-ID 3693fd6ea039830" -- who and what is this

function imgur.image(img, name, title, desc)
	return Promise(function(res, rej)
		HTTP {
			url = "https://api.imgur.com/3/image",
			method = "post",
			headers = {
				Authorization = auth,
			},
			success = function(_, c, _, _)
				local album = util.JSONToTable(c)
				if (not album or not album.success) then
					rej(album)
					return
				end

				res(album)
			end,
			failed = function(a)
				rej(a)
			end,
			parameters = {
				image = util.Base64Encode(img),
				title = title,
				description = desc,
				name = name,
			},
		}
	end)
end
