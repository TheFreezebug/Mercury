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

			local ctrl = vgui.Create( "DListView", gframe)
			ctrl:AddColumn( "Steam ID" )
			ctrl:AddColumn( "Time left" )
			ctrl:AddColumn( "Banning Administrator" )
			ctrl:SetSize( 450, 400 )	
			ctrl:SetPos( 10, 0 )
				
	




			function ctrl:OnRowSelected(lineid,isselected)
				local line_obj = self:GetLine(lineid)
				surface.PlaySound("buttons/button6.wav")
				return true
			end
			for k, ply in pairs( bandata ) do
				local item = ctrl:AddLine( ply.STEAMID,ply["TimeRemaining"],ply["bannedby"] )
				item.ban = ply
			end	







end



 function GenerateMenu(CONTAINER)
 
 	local banwindow = CONTAINER
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
	timer.Simple(5,function()
		DoLayout(CONTAINER)
		if IsValid(banwindow) then 
			function banwindow:Paint(w,h) 
			end
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