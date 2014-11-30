include('player_infocard.lua')
 
// checking for utime for the hours
utimecheck = false
 
 
//local texGradient = surface.GetTextureID( "gui/center_gradient" )
 
/*local texRatings = {}
texRatings[ 'none' ]            = surface.GetTextureID( "gui/silkicons/user" )
texRatings[ 'smile' ]           = surface.GetTextureID( "gui/silkicons/emoticon_smile" )
texRatings[ 'lol' ]             = surface.GetTextureID( "gui/silkicons/emoticon_smile" )
texRatings[ 'gay' ]             = surface.GetTextureID( "gui/gmod_logo" )
texRatings[ 'stunter' ]         = surface.GetTextureID( "gui/inv_corner16" )
texRatings[ 'god' ]             = surface.GetTextureID( "gui/gmod_logo" )
texRatings[ 'curvey' ]          = surface.GetTextureID( "gui/corner16" )
texRatings[ 'best_landvehicle' ]        = surface.GetTextureID( "gui/faceposer_indicator" )
texRatings[ 'best_airvehicle' ]                 = surface.GetTextureID( "gui/arrow" )
texRatings[ 'naughty' ]         = surface.GetTextureID( "gui/silkicons/exclamation" )
texRatings[ 'friendly' ]        = surface.GetTextureID( "gui/silkicons/user" )
texRatings[ 'informative' ]     = surface.GetTextureID( "gui/info" )
texRatings[ 'love' ]            = surface.GetTextureID( "gui/silkicons/heart" )
texRatings[ 'artistic' ]        = surface.GetTextureID( "gui/silkicons/palette" )
texRatings[ 'gold_star' ]       = surface.GetTextureID( "gui/silkicons/star" )
texRatings[ 'builder' ]         = surface.GetTextureID( "gui/silkicons/wrench" )
 
surface.GetTextureID( "gui/silkicons/emoticon_smile" )*/
 
local PANEL = {}
 
/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint( w, h )
        if not IsValid( self.Player ) then
                self:Remove()
                SCOREBOARD:InvalidateLayout()
                return
        end
       
        local color = Color( 100, 100, 100, 255 )
 
        if self.Armed then
                color = Color( 125, 125, 125, 255 )
        end
       
        if self.Selected then
                color = Color( 125, 125, 125, 255 )
        end
       
        if self.Player:Team() == TEAM_CONNECTING then
                color = Color( 100, 100, 100, 155 )
        elseif IsValid( self.Player ) then
                if self.Player:Team() == TEAM_UNASSIGNED then
                        color = Color( 100, 100, 100, 255 )
                else   
                        color = team.GetColor( self.Player:Team() )
                end
        elseif self.Player:IsAdmin() then
                color = Color( 255, 155, 0, 255 )
        end
       
        if self.Player == LocalPlayer() then
                color = team.GetColor( self.Player:Team() )
        end
 
        if self.Open or self.Size ~= self.TargetSize then
                draw.RoundedBox( 1, 18, 16, self:GetWide() - 36, self:GetTall() - 16, color )
                draw.RoundedBox( 1, 20, 16, self:GetWide() - 36, self:GetTall() - 16 - 2, Color( 225, 225, 225, 150 ) )
               
                //surface.SetTexture( texGradient )
                //surface.SetDrawColor( 255, 255, 255, 100 )
                //surface.DrawTexturedRect( 20, 16, self:GetWide() - 40, self:GetTall() - 18 )
        end
       
        draw.RoundedBox( 0, 18, 0, self:GetWide() - 36, 38, color )
       
        //surface.SetTexture( texGradient )
        //surface.SetDrawColor( 255, 255, 255, 150 )
        //surface.DrawTexturedRect( 0, 0, self:GetWide() - 36, 38 )
       
        /*surface.SetTexture( self.texRating )
        surface.SetDrawColor( 255, 255, 255, 255 )
        -- surface.DrawTexturedRect( 20, 4, 16, 16 )
        surface.DrawTexturedRect( 56, 3, 16, 16 )*/
       
        return true
end
 
/*---------------------------------------------------------
   Name: SetPlayer
---------------------------------------------------------*/
function PANEL:SetPlayer( ply )
        self.Player = ply
        self.infoCard:SetPlayer( ply )
        self:UpdatePlayerData()
        self.imgAvatar:SetPlayer( ply )
