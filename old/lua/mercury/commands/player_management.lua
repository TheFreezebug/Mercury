---------------------------
--// Player Management //--
---------------------------

Mercury.Commands.AddPrivilege("viewbans")
Mercury.Commands.AddPrivilege("mute")
Mercury.Commands.AddPrivilege("gag")

hook.Add("PlayerSay","mercurymute",function(XAD, ply)
	if XAD["Muted"] ==true then 
		return ""		
	end
end, 18 )

hook.Add("PlayerCanHearPlayersVoice","mercurygag",function(XAD, ply)
	if ply.Gagged==true then 
		return false,false
	end
end)

local function MutePrivilegeCheck(ply)
	return ply:HasPrivilege("mute")
end

local function GagPrivilegeCheck(ply)
	return ply:HasPrivilege("gag")
end

-- Mute
local MCMD = Mercury.Commands.CreateTable("mute", "muted", true, "<player>", true, true, true, "Player Management", true, MutePrivilegeCheck)
function callfunc(caller,args)
	args[1].Muted = true 
	return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
	local selectedplayer = nil 

	local ctrl = vgui.Create( "DListView", frame)
	ctrl:AddColumn( "Players" )
	ctrl:SetSize( 210, 380 )	
	ctrl:SetPos( 10, 0 )
				
	local UnmuteButton = vgui.Create( "DButton" , frame)
	local MuteButton = vgui.Create( "DButton" , frame)
	MuteButton:SetPos( 240, 40 )
	MuteButton:SetText( "Mute Chat" )
	MuteButton:SetSize( 130, 60 )
	MuteButton:SetDisabled(true)
	MuteButton.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("mute")
			net.WriteTable({selectedplayer})
		net.SendToServer()
	end

	UnmuteButton:SetPos( 240, 120 )
	UnmuteButton:SetText( "Unmute Chat" )
	UnmuteButton:SetSize( 130, 60 )
	UnmuteButton:SetDisabled(true)
	UnmuteButton.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("unmute")
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
		UnmuteButton:SetDisabled(false)
		MuteButton:SetDisabled(false)
		selectedplayer = line_obj.ply
		return true
	end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Unmute
local MCMD = Mercury.Commands.CreateTable("unmute", "unmuted", true, "<player>", true, true, false, "Player Management", true, MutePrivilegeCheck)
function callfunc(caller,args)
	args[1].Muted = false
	return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Gag
local MCMD = Mercury.Commands.CreateTable("gag", "gagged", true, "<player>", true, true, true, "Player Management", true, GagPrivilegeCheck)
function callfunc(caller,args)
	args[1].Gagged = true
	return true, "", false, {}
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
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Ungag
local MCMD = Mercury.Commands.CreateTable("ungag", "ungagged", true, "<player>", true, true, false, "Player Management", true, GagPrivilegeCheck)
function callfunc(caller,args)
	args[1].Gagged = false
	return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Kick
local MCMD = Mercury.Commands.CreateTable("kick", "kicked", true, "<player>", true, true, true, "Player Management")
function callfunc(caller,args)
	if !args[2] then 
		args[2] = "Kicked by administrator."
	end

	timer.Simple(0.1,function() 
		args[1]:Kick(args[2])
	end)

	return true, "heh",true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has kicked ", args[1], Mercury.Config.Colors.Arg ," (", args[2],")"}
end

function MCMD.GenerateMenu(frame)
	local selectedplayer = nil 

	local ctrl = vgui.Create( "DListView", frame)
	ctrl:AddColumn( "Players" )
	ctrl:SetSize( 210, 380 )	
	ctrl:SetPos( 10, 0 )
				
	local TextEntry = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
	TextEntry:SetPos( 240, 10 )
	TextEntry:SetSize( 130, 20 )
	TextEntry:SetText( "Kicked by administrator." )

	local DButtonRmsel = vgui.Create( "DButton" , frame)
	DButtonRmsel:SetPos( 240, 40 )
	DButtonRmsel:SetText( "Kick" )
	DButtonRmsel:SetSize( 130, 60 )
	DButtonRmsel:SetDisabled(true)
	DButtonRmsel.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		local lid = ctrl:GetSelectedLine()
		ctrl:RemoveLine(lid)	
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("kick")
			net.WriteTable({selectedplayer,TextEntry:GetText()})
		net.SendToServer()
		self:SetDisabled(true)
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
		DButtonRmsel:SetDisabled(false)
		selectedplayer = line_obj.ply
		return true
	end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Ban
