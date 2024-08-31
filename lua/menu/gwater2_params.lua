AddCSLuaFile()

if SERVER or not gwater2 then return end

if gwater2.__PARAMS__ then return gwater2.__PARAMS__ end

local styling = include("menu/gwater2_styling.lua")

local parameters = {
	["001-Physics Parameters"] = {
		["list"] = {
			["001-Adhesion"] = {
				desc="Controls how well particles stick to surfaces.\n\n"..
					 "Note that this specific parameter doesn't reflect changes in the preview very well and may need to be viewed externally.",
				min=0,
				max=0.2,
				decimals=3,
				type="scratch"
			},
			["002-Cohesion"] = {
				desc="Controls how well particles hold together.\n\n"..
					 "Higher values make the fluid more solid/rigid, while lower values make it more fluid and loose.",
				min=0,
				max=2,
				decimals=3,
				type="scratch"
			},
			["003-Radius"] = {
				desc="Controls the size of each particle.\n\n"..
					 "In the preview it is clamped to 15 to avoid weirdness.\n\n"..
					 "Radius is measured in source units and is the same for all particles.",
				min=1,
				max=100,
				decimals=1,
				type="scratch"
			},
			["004-Gravity"] = {
				desc="Controls how strongly fluid is pulled down. This value is measured in meters per second.\n\n"..
					 "Note that the default source gravity is -15.24 which is NOT the same as Earths gravity of -9.81.",
				min=-30.48,
				max=30.48,
				decimals=2,
				type="scratch"
			},
			["005-Viscosity"] = {
				desc="Controls how much particles resist movement.\n\n"..
					 "Higher values look more like honey or syrup, while lower values look like water or oil.",
				min=0,
				max=20,
				decimals=2,
				type="scratch"
			},
			["006-Surface Tension"] = {
				desc="Controls how strongly particles minimize surface area.\n\n"..
					 "This parameter tends to make particles behave oddly if set too high\n\nUsually bundled with cohesion.",
				min=0,
				max=1,
				decimals=2,
				type="scratch"
			},
			["007-Timescale"] = {
				desc="Sets the speed of the simulation.\n\n"..
					 "Note that some parameters like cohesion and surface tension may behave differently due to smaller or larger compute times",
				min=0,
				max=2,
				decimals=2,
				type="scratch"
			}
		},
		["desc"] = "Parameters that directly influence physics interactions with water."
	},
	["002-Advanced Physics Parameters"] = {
		["list"] = {
			["001-Collision Distance"] = {
				desc="Controls the collision distance between particles and objects.\n\n"..
					 "Note that a lower collision distance will cause particles to clip through objects more often.",
				min=0.1,
				max=1,
				decimals=2,
				type="scratch"
			},
			["002-Fluid Rest Distance"] = {
				desc="Controls the collision distance between particles.\n\n"..
					 "Higher values cause more lumpy liquids while lower values cause smoother liquids",
				min=0.55,
				max=0.85,
				decimals=2,
				type="scratch"
			},
			["003-Dynamic Friction"] = {
				desc="Controls the amount of friction particles receive on surfaces.\n\n"..
					 "Causes Adhesion to behave weirdly when set to 0.",
				min=0,
				max=1,
				decimals=2,
				type="scratch"
			},
			["004-Vorticity Confinement"] = {
				desc="Increases the vorticity effect by applying rotational forces to particles.\n\n"..
					 "This exists because air pressure cannot be efficiently simulated.",
				min=0,
				max=200,
				decimals=0,
				type="scratch"
			}
		},
		["desc"] = "More technical settings."
	},
	["003-Reaction Force Parameters"] = {
		["list"] = {
			["001-Force Multiplier"] = {
				desc="Determines the amount of force which is applied to props by water.",
				min=0.001,
				max=0.02,
				decimals=3,
				type="scratch"
			},
			["002-Force Buoyancy"] = {
				desc="Buoyant force which is applied to props in water.\n\n"..
					 "The implementation is by no means accurate and probably should not be used for prop boats.",
				min=0,
				max=500,
				decimals=1,
				type="scratch"
			},
			["003-Force Dampening"] = {
				desc="Dampening force applied to props.\n\n"..
					 "Helps a little bit if props tend to bounce on the water surface.",
				min=0,
				max=1,
				decimals=2,
				type="scratch"
			}
		},
		["desc"] = "'Reaction Forces' (in performance tab) must be set to 2 for these to work!"
	}
}
local visuals = {
	["001-Diffuse Threshold"] = {
		desc="Controls the amount of force required to make a bubble/foam particle.",
		min=1,
		max=500,
		decimals=1,
		type="scratch"
	},
	["002-Diffuse Lifetime"] = {
		desc="Controls how long bubbles/foam particles last after being created.\n\n"..
			 "This is affected by the Timescale parameter.\n\n"..
			 "Setting this to zero will spawn no diffuse particles",
		min=0,
		max=20,
		decimals=1,
		type="scratch"
	},
	["003-Anisotropy Scale"] = {
		desc="Controls the visual size of stretching between particles.\n\n"..
			 "Making this value zero will turn off stretching.",
		min=0,
		max=2,
		decimals=2,
		type="scratch"
	},
	["004-Anisotropy Min"] = {
		desc="Controls the minimum visual size that particles can be.",
		min=-0.1,
		max=1,
		decimals=2,
		type="scratch"
	},
	["005-Anisotropy Max"] = {
		desc="Controls the maximum visual size that particles are allowed to stretch between particles.",
		min=0,
		max=2,
		decimals=2,
		type="scratch"
	},
	["006-Color"] = {
		desc="Controls the color of the fluid.\n\n"..
			 "The alpha (transparency) channel controls the amount of color absorbsion.\n\n"..
			 "An alpha value of 255 (maxxed) makes the fluid opaque.",
		type="color",
		func=function(col)
			local finalpass = Material("gwater2/finalpass")
			local col = Color(gwater2.options.parameters.color.real:Unpack())
			col.r = col.r * gwater2.options.parameters.color_value_multiplier.real
			col.g = col.g * gwater2.options.parameters.color_value_multiplier.real
			col.b = col.b * gwater2.options.parameters.color_value_multiplier.real
			col.a = col.a * gwater2.options.parameters.color_value_multiplier.real
			finalpass:SetVector4D("$color2", col:Unpack())
		end
	},
	["007-Color Value Multiplier"] = {
		desc="Controls the multiplier of color of the fluid.",
		type="scratch",
		min=-3,
		max=3,
		decimals=2,
		setup=function(scratch)
			scratch:SetValue(gwater2.options.parameters.color_value_multiplier.real)
		end
	},
	["008-Reflectance"] = {
		desc="Defines how reflective water is.",
		type="scratch",
		min=-16,
		max=16,
		decimals=3,
		func=function(val)
			local finalpass = Material("gwater2/finalpass")
			finalpass:SetFloat("$reflectance", val)
			return true
		end
	}
}
local performance = {
	["001-Iterations"] = {
		desc="Controls how many times the physics solver attempts to converge to a solution per substep.\n\n"..
			 "Medium performance impact.",
		min=1,
		max=10,
		decimals=0,
		type="scratch"
	},
	["002-Substeps"] = {
		desc="Controls the number of physics steps done per tick.\n\n"..
			 "Note that parameters may not be properly tuned for different substeps!\n\n"..
			 "Medium-High performance impact.",
		min=1,
		max=10,
		decimals=0,
		type="scratch"
	},
	["003-Blur Passes"] = {
		desc="Controls the number of blur passes done per frame. More passes creates a smoother water surface. Zero passes will do no blurring.\n\n"..
			 "Low performance impact.",
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
		desc="USE THIS PARAMETER AT YOUR OWN RISK.\n\n"..
			 "Changes the limit of particles.\n\n"..
			 "Note that a higher limit will negatively impact performance even with the same number of particles spawned.",
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
				local mainFrame = panel:GetParent():GetParent():GetParent():GetParent():GetParent()
				local frame = styling.create_blocking_frame(mainFrame)
				function frame:Paint(w, h)
					styling.draw_main_background(0, 0, w, h)

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

					draw.DrawText("You are about to change the particle limit to \n" .. math.floor(slider:GetValue()) .. " ("..size_fmt..") .\nAre you sure?", "GWater2Title", 200, 30, color_white, TEXT_ALIGN_CENTER)
					draw.DrawText("This can be dangerous, because all particles must be allocated on the GPU.\n"..
								  "DO NOT set the limit to a number higher then you think your computer can handle.\n"..
								  "I DO NOT take responsiblity for any damage to your computer this may cause.",
								  "DermaDefault", 200, 110, color_white, TEXT_ALIGN_CENTER)
				end

				local confirm = vgui.Create("DButton", frame)
				confirm:SetPos(260, 160)
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

				local deny = vgui.Create("DButton", frame)
				deny:SetPos(110, 160)
				deny:SetText("")
				deny:SetSize(20, 20)
				deny:SetImage("icon16/cross.png")
				deny.Paint = nil
				function deny:DoClick()
					frame:Close()
					surface.PlaySound("gwater2/menu/select_deny.wav")
				end
				input.SetCursorPos(frame:GetX()+120, frame:GetY()+170)

				surface.PlaySound("gwater2/menu/confirm.wav")
			end
		end
	},
	["005-Reaction Forces"] = {
		desc="0 = No reaction forces\n\n"..
			 "1 = Simple reaction forces. (Swimming)\n\n"..
			 "2 = Full reaction forces (Water can move props).",
		min=0,
		max=2,
		decimals=0,
		type="scratch"
	},
	["006-Absorption"] = {
		desc="Enables absorption of light over distance inside of fluid.\n\n"..
			 "(more depth = darker color)\n\n"..
			 "Medium performance impact.",
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
		desc="Makes particles appear spherical instead of flat, creating a cleaner and smoother water surface.\n\n"..
			 "Causes shader overdraw.\n\n"..
			 "Medium-High performance impact.",
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
        desc="",
        type="scratch",
        min=-20,
        max=100,
        decimals=0,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["002-SwimFriction"] = {
        desc="",
        type="scratch",
        min=0,
        max=100,
        decimals=0,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["003-SwimBuoyancy"] = {
        desc="",
        type="scratch",
        min=-2,
        max=2,
        decimals=2,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["004-DrownTime"] = {
        desc="",
        type="scratch",
        min=0,
        max=100,
        decimals=1,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["005-DrownParticles"] = {
        desc="",
        type="scratch",
        min=0,
        max=200,
        decimals=0,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["006-DrownDamage"] = {
        desc="",
        type="scratch",
        min=0,
        max=5,
        decimals=2,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["007-MultiplyParticles"] = {
        desc="",
        type="scratch",
        min=0,
        max=200,
        decimals=0,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["008-MultiplyWalk"] = {
        desc="",
        type="scratch",
        min=0,
        max=2,
        decimals=2,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["009-MultiplyJump"] = {
        desc="",
        type="scratch",
        min=0,
        max=2,
        decimals=2,
        func=function(val) end,
        setup=function(scratch) end
    },
    ["010-TouchDamage"] = {
        desc="",
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