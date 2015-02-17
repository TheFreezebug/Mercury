  local MenuTab = {}
  MenuTab.index = 5 //Internal identifier for table
  MenuTab.Name = "Configuration" // Display name 
  MenuTab.Desc = "Settings and Configuration" // Description 
  MenuTab.Icon = "icon16/cog.png" // Icon


function MenuTab:ShouldGenerateTab()

	return LocalPlayer():HasPrivilege("viewconfig")


end



 function GenerateMenu(CONTAINER)
 	function CONTAINER:Paint(w,h)
 		draw.RoundedBox( 8, 0, 0, w, h, Color( math.abs( math.sin(CurTime() *4 )) * 50 + 150 ,  150 , math.abs( math.cos(CurTime() )) * 50 + 150 ) )

 	end
 
 end


Mercury.Menu.AddMenuTab(MenuTab.index,MenuTab.Icon,MenuTab.Name,MenuTab.Desc,GenerateMenu,MenuTab.ShouldGenerateTab) 





