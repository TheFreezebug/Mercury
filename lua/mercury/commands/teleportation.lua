-- Goto
local MCMD = Mercury.Commands.CreateTable("goto", "has gone to", false, "<player>", false, true, true, "Teleportation")
function callfunc(caller,args)
	caller:SetPos(args[1]:GetPos() + Vector(0,0,80) )
	return true, "heh", false, {}
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
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


-- bring
local MCMD = Mercury.Commands.CreateTable("bring", "brought", true, "<player>", true, true, true, "Teleportation")
function callfunc(caller,args)
	args[1]:SetPos(caller:GetPos() + Vector(0,0,80) )
	return true, "heh", false, {}
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
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)



local MCMD = Mercury.Commands.CreateTable("tp", "teleported", false, "<player>", true, true, true, "Teleportation")
function callfunc(caller,args)
	args[1]:SetPos(caller:GetEyeTraceNoCursor().HitPos + Vector(0,0,72))
	return true, "heh", false, {}
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
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)