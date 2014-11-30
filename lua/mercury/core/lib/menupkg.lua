	for _,f in pairs(file.Find("mercury/menu/*.lua","LUA")) do
		local S,ER =	pcall(function() AddCSLuaFile("mercury/menu/" .. f) end) // OUCH!!!! MY MEMORY!!!
		if (S) then print("Loaded: " .. f) else
	 		 Msg("[Mercury-Menu-Packager]: " .. ER)
		end
	end
