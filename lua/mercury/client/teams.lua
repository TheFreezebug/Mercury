Mercury.Ranks = {}
Mercury.Ranks.RankTable = {}
Mercury.Ranks.AdminRanks = {}
Mercury.Ranks.__TEAMACCESS = {}
Mercury.Ranks.RankTable["default"] =  { -- MARS is dependent on this rank.
	title = "Guest",
	order = 99999,
	color = {r= 0,g=0,b=255}, -- Yeah.. sorry about this. The meathod i'm using to save this litterally HATES vectors / colors
	commands = {"motd"},
	immunity = -1000,
	admin = false,
	superadmin = false,
}

net.Receive("Mercury:RankData",function()
local command = net.ReadString()
local args =  net.ReadTable()

	if command=="SEND_RANKS" then
		Mercury.Ranks.RankTable = args
		PrintTable(Mercury.Ranks.RankTable)
		for k,rtab in pairs(Mercury.Ranks.RankTable) do
			local title = rtab.title
			local order = rtab.order
			local color = rtab.color 

			team.SetUp(order - Mercury.Config["TeamOffset"]  , title, color, false ) 

		end
	end


end)

metaplayer = FindMetaTable("Player")

function metaplayer:GetUserGroup()
	local xad = self:GetNWString("UserGroup")
	if xad == "" or xad==nil then 
		return "default"
	end
	return xad
end

function metaplayer:GetRankTable()
	return Mercury.Ranks.RankTable[self:GetUserGroup()]
end
function metaplayer:IsAdmin()
	if !Mercury.Ranks.RankTable[self:GetUserGroup()] then return false end
	return Mercury.Ranks.RankTable[self:GetUserGroup()].admin or Mercury.Ranks.RankTable[self:GetUserGroup()].superadmin
end
function metaplayer:IsSuperAdmin()
		if !Mercury.Ranks.RankTable[self:GetUserGroup()] then return false end
	return Mercury.Ranks.RankTable[self:GetUserGroup()].superadmin
end
function metaplayer:GetImmunity()
		return Mercury.Ranks.RankTable[self:GetUserGroup()].immunity
end
function metaplayer:HasPrivilege(x) 
	if !x then return false,"NO PRIVLAGE?" end
	local rnk = self:GetUserGroup()
	x = string.lower(x)
		local gax = Mercury.Ranks.RankTable[rnk]
		for k,v in pairs(gax["privileges"]) do
			if x==v or v=="@allcmds@" then return true end
		end
		return false 
end
timer.Create("MARS_OverrideAdmin",1,1,function() -- This is just in case you have something weird tampering with these functions. THEY ARE MINE.
	function metaplayer:IsAdmin()
			if !Mercury.Ranks.RankTable[self:GetUserGroup()] then return false end
		return Mercury.Ranks.RankTable[self:GetUserGroup()].admin or Mercury.Ranks.RankTable[self:GetUserGroup()].superadmin
	end
	function metaplayer:IsSuperAdmin()
			if !Mercury.Ranks.RankTable[self:GetUserGroup()] then return false end
		return Mercury.Ranks.RankTable[self:GetUserGroup()].superadmin
	end
end)

hook.Add("HUDPaint","MInitialRankUpdate",function()
	net.Start("Mercury:RankData")
		net.WriteString("GET_RANKS")
		net.WriteTable({"0"})
	net.SendToServer()
	hook.Remove("HUDPaint","MInitialRankUpdate")

end)


// It makes a clicking noise.
// Yes it does.
