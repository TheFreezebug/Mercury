Mercury.Config = {
	UseScoreboard = true,
	UseTeams = true,


	TeamOffset = 50000,
	UseRankTime = true,


	Colors = {
			Default = Color(255,255,255,255),
			Error = Color(255,131,85),
			Arg = Color(102,198,255),
			Rank = Color(130,255,132),
			Server = Color(1,1,1)

		},
}
 


if SERVER then 
	local tab = file.Read("mercury/config.txt","DATA")
	if tab then 
			local jdata = util.JSONToTable(tab)
			for k,v in pairs(jdata) do
					Mercury.Config[k] = v

			end

	end
end