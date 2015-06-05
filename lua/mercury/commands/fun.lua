Mercury.Commands.AddPrivilege("physgunpickup")

if SERVER then 
    local function PlayerPickup( ply, ent )
        if ply:HasPrivilege("physgunpickup") and ent:GetClass():lower() == "player" then
            if ply:CanUserTarget(ent) then
                return true
            else 
                return false
            end
        end
    end
    hook.Add( "PhysgunPickup", "MercuryPhysgunPickup", PlayerPickup )
end

-------------------------
--// Local Functions //--
-------------------------
local function DoInvisible()
    local players = player.GetAll()
    local remove = true
    for _, player in ipairs( players ) do
        local t = player:GetTable()
        if t.invis then
            remove = false
            if player:Alive() and player:GetActiveWeapon():IsValid() then
                if player:GetActiveWeapon() ~= t.invis.wep then

                    if t.invis.wep and IsValid( t.invis.web ) then      -- If changed weapon, set the old weapon to be visible.
                        t.invis.wep:SetRenderMode( RENDERMODE_NORMAL )
                        t.invis.wep:Fire( "alpha", 255, 0 )
                        t.invis.wep:SetMaterial( "" )
                    end

                    t.invis.wep = player:GetActiveWeapon()
                    Mercury.Invisible(player, true, t.invis.vis)
                end
            end
        end
    end

    if remove then
        hook.Remove( "Think", "InvisThink" )
    end
end

function Mercury.Invisible( ply, bool, visibility )
    if not ply:IsValid() then return end -- This is called on a timer so we need to verify they're still connected

    if bool == true then
        visibility = visibility or 0
        ply:DrawShadow( false )
        ply:SetRenderMode( RENDERMODE_TRANSALPHA )
        ply:Fire( "alpha", visibility, 0 )
        ply:GetTable().invis = { vis=visibility, wep=ply:GetActiveWeapon() }

        if IsValid( ply:GetActiveWeapon() ) then
            ply:GetActiveWeapon():SetRenderMode( RENDERMODE_TRANSALPHA )
            ply:GetActiveWeapon():Fire( "alpha", visibility, 0 )
            ply:GetActiveWeapon():SetMaterial( "models/effects/vol_light001" )
            if ply:GetActiveWeapon():GetClass() == "gmod_tool" then
                ply:DrawWorldModel( false ) -- tool gun has problems
            else
                ply:DrawWorldModel( true )
            end
        end

        hook.Add( "Think", "InvisThink", DoInvisible )
    else
        ply:DrawShadow( true )
        ply:SetMaterial( "" )
        ply:SetRenderMode( RENDERMODE_NORMAL )
        ply:Fire( "alpha", 255, 0 )
        local activeWeapon = ply:GetActiveWeapon()
        if IsValid( activeWeapon ) then
            activeWeapon:SetRenderMode( RENDERMODE_NORMAL )
            activeWeapon:Fire( "alpha", 255, 0 )
            activeWeapon:SetMaterial( "" )
        end
        ply:GetTable().invis = nil
    end
end

-------------------------
--//  The  commands  //--
-------------------------

