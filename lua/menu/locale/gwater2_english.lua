local strings = {
	["gwater2.menu.title"]="GWater2 (%s)",

	["gwater2.menu.About Tab.title"] = "About Tab",
	["gwater2.menu.About Tab.titletext"] = "Welcome to GWater2 (v%s)",
	["gwater2.menu.About Tab.welcome"]=[[
			Thank you for downloading gwater2 beta! This menu is the interface that you will be using to control everything about gwater. So get used to it! :D

			Make sure to read the changelog to see what has been updated!

			Changelog (v0.5b):
			- Added cloth to spawnmenu
			- Added black hole to spawnmenu
			- Added emitter, and drain entity to spawnmenu
			- Added particle lifetimes (evaporation)
			- Added gravity gun interaction
			- Tweaked absorption, reflection, and phong calculations to be more realistic
			- Tweaked diffuse visuals
			- Tweaked portal gel preset to look more like portal gel
			- Fixed particles not going through objects with 'Disable Collision' on
			- Fixed a majority of particle clipping issues
			- Fixed being able to 'fly' in adhesive liquids
			- General backend code cleanup and API improvements
	]],
	["gwater2.menu.About Tab.help"]=[[
		On each tab, this area will contain useful information.

		For example:
		Clicking anywhere outside the menu, or re-pressing the menu button will close it.

		Make sure to read this area!
	]],

	["gwater2.menu.Parameters.title"]="Parameters",
	["gwater2.menu.Parameters.titletext"]="Parameters",
	["gwater2.menu.Parameters.help"]=[[
		This tab is where you can change how the water interacts with itself and the environment.

		Hover over a parameter to reveal its functionality.
	]],

	["gwater2.menu.Visuals.title"]="Visuals",
	["gwater2.menu.Visuals.titletext"]="Visuals",
	["gwater2.menu.Visuals.help"]=[[
		This tab controls what the fluid looks like.

		Hover over a parameter to reveal its functionality.
	]],

	["gwater2.menu.Performance.title"]="Performance",
	["gwater2.menu.Performance.titletext"]="Performance",
	["gwater2.menu.Performance.help"]=[[
		This tab has options which can help and alter your performance.

		Each option is colored between green and red to indicate its performance hit.

		All parameters directly impact the GPU.

		Hover over a parameter to reveal its functionality.
	]],

	["gwater2.menu.Interactions.title"]="Interactions",
	["gwater2.menu.Interactions.titletext"]="Interactions",
	["gwater2.menu.Interactions.help"]=[[
		Controls how water interacts with players.
	]],

	["gwater2.menu.Presets.title"]="Presets",
	["gwater2.menu.Presets.titletext"]="Presets",
	["gwater2.menu.Presets.help"]=[[
		Presets tab, provides access to liquid presets.
	]],
	["gwater2.menu.Presets.import_preset"]="Import preset",
	["gwater2.menu.Presets.import.paste_here"]="Paste preset here",
	["gwater2.menu.Presets.import.detected"]="Detected: %s preset",
	["gwater2.menu.Presets.import.bad_data"]="Data is malformed or preset type is unknown.",
	["gwater2.menu.Presets.save"]="Save preset",
	["gwater2.menu.Presets.save.preset_name"]="Preset name",
	["gwater2.menu.Presets.save.include_params"]="Include next parameters",
	["gwater2.menu.Presets.copy"]="Copy to clipboard",
	["gwater2.menu.Presets.copy.as_json"]="...as JSON",
	["gwater2.menu.Presets.copy.as_b64pi"]="...as B64-PI",
	["gwater2.menu.Presets.delete"]="Delete",

	["gwater2.menu.Patrons.title"] = "Patrons",
	["gwater2.menu.Patrons.titletext"]="Patrons",
	["gwater2.menu.Patrons.help"]=[[
		This tab has a list of all my patrons.

		The list is sorted in alphabetical order.

		It will be updated routinely until release.
	]],
	["gwater2.menu.Patrons.text"]=[[
		Thanks to everyone here who supported me throughout the development of GWater2!
			
		All revenue generated from this project goes directly to my college fund. Thanks so much guys :)
		-----------------------------------------
	]],

	["gwater2.menu.Parameters.Physics Parameters"]="Physics Parameters",
	["gwater2.menu.Parameters.Advanced Physics Parameters"]="Advanced Physics Parameters",
	["gwater2.menu.Parameters.Reaction Force Parameters"]="Reaction Forces Parameters",

	["gwater2.menu.Parameters.Adhesion"]="Adhesion",
	["gwater2.menu.Parameters.Adhesion.desc"]=[[
		Controls how well particles stick to surfaces.

		Note that this specific parameter doesn't reflect changes in the preview very well and may need to be viewed externally.
	]],
	["gwater2.menu.Parameters.Gravity"]="Gravity",
	["gwater2.menu.Parameters.Gravity.desc"]=[[
		Controls how strongly fluid is pulled down. This value is measured in meters per second.

		Note that the default source gravity is -15.24 which is NOT the same as Earths gravity of -9.81.
	]],
	["gwater2.menu.Parameters.Cohesion"]="Cohesion",
	["gwater2.menu.Parameters.Cohesion.desc"]=[[
		Controls how well particles hold together.

		Higher values make the fluid more solid/rigid, while lower values make it more fluid and loose.
	]],
	["gwater2.menu.Parameters.Surface Tension"]="Surface Tension",
	["gwater2.menu.Parameters.Surface Tension.desc"]=[[
		Controls how strongly particles minimize surface area.

		This parameter tends to make particles behave oddly if set too high

		Usually bundled with cohesion.
	]],
	["gwater2.menu.Parameters.Viscosity"]="Viscosity",
	["gwater2.menu.Parameters.Viscosity.desc"]=[[
		Controls how much particles resist movement.

		Higher values look more like honey or syrup, while lower values look like water or oil.
	]],
	["gwater2.menu.Parameters.Radius"]="Radius",
	["gwater2.menu.Parameters.Radius.desc"]=[[
		Controls the size of each particle.

		In the preview it is clamped to 15 to avoid weirdness.

		Radius is measured in source units and is the same for all particles.
	]],
	["gwater2.menu.Parameters.Timescale"]="Timescale",
	["gwater2.menu.Parameters.Timescale.desc"]=[[
		Sets the speed of the simulation.

		Note that some parameters like cohesion and surface tension may behave differently due to smaller or larger compute times
	]],
	["gwater2.menu.Parameters.Dynamic Friction"]="Dynamic Friction",
	["gwater2.menu.Parameters.Dynamic Friction.desc"]=[[
		Controls the amount of friction particles receive on surfaces.

		Causes Adhesion to behave weirdly when set to 0.
	]],
	["gwater2.menu.Parameters.Vorticity Confinement"]="Vorticity Confinement",
	["gwater2.menu.Parameters.Vorticity Confinement.desc"]=[[
		Increases the vorticity effect by applying rotational forces to particles.

		This exists because air pressure cannot be efficiently simulated.
	]],
	["gwater2.menu.Parameters.Collision Distance"]="Collision Distance",
	["gwater2.menu.Parameters.Collision Distance.desc"]=[[
		Controls the collision distance between particles and objects.

		Note that a lower collision distance will cause particles to clip through objects more often.
	]],
	["gwater2.menu.Parameters.Fluid Rest Distance"]="Fluid Rest Distance",
	["gwater2.menu.Parameters.Fluid Rest Distance.desc"]=[[
		Controls the collision distance between particles.

		Higher values cause more lumpy liquids while lower values cause smoother liquids
	]],
	["gwater2.menu.Parameters.Force Buoyancy"]="Force Buoyancy",
	["gwater2.menu.Parameters.Force Buoyancy.desc"]=[[
		Buoyant force which is applied to props in water.

		The implementation is by no means accurate and probably should not be used for prop boats.
	]],
	["gwater2.menu.Parameters.Force Dampening"]="Force Dampening",
	["gwater2.menu.Parameters.Force Dampening.desc"]=[[
		Dampening force applied to props.

		Helps a little bit if props tend to bounce on the water surface.
	]],
	["gwater2.menu.Parameters.Force Multiplier"]="Force Multiplier",
	["gwater2.menu.Parameters.Force Multiplier.desc"]=[[
		Determines the amount of force which is applied to props by water.
	]],

	["gwater2.menu.Visuals.Diffuse Threshold"]="Diffuse Threshold",
	["gwater2.menu.Visuals.Diffuse Threshold.desc"]=[[
		Controls the amount of force required to make a bubble/foam particle.
	]],
	["gwater2.menu.Visuals.Color"]="Color",
	["gwater2.menu.Visuals.Color.desc"]=[[
		Controls the color of the fluid.

		The alpha (transparency) channel controls the amount of color absorbsion.

		An alpha value of 255 (maxxed) makes the fluid opaque.
	]],
	["gwater2.menu.Visuals.Anisotropy Max"]="Anisotropy Max",
	["gwater2.menu.Visuals.Anisotropy Max.desc"]=[[
		Controls the maximum visual size that particles are allowed to stretch between particles.
	]],
	["gwater2.menu.Visuals.Diffuse Lifetime"]="Diffuse Lifetime",
	["gwater2.menu.Visuals.Diffuse Lifetime.desc"]=[[
		Controls how long bubbles/foam particles last after being created.

		This is affected by the Timescale parameter.

		Setting this to zero will spawn no diffuse particles
	]],
	["gwater2.menu.Visuals.Anisotropy Min"]="Anisotropy Min",
	["gwater2.menu.Visuals.Anisotropy Min.desc"]=[[
		Controls the minimum visual size that particles can be.
	]],
	["gwater2.menu.Visuals.Reflectance"]="Reflectance",
	["gwater2.menu.Visuals.Reflectance.desc"]=[[
		Defines how reflective water is.
	]],
	["gwater2.menu.Visuals.Anisotropy Scale"]="Anisotropy Scale",
	["gwater2.menu.Visuals.Anisotropy Scale.desc"]=[[
		Controls the visual size of stretching between particles.

		Making this value zero will turn off stretching.
	]],
	["gwater2.menu.Visuals.Color Value Multiplier"]="Color Value Multiplier",
	["gwater2.menu.Visuals.Color Value Multiplier.desc"]=[[
		Controls the multiplier of color of the fluid.

		Setting it to anything higher than 1 makes liquid "glow" under certain conditions.
	]],

	["gwater2.menu.Performance.Blur Passes"]="Blur Passes",
	["gwater2.menu.Performance.Blur Passes.desc"]=[[
		Controls the number of blur passes done per frame. More passes creates a smoother water surface. Zero passes will do no blurring.

		Low performance impact.
	]],
	["gwater2.menu.Performance.Reaction Forces"]="Reaction Forces",
	["gwater2.menu.Performance.Reaction Forces.desc"]=[[
		0 = No reaction forces

		1 = Simple reaction forces. (Swimming)

		2 = Full reaction forces (Water can move props).
	]],
	["gwater2.menu.Performance.Absorption"]="Absorption",
	["gwater2.menu.Performance.Absorption.desc"]=[[
		Enables absorption of light over distance inside of fluid.

		(more depth = darker color)

		Medium performance impact.
	]],
	["gwater2.menu.Performance.Substeps"]="Substeps",
	["gwater2.menu.Performance.Substeps.desc"]=[[
		Controls the number of physics steps done per tick.

		Note that parameters may not be properly tuned for different substeps!

		Medium-High performance impact.
	]],
	["gwater2.menu.Performance.Depth Fix"]="Depth Fix",
	["gwater2.menu.Performance.Depth Fix.desc"]=[[
		Makes particles appear spherical instead of flat, creating a cleaner and smoother water surface.

		Causes shader overdraw.

		Medium-High performance impact.
	]],
	["gwater2.menu.Performance.Particle Limit"]="Particle Limit",
	["gwater2.menu.Performance.Particle Limit.desc"]=[[
		USE THIS PARAMETER AT YOUR OWN RISK.

		Changes the limit of particles.

		Note that a higher limit will negatively impact performance even with the same number of particles spawned.
	]],
	["gwater2.menu.Performance.Iterations"]="Iterations",
	["gwater2.menu.Performance.Iterations.desc"]=[[
		Controls how many times the physics solver attempts to converge to a solution per substep.

		Medium performance impact.
	]],

	["gwater2.menu.Interactions.SwimSpeed"]="Swim Speed",
	["gwater2.menu.Interactions.SwimSpeed.desc"]="Controls how much your speed changes while you swim",
	["gwater2.menu.Interactions.SwimFriction"]="Swim Friction",
	["gwater2.menu.Interactions.SwimFriction.desc"]="Controls how much water will resist to your movement",
	["gwater2.menu.Interactions.SwimBuoyancy"]="Swim Buoyancy",
	["gwater2.menu.Interactions.SwimBuoyancy.desc"]="Controls how much water will try and push you out.",
	["gwater2.menu.Interactions.DrownTime"]="Drowning Time",
	["gwater2.menu.Interactions.DrownTime.desc"]="Determines how much time should pass before you start drowning.",
	["gwater2.menu.Interactions.DrownParticles"]="Drowning Particles",
	["gwater2.menu.Interactions.DrownParticles.desc"]="Determines how many particles you should be contacting before drowning starts.",
	["gwater2.menu.Interactions.DrownDamage"]="Drowning Damage",
	["gwater2.menu.Interactions.DrownDamage.desc"]="Determines how much damage is dealt to you every second you drown.",
	["gwater2.menu.Interactions.MultiplyParticles"]="Multiply Particles",
	["gwater2.menu.Interactions.MultiplyParticles.desc"]="Controls how much particles you should be contacting before multipliers take effect.",
	["gwater2.menu.Interactions.MultiplyWalk"]="Walk Speed Multiplier",
	["gwater2.menu.Interactions.MultiplyWalk.desc"]="Determines how much your walk and run speeds are multiplied by.",
	["gwater2.menu.Interactions.MultiplyJump"]="Jump Power Multiplier",
	["gwater2.menu.Interactions.MultiplyJump.desc"]="Determines how much your jump power is multiplied by.",
	["gwater2.menu.Interactions.TouchDamage"]="Touch Damage",
	["gwater2.menu.Interactions.TouchDamage.desc"]="Controls how much damage will be dealt every tick that you are in water.",

	["gwater2.menu.Menu.title"]="Menu",
	["gwater2.menu.Menu.titletext"]="Menu",
	["gwater2.menu.Menu.help"]=[[
		This tab controls visuals and behavior of menu
	]],
}

return strings, "english"