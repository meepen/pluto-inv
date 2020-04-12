local classname = "tfa_cso_thanatos9"
local seqN = "shootA2"
local spinCycle = {0.3, 0.4}
local upVec = Vector(0, 0, 1)
local THANATOSSPIN = false
local THANATOSSPINVM = false

local function MyCalcView(ply, pos, angles, fov, ...)
	if THANATOSSPIN then return end
	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return end
	if string.lower(wep:GetClass()) ~= classname then return end
	if ply:ShouldDrawLocalPlayer() then return end
	local vm = ply:GetViewModel()
	if not IsValid(vm) then return end
	if vm:GetSequenceName(vm:GetSequence()) ~= seqN then return end
	local cyc = vm:GetCycle()
	if cyc < spinCycle[1] or cyc > spinCycle[2] then return end
	local cycleLen = spinCycle[2] - spinCycle[1]
	local rot = math.Clamp(vm:GetCycle() - spinCycle[1], 0, cycleLen) / cycleLen * 360
	THANATOSSPIN = true

	local view = hook.Run("CalcView", ply, pos, angles, fov, ...) or {
		["origin"] = pos,
		["angles"] = angles,
		["fov"] = fov
	}

	THANATOSSPIN = false
	view.angles:RotateAroundAxis(upVec, rot)

	return view
end

hook.Add("CalcView", "Thanatos9Spin", MyCalcView)

local function MyCalcVMView(wep, vm, oldpos, oldang, pos, ang, ...)
	if THANATOSSPINVM then return end
	local ply = GetViewEntity()
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end
	if not IsValid(wep) then return end
	if string.lower(wep:GetClass()) ~= classname then return end
	if vm:GetSequenceName(vm:GetSequence()) ~= seqN then return end
	local cyc = vm:GetCycle()
	if cyc < spinCycle[1] or cyc > spinCycle[2] then return end
	local cycleLen = spinCycle[2] - spinCycle[1]
	local rot = math.Clamp(vm:GetCycle() - spinCycle[1], 0, cycleLen) / cycleLen * 360
	THANATOSSPINVM = true
	local p, a = hook.Run("CalcViewModelView", wep, vm, oldpos, oldang, pos, ang, ...)
	p = p or pos
	a = a or ang
	THANATOSSPINVM = false
	a:RotateAroundAxis(upVec, rot)

	return p, a
end

hook.Add("CalcViewModelView", "Thanatos9Spin", MyCalcVMView)