local MCMD = Mercury.Commands.CreateTable("ban", "banned", true, "<player> <time> <message>", true, true, true, "Player Management")
function callfunc(caller,args)
	if !args[2] or !tonumber(args[2]) then
		return false, "No time specified"
	end
	if !args[3] then 
		args[3] = "Banned by administrator"
	end

	sts,err = Mercury.Bans.Add(caller,args[1],tonumber(args[2]),args[3])

	timer.Simple(0.1,function()
		args[1]:Kick(args[3])
	end)

	local bancolor = Color(0,0,255)
	local timestring = args[2] .. " minutes"
	if tonumber(args[2])==0 then
		bancolor = Color(255,0,0)
		timestring = "eternity"
	end

	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has banned ", args[1], " for ", bancolor,timestring," ", Mercury.Config.Colors.Arg ," (", args[3],")"}
end

function MCMD.GenerateMenu(frame)
	local selectedplayer = nil 

	local ctrl = vgui.Create( "DListView", frame)
	ctrl:AddColumn( "Players" )
	ctrl:SetSize( 210, 380 )	
	ctrl:SetPos( 10, 0 )
	local ImmuLab = vgui.Create( "DLabel", frame )
	ImmuLab:SetPos( 240 , 10 )
	ImmuLab:SetText( "Reason" )
	ImmuLab:SetTextColor(Mercury.Config.Colors.Server)
	
	local TextEntry = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
	TextEntry:SetPos( 240, 30 )
	TextEntry:SetSize( 130, 20 )
	TextEntry:SetText( "Banned by administrator" )


	local TimeLab = vgui.Create( "DLabel", frame )
	TimeLab:SetPos( 240 , 45 )
	TimeLab:SetText( "Time (0 = perma)" )
	TimeLab:SetTextColor(Mercury.Config.Colors.Server)
	TimeLab:SizeToContentsX()
	
	local BanLength = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
	BanLength:SetPos( 240, 60 )
	BanLength:SetSize( 130, 20 )
	BanLength:SetText( "1440" )

	local DButtonRmsel = vgui.Create( "DButton" , frame)
	DButtonRmsel:SetPos( 240, 100 )
	DButtonRmsel:SetText( "Ban this user" )
	DButtonRmsel:SetSize( 130, 60 )
	DButtonRmsel:SetDisabled(true)
	DButtonRmsel.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		local lid = ctrl:GetSelectedLine()
		ctrl:RemoveLine(lid)	
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("ban")
			net.WriteTable({selectedplayer,BanLength:GetText(),TextEntry:GetText(),})
		net.SendToServer()
		self:SetDisabled(true)
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
		DButtonRmsel:SetDisabled(false)
		selectedplayer = line_obj.ply
		return true
	end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Banid
local MCMD = Mercury.Commands.CreateTable("banid", "banned id", true, "<steamid> <time> <reason>", true, false, true, "Player Management")
function callfunc(caller,args)
	if !args[1] then 
		return false,"No steamid specified" end
	if !args[2] or !tonumber(args[2]) then
		return false,"No time specified"
	end
	if !args[3] then 
		args[3] = "Banned by administrator"
	end

	if !string.find(string.upper(args[1]),"STEAM_") then
		return false,"That is not a valid steamid."
	end

	local sts,err = Mercury.Bans.Add(caller,args[1],tonumber(args[2]),args[3])

	local bancolor = Color(0,0,255)
	local timestring = args[2] .. " minutes"
	if tonumber(args[2])==0 then
		bancolor = Color(255,0,0)
		timestring = "eternity"
	end

	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has banned ", args[1], " for ", bancolor,timestring," ", Mercury.Config.Colors.Arg ," (", args[3],")"}
