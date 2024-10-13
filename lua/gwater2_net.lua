AddCSLuaFile()

if SERVER then
	util.AddNetworkString("GWATER2_ADDCLOTH")
	util.AddNetworkString("GWATER2_ADDPARTICLE")
	util.AddNetworkString("GWATER2_ADDCUBE")
	util.AddNetworkString("GWATER2_ADDCYLINDER")
	util.AddNetworkString("GWATER2_ADDSPHERE")
	util.AddNetworkString("GWATER2_ADDMODEL")

	gwater2 = {
		AddCloth = function(translation, size, particle_data)
			net.Start("GWATER2_ADDCLOTH")
				net.WriteMatrix(translation)
				net.WriteUInt(size[1], 8)
				net.WriteUInt(size[2], 8)
				net.WriteTable(particle_data or {}) -- empty table only takes 3 bits
			net.Broadcast()
		end,

		AddCylinder = function(translation, size, particle_data)
			net.Start("GWATER2_ADDCYLINDER")
				net.WriteMatrix(translation)
				net.WriteUInt(size[1], 8)
				net.WriteUInt(size[2], 8)
				net.WriteUInt(size[3], 8)
				net.WriteTable(particle_data or {})
			net.Broadcast()
		end,

		AddSphere = function(translation, radius, particle_data)
			net.Start("GWATER2_ADDSPHERE")
				net.WriteMatrix(translation)
				net.WriteUInt(radius, 8)
				net.WriteTable(particle_data or {})
			net.Broadcast()
		end,

		AddCube = function(translation, size, particle_data)
			net.Start("GWATER2_ADDCUBE")
				net.WriteMatrix(translation)
				net.WriteUInt(size[1], 8)
				net.WriteUInt(size[2], 8)
				net.WriteUInt(size[3], 8)
				net.WriteTable(particle_data or {})
			net.Broadcast()
		end,
		
		AddParticle = function(pos, particle_data)
			net.Start("GWATER2_ADDPARTICLE")
				net.WriteVector(pos)
				net.WriteTable(particle_data or {})
			net.Broadcast()
		end,

		AddModel = function(translation, model, particle_data)
			net.Start("GWATER2_ADDMODEL")
				net.WriteMatrix(translation)
				net.WriteString(model)
				net.WriteTable(particle_data or {})
			net.Broadcast()
		end,

		quick_matrix = function(pos, ang, scale)
			local mat = Matrix()
			if pos then mat:SetTranslation(pos) end
			if ang then mat:SetAngles(ang) end
			if scale then mat:SetScale(Vector(1, 1, 1) * scale) end
			return mat
		end
	}

else	-- CLIENT
	net.Receive("GWATER2_ADDCLOTH", function(len)
		local translation = net.ReadMatrix()
		local size_x = net.ReadUInt(8)
		local size_y = net.ReadUInt(8)
		local extra = net.ReadTable()	-- the one time this function is actually useful
		gwater2.solver:AddCloth(translation, Vector(size_x, size_y), extra)
		gwater2.cloth_pos = translation:GetTranslation()
	end)

	net.Receive("GWATER2_ADDCYLINDER", function(len)
		local translation = net.ReadMatrix()
		local size_x = net.ReadUInt(8)
		local size_y = net.ReadUInt(8)
		local size_z = net.ReadUInt(8)
		local extra = net.ReadTable()
		gwater2.solver:AddCylinder(translation, Vector(size_x, size_y, size_z), extra)
	end)

	net.Receive("GWATER2_ADDSPHERE", function(len)
		local translation = net.ReadMatrix()
		local radius = net.ReadUInt(8)
		local extra = net.ReadTable()
		gwater2.solver:AddSphere(translation, radius, extra)
	end)

	net.Receive("GWATER2_ADDCUBE", function(len)
		local translation = net.ReadMatrix()
		local size_x = net.ReadUInt(8)
		local size_y = net.ReadUInt(8)
		local size_z = net.ReadUInt(8)
		local extra = net.ReadTable()
		gwater2.solver:AddCube(translation, Vector(size_x, size_y, size_z), extra)
	end)

	net.Receive("GWATER2_ADDMODEL", function(len)
		local translation = net.ReadMatrix()
		local model = net.ReadString()
		local extra = net.ReadTable()

		--[[
		local model, offset = util.GetModelMeshes(model)
		if !model then return end

		for k, body in ipairs(model) do
			local offset = offset[k - 1]
			local succ
			if offset then
				succ = gwater2.solver:AddMesh(translation, body.triangles, extra)
			else
				succ = gwater2.solver:AddMesh(translation, body.triangles, extra)
			end
		end]]

		local cs_ent = ents.CreateClientProp(model)
		local mins, maxs = cs_ent:OBBMins(), cs_ent:OBBMaxs()
		local phys = cs_ent:GetPhysicsObject()
		if !IsValid(phys) then 
			cs_ent:Remove()
			return
		end

		-- set up for GetVelocityAtPoint
		phys:SetPos(translation:GetTranslation())
		phys:SetAngles(translation:GetAngles())
		phys:SetVelocity(extra.ent_vel or Vector())
		phys:SetAngleVelocity(extra.ent_angvel or Vector())

		local colliders = CreatePhysCollidesFromModel(model)
		if !colliders then 
			cs_ent:Remove() 
			return 
		end
		
		local radius = gwater2.solver:GetParameter("fluid_rest_distance")
		local offset = radius / 2
		mins = mins + Vector(offset, offset, offset)
		maxs = maxs + Vector(offset, offset, offset)

		local function trace_filter(e) return e == cs_ent end
		for z = mins[3], maxs[3], radius do
			for y = mins[2], maxs[2], radius do
				for x = mins[1], maxs[1], radius do
					local pos = Vector(x, y, z)
					--local hit = 0
					for _, v in ipairs(colliders) do
						if v:TraceBox(Vector(0, 0, 0), Angle(), pos, pos, Vector(-offset, -offset, -offset), Vector(offset, offset, offset)) then
							--hit = 255
							-- Add particle
							local vel = extra.vel and extra.vel or phys:GetVelocityAtPoint(phys:LocalToWorld(pos))
							gwater2.solver:AddParticle(translation * pos + Vector(0, 0, offset), {vel = vel})
							if gwater2.solver:GetActiveParticles() >= gwater2.solver:GetMaxParticles() then
								goto megabreak
							end

							break
						end
					end
					--debugoverlay.BoxAngles(phys:LocalToWorld(pos), Vector(-offset, -offset, -offset), Vector(offset, offset, offset), phys:GetAngles(), 10, Color(255 - hit, hit, 0, 0))
				end
			end
		end

		::megabreak::
		for k, v in ipairs(colliders) do v:Destroy() end
		cs_ent:Remove()
	end)

	net.Receive("GWATER2_ADDPARTICLE", function(len)
		local pos = net.ReadVector()
		local extra = net.ReadTable()
		gwater2.solver:AddParticle(pos, extra)
	end)
end