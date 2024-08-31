AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Category     = "GWater2"
ENT.PrintName    = "Drain"
ENT.Author       = "Meetric"
ENT.Purpose      = ""
ENT.Instructions = ""
ENT.Spawnable    = true
ENT.Editable	 = true

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "Radius", {KeyName = "Radius", Edit = {type = "Float", order = 0, min = 0, max = 100}})
	self:NetworkVar("Float", 1, "Strength", {KeyName = "Strength", Edit = {type = "Float", order = 1, min = 0, max = 200}})

	if SERVER then return end

	self.PARTICLE_EMITTER = ParticleEmitter(self:GetPos(), false)
	hook.Add("gwater2_posttick", self, function()
		gwater2.solver:RemoveSphere(gwater2.quick_matrix(self:GetPos(), nil, self:GetRadius()))
		gwater2.solver:AddForceField(self:GetPos(), self:GetRadius(), -self:GetStrength(), 0, true)
	end)
end

if SERVER then
	function ENT:Initialize()
		if CLIENT then return end
		self:SetModel("models/xqm/button3.mdl")
		self:SetMaterial("phoenix_storms/dome")
		
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
	end

	function ENT:SpawnFunction(ply, tr, class)
		if not tr.Hit then return end
		local ent = ents.Create(class)
		ent:SetPos(tr.HitPos)
		ent:Spawn()
		ent:Activate()

		ent:SetRadius(20)
		ent:SetStrength(100)
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)

		return ent
	end
elseif CLIENT then
	function ENT:OnRemove()
		hook.Remove("gwater2_posttick", self)
	end
end