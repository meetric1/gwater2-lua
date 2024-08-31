local params = include("menu/gwater2_params.lua")
local styling = include("menu/gwater2_styling.lua")
local util = include("menu/gwater2_util.lua")

local function parameters_tab(tabs)
	local tab = vgui.Create("DPanel", tabs)
	function tab:Paint() end
	tabs:AddSheet(util.get_localised("Parameters.title"), tab, "icon16/cog.png").Tab.realname = "Parameters"
	tab = tab:Add("GF_ScrollPanel")
	tab:Dock(FILL)

	styling.define_scrollbar(tab:GetVBar())

	local _ = tab:Add("DLabel") _:SetText(" ") _:SetFont("GWater2Title") _:Dock(TOP) _:SizeToContents()
	function _:Paint(w, h)
		draw.DrawText(util.get_localised("Parameters.titletext"), "GWater2Title", 6, 6, Color(0, 0, 0), TEXT_ALIGN_LEFT)
		draw.DrawText(util.get_localised("Parameters.titletext"), "GWater2Title", 5, 5, Color(187, 245, 255), TEXT_ALIGN_LEFT)
	end

	local _params = params

	local params = {}

	for sname,sec in SortedPairs(_params.parameters) do
		local pan = tab:Add("Panel")
		pan.help_text = tabs.help_text
		function pan:Paint(w, h) styling.draw_main_background(0, 0, w, h) end

		util.make_title_label(pan, util.get_localised("Parameters."..sname:sub(5))).realkey = sname
		for name,param in SortedPairs(sec["list"]) do
			if param.type == "scratch" then
				params[name:sub(5)] = util.make_parameter_scratch(pan, "Parameters."..name:sub(5), name:sub(5), param)
			elseif param.type == "color" then
				params[name:sub(5)] = util.make_parameter_color(pan, "Parameters."..name:sub(5), name:sub(5), param)
			elseif param.type == "check" then
				params[name:sub(5)] = util.make_parameter_check(pan, "Parameters."..name:sub(5), name:sub(5), param)
			else
				error("got unknown parameter type in \"parameters\" menu generation: \""..param.type.."\" at "..name)
			end
		end


		local ttall = pan:GetTall()+5
		for _,i in pairs(pan:GetChildren()) do
			ttall = ttall + i:GetTall()
		end
		ttall = ttall - 20
		pan:SetTall(ttall)
		pan:Dock(TOP)
		pan:InvalidateChildren()
		pan:DockMargin(5, 5, 5, 5)
		pan:DockPadding(5, 5, 5, 5)
	end
	return params, tab
end

local function visuals_tab(tabs)
	local tab = vgui.Create("DPanel", tabs)
	function tab:Paint() end
	tabs:AddSheet(util.get_localised("Visuals.title"), tab, "icon16/picture.png").Tab.realname = "Visuals"
	tab = tab:Add("GF_ScrollPanel")
	tab:Dock(FILL)

	styling.define_scrollbar(tab:GetVBar())

	local _ = tab:Add("DLabel") _:SetText(" ") _:SetFont("GWater2Title") _:Dock(TOP) _:SizeToContents()
	function _:Paint(w, h)
		draw.DrawText(util.get_localised("Visuals.titletext"), "GWater2Title", 6, 6, Color(0, 0, 0), TEXT_ALIGN_LEFT)
		draw.DrawText(util.get_localised("Visuals.titletext"), "GWater2Title", 5, 5, Color(187, 245, 255), TEXT_ALIGN_LEFT)
	end

	local _params = params

	local params = {}
	local pan = tab:Add("Panel")
	pan.help_text = tabs.help_text
	function pan:Paint(w, h) styling.draw_main_background(0, 0, w, h) end

	for name,param in SortedPairs(_params.visuals) do
		if param.type == "scratch" then
			params[name:sub(5)] = util.make_parameter_scratch(pan, "Visuals."..name:sub(5), name:sub(5), param)
		elseif param.type == "color" then
			params[name:sub(5)] = util.make_parameter_color(pan, "Visuals."..name:sub(5), name:sub(5), param)
		elseif param.type == "check" then
			params[name:sub(5)] = util.make_parameter_check(pan, "Visuals."..name:sub(5), name:sub(5), param)
		else
			error("got unknown parameter type in \"visuals\" menu generation: \""..param.type.."\" at "..name)
		end
	end
	local ttall = pan:GetTall()+5
	for _,i in pairs(pan:GetChildren()) do
		ttall = ttall + i:GetTall()
	end
	ttall = ttall - 20
	pan:SetTall(ttall)
	pan:Dock(TOP)
	pan:InvalidateChildren()
	pan:DockMargin(5, 5, 5, 5)
	pan:DockPadding(5, 5, 5, 5)
	return params, tab
