Mercury.Commands = {}
Mercury.Commands.CommandTable = {}
local GlobalProperties = {
	"Command",
	"Verb",
	"RconUse",
	"Useage", 
	
	"UseImmunity",
	"PlayerTarget",
	"HasMenu",
	"Category",
	"UseCustomPrivCheck",
	"PrivCheck"

}
local GlobalPrivileges = {
	"@allcmds@"
}

-- Who cares?
function Mercury.Commands.AddPrivilege(str)	
	str = string.lower(str)
	for k,v in pairs(GlobalPrivileges) do
		if string.lower(v)==str then return false,"PRIVLAGE ALREADY EXISTS" end
	end
	GlobalPrivileges[#GlobalPrivileges + 1] = str
end

function Mercury.Commands.GetPrivileges()
	return table.Copy(GlobalPrivileges)
end

-- Function used to create command table
/* NOTICE! THIS FUNCTION WILL BE DEPRECATED */
/* DO NOT USE IT                            */
function Mercury.Commands.CreateTable(command, verb, hasrcon, usage, hasimmunity, hasplayertarget, hasmenu, category, hascustomprivledge, privledgecheckfunction)
   	if command==nil then error("No command name was given to function") return end
   	if verb==nil then verb = "" end
   	if hasrcon==nil then hasrcon = false end
   	if usage==nil then usage = "" end
   	if hasimmunity==nil then hasimmunity = true end
   	if hasplayertarget==nil then hasplayertarget = false end
   	if hasmenu==nil then hasmenu = false end
   	if category==nil then category = "Uncategorized" end
   	if hascustomprivledge==nil then hascustomprivledge = false end
   
   	
    local tab = {}
    tab.Command = command
    tab.Verb = verb
    tab.RconUse = hasrcon
    tab.Useage = usage
    tab.UseImmunity = hasimmunity
    tab.PlayerTarget = hasplayertarget
    tab.HasMenu = hasmenu
    tab.Category = category
    tab.UseCustomPrivCheck = hascustomprivledge
	tab.PrivCheck = privledgecheckfunction

    return tab
end

function Mercury.Commands.AddCommand(comname,comtab,callfunc)
	if !comname then return false,"NO INDEX" end
	if !comtab then return false,"Empty command" end
	print("ADDING COMMAND " .. comname)
	comname = string.lower(comname)
	if not comtab.UseCustomPrivCheck then 
		Mercury.Commands.AddPrivilege(comname)
	end
	comtab._CALLFUNC = callfunc
	Mercury.Commands.CommandTable[comname] = comtab
end

local function plookup(info)
	if !type(info)=="string" then return nil end
	local targets ={}
	for k, v in pairs(player.GetAll()) do
		if string.find(string.lower(v:Name()), string.lower(tostring(info))) ~= nil then
			targets[#targets + 1] = v
		end
		if v:SteamID()==info then
			targets[#targets + 1] = v
		end
	end
	return targets
end      
Mercury.Commands.PlayerLookup = plookup




 // 					Mercury.Util.Broadcast({Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default, " has " .. com.Verb .." ",gabe,Mercury.Config.Colors.Default, "."})
function Mercury.Commands.Call(caller,command,args,silent) 
	if !command then return false,"No command specified." end // Check for specified command.

	command = string.lower(command)

	if !Mercury.Commands.CommandTable[command] then return false,"Command does not exist." end // Check for existance of command

	local CommandTable = Mercury.Commands.CommandTable[command] 
	local CallerIdentifier ="[SERVER]"
	local RconIsCalling = false 
	local Targets = {}

	if not IsValid(caller) then 
		  caller = "[SERVER]"
	end

	//* Checking for privileges
	if not RconIsCalling then // * Rcon is god
			if not CommandTable.UseCustomPrivCheck then 
				if not caller:HasPrivilege(command) then 
					return false,{"You do not have access to this command."}
				end 
			else //* Command has a custom privilege check.
				if not CommandTable.PrivCheck(caller) then 
					return false,{"You do not have access to this command."}
				end 
			end
	end 

	// TARGETED COMMANDS

	if CommandTable.PlayerTarget then 

		if !args[1] then 
			if CommandTable.AllowWildcard then //Check if command allows wildcard to be used 
				Targets[#Targets + 1] = caller 
			else 
				return false,{"No target was specified for the command."}
			end
		end
		
		if args[1] then 
			if args[1]=="^" or args[1]=="*" then 
				if CommandTable.AllowWildcard then 
					if args[1]=="^" then 
						Targets[#Targets + 1] = caller 	
					elseif args[1]=="*" then 
						for k,v in pairs(player.GetAll()) do
							Targets[#Targets + 1] = v
						end
					end
				else
					return false,{"The command you specified doesn't allow symbolic / wildcard targeting."}
				end
			else 
				PrintTable(args)
				local tgs = plookup(args[1])
				if #tgs == 0 then 
					return false,{"No target was found."}
				end 

				if #tgs > 0 then 
					if #tgs > 1 and not CommandTable.AllowWildcard then 
						local playernamesor = {} 
						for I=1,#tgs do 
							if I~=#tgs then 
								playernamesor[#playernamesor + 1] = tgs[I]
								playernamesor[#playernamesor + 1] = ", "
							else 
								playernamesor[#playernamesor + 1] =  " or "
								playernamesor[#playernamesor + 1] = tgs[I] 
								playernamesor[#playernamesor + 1] = "?"
							end
						end
						return false,{"Multiple targets found, did you mean ", unpack(playernamesor) }
					end
					for k,v in pairs(tgs)do 
						Targets[#Targets + 1] = v 
					end 
				
				end
				
			end
		end

		local success,error,custom,ctable
		for k,v in pairs(Targets)do 
			local ar2 = args
			ar2[1] = v
			/////////Problem Here
			success,error,custom,ctable = CommandTable._CALLFUNC(caller,ar2)
			
			if type(error) == "string" then // Legacy command support
				if error == "@SYNTAX_ERR" then
					error = {"Command syntax error. Syntax of this command is: ", command ,	" ",	CommandTable.Useage}
				else 
					error = {error}
				end
			end
			if success then 
				if custom then 
					if not silent then 
						Mercury.Util.Broadcast({Mercury.Config.Colors.Server, unpack( ctable ) })
					else 
						Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Server, "(SILENT) ", unpack( ctable ) })
					end 

				else 
					if not silent then 
						Mercury.Util.Broadcast({Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default, " has " .. CommandTable.Verb .." ",v,Mercury.Config.Colors.Default, "."})				
					else 
						Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Server,"(SILENT) ",caller,Mercury.Config.Colors.Default, " has " .. CommandTable.Verb .." ",v,Mercury.Config.Colors.Default, "."})
					end

				end
				return true,{"Command completed successfully. "} 

			else 
				return false,{error}
			end
		end
		 
		return true,{"Command completed successfully."}
	end // END OF TARGETED COMMANDS
	//////////////////////////////////////////////////////////////////////


	////////////////NON TARGETED COMMANDS//////////////////////



	local success,error,custom,ctable = CommandTable._CALLFUNC(caller,args)
			
			if type(error) == "string" then // Legacy command support
				if error == "@SYNTAX_ERR" then
					error = {"Command syntax error. Syntax of this command is: ", command ,	" ",	CommandTable.Useage}
				else 
					error = {error}
				end
			end
			if success then 
				if custom then 
					if not silent then 
						Mercury.Util.Broadcast({Mercury.Config.Colors.Server, unpack( ctable ) })
					else 
						Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Server, "(SILENT) ", unpack( ctable ) })
					end 

				else 
					if not silent then 
						Mercury.Util.Broadcast({Mercury.Config.Colors.Server,caller,Mercury.Config.Colors.Default, " has " .. CommandTable.Verb .." ",v,Mercury.Config.Colors.Default, "."})				
					else 
						Mercury.Util.SendMessage(caller, {Mercury.Config.Colors.Server,"(SILENT) ",caller,Mercury.Config.Colors.Default, " has " .. CommandTable.Verb .." ",v,Mercury.Config.Colors.Default, "."})
					end

				end
				return true,{"Command completed successfully. "} 

			else 
				return false,{error}
			end


	return false,{"Something pretty weird happened."}
end


concommand.Add("hg",function(P,C,A)
	local command = ""
	local argtab = {}
	command = A[1]
	if !command then  
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,"No command specified."})
		return false 
	end
	if #A > 1 then 

		for I=1,#A - 1 do
			argtab[I] = A[1 + I]

		end

	end
	local result,err = Mercury.Commands.Call(P,command,argtab,false) 
	if result~=true and IsValid(P) then 
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,unpack(err)})
	end
	if !IsValid(P) and result~=true then 
		print(err)
	end
end)


concommand.Add("hgs",function(P,C,A)
	local command = ""
	local argtab = {}
	command = A[1]
	if !command then 
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,"No command specified."})
		return false 
	end
	if #A > 1 then 
		for I=1,#A - 1 do
			argtab[I] = A[1 + I]
		end
	end
	local result,err = Mercury.Commands.Call(P,command,argtab,true) 
	if result~=true and IsValid(P) then 
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,unpack(err)})
	end
	if !IsValid(P) and result~=true then 
		print(err)
	end