end
 
/*function PANEL:CheckRating( name, count )
        if self.Player:GetNetworkedInt( "Rating." .. name, 0 ) > count then
                count = self.Player:GetNetworkedInt( "Rating." .. name, 0 )
                self.texRating = texRatings[ name ]
        end
        return count
end*/
 
/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:UpdatePlayerData()
        local ply = self.Player
        if not IsValid( ply ) then return end
       
        self.lblName:SetText( ply:Nick() )
        self.lblTeam:SetText( team.GetName( ply:Team() ) )
        self.lblHours:SetText( string.NiceTime(ply:GetNWInt("ranktime")) )
        self.lblHealth:SetText( ply:Health() )
        self.lblFrags:SetText( ply:Frags() )
        self.lblDeaths:SetText( ply:Deaths() )
        self.lblPing:SetText( ply:Ping() )
 
        local k = ply:Frags()
        local d = ply:Deaths()
        local kdr = "--   "
        if d ~= 0 then
           kdr = k / d
           local y, z = math.modf( kdr )
           z = string.sub( z, 1, 5 )
           if y ~= 0 then kdr = string.sub( y + z, 1, 5 ) else kdr = z end
           kdr = kdr .. ":1"
           if k == 0 then kdr = k .. ":" .. d end
        end
 
        self.lblRatio:SetText( kdr )
       
        // Work out what icon to draw
        /*self.texRating = surface.GetTextureID( "gui/silkicons/emoticon_smile" )
 
        self.texRating = texRatings[ 'none' ]
        local count = 0
       
        count = self:CheckRating( 'smile', count )
        count = self:CheckRating( 'love', count )
        count = self:CheckRating( 'artistic', count )
        count = self:CheckRating( 'gold_star', count )
        count = self:CheckRating( 'builder', count )
        count = self:CheckRating( 'lol', count )
        count = self:CheckRating( 'gay', count )
        count = self:CheckRating( 'curvey', count )
        count = self:CheckRating( 'god', count )
        count = self:CheckRating( 'stunter', count )
        count = self:CheckRating( 'best_landvehicle', count )
        count = self:CheckRating( 'best_airvehicle', count )
        count = self:CheckRating( 'friendly', count )
        count = self:CheckRating( 'informative', count )
        count = self:CheckRating( 'naughty', count )*/
end
 
/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()
        self.Size = 38
        self:OpenInfo( false )
       
        self.infoCard   = vgui.Create( "suiscoreplayerinfocard", self )
       
        self.lblName    = vgui.Create( "DLabel", self )
         self.lblTeam   = vgui.Create( "DLabel", self )
        self.lblHours   = vgui.Create( "DLabel", self )
        self.lblHealth  = vgui.Create( "DLabel", self )
        self.lblFrags   = vgui.Create( "DLabel", self )
        self.lblDeaths  = vgui.Create( "DLabel", self )
        self.lblRatio   = vgui.Create( "DLabel", self )
        self.lblPing    = vgui.Create( "DLabel", self )
        self.lblPing:SetText( "9999" )
       
        self.btnAvatar = vgui.Create( "DButton", self )
        self.btnAvatar.DoClick = function() self.Player:ShowProfile() end
       
        self.imgAvatar = vgui.Create( "AvatarImage", self.btnAvatar )
       
        // If you don't do this it'll block your clicks
        self.lblName:SetMouseInputEnabled( false )
        self.lblTeam:SetMouseInputEnabled( false )
        self.lblHours:SetMouseInputEnabled( false )
        self.lblHealth:SetMouseInputEnabled( false )
        self.lblFrags:SetMouseInputEnabled( false )
        self.lblDeaths:SetMouseInputEnabled( false )
        self.lblRatio:SetMouseInputEnabled( false )
        self.lblPing:SetMouseInputEnabled( false )
        self.imgAvatar:SetMouseInputEnabled( false )
end
 
