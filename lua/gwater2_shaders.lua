local function GetRenderTargetGWater(name, mult, depth) 
	mult = mult or 1
	return GetRenderTargetEx(name, ScrW() * mult, ScrH() * mult,
		RT_SIZE_DEFAULT,
		depth or 0,
		2 + 4 + 8 + 256,
		0,
		IMAGE_FORMAT_RGBA16161616F
	)
end

local cache_screen0 = render.GetScreenEffectTexture()
local cache_screen1 = render.GetScreenEffectTexture(1)
local cache_depth = GetRenderTargetGWater("1gwater_cache_depth", 1 / 1)
local cache_absorption = GetRenderTargetGWater("2gwater_cache_absorption", 1 / 2, MATERIAL_RT_DEPTH_NONE)
local cache_normals = GetRenderTargetGWater("1gwater_cache_normals", 1 / 1, MATERIAL_RT_DEPTH_SEPARATE)
local cache_bloom = GetRenderTargetGWater("2gwater_cache_bloom", 1 / 2)	-- for blurring
local water = Material("gwater2/finalpass")
local water_blur = Material("gwater2/smooth")
local water_volumetric = Material("gwater2/volumetric")
local water_normals = Material("gwater2/normals")
local water_bubble = Material("gwater2/bubble")	-- bubbles
local water_mist = Material("gwater2/mist")
local black = Material("gwater2/black")
local cloth = Material("gwater2/cloth")

local debug_depth = CreateClientConVar("gwater2_debug_depth", "0", false)
local debug_absorption = CreateClientConVar("gwater2_debug_absorption", "0", false)
local debug_normals = CreateClientConVar("gwater2_debug_normals", "0", false)

local blur_passes = CreateClientConVar("gwater2_blur_passes", "3", true)
local blur_scale = CreateClientConVar("gwater2_blur_scale", "1", true)
local antialias = GetConVar("mat_antialias")

local lightpos = EyePos()

-- makes lighting work properly in sourceengine
local function unfuck_lighting(pos0, pos1)
	render.PushRenderTarget(cache_screen0)	-- rt doesnt matter, just dont write it to the main one
	render.OverrideDepthEnable(true, false)
	render.Model({model="models/shadertest/envballs.mdl",pos=pos0, angle = EyeAngles()})	-- cubemap
	render.Model({model="models/shadertest/vertexlit.mdl",pos=pos1, angle = EyeAngles()}) 	-- lighting
	render.OverrideDepthEnable(false, false)
	render.PopRenderTarget()
end

