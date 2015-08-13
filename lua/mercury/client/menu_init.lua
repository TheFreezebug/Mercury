local MenuTabs = {}
Mercury.Menu = {}

	function Mercury.Menu.AddMenuTab(index,icon,name,desc,func,chfnk) 
		MenuTabs[index] = { name = name,icon = icon, desc = desc, genfunc = func,checkfunc = chfnk}
	end


function Mercury.Menu.Open()
	for _,f in pairs(file.Find("mercury/menu/*.lua","LUA")) do
		local S,ER =	pcall(function() include("mercury/menu/" .. f) end) // OUCH!!!! MY MEMORY!!!
		if (S) then Msg("[Mercury-Menu]: Adding accessory: " .. f .. "\n") else
	 		 Msg("[Mercury-Menu]: Adding accessory: " .. ER .. "\n")
		end
	end   

	local rootwindow = vgui.Create( "DFrame" )
	rootwindow:SetSize( 640, 480 )
	rootwindow:Center()
 	rootwindow:SetTitle( "Mercury Menu" )
	rootwindow:SetVisible( true )
	rootwindow:MakePopup()

	local prosh = vgui.Create("DPropertySheet", rootwindow)
	prosh:Dock(FILL)
	prosh:SetPos(0,24)

	function prosh:GetWindow()
		return rootwindow
	end 

	function rootwindow:GetPropertySheet()
		return prosh
	end

	for k,v in pairs(MenuTabs) do
		local cf = MenuTabs[k]["checkfunc"]
		local shouldgen = true 
		if (cf) and cf~=nil then 
			shouldgen = cf()
		end
	
		if shouldgen == true then 
			local window = vgui.Create("DPanel",prosh)
			window:SetSize(640,456)
			local gtab = MenuTabs[k]
			local gf = MenuTabs[k]["genfunc"]
			local stat , err = xpcall(gf,function(err) Mercury.Menu.ShowError(err .. " \n " .. debug.traceback()) end,window)
			prosh:AddSheet(  gtab.name ,window, gtab.icon , false, false, gtab.desc ) // Register window on propertysheet.
		end
	end
end

function Mercury.Menu.ShowError(err)
	surface.PlaySound("mercury/mercury_error.ogg")
	local rootwindow = vgui.Create( "DFrame" ) // Actual window frame
	rootwindow:SetSize( 480, 480 )
	rootwindow:Center()
 	rootwindow:SetTitle( "Mercury - Error" )
	rootwindow:SetVisible( true )
	rootwindow:MakePopup()

	local DLabel = vgui.Create( "DLabel", rootwindow )
	DLabel:SetPos( 60, 50 )
	DLabel:SetText( "An error occured on clientside." )
	DLabel:SizeToContents()

	local tbox = vgui.Create("HTML", rootwindow) 
	tbox:SetSize( 450 , 365)
	tbox:SetPos(15,96)
	tbox:SetHTML([[<pre>  <font color="white">]] .. err .. "<font></pre>")
end


function Mercury.Menu.ShowErrorCritical(err)
	surface.PlaySound("mercury/mercury_error.ogg")
	local rootwindow = vgui.Create( "DFrame" ) // Actual window frame
	rootwindow:SetSize( 480, 480 )
	rootwindow:Center()
 	rootwindow:SetTitle( "Mercury - Critical Failure" )
	rootwindow:SetVisible( true )
	rootwindow:MakePopup()


	local DLabel = vgui.Create( "DLabel", rootwindow )
	DLabel:SetPos( 60, 50 )
	DLabel:SetText( "A critical failure has occured." )
	DLabel:SizeToContents()

	local tbox = vgui.Create("HTML", rootwindow) 
	tbox:SetSize( 450 , 365)
	tbox:SetPos(15,96)
	tbox:SetHTML([[<pre>  <font color="white">]] .. err .. "<font></pre>")
end




local progressactive = false
local progress = 0 
local maxprogress = 500
local progresstext = "???"
function Mercury.Menu.ShowProgress(message)
	progresstext = message
	progressactive = true 
end

hook.Add("PostRenderVGUI","MercuryProgress",function()
	if progressactive then
		surface.SetDrawColor(Color(1,1,1))
		surface.DrawRect( (ScrW() / 2 ) - ((ScrW() / 4) / 2), (ScrH() / 2 ) - ((ScrH() / 5) / 2), (ScrW() / 4),(ScrH() / 5))
		surface.SetDrawColor(Color(200,200,200))
		surface.DrawRect( (ScrW() / 2 ) - ((ScrW() / 4) / 2), (ScrH() / 2 ) - ((ScrH() / 5) / 2), (ScrW() / 4),(ScrH() / 5))

		local pulse = math.sin(CurTime()  * 10) * 2
		surface.SetDrawColor(Color(50,50,50))
		surface.DrawRect( (ScrW() / 1.9) - ((ScrW() / 4) / 2) - pulse, (ScrH() / 1.95) - pulse , (ScrW() / 5) + pulse* 2 ,(ScrH() / 24) + pulse * 2)


		surface.SetDrawColor(Color(50,255,50))
		surface.DrawRect( (ScrW() / 1.9) - ((ScrW() / 4) / 2) - pulse , (ScrH() / 1.95) - pulse ,  ((ScrW() / 5) + pulse * 2) * math.Clamp((progress / maxprogress),0,1)  , ((ScrH() / 24))  + pulse*2 )

		draw.SimpleText( progresstext, "ChatFont", ScrW() / 2, ScrH() / 2.3, Color(1,1,1,255) , TEXT_ALIGN_CENTER) 
	end
end)


function Mercury.Menu.CloseProgress()
	progressactive = false
	progresstext = "This shouldn't be open :/"
	progress = 0 
	maxprogress = 1
end

function Mercury.Menu.UpdateProgress(current,max,newtitle)
	progresss = current 
	maxprogress = max
	if newtitle then 
		progresstext = newtitle 
	end
end

net.Receive("Mercury:Progress",function()
	local command = net.ReadString()
	local data = net.ReadTable() 
	if command == "START_PROGRESS" then 
		Mercury.Menu.ShowProgress(data.messagetext)
	end
	if command == "UPDATE_PROGRESS" then 
		progress = data.progress 
		maxprogress = data.maxprogress
	end
	if command == "STOP_PROGRESS" then
		Mercury.Menu.CloseProgress()
	end
end)