-- Explode
local MCMD = Mercury.Commands.CreateTable("explode", "exploded", true, "<player>", true, true, true, "Fun")
function callfunc(caller,args)
	local ply = args[1]
	local rmtab = {}
	ply:EmitSound("items/cart_explode_falling.wav",150)
    ply:SetPos(ply:GetPos() + Vector(0,0,10))
    ply:SetVelocity(Vector(0,0,99999))
    timer.Simple(0.2,function() 
        ply:Kill()

        ply:EmitSound("items/cart_explode.wav")

              local explosive = ents.Create( "env_explosion" )
                        explosive:SetPos( ply:GetPos() )
                        explosive:SetOwner( ply )
                        explosive:Spawn()
                        explosive:SetKeyValue( "iMagnitude", "1" )
                        explosive:Fire( "Explode", 0, 0 )

        for I=1,6 do
            rmtab[I] = ents.Create("prop_physics")
            rmtab[I]:SetModel("models/Roller.mdl")
            rmtab[I]:SetPos(ply:GetPos() + Vector(math.random(-50,50) ,math.random(-50,50) ,math.random(-50,50)))
            rmtab[I]:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
            rmtab[I]:Spawn()
            local trail = util.SpriteTrail(rmtab[I], 0, Color(math.random(1,255) ,math.random(1,255) ,math.random(1,255) ), false, 15, 1, 10, 3, "trails/plasma.vmt")
            rmtab[I]:GetPhysicsObject():SetVelocityInstantaneous(Vector(math.random(-1000,1000) ,math.random(-1000,1000) ,1000))

        end
        timer.Simple(10,function()
            for k,v in pairs(rmtab) do
                if v and IsValid(v) then v:Remove() end
            end

        end)    
    end)

	return true,"",false,{}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn( "Players" )
    ctrl:SetSize( 210, 380 )    
    ctrl:SetPos( 10, 0 )
               
    local Button = vgui.Create( "DButton" , frame)
    Button:SetPos( 240, 40 )
    Button:SetText( "Explode" )
    Button:SetSize( 130, 60 )
    Button:SetDisabled(true)
    Button.DoClick = function(self)
        if self:GetDisabled()==true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("explode")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid,isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        Button:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end 
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Noclip
local MCMD = Mercury.Commands.CreateTable("noclip", "", true, "<player>", true, false, true, "Fun")
function callfunc(caller, args)
    local target_player = nil
    if !args[1] then 
        target_player = caller 
    end

    if args[1] then
        if type(args[1])=="string" then 
            local plr = Mercury.Commands.PlayerLookup(args[1])
            if IsValid(plr) then 
                target_player = plr 
            end 
        elseif type(args[1])=="Player" then 
                target_player = args[1]


        end 

    end


    if IsValid(caller) then 
        if not caller:CanUserTarget(target_player) then 
                return false,"You cannot target this person."
        end

    end

    if !target_player or !IsValid(target_player) then 
        return false,"Could not find target."
    end

    target_player:ExitVehicle()
    
    if target_player:GetMoveType() == MOVETYPE_WALK then
        target_player:SetMoveType( MOVETYPE_NOCLIP )
    elseif target_player:GetMoveType() == MOVETYPE_NOCLIP then
        target_player:SetMoveType( MOVETYPE_WALK )
    else
        return false, target_player:Nick() .. " can't be noclipped right now", false, {}
    end


    if target_player == caller then
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " toggled noclip for themselves."}
    else
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " toggled noclip for ", target_player,  Mercury.Config.Colors.Default, "."}
    end
    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
    
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)
               
    local NoclipButton = vgui.Create("DButton" , frame)
    NoclipButton:SetPos(240, 40)
    NoclipButton:SetText("Toggle Noclip")
    NoclipButton:SetSize(130, 60)
    NoclipButton:SetDisabled(true)
    NoclipButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("noclip")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        NoclipButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Slap
