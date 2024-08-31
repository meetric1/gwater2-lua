
local GWATER2_PARTICLES_TO_SWIM = 30

-- swim code provided by kodya (with permission)
local gravity_convar = GetConVar("sv_gravity")
local function in_water(ply) 
	if ply:OnGround() then return false end
	return ply.GWATER2_CONTACTS and ply.GWATER2_CONTACTS >= GWATER2_PARTICLES_TO_SWIM
end

hook.Add("CalcMainActivity", "gwater2_swimming", function(ply)
	if !in_water(ply) or ply:InVehicle() then return end
	return ACT_MP_SWIM, -1
end)

hook.Add("Move", "gwater2_swimming", function(ply, move)
	if !in_water(ply) then return end

	local vel = move:GetVelocity()
	local ang = move:GetMoveAngles()

	local acel =
	(ang:Forward() * move:GetForwardSpeed()) +
	(ang:Right() * move:GetSideSpeed()) +
	(ang:Up() * move:GetUpSpeed())

	local aceldir = acel:GetNormalized()
	local acelspeed = math.min(acel:Length(), ply:GetMaxSpeed())
	acel = aceldir * acelspeed * 2

	if bit.band(move:GetButtons(), IN_JUMP) ~= 0 then
		acel.z = acel.z + ply:GetMaxSpeed()
	end

	vel = vel + acel * FrameTime()
	vel = vel * (1 - FrameTime() * 2)

	local pgrav = ply:GetGravity() == 0 and 1 or ply:GetGravity()
	local gravity = pgrav * gravity_convar:GetFloat() * 0.5
	vel.z = vel.z + FrameTime() * gravity

	move:SetVelocity(vel * 0.99)
end)

hook.Add("FinishMove", "gwater2_swimming", function(ply, move)
	if !in_water(ply) then return end
	local vel = move:GetVelocity()
	local pgrav = ply:GetGravity() == 0 and 1 or ply:GetGravity()
	local gravity = pgrav * gravity_convar:GetFloat() * 0.5

	vel.z = vel.z + FrameTime() * gravity
	move:SetVelocity(vel)
end)

-- cancel fall damage when in water
hook.Add("GetFallDamage", "gwater2_swimming", function(ply, speed)
	if !ply.GWATER2_CONTACTS or ply.GWATER2_CONTACTS < GWATER2_PARTICLES_TO_SWIM then return end

	ply:EmitSound("Physics.WaterSplash")
	return 0
end)

return in_water