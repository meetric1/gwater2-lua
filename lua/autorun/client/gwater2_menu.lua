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

	config_cache = nil,

	write_config = function(tbl)
		local real = gwater2.options.read_config()
		for k,v in pairs(real) do
			if tbl[k] == nil then tbl[k] = v end
		end
		file.Write("gwater2/config.txt", util.TableToJSON(tbl))
		gwater2.options.config_cache = tbl
	end,
	read_config = function()
		if gwater2.options.config_cache then return gwater2.options.config_cache end
		gwater2.options.config_cache = util.JSONToTable(file.Read("gwater2/config.txt") or "{}")
		return gwater2.options.config_cache
	end,

	initialised = {},
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
		swimfriction = {real=1, default=1, val=1, defined=true, func=function() end},
		swimspeed = {real=2, default=2, val=2, defined=true, func=function() end},
		swimbuoyancy = {real=0.5, default=0.5, val=0.5, defined=true, func=function() end},
		drowntime = {real=4, default=4, val=4, defined=true, func=function() end},
		drowndamage = {real=0.25, default=0.25, val=0.25, defined=true, func=function() end},
		drownparticles = {real=60, default=60, val=60, defined=true, func=function() end},
		multiplyparticles = {real=60, default=60, val=60, defined=true, func=function() end},
		multiplywalk = {real=1, default=1, val=1, defined=true, func=function() end},
		multiplyjump = {real=1, default=1, val=1, defined=true, func=function() end},
		touchdamage = {real=0, default=0, val=0, defined=true, func=function() end}
	}
}

if not file.Exists("gwater2/config.txt", "DATA") then
	gwater2.options.write_config({
		["sounds"]=true,
		["animations"]=true,
		["preview"]=true
	})