end

function MCMD.GenerateMenu(frame)
	local selectedplayer = nil 
		 
	local ImmuLab = vgui.Create( "DLabel", frame )
	ImmuLab:SetPos( 10 , 0 )
	ImmuLab:SetText( "Reason" )
	ImmuLab:SetTextColor(Mercury.Config.Colors.Server)
	
	local TextEntry = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
	TextEntry:SetPos( 10, 20 )
	TextEntry:SetSize( 130, 20 )
	TextEntry:SetText( "Banned by administrator" )

	local TimeLab = vgui.Create( "DLabel", frame )
	TimeLab:SetPos( 10 , 40 )
	TimeLab:SetText( "Time (0 = perma)" )
	TimeLab:SetTextColor(Mercury.Config.Colors.Server)
	TimeLab:SizeToContentsX()

	local BanLength = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
	BanLength:SetPos( 10, 60 )
	BanLength:SetSize( 130, 20 )
	BanLength:SetText( "1440" )

	local TimeLab = vgui.Create( "DLabel", frame )
	TimeLab:SetPos( 10 , 80 )
	TimeLab:SetText( "Steam ID" )
	TimeLab:SetTextColor(Mercury.Config.Colors.Server)
	TimeLab:SizeToContentsX()

	local SteamID = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
	SteamID:SetPos( 10, 100 )
	SteamID:SetSize( 130, 20 )
	SteamID:SetText( "" )

	local DButtonRmsel = vgui.Create( "DButton" , frame)
	DButtonRmsel:SetPos( 10, 180 )
	DButtonRmsel:SetText( "Ban this ID" )
	DButtonRmsel:SetSize( 130, 60 )
	DButtonRmsel.DoClick = function(self)
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("banid")
			net.WriteTable({SteamID:GetText(),BanLength:GetText(),TextEntry:GetText(),})
		net.SendToServer()
	end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Unban
local MCMD = Mercury.Commands.CreateTable("unban", "unbanned", true, "<steamid>", true, false, true, "Player Management")
function callfunc(caller,args)
	if !args[1] then 
		return false,"No steamid specified" end
	if !args[2] then
		args[2] = "Unbanned by administrator."
	end

	if !string.find(string.upper(args[1]),"STEAM_") then
		return false,"That is not a valid steamid."
	end

	sts,err = Mercury.Bans.UnbanID(args[1],args[2])
	if sts~=true then
		return false,err
	end

	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has unbanned ", args[1], Mercury.Config.Colors.Arg ," (", args[2],")"}
end

function MCMD.GenerateMenu(frame)
	local selectedplayer = nil 
 
	local ImmuLab = vgui.Create( "DLabel", frame )
	ImmuLab:SetPos( 10 , 0 )
	ImmuLab:SetText( "Reason" )
	ImmuLab:SetTextColor(Mercury.Config.Colors.Server)
	
	local TextEntry = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
	TextEntry:SetPos( 10, 20 )
	TextEntry:SetSize( 130, 20 )
	TextEntry:SetText( "UnBanned by administrator" )

	local TimeLab = vgui.Create( "DLabel", frame )
	TimeLab:SetPos( 10 , 40 )
	TimeLab:SetText( "Steam ID" )
	TimeLab:SetTextColor(Mercury.Config.Colors.Server)
	TimeLab:SizeToContentsX()

	local SteamID = vgui.Create( "DTextEntry", frame )	-- create the form as a child of frame
	SteamID:SetPos( 10, 60 )
	SteamID:SetSize( 130, 20 )
	SteamID:SetText( "" )

	local DButtonRmsel = vgui.Create( "DButton" , frame)
	DButtonRmsel:SetPos( 10, 180 )
	DButtonRmsel:SetText( "UnBan this ID" )
	DButtonRmsel:SetSize( 130, 60 )
	DButtonRmsel.DoClick = function(self)
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("unban")
			net.WriteTable({SteamID:GetText(),TextEntry:GetText()})
		net.SendToServer()
	end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

