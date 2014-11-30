Mercury = {} // Onward!
Mercury.Version = "Hotel 4"
Mercury.Booted = false
Mercury.Config = {
	UseScoreboard = true,  // Don't change this! This is designed to contain default config values in case yours get fucked up some how.
	UseTeams = true, TeamOffset = 50000,
	UseRankTime = true

} 
 
////////////////////////////
/////MILLIONS OF PIECES/////
/////PIECES FOR MEEEE~!/////
////////////////////////////



if SERVER then AddCSLuaFile("mercury/config.lua") end
include("mercury/config.lua")
///////////////////////////////////////////////////////////////////
////////////////////EXPLOSION NOISE////////////////////////////////
///////////////////////////////////////////////////////////////////

 
  
print("Initialzing Mercury.") // Its truuuuuuuuuuuuuuuuue~ 
/// That it kicks you in the teeth when you're least expecting.
local function mtag(...)
	MsgC(Color(100,255,100),"[Mercury]: ")
end
if SERVER then 
    mtag() 	MsgC(Color(255,255,0),"Checking existance of data folder... ")
	if !file.Exists("mercury","DATA") then
		 	MsgC(Color(255,0,0)," NO  \n")
		file.CreateDir("mercury") 
		    MsgN(" ") mtag() 	MsgC(Color(255,255,0)," Data folder created \n")
		else
			  	MsgC(Color(0,255,0)," OK. \n")
	end
///////////DO THE D.A.N.C.E 
///////////////// 1 2 3 4 5
	AddCSLuaFile()
////////////////SUI SCOREBOARD///////////////////////////
	if Mercury.Config["UseScoreboard"]==true then
	    mtag() 	MsgC(Color(255,255,0)," Scoreboard will be used. \n")
		AddCSLuaFile( "autorun/sui_scoreboard.lua" )
		AddCSLuaFile( "sui_scoreboard/admin_buttons.lua" )
		AddCSLuaFile( "sui_scoreboard/cl_tooltips.lua" )
		AddCSLuaFile( "sui_scoreboard/player_frame.lua" )
		AddCSLuaFile( "sui_scoreboard/player_infocard.lua" )
		AddCSLuaFile( "sui_scoreboard/player_row.lua" )
		AddCSLuaFile( "sui_scoreboard/scoreboard.lua" )
		AddCSLuaFile( "sui_scoreboard/vote_button.lua" )

		include( "sui_scoreboard/rating.lua" )
		 
		/*resource.AddFile("materials/gui/silkicons/exclamation.vmt")
		resource.AddFile("materials/gui/silkicons/heart.vmt")
		resource.AddFile("materials/gui/silkicons/palette.vmt")
		resource.AddFile("materials/gui/silkicons/star.vmt")
		resource.AddFile("materials/gui/silkicons/user.vmt")*/ 
		
	end
///////////////////////////////////////////////////////////

	for _,f in pairs(file.Find("mercury/core/lib/*.lua","LUA")) do
		local S,ER =	pcall(function() include("mercury/core/lib/" .. f) end) // OUCH!!!! MY MEMORY!!!
		if (S) then print("Loaded LIBRARY: " .. f) else
			 Msg("[Mercury]: " .. ER)
		end
	end

	for _,f in pairs(file.Find("mercury/core/*.lua","LUA")) do
		local S,ER =	pcall(function() include("mercury/core/" .. f) end) // OUCH!!!! MY MEMORY!!!
		if (S) then print("Loaded CORE: " .. f) else
			 Msg("[Mercury]: " .. ER)
		end
	end
	for _,f in pairs(file.Find("mercury/client/*.lua","LUA")) do
		local S,ER =	pcall(function() AddCSLuaFile("mercury/client/" .. f) end) 
		if (S) then print("Push CLIENT: " .. f) else
			 Msg("[Mercury]: Loaded " .. f .. "\n")
		end
	end
	for _,f in pairs(file.Find("mercury/core/extensions/*.lua","LUA")) do
		local S,ER =	pcall(function() include("mercury/core/extensions/" .. f) end) // OUCH!!!! MY MEMORY!!!
		if (S) then print("Loaded: " .. f) else
	 		 Msg("[Mercury]: " .. ER)
		end
	end
	
		Mercury.ModHook.Call("AddPrivileges")
		Mercury.ModHook.Call("PrivilegesReady")
		Mercury.ModHook.Call("ServerSideLoaded")

end


if CLIENT then

	do // Thanks, scope.
		if !file.Exists("autorun/sui_scoreboard.lua","LUA") then return false end
		include( "sui_scoreboard/scoreboard.lua" )

		SuiScoreBoard = nil
		
		timer.Simple( 1.5, function()
			function GAMEMODE:CreateScoreboard()
				if ( ScoreBoard ) then
				
					ScoreBoard:Remove()
					ScoreBoard = nil
					
				end
				
				SuiScoreBoard = vgui.Create( "suiscoreboard" )
				
				return true
			end

			function GAMEMODE:ScoreboardShow()
				if not SuiScoreBoard then
					self:CreateScoreboard()
				end

				GAMEMODE.ShowScoreboard = true
				gui.EnableScreenClicker( true )

				SuiScoreBoard:SetVisible( true )
				SuiScoreBoard:UpdateScoreboard( true )
				
				return true
			end
			
			function GAMEMODE:ScoreboardHide()
				GAMEMODE.ShowScoreboard = false
				gui.EnableScreenClicker( false )
				if SuiScoreBoard then
					SuiScoreBoard:SetVisible( false )
				end
				return true
			end
		end )
	end

	for _,f in pairs(file.Find("mercury/client/*.lua","LUA")) do
		local S,ER =	pcall(function() include("mercury/client/" .. f) end) 
		if (S) then print("Push CLIENT: " .. f) else
			 Msg("[Mercury]: Loaded " .. f .. "\n")
		end
	end


end


Mercury.Booted = true // This seems really stupid, I know. This is for later, it helps with live-updates.