end

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
	local divider = vgui.Create("DHorizontalDivider", frame)
	--sim_preview:Dock(LEFT)
	help_text:Dock(RIGHT)
	sim_preview:SetSize(frame:GetWide()*0.25, sim_preview:GetTall())

	divider:Dock(FILL)

	divider:SetLeft(sim_preview)
	divider:SetRight(tabs)
	divider:SetDividerWidth(4)
	divider:SetLeftWidth(sim_preview:GetWide())
	divider:SetLeftMin(20)

	local particle_material = nil
	local pixelated = "hell"
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

		if gwater2.options.read_config().pixelate_preview ~= pixelated then
			pixelated = gwater2.options.read_config().pixelate_preview
			particle_material = CreateMaterial("gwater2_menu_material"..(gwater2.options.read_config().pixelate_preview and "_pix" or ""), "UnlitGeneric", {
				["$basetexture"] = (gwater2.options.read_config().pixelate_preview and "color/white" or "vgui/circle"),
				["$vertexcolor"] = 1,
				["$vertexalpha"] = 1,
				["$ignorez"] = 1
			})
		end

		gwater2.options.solverd.average_fps = gwater2.options.solverd.average_fps + (RealFrameTime() - gwater2.options.solverd.average_fps) * 0.01
		surface.SetMaterial(particle_material)
		gwater2.options.solver:RenderParticles(function(pos)
			local depth = math.max((pos[3] - y) / 390, 0) * 20	-- ranges from 0 to 20 down
			local absorption = is_translucent and exp((gwater2.options.parameters.color.real:ToVector() * gwater2.options.parameters.color_value_multiplier.real - Vector(1, 1, 1)) * gwater2.options.parameters.color.real.a / 255 * depth) or (gwater2.options.parameters.color.real:ToVector() * gwater2.options.parameters.color_value_multiplier.real)
			surface.SetDrawColor(absorption[1] * 255, absorption[2] * 255, absorption[3] * 255, 63)
			local px = pos[1] - x
			local py = pos[3] - y
			if gwater2.options.read_config().pixelate_preview then
				px = math.floor(px / radius) * radius
				py = math.floor(py / radius) * radius
			end
			surface.DrawTexturedRect(px, py, radius, radius)
		end)

		styling.draw_main_background(0, 0, sim_preview:GetWide(), 30)
		draw.DrawText(util.get_localised("Fluid Preview.title"), "GWater2Title", sim_preview:GetWide() / 2 + 1, 6, Color(0, 0, 0), TEXT_ALIGN_CENTER)
		draw.DrawText(util.get_localised("Fluid Preview.title"), "GWater2Title", sim_preview:GetWide() / 2, 5, Color(187, 245, 255), TEXT_ALIGN_CENTER)
	end
	local reset = sim_preview:Add("DButton")
	reset:SetText("")
	reset:SetImage("icon16/arrow_refresh.png")
	reset:SetWide(reset:GetTall())
	reset.Paint = nil
	reset:SetPos(5, 5)
	function reset:DoClick()
		gwater2.options.solver:Reset()
		if gwater2.options.read_config().sounds then LocalPlayer():EmitSound("gwater2/menu/reset.wav", 75, 100, 1, CHAN_STATIC) end
	end

	if not gwater2.options.read_config().preview then
		sim_preview:SetVisible(false)
		divider:SetLeft(nil)
		divider:SetLeftWidth(0)
		divider:SetLeftMin(0)
		divider:SetDividerWidth(0)
	end

	help_text:SetSize(frame:GetWide()*0.25, help_text:GetTall())
	function help_text:Paint(w, h)
		styling.draw_main_background(0, 0, w, h)
		draw.DrawText(util.get_localised("Explanation Area.title"), "GWater2Title", help_text:GetWide() / 2 + 1, 6, Color(0, 0, 0), TEXT_ALIGN_CENTER)
		draw.DrawText(util.get_localised("Explanation Area.title"), "GWater2Title", help_text:GetWide() / 2, 5, Color(187, 245, 255), TEXT_ALIGN_CENTER)
	end
	--tabs:Dock(FILL)
	tabs:SetFadeTime(0)
	help_text = help_text:Add("DLabel")
	help_text:Dock(FILL)
	help_text:DockMargin(5, 5, 5, 5)
	help_text:SetTextInset(0, 24)
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

	frame.tabs = tabs

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
	        func=function(val)
	        	gwater2.options.write_config({["sounds"]=val})
	        	return true
	        end,
	        setup=function(check)
	        	check:GetParent().button:Remove()
	        	check:SetValue(gwater2.options.read_config().sounds)
	        	return true
	        end
    	})

    	util.make_parameter_check(tab, "Menu.animations", "Animations", {
	        func=function(val)
	        	gwater2.options.write_config({["animations"]=val})
	        	return true
	        end,
	        setup=function(check)
	        	check:GetParent().button:Remove()
	        	check:SetValue(gwater2.options.read_config().animations)
	        	return true
	        end
    	})

    	util.make_parameter_check(tab, "Menu.preview", "Preview", {
	        func=function(val)
	        	gwater2.options.write_config({["preview"]=val})
	        	sim_preview:SetVisible(val)
	        	if not val then
	        		divider:SetLeft(nil)
	        		divider:SetLeftWidth(0)
					divider:SetLeftMin(0)
					divider:SetDividerWidth(0)
	        	else
	        		divider:SetLeft(sim_preview)
	        		divider:SetLeftWidth(sim_preview:GetWide())
					divider:SetLeftMin(20)
					divider:SetDividerWidth(4)
	        	end
	        	frame:InvalidateLayout()
	        	return true
	        end,
	        setup=function(check)
	        	check:GetParent().button:Remove()
	        	check:SetValue(gwater2.options.read_config().preview)
	        	return true
	        end
    	})

    	util.make_parameter_check(tab, "Menu.pixelate_preview", "Pixelate Preview", {
	        func=function(val)
	        	gwater2.options.write_config({["pixelate_preview"]=val})
	        	return true
	        end,
	        setup=function(check)
	        	check:GetParent().button:Remove()
	        	check:SetValue(gwater2.options.read_config().pixelate_preview)
	        	return true
	        end
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
	hook.Run("GWater2MenuAfterTab", "interaction", _tab)
	local _tab = paramstabs.developer_tab(tabs)
	hook.Run("GWater2MenuAfterTab", "developer", _tab)
	hook.Run("GWater2MenuAfterTab", "presets", presets.presets_tab(tabs, _parameters, _visuals, _performance, _interaction))
	hook.Run("GWater2MenuAfterTab", "supporters", supporters_tab(tabs))
	hook.Run("GWater2MenuAfterTab", "menu", menu_tab(tabs))

	frame.params = {parameters=_parameters, visuals=_visuals, performance=_performance, interaction=_interaction}

	for _,tab in pairs(tabs:GetItems()) do
		local rt = tab
		tab = tab.Tab
		function tab:Paint(w, h)
			styling.draw_main_background(0, 0, w - 4, self:IsActive() and h - 4 or h)
			if tab.lastpush ~= nil then
				local delta = 1 - (RealTime() - tab.lastpush) * 2
				if RealTime() - tab.lastpush < 0.5 then
					surface.SetDrawColor(0, 127, 255, 255*delta)
					surface.DrawRect(0, 0, w - 4, self:IsActive() and h - 4 or h)
					surface.SetDrawColor(255, 255, 255, 255*delta)
					surface.DrawOutlinedRect(0, 0, w - 4, self:IsActive() and h - 4 or h)
				end
				if gwater2.options.read_config().animations then
					local children = {}
					local function _(p)
						for __,child in pairs(p:GetChildren()) do
							children[#children+1] = child
							_(child)
						end
					end
					_(rt.Panel:GetChildren()[1])
					for i,v in pairs(children) do
						v:SetAlpha((1-delta-i/500)*255*4)
					end
				end
			end
			surface.SetDrawColor(255, 255, 255, 255)
		end
	end

	tabs:SetActiveTab(tabs.Items[gwater2.options.menu_tab:GetInt() ~= 1 and 1 or 2].Tab)
	function tabs:OnActiveTabChanged(_, new)
		help_text:SetText(util.get_localised(new.realname..".help"))
		for k, v in ipairs(self.Items) do
			if v.Tab == new then
				gwater2.options.menu_tab:SetInt(k)
				break
			end
		end
		if gwater2.options.read_config().sounds then LocalPlayer():EmitSound("gwater2/menu/select.wav", 75, 100, 1, CHAN_STATIC) end
		new.lastpush = RealTime()
		help_text:GetParent():SetParent(new:GetPanel())
		help_text:GetParent():Dock(RIGHT)
		help_text:SetWide(help_text:GetWide()*2)
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

concommand.Add("gwater2_menu2", function()
	if gwater2.options.frame == nil or not IsValid(gwater2.options.frame) then
		gwater2.options.frame = create_menu()
		return
	end
	gwater2.options.frame:Close()
	gwater2.options.frame = nil
end)

hook.Add("GUIMousePressed", "gwater2_menu2close", function(mouse_code, aim_vector)
	if not IsValid(frame) then return end

	local x, y = gui.MouseX(), gui.MouseY()
	local frame_x, frame_y = gwater2.options.frame:GetPos()
	if x < frame_x or x > frame_x + gwater2.options.frame:GetWide() or y < frame_y or y > frame_y + gwater2.options.frame:GetTall() then
		gwater2.options.frame:Remove()
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
function OpenGW2Menu(ply, key)
	if key ~= gwater2.options.menu_key:GetInt() or just_closed == true then return end
	RunConsoleCommand("gwater2_menu2")
end

function CloseGW2Menu(ply, key)
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