MCMD = {}
MCMD.Command = "goto"
MCMD.Verb = "gone to"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = false 
MCMD.PlayerTarget = true
MCMD.HasMenu = true



function callfunc(caller,args)

	caller:SetPos(args[1]:GetPos() + Vector(0,0,80) )



	return true,"heh",false,{}
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
				

			local DButtonRmsel = vgui.Create( "DButton" , frame)
			DButtonRmsel:SetPos( 240, 40 )
			DButtonRmsel:SetText( "GoTo" )
			DButtonRmsel:SetSize( 130, 60 )
			DButtonRmsel:SetDisabled(true)
			DButtonRmsel.DoClick = function(self)
				if self:GetDisabled()==true then return false end

				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("goto")
					net.WriteTable({selectedplayer})
				net.SendToServer()
				
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
				selectedplayer = line_obj.ply
				DButtonRmsel:SetDisabled(false)
				return true
			end
end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)



MCMD = {}
MCMD.Command = "bring"
MCMD.Verb = "brought"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true



function callfunc(caller,args)

	args[1]:SetPos(caller:GetPos() + Vector(0,0,80) )



	return true,"heh",false,{}
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
				

			local DButtonRmsel = vgui.Create( "DButton" , frame)
			DButtonRmsel:SetPos( 240, 40 )
			DButtonRmsel:SetText( "Bring" )
			DButtonRmsel:SetSize( 130, 60 )
			DButtonRmsel:SetDisabled(true)
			DButtonRmsel.DoClick = function(self)
				if self:GetDisabled()==true then return false end
	
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("bring")
					net.WriteTable({selectedplayer})
				net.SendToServer()
				
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
				selectedplayer = line_obj.ply
				DButtonRmsel:SetDisabled(false)
				return true
			end
end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)



MCMD = {}
MCMD.Command = "tp"
MCMD.Verb = "teleported"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true



function callfunc(caller,args)

	args[1]:SetPos(caller:GetEyeTraceNoCursor().HitPos + Vector(0,0,72))



	return true,"heh",false,{}
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
				

			local DButtonRmsel = vgui.Create( "DButton" , frame)
			DButtonRmsel:SetPos( 240, 40 )
			DButtonRmsel:SetText( "Teleport" )
			DButtonRmsel:SetSize( 130, 60 )
			DButtonRmsel:SetDisabled(true)
			DButtonRmsel.DoClick = function(self)
				if self:GetDisabled()==true then return false end
	
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("tp")
					net.WriteTable({selectedplayer})
				net.SendToServer()
				
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
				selectedplayer = line_obj.ply
				DButtonRmsel:SetDisabled(false)
				return true
			end
end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)