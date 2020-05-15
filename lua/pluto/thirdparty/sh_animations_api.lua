--[[
A simple animations API
	Written by Stalker (http://steamcommunity.com/profiles/76561197996451757/)
	For Kuma (http://steamcommunity.com/profiles/76561198061335920/)
Documentation:
	All of the functions are serverside only.
	Player:StartAnimation(number or string, boolean, function, number)
		-- Arg One: Either the name of a sequence or the ACT_ enum of an animation.
		-- Arg Two: While they are performing this animation
					should we freeze their movement. (Optional, false by default).
		-- Arg Three:	If time is specified this function will be called when the animation is over.
						Called only on the server.
		-- Arg Four: Set this to false to play indefinitely
		-- Arg Five: Arg four is true and this is not set it will play for the length of the animation.
						If this arg is set then it will play for that amount of time.
	Player:StopAnimation()
		-- Stops the currently playing animation.
	Player:GetAnimationLength(string or number)
		-- Arg One: Either the name of a sequence or the ACT_ enum of an animation.
		-- Returns: The length of the animation in seconds.
]]

if SERVER then
	local PLAYER = FindMetaTable("Player")

	function PLAYER:StartAnimation(anim, freeze, callback, HasTime, time)
		self:StopAnimation()

		if type(anim) == "number" then
			self:SetNW2Int("anims_act", anim)
			self:SetNW2Int("anims_seq", -1)
		elseif type(anim) == "string" then
			local seqid = self:LookupSequence(anim)

			if seqid then
				self:SetNW2Int("anims_act", -1)
				self:SetNW2Int("anims_seq", seqid)
			else
				return
			end
		end

		if freeze then
			self:SetNW2Bool("anims_freeze", true)
		end

		if type(callback) == "function" then
			self.AnimCallback = callback
		end

		if HasTime then
			time = isnumber(time) and time or self:GetAnimationLength(anim)
			time = time + CurTime() - 1
		else
			time = -1
		end
		self:SetNW2Float("anims_time", time)
		self:SetNW2Bool("anims_start", true)
		self:SetNW2Bool("anims_hasanim", true)
	end

	function PLAYER:StopAnimation()
		self:SetNW2Bool("anims_hasanim", false)
		self:SetNW2Int("anims_act", -1)
		self:SetNW2Int("anims_seq", -1)
		self:SetNW2Bool("anims_freeze", false)

		self:AnimRestartMainSequence()
	end

	function PLAYER:GetAnimationLength(anim)
		local seqid = -1

		if type(anim) == "number" then
			seqid = self:SelectWeightedSequence(anim)
		elseif type(anim) == "string" then
			seqid = self:LookupSequence(anim)
		end

		return self:SequenceDuration(seqid)
	end
end

hook.Add("CalcMainActivity", "AnimationsAPI", function(ply, velocity)
	if (ply.IsProne and ply:IsProne()) or not ply:GetNW2Bool("anims_hasanim", false) then
		return
	end

	local act = ply:GetNW2Int("anims_act", -1)
	local seqid = ply:GetNW2Int("anims_seq", -1)
	local time = ply:GetNW2Float("anims_time", -1)

	if ply:GetNW2Bool("anims_start", false) then
		ply:SetNW2Bool("anims_start", false)
		ply:SetCycle(0)
	end

	if time >= 0 and CurTime() >= time then
		if SERVER then
			if type(ply.AnimCallback) == "function" then
				ply:AnimCallback()
			end
			ply:StopAnimation()
			return
		end
	end

	if type(act) == "number" and act > -1 then
		return act, -1
	elseif type(seqid) == "number" and seqid > -1 then
		return -1, seqid
	end
end)

hook.Add("UpdateAnimation", "AnimationsAPI", function(ply, velocity, maxSeqGroundSpeed)
	if ply:GetNW2Bool("anims_hasanim", false) then
		ply:SetPlaybackRate(1)
	end
end)

hook.Add("SetupMove", "AnimationsAPI", function(ply, cmd)
	if ply:GetNW2Bool("anims_freeze", false) then
		cmd:SetForwardSpeed(0)
		cmd:SetSideSpeed(0)
	end
end)