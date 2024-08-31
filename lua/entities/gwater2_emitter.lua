AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Category		= "GWater2"
ENT.PrintName		= "Emitter"
ENT.Author			= "Mee"
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Spawnable   	= true
ENT.Editable		= true

function ENT:Initialize()
	if CLIENT then return end

	self:SetModel("models/mechanics/wheels/wheel_speed_72.mdl")
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

	ent:SetRadius(6)
	ent:SetStrength(60)
	ent:SetSpread(1)
	ent:SetLifetime(10)
	ent:SetOn(true)
	ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ent:SetMaterial("phoenix_storms/gear")

	return ent
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Radius", {KeyName = "Radius", Edit = {type = "Int", order = 0, min = 1, max = 9}})
	self:NetworkVar("Float", 0, "Spread", {KeyName = "Spread", Edit = {type = "Float", order = 1, min = 1, max = 2}})
	self:NetworkVar("Float", 1, "Lifetime", {KeyName = "Lifetime", Edit = {type = "Float", order = 2, min = 1, max = 100}})
	self:NetworkVar("Float", 2, "Strength", {KeyName = "Strength", Edit = {type = "Float", order = 3, min = 1, max = 500}})
	self:NetworkVar("Bool", 0, "On", {KeyName = "On", Edit = {type = "Bool", order = 4}})

	if SERVER then return end

	-- runs per client FleX frame, this may be different per client.
	-- more particles might be spawned depending on the client, but this setup allows for laminar flow, which I think looks better
	-- The alternative is running a gwater2.AddCylinder in a serverside Think hook, however with that setup different clients may see different results
	hook.Add("gwater2_posttick", self, function()
		if !self:GetOn() then return end

		local particle_radius = gwater2.solver:GetParameter("radius")
		local radius = self:GetRadius()
		local spread = self:GetSpread()
		local strength = self:GetStrength()

		local mat = Matrix()
		mat:SetScale(Vector(spread, spread, spread))
		mat:SetAngles(self:GetAngles())
		--mat:SetAngles(self:LocalToWorldAngles(Angle(0, CurTime() * 200, 0)))
		mat:SetTranslation(self:GetPos() + self:GetUp() * particle_radius * math.Rand(0.999, 1))
	 
		gwater2.solver:AddCylinder(mat, Vector(radius, radius, 1), {vel = self:GetUp() * strength, lifetime = self:GetLifetime()})
	end)
end

function ENT:OnRemove()
	hook.Remove("gwater2_posttick", self)
end
