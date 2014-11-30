Mercury.Ranks = {}
Mercury.Ranks.RankTable = {}
META = FindMetaTable("Player")


local rankproperties = { // This tells the rank system what properties initially exist, this is used for saving the rank data.
	color = "table",
	title = "string",
	privileges = "table",
	immunity = "number",
	order = "number",
	admin = "boolean",
	superadmin = "boolean" 
}


Mercury.Ranks.RankTable["default"] = {
	color = Color(100,100,100),
	title = "Guest",
	privileges = {""},
	immunity = -1000,
	order = -9999,
	admin = false,
	superadmin = false

}
local function GetTemplateRank()
	return {
	color = Color(100,100,100),
	title = "RANKNAME.TEMPLATE",
	privileges = {""},
	immunity = -1000,
	order = -9999,
	admin = false,
	superadmin = false

	}
end 


local function mtag(...)
	MsgC(Color(100,255,100),"[Mercury-Ranks]: ")
end

mtag() 	MsgC(Color(255,255,0),"Checking existance of ranks folder... ")
if !file.Exists("mercury/ranks","DATA") then
	MsgC(Color(255,0,0)," NO.  \n")
	file.CreateDir("mercury/ranks") 
	  MsgN(" ") mtag() 	MsgC(Color(255,255,0),"Data folder created \n")
	else
		 MsgC(Color(0,255,0)," OK. \n")
end

function Mercury.Ranks.AddRankProperty(property,typ_e,default)
	if !property then return false,"NO PROPERTY SPECIFIED" end
	if !typ_e then return false,"NO TYPE SPECIFIED" end
	if !default then return false,"NO DEFAULT SPECIFIED" end
	if type(default)~="type" then return false,"??? TYPE OF DEFAULT IS NOT THE SAME AS TYPE VAR ???" end
	local property = string.lower(property) 
	for k,v in pairs(rankproperties) do
		if k==property then return false,"ERROR: PROPERTY ALREADY EXISTS" end
	end
	rankproperties[property] = typ_e // hue because type() function .

end


function Mercury.Ranks.SaveRank(index,configuration)
	if !index or type(index)~="string" then return false,"NO OR BAD INDEX." end
	if !configuration or type(configuration)~="table" then return false,"MISSING OR NON-TABLE CONFIGURATION TABLE" end

	//Encode config in json
	local cfg = util.TableToJSON(configuration)
	file.Write("mercury/ranks/" .. index .. ".txt", cfg)
	return true,"Rank configuration saved to disk."
end
 


function Mercury.Ranks.CreateRank(index,title,color) 
	if !index then return false,"NO INDEX SPECIFIED" end
	if !title then return false,"NO TITLE SPECIFIED" end
	if !color then color = Color(100,100,100) end
	index = string.lower(index)

	if Mercury.Ranks.RankTable[index] then 
		return false, "RANK ALREADY EXISTS"
	end

	local newrank = GetTemplateRank()
	newrank.color = color
	newrank.title = title
	newrank.order = math.random(1,Mercury.Config["TeamOffset"])

	if Mercury.Config["UseTeams"] == true then 
					
			team.SetUp( newrank.order - Mercury.Config["TeamOffset"]  , title, color, false ) 

	end

	Mercury.Ranks.RankTable[index] = newrank 
		Mercury.Ranks.SendRankUpdateToClients()
	Mercury.Ranks.SaveRank(index,newrank)
	return true,"Rank created successfully."
end



function Mercury.Ranks.DeleteRank(index) 
	if !index then return false,"NO INDEX SPECIFIED" end
	index = string.lower(index)
	if index=="default" then return false,"Default rank cannot be deleted." end
	if !Mercury.Ranks.RankTable[index] then 
		return false, "Rank does not exist"
	end

	for k,v in pairs(player.GetAll()) do
		if v:GetRank()==index then 
			Mercury.UDL.SetSaveRank(v,"default")
		end
	end
	Mercury.Ranks.RankTable[index] = nil
	Mercury.Ranks.SendRankUpdateToClients()
	file.Delete("mercury/ranks/" .. index .. ".txt")
	return true,"Rank deleted successfully."
end

 

function Mercury.Ranks.ChangeIndex(index,newindex)
	if !index then return false,"NO INDEX SPECIFIED" end
	if !newindex then return false,"Rank to change index to not specified." end
	index = string.lower(index)
	if index=="default" then return false,"Default rank cannot be renamed." end

	if !Mercury.Ranks.RankTable[index] then 
		return false, "Rank does not exist"
	end
	if Mercury.Ranks.RankTable[newindex] then 
		return false, "Cannot overwrite another rank."
	end
	local rankdata = table.Copy(Mercury.Ranks.RankTable[index])
	Mercury.Ranks.RankTable[newindex] = rankdata
	Mercury.Ranks.DeleteRank(index)
	if Mercury.Config["UseTeams"] == true then 
					
			team.SetUp( rankdata.order - Mercury.Config["TeamOffset"]  , rankdata.title , rankdata.color, false ) 

	end
	for k,v in pairs(player.GetAll()) do
		if v:GetRank()==index then 
			Mercury.UDL.SetSaveRank(v,newindex)
		end
	end
	Mercury.Ranks.SaveRank(newindex,rankdata)
	Mercury.Ranks.RankTable[index] = nil
	Mercury.Ranks.SendRankUpdateToClients()
	file.Delete("mercury/ranks/" .. index .. ".txt")
	return true,"Rank changed successfully."
