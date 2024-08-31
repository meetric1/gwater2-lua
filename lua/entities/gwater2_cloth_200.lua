AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Category		= "GWater2"
ENT.PrintName		= "Cloth (200x200)"
ENT.Author			= "Meetric"
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Spawnable 		= true

-- send cloth data to the client
function ENT:SpawnFunction(ply, tr, class, type)
	gwater2.AddCloth(gwater2.quick_matrix(tr.HitPos + Vector(0, 0, 50)), Vector(200, 200))	-- network

	local ent = ents.Create(class)
	ent:SetPos(tr.HitPos + tr.HitNormal)
	ent:Spawn()

	return ent
end

-- dont.
function ENT:Draw()
	self:SetNoDraw(true)
end

function ENT:OnRemove()
	if CLIENT then
		gwater2.solver:ResetCloth()	-- remove all cloth, as theres not a way to remove individually yet
	else
		for k, v in ipairs(ents.FindByClass("gwater2_cloth_*")) do	-- die
			SafeRemoveEntity(v)
		end
	end
end
