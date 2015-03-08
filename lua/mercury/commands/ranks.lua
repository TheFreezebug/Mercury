Mercury.Commands.AddPrivilege("manageranks")
function RankPrivilegeCheck(caller)
	return caller:HasPrivilege("manageranks")
end


///////////////CREATE RANK///////////////

MCMD = {}
MCMD.Command = "rankadd"
MCMD.Verb = "created the rank"
MCMD.RconUse = true
MCMD.Useage = "<rank index> <rank title> <color>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RankPrivilegeCheck



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


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
/////////////////////////////////////////////





/////////////DELETE RANK/////////////////////


MCMD = {}
MCMD.Command = "rankdel"
MCMD.Verb = "deleted the rank"
MCMD.RconUse = true
MCMD.Useage = "<rank index>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RankPrivilegeCheck


function callfunc(caller,args)
	if not (args[1] and type(args[1])=="string") then return false,"No rank name specified." end
	local rsl,err = Mercury.Ranks.DeleteRank(args[1]) 
	if rsl~=true then 
		return false,err
	end
	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," has deleted the rank ", Mercury.Config.Colors.Rank , args[1]}
end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

////////////////////////////////////////////////


/////////////MOD PRIVILEGES/////////////////////

MCMD = {}
MCMD.Command = "rankmodpriv"
MCMD.Verb = "set the privileges of"
MCMD.RconUse = true
MCMD.Useage = "<rank index> <add / remove> <privilege>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RankPrivilegeCheck


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


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)

////////////////////////////////////////////////







///////////////MODIFY COLOR///////////////

MCMD = {}
MCMD.Command = "ranksetcolor"
MCMD.Verb = "set the color of"
MCMD.RconUse = true
MCMD.Useage = "<rank index> <rank title> <color>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false

MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RankPrivilegeCheck




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


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
/////////////////////////////////////////////


///////////////MODIFY TITLE///////////////

MCMD = {}
MCMD.Command = "ranksettitle"
MCMD.Verb = "modified the title of"
MCMD.RconUse = true
MCMD.Useage = "<rank index> <rank title>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RankPrivilegeCheck




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


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
/////////////////////////////////////////////


///////////////SET ADMIN///////////////

MCMD = {}
MCMD.Command = "ranksetadmin"
MCMD.Verb = "set the admin of"
MCMD.RconUse = true
MCMD.Useage = "<rank index> <admin / superadmin> <true/false>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RankPrivilegeCheck




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


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
/////////////////////////////////////////////




///////////////MODIFY SCOREBOARD ORDER///////////////
Mercury.Commands.AddPrivilege("viewranks")	

MCMD = {}
MCMD.Command = "ranksetorder"
MCMD.Verb = "set the order of"
MCMD.RconUse = true
MCMD.Useage = "<rank index> <rank title>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RankPrivilegeCheck




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


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
/////////////////////////////////////////////



///////////////SET RANK///////////////

MCMD = {}
MCMD.Command = "setrank"
MCMD.Verb = "set the rank of"
MCMD.RconUse = true
MCMD.Useage = "<player> <rank>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = true
MCMD.HasMenu = false

function callfunc(caller,args)
	if !args[2] then return false,"No rank specified." end
	local index = string.lower(args[2])

	if !Mercury.Ranks.RankTable[index] then return false,"Rank did not exist." end
	Mercury.UDL.SetSaveRank(args[1],index)


	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," set the rank of ", Mercury.Config.Colors.Rank , args[1] ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
/////////////////////////////////////////////


//Mercury.Ranks.ChangeIndex(index,newindex)


///////////////CHANGE INDEX///////////////

MCMD = {}
MCMD.Command = "ranksetindex"
MCMD.Verb = "set the index of"
MCMD.RconUse = true
MCMD.Useage = "<index> <new index>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RankPrivilegeCheck


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


	return true,"heh",true,{Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default," changed the index of ", Mercury.Config.Colors.Rank , args[1] ,Mercury.Config.Colors.Default , " to ", Mercury.Config.Colors.Rank , args[2] ,Mercury.Config.Colors.Default , "." } 

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)




MCMD = {}
MCMD.Command = "rankcopy"
MCMD.Verb = "set the index of"
MCMD.RconUse = true
MCMD.Useage = "<index> <new index>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RankPrivilegeCheck


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


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
/////////////////////////////////////////////



///////////////MODIFY IMMUNITY///////////////

MCMD = {}
MCMD.Command = "ranksetimmunity"
MCMD.Verb = "set the immunity of"
MCMD.RconUse = true
MCMD.Useage = "<rank index> <number immunity>"
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false
MCMD.UseCustomPrivCheck = true 
MCMD.PrivCheck = RankPrivilegeCheck




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


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
/////////////////////////////////////////////