end


function Mercury.Ranks.ModProperty(index,property,value)
	if !index then return false,"NO INDEX SPECIFIED" end
	if !property then return false,"NO PROPERTY SPECIFIED" end
	if value==nil then return false,"NO VALUE PROVIDED" end
	index = string.lower(index)
	property = string.lower(property)
	local hrprop = false
	local typ = false
	for k,v in pairs(rankproperties) do
		if k==property then hrprop = true end
	end
	if hrprop==false then return false,"Property not registered, please register the property first." end
	if rankproperties[property]==type(value) then 
		typ = true 
	end
	if typ==false then return false,"VALUE NOT THE SAME TYPE AS PROPERTY DEFENITION" end
	local gax = Mercury.Ranks.RankTable[index]
	if !gax then return false,"RANK DID NOT EXIST" end
	if gax then 
		gax[property] = value 
	end
	Mercury.Ranks.SendRankUpdateToClients()
	Mercury.Ranks.SaveRank(index,gax)
	return true 

end


function Mercury.Ranks.GetProperty(index,property)
	if !index then return false,"NO INDEX SPECIFIED" end
	if !property then return false,"NO PROPERTY SPECIFIED" end
	index = string.lower(index)
	property = string.lower(property)
	local gax = Mercury.Ranks.RankTable[index]
	if !gax then return false,"RANK DID NOT EXIST" end
	if gax then 
		return gax[property] 
	end
	return nil

end 

function Mercury.Ranks.SetRank(play,rank)
	if !play then return false,"No player specified." end
	if !rank then return false,"No rank specified." end
	rank = string.lower(rank)
	local gax = Mercury.Ranks.RankTable[rank]
	if !gax then return false,"RANK DID NOT EXIST" end

	play._RANK = rank
	Mercury.Ranks.SendRankUpdateToClients()
	return true
end

function META:GetRank()
	if !self._RANK then return "default" end
	return self._RANK
end
 
function META:HasPrivilege(x) 
	if !x then return false,"NO PRIVLAGE?" end
	local rnk = self:GetRank()

	x = string.lower(x)
		local gax = Mercury.Ranks.RankTable[rnk]
		for k,v in pairs(gax["privileges"]) do
			if x==v or v=="@allcmds@" then return true end
		end
		return false 
end

function META:GetImmunity()
		return Mercury.Ranks.RankTable[self:GetRank()].immunity
end

function META:CanUserTarget(x)
	if !x then return false end
	return self:GetImmunity() >= x:GetImmunity()
end

timer.Create("Mercury:OverrideAdmin",0.1,1,function() -- This is just in case you have something weird tampering with these functions. THEY ARE MINE.
	function metaplayer:IsAdmin()
			if !Mercury.Ranks.RankTable[self:GetRank()] then return false end
		return Mercury.Ranks.RankTable[self:GetRank()].admin or Mercury.Ranks.RankTable[self:GetUserGroup()].superadmin
	end
	function metaplayer:IsSuperAdmin()
			if !Mercury.Ranks.RankTable[self:GetRank()] then return false end
		return Mercury.Ranks.RankTable[self:GetRank()].superadmin
	end
end)

local rnks = file.Find("mercury/ranks/*.txt","DATA")

for k,v in pairs(rnks) do
	local content = file.Read("mercury/ranks/" .. v )
	local index = string.sub(v,0,#v-4) // rip .txt
	local rtab = util.JSONToTable(content)
	pcall(function()
		if Mercury.Config["UseTeams"] == true then 
			local title = rtab.title
			local order = rtab.order
			local color = rtab.color 

			team.SetUp( order - Mercury.Config["TeamOffset"]  , title, color, false ) 

		end

	end)
	Mercury.Ranks.RankTable[index] = rtab
end


function Mercury.Ranks.SendRankUpdateToClients()
	net.Start("Mercury:RankData")
		net.WriteString("SEND_RANKS")
		net.WriteTable(Mercury.Ranks.RankTable)
	net.Send(player.GetAll())
	
end


net.Receive("Mercury:RankData",function()
	local command = net.ReadString()
	local args = net.ReadTable()
	if command == "GET_RANKS" then 
		Mercury.Ranks.SendRankUpdateToClients()
	end 

end)


timer.Create("Mercury_UpdatePlayerInfo",0.5,0,function()
	for k,v in pairs(player.GetAll()) do 
		v:SetNWString("UserGroup",v:GetRank())
		pcall( function()
			if Mercury.Config["UseTeams"] == true then 
					v:SetTeam(Mercury.Ranks.RankTable[v:GetRank()].order  - Mercury.Config["TeamOffset"] )
			end
		end)

	end
end)



hook.Add("PlayerInitialSpawn","MARS_Rank_Initialspawn",function() 
	Mercury.Ranks.SendRankUpdateToClients()
end) 


Mercury.Ranks.SendRankUpdateToClients()