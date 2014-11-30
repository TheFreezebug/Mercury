Mercury.Bans = {}
local function mtag(...)
	MsgC(Color(100,255,100),"[Mercury-Bans]: ")
end
 
mtag() 	MsgC(Color(255,255,0),"Checking existance of bans folder... ")
if !file.Exists("mercury/bans","DATA") then
	MsgC(Color(255,0,0)," NO  \n")
	file.CreateDir("mercury/bans") 
	  MsgN(" ") mtag() 	MsgC(Color(255,255,0),"Data folder created \n")
	else
		 MsgC(Color(0,255,0)," OK. \n")
end


local function SAFESID(steam) return string.gsub(steam,":","_") end
local function USAFESID(steam) 

	local gx = string.gsub(steam,"_",":")
	local ax = string.sub(steam,7,#steam)
	print("AX IS " .. ax) 
	gx = string.gsub(ax,"_",":")
	return "STEAM_" ..gx
end

function Mercury.Bans.GetTime()
	return      (   tonumber(os.date("%H")   )*60      + tonumber(os.date("%M")) + (tonumber(os.date("%j")) *(24*60) )          )
end

function Mercury.Bans.GetTimeStruct(minuites)
	return (Mercury.Bans.GetTime() + minuites)
end

function Mercury.Bans.GetBanDuration(bantime) -- RETURNS BAN LENGTH IN MINUITES.
	return bantime - Mercury.Bans.GetTime()
end

function Mercury.Bans.UnbanID(STEAM,REASON)
	 Msg("[Mercury]: UNBANID -> " .. STEAM .. " (" .. REASON .. ")")
	 Msg(" . . . ")
	 if (file.Exists("mercury/bans/" .. SAFESID(STEAM) .. ".txt","DATA")) then
	 		file.Delete("mercury/bans/" .. SAFESID(STEAM) .. ".txt")
	 		Msg("SUCCESS")
	 		return true,nil
	 else
	 		Msg("FAIL (BAN NOT EXISTANT) ")
	 		return false,"Ban did not exist!"

	 end
	
end
function Mercury.Bans.IsBanned(STEAM)
	 if (file.Exists("mercury/bans/" .. SAFESID(STEAM) .. ".txt","DATA")) then
	 	local FI = file.Read("mercury/bans/" .. SAFESID(STEAM) .. ".txt","DATA") -- READ BAN.
		local BINF = util.JSONToTable(FI)
		if BINF["unbantime"]~=0 then
			if BINF["unbantime"] <= Mercury.Bans.GetTime() then
				Mercury.Bans.UnbanID(STEAM ,"AUTO: BAN TIME EXPIRED.") return false
			end
		end

	 	return true,BINF["reason"],BINF["unbantime"] ,BINF["bannedby"]
	 		
	 else
	 	return false,"NOT BANNED",0
	 end
end


--util.SteamIDFrom64( string id ) 
function Mercury.Bans.Prune()
	for k,v in pairs(file.Find("mercury/bans/*.txt","DATA")) do
		-- Decode table
		pcall(function()

			local FI = file.Read("mercury/bans/" .. v,"DATA") -- READ BAN.
			local BINF = util.JSONToTable(FI)
			if BINF["unbantime"]~=0 then
				if BINF["unbantime"] <= Mercury.Bans.GetTime() then
					Mercury.Bans.UnbanID(string.sub(v,#v-#v,#v-4) ,"AUTO: BAN TIME EXPIRED.")
				end
			end
		end)
	end
end
 

function Mercury.Bans.Add(caller,plr,time,rsn)
	if !plr then return false,"No player specified" end
	if !time then time = 5 end
	if !type(caller)=="Player" then caller = "[SERVER]" else
		if type(caller)=="Player" then
			 caller = caller:GetName()
		end
	end
	local ban = {}
	ban["bannedby"] = caller
	if time~=0 then
		ban["unbantime"] = Mercury.Bans.GetTimeStruct(time)
	else
		ban["unbantime"] = 0
	end
	rsn = string.gsub(rsn,[["]],"-")
	ban["reason"] = rsn
	if type(plr)=="Player" then
		file.Write("mercury/bans/" .. SAFESID(plr:SteamID()) .. ".txt",util.TableToJSON(ban))
	else
		file.Write("mercury/bans/" .. SAFESID(plr) .. ".txt",util.TableToJSON(ban))
	end
	
	PrintTable(ban)
 end

function Mercury.Bans.ConnectionCheck(steamID,ipAdress, svPassword, clPassword, name)
	if svPassword and svPassword !="" then 
		if clPassword~=svPassword then return false,"Incorrect password!" end
	end

	local stm = util.SteamIDFrom64( steamID )
	local banned,reason,time,banner = Mercury.Bans.IsBanned(stm)
	banned = not banned -- I have to reverse the result of the value, due to the nature of the hook.
	local banmsg = "Sorry " .. name .. " you have been banned!  Though unfortunately we were unable to retrieve any information on your ban."
	if banned==false then 
		if time~=0 then 
			-- banmsg = "Your ban expires in: " .. Mercury.Bans.GetBanDuration(time) .. "(" .. reason.. ")"
			banmsg = 
			[[Greetings %s, we're sorry to inform you that you are banned. 
			You will be unbanned in: %d minuites 

			Reasoning: %s 

			Inflicting Administrator: %s ]]
			banmsg = string.format(banmsg,name,Mercury.Bans.GetBanDuration(time),reason,banner)

		else
				banmsg = 
			[[Greetings %s, we're sorry to inform you that you are banned.
			This ban is not set to expire. 

			Reasoning: %s 
			Banning Administrator Name: %s .]]
			banmsg = string.format(banmsg,name,reason,banner)
		end
			print("[BANSYS]: CNCT_DENY_BANNED " .. stm .. " " .. banmsg)
			Mercury.Util.Broadcast({Color(255,1,1,255),name,Color(47,150,255,255), " has tried to connect but is banned for " .. reason})
		else
			Mercury.Util.Broadcast({Color(255,1,1,255),name,Color(47,150,255,255), " has connected."})

	end
	

	return banned,banmsg
end
hook.Add("CheckPassword","MARS_CheckBanned",Mercury.Bans.ConnectionCheck)


net.Receive("Mercury:BanData",function(len,p)
	local args = net.ReadString()
	if args == "GET_DATA" then 
		local bdata = {}
		for k,v in pairs(file.Find("mercury/bans/*.txt","DATA")) do
			-- Decode table
			local FI = file.Read("mercury/bans/" .. v,"DATA") -- READ BAN.
			local BINF = util.JSONToTable(FI)
			local bkey = USAFESID(v)
			
			
			bkey = string.sub(bkey,0,#bkey-4)
			BINF.STEAMID = USAFESID(bkey)
			BINF.TimeRemaining = Mercury.Bans.GetBanDuration(BINF["unbantime"])  
			if BINF.TimeRemaining < -1 then 
				BINF.TimeRemaining = "Unbanned."
			end

			if BINF["unbantime"]==0 then 
				BINF.TimeRemaining = "Never"
			end
		
			bdata[#bdata + 1] = BINF
		end
		net.Start("Mercury:BanData")
		
			net.WriteTable({data = bdata,tchunks = 0,chunkno = 0})
		net.Send(p)
	end

end)