
hook.Add("PlayerCanHearPlayersVoice","mercurygag",function(XAD,P)
	if P.Gagged==true then 

		return false,false
	end
	return true,false
end)


MCMD = {}
MCMD.Command = "gag"
MCMD.Verb = "gagged"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true



function callfunc(caller,args)
	args[1].Gagged = true

	return true,"",false,{} //RETURN CODES.
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
				
			local UnGagButton = vgui.Create( "DButton" , frame)
			local GagButton = vgui.Create( "DButton" , frame)
			GagButton:SetPos( 240, 40 )
			GagButton:SetText( "Gag Voice" )
			GagButton:SetSize( 130, 60 )
			GagButton:SetDisabled(true)
			GagButton.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("gag")
					net.WriteTable({selectedplayer})
				net.SendToServer()

			end




			UnGagButton:SetPos( 240, 120 )
			UnGagButton:SetText( "UnGag Voice" )
			UnGagButton:SetSize( 130, 60 )
			UnGagButton:SetDisabled(true)
			UnGagButton.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("ungag")
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
				 UnGagButton:SetDisabled(false)
				 GagButton:SetDisabled(false)
				selectedplayer = line_obj.ply
				return true
			end
end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)




MCMD = {}
MCMD.Command = "ungag"
MCMD.Verb = "ungagged"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = false



function callfunc(caller,args)
	args[1].Gagged = false

	return true,"",false,{} //RETURN CODES.
	// First argument true / false -- Command succeeded? 
	// Second argument: String error, if first argument is false this is pushed to the client.
	// Third argument true / false -- supress default messages
	// Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)

end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
