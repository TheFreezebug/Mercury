MCMD = {}
MCMD.Command = "kick"
MCMD.Verb = "kicked"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true



function callfunc(caller,args)
	if !args[2] then 
		args[2] = "Kicked by administrator."
	end

	timer.Simple(0.1,function() 
		args[1]:Kick(args[2])
	end)





	return true,"heh",true,{Color(1,1,1,255),caller,Color(47,150,255,255)," has kicked ", args[1], Color(255,255,255,255) ," (", args[2],")"} //RETURN CODES.
	// First argument true / false -- Command succeeded? 
	// Second argument: String error, if first argument is false this is pushed to the client.
	// Third argument true / false -- supress default messages
	// Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)
		local selectedplayer = nil 

			local ctrl = vgui.Create( "DListView", frame)
			ctrl:AddColumn( "Players" )
			ctrl:SetSize( 210, 380 )	
			ctrl:SetPos( 10, 0 )
				
			local TextEntry = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
			TextEntry:SetPos( 240, 10 )
			TextEntry:SetSize( 130, 20 )
			TextEntry:SetText( "Kicked by administrator." )

			local DButtonRmsel = vgui.Create( "DButton" , frame)
			DButtonRmsel:SetPos( 240, 40 )
			DButtonRmsel:SetText( "Kick" )
			DButtonRmsel:SetSize( 130, 60 )
			DButtonRmsel:SetDisabled(true)
			DButtonRmsel.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				local lid = ctrl:GetSelectedLine()
				ctrl:RemoveLine(lid)	
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("kick")
					net.WriteTable({selectedplayer,TextEntry:GetText()})
				net.SendToServer()
				self:SetDisabled(true)
			end


		
			local players = player.GetAll()
			local t = {}
			for _, ply in ipairs( players ) do
				local item = ctrl:AddLine( ply:Nick() )
				item.ply = ply
			end	

			function ctrl:OnRowSelected(lineid,isselected)
				local line_obj = self:GetLine(lineid)
				surface.PlaySound("buttons/button6.wav")
				DButtonRmsel:SetDisabled(false)
				selectedplayer = line_obj.ply
				return true
			end
end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)










MCMD = {}
MCMD.Command = "ban"
MCMD.Verb = "kicked"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true



function callfunc(caller,args)
	if !args[2] or !tonumber(args[2]) then
		return false,"No time specified"
	end
	if !args[3] then 
		args[3] = "Banned by administrator"
	end


	sts,err = Mercury.Bans.Add(caller,args[1],tonumber(args[2]),args[3])

	timer.Simple(0.1,function()
		args[1]:Kick(args[2])
	end)

	local bancolor = Color(0,0,255)
	local timestring = args[2] .. " minutes"
	if tonumber(args[2])==0 then
		bancolor = Color(255,0,0)
		timestring = "eternety"
	end



	return true,"heh",true,{Color(1,1,1,255),caller,Color(47,150,255,255)," has banned ", args[1], " for ", bancolor,timestring," ", Color(255,255,255,255) ," (", args[3],")"} //RETURN CODES.
	// First argument true / false -- Command succeeded? 
	// Second argument: String error, if first argument is false this is pushed to the client.
	// Third argument true / false -- supress default messages
	// Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)
		local selectedplayer = nil 

			local ctrl = vgui.Create( "DListView", frame)
			ctrl:AddColumn( "Players" )
			ctrl:SetSize( 210, 380 )	
			ctrl:SetPos( 10, 0 )
			local ImmuLab = vgui.Create( "DLabel", frame )
					ImmuLab:SetPos( 240 , 10 )
					ImmuLab:SetText( "Reason" )
				ImmuLab:SetTextColor(Color(1,1,1,255))
	
			local TextEntry = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
			TextEntry:SetPos( 240, 30 )
			TextEntry:SetSize( 130, 20 )
			TextEntry:SetText( "Banned by administrator" )


			local TimeLab = vgui.Create( "DLabel", frame )
			TimeLab:SetPos( 240 , 45 )
			TimeLab:SetText( "Time (0 = perma)" )
			TimeLab:SetTextColor(Color(1,1,1,255))
			TimeLab:SizeToContentsX()
			local BanLength = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
			BanLength:SetPos( 240, 60 )
			BanLength:SetSize( 130, 20 )
			BanLength:SetText( "1440" )

			local DButtonRmsel = vgui.Create( "DButton" , frame)
			DButtonRmsel:SetPos( 240, 100 )
			DButtonRmsel:SetText( "Ban this user" )
			DButtonRmsel:SetSize( 130, 60 )
			DButtonRmsel:SetDisabled(true)
			DButtonRmsel.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				local lid = ctrl:GetSelectedLine()
				ctrl:RemoveLine(lid)	
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("ban")
					net.WriteTable({selectedplayer,BanLength:GetText(),TextEntry:GetText(),})
				net.SendToServer()
				self:SetDisabled(true)
			end


		
			local players = player.GetAll()
			local t = {}
			for _, ply in ipairs( players ) do
				local item = ctrl:AddLine( ply:Nick() )
				item.ply = ply
			end	

			function ctrl:OnRowSelected(lineid,isselected)
				local line_obj = self:GetLine(lineid)
				surface.PlaySound("buttons/button6.wav")
				DButtonRmsel:SetDisabled(false)
				selectedplayer = line_obj.ply
				return true
			end
end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)










MCMD = {}
MCMD.Command = "banid"
MCMD.Verb = "banned id"
MCMD.RconUse = true
MCMD.Useage = "<steamid> <time> <reason> "
MCMD.UseImmunity = true
MCMD.PlayerTarget = false
MCMD.HasMenu = true



