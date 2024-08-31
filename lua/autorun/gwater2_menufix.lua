-- fixes menu not working in singleplayer because of predicted hooks. Fuck this shit hack
if !game.SinglePlayer() or CLIENT then return end

hook.Add("PlayerButtonDown", "gwater2_menu2", function(ply, key)
	ply:SendLua("if OpenGW2Menu2 then OpenGW2Menu2(LocalPlayer(), " .. key .. ") end")
end)
hook.Add("PlayerButtonUp", "gwater2_menu2", function(ply, key)
	ply:SendLua("if CloseGW2Menu2 then CloseGW2Menu2(LocalPlayer(), " .. key .. ") end")
end)