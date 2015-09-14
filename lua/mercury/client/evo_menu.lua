Mercury.EvoMenu = {}

local EVO = {}
	EVO.SelectedCommand = "nocommands"
	EVO.RepVars = {
		PLAYER = 0x01,
	}
	EVO.BaseFrame = nil
function EVO:Open()
	self.SelectedCommand = "nocommands"
	local v_BFrame = vgui.Create("DFrame")
	v_BFrame:SetSize(ScrW() * 0.20 ,ScrH())
	v_BFrame:ShowCloseButton(false)
	surface.PlaySound("mercury/mercury_emenu_open.wav")
	gui.EnableScreenClicker(true)
	function v_BFrame:Paint()
		// :(
	end
	self.BaseFrame = v_BFrame

	self:GenerateCommandBase()
end


function EVO:GenerateCommandBase()
	for k,v in pairs(Mercury.Commands.CommandTable) do
		if v.PlayerTarget then 
			 local  bal = vgui.Create("DButton",self.BaseFrame)
			 bal:SetSize(50,20)
			 bal:Dock(bit.bor(TOP))
			 bal:SetText(v.Command)
			 bal.selalpha = 0 
			 bal.OPaint = bal.Paint
			 function bal:Paint(w,h)
			 	surface.SetDrawColor(Color(255,255,255,255))
			 	surface.DrawRect(0,0,w,h)


			 	surface.SetDrawColor(Color(150,100,150,self.selalpha))
			 	surface.DrawRect(0,0,w,h)



			 	if self:IsHovered() then 
			 		self.selalpha = math.Clamp(self.selalpha + 10,0,200)
			 	else
			 		self.selalpha = math.Clamp(self.selalpha - 10,0,255)
			 	end



			 end

		end
	end


end


function EVO:Close()
	if self.BaseFrame then 
		self.BaseFrame:Remove()
	end
		surface.PlaySound("mercury/mercury_emenu_close.wav")
		gui.EnableScreenClicker(false)

end





concommand.Add("+mercury_evo",function ()
	Mercury.EvoMenu:Open()
end)


concommand.Add("-mercury_evo",function ()
	Mercury.EvoMenu:Close()
end)

Mercury.EvoMenu = EVO