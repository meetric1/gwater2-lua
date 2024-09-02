AddCSLuaFile()

if SERVER or not gwater2 then return end

gwater2.VERSION = "0.5b"

local just_closed = false

gwater2.options = gwater2.options or {
	solver = FlexSolver(1000), -- that 2D-solver is available to everyone
	solverd = {x=0,y=0,w=0,h=0}, -- 2D solver data
	blur_passes = CreateClientConVar("gwater2_blur_passes", "3", true),
	absorption = CreateClientConVar("gwater2_absorption", "1", true),
	depth_fix = CreateClientConVar("gwater2_depth_fix", "0", true),
	menu_key = CreateClientConVar("gwater2_menu2key", KEY_G, true),
	menu_tab = CreateClientConVar("gwater2_menu2tab", "1", true),
	parameters = {
		color = {real=Color(209, 237, 255, 25), default=Color(209, 237, 255, 25)},
		color_value_multiplier = {real=1, default=1, val=1, func=function()
			local col = gwater2.options.parameters.color.real
			local finalpass = Material("gwater2/finalpass")
			col = Color(col.r, col.g, col.b, col.a)
			gwater2.options.parameters.color_value_multiplier.real = gwater2.options.parameters.color_value_multiplier.val
			col.r = col.r * gwater2.options.parameters.color_value_multiplier.real
			col.g = col.g * gwater2.options.parameters.color_value_multiplier.real
			col.b = col.b * gwater2.options.parameters.color_value_multiplier.real
			col.a = col.a * gwater2.options.parameters.color_value_multiplier.real
			finalpass:SetVector4D("$color2", col:Unpack())
		end, defined=true},
		swimfriction = {real=1, default=1, val=1, func=function()
			local val = gwater2.options.parameters.swimfriction.val
			gwater2.ChangeParameter("swimfriction", val)
		end, defined=true},
		swimspeed = {real=2, default=2, val=2, func=function()
			local val = gwater2.options.parameters.swimspeed.val
			gwater2.ChangeParameter("swimspeed", val)
		end, defined=true},
		swimbuoyancy = {real=0.5, default=0.5, val=0.5, func=function()
			local val = gwater2.options.parameters.swimbuoyancy.val
			gwater2.ChangeParameter("swimbuoyancy", val)
		end, defined=true},
		drowntime = {real=4, default=4, val=4, func=function()
			local val = gwater2.options.parameters.drowntime.val
			gwater2.ChangeParameter("drowntime", val)
		end, defined=true},
		drowndamage = {real=0.25, default=0.25, val=0.25, func=function()
			local val = gwater2.options.parameters.drowndamage.val
			gwater2.ChangeParameter("drowndamage", val)
		end, defined=true},
		drownparticles = {real=60, default=60, val=60, func=function()
			local val = gwater2.options.parameters.drownparticles.val
			gwater2.ChangeParameter("drownparticles", val)
		end, defined=true},
		multiplyparticles = {real=60, default=60, val=60, func=function()
			local val = gwater2.options.parameters.multiplyparticles.val
			gwater2.ChangeParameter("multiplyparticles", val)
		end, defined=true},
		multiplywalk = {real=1, default=1, val=1, func=function()
			local val = gwater2.options.parameters.multiplywalk.val
			gwater2.ChangeParameter("multiplywalk", val)
		end, defined=true},
		multiplyjump = {real=1, default=1, val=1, func=function()
			local val = gwater2.options.parameters.multiplyjump.val
			gwater2.ChangeParameter("multiplyjump", val)
		end, defined=true},
		touchdamage = {real=0, default=0, val=0, func=function()
			local val = gwater2.options.parameters.touchdamage.val
			gwater2.ChangeParameter("touchdamage", val)
		end, defined=true}
	}
}

gwater2.options.solverd.average_fps = 1 / 60

local params = include("menu/gwater2_params.lua")
local paramstabs = include("menu/gwater2_paramstabs.lua")
local styling = include("menu/gwater2_styling.lua")
local util = include("menu/gwater2_util.lua")
local GFScrollPanel = include("menu/gf_scrollpanel.lua")
if not file.Exists("gwater2", "DATA") then file.CreateDir("gwater2") end
local presets = include("menu/gwater2_presets.lua")