local MCMD = Mercury.Commands.CreateTable("slap", "", true, "<player> <damage>", true, true, true, "Fun")
function callfunc(caller, args)
    local target_player = nil
    local damage = args[2] or 0
    local sSounds = {
        "physics/body/body_medium_impact_hard1.wav",
        "physics/body/body_medium_impact_hard2.wav",
        "physics/body/body_medium_impact_hard3.wav",
        "physics/body/body_medium_impact_hard5.wav",
        "physics/body/body_medium_impact_hard6.wav",
        "physics/body/body_medium_impact_soft5.wav",
        "physics/body/body_medium_impact_soft6.wav",
        "physics/body/body_medium_impact_soft7.wav",
    }

    if not args[1] then return false, "No target player was defined." end


    if IsValid(args[1]) and args[1]:IsPlayer() then 
        if not args[1]:Alive() then return end
        args[1]:ExitVehicle()
        if args[1]:GetMoveType() == MOVETYPE_NOCLIP then
            args[1]:SetMoveType(MOVETYPE_WALK)
        end

        args[1]:EmitSound(sSounds[math.random(#sSounds)])
        
        local direction = Vector(math.random(20) - 10, math.random(20) - 10, math.random(20) - 5)
        local accel = direction * 50
        args[1]:SetPos(args[1]:GetPos() + Vector(0,0,8))
        args[1]:SetVelocity(accel)

        -- Angular punch
        local angle_punch_pitch = math.Rand( -20, 20 )
        local angle_punch_yaw = math.sqrt( 20*20 - angle_punch_pitch * angle_punch_pitch )
        if math.random( 0, 1 ) == 1 then
            angle_punch_yaw = angle_punch_yaw * -1
        end
        args[1]:ViewPunch(Angle(angle_punch_pitch, angle_punch_yaw, 0))

        -- Deal with their health
        local newHp = args[1]:Health() - damage
        if newHp <= 0 then
            if args[1]:IsPlayer() then
                args[1]:Kill()
            end
        else
            -- Set the new health
            args[1]:SetHealth(newHp)
        end
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " slapped ", args[1], " for ", Mercury.Config.Colors.Arg, damage, Mercury.Config.Colors.Default, " damage."}
    end
    
    -- Finish!
    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local Damage = vgui.Create("DTextEntry", frame)
    Damage:SetPos(240, 20)
    Damage:SetSize(130, 20)
    Damage:CheckNumeric(true)
    Damage:SetText("Damage")
    Damage:SetEnterAllowed(false)
               
    local SlapButton = vgui.Create("DButton" , frame)
    SlapButton:SetPos(240, 40)
    SlapButton:SetText("Slap")
    SlapButton:SetSize(130, 60)
    SlapButton:SetDisabled(true)
    SlapButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        local damage = nil
        local IsNumeric = true
        local DamageVal = Damage:GetValue()
        for i=1, #DamageVal do
            if (string.byte(DamageVal[i]) >= 48 and string.byte(DamageVal[i]) <= 57) then
                continue
            else
                IsNumeric = false
                break
            end
        end
        if IsNumeric == true then damage = DamageVal end

        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("slap")
            net.WriteTable({selectedplayer, damage})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        SlapButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Cloak
local MCMD = Mercury.Commands.CreateTable("cloak", "", true, "<player> <amount>", true, true, true, "Fun")
function callfunc(caller, args)
    local amount = 0
    if !args[2] then amount = 255 else amount = args[2] end
    Mercury.Invisible(args[1], true, amount)
    return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " cloaked ", args[1],  Mercury.Config.Colors.Default, " by amount ", Mercury.Config.Colors.Arg, amount}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
    local cloak_amount = 0
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local NumSlider = vgui.Create("DNumSlider", frame)
    NumSlider:SetPos(230, 15)
    NumSlider:SetWide(150)
    NumSlider:SetText("Amount")
    NumSlider:SetMinMax(0, 255)
    NumSlider:SetDecimals(0)
    NumSlider:SetValue(0)
                        
    local Button = vgui.Create("DButton" , frame)
    Button:SetPos(230, 40)
    Button:SetText("Cloak")
    Button:SetSize(150, 20)
    Button:SetDisabled(true)
    Button.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        cloak_amount = NumSlider:GetValue()
        print(cloak_amount)
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("cloak")
            net.WriteTable({selectedplayer, cloak_amount})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        Button:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Uncloak
local MCMD = Mercury.Commands.CreateTable("uncloak", "uncloaked", true, "<player>", true, true, true, "Fun")
MCMD.Command = "uncloak"
MCMD.Verb = "uncloaked"
MCMD.RconUse = true
MCMD.Useage = "<player>"
MCMD.UseImmunity = true
MCMD.PlayerTarget = true
MCMD.HasMenu = true
MCMD.Category = "Fun" 
 
function callfunc(caller, args)
    if !args[2] then args[2] = 255 end 
    Mercury.Invisible(args[1], false, 255)
    return true, "", false,{}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)
               
    local Button = vgui.Create("DButton" , frame)
    Button:SetPos(240, 40)
    Button:SetText("Uncloak")
    Button:SetSize(130, 60)
    Button:SetDisabled(true)
    Button.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("uncloak")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        Button:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Jail
local jailstuff = {}
timer.Create("JailRemove",0.8,0,function()
    for k,v in pairs(jailstuff) do
        if !IsValid(v["player"]) then 
            for o,ent in pairs(v["jail"]) do
                if IsValid(ent) then 
                    ent:Remove()
                end
            end
        end
    end
end)

