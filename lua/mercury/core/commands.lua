Mercury.Commands = {}
Mercury.Commands.CommandTable = {}
local GlobalPrivileges = {
	"@allcmds@"

}
 
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

function Mercury.Commands.AddCommand(comname,comtab,callfunc)
	if !comname then return false,"NO INDEX" end
	if !comtab then return false,"Empty command" end
	print("ADDING COMMAND " .. comname)
	comname = string.lower(comname)
	Mercury.Commands.AddPrivilege(comname)
	comtab._CALLFUNC = callfunc
	Mercury.Commands.CommandTable[comname] = comtab
end

local function plookup(info)
	if !type(info)=="string" then return nil end
	for k, v in pairs(player.GetAll()) do
		if string.find(string.lower(v:Name()), string.lower(tostring(info))) ~= nil then
			return v
		end
		if v:SteamID()==info then
			return v
		end
	end
end      

Mercury.Commands.PlayerLookup = plookup




function Mercury.Commands.Call(caller,command,args,silent) // Here I cum ~<3


	if !command then return false,"No command specified." end
	command = string.lower(command)
	local isrcon = false
	if !Mercury.Commands.CommandTable[command] then return false,"Command does not exist." end
	local com = Mercury.Commands.CommandTable[command] 
	if !IsValid(caller) then isrcon = true end   
	local rslt,msg = false,"What?"
	if isrcon~=true then 
		if !caller:HasPrivilege(command) then
			return false,"You do not have access to this command."
		end
	end
	local asd = tostring(caller)
	local argstring = ""
	for k,v in pairs(args) do
		argstring = argstring .. tostring(args[k]) .. ", "
	end
	if isrcon==true then
		asd = "[SERVER]"
	end

	MsgN(tostring(asd) .. " ran " .. command .. " with args " .. argstring)
//rcon lua_run Mercury.Commands.Call(Player(11),[[test]],[[freeze]],false)

	//////// FOR TARGETED COMMANDS ////////
	if com.PlayerTarget==true then 
		local rsl,err,supress,supresstab 
		local target 
		if type(args[1])=="string" then 
			target = plookup(args[1])
		elseif type(args[1])=="Player" then 
			target = args[1]

		end
		if !target then return false,"Could not find target." end
		args[1] = target // pckg args.
		if isrcon~=true then 
			if com.UseImmunity==true then
				local ctarget = caller:CanUserTarget(target)
				if !ctarget then return ctarget,"You cannot target this person." end
			end
		args[1] = target
		rsl,err,supress,supresstab = com._CALLFUNC(caller,args);	
		if rsl==false then 
			return false,err
		end
		else
			caller = "[SERVER]"
			if com.RconUse==false then return false,"RCON Cannot use this command." end
			rsl,err,supress,supresstab = com._CALLFUNC(caller,args);	

		end 
		if rsl==true then 
			if silent~=true then 
				if supress~=true then
					Mercury.Util.Broadcast({Color(1,1,1,255),caller,Color(47,150,255,255), " has " .. com.Verb .." ",target,Color(47,150,255,255), "."})
				else
					if #supresstab > 0 then 
						Mercury.Util.Broadcast(supresstab)
					end
				end

			end

		end
		return true,"Command completed successfully."
	end
	//////////////////////////////


	do
		local rsl,err,supress,supresstab 
		local gabe = args[1]
		if isrcon~=true then 

		rsl,err,supress,supresstab = com._CALLFUNC(caller,args);	

				if rsl==false then 
					return false,err
				end
		else

				caller = "[SERVER]"
				if com.RconUse==false then return false,"RCON Cannot use this command." end
				rsl,err,supress,supresstab = com._CALLFUNC(caller,args);	

				if rsl==false then 
					return false,err
				end
		end


		if rsl==true then 
	
	
			if silent~=true then 
			
				if supress~=true then
				
					Mercury.Util.Broadcast({Color(1,1,1,255),caller,Color(47,150,255,255), " has " .. com.Verb .." ",gabe,Color(47,150,255,255), "."})
				else
			
					if #supresstab > 0 then 
					
						Mercury.Util.Broadcast(supresstab)
					end
				end

			end

			return true,"Command completed successfully."

		end

	end






	return false,"An undeterminable error occured while processing the command."

end


concommand.Add("hg",function(P,C,A)
	local command = ""
	local argtab = {}
	command = A[1]
	if !command then 
		Mercury.Util.SendMessage(P,{Color(47,150,255,255),"No command specified."})
		return false 
	end
	if #A > 1 then 
		for I=1,#A - 1 do
			argtab[I] = A[1 + I]

		end

	end
	local result,err = Mercury.Commands.Call(P,command,argtab,false) 
	if result~=true and IsValid(P) then 
		Mercury.Util.SendMessage(P,{Color(47,150,255,255),err})
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
		Mercury.Util.SendMessage(P,{Color(47,150,255,255),"No command specified."})
		return false 
	end
	if #A > 1 then 
		for I=1,#A - 1 do
			argtab[I] = A[1 + I]

		end

	end
	local result,err = Mercury.Commands.Call(P,command,argtab,true) 
	if result~=true and IsValid(P) then 
		Mercury.Util.SendMessage(P,{Color(47,150,255,255),err})

	end
	if !IsValid(P) and result~=true then 
		print(err)
	end
end)
net.Receive("Mercury:Commands",function(_,P)

	local command = ""
	local argtab = {}
	pcall(function()
		command = net.ReadString()
		argtab = net.ReadTable()
	end)
	
	if !command then 
		Mercury.Util.SendMessage(P,{Color(47,150,255,255),"No command specified."})
		return false 
	end

	local result,err = Mercury.Commands.Call(P,command,argtab,false) 
	if result~=true and IsValid(P) then 
		Mercury.Util.SendMessage(P,{Color(47,150,255,255),err})
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
							Mercury.Util.SendMessage(Plr,{Color(47,150,255,255),err})
						end
					end
					if firstsym == "/" then 
						result,err = Mercury.Commands.Call(Plr,command,argms,false) 
						if result~=true then 
							Mercury.Util.SendMessage(Plr,{Color(47,150,255,255),err})
						end
						return ""
					end
					if firstsym == "@" then
						result,err = Mercury.Commands.Call(Plr,command,argms,true) 
						if result~=true then 
							Mercury.Util.SendMessage(Plr,{Color(47,150,255,255),err})
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