-- garry, sincerely... fuck you
timer.Simple(0, function() 
	Material("gwater2/volumetric"):SetFloat("$alpha", gwater2.options.absorption:GetBool() and 0.125 or 0)
	Material("gwater2/normals"):SetInt("$depthfix", gwater2.options.depth_fix:GetBool() and 1 or 0)
end)

gwater2.options.solver:SetParameter("gravity", 15.24)	-- flip gravity because y axis positive is down
gwater2.options.solver:SetParameter("static_friction", 0)	-- stop adhesion sticking to front and back walls
gwater2.options.solver:SetParameter("dynamic_friction", 0)	-- ^
gwater2.options.solver:SetParameter("diffuse_threshold", math.huge)	-- no diffuse particles allowed in preview

local function create_menu()
	local frame = vgui.Create("DFrame")
	frame:SetTitle("GWater 2 "..gwater2.VERSION)
	frame:SetSize(ScrW() * 0.8, ScrH() * 0.6)
	frame:Center()
	frame:MakePopup()
	function frame:Paint(w, h)
		styling.draw_main_background(0, 0, w, h)
	end

	local minimize_btn = frame:GetChildren()[3]
	minimize_btn:SetVisible(false)
	local maximize_btn = frame:GetChildren()[2]
	maximize_btn:SetVisible(false)
	local close_btn = frame:GetChildren()[1]
	close_btn:SetVisible(false)

	local new_close_btn = vgui.Create("DButton", frame)
	new_close_btn:SetPos(frame:GetWide() - 20, 0)
	new_close_btn:SetSize(20, 20)
	new_close_btn:SetText("")

	function new_close_btn:DoClick()
		frame:Close()
		just_closed = false
	end

	function new_close_btn:Paint(w, h)
		if self:IsHovered() then
			surface.SetDrawColor(255, 0, 0, 127)
			surface.DrawRect(0, 0, w, h)
		end
		surface.SetDrawColor(255, 255, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawLine(5, 5, w - 5, h - 5)
		surface.DrawLine(w - 5, 5, 5, h - 5)
	end

	gwater2.options.solver:Reset()

	local sim_preview = vgui.Create("DPanel", frame)
	local help_text = vgui.Create("DPanel", frame)
	local tabs = vgui.Create("DPropertySheet", frame)
	sim_preview:Dock(LEFT)
	help_text:Dock(RIGHT)
	sim_preview:SetSize(frame:GetWide()*0.25, sim_preview:GetTall())

	local particle_material = CreateMaterial("gwater2_menu_material", "UnlitGeneric", {
		["$basetexture"] = "vgui/circle",
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1,
		["$ignorez"] = 1
	})
	function sim_preview:Paint(w, h)
		styling.draw_main_background(0, 0, w, h)
		local x, y = sim_preview:LocalToScreen()
		local function exp(v) return Vector(math.exp(v[1]), math.exp(v[2]), math.exp(v[3])) end
		local is_translucent = gwater2.options.parameters.color.real.a < 255
		local radius = gwater2.options.solver:GetParameter("radius")
		--gwater2.options.solver:InitBounds(Vector(x, 0, y), Vector(x + w, radius, y + h))
		--local mat = Matrix()
		--mat:SetTranslation(Vector(x + w / 2 + math.random(), 0, y + radius))
		--gwater2.options.solver:AddCube(mat, Vector(4, 1, 1), {vel = Vector(0, 0, 50)})
		--gwater2.options.solver:Tick(gwater2.options.solverd.average_fps * 2)

		local mat = Matrix()
		mat:SetTranslation(Vector(x + w / 2 + math.random(), 0, y + radius))
		gwater2.options.solver:InitBounds(Vector(x, 0, y), Vector(x + w, radius, y + h))
		gwater2.options.solver:AddCube(mat, Vector(4, 1, 1), {vel = Vector(0, 0, 50)})
		gwater2.options.solver:Tick(1 / 60)

		gwater2.options.solverd.average_fps = gwater2.options.solverd.average_fps + (RealFrameTime() - gwater2.options.solverd.average_fps) * 0.01
		surface.SetMaterial(particle_material)
		gwater2.options.solver:RenderParticles(function(pos)
			local depth = math.max((pos[3] - y) / 390, 0) * 20	-- ranges from 0 to 20 down
			local absorption = is_translucent and exp((gwater2.options.parameters.color.real:ToVector() * gwater2.options.parameters.color_value_multiplier.real - Vector(1, 1, 1)) * gwater2.options.parameters.color.real.a / 255 * depth) or (gwater2.options.parameters.color.real:ToVector() * gwater2.options.parameters.color_value_multiplier.real)
			surface.SetDrawColor(absorption[1] * 255, absorption[2] * 255, absorption[3] * 255, 255)
			surface.DrawTexturedRect(pos[1] - x, pos[3] - y, radius, radius)
		end)
	end
	local reset = sim_preview:Add("DButton")
	reset:SetText("")
	reset:SetImage("icon16/arrow_refresh.png")
	reset:SetWide(reset:GetTall())
	reset.Paint = nil
	reset:SetPos(sim_preview:GetWide() - reset:GetWide() - 5, 5)
	function reset:DoClick()
		gwater2.options.solver:Reset()
		surface.PlaySound("gwater2/menu/reset.wav")
	end

	help_text:SetSize(frame:GetWide()*0.25, help_text:GetTall())
	function help_text:Paint(w, h) styling.draw_main_background(0, 0, w, h) end
	tabs:Dock(FILL)
	tabs:SetFadeTime(0)
	help_text = help_text:Add("DLabel")
	help_text:Dock(FILL)
	help_text:DockMargin(5, 5, 5, 5)
	help_text:SetWrap(true)
	help_text:SetColor(Color(255, 255, 255))
	help_text:SetContentAlignment(7)
	help_text:SetFont("GWater2Param")
	function tabs:Paint(w, h) styling.draw_main_background(0, 23, w, h-23) end

	function frame:OnKeyCodePressed(key)
		if key == gwater2.options.menu_key:GetInt() then
			frame:Close()
			just_closed = true
		end
	end

	hook.Run("GWater2MenuPreInitialize", frame, params.parameters, params.visuals, params.performance, params.interaction)

	local function about_tab(tabs)
		local tab = vgui.Create("DPanel", tabs)
		function tab:Paint() end
		tabs:AddSheet(util.get_localised("About Tab.title"), tab, "icon16/exclamation.png").Tab.realname = "About Tab"
		tab = tab:Add("GF_ScrollPanel")
		tab:Dock(FILL)

		styling.define_scrollbar(tab:GetVBar())

		local _ = tab:Add("DLabel") _:SetText(" ") _:SetFont("GWater2Title") _:Dock(TOP) _:SizeToContents()
		function _:Paint(w, h)
			draw.DrawText(util.get_localised("About Tab.titletext", gwater2.VERSION), "GWater2Title", 6, 6, Color(0, 0, 0), TEXT_ALIGN_LEFT)
			draw.DrawText(util.get_localised("About Tab.titletext", gwater2.VERSION), "GWater2Title", 5, 5, Color(187, 245, 255), TEXT_ALIGN_LEFT)
		end

		local label = tab:Add("DLabel")
		label:Dock(TOP)
		label:DockMargin(5, 5, 5, 5)
		label:SetText(util.get_localised("About Tab.welcome"))
		label:SetColor(Color(255, 255, 255))
		label:SetTextInset(5, 5)
		label:SetWrap(true)
		label:SetContentAlignment(7)
		label:SetFont("GWater2Param")
		
		label:SetPos(0, 0)
		label:SetTall(800)

		return tab
	end

	local function supporters_tab(tabs)
		local tab = vgui.Create("DPanel", tabs)
		function tab:Paint() end

		-- pretty sure you can also put people who helped meetric in development, that's why i renamed patrons_tab to supporters_tab :clueless:

		tabs:AddSheet(util.get_localised("Patrons.title"), tab, "icon16/award_star_gold_3.png").Tab.realname = "Patrons"
		tab = tab:Add("GF_ScrollPanel")
		tab:Dock(FILL)

		styling.define_scrollbar(tab:GetVBar())

		local _ = tab:Add("DLabel") _:SetText(" ") _:SetFont("GWater2Title") _:Dock(TOP) _:SizeToContents()
		function _:Paint(w, h)
			draw.DrawText(util.get_localised("Patrons.titletext"), "GWater2Title", 6, 6, Color(0, 0, 0), TEXT_ALIGN_LEFT)
			draw.DrawText(util.get_localised("Patrons.titletext"), "GWater2Title", 5, 5, Color(187, 245, 255), TEXT_ALIGN_LEFT)
		end

		local label = tab:Add("DLabel")
		label:Dock(TOP)
		label:DockMargin(5, 5, 5, 5)
		label:SetText(util.get_localised("Patrons.text"))
		label:SetColor(Color(255, 255, 255))
		label:SetTextInset(5, 5)
		label:SetWrap(true)
		label:SetContentAlignment(7)
		label:SetFont("GWater2Param")

		local supporters = file.Read("gwater2_patrons.lua", "LUA") or "<Failed to load patron data!>"
		--[[

		-- Hi - Xenthio
		-- DONT FORGET TO ADD 'Xenthio' & 'NecrosVideos'

		-- like this? \/\/\/

		supporters = "Special thanks to:\n"..
					 "  Xenthio\n"..
					 "  NecrosVideos\n"..
					 "-----------------------------------------\n"..
					 "Patreons:\n"..supporters
		]]
		local supporters_table = string.Split(supporters, "\n")
		local supporter_color = Color(171, 255, 163)
		
		label:SetPos(0, 0)
		label:SetTall(math.max(#supporters_table * 20, 1000) + 180)
		function label:Paint(w, h)
			-- unoptimized as shit but im at the mercy of vgui. 
			for k, v in ipairs(supporters_table) do
				draw.DrawText(v, "GWater2Param", 6, 120 + k * 20, supporter_color, TEXT_ALIGN_LEFT)
			end
		end
		return tab
	end

	local function menu_tab(tabs)
		local tab = vgui.Create("DPanel", tabs)
		function tab:Paint() end

		tabs:AddSheet(util.get_localised("Menu.title"), tab, "icon16/css_valid.png").Tab.realname = "Menu"
		tab = tab:Add("GF_ScrollPanel")
		tab:Dock(FILL)
		tab.help_text = tabs.help_text

		styling.define_scrollbar(tab:GetVBar())

		local _ = tab:Add("DLabel") _:SetText(" ") _:SetFont("GWater2Title") _:Dock(TOP) _:SizeToContents()
		function _:Paint(w, h)
			draw.DrawText(util.get_localised("Menu.titletext"), "GWater2Title", 6, 6, Color(0, 0, 0), TEXT_ALIGN_LEFT)
			draw.DrawText(util.get_localised("Menu.titletext"), "GWater2Title", 5, 5, Color(187, 245, 255), TEXT_ALIGN_LEFT)
		end

		util.make_parameter_check(tab, "Menu.sounds", "Sounds", {
	        func=function(val) return true end,
	        setup=function(check) return true end
    	})
	end

	tabs.help_text = help_text

	help_text:SetText(util.get_localised("About Tab.help"))
	
	hook.Run("GWater2MenuAfterTab", "about", about_tab(tabs))
	local _parameters, _tab = paramstabs.parameters_tab(tabs)
	hook.Run("GWater2MenuAfterTab", "parameters", _tab)
	local _visuals, _tab = paramstabs.visuals_tab(tabs)
	hook.Run("GWater2MenuAfterTab", "visuals", _tab)
	local _performance, _tab = paramstabs.performance_tab(tabs)
	hook.Run("GWater2MenuAfterTab", "performance", _tab)
	local _interaction, _tab = paramstabs.interaction_tab(tabs)
	hook.Run("GWater2MenuAfterTab", "presets", presets.presets_tab(tabs, _parameters, _visuals, _performance, _interaction))
	hook.Run("GWater2MenuAfterTab", "supporters", supporters_tab(tabs))
	hook.Run("GWater2MenuAfterTab", "menu", menu_tab(tabs))

	for _,tab in pairs(tabs:GetItems()) do
		local rt = tab
		tab = tab.Tab
		function tab:Paint(w, h)
			styling.draw_main_background(0, 0, w - 4, self:IsActive() and h - 4 or h)
			if tab.lastpush ~= nil and RealTime() - tab.lastpush < 0.5 then
				local delta = 1 - (RealTime() - tab.lastpush) * 2
				surface.SetDrawColor(0, 127, 255, 255*delta)
				surface.DrawRect(0, 0, w - 4, self:IsActive() and h - 4 or h)
				surface.SetDrawColor(255, 255, 255, 255*delta)
				surface.DrawOutlinedRect(0, 0, w - 4, self:IsActive() and h - 4 or h)
			end
			surface.SetDrawColor(255, 255, 255, 255)
		end
	end

	tabs:SetActiveTab(tabs.Items[gwater2.options.menu_tab:GetInt() ~= 1 and 1 or 2].Tab)
	local last_change_sound = ""
	function tabs:OnActiveTabChanged(_, new)
		help_text:SetText(util.get_localised(new.realname..".help"))
		for k, v in ipairs(self.Items) do
			if v.Tab == new then
				gwater2.options.menu_tab:SetInt(k)
				break
			end
		end
		local now_change_sound = last_change_sound
		while now_change_sound == last_change_sound do
			now_change_sound = "gwater2/menu/select/select_"..math.random(0, 14)..".mp3"
		end
		surface.PlaySound(now_change_sound)
		last_change_sound = now_change_sound
		new.lastpush = RealTime()
		help_text:GetParent():SetParent(new:GetPanel())
		help_text:GetParent():Dock(RIGHT)
	end
	tabs:SetActiveTab(tabs.Items[gwater2.options.menu_tab:GetInt()].Tab)
	hook.Run("GWater2MenuPostInitialize", frame)

	return frame
end

surface.CreateFont("GWater2Param", {
    font = "Space Mono", 
    extended = false,
    size = 20,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont("GWater2Title", {
    font = "coolvetica", 
    extended = false,
    size = 24,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

local frame = nil
concommand.Add("gwater2_menu2", function()
	if frame == nil or not IsValid(frame) then
		frame = create_menu()
		return
	end
	frame:Close()
	frame = nil
end)

hook.Add("GUIMousePressed", "gwater2_menu2close", function(mouse_code, aim_vector)
	if not IsValid(frame) then return end

	local x, y = gui.MouseX(), gui.MouseY()
	local frame_x, frame_y = frame:GetPos()
	if x < frame_x or x > frame_x + frame:GetWide() or y < frame_y or y > frame_y + frame:GetTall() then
		frame:Remove()
	end
end)

hook.Add("PopulateToolMenu", "gwater2_menu2", function()
    spawnmenu.AddToolMenuOption("Utilities", "gwater2", "gwater2_menu2", "Menu Rewrite Options", "", "", function(panel)
		panel:ClearControls()
		panel:Button("Open Menu", "gwater2_menu2")
        panel:KeyBinder("Menu Key", "gwater2_menu2key")
	end)
end)

-- hate this
function OpenGW2Menu2(ply, key)
	if key ~= gwater2.options.menu_key:GetInt() or just_closed == true then return end
	RunConsoleCommand("gwater2_menu2")
end

function CloseGW2Menu2(ply, key)
	if key ~= gwater2.options.menu_key:GetInt() then return end
	just_closed = false
end

local do_load_locale = false -- set to true if you actually want to see translated menu.
-- please note that this is not supported and translations may not be complete or correct

print("GWater2: loading language: english (fallback)")
local strings, lang = include("menu/locale/gwater2_english.lua")
for k,v in pairs(strings) do language.Add(k, v) end

if do_load_locale then
	pcall(function()
		local strings, lang = include("menu/locale/gwater2_"..GetConVar("cl_language"):GetString()..".lua")
		print("GWater2: loading language: "..lang)
		for k,v in pairs(strings) do language.Add(k, v) end
	end)
end

-- shit breaks in singleplayer due to predicted hooks
if game.SinglePlayer() then return end

hook.Add("PlayerButtonDown", "gwater2_menu2", OpenGW2Menu)
hook.Add("PlayerButtonUp", "gwater2_menu2", CloseGW2Menu)