end

local function performance_tab(tabs)
	local tab = vgui.Create("DPanel", tabs)
	function tab:Paint() end
	tabs:AddSheet(util.get_localised("Performance.title"), tab, "icon16/application_xp_terminal.png").Tab.realname = "Performance"
	tab = tab:Add("GF_ScrollPanel")
	tab:Dock(FILL)

	styling.define_scrollbar(tab:GetVBar())

	local _ = tab:Add("DLabel") _:SetText(" ") _:SetFont("GWater2Title") _:Dock(TOP) _:SizeToContents()
	function _:Paint(w, h)
		draw.DrawText(util.get_localised("Performance.titletext"), "GWater2Title", 6, 6, Color(0, 0, 0), TEXT_ALIGN_LEFT)
		draw.DrawText(util.get_localised("Performance.titletext"), "GWater2Title", 5, 5, Color(187, 245, 255), TEXT_ALIGN_LEFT)
	end

	local _params = params

	local params = {}
	local pan = tab:Add("Panel")
	pan.help_text = tabs.help_text
	function pan:Paint(w, h) styling.draw_main_background(0, 0, w, h) end

	for name,param in SortedPairs(_params.performance) do
		if param.type == "scratch" then
			params[name:sub(5)] = util.make_parameter_scratch(pan, "Performance."..name:sub(5), name:sub(5), param)
		elseif param.type == "color" then
			params[name:sub(5)] = util.make_parameter_color(pan, "Performance."..name:sub(5), name:sub(5), param)
		elseif param.type == "check" then
			params[name:sub(5)] = util.make_parameter_check(pan, "Performance."..name:sub(5), name:sub(5), param)
		else
			error("got unknown parameter type in \"performance\" menu generation: \""..param.type.."\" at "..name)
		end
	end
	local ttall = pan:GetTall()+5
	for _,i in pairs(pan:GetChildren()) do
		ttall = ttall + i:GetTall()
	end
	ttall = ttall - 20
	pan:SetTall(ttall)
	pan:Dock(TOP)
	pan:InvalidateChildren()
	pan:DockMargin(5, 5, 5, 5)
	pan:DockPadding(5, 5, 5, 5)
	return params, tab
end

local function interaction_tab(tabs)
	local tab = vgui.Create("DPanel", tabs)
	function tab:Paint() end
	tabs:AddSheet(util.get_localised("Interactions.title"), tab, "icon16/application_xp_terminal.png").Tab.realname = "Interactions"
	tab = tab:Add("GF_ScrollPanel")
	tab:Dock(FILL)

	styling.define_scrollbar(tab:GetVBar())

	local _ = tab:Add("DLabel") _:SetText(" ") _:SetFont("GWater2Title") _:Dock(TOP) _:SizeToContents()
	function _:Paint(w, h)
		draw.DrawText(util.get_localised("Interactions.titletext"), "GWater2Title", 6, 6, Color(0, 0, 0), TEXT_ALIGN_LEFT)
		draw.DrawText(util.get_localised("Interactions.titletext"), "GWater2Title", 5, 5, Color(187, 245, 255), TEXT_ALIGN_LEFT)
	end

	local _params = params

	local params = {}
	local pan = tab:Add("Panel")
	pan.help_text = tabs.help_text
	function pan:Paint(w, h) styling.draw_main_background(0, 0, w, h) end

	for name,param in SortedPairs(_params.interaction) do
		if param.type == "scratch" then
			params[name:sub(5)] = util.make_parameter_scratch(pan, "Interactions."..name:sub(5), name:sub(5), param)
		elseif param.type == "color" then
			params[name:sub(5)] = util.make_parameter_color(pan, "Interactions."..name:sub(5), name:sub(5), param)
		elseif param.type == "check" then
			params[name:sub(5)] = util.make_parameter_check(pan, "Interactions."..name:sub(5), name:sub(5), param)
		else
			error("got unknown parameter type in \"interaction\" menu generation: \""..param.type.."\" at "..name)
		end
	end
	local ttall = pan:GetTall()+5
	for _,i in pairs(pan:GetChildren()) do
		ttall = ttall + i:GetTall()
	end
	ttall = ttall - 20
	pan:SetTall(ttall)
	pan:Dock(TOP)
	pan:InvalidateChildren()
	pan:DockMargin(5, 5, 5, 5)
	pan:DockPadding(5, 5, 5, 5)
end

return {
	parameters_tab=parameters_tab,
	visuals_tab=visuals_tab,
	performance_tab=performance_tab,
	interaction_tab=interaction_tab
}