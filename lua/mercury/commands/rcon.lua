MCMD = {}
MCMD.Command = "rcon"
MCMD.Verb = ""
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = false
MCMD.HasMenu = false



function callfunc(caller,args)

	local comstring = table.concat(args," ",1)
	
	Mercury.Util.SendMessage(caller,{Color(1,1,1),"[SILENT] ",caller,Color(47,150,255,255), " ran ", Color(255,255,255) , comstring ,Color(47,150,255,255), " on " , Color(1,1,1), "[SERVER]"} )
	RunConsoleCommand(unpack(args))
	return false,nil

	//return true,"",true,{caller,Color(47,150,255,255), " ran ", Color(255,255,255) , comstring ,Color(47,150,255,255), " on " , Color(47,150,255,255), args[1] } 

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)



MCMD = {}
MCMD.Command = "cexec"
MCMD.Verb = "executed"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = false



function callfunc(caller,args)

	local comstring = table.concat(args," ",2)
	args[1]:ConCommand(comstring)
		

	return true,"",true,{caller,Color(47,150,255,255), " ran ", Color(255,255,255) , comstring ,Color(47,150,255,255), " on " , Color(47,150,255,255), args[1] } 

end


Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)
