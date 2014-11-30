  local MenuTab = {}
  MenuTab.index = 1 //Internal identifier for table
  MenuTab.Name = "Commands" // Display name 
  MenuTab.Desc = "Avalible commands" // Description 
  MenuTab.Icon = "icon16/table.png" // Icon
 function GenerateMenu(CONTAINER)

 ////////////COMMANDS TAB////////////////////

 	local comwindow = CONTAINER
 	///////Create container for plugins///////////
	local gframe = vgui.Create( "ContextBase" , comwindow ) 
	gframe:SetSize( 390, 400 )
	gframe:SetPos(225,10)
	gframe:SetVisible( true )
	function gframe:GetWindow()
		return comwindow
	end
	comwindow.CurrentGFrame = gframe

	local breen_img = vgui.Create( "DImage", gframe )	
	breen_img:SetPos( 10, 120 )	-- Move it into frame
	breen_img:SetSize( 360, 100 )	-- Size it to 150x150

	-- Set material relative to "garrysmod/materials/"
	breen_img:SetImage( "mercury/mercury.png" )

	//////////////////////////////////////////////

	///////Create list of plugins and generation functions///////
	local ctrl = vgui.Create( "DListView", comwindow )
	ctrl:AddColumn( "Commands" )
	ctrl:SetSize( 210, 400 )	
	ctrl:SetPos( 10, 10 )
	ctrl:SetMultiSelect(false)
	function ctrl:GetWindow()
		return comwindow
	end
	function ctrl:OnClickLine(line,isselected)
		if self.LastSelectedRow then self.LastSelectedRow:SetSelected(false) end
		if self:GetWindow().CurrentGFrame then self:GetWindow().CurrentGFrame:Remove() end
			local gframe = vgui.Create( "ContextBase" , comwindow )
			gframe:SetSize( 390, 400 )
			gframe:SetPos(225,10)
			gframe:SetVisible( true )
			function gframe:GetWindow()
				return comwindow
			end
			function gframe:Paint(w,h)
				    draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 255, 100, 10 ) )
			end
			self:GetWindow().CurrentGFrame = gframe
			if line.PluginTable then 
				if line.PluginTable.GenerateMenu then
					line.PluginTable.GenerateMenu(gframe)
				end
			end
			line:SetSelected(true)
			self.LastSelectedRow = line
		
	end

	ctrl:SetMultiSelect(false)


	for k,v in pairs( Mercury.Commands.CommandTable ) do
		if LocalPlayer():HasPrivilege(k) then
			if v.HasMenu == true then 

				local x = k[1]
				x = string.upper(x)

				local xad = string.sub(k,2,#k)
				local item = ctrl:AddLine( x .. xad )
				item.PluginTable = v
				
			end
		end
	end	
 
end

Mercury.Menu.AddMenuTab(MenuTab.index,MenuTab.Icon,MenuTab.Name,MenuTab.Desc,GenerateMenu) 

//
//prosh:AddSheet( "Commands", comwindow, "icon16/table.png", false, false, "Avalible Commands" ) // Register window on propertysheet.