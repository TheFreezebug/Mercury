local PANEL = {}

/*---------------------------------------------------------
   Name: 
---------------------------------------------------------*/
function PANEL:DoClick()
	local plr = self:GetParent().Player 
	if ( !plr || LocalPlayer() == plr || plr:GetImmunity() > LocalPlayer():GetImmunity() ) then surface.PlaySound("buttons/button2.wav") return end
	surface.PlaySound("buttons/button3.wav")
	self:DoCommand( self:GetParent().Player )
	// timer.Simple( 0.1, SuiScoreBoard.UpdateScoreboard())

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint( w,h )
	
	local bgColor = Color( 200,200,200,100 )

	if ( self.Selected ) then
		bgColor = Color( 135, 135, 135, 100 )
	elseif ( self.Armed ) then
		bgColor = Color( 175, 175, 175, 100 )
	end
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), bgColor )
	
	draw.SimpleText( self.Text, "DefaultSmall", self:GetWide() / 2, self:GetTall() / 2, Color(0,0,0,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	return true

end


vgui.Register( "suispawnmenuadminbutton", PANEL, "Button" )



/*   PlayerKickButton */

PANEL = {}
PANEL.Text = "Kick"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )

	LocalPlayer():ConCommand( [[hg kick "]].. ply:Name() .. [[" Kicked by administrator]] )
	
end

vgui.Register( "suiplayerkickbutton", PANEL, "suispawnmenuadminbutton" )



/*   PlayerPermBanButton */

PANEL = {}
PANEL.Text = "PermBan"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )

	LocalPlayer():ConCommand( [[hg ban "]] .. self:GetParent().Player:Nick().. [[" 0 Permanently Banned]]  )
	
	
end

vgui.Register( "suiplayerpermbanbutton", PANEL, "suispawnmenuadminbutton" )



/*   PlayerPermBanButton */

PANEL = {}
PANEL.Text = "1hr Ban"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )

	LocalPlayer():ConCommand( [[hg ban "]] .. self:GetParent().Player:Nick() .. [[" 60 One hour ban]] )
	
	
end

vgui.Register( "suiplayerbanbutton", PANEL, "suispawnmenuadminbutton" )


PANEL = {}
PANEL.Text = "COMMAND"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )

	LocalPlayer():ConCommand( string.format(self.Command,ply:Nick()) )
	
	
end

vgui.Register( "suicommandbutton", PANEL, "suispawnmenuadminbutton" )