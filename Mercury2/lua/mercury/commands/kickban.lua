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


	Mercury.Bans.Add(caller,args[1],tonumber(args[2]),args[3])
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