end)
net.Receive("Mercury:Commands",function(len,P)
	if len and len > 0xFFF then // Thanks !cake
			P:SendLua('Mercury.Menu.ShowErrorCritical([[Net buffer is too large. \n]] .. [[ ' .. debug.traceback()  .. '"]] )')
		return "OH SHIT, INCOMING"
	end

	local command = ""
	local argtab = {}
	pcall(function()
		command = net.ReadString()
		argtab = net.ReadTable()
	end)
	if !command then 
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,"No command specified."})
		return false 
	end
	local result,err = Mercury.Commands.Call(P,command,argtab,false) 
	if result~=true and IsValid(P) then 
		Mercury.Util.SendMessage(P,{Mercury.Config.Colors.Error,unpack(err)})
	end
	if !IsValid(P) and result~=true then 
		print(err)
	end
end)
  

function Mercury.Commands.ChatHook(Plr,Text,TeamOnly)
	local argms = {}
	local firstsym = Text[1]
	if Text[1]=="!" or Text[1]=="/" or Text[1]=="@" then  -- This is shitty.
		Text = string.sub(Text,2,#Text)
		argms = Mercury.Util.StringArguments(Text)
		local command = string.lower(argms[1])
		table.remove(argms,1) // remove command.
		if command then 
			for k,v in pairs(Mercury.Commands.CommandTable) do
	
				if k==command then 
					if firstsym == "!" then
				
						result,err = Mercury.Commands.Call(Plr,command,argms,false) 
						if result~=true then 
							Mercury.Util.SendMessage(Plr,{Mercury.Config.Colors.Error,unpack(err)})
						end
					end
					if firstsym == "/" then 
						result,err = Mercury.Commands.Call(Plr,command,argms,false) 
						if result~=true then 
							Mercury.Util.SendMessage(Plr,{Mercury.Config.Colors.Error,unpack(err)})
						end
						return ""
					end
					if firstsym == "@" then
						result,err = Mercury.Commands.Call(Plr,command,argms,true) 
						if result~=true then 
							Mercury.Util.SendMessage(Plr,{Mercury.Config.Colors.Error,unpack(err)})
						end
						return ""
					end
				end
			end 
		end
	end
end
hook.Add("PlayerSay","Mercury:ChatCommands",Mercury.Commands.ChatHook)


for k,v in pairs(file.Find("mercury/commands/*.lua","LUA")) do
	AddCSLuaFile("mercury/commands/" .. v)  // FREEZEBUG FREEZEBUG DONT SENT MAI LUA 2 CLINT PLS!
	include("mercury/commands/" .. v)
end

if Mercury.Booted==true then // This will call the modhook library's hooks again. This is for lua refresh. If Mercury is fully loaded. Then it will not call the init script again. When the commands file is refreshed, the privilege registers are terminated. This will call them again.
		Mercury.ModHook.Call("AddPrivileges")
		Mercury.ModHook.Call("PrivilegesReady")
end
