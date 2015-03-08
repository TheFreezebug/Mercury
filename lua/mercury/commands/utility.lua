MCMD = {}
MCMD.Command = "decals"
MCMD.Verb = "cleaned up the decals"
MCMD.RconUse = true
MCMD.Useage = "<steamid> <time> <reason> "
MCMD.UseImmunity = true
MCMD.PlayerTarget = false
MCMD.HasMenu = true



function callfunc(caller,args)
	for k,v in pairs(player.GetAll()) do
		v:SendLua([[RunConsoleCommand("r_cleardecals")]])
	end
	


	return true,"heh",false,{}
	// First argument true / false -- Command succeeded? 
	// Second argument: String error, if first argument is false this is pushed to the client.
	// Third argument true / false -- supress default messages
	// Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)
		local selectedplayer = nil 

		 


			local DButtonRmsel = vgui.Create( "DButton" , frame)
			DButtonRmsel:SetPos( 10, 0 )
			DButtonRmsel:SetText( "Clean decals" )
			DButtonRmsel:SetSize( 130, 60 )

			DButtonRmsel.DoClick = function(self)
				//if self:GetDisabled()==true then return false end
			//	local lid = ctrl:GetSelectedLine()
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("decals")
					net.WriteTable({})
				net.SendToServer()
				 
			end

end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)





MCMD = {}
MCMD.Command = "cleanup"
MCMD.Verb = "cleaned up"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true



function callfunc(caller,args)
		local target = args[1]
		local vm = target:GetViewModel( 0 ) 
   		for k,v in pairs(ents.GetAll()) do
                if v:CPPIGetOwner()==target and v~=vm then
                        if !v:IsPlayer() and !v:IsWeapon() then
                                v:Remove()
                        end
                end
        end





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
			DButtonRmsel:SetText( "CleanUp" )
			DButtonRmsel:SetSize( 130, 60 )
			DButtonRmsel:SetDisabled(true)
			DButtonRmsel.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				local lid = ctrl:GetSelectedLine()
				ctrl:RemoveLine(lid)	
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("cleanup")
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
MCMD.Command = "god"
MCMD.Verb = "enabled godmode for"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true



function callfunc(caller,args)
	args[1]:GodEnable()

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
			GagButton:SetText( "God" )
			GagButton:SetSize( 130, 60 )
			GagButton:SetDisabled(true)
			GagButton.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("god")
					net.WriteTable({selectedplayer})
				net.SendToServer()

			end




			UnGagButton:SetPos( 240, 120 )
			UnGagButton:SetText( "UnGod" )
			UnGagButton:SetSize( 130, 60 )
			UnGagButton:SetDisabled(true)
			UnGagButton.DoClick = function(self)
				if self:GetDisabled()==true then return false end
				surface.PlaySound("buttons/button3.wav")
				net.Start("Mercury:Commands")
					net.WriteString("ungod")
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
MCMD.Command = "ungod"
MCMD.Verb = "disabled godmode for"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = false



function callfunc(caller,args)
	args[1]:GodDisable()

	return true,"",false,{} //RETURN CODES.
	// First argument true / false -- Command succeeded? 
	// Second argument: String error, if first argument is false this is pushed to the client.
	// Third argument true / false -- supress default messages
	// Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)

end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)



MCMD = {}
MCMD.Command = "changelevel" 
MCMD.Verb = "changed the map"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = false
MCMD.HasMenu = false



function callfunc(caller,args)
	if !args[1] then return false,"No map specified." end
	if !file.Exists("maps/" .. args[1] .. ".bsp","GAME") then return false,"Map does not exist." end

	RunConsoleCommand("changelevel",unpack(args))


	return true,"",false,{} //RETURN CODES.
	// First argument true / false -- Command succeeded? 
	// Second argument: String error, if first argument is false this is pushed to the client.
	// Third argument true / false -- supress default messages
	// Fourth argument table, the message to print to chat if second argument is true.

end


function MCMD.GenerateMenu(frame)

end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)




------------------------------ Respawn ------------------------------
//force spawn a player
MCMD = {}
MCMD.Command = "spawn" // The actual command index.
MCMD.Verb = "respawned" // The verb (if using)
MCMD.RconUse = true // Can RCON use this command?
MCMD.Useage = "<player>" // The useage for this command, the arguments.
MCMD.UseImmunity = true // Should this abide by immunity?
MCMD.PlayerTarget = true // Does it use a player target?
MCMD.HasMenu = true // Does it have a callable GenerateMenu function?
/// NOTICE /// if PlayerTarget is true, the first argument will be the selected player target.
 
 
function callfunc(caller,args)
	args[1]:Spawn()	
	return true,"",false,{Color(1,1,1,255),caller,Color(47,150,255,255)," respawned ", args[1]} //RETURN CODES.
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
               
            local SpawnButton = vgui.Create( "DButton" , frame)
            SpawnButton:SetPos( 240, 40 )
            SpawnButton:SetText( "Respawn" )
            SpawnButton:SetSize( 130, 60 )
            SpawnButton:SetDisabled(true)
            SpawnButton.DoClick = function(self)
                if self:GetDisabled()==true then return false end
                surface.PlaySound("buttons/button3.wav")
                net.Start("Mercury:Commands")
                    net.WriteString("spawn")
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
                 SpawnButton:SetDisabled(false)
                selectedplayer = line_obj.ply
                return true
            end
end
 
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)// This is where we add the plugin.

