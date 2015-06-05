-------------------------------
--//    Color Functions    //--
-------------------------------
Mercury.Commands.AddPrivilege("viewconfig")	
Mercury.Commands.AddPrivilege("configmanagement")

local function ConfigPrivilegeCheck(ply)
	return ply:HasPrivilege("configmanagement")
end

-- Set use teams
local MCMD = Mercury.Commands.CreateTable("setuseteams", "set", true, "<player>", true, false, false, "Config")
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = ConfigPrivilegeCheck
function callfunc(caller,args) 
   	if !args[1] then return false, "true / false not specified." end
   	args[1] = string.lower(args[1])

   	if args[1]=="true" then 
   		Mercury.Config.UseTeams = true
   		Mercury.ConfigManager.WriteConfig()
   		return true,"",true,{caller,Mercury.Config.Colors.Default," has set teams", Mercury.Config.Colors.Setting, " to " , Mercury.Config.Colors.Default,"be used."}

   	else 
   		Mercury.Config.UseTeams = false
   		Mercury.ConfigManager.WriteConfig()
   		return true,"",true,{caller,Mercury.Config.Colors.Default," has set teams", Mercury.Config.Colors.Setting, " to not " , Mercury.Config.Colors.Default,"be used."}


   	end
    target:Lock(true)

    return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set server color
local MCMD = Mercury.Commands.CreateTable("setservercolor", "set", true, "<player>", true, false, false, "Config")
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = ConfigPrivilegeCheck
 function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Server = col
    Mercury.ConfigManager.WriteConfig()

	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Server Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set settings color
local MCMD = Mercury.Commands.CreateTable("setsettingcolor", "set", true, "<player>", true, false, false, "Config")
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = ConfigPrivilegeCheck
function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Setting = col
    Mercury.ConfigManager.WriteConfig()
	
	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Setting Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set args color
local MCMD = Mercury.Commands.CreateTable("setargcolor", "set", true, "<player>", true, false, false, "Config")
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = ConfigPrivilegeCheck
function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Arg = col
    Mercury.ConfigManager.WriteConfig()

	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Argument Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set rank color
local MCMD = Mercury.Commands.CreateTable("setrankcolor", "set", true, "<player>", true, false, false, "Config")
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = ConfigPrivilegeCheck
function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Rank = col
    Mercury.ConfigManager.WriteConfig()
   
	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Rank Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set error color
local MCMD = Mercury.Commands.CreateTable("seterrorcolor", "set", true, "<player>", true, false, false, "Config")
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = ConfigPrivilegeCheck
function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Error = col
    Mercury.ConfigManager.WriteConfig()

	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Error Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-- Set default color
local MCMD = Mercury.Commands.CreateTable("setdefaultcolor", "set", true, "<player>", true, false, false, "Config")
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = ConfigPrivilegeCheck
function callfunc(caller,args) 
	if !args[1] then return false,"Specify a color." end
	local col 
	if type(args[1])=="string" then
		local rtab = string.Explode(",",args[1])
		if #rtab < 3 then return false,"Bad color passed, seperate with commas. Example: 255,0,0" end
			col = Color(rtab[1],rtab[2],rtab[3])
		elseif type(args[1])=="table" then 
			col = args[1]
	end

	Mercury.Config.Colors.Default = col
    Mercury.ConfigManager.WriteConfig()
  
	return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Default Color" ,Mercury.Config.Colors.Default , " to ", col , "this."} 
end
Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

-------------------------------
--// Restriction Functions //--
-------------------------------
Mercury.Commands.AddPrivilege("viewrestrictions")	
Mercury.Commands.AddPrivilege("nolimits")
Mercury.Commands.AddPrivilege("managerestrictions") 

function RestrictPrivilegeCheck(caller)
	return caller:HasPrivilege("managerestrictions")
end

-- restrict Swep
local MCMD = Mercury.Commands.CreateTable("restrictswep", "", true, "<swep class> <restrict add / remove> <rank name>", false, false, false, "Config", true, RestrictPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[3])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"Add / Remove not specified." end
	if not (args[3] and type(args[1])=="string") then return false,"Swep not specified to configure restriction for." end
	local class = string.lower(args[1])
	local action = string.lower(args[2])
	local rank = string.lower(args[3])

	if action == "add" then 
		local rsl,err = Mercury.Restrictions.RestrictWeapon(rank, class, action=="add" )
		if !rsl then 
			return rsl,err
		end
		return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has restricted the swep ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," from ", Mercury.Config.Colors.Rank, rank}
	end


	if action == "remove" then 
		local rsl,err = Mercury.Restrictions.RestrictWeapon(rank, class, action=="add" )
		if !rsl then 
			return rsl,err
		end
		
		return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has allowed the swep ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," to ", Mercury.Config.Colors.Rank, rank}
	end


	return false, "Malformed syntax. Example: hg restrictswep weapon_pistol add default"
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Restrict Sent
local MCMD = Mercury.Commands.CreateTable("restrictsent", "", true, "<sent class> <restrict add / remove> <rank name>", false, false, false, "Config", true, RestrictPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[3])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"Add / Remove not specified." end
	if not (args[3] and type(args[1])=="string") then return false,"Sent not specified to configure restriction for." end
	local class = string.lower(args[1])
	local action = string.lower(args[2])
	local rank = string.lower(args[3])

	if action == "add" then 
		local rsl,err = Mercury.Restrictions.RestrictSent(rank, class, action=="add" )
		if !rsl then 
			return rsl,err
		end
		return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has restricted the entity ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," from ", Mercury.Config.Colors.Rank, rank}
	end


	if action == "remove" then 
		local rsl,err = Mercury.Restrictions.RestrictSent(rank, class, action=="add" )
		if !rsl then 
			return rsl,err
		end
		
		return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has allowed the entity ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," to ", Mercury.Config.Colors.Rank, rank}
	end

	return false,"Malformed syntax. Example: hg restrictsent prop_thumper add default"
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Restrict tool
local MCMD = Mercury.Commands.CreateTable("restricttool", "", true, "<sent class> <restrict add / remove> <rank name>", false, false, false, "Config", true, RestrictPrivilegeCheck)
function callfunc(caller,args)
	if not (args[1] and type(args[3])=="string") then return false,"No rank name specified." end
	if not (args[2] and type(args[2])=="string") then return false,"Add / Remove not specified." end
	if not (args[3] and type(args[1])=="string") then return false,"Tool not specified to configure restriction for." end
	local class = string.lower(args[1])
	local action = string.lower(args[2])
	local rank = string.lower(args[3])


	if action == "add" then 
		local rsl,err = Mercury.Restrictions.RestrictTool(rank, class, action=="add" )
		if !rsl then 
			return rsl,err
		end
		return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has restricted the tool ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," from ", Mercury.Config.Colors.Rank, rank}
	end


	if action == "remove" then 
		local rsl,err = Mercury.Restrictions.RestrictTool(rank, class, action=="add" )
		if !rsl then 
			return rsl,err
		end
		
		return true, "heh", true, {Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has allowed the tool ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," to ", Mercury.Config.Colors.Rank, rank}
	end

	return false,"Malformed syntax. Example: hg restrictsent weld add default"
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)