AddCSLuaFile()

if SERVER then
	util.AddNetworkString("GWATER2_ADDCLOTH")
	util.AddNetworkString("GWATER2_ADDPARTICLE")
	util.AddNetworkString("GWATER2_ADDCUBE")
	util.AddNetworkString("GWATER2_ADDCYLINDER")
	util.AddNetworkString("GWATER2_ADDSPHERE")

	util.AddNetworkString("GWATER2_CHANGEPARAMETER")
	util.AddNetworkString("GWATER2_REQUESTPARAMETERSSNAPSHOT")

	gwater2 = {
		parameters = {},

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
				net.WriteTable(particle_data or {}) -- empty table only takes 3 bits
			net.Broadcast()
		end,

		AddSphere = function(translation, radius, particle_data)
			net.Start("GWATER2_ADDSPHERE")
				net.WriteMatrix(translation)
				net.WriteUInt(radius, 8)
				net.WriteTable(particle_data or {}) -- empty table only takes 3 bits
			net.Broadcast()
		end,

		AddCube = function(translation, size, particle_data)
			net.Start("GWATER2_ADDCUBE")
				net.WriteMatrix(translation)
				net.WriteUInt(size[1], 8)
				net.WriteUInt(size[2], 8)
				net.WriteUInt(size[3], 8)
				net.WriteTable(particle_data or {}) -- empty table only takes 3 bits
			net.Broadcast()
		end,
		
		AddParticle = function(pos, particle_data)
			net.Start("GWATER2_ADDPARTICLE")
				net.WriteVector(pos)
				net.WriteTable(particle_data or {}) -- empty table only takes 3 bits
			net.Broadcast()
		end,

		ChangeParameter = function(name, value, omit)
			if gwater2.parameters[name] == value then return end
			net.Start("GWATER2_CHANGEPARAMETER")
				net.WriteString(name)
				net.WriteType(value)
			gwater2.parameters[name] = value
			if not omit then
				net.Broadcast()
			else
				net.SendOmit(omit)
			end
		end,

		quick_matrix = function(pos, ang, scale)
			local mat = Matrix()
			if pos then mat:SetTranslation(pos) end
			if ang then mat:SetAngles(ang) end
			if scale then mat:SetScale(Vector(1, 1, 1) * scale) end
			return mat
		end
	}
	net.Receive("GWATER2_CHANGEPARAMETER", function(len, ply)
		-- if not ply:IsSuperAdmin() then return end -- do not accept change of parameters from non-superadmins
		gwater2.ChangeParameter(net.ReadString(), net.ReadType(), ply)
	end)
	net.Receive("GWATER2_REQUESTPARAMETERSSNAPSHOT", function(len, ply)
		-- TODO
	end)
else	-- CLIENT
	gwater2.ChangeParameter = function(name, value)
		net.Start("GWATER2_CHANGEPARAMETER")
			net.WriteString(name)
			net.WriteType(value)
		net.SendToServer()
	end

	local util = include("menu/gwater2_util.lua")
	net.Receive("GWATER2_CHANGEPARAMETER", function(len, ply)
		util.set_gwater_parameter(net.ReadString(), net.ReadType())
	end)

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

	net.Receive("GWATER2_ADDPARTICLE", function(len)
		local pos = net.ReadVector()
		local extra = net.ReadTable()
		gwater2.solver:AddParticle(pos, extra)
	end)
end