function callfunc(caller,args)
	if !args[1] then 
		return false,"No steamid specified" end
	if !args[2] or !tonumber(args[2]) then
		return false,"No time specified"
	end
	if !args[3] then 
		args[3] = "Banned by administrator"
	end

	if !string.find(string.upper(args[1]),"STEAM_") then
		return false,"That is not a valid steamid."
	end


	local sts,err = Mercury.Bans.Add(caller,args[1],tonumber(args[2]),args[3])



	local bancolor = Color(0,0,255)
	local timestring = args[2] .. " minutes"
	if tonumber(args[2])==0 then
		bancolor = Color(255,0,0)
		timestring = "eternety"
	end



	return true,"heh",true,{Color(1,1,1,255),caller,Color(47,150,255,255)," has banned ", args[1], " for ", bancolor,timestring," ", Color(255,255,255,255) ," (", args[3],")"} //RETURN CODES.
	// First argument true / false -- Command succeeded? 
	// Second argument: String error, if first argument is false this is pushed to the client.
	// Third argument true / false -- supress default messages
	// Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)
		local selectedplayer = nil 

		 
			local ImmuLab = vgui.Create( "DLabel", frame )
					ImmuLab:SetPos( 10 , 0 )
					ImmuLab:SetText( "Reason" )
				ImmuLab:SetTextColor(Color(1,1,1,255))
	
			local TextEntry = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
			TextEntry:SetPos( 10, 20 )
			TextEntry:SetSize( 130, 20 )
			TextEntry:SetText( "Banned by administrator" )


			local TimeLab = vgui.Create( "DLabel", frame )
			TimeLab:SetPos( 10 , 40 )
			TimeLab:SetText( "Time (0 = perma)" )
			TimeLab:SetTextColor(Color(1,1,1,255))
			TimeLab:SizeToContentsX()
			local BanLength = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
			BanLength:SetPos( 10, 60 )
			BanLength:SetSize( 130, 20 )
			BanLength:SetText( "1440" )


			local TimeLab = vgui.Create( "DLabel", frame )
			TimeLab:SetPos( 10 , 80 )
			TimeLab:SetText( "Steam ID" )
			TimeLab:SetTextColor(Color(1,1,1,255))
			TimeLab:SizeToContentsX()
			local SteamID = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
			SteamID:SetPos( 10, 100 )
			SteamID:SetSize( 130, 20 )
			SteamID:SetText( "" )

			local DButtonRmsel = vgui.Create( "DButton" , frame)
			DButtonRmsel:SetPos( 10, 180 )
			DButtonRmsel:SetText( "Ban this ID" )
			DButtonRmsel:SetSize( 130, 60 )

			DButtonRmsel.DoClick = function(self)
				//if self:GetDisabled()==true then return false end
			//	local lid = ctrl:GetSelectedLine()
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("banid")
					net.WriteTable({SteamID:GetText(),BanLength:GetText(),TextEntry:GetText(),})
				net.SendToServer()
				 
			end

end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)










MCMD = {}
MCMD.Command = "unban"
MCMD.Verb = "banned id"
MCMD.RconUse = true
MCMD.Useage = "<steamid> <time> <reason> "
MCMD.UseImmunity = true
MCMD.PlayerTarget = false
MCMD.HasMenu = true
 


function callfunc(caller,args)
	if !args[1] then 
		return false,"No steamid specified" end
	if !args[2] then
		args[2] = "Unbanned by administrator."
	end


	if !string.find(string.upper(args[1]),"STEAM_") then
		return false,"That is not a valid steamid."
	end


	sts,err = Mercury.Bans.UnbanID(args[1],args[2])
	if sts~=true then
		return false,err
	end




	return true,"heh",true,{Color(1,1,1,255),caller,Color(47,150,255,255)," has unbanned ", args[1], Color(255,255,255,255) ," (", args[2],")"} //RETURN CODES.
	// First argument true / false -- Command succeeded? 
	// Second argument: String error, if first argument is false this is pushed to the client.
	// Third argument true / false -- supress default messages
	// Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)
		local selectedplayer = nil 

		 
			local ImmuLab = vgui.Create( "DLabel", frame )
					ImmuLab:SetPos( 10 , 0 )
					ImmuLab:SetText( "Reason" )
				ImmuLab:SetTextColor(Color(1,1,1,255))
	
			local TextEntry = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
			TextEntry:SetPos( 10, 20 )
			TextEntry:SetSize( 130, 20 )
			TextEntry:SetText( "Banned by administrator" )



			local TimeLab = vgui.Create( "DLabel", frame )
			TimeLab:SetPos( 10 , 40 )
			TimeLab:SetText( "Steam ID" )
			TimeLab:SetTextColor(Color(1,1,1,255))
			TimeLab:SizeToContentsX()
			local SteamID = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
			SteamID:SetPos( 10, 60 )
			SteamID:SetSize( 130, 20 )
			SteamID:SetText( "" )

			local DButtonRmsel = vgui.Create( "DButton" , frame)
			DButtonRmsel:SetPos( 10, 180 )
			DButtonRmsel:SetText( "Ban this ID" )
			DButtonRmsel:SetSize( 130, 60 )

			DButtonRmsel.DoClick = function(self)
				//if self:GetDisabled()==true then return false end
			//	local lid = ctrl:GetSelectedLine()
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("unban")
					net.WriteTable({SteamID:GetText(),TextEntry:GetText()})
				net.SendToServer()
				 
			end

end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)