MCMD = {}
MCMD.Command = "menu"
MCMD.Verb = ""
MCMD.RconUse = false
MCMD.Useage = ""
MCMD.UseImmunity = false
MCMD.PlayerTarget = false
MCMD.HasMenu = false



function callfunc(caller,args)
	caller:SendLua("Mercury.Menu.Open()")
	return true,"heh",true,{} //RETURN CODES.

end


function MCMD.GenerateMenu(GFRAME)









end

Mercury.Commands.AddCommand(MCMD.Command,MCMD,callfunc)