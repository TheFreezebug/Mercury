  local MenuTab = {}
  MenuTab.index = "Bans" //Internal identifier for table
  MenuTab.Name = "Bans" // Display name 
  MenuTab.Desc = "Server Bans" // Description 
  MenuTab.Icon = "icon16/heart.png" // Icon
local bandata = {}
local totalchunks = 0
local gotchunks = 0


local function DoLayout(gframe,bantable)
			if !IsValid(gframe) then return false end
			local steamid = ""
			local ctrl = vgui.Create( "DListView", gframe)
			ctrl:AddColumn( "Steam ID" )
			ctrl:AddColumn( "Time left" )
			ctrl:AddColumn( "Banning Administrator" )
			ctrl:SetSize( 450, 400 )	
			ctrl:SetPos( 10, 10 )
				
			local UnbanButton = vgui.Create( "DButton" , gframe)
			UnbanButton:SetPos( 460,  380 )
			UnbanButton:SetText( "Unban user" )
			UnbanButton:SetDisabled(true)
			UnbanButton:SetSize(170,30)



			function ctrl:OnRowSelected(lineid,isselected)
				local line_obj = self:GetLine(lineid)
				surface.PlaySound("buttons/button6.wav")
				UnbanButton:SetDisabled(false)
				steamid = line_obj.ban.STEAMID
				print(steamid)
				return true
			end
			for k, ply in pairs( bandata ) do

				local item = ctrl:AddLine( ply.STEAMID,ply["TimeRemaining"],ply["bannedby"] )
				item.ban = ply
			end	



	
			UnbanButton.DoClick = function( self )
					if self.RW and IsValid(self.RW) then self.RW:Remove() end
					surface.PlaySound("mercury/mercury_error.ogg")
					local rootwindow = vgui.Create( "DFrame" ) // actual window frame
					self.RW = rootwindow
					rootwindow:SetSize( 480, 150 )
					rootwindow:Center()
			 		rootwindow:SetTitle( "Mercury - Warning" )
					rootwindow:SetVisible( true )
					rootwindow:MakePopup()
					function rootwindow:Paint(w,h)
						    draw.RoundedBox( 0, 0, 0, w, h, Color( 104,134, 200, 220 ) )
						    surface.SetMaterial( Material("icon16/error.png") ) 
						   	surface.SetDrawColor(Color(255,255,255,255))
						    surface.DrawTexturedRect(12,40,32,32)
					end
						local DLabel = vgui.Create( "DLabel", rootwindow )
						DLabel:SetPos( 60, 50 )
						DLabel:SetText( "Really unban " .. steamid .. "?" )
						DLabel:SetColor(Color(255,255,255))
						DLabel:SizeToContents()
						local ConfirmUnban = vgui.Create( "DButton" , rootwindow)
							ConfirmUnban:SetPos( 90,  80 )
							ConfirmUnban:SetText( "Yes, unban them." )
							ConfirmUnban:SetSize(90,20)
							ConfirmUnban.DoClick = function( self )
								surface.PlaySound("mercury/mercury_info.ogg")
									net.Start("Mercury:Commands")
										net.WriteString("unban")
										net.WriteTable({steamid})
									net.SendToServer()
									local lid = ctrl:GetSelectedLine()
									ctrl:RemoveLine(lid)	
									UnbanButton:SetDisabled(true)
									rootwindow:Close()
									
							end
						local DenyUnban = vgui.Create( "DButton" , rootwindow)
							DenyUnban:SetPos( 250,  80 )
							DenyUnban:SetText( "No, don't unban them." )
							DenyUnban:SetSize(175,20)
							
							
							DenyUnban.DoClick = function( self )
									rootwindow:Remove()
							end


			end
				function UnbanButton:Paint(w,h)
					    draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 200, 200, 255 ) )
				end





end



 function GenerateMenu(CONTAINER)
 
 	local banwindow = CONTAINER
 	local obanpaint = banwindow.Paint
 	bandata = {}
 	net.Start("Mercury:BanData")
 		net.WriteString("GET_DATA")
 	net.SendToServer()

 	
 	  local bstr = [[==Mercury bans system v1.0A==
     
Just a sec, waiting on the server. ]]
 	  if LocalPlayer():HasPrivilege("editban")~=true then 
 	  bstr = [[==Mercury bans system v1.0A==


 	  No access. ]]

 	  end

 	  function banwindow:Paint(w,h)
   		  draw.RoundedBox( 0, 0, 0, w, h, Color( 1,1, 1, 255 ) )
          draw.DrawText(bstr, "Default", 0, 0, Color(255,255,255) , TEXT_ALLIGN_LEFT )

		  if math.sin(CurTime() * 20) > 0 then 
			        if bstr[#bstr]!="_" then 
			            bstr = bstr .. "_"
			        end
			        else
			        if bstr[#bstr]=="_" then
			            bstr = string.sub(bstr,0,#bstr-1)
			        end
			    end 
			    
		  end
	timer.Simple(2,function()
		DoLayout(CONTAINER)
		if IsValid(banwindow) then 
			banwindow.Paint = obanpaint
		end
	end)


end

Mercury.Menu.AddMenuTab(MenuTab.index,MenuTab.Icon,MenuTab.Name,MenuTab.Desc,GenerateMenu) 









net.Receive("Mercury:BanData",function()
	local comm,args 
	pcall(function()
		args = net.ReadTable()
	end)
	local dat = args["data"]
	totalchunks = args["tchunks"]
	gotchunks = args["chunkno"]

	for k,v in pairs(dat) do
		bandata[#bandata + 1] = v

	end

end)