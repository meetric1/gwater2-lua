---@diagnostic disable: inject-field
AddCSLuaFile()

if SERVER or not gwater2 then return end

local styling = include("menu/gwater2_styling.lua")
local _util = include("menu/gwater2_util.lua")

local function cloth_tab(tabs)
    local tab = vgui.Create("DPanel", tabs)
	function tab:Paint() end
	tabs:AddSheet(_util.get_localised("Cloth.title"), tab, "icon16/bug.png").Tab.realname = "Cloth"
	tab = tab:Add("GF_ScrollPanel")
	tab:Dock(FILL)

	styling.define_scrollbar(tab:GetVBar())

	local _ = tab:Add("DLabel") _:SetText(" ") _:SetFont("GWater2Title") _:Dock(TOP) _:SizeToContents()
	function _:Paint(w, h)
		draw.DrawText(_util.get_localised("Cloth.titletext"), "GWater2Title", 6, 6, Color(0, 0, 0), TEXT_ALIGN_LEFT)
		draw.DrawText(_util.get_localised("Cloth.titletext"), "GWater2Title", 5, 5, Color(187, 245, 255), TEXT_ALIGN_LEFT)
	end

    gwater2.options.initialised["clothskin"] = {{func=function() end}}

    local label = tab:Add("DLabel")
	label:SetText(_util.get_localised("Cloth.skin"))
	label:SetColor(Color(255, 255, 255))
	label:SetFont("GWater2Param")
	label:Dock(TOP)
	label:SetMouseInputEnabled(true)
	label:SizeToContents()

    local clothskin = vgui.Create("DComboBox", tab)
    clothskin:Dock(TOP)
    clothskin:SetText(gwater2.options.parameters.clothskin.real or "Default")
    clothskin:AddChoice("Default", nil, false, "gwater2/cloth")
    clothskin:AddChoice("Wireframe", nil, false, "models/wireframe")
    clothskin:AddChoice("Newspaper", nil, false, "models/props_c17/paper01")
    clothskin:AddChoice("Meetricloth", nil, false, "__error")
    function clothskin:OnSelect(index, value, data)
        local nam, val = self:GetSelected()
        _util.set_gwater_parameter("clothskin", nam)
    end

    return tab
end

return {cloth_tab=cloth_tab}