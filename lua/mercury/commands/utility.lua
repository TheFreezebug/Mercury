Mercury.Commands.AddPrivilege("god")

local function GodPrivilegeCheck(ply)
	return ply:HasPrivilege("god")
end

-- Decals
local MCMD = Mercury.Commands.CreateTable("decals", "cleaned up the decals", true, "", true, false, true, "Utility")
function callfunc(caller,args)
	for k,v in pairs(player.GetAll()) do
		v:SendLua([[RunConsoleCommand("r_cleardecals")]])
	end
	
	return true, "heh", false, {}
end


function MCMD.GenerateMenu(frame)
	local selectedplayer = nil 

	local DButtonRmsel = vgui.Create( "DButton" , frame)
	DButtonRmsel:SetPos( 10, 0 )
	DButtonRmsel:SetText( "Clean decals" )
	DButtonRmsel:SetSize( 130, 60 )

	DButtonRmsel.DoClick = function(self)
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("decals")
			net.WriteTable({})
		net.SendToServer()
	end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Cleanup
local MCMD = Mercury.Commands.CreateTable("cleanup", "cleaned up", true, "<player>", true, true, true, "Utility")
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
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- God
local MCMD = Mercury.Commands.CreateTable("god", "enabled godmode for", true, "<player>", true, true, true, "Utility", true, GodPrivilegeCheck)
function callfunc(caller,args)
	args[1]:GodEnable()

	return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
	local selectedplayer = nil 

	local ctrl = vgui.Create( "DListView", frame)
	ctrl:AddColumn( "Players" )
	ctrl:SetSize( 210, 380 )	
	ctrl:SetPos( 10, 0 )
				
	local God = vgui.Create( "DButton" , frame)
	God:SetPos( 240, 40 )
	God:SetText("God")
	God:SetSize( 130, 20 )
	God:SetDisabled(true)
	God.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("god")
			net.WriteTable({selectedplayer})
		net.SendToServer()
	end

	local UnGod = vgui.Create( "DButton" , frame)
	UnGod:SetPos( 240, 120 )
	UnGod:SetText("Ungod")
	UnGod:SetSize( 130, 20 )
	UnGod:SetDisabled(true)
	UnGod.DoClick = function(self)
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
		 UnGod:SetDisabled(false)
		 God:SetDisabled(false)
		selectedplayer = line_obj.ply
		return true
	end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Ungod
local MCMD = Mercury.Commands.CreateTable("ungod", "disabled godmode for", true, "<player>", true, true, false, "Utility", true, GodPrivilegeCheck)
function callfunc(caller,args)
	args[1]:GodDisable()
	return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Force respawn
local MCMD = Mercury.Commands.CreateTable("spawn", "respawned", true, "<player>", true, true, true, "Utility")
function callfunc(caller,args)
	args[1]:Spawn()	
	return true, "", false, {Color(1,1,1,255),caller,Color(47,150,255,255)," respawned ", args[1]}
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
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)