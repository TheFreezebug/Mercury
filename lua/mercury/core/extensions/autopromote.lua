local RANKS = {
		[1] = "fisherman",
		[3] = "skillful",
		[5] = "adept",
		[8] = "accomplished",
		[14] = "experienced",
		[22] = "proficient",
		[32] = "masterful",
		[46] = "historical",
		[56] = "legendary",
		[75] = "mythical",
		[95] = "godlike",
		[120] = "celestial",
		[168] = "supernatural",
}

local NoTouch = { 
	"lightdonator", 
	"donator", 
	"superdonator", 
	"serenity", 
	"lostsouls", 
	"defiance", 
	"mapper", 
	"communitydeveloper",
	"admin",
	"supertantural",
	"furfag",
	"superadmin",
	"owner",
}

local function IsBadRank(str)

	for k,v in pairs(NoTouch) do
		if v==str then return true end
	end
	return false 
end



local function findPromoteRank(hours)
		local lastrank = "NONE"
		for k,v in SortedPairs(RANKS) do 
		
			if ((hours + 1) - k <= 0) then 
			
					return lastrank 
			end
			lastrank =v
		end
		return lastrank
end



FNDRNK = findPromoteRank





/*
,0


					Mercury.Commands.Call(nil, "setrank", {v,RANKS[hours]}, true) 

					Mercury.Util.Broadcast({Color(50,255,50,255), "[Auto-Promote]", Mercury.Config.Colors.Default ," set the rank of ", Color(255,255,255) , v ,Mercury.Config.Colors.Defualt , " to ", Mercury.Config.Colors.Rank , RANKS[hours] ,Color(47,150,255,255) , "." } )


					*/


timer.Create("RANKTIME_AUTOPROMOTE", 8 , 0, function()

	for k, v in pairs(player.GetAll()) do
		local hours = math.floor((v:GetNWInt("ranktime") / 60 ) / 60 )
		local pr = findPromoteRank(hours)
		if v:GetRank()~=pr and pr~="NONE" then 
		
				if !IsBadRank(v:GetRank()) then 

					Mercury.Commands.Call(nil, "setrank", {v,pr}, true) 

					Mercury.Util.Broadcast({Color(50,255,50,255), "[Auto-Promote]", Mercury.Config.Colors.Default ," set the rank of ", Color(255,255,255) , v ,Mercury.Config.Colors.Defualt , " to ", Mercury.Config.Colors.Rank , pr ,Color(47,150,255,255) , "." } )

				end

			
		end
	end
	
end)