-- gwater2 shader pipeline
hook.Add("PostDrawOpaqueRenderables", "gwater2_render", function(depth, sky, sky3d)	--PreDrawViewModels
	if gwater2.solver:GetActiveParticles() < 1 then return end

	if sky3d or render.GetRenderTarget() then return end

	-- Clear render targets
	render.ClearRenderTarget(cache_normals, Color(0, 0, 0, 0))
	render.ClearRenderTarget(cache_depth, Color(0, 0, 0, 0))
	render.ClearRenderTarget(cache_absorption, Color(0, 0, 0, 0))
	render.ClearRenderTarget(cache_bloom, Color(0, 0, 0, 0))

	-- cached variables
	local scrw = ScrW()
	local scrh = ScrH()
	local radius = gwater2.solver:GetParameter("radius")

	gwater2.renderer:SetHang(false)
	gwater2.renderer:BuildMeshes(gwater2.solver, 0.25)

	-- cloth
	unfuck_lighting(gwater2.cloth_pos, gwater2.cloth_pos)	-- fix cloth lighting, mostly
	render.SetMaterial(cloth)	
	--render.SetMaterial(Material("debug/env_cubemap_model"))
	gwater2.renderer:DrawCloth()
	render.RenderFlashlights(function() gwater2.renderer:DrawCloth() end)

	-- setup water lighting
	local tr = util.QuickTrace( EyePos(), LocalPlayer():EyeAngles():Forward() * 800, LocalPlayer())
	local dist = math.min(230, (tr.HitPos - tr.StartPos):Length() / 1.5)	
	lightpos = LerpVector(0.8 * FrameTime(), lightpos, EyePos() + (LocalPlayer():EyeAngles():Forward() * dist))	-- fucking hell
	unfuck_lighting(EyePos(), lightpos)	

	render.UpdateScreenEffectTexture()	-- _rt_framebuffer is used in refraction shader
	
	-- depth absorption (disabled when opaque liquids are enabled)
	local _, _, _, a = water:GetVector4D("$color2")
	if water_volumetric:GetFloat("$alpha") != 0 and a > 0 and a < 255 then
		-- ANTIALIAS FIX! (courtesy of Xenthio)
			-- how it works: 
			-- Clear the main rendertarget, keeping depth
			-- Render to main buffer (still has depth), and copy the contents to another rendertarget
			-- Restore the main buffer

		-- clear screen w/o intruding translucents depth buffer
		render.SetMaterial(black)
		render.DrawScreenQuad()

		render.SetMaterial(water_volumetric)
		gwater2.renderer:DrawWater()
		render.CopyTexture(render.GetRenderTarget(), cache_absorption)
		render.DrawTextureToScreen(cache_screen0)
	else
		-- no absorption calculations, so just use solid color
		render.PushRenderTarget(cache_absorption)
		render.Clear(15, 15, 15, 10)
		render.PopRenderTarget()
	end

	-- dont render bubbles underwater if opaque
	if a < 255 then
		-- Bubble particles inside water
		-- Make sure the water screen texture has bubbles but the normal framebuffer does not
		render.SetMaterial(water_bubble)
		render.UpdateScreenEffectTexture(1)
		gwater2.renderer:DrawDiffuse()
		render.CopyTexture(render.GetRenderTarget(), cache_screen0)
		render.DrawTextureToScreen(cache_screen1)
	end

	-- grab normals
	water_normals:SetFloat("$radius", radius)
	render.SetMaterial(water_normals)
	render.PushRenderTarget(cache_normals)
	render.SetRenderTargetEx(1, cache_depth)
	render.ClearDepth()
	gwater2.renderer:DrawWater()
	render.PopRenderTarget()
	render.SetRenderTargetEx(1, nil)

	-- Blur normals
	water_blur:SetFloat("$radius", radius)
	water_blur:SetTexture("$depthtexture", cache_depth)
	render.SetMaterial(water_blur)
	for i = 1, blur_passes:GetInt() do
		-- Blur X
		local scale = (0.25 / i) * blur_scale:GetFloat()
		water_blur:SetTexture("$normaltexture", cache_normals)
		water_blur:SetVector("$scrs", Vector(scale / scrw, 0))
		render.PushRenderTarget(cache_bloom)	-- Bloom texture resolution is significantly lower than screen res, enabling for a faster blur
		render.DrawScreenQuad()
		render.PopRenderTarget()
		
		-- Blur Y
		water_blur:SetTexture("$normaltexture", cache_bloom)
		water_blur:SetVector("$scrs", Vector(0, scale / scrh))
		render.PushRenderTarget(cache_normals)
		render.DrawScreenQuad()
		render.PopRenderTarget()
	end

	-- Setup water material parameters
	water:SetFloat("$radius", radius)
	water:SetTexture("$normaltexture", cache_normals)
	water:SetTexture("$depthtexture", cache_absorption)
	render.SetMaterial(water)
	--render.SetMaterial(Material("models/props_combine/combine_interface_disp"))
	gwater2.renderer:DrawWater()
	render.RenderFlashlights(function() gwater2.renderer:DrawWater() end)

	render.SetMaterial(water_mist)
	gwater2.renderer:DrawDiffuse()

	-- Debug Draw
	local dbg = 0
	if debug_absorption:GetBool() then render.DrawTextureToScreenRect(cache_absorption, ScrW() * 0.75, (ScrH() / 4) * dbg, ScrW() / 4, ScrH() / 4); dbg = dbg + 1 end
	if debug_normals:GetBool() then render.DrawTextureToScreenRect(cache_normals, ScrW() * 0.75, (ScrH() / 4) * dbg, ScrW() / 4, ScrH() / 4); dbg = dbg + 1 end
	if debug_depth:GetBool() then render.DrawTextureToScreenRect(cache_depth, ScrW() * 0.75, (ScrH() / 4) * dbg, ScrW() / 4, ScrH() / 4); dbg = dbg + 1 end
end)

--hook.Add("NeedsDepthPass", "gwater2_depth", function()
--	DOFModeHack(true)	-- fixes npcs and stuff dissapearing
--	return true
--end)