Mercury.ConfigManager = {}
local types = {}
local defaults = {}





/*
function Mercury.ConfigManager.AddIndex(indx,typ_e,default)
	if types[indx] then 
		return false,"Value exists already, remove it first."
	end
	if typ_e~=type(default) then 
		return false,"The type of the value didn't match the default value."
	end
	types[indx] = type(default)
	defaults[indx] = default
	Mercury.Config[indx] = default 

end
*/

/*
function Mercury.ConfigManager.RemoveValue(index) 
	if types[index] then 
		types[index] = nil 
		defaults[index] = nil
		Mercury.Config[index] = nil
	end
end
*/

function Mercury.ConfigManager.WriteConfig()
	local rma = util.TableToJSON(Mercury.Config) 
	file.Write("mercury/config.txt",rma)
	Mercury.ConfigManager.RefreshAll()
	return true
end

function Mercury.ConfigManager.Receive(len,ply)

	local COMMAND = net.ReadString()
	local CARGS = net.ReadTable()
	if COMMAND=="GET_CONFIG" then 
		
		Mercury.ConfigManager.SendConfig(ply)

	end
end
net.Receive("Mercury:Config",Mercury.ConfigManager.Receive)

function Mercury.ConfigManager.SendConfig(ply)

	net.Start("Mercury:Config")
			net.WriteString("SEND_CONFIG")
			net.WriteTable(Mercury.Config)
	net.Send(ply)

end


function Mercury.ConfigManager.RefreshAll()

	Mercury.ConfigManager.SendConfig(player.GetAll())

end