AddCSLuaFile()

if SERVER or not gwater2 then return end

if gwater2.__PARAMS__ then return gwater2.__PARAMS__ end

local styling = include("menu/gwater2_styling.lua")
local _util = include("menu/gwater2_util.lua")

local parameters = {
	["001-Physics Parameters"] = {
		["list"] = {
			["001-Adhesion"] = {
				min=0,
				max=0.2,
				decimals=3,
				type="scratch"
			},
			["002-Cohesion"] = {
				min=0,
				max=2,
				decimals=3,
				type="scratch"
			},
			["003-Radius"] = {
				min=1,
				max=100,
				decimals=1,
				type="scratch"
			},
			["004-Gravity"] = {
				min=-30.48,
				max=30.48,
				decimals=2,
				type="scratch"
			},
			["005-Viscosity"] = {
				min=0,
				max=20,
				decimals=2,
				type="scratch"
			},
			["006-Surface Tension"] = {
				min=0,
				max=1,
				decimals=2,
				type="scratch"
			},
			["007-Timescale"] = {
				min=0,
				max=2,
				decimals=2,
				type="scratch"
			},
			["007-Timescale"] = {
				min=0,
				max=2,
				decimals=2,
				type="scratch"
			}
		}
	},
	["002-Advanced Physics Parameters"] = {
		["list"] = {
			["001-Collision Distance"] = {
				min=0.1,
				max=1,
				decimals=2,
				type="scratch"
			},
			["002-Fluid Rest Distance"] = {
				min=0.55,
				max=0.85,
				decimals=2,
				type="scratch"
			},
			["003-Dynamic Friction"] = {
				min=0,
				max=1,
				decimals=2,
				type="scratch"
			},
			["004-Vorticity Confinement"] = {
				min=0,
				max=200,
				decimals=0,
				type="scratch"
			}
		}
	},
	["003-Reaction Force Parameters"] = {
		["list"] = {
			["001-Force Multiplier"] = {
				min=0.001,
				max=0.02,
				decimals=3,
				type="scratch"
			},
			["002-Force Buoyancy"] = {
				min=0,
				max=500,
				decimals=1,
				type="scratch"
			},
			["003-Force Dampening"] = {
				min=0,
				max=1,
				decimals=2,
				type="scratch"
			}
		}
	}
}
local visuals = {
	["001-Diffuse Threshold"] = {
		min=1,
		max=500,
		decimals=1,
		type="scratch"
	},
	["002-Diffuse Lifetime"] = {
		min=0,
		max=20,
		decimals=1,
		type="scratch"
	},
	["003-Anisotropy Scale"] = {
		min=0,
		max=2,
		decimals=2,
		type="scratch"
	},
	["004-Anisotropy Min"] = {
		min=-0.1,
		max=1,
		decimals=2,
		type="scratch"
	},
	["005-Anisotropy Max"] = {
		min=0,
		max=2,
		decimals=2,
		type="scratch"
	},
	["006-Color"] = {
		type="color",
		func=function(col)
			local finalpass = Material("gwater2/finalpass")
			local col = Color(col:Unpack())
			col.r = col.r * gwater2.options.parameters.color_value_multiplier.real
			col.g = col.g * gwater2.options.parameters.color_value_multiplier.real
			col.b = col.b * gwater2.options.parameters.color_value_multiplier.real
			col.a = col.a * gwater2.options.parameters.color_value_multiplier.real
			finalpass:SetVector4D("$color2", col:Unpack())
			return true
		end
	},
	["007-Color Value Multiplier"] = {
		type="scratch",
		min=-3,
		max=3,
		decimals=2,
		setup=function(scratch)
			scratch:SetValue(gwater2.options.parameters.color_value_multiplier.real)
		end
	},
	["008-Reflectance"] = {
		type="scratch",
		min=-16,
		max=16,
		decimals=3,
		func=function(val)
			local finalpass = Material("gwater2/finalpass")
			finalpass:SetFloat("$reflectance", val)
			return true
		end,
		setup=function(slider)
			local finalpass = Material("gwater2/finalpass")
			slider:SetValue(finalpass:GetFloat("$reflectance"))
		end
	}
}
local performance = {

	["001-Iterations"] = {
		min=1,
		max=10,
		decimals=0,
		type="scratch"
	},
	["002-Substeps"] = {
		min=1,
		max=10,
		decimals=0,
		type="scratch"
	},
	["003-Blur Passes"] = {
		min=0,
		max=4,
		decimals=0,
		type="scratch",
		func=function(n)
			gwater2.options.blur_passes:SetInt(n)
		end,
		setup=function(slider)
			slider:SetValue(gwater2.options.blur_passes:GetInt())
		end
	},
	["004-Particle Limit"] = {
		min=1,
		max=1000000,
		decimals=0,
		type="scratch",
		func=function(_) return true end,
		setup=function(slider)
			slider:SetValue(gwater2.solver:GetMaxParticles())
			local panel = slider:GetParent()
			local button = panel:Add("DButton")
			button:Dock(RIGHT)
			button:SetText("")
			button:SetImage("icon16/accept.png")
			button:SetWide(button:GetTall())
			button.Paint = nil
			panel.button_apply = button
			function button:DoClick()
				local frame = styling.create_blocking_frame()
				frame:SetSize(ScrW() / 2, ScrH() / 2)
				frame:Center()
				function frame:Paint(w, h)
					styling.draw_main_background(0, 0, w, h)
				end

				-- from testing it seems each particle is around 0.8kb so you could probably do some math to figure out the memory required and show it here
				local size_fmt = 0.8*slider:GetValue() * 1024
			    local u = ""
			    for _,unit in pairs({"", "Ki", "Mi", "Gi", "Ti", "Pi", "Ei", "Zi"}) do
			    	u = unit
			    	if math.abs(size_fmt) < 1024.0 then
			    		break
			    	end
			    	size_fmt = size_fmt / 1024.0
			    end
			    size_fmt = string.format("%.2f", size_fmt)
			    size_fmt = size_fmt..u.."B"

			    local wrnpnl = frame:Add("DPanel")
				wrnpnl:Dock(TOP)
				function wrnpnl:Paint(w, h)
					local r = (math.sin(RealTime() * 2) + 1) * 255 / 2
					local s = 40
					surface.SetDrawColor(r, 0, 0, r)
					draw.NoTexture()
					for x=-s*2,w+s,s do
						x = x + ((RealTime() * 20) % s)
						surface.DrawPoly({
							{x=x, y=0}, {x=x+s/2, y=0}, {x=x+s, y=h}, {x=x+s/2, y=h}, 
						})
					end
					surface.SetDrawColor(255-r, 0, 0, 255-r)
					for x=-s/2-s,w-s/2+s,s do
						x = x + ((RealTime() * 20) % s)
						surface.DrawPoly({
							{x=x, y=0}, {x=x+s/2, y=0}, {x=x+s, y=h}, {x=x+s/2, y=h}, 
						})
					end
				end

				local label = frame:Add("DLabel")
				label:Dock(TOP)
				label:SetText(_util.get_localised("Performance.Particle Limit.title", math.floor(slider:GetValue()), size_fmt))
				label:SetFont("GWater2Title")
				label:SizeToContentsY()
				label.text = label:GetText()
				label:SetText("")
				function label:Paint() draw.DrawText(self.text, self:GetFont(), self:GetWide() / 2, 0, color_white, TEXT_ALIGN_CENTER) end

				local label2 = frame:Add("DLabel")
				label2:Dock(TOP)
				label2:SetText(_util.get_localised("Performance.Particle Limit.warning"))
				label2:SetFont("DermaDefault")
				label2:SizeToContentsY()
				label2.text = label2:GetText()
				label2:SetText("")
				function label2:Paint() draw.DrawText(self.text, self:GetFont(), self:GetWide() / 2, 0, color_white, TEXT_ALIGN_CENTER) end

				local btnpanel = frame:Add("DPanel")
				btnpanel:Dock(BOTTOM)
				function btnpanel:Paint() end

				local wrnpnl2 = frame:Add("DPanel")
				wrnpnl2:Dock(BOTTOM)
				wrnpnl2.Paint = wrnpnl.Paint

				local confirm = vgui.Create("DButton", btnpanel)
				confirm:Dock(RIGHT)
				confirm:SetText("")
				confirm:SetSize(20, 20)
				confirm:SetImage("icon16/accept.png")
				confirm.Paint = nil
				function confirm:DoClick() 
					gwater2.solver:Destroy()
					gwater2.solver = FlexSolver(slider:GetValue())
					gwater2.reset_solver(true)
					frame:Close()
					surface.PlaySound("gwater2/menu/select_ok.wav")
				end

				local deny = vgui.Create("DButton", btnpanel)
				deny:Dock(LEFT)
				deny:SetText("")
				deny:SetSize(20, 20)
				deny:SetImage("icon16/cross.png")
				deny.Paint = nil
				function deny:DoClick()
					frame:Close()
					surface.PlaySound("gwater2/menu/select_deny.wav")
				end

				surface.PlaySound("gwater2/menu/confirm.wav")
			end
		end
	},
	["005-Reaction Forces"] = {
		min=0,
		max=2,
		decimals=0,
		type="scratch"
	},
	["006-Absorption"] = {
		type="check",
		func=function(val)
			local water_volumetric = Material("gwater2/volumetric")
			gwater2.options.absorption:SetBool(val)
			water_volumetric:SetFloat("$alpha", val and 0.125 or 0)
			return true
		end,
		setup=function(check)
			check:SetValue(gwater2.options.absorption:GetBool())
		end
	},
	["007-Depth Fix"] = {
		type="check",
		func=function(val)
			local water_normals = Material("gwater2/normals")
			gwater2.options.depth_fix:SetBool(val)
			water_normals:SetInt("$depthfix", val and 1 or 0)
			return true
		end,
		setup=function(check)
			check:SetValue(gwater2.options.depth_fix:GetBool())
		end
	}
}
local interaction = {
    ["001-SwimSpeed"] = {
        type="scratch",
        min=-20,
        max=100,
        decimals=0,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["002-SwimFriction"] = {
        type="scratch",
        min=0,
        max=100,
        decimals=0,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["003-SwimBuoyancy"] = {
        type="scratch",
        min=-2,
        max=2,
        decimals=2,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["004-DrownTime"] = {
        type="scratch",
        min=0,
        max=100,
        decimals=1,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["005-DrownParticles"] = {
        type="scratch",
        min=0,
        max=200,
        decimals=0,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["006-DrownDamage"] = {
        type="scratch",
        min=0,
        max=5,
        decimals=2,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["007-MultiplyParticles"] = {
        type="scratch",
        min=0,
        max=200,
        decimals=0,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["008-MultiplyWalk"] = {
        type="scratch",
        min=0,
        max=2,
        decimals=2,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["009-MultiplyJump"] = {
        type="scratch",
        min=0,
        max=2,
        decimals=2,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["010-TouchDamage"] = {
        type="scratch",
        min=-200,
        max=200,
        decimals=2,
        func=function(val) end,
        setup=function(scratch) end
    },
}

gwater2.__PARAMS__ = {parameters=parameters, visuals=visuals, performance=performance, interaction=interaction}
return gwater2.__PARAMS__