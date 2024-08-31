-- fixes menu not working in singleplayer because of predicted hooks. Fuck this shit hack
if !game.SinglePlayer() or CLIENT then return end

hook.Add("PlayerButtonDown", "gwater2_menu", function(ply, key)
	ply:SendLua("if OpenGW2Menu then OpenGW2Menu(LocalPlayer(), " .. key .. ") end")
end)
hook.Add("PlayerButtonUp", "gwater2_menu", function(ply, key)
	ply:SendLua("if CloseGW2Menu then CloseGW2Menu(LocalPlayer(), " .. key .. ") end")
end)