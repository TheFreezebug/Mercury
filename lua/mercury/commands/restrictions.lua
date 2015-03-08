Mercury.Commands.AddPrivilege("viewrestrictions")	
Mercury.Commands.AddPrivilege("nolimits")
Mercury.Commands.AddPrivilege("managerestrictions") 


function RestrictPrivilegeCheck(caller)
	return caller:HasPrivilege("managerestrictions")
end


///// SWEP RESTRICTIONS /////
MCMD = {}
MCMD.Command = "restrictswep"
MCMD.Verb = ""
MCMD.RconUse = true
MCMD.Useage = "<swep class> <restrict add / remove> <rank name>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RestrictPrivilegeCheck



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
		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has restricted the swep ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," from ", Mercury.Config.Colors.Rank, rank }

	end


	if action == "remove" then 
		local rsl,err = Mercury.Restrictions.RestrictWeapon(rank, class, action=="add" )
		if !rsl then 
			return rsl,err
		end
		
		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has allowed the swep ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," to ", Mercury.Config.Colors.Rank, rank }

	end


	return false,"Malformed syntax. Example: hg restrictswep weapon_pistol add default"

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

////////////////////////////////////////////////
////Mercury.Restrictions.RestrictSent(index, sent, blocked)


///////SENT RESTRICTION/////////////////


MCMD = {}
MCMD.Command = "restrictsent"
MCMD.Verb = ""
MCMD.RconUse = true
MCMD.Useage = "<sent class> <restrict add / remove> <rank name>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RestrictPrivilegeCheck

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
		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has restricted the entity ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," from ", Mercury.Config.Colors.Rank, rank }

	end


	if action == "remove" then 
		local rsl,err = Mercury.Restrictions.RestrictSent(rank, class, action=="add" )
		if !rsl then 
			return rsl,err
		end
		
		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has allowed the entity ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," to ", Mercury.Config.Colors.Rank, rank }

	end


	return false,"Malformed syntax. Example: hg restrictsent prop_thumper add default"

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)




////////////TOOL RESTRICTION//////////////

 


MCMD = {}
MCMD.Command = "restricttool"
MCMD.Verb = ""
MCMD.RconUse = true
MCMD.Useage = "<sent class> <restrict add / remove> <rank name>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RestrictPrivilegeCheck


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
		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has restricted the tool ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," from ", Mercury.Config.Colors.Rank, rank }

	end


	if action == "remove" then 
		local rsl,err = Mercury.Restrictions.RestrictTool(rank, class, action=="add" )
		if !rsl then 
			return rsl,err
		end
		
		return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has allowed the tool ", Mercury.Config.Colors.Arg , class ,Mercury.Config.Colors.Default," to ", Mercury.Config.Colors.Rank, rank }

	end


	return false,"Malformed syntax. Example: hg restrictsent weld add default"

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
