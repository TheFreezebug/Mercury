Mercury.Commands.AddPrivilege("viewconfig")	
Mercury.Commands.AddPrivilege("configmanagement")
local function ConfigPrivilegeCheck(caller)
	return caller:HasPrivilege("configmanagement")
end

MCMD = {}
MCMD.Command = "setuseteams"
MCMD.Verb = "set"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = false
MCMD.HasMenu = false
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

    return true,"",false,{} //RETURN CODES.
    // First argument true / false -- Command succeeded? 
    // Second argument: String error, if first argument is false this is pushed to the client.
    // Third argument true / false -- supress default messages
    // Fourth argument table, the message to print to chat if second argument is true.

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)




MCMD = {}
MCMD.Command = "setservercolor"
MCMD.Verb = "set"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true 
MCMD.PlayerTarget = false
MCMD.HasMenu = false
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

   	

   
	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Server Color" ,Mercury.Config.Colors.Default , " to ", col , "this." } 

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)


/*	Colors = {
			Default = Color(255,255,255,255),
			Error = Color(255,131,85),
			Arg = Color(102,198,255),
			Rank = Color(130,255,132),
			Server = Color(1,1,1),
			Setting = Color(255,100,255),

		},

*/




MCMD = {}
MCMD.Command = "setsettingcolor"
MCMD.Verb = "set"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true 
MCMD.PlayerTarget = false
MCMD.HasMenu = false
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

   	

   
	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Setting Color" ,Mercury.Config.Colors.Default , " to ", col , "this." } 

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)


MCMD = {}
MCMD.Command = "setargcolor"
MCMD.Verb = "set"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true 
MCMD.PlayerTarget = false
MCMD.HasMenu = false
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

   	

   
	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Argument Color" ,Mercury.Config.Colors.Default , " to ", col , "this." } 

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)


MCMD = {}
MCMD.Command = "setrankcolor"
MCMD.Verb = "set"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true 
MCMD.PlayerTarget = false
MCMD.HasMenu = false
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

   	

   
	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Rank Color" ,Mercury.Config.Colors.Default , " to ", col , "this." } 

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)




MCMD = {}
MCMD.Command = "seterrorcolor"
MCMD.Verb = "set"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true 
MCMD.PlayerTarget = false
MCMD.HasMenu = false
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

   	

   
	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Error Color" ,Mercury.Config.Colors.Default , " to ", col , "this." } 

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)


MCMD = {}
MCMD.Command = "setdefaultcolor"
MCMD.Verb = "set"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true 
MCMD.PlayerTarget = false
MCMD.HasMenu = false
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

   	

   
	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has set the ", Mercury.Config.Colors.Setting , "Default Color" ,Mercury.Config.Colors.Default , " to ", col , "this." } 

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)