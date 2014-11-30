MCMD = {}
MCMD.Command = "test"
MCMD.Verb = "tested"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true



function callfunc(caller,args)








	return true,"heh",false,{} //RETURN CODES.
	// First argument true / false -- Command succeeded? 
	// Second argument: String error, if first argument is false this is pushed to the client.
	// Third argument true / false -- supress default messages
	// Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)
		local selectedplayer = nil 

		
			local DButtonRmsel = vgui.Create( "DButton" , frame)
			DButtonRmsel:SetPos( 240, 40 )
			DButtonRmsel:SetText( "Gabe" )
			DButtonRmsel:SetSize( 130, 60 )
			DButtonRmsel:SetDisabled(true)
			DButtonRmsel.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				local ax = removetarget(selectedplayer)
				if ax==false then surface.PlaySound("buttons/button2.wav") else surface.PlaySound("buttons/button3.wav") end
			end


			local ctrl = vgui.Create( "DListView", frame)
			ctrl:AddColumn( "Players" )
			ctrl:SetSize( 210, 380 )	
			ctrl:SetPos( 10, 40 )
				
			local players = player.GetAll()
			local t = {}
			for _, ply in ipairs( players ) do
				local item = ctrl:AddLine( ply:Nick() )
				item.ply = ply
			end	
			function ctrl:OnClickLine(line,isselected)
				if self.LastSelectedRow then self.LastSelectedRow:SetSelected(false) end
				//if !selectedplayer then surface.PlaySound("buttons/button2.wav") return false end
				surface.PlaySound("buttons/button6.wav")
				line:SetSelected(true)
				DButtonRmsel:SetDisabled(false)
				self.LastSelectedRow = line
				selectedplayer = line.ply
			end








end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)