/*---------------------------------------------------------
   Name: ApplySchemeSettings
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()
        self.lblName:SetFont( "suiscoreboardplayername" )
         self.lblTeam:SetFont( "suiscoreboardplayername" )
        self.lblHours:SetFont( "suiscoreboardplayername" )
        self.lblHealth:SetFont( "suiscoreboardplayername" )
        self.lblFrags:SetFont( "suiscoreboardplayername" )
        self.lblDeaths:SetFont( "suiscoreboardplayername" )
        self.lblRatio:SetFont( "suiscoreboardplayername" )
        self.lblPing:SetFont( "suiscoreboardplayername" )
       
        self.lblName:SetTextColor( color_black )
        self.lblTeam:SetTextColor( color_black )
        self.lblHours:SetTextColor( color_black )
        self.lblHealth:SetTextColor( color_black )
        self.lblFrags:SetTextColor( color_black )
        self.lblDeaths:SetTextColor( color_black )
        self.lblRatio:SetTextColor( color_black )
        self.lblPing:SetTextColor( color_black )
end
 
/*---------------------------------------------------------
   Name: DoClick
---------------------------------------------------------*/
function PANEL:DoClick()
        if self.Open then
                surface.PlaySound( "ui/buttonclickrelease.wav" )
        else
                surface.PlaySound( "ui/buttonclick.wav" )
        end
        self:OpenInfo( not self.Open )
end
 
/*---------------------------------------------------------
   Name: OpenInf--------------------------------------------*/
function PANEL:OpenInfo( open )
        if open then
                self.TargetSize = 150
        else
                self.TargetSize = 22
        end
        self.Open = open
end
 
/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function PANEL:Think()
        if self.Size ~= self.TargetSize then
                self.Size = math.Approach( self.Size, self.TargetSize, (math.abs( self.Size - self.TargetSize ) + 1) * 10 * FrameTime() )
                self:PerformLayout()
                SCOREBOARD:InvalidateLayout()
        end
       
        if not self.PlayerUpdate or self.PlayerUpdate < CurTime() then
                self.PlayerUpdate = CurTime() + 0.5
                self:UpdatePlayerData()
        end
end
 
/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
        self:SetSize( self:GetWide(), self.Size )
       
        self.btnAvatar:SetPos( 21, 4 )
        self.btnAvatar:SetSize( 16, 16 )
       
        self.imgAvatar:SetSize( 16, 16 )
       
        self.lblName:SizeToContents()
         self.lblTeam:SizeToContents()
        self.lblHours:SizeToContents()
        self.lblHealth:SizeToContents()
        self.lblFrags:SizeToContents()
        self.lblDeaths:SizeToContents()
        self.lblRatio:SizeToContents()
        self.lblPing:SizeToContents()
        self.lblPing:SetWide( 100 )
       
        self.lblName:SetPos( 60, 3 )
         self.lblTeam:SetPos( self:GetParent():GetWide() - 45 * 10.2 - 6, 3 )
        self.lblHours:SetPos( self:GetParent():GetWide() - 45 * 13, 3 )
        self.lblHealth:SetPos( self:GetParent():GetWide() - 45 * 5.4 - 6, 3 )
        self.lblFrags:SetPos( self:GetParent():GetWide() - 45 * 4.4 - 6, 3 )
        self.lblDeaths:SetPos( self:GetParent():GetWide() - 45 * 3.4 - 6, 3 )
        self.lblRatio:SetPos( self:GetParent():GetWide() - 45 * 2.4 - 6, 3 )
        self.lblPing:SetPos( self:GetParent():GetWide() - 45 - 6, 3 )
       
        if self.Open or self.Size ~= self.TargetSize then
                self.infoCard:SetVisible( true )
                self.infoCard:SetPos( 18, self.lblName:GetTall() + 27 )
                self.infoCard:SetSize( self:GetWide() - 36, self:GetTall() - self.lblName:GetTall() + 5 )
        else
                self.infoCard:SetVisible( false )
        end
end
 
/*---------------------------------------------------------
   Name: HigherOrLower
---------------------------------------------------------*/
function PANEL:HigherOrLower( row )
        if self.Player:Team() == TEAM_CONNECTING then return false end
        if row.Player:Team() == TEAM_CONNECTING then return true end
       
        if self.Player:Team() ~= row.Player:Team() then
                return self.Player:Team() < row.Player:Team()
        end
       
        if ( self.Player:Frags() == row.Player:Frags() ) then
       
                return self.Player:Deaths() < row.Player:Deaths()
       
        end
 
        return self.Player:Frags() > row.Player:Frags()
end
 
vgui.Register( "suiscoreplayerrow", PANEL, "DButton" )