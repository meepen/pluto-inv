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

	function PLAYER:StartAnimation(anim, isidle)
		self:StopAnimation()

		self:SetNW2Bool("anims_isidle", isidle)
		if (type(anim) == "number") then
			self:SetNW2Int("anims_act", anim)
		elseif (type(anim) == "string" and self:LookupSequence(anim)) then
			self:SetNW2Int("anims_act", self:GetSequenceActivity(self:LookupSequence(anim)))
		else
			self:SetNW2Int("anims_act", -1)
			return
		end

		if HasTime then
			time = isnumber(time) and time or self:GetAnimationLength(anim)
			time = time + CurTime() - 1
		else
			time = -1
		end
	end

	function PLAYER:StopAnimation()
		self:SetNW2Int("anims_act", -1)
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

hook.Add("UpdateAnimation", "AnimationsAPI", function(ply)
	local act = ply:GetNW2Int("anims_act", -1)

	ply.AnimationAPIWeight = ply.AnimationAPIWeight or 0

	-- Don't show this when we're playing a taunt!
	if (ply:IsPlayingTaunt() or ply:GetNW2Bool("anims_isidle", false)) then
		return
	end

	if (act ~= -1) then
		ply.AnimationAPIWeight = math.Approach(ply.AnimationAPIWeight, 1, FrameTime() * 5.0)
		ply.LastAnimationAPIAct = act
	else
		ply.AnimationAPIWeight = math.Approach(ply.AnimationAPIWeight, 0, FrameTime() * 5.0)
	end

	if (ply.AnimationAPIWeight > 0) then
		ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, act ~= -1 and act or ply.LastAnimationAPIAct, true)
		ply:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, ply.AnimationAPIWeight)
	end
end)