TOOL.Category = "GWater2"
TOOL.Name = "#Tool.gwater2_transmuter.name"

if CLIENT then
	language.Add("Tool.gwater2_transmuter.name", "Transmuter")
	language.Add("Tool.gwater2_transmuter.desc", "Turns props into liquid")

	TOOL.Information = {
		{name = "left"},
	}

	language.Add("Tool.gwater2_transmuter.left", "Turns props into liquid.  Complex models may lag!")
end

function TOOL:LeftClick(trace)
	local ent = trace.Entity
	if ent:IsWorld() or ent:IsPlayer() then 	-- no fun allowed
		return false 
	end

	if SERVER then
		local phys = ent:GetPhysicsObject()
		if !IsValid(phys) then return end

		local transform = gwater2.quick_matrix(phys:GetPos(), phys:GetAngles())
		local model = ent:GetModel()
		local extra = {
			ent_vel = phys:GetVelocity() * FrameTime(),
			ent_angvel = phys:GetAngleVelocity() * FrameTime()
		}

		phys:EnableMotion(false)
		ent:SetNotSolid(true)
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
		--ent:Remove()

		-- net is too fast and can explode sometimes
		timer.Simple(0, function()
			gwater2.AddModel(transform, model, extra)
			SafeRemoveEntity(ent)
		end)
	end

	return true
end