local MCMD = Mercury.Commands.CreateTable("jail", "", true, "<player> <time>", true, true, false, "Fun")
function callfunc(caller, args)
    local ply = nil
    local time = 999999
    local Jail = {
        { pos = Vector( 0, 0, -5 ), ang = Angle( 90, 0, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( 0, 0, 97 ), ang = Angle( 90, 0, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( 21, 31, 46 ), ang = Angle( 0, 90, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( 21, -31, 46 ), ang = Angle( 0, 90, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( -21, 31, 46 ), ang = Angle( 0, 90, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( -21, -31, 46), ang = Angle( 0, 90, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( -52, 0, 46 ), ang = Angle( 0, 0, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
        { pos = Vector( 52, 0, 46 ), ang = Angle( 0, 0, 0 ), mdl = Model("models/props_building_details/Storefront_Template001a_Bars.mdl") },
    }

    if args[1] then ply = args[1] else return false, "No target player was specified." end
    if args[2] then time = tonumber(args[2]) end


    if IsValid(ply) and ply:IsPlayer() and not ply.IsJailed then 
        ply:ExitVehicle()
        -- Construct the jail
        ply.IsJailed = true
        ply.JailWalls = {}
        local jailtab = {}
        for _, info in ipairs(Jail) do
            local ent = ents.Create("prop_physics")
            ent:SetModel(info.mdl)
            ent:SetPos(ply:GetPos() + info.pos)
            ent:SetAngles(info.ang)
            ent:Spawn()
            ent:GetPhysicsObject():EnableMotion(false)
            ent:SetMoveType(MOVETYPE_NONE)
            ent.jailWall = true
            jailtab[#jailtab + 1] = ent
            table.insert(ply.JailWalls, ent)
        end

        jailstuff[#jailstuff + 1 ] = {player = ply, jail = jailtab}

        timer.Create("Mercury:JailedPlayer:"..ply:UniqueID(), time, 1, function()
            if IsValid(ply) and ply.IsJailed == true then
                ply.IsJailed = nil
                for k,v in pairs(jailstuff) do 
                    if v["player"]==ply then 
                        table.remove(jailstuff,k)
                    end
                end
                for _, ent in ipairs(ply.JailWalls) do
                    if ent:IsValid() then
                        ent:Remove()
                    end
                end
            end
        end, ply)
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " has jailed ", args[1], " for ", Mercury.Config.Colors.Arg, time, Mercury.Config.Colors.Default, " seconds."}
    elseif IsValid(ply) and ply:IsPlayer() and ply.IsJailed == true then 
        return false, ply:Nick().." is already jailed."
    end
    
    -- Finish!
    return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- UnJail
local MCMD = Mercury.Commands.CreateTable("unjail", "", true, "<player>", true, true, false, "Fun")
function callfunc(caller, args)
    local ply = nil
    if args[1] then ply = args[1] else return false, "No target player was specified." end


    if IsValid(ply) and ply:IsPlayer() and ply.IsJailed == true then 
        -- Construct the jail
        ply.IsJailed = nil
        for _, ent in ipairs(ply.JailWalls) do
            if ent:IsValid() then
                ent:Remove()
            end
        end
          for k,v in pairs(jailstuff) do 
                    if v["player"]==ply then 
                        table.remove(jailstuff,k)
                    end
          end
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " has unjailed ", args[1], Mercury.Config.Colors.Default, "."}
    elseif IsValid(ply) and ply:IsPlayer() and not ply.IsJailed then 
        return false, ply:Nick().." is not jailed."
    end
    
    -- Finish!
    return true, "", false, {}
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- HP
local MCMD = Mercury.Commands.CreateTable("hp", "", true, "<player> <amount>", true, true, true, "Fun")
function callfunc(caller, args)
    if not args[1] then return false, "No target player was specified." end
    if not args[2] or tonumber(args[2]) < 0 then return false, "No health amount was specified." end

    if IsValid(args[1]) and args[1]:IsPlayer() then 
        -- Set the new health
        local health = tonumber(args[2])
        args[1]:SetHealth(health)
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " has set the hp of ", args[1], " to ", Mercury.Config.Colors.Arg, health, Mercury.Config.Colors.Default, "."}
    end
    
    -- Finish!
    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil

    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local HP = vgui.Create("DTextEntry", frame)
    HP:SetPos(240, 20)
    HP:SetSize(130, 20)
    HP:CheckNumeric(true)
    HP:SetText("Amount")
    HP:SetEnterAllowed(false)
               
    local HPButton = vgui.Create("DButton" , frame)
    HPButton:SetPos(240, 40)
    HPButton:SetText("Set Health")
    HPButton:SetSize(130, 60)
    HPButton:SetDisabled(true)
    HPButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        local health = 100
        local IsNumeric = true
        local hpVal = HP:GetValue()
        for i=1, #hpVal do
            if (string.byte(hpVal[i]) >= 48 and string.byte(hpVal[i]) <= 57) then
                continue
            else
                IsNumeric = false
                break
            end
        end
        if IsNumeric == true then health = hpVal end

        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("hp")
            net.WriteTable({selectedplayer, health})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs(players) do
        local item = ctrl:AddLine(ply:Nick())
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        HPButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

--Armor
local MCMD = Mercury.Commands.CreateTable("armor", "", true, "<player> <amount>", true, true, true, "Fun")
function callfunc(caller, args)
    if not args[1] then return false, "No target player was specified." end
    if not args[2] or tonumber(args[2]) < 0 then return false, "No armor amount was specified." end
    if tonumber(args[2]) > 255 then args[2] = 255 end

    if IsValid(args[1]) and args[1]:IsPlayer() then 
        -- Set the new armor
        local armor = tonumber(args[2])
        args[1]:SetArmor(armor)
        return true, "", true, {Mercury.Config.Colors.Server, caller, Mercury.Config.Colors.Default, " has set the armor of ", args[1], " to ", Mercury.Config.Colors.Arg, armor, Mercury.Config.Colors.Default, "."}
    end
    
    -- Finish!
    return true, "", false, {}
end

function MCMD.GenerateMenu(frame)
    local selectedplayer = nil

    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local Armor = vgui.Create("DTextEntry", frame)
    Armor:SetPos(240, 20)
    Armor:SetSize(130, 20)
    Armor:CheckNumeric(true)
    Armor:SetText("Amount")
    Armor:SetEnterAllowed(false)
               
    local ArmorButton = vgui.Create("DButton" , frame)
    ArmorButton:SetPos(240, 40)
    ArmorButton:SetText("Set Health")
    ArmorButton:SetSize(130, 60)
    ArmorButton:SetDisabled(true)
    ArmorButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        local armor = 0
        local IsNumeric = true
        local armorVal = Armor:GetValue()
        for i=1, #armorVal do
            if (string.byte(armorVal[i]) >= 48 and string.byte(armorVal[i]) <= 57) then
                continue
            else
                IsNumeric = false
                break
            end
        end
        if IsNumeric == true then armor = armorVal end

        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("armor")
            net.WriteTable({selectedplayer, armor})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs(players) do
        local item = ctrl:AddLine(ply:Nick())
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        ArmorButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Ignite
local MCMD = Mercury.Commands.CreateTable("ignite", "", true, "<player> <time>", true, true, true, "Fun")
function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.
    if not args[1] then return false, "No player was supplied to the command", false, {} end

    local time = 999
    if args[2] then time = args[2] end

    if args[1] and IsValid(args[1]) and args[1]:IsPlayer() then
        if args[1]:Alive() then
            args[1]:Ignite(time)
            return true, "", true, {args[1],Mercury.Config.Colors.Default," has been ignited for ", Mercury.Config.Colors.Arg, time, Mercury.Config.Colors.Default, " seconds"}
        else
            return false, args[1]:Nick().." is dead", false, {}
        end
    end

    return true, "", false, {}
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
    local time = 999
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local Time = vgui.Create("DTextEntry", frame)
    Time:SetPos(240, 20)
    Time:SetSize(130, 20)
    Time:CheckNumeric(true)
    Time:SetText("Enter a time")
    Time:SetEnterAllowed(false)
               
    local SpawnButton = vgui.Create("DButton" , frame)
    SpawnButton:SetPos(240, 40)
    SpawnButton:SetText("Ignite")
    SpawnButton:SetSize(130, 60)
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        
        local time = nil
        local IsNumeric = true
        local timeVal = Time:GetValue()
        for i=1, #timeVal do
            if (string.byte(timeVal[i]) >= 48 and string.byte(timeVal[i]) <= 57) then
                continue
            else
                IsNumeric = false
                break
            end
        end
        if IsNumeric == true then time = timeVal end

        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("ignite")
            net.WriteTable({selectedplayer, time})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        SpawnButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Extinguish
local MCMD = Mercury.Commands.CreateTable("extinguish", "", true, "<player>", true, true, true, "Fun")
function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.
    if not args[1] then return false, "No player was supplied to the command", false, {} end

    if args[1] and IsValid(args[1]) and args[1]:IsPlayer() then
        if args[1]:Alive() then
            if args[1]:IsOnFire() then
                args[1]:Extinguish()
                return true, "", true, {args[1],Mercury.Config.Colors.Default," has been extinguished"}
            else
                 return false, args[1]:Nick().." is not on fire", false, {}
            end
        else
            return false, args[1]:Nick().." is dead", false, {}
        end
    end

    return true, "", false, {}
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
    local time = 999
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)

    local SpawnButton = vgui.Create("DButton" , frame)
    SpawnButton:SetPos(240, 40)
    SpawnButton:SetText("Extinguish")
    SpawnButton:SetSize(130, 60)
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("extinguish")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        SpawnButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Slay
local MCMD = Mercury.Commands.CreateTable("slay", "slayed", true, "<player>", true, true, true, "Fun")
function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.
    
    if not args[1] then
        return false, "No player was supplied to the command", false, {}
    end

    if args[1] and IsValid(args[1]) and args[1]:IsPlayer() then
        if args[1]:Alive() then
            args[1]:Kill()
        else
            return false, args[1]:Nick().." is already dead", false, {}
        end
    end

    return true, "", false, {}
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)
               
    local SpawnButton = vgui.Create("DButton" , frame)
    SpawnButton:SetPos(240, 40)
    SpawnButton:SetText("Slay")
    SpawnButton:SetSize(130, 60)
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("slay")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        SpawnButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)

-- Silent Slay
local MCMD = Mercury.Commands.CreateTable("sslay", "", true, "<player>", true, true, true, "Fun")
function callfunc(caller, args)
    -- Caller is the player who issued the command.
    -- args is the string or player arguments that may have been passed.
    
    if not args[1] then
        return false, "No player was supplied", false, {}
    end

    if args[1] and IsValid(args[1]) and args[1]:IsPlayer() then
        if args[1]:Alive() then
            args[1]:KillSilent()
        else
            return false, args[1]:Nick().." is already dead", false, {}
        end
    end

    return false, " "
end


function MCMD.GenerateMenu(frame)
    local selectedplayer = nil
 
    local ctrl = vgui.Create( "DListView", frame)
    ctrl:AddColumn("Players")
    ctrl:SetSize(210, 380)    
    ctrl:SetPos(10, 0)
               
    local SpawnButton = vgui.Create("DButton" , frame)
    SpawnButton:SetPos(240, 40)
    SpawnButton:SetText("Silent Slay")
    SpawnButton:SetSize(130, 60)
    SpawnButton:SetDisabled(true)
    SpawnButton.DoClick = function(self)
        if self:GetDisabled() == true then return false end
        surface.PlaySound("buttons/button3.wav")
        net.Start("Mercury:Commands")
            net.WriteString("sslay")
            net.WriteTable({selectedplayer})
        net.SendToServer()
    end
 
    local players = player.GetAll()
    local t = {}
    for _, ply in ipairs( players ) do
        local item = ctrl:AddLine( ply:Nick() )
        item.ply = ply
    end
 
    function ctrl:OnRowSelected(lineid, isselected)
        local line_obj = self:GetLine(lineid)
        surface.PlaySound("buttons/button6.wav")
        SpawnButton:SetDisabled(false)
        selectedplayer = line_obj.ply
        return true
    end
end
Mercury.Commands.AddCommand(MCMD.Command, MCMD, callfunc)