--[[local pNameDetour = debug.getregistry().Player
pNameDetour.RealName = pNameDetour.Nick
pNameDetour.Nick = function(self) if IsValid(self) then return self:GetNWString("Mercury:ChangeName", self:Nick()) else return "" end end
pNameDetour.Name = pNameDetour.Nick
pNameDetour.GetName = pNameDetour.Nick

-- Changename
local MCMD = Mercury.Commands.CreateTable("changename", "", true, "<player> <name>", true, true, true, "Player Management")
function callfunc(caller,args)
	if not args[1] then
        return false, "No player was supplied to the command"
    end

    if not args[2] then
    	return false, "No name was provided for the player"
    end

    local oName = args[1]:Nick()
    local nName = args[2]
    args[1]:SetNWString("Mercury:ChangeName", nName)

	return true, "", true, {caller, Mercury.Config.Colors.Default," changed the name of ", Mercury.Config.Colors.Arg, oName, Mercury.Config.Colors.Default, " to ", Mercury.Config.Colors.Arg, nName}
end

function MCMD.GenerateMenu(frame)
	local selectedplayer = nil 

	local ctrl = vgui.Create("DListView", frame)
	ctrl:AddColumn("Players")
	ctrl:SetSize(210, 380)	
	ctrl:SetPos(10, 0)
				
	local TextEntry = vgui.Create("DTextEntry", frame)	-- create the form as a child of frame
	TextEntry:SetPos(240, 10)
	TextEntry:SetSize(130, 20)
	TextEntry:SetText("")

	local DButtonRmsel = vgui.Create( "DButton" , frame)
	DButtonRmsel:SetPos( 240, 40 )
	DButtonRmsel:SetText( "Change name" )
	DButtonRmsel:SetSize( 130, 60 )
	DButtonRmsel:SetDisabled(true)
	DButtonRmsel.DoClick = function(self)
		if self:GetDisabled()==true then return false end
		local lid = ctrl:GetSelectedLine()
		ctrl:RemoveLine(lid)	
		surface.PlaySound("buttons/button3.wav")
		net.Start("Mercury:Commands")
			net.WriteString("changename")
			net.WriteTable({selectedplayer, TextEntry:GetText()})
		net.SendToServer()
		self:SetDisabled(true)
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
		DButtonRmsel:SetDisabled(false)
		selectedplayer = line_obj.ply
		return true
	end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)]]

-------------------------
--// Rank  Functions //--
-------------------------
Mercury.Commands.AddPrivilege("manageranks")
Mercury.Commands.AddPrivilege("viewranks")	

local function RankPrivilegeCheck(ply)
	return ply:HasPrivilege("manageranks")
end

-- Create rank
local MCMD = Mercury.Commands.CreateTable("rankadd", "created the rank", true, "<rank index> <rank title> <color>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"No title specified." end
	if !args[3] then return false,"No color specified." end
	local col 
	if type(args[3])=="string" then
		local rtab = string.Explode(",",args[3])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
		col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[3])=="table" then 
			col = args[3]
	end
	if !col then return false,"Could not get color value." end 

	local rsl,err = Mercury.Ranks.CreateRank(string.lower(args[1]),string.lower(args[2]),col) 	
	if rsl~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has created the rank ", Mercury.Config.Colors.Rank , args[1] ,Mercury.Config.Colors.Default , " with the title of ",Mercury.Config.Colors.Rank ,args[2] ,Mercury.Config.Colors.Default , " and ", col , "this color" } //RETURN CODES.
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Delete rank
local MCMD = Mercury.Commands.CreateTable("rankdel", "deleted the rank", true, "<rank index>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	local rsl,err = Mercury.Ranks.DeleteRank(args[1]) 
	if rsl~=true then 
		return false,err
	end
	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has deleted the rank ", Mercury.Config.Colors.Rank , args[1]}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Modify privledges
local MCMD = Mercury.Commands.CreateTable("rankmodpriv", "set the privileges of", true, "<rank index> <add / remove> <privilege>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"Add / Remove not specified." end
	if not (args[3] and type(args[3])=="string") then return false,"Command not specified to add / remove." end
	local index = string.lower(args[1])
	local action = string.lower(args[2])
	local apriv = string.lower(args[3])

	local gprivleges = Mercury.Commands.GetPrivileges()
	if action == "add" then 

		local privexists = false 
		for k,v in pairs(gprivleges) do
			if v==apriv then privexists = true  end
		end
		if privexists==false then return false,"Privilege does not exist." end

		local data,err = Mercury.Ranks.GetProperty(index,"privileges")
		if data==false then 
			return false,err
		end
		for k,v in pairs(data) do
			if v==apriv then return false,"Rank already has that privilege." end
		end
		data[#data + 1] = apriv 
		Mercury.Ranks.ModProperty(index,"privileges",data)
		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has added the privilege ", Mercury.Config.Colors.Rank , apriv,Mercury.Config.Colors.Default," to ", Mercury.Config.Colors.Rank ,index }
	end

	if action == "remove" then 
		local privexists = false 
		for k,v in pairs(gprivleges) do
			if v==apriv then privexists = true  end
		end
		if privexists==false then return false,"Privilege does not exist." end

		local data,err = Mercury.Ranks.GetProperty(index,"privileges")
		if data==false then 
			return false,err
		end
		local canremove = false
		for k,v in pairs(data) do
			if v==apriv then canremove = true end
		end
		if !canremove then 
			return false,"Rank does not have the privilege to remove"
		end

		for k,v in pairs(data) do
			if v==apriv then 
				data[k] = nil
			end
		end
		Mercury.Ranks.ModProperty(index,"privileges",data)
		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has removed the privilege ", Mercury.Config.Colors.Rank , apriv,Mercury.Config.Colors.Default," from ", Mercury.Config.Colors.Rank ,index }
	end

	return false,"Malformed syntax. Example: hg rankmodpriv owner add @allcmds@"
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Set rank's color
local MCMD = Mercury.Commands.CreateTable("ranksetcolor", "set the color of", true, "<rank index> <rank title> <color>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if !args[2] then return false,"No color specified." end
	local index = string.lower(args[1])
	local col 
	if type(args[2])=="string" then
		local rtab = string.Explode(",",args[2])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
		col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[3])=="table" then 
			col = args[2]
	end
	if !col then return false,"Could not get color value." end 

	local rsl,err = Mercury.Ranks.ModProperty(index,"color",col)
	if rsl~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed ", Mercury.Config.Colors.Rank , args[1] .. "'s" ,Mercury.Config.Colors.Default , " color to ", col , "this." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Modify rank's title
local MCMD = Mercury.Commands.CreateTable("ranksettitle", "modified the title of", true, "<rank index> <rank title>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if !args[2] then return false,"No title specified." end
	local index = string.lower(args[1])
	local rsl,err = Mercury.Ranks.ModProperty(index,[[title]],args[2])
	if rsl~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed ", Mercury.Config.Colors.Rank , args[1] .. "'s title" ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Set admin
local MCMD = Mercury.Commands.CreateTable("ranksetadmin", "set the admin of", true, "<rank index> <admin / superadmin> <true/false>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"Admin / superadmin not specified" end
	if not (args[3] and type(args[3])=="string") then return false,"true / false not specified" end
	local index = string.lower(args[1])
	local group = string.lower(args[2])
	local truefalse = string.lower(args[3])

	if truefalse~="true" and truefalse~="false"  then 
		return false,"Malformed syntax. Example: hg ranksetadmin owner admin true"
	end
	local bool = truefalse=="true"


	if group == "superadmin" then 
		local rsl,err = Mercury.Ranks.ModProperty(index,[[superadmin]],bool)
		if rsl~=true then 
			return false,err
		end
		local rsl,err = Mercury.Ranks.ModProperty(index,[[admin]],bool)
		if rsl~=true then 
			return false,err
		end

		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set ", Mercury.Config.Colors.Rank , index .. "'s" ,Mercury.Config.Colors.Default," superadmin status to ", Mercury.Config.Colors.Rank ,truefalse }
	end


	if group == "admin" then 
		local rsl,err = Mercury.Ranks.ModProperty(index,[[admin]],bool)
		if rsl~=true then 
			return false,err
		end

		if bool==false then 
			local rsl,err = Mercury.Ranks.ModProperty(index,[[superadmin]],bool)
			if rsl~=true then 
				return false,err
			end
			local rsl,err = Mercury.Ranks.ModProperty(index,[[admin]],bool)
			if rsl~=true then 
				return false,err
			end
		end

		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set ", Mercury.Config.Colors.Rank , index .. "'s" ,Mercury.Config.Colors.Default," admin status to ", Mercury.Config.Colors.Rank ,truefalse }
	end
	
	return false,"Malformed syntax. Example: hg ranksetadmin owner admin true"
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Scoreboard order ;)
local MCMD = Mercury.Commands.CreateTable("ranksetorder", "set the order of", true, "<rank index> <rank title>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if !args[2] then return false,"No order specified." end
	local index = string.lower(args[1])
	local rsl,err = Mercury.Ranks.ModProperty(index,[[order]],tonumber(args[2]))
	if rsl~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed ", Mercury.Config.Colors.Rank , args[1] .. "'s order" ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Set rank
local MCMD = Mercury.Commands.CreateTable("setrank", "set the rank of", true, "<player> <rank>", false, true, false, "Player Management")
function callfunc(caller,args)
	if !args[2] then return false,"No rank specified." end
	local index = string.lower(args[2])

	if !Mercury.Ranks.RankTable[index] then return false,"Rank did not exist." end
	Mercury.UDL.SetSaveRank(args[1],index)


	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," set the rank of ", Mercury.Config.Colors.Rank , args[1] ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Change index
local MCMD = Mercury.Commands.CreateTable("ranksetindex", "set the index of", true, "<rank index> <new index>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if !args[1] then return false,"No rank specified." end
	if !args[2] then return false,"New index not specified." end
	local index = string.lower(args[1])
	local newindex = string.lower(args[2])
	if !Mercury.Ranks.RankTable[index] then return false,"Rank did not exist." end
	local sts,err = Mercury.Ranks.ChangeIndex(index,newindex)
	if sts~=true then
		return false,err
	end


	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed the index of ", Mercury.Config.Colors.Rank , args[1] ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)


-- Copy rank
local MCMD = Mercury.Commands.CreateTable("rankcopy", "", true, "", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if !args[1] then return false,"No rank specified." end
	if !args[2] then return false,"New index not specified." end
	local index = string.lower(args[1])
	local newindex = string.lower(args[2])
	if !Mercury.Ranks.RankTable[index] then return false,"Rank did not exist." end
	local sts,err = Mercury.Ranks.CopyRank(index,newindex)
	if sts~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," copied the rank ", Mercury.Config.Colors.Rank , args[1] ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Modify immunities
local MCMD = Mercury.Commands.CreateTable("ranksetimmunity", "set the immunity of", true, "<rank index> <number immunity>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if !args[2] then return false,"No immunity specified." end
	local index = string.lower(args[1])
	local rsl,err = Mercury.Ranks.ModProperty(index,[[immunity]],tonumber(args[2]))
	if rsl~=true then
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed ", Mercury.Config.Colors.Rank , args[1] .. "'s immunity" ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Set target as self
local MCMD = Mercury.Commands.CreateTable("ranksettargetself", "", true, "<rank index> <true/false>", false, false, false, "Player Management", true, RankPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"True / false not specified" end

	local index = string.lower(args[1])
	local truefalse = string.lower(args[2])

	if truefalse~="true" and truefalse~="false"  then 
		return false,"Malformed syntax. Example: hg ranksettargetself group true/false"
	end

	local bool = truefalse=="true"
	local rsl,err = Mercury.Ranks.ModProperty(index,[[only_target_self]],bool)

	if rsl~=true then 
		return false,err
	end

	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set ", Mercury.Config.Colors.Rank , index .. "s" ,Mercury.Config.Colors.Default," to only be able to target ", Mercury.Config.Colors.Rank ,index }
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)