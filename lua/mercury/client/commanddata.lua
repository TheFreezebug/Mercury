Mercury.Commands = {}
Mercury.Commands.CommandTable = {}
local GlobalPrivileges = {"@allcmds@"}

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
	comname = string.lower(comname)
	Mercury.Commands.AddPrivilege(comname)

	Mercury.Commands.CommandTable[comname] = comtab
end

for k,v in pairs(file.Find("mercury/commands/*.lua","LUA")) do
	include("mercury/commands/" .. v